FROM continuumio/miniconda3


WORKDIR /software
RUN wget https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz && \
	tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz

ENV PATH "$PATH:/usr/local/go/bin"

RUN conda config --add channels bioconda
RUN conda install --yes \
	'bokeh' \
	'matplotlib' \
	'numpy' \
	'jupyter' \
	'pandas' \
	'fastx_toolkit' 


RUN apt-get update &&\
	apt-get install -y \
	nano \
	htop \
	tree \
	curl


RUN go get github.com/sfletc/scram2 github.com/sfletc/scram2pkg github.com/spf13/cobra github.com/spf13/viper github.com/montanaflynn/stats
RUN cd /root/go/src/github.com/sfletc/scram2 && \
	go install

WORKDIR /scram2
RUN git clone https://github.com/sfletc/scram2_plot.git && \
	cd scram2_plot && \
	python setup.py install 

WORKDIR /scram2_plot
RUN	cd /scram2_plot && \
	cp /scram2/scram2_plot/scram2_plot/* ./

ENV PATH "$PATH:/root/go/bin"

WORKDIR /work

CMD jupyter notebook --port=8888 --no-browser --ip='*'