from typing import ClassVar
import numpy as np
import neurokit2 as nk
import pywt
from PIL import Image
from fastapi import FastAPI
from fastapi.requests import Request
from fastapi.responses import Response
from pydantic import BaseModel, Field
import trio
from hypercorn.config import Config
from hypercorn.trio import serve

sample_rate = 512
before_rpeak = int(0.32*sample_rate)
after_rpeak = int(0.48*sample_rate)
output_size = (128, 128)
n_scales = 128
scales = np.arange(1, n_scales+1)
waveletname = 'gaus1'
n_choices = 9
rpeak_offset = 2

app = FastAPI()
port = 55001
config = Config()
config.bind = [f"0.0.0.0:{port}"]

print("Trying to run FastAPIs on a Hypercorn server:", port)

class Item(BaseModel):
    values: list[list[float]] = []

class ItemList(BaseModel):
    items: ClassVar = list[Item]

@app.post("/cwt", response_model = ItemList)
async def get_cwt_list(request: Request):
    async for chunk in request.stream():
        dtype = np.dtype(np.float32).newbyteorder('>')
        data = np.frombuffer(chunk, dtype=dtype)
        print(data)
        data_size = len(data)
        data = nk.ecg_clean(data, sampling_rate=sample_rate)
        processed_data, info = nk.ecg_process(data, sampling_rate=sample_rate)
        rpeaks = np.nonzero(np.array(processed_data['ECG_R_Peaks']))[0]
        n_rpeaks = len(rpeaks)
        item_list = ItemList()

        for i in range(min(n_rpeaks-2, n_choices)):
            segment = data[rpeaks[i+rpeak_offset]-before_rpeak:rpeaks[i+rpeak_offset]+after_rpeak+1]
            segment, _ = pywt.cwt(segment, scales, waveletname)
            segment = Image.fromarray(segment.astype(np.float32))
            item = Item()
            item.values = segment.resize(output_size).getdata()
            item_list.items.append(item)
        break
    print(item_list)
    return item_list

trio.run(serve, app, config)