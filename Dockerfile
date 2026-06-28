FROM vastai/pytorch:cuda-13.2.1-auto
ENV HF_HUB_ENABLE_HF_TRANSFER=1 PYTHONUTF8=1 PYTHONIOENCODING=utf-8
# The base image ships GPU torch (>=2.12 / cu130, already supports Blackwell sm_120)
# inside the venv at /venv/main. Bare pip/python3 in a RUN step hit a SEPARATE
# system Python with no CUDA torch, so we must install Wan2GP's deps with the
# venv's own pip and NOT reinstall torch (that would downgrade/break the GPU build).
RUN git clone --depth 1 https://github.com/deepbeepmeep/Wan2GP /opt/Wan2GP \
 && /venv/main/bin/pip install --no-cache-dir -r /opt/Wan2GP/requirements.txt \
 && /venv/main/bin/pip install --no-cache-dir hf_transfer
# Fail the build loudly if the venv torch is missing or has no CUDA build baked in.
RUN /venv/main/bin/python -c "import torch; print('torch', torch.__version__, 'cuda_build', torch.version.cuda); assert torch.version.cuda is not None, 'venv torch has no CUDA build'"
WORKDIR /opt/Wan2GP
