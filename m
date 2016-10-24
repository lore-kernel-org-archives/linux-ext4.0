From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Test generic/299 stalling forever
Date: Sun, 23 Oct 2016 23:38:52 -0400
Message-ID: <20161024033852.quinlee4a24mb2e2@thunk.org>
References: <20161013231923.j2fidfbtzdp66x3t@thunk.org>
 <20161018180107.fscbfm66yidwhey4@thunk.org>
 <7856791a-0795-9183-6057-6ce8fd0e3d58@fb.com>
 <30fef8cd-67cc-da49-77d9-9d1a833f8a48@fb.com>
 <20161019203233.mbbmskpn5ekgl7og@thunk.org>
 <1fb60e7c-a558-80df-09da-d3c36863a461@fb.com>
 <20161021221551.sdv4hgw33zjxnkvu@thunk.org>
 <53fe5a98-6ff9-4fa1-e84c-8a3e16cc0f50@fb.com>
 <20161023193320.rlzlaxdi4vbyu7of@thunk.org>
 <20161023212408.cjqmnzw3547ujzil@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vsqmgnvvhmetvzh3"
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
        fstests@vger.kernel.org, tarasov@vasily.name
To: Jens Axboe <axboe@fb.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161023212408.cjqmnzw3547ujzil@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--vsqmgnvvhmetvzh3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I enabled some more debugging and it's become more clear what's going
on.   (See attached for the full log).

