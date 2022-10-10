import numpy as np
import matplotlib.pyplot as plt
import cv2
import random
import os
import pdb
import fire

start_idx=1

our_res = np.array(list(range(600, 5401, 400))[start_idx:]) / 1000.
ours_mem = np.array([709, 935, 1249, 1753, 2299, 2941, 3697, 4629, 5611, 6681, 7845, 9329, 10715][start_idx:])

SCN_res = np.array(list(range(600, 3401, 400))[start_idx:]) / 1000.
SCN_mem = np.array([981, 1691, 2647, 3839, 4579, 6192, 8231, 10159][start_idx:])

our_color_shapes= ['k-^', 'r-*', 'g-p', 'r-o', 'r-+','c-s', 'g-x', 'm-d', 'y-o', 'r-D', 'g-d']
SCN_color_shapes = ['k-^', 'r-o', 'g-p', 'r-o', 'r-+','c-s', 'g-x', 'm-d', 'y-o', 'b-D', 'g-x']

def read_time(method):
    lines = open(f'time/{method}.txt').readlines()
    time = [float(item.strip().split(':')[-1]) * 80 for item in lines]

    return time[start_idx:]

def main(style=14):
    styles = plt.style.available
    font = {'family':'sans serif', 'weight':'normal', 'size':12}
    plt.style.use(styles[style])
    #plt.style.use('fivethirtyeight')

    ours_time = read_time('PCNet')
    SCN_time = read_time('SCN')

    #fig = plt.figure()
    fig, ax1 = plt.subplots()
    ax2 = ax1.twinx()
    our_time,=ax1.plot(our_res, np.log(ours_time), our_color_shapes[1], label=r'$PCNet_t$')
    scan_time,=ax1.plot(SCN_res, np.log(SCN_time), SCN_color_shapes[1], label=r'$PCNet_t$')
    
    our_mem,=ax2.plot(our_res, ours_mem, our_color_shapes[-1], label='$PCNet_m$')
    scan_mem,=ax2.plot(SCN_res, SCN_mem, SCN_color_shapes[-1], label='$PCNet_m$')

    ax1.set_xlabel('Resolution(K)')
    ax1.set_ylabel('Time (log. sec)')
    ax2.set_ylabel('Memory(M)')
    plt.grid()
    plt.legend(handles=[our_time, our_mem, scan_time, scan_mem], loc='best')

    #ax1.set_facecolor([245/255.,245/255.,245/255.])
    plt.xlim(0.9, 5.5)
    plt.xticks(our_res)
    plt.savefig(f'mem_time_comp.pdf', bbox_inches='tight')
    #plt.show()

fire.Fire(main)

