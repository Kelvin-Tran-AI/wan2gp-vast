FROM vastai/pytorch:cuda-13.2.1-auto
ENV HF_HUB_ENABLE_HF_TRANSFER=1 PYTHONUTF8=1 PYTHONIOENCODING=utf-8
# Blackwell (sm_120) needs cu128 torch; bake it + Wan2GP + deps so instances start ready.
RUN pip install --no-cache-dir torch==2.7.1 torchvision --index-url https://download.pytorch.org/whl/cu128
RUN git clone --depth 1 https://github.com/deepbeepmeep/Wan2GP /opt/Wan2GP \n && cd /opt/Wan2GP \n && pip install --no-cache-dir -r requirements.txt \n && pip install --no-cache-dir hf_transfer
WORKDIR /opt/Wan2GP