The main issue seems to be that once one of fio is done, it kills off
the other threads (actually, we're using processes):

process  31848 terminate group_id=0
process  31848 setting terminate on direct_aio/31846
process  31848 setting terminate on direct_aio/31848
process  31848 setting terminate on direct_aio/31849
process  31848 setting terminate on direct_aio/31851
process  31848 setting terminate on aio-dio-verifier/31852
process  31848 setting terminate on buffered-aio-verifier/31854
process  31851 pid=31851: runstate RUNNING -> FINISHING
process  31851 terminate group_id=0
process  31851 setting terminate on direct_aio/31846
process  31851 setting terminate on direct_aio/31848
process  31851 setting terminate on direct_aio/31849
process  31851 setting terminate on direct_aio/31851
process  31851 setting terminate on aio-dio-verifier/31852
process  31851 setting terminate on buffered-aio-verifier/31854
process  31852 pid=31852: runstate RUNNING -> FINISHING
process  31846 pid=31846: runstate RUNNING -> FINISHING
    ...

but one or more of the threads doesn't exit within 60 seconds:

fio: job 'direct_aio' (state=5) hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
process  31794 pid=31849: runstate RUNNING -> REAPED
fio: job 'buffered-aio-verifier' (state=5) hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
process  31794 pid=31854: runstate RUNNING -> REAPED
process  31794 terminate group_id=-1

The main thread then prints all of the statistics, and calls stat_exit():

stat_exit called by tid: 31794       <---- debugging message which prints gettid()

Unfortunately, this process(es) aren't actually, killed, they are
marked as reap, but they are still in the process listing:

root@xfstests:~# ps augxww | grep fio
root      1585  0.0  0.0      0     0 ?        S<   18:45   0:00 [dm_bufio_cache]
root      7191  0.0  0.0  12732  2200 pts/1    S+   23:05   0:00 grep fio
root     31849  1.5  0.2 407208 18876 ?        Ss   22:36   0:26 /root/xfstests/bin/fio /tmp/31503.fio
root     31854  1.2  0.1 398480 10240 ?        Ssl  22:36   0:22 /root/xfstests/bin/fio /tmp/31503.fio

And if you attach to them with a gdb, they are spinning trying to grab
the stat_mutex(), which they can't get because the main thread has
already called stat_exit() and then has exited.  So these two threads
did eventually return, but some time after 60 seconds had passed, and
then they hung waiting for stat_mutex(), which they will never get
because the main thread has already called stat_exit().

This probably also explains why you had trouble reproducing it.  It
requires a disk whose performance is variable enougoh that under heavy
load, it might take more than 60 seconds for the direct_aio or
buffered-aio-verifier thread to close itself out.

And I suspect once the main thread exited, it probably also closed out
the debugging channel so the deadlock detector did probably trip, but
somehow we just didn't see the output.

So I can imagine some possible fixes.  We could make the thread
timeout configurable, and/or increase it from 60 seconds to something like
300 seconds.  We could make stat_exit() a no-op --- after all, if the
main thread is exiting, there's no real point to down and then destroy
the stat_mutex.  And/or we could change the forced reap to send a kill
-9 to the thread, and instead of maring it as reaped.

Cheers,

						- Ted


--vsqmgnvvhmetvzh3
Content-Type: application/gzip
Content-Disposition: attachment; filename="299.full.gz"
Content-Transfer-Encoding: base64

H4sICBZ6DVgCAzI5OS5mdWxsAO2d/W/bRpqAf9dfMcCiaHqwJc7w21gV6G7SXSN3aZFk76sI
DFmibDay6COpODncH3/vkJREKlRsK2nibJ4CTajRM/MMyXnfmSHdep5m6vg4zZLlRbpMxov0
fFKVnBdjbaLXcjRL82RaZvm78ehtefxmNpWyebpIivR/k7HvBlHoxNo4UlqVxHH8t6rFWXJd
XtpG/kXL52m2LNPlKjnLlmdJnmf5+CZPy8SSF8ssT5rCoyfPfnnx61+luPp8NltdXY9t29M8
mZRV7ew6WY5tk/PJYpFNpXS8zJa2peRtWkpZ9eVycpWM666f1WdUf6i+PF/N50mezKqWl6ur
3zM5XU+O85txPlnO1l3LV9JpaUc7TnUS9sPZ+aRIZmuDNC0NZ8dvkjydp0neas9WqIrfjaf5
1DXT43RZJotN6dl8Ir1tYfXJtj6fT6avF9mF6I23LZ0U75bT8bagyPL6rNonKKfzens++U1z
z/b22Zavr8rx5GGdkNO+Y7eeXf9ZDP60/WfwJ2XiWJVJUaq5DI3JtEzfpOU7Kf+5aaVQM6n5
Ru7zPM+ulD19W6zEZj+kM7VIXydqnskIvClOpOZwOPjtYpGdTxavBjvRNGhiafBeJA164miw
iaJBJ4YGeyJo0Bc/g3b0DHZjZ9CNnMEmbgZymdSvST7P8itV91bJCRypMlNVV9XNZTq9VFeT
d+o8UaXEh21lZqudv1PJ2zLJl5OFKifF68Fv2+h7NViPzcE29AabwBu0w27QCbrBNuSkcz19
q25JPW7UTMafQC8v06K+u1Opp4rLbLWYqellMn2tVkVyPJlLN4/neZKotChWSTH4bTckXm06
pwc9Q37QHfCDznAf9Az2QXeoD9oDvXVt7LgebEb1YG/Eti/F+oJ+uovRG0Ff4oo429HygYvT
210581GeZeXo7bywZ1+MztPlyEb7qLy6Hrnad9yhfNyGwol6lqniejJN1CKZlypbSg54k04T
kD3INr5P1KOLsfPDiWoH8pGq897TY/vHqOfoSO1kSluwSXmDoeTU3ZG/a8pvKo339Nh7Omr9
eUvTvWPmE7Uto+rYDLV37DnHF4mJ9dROZDK9FOWkPEuXqQ3FxUIiVlJmmc5OlKvD2Bu8KCe5
JPgLFajrPJsmRSHB2BypmlHXqSRO6eBqaRtL1LNfXp799fmTn14+eayOf1Qvnrx8efrsb2f/
+PW2ilvS1ms1gxHjgcbPlnjud2p7LshNuljIAi5/3f4i8oJqsVe1WX8sbFjK6mOH2gAtcUt6
+uz05elP/3r63/e+E/frbtTtbtTf3WgLfNnuxt3uxv3djbfAF+2urzvdlY993ZXiDfBlu2u6
3TX93TVb4Mt21+t21+vvrrcFbu/uQ1oe9Vy63YTR6ro9k+f/ePZMUuu+mtHBNeNDa3ZG9P1q
moNrevequW+ENKit9e9Pnp/+/F93rLeB8eHDhw8fPnz48OHDhw8fPnz48OHDhw8fPnz48OH7
Vn0P9L3rvpfdt597f73brzU+fN+47w8M0U/T9B+YwRhL+PDhw4fv4c0yn83OWML3dft4JvB1
+xgv+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw8f7Yt4X48OHDx8+fPjw4cOHDx8+
fPjw8fyF+4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cP
Hz58+PDhw4cPHz58/D4ixgs+fPjw4cOHD98/z/rz27wujBd8+PB9Vt8f+Iu1+ZXK+L6eXx9P
IODDh+9hJ7JDu/SQciRjCR8+fPjw4WMf/rX5WAX9M10CAg8fPnz4WEtxyVm4cAl4zocPHz58
+Fi78fMMjF18+PDhY676CvbhzI34yAXc4ge6LufJJT58+EicX+PcSBbm/RGLmm8A4b8zxYcP
Hz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cP
Hz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cP
Hz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cP
Hz58+PDhw4cPHz58+PDhw4cPH74v4DObeuZevv56XE98+PDhw4cPHz58+Ng/sH/Ahw8fPnzM
f8x/+O7rO3SccR/w4cOHDx8+fPjw4cOHDx8+fPjw4cOHDx8+fPjw4cP3bb6357rgw4cPHz58
+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58+PDhw4cPHz58
+PDhw4cPHz58+PDhw4fvo3zzyWKRTeXrE/UsU8X1ZJqoRTIvVbZUs+RNOk0+H/JFf1cKPnz4
PqvvAaYEch0+fPjw4cP3dc79n6Zp7gprG3z48OHDhw8fvm/nORg+fPj6fV60rudF/b6fT5+d
vvh7T70yya/SpaUv8mx1fSbNOLtMkZRlurxosTYNpHkyLc8maTayVHBIpeiQSvEBlXx9p0pC
H8/k3zdJns7TJK+qmjtVPV/N50mezI4nu/W97i3Wm1us73OrpN6tt0qY+9+qO1aKDqkUH1Bp
51btq3SHW7Wv6p1v1a1RvCeqgk00Bvesd3s0BodEY3BINAaHRGNwSDQGh0dj8HG3eE/i3Nwf
e7Oe/OfpyyeP7xLEt1QLY6/XVpNVbn/y069763RUH6pjB+7tucIckivMIbnCHJIrzCG5whye
K8xHDqT+mL/HiAjucXf70tLdVZ1q76nmaXaifs/O1ffba/29elTRY/8HdTkplt+XKnmblslM
pUsVOHLpptlyVhyptFST6+tkkheqzNR5oopyNX09VI8ze2XnWT5N5qtFVVllc1VepoV1Dfdd
lLg/f77X1d7b9KV6ve9Ho/qjuydSj/UudO9QvWul6JBK8QGV/Lud0+2hurfqHUN1X8zVd2fv
7LyvWifsPpi/u0vzu9uiw2zxYbb4IFt3LXtn2/7Z88M2c5jNHGbzDrN5t9gG2wA5UY+q4Lez
9JFNLcVY/3Cikjwfm0g9ksPW0HuxWqpfpqUyrjLmxI1OfF8ZRwcDpW7y1D6ySbOx9gN/GPzb
X47U+Y18iMPw6V9GNtVl18U4jM2R7Vs51o7jut6VZEKprVSxmJTq0Uo+ilIia6zjI3U1eTv2
Atf4/pGavLkYa+ProR8eSZacJW/GWnuuN4x01cC0auBq24Bf13dDz61rR44/9Lx15cCEQ8lB
tqrarbp2S92wqavNMDKbuq4zdLyt9jqRPL0s00VSrNupG/4/pfTQccrL8W/yKQhfHSnlbwp0
VaCdTYHRvhSYVkEUvzpaN+Vuy93AFdDbFniBgMrfFvhRIAXBtiD0o21T4aZcO9oIGG0LXMe2
HW8Lgtg2FW/6beS6b5uK40155NruS4FfF0hLpi6ImwLfnk9V4LcKWk3FcV0eGufVoHtr1Il0
dizd0t/Za7Q+8u2Rdr6zF9IeGmO/llI9jLzv3m/DF8obBr5QoVBmGOi6rq3h+1Xbcuza2kfq
x3H1yZEO27am1yu1+edErYpcvgpCAYt3Ejh6GNiOTMu3Mrxl6NtR9PvcBpaMqrmUSROnv6hZ
cl1eFnUT2vbeSpu/vebvqPlbB82BuyZ+HAfe2F6q+uRUsTq/ktVB1Vp1VapW5ISqo6gpqdpx
1u3Yg8BrDqoG7WHd3jS7ul4kkjk+sj3dtJcWxUoWPlX/yqycLMZy0UY3kgq8KBxVaae4zPKy
KXbqolmeXbdL6rYkLWV50W4rkNEp8T1P86I8q76WvDX6855Hxz9u4j1ZTt/VzUzyi6S0ypt0
Octu7NE2nuvztmdV3TTJQNFByTO6Y/IMdSRD/2mdPEMdRMN29tS+bqVP48e3p884coJQ10ks
8D1JW5vs6ZhImvf6s2fQZF/HBOvcG0nYtGvLyA/686cbvl/bjli3VdsfRs59M6j2dDeD1gmz
nUG9uJtBXdfpzaBe4HczaKB1N4PGoe5kUO35Tm8GDWO/k0GNjpxOBjVx0M2grmuCvgzqhr7p
ZlBZp3QzaOx1M6jn2Evwfgatyj+UQf3NUZ0367Ralbph9b09jNyeFBpWlOet86YkXb3Om5Ip
O3kzivfkTT3U8TpvmmEYN3kziONgJ21Gnyxr1kns606bkgOCMPjovKm9wAn0w0+c8QcT53tz
+94xbZxmTMu4C5q537Fzf1+MOJvxbep1gRd11gLu3rVAdcZ2TDeHdkg7O+P5m1oFOLcNZyfw
vPjjh7Ojdfzwh7Pddd5pHRAETugGzTog8GUu8VrrgCBsrwKi/asAY+qJOIjDWFpo5mIvMpHM
vpvJOHJMGA7doH8l4DUrCe24dvdkWzAy5w2Nv27AyHZkaOL+tYDvNNWN64Tr6rHde22rh91d
3B23U9HuYiDc2U55jtNdDPhO0LsY8ENndzGws50KjX+nxYCrdxYDXlBtxLaLAd/1TGcxEPhG
9ywGqg1EezHQKoibAhM77cVAU/DeYqAu35cu3SZdmqGONlsnz1+nS6c+rvZKfjOd9yVMf2ii
dcKU+dzfJkwZbH68P2Nudk9DHW42T46/kzTjA5OmWScnv5U09Ve+BghC9+N3TtoP/c+bMHef
sN49bZoPps08mcxU/exJO94wXD970ib0W1nTRHZTtHn4ZPT+vOnVOcv4fhStN0+S4rYpy9iQ
bz94alWOnaa61q7dv62TnuSGodbrJkL75GWo/VbWbLdhwU0b8baNyAz9aNuG8V0J2z2pc7Un
dWr7dKWdOnVUPeLZpk4js3IndbpOFPWlTtd4USd1um71PMlvFYTdJ1GuF5re1BlU6bqVOl3T
2UfJydtObFOnTGRe5PTkTlcuXxC1k6cXePU5brJnIHvp6iQ36TN0osCJevJn7HuuNNedoOUs
ovX8LEvp2G0NtDC460DTbn2bJdUap3lOaWRyDYL1PfbCKBxGYf/cHK4HiRPXdV0TDsPN+NBh
IKew5xmnuxlg67quliuxrStrhOjek3I1T7YmZZk4upOyBGV3Utb9I0uifGeHLtHYnZRNHHaf
cbpu7zNO2TUHnZHV7P7j9gqgM7JkBRBEfTt0FRmvs0NXkRd1dujNA9XtDl07ode3Q5ebFrQm
5VV39+GYnonWjL2hNtWk4vr1HKvto8q43qrIvOu666297/TP1HZPvt4WyTxtmnneDL14sy3y
w+3W3umb8ZuNkKP3bu7DqJnW5U5H0Xpe94Mo2pnYTeSzv2/mdiMLc9nb30gKCMPY+egp3gRa
MtrnneR734V+YKZXzkn7vdXtm/1V5ymUo1tDNeyNGV0vbCVmZK6sH1qNvagelRI02t1ETfX9
vqipFqpmK908DtD6gTwO+BqG/4eeB8hqJvLtoI5lro4+evQ73YHvjP78YjW1r0s/yTgfPJeR
al+xror6xyeUox5NFotqdNdz4/MnPz3eWZZOLi7y8/bKVIZA9/Pk7e737VVEBewsK/7j+enL
J5VHJkR/GG89ruOGuuUJvI5l+252bWkeJrQszSvaweO0eF2drsz+dr09qpZCzRpgdnWsbQeK
sSyYnZGRDb59vHCVyEWV6y6HZTp9XYyDWPtROJJFq++EgRSny7P/WSWrRDKV40WRfVawkgtu
92jVazl7GnWzYTTSkfbs+w9bWDdtRrLSc5uiRiHLJeON7Grb0bHTNLHRSCqR9ahXF7dUchrF
bLo+h5ZsR7RH0iNoN26v21n1MzxTGSEy7M/fSUuzk/q1ff3DRHMZZ/ZnhS7VMitVcnVdvrOZ
2dZ6UP9fIhAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
EBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQ
kG8O+X+JSoeBI5cDAA==

--vsqmgnvvhmetvzh3--
