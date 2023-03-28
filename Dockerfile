FROM ubuntu:22.04

WORKDIR /app

RUN apt-get update && rm -rf /var/lib/apt/lists/*

# Libreoffce
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:libreoffice/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends libreoffice && \
    apt-get remove -y --auto-remove software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Some additional MS fonts for better WMF conversion
COPY fonts/* /usr/share/fonts/
RUN fc-cache -f -v

COPY get-pip.py .
RUN python3 get-pip.py
RUN python3 -m pip install --no-cache-dir flask
COPY app.py .
EXPOSE 5000

RUN mkdir uploads

RUN apt-get install -y 

# Install Macros
COPY demo.odt .
RUN libreoffice --headless --convert-to pdf demo.odt # Init basic files
COPY basic /root/.config/libreoffice/4/user/basic

CMD ["flask", "run", "-h", "0.0.0.0"]
