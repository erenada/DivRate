#!/bin/sh

contigTotal= $(cat pi_contigList | wc -l)
counter=c


while read -r line
