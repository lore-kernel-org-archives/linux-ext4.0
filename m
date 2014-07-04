From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Fri, 4 Jul 2014 13:28:02 +0200
Message-ID: <20140704132802.0d43b1fc@archvile>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
	<20140701082619.1ac77f1d@archvile>
	<20140701084206.GG9743@birch.djwong.org>
	<CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
	<20140703134338.GE2374@thunk.org>
	<20140703161551.5fd13245@archvile>
	<87tx6yzdxz.fsf@openvz.org>
	<20140704114031.2915161a@archvile>
	<87r421zavi.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:9246 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaGDL1z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 07:27:55 -0400
In-Reply-To: <87r421zavi.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 04 Jul 2014 14:17:21 +0400
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> On Fri, 4 Jul 2014 11:40:31 +0200, David Jander <david@protonic.nl> wrote:
> > 
> > Hi Dmitry,
> > 
> > On Thu, 03 Jul 2014 18:58:48 +0400
> > Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> > 
> > > On Thu, 3 Jul 2014 16:15:51 +0200, David Jander <david@protonic.nl> wrote:
> > > > 
> > > > Hi Ted,
> > > > 
> > > > On Thu, 3 Jul 2014 09:43:38 -0400
> > > > "Theodore Ts'o" <tytso@mit.edu> wrote:
> > > > 
> > > > > On Tue, Jul 01, 2014 at 10:55:11AM +0200, Matteo Croce wrote:
> > > > > > 2014-07-01 10:42 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
> > > > > > 
> > > > > > I have a Samsung SSD 840 PRO
> > > > > 
> > > > > Matteo,
> > > > > 
> > > > > For you, you said you were seeing these problems on 3.15.  Was it
> > > > > *not* happening for you when you used an older kernel?  If so, that
> > > > > would help us try to provide the basis of trying to do a bisection
> > > > > search.
> > > > 
> > > > I also tested with 3.15, and there too I see the same problem.
> > > > 
> > > > > Using the kvm-xfstests infrastructure, I've been trying to reproduce
> > > > > the problem as follows:
> > > > > 
> > > > > ./kvm-xfstests  --no-log -c 4k generic/075 ; e2fsck -p /dev/heap/test-4k ; e2fsck -f /dev/heap/test-4k 
> > > > > 
> > > > > xfstests geneeric/075 runs fsx which does a fair amount of block
> > > > > allocation deallocations, and then after the test finishes, it first
> > > > > replays the journal (e2fsck -p) and then forces a fsck run on the
> > > > > test disk that I use for the run.
> > > > > 
> > > > > After I launch this, in a separate window, I do this:
> > > > > 
> > > > > 	sleep 60  ; killall qemu-system-x86_64 
> > > > > 
> > > > > This kills the qemu process midway through the fsx test, and then I
> > > > > see if I can find a problem.  I haven't had a chance to automate this
> > > > > yet, and it is my intention to try to set this up where I can run this
> > > > > on a ramdisk or a SSD, so I can more closely approximate what people
> > > > > are reporting on flash-based media.
> > > > > 
> > > > > So far, I haven't been able to reproduce the problem.  If after doing
> > > > > a large number of times, it can't be reproduced (especially if it
> > > > > can't be reproduced on an SSD), then it would lead us to believe that
> > > > > one of two things is the cause.  (a) The CACHE FLUSH command isn't
> > > > > properly getting sent to the device in some cases, or (b) there really
> > > > > is a hardware problem with the flash device in question.
> > > > 
> > > > Could (a) be caused by a bug in the mmc subsystem or in the MMC peripheral
> > > > driver? Can you explain why I don't see any problems with EXT3?
> > > > 
> > > > I can't discard the possibility of (b) because I cannot prove it, but I will
> > > > try to see if I can do the same test on a SSD which I happen to have on that
> > > > platform. That should be able to rule out problems with the eMMC chip and
> > > > -driver, right?
> > > > 
> > > > Do you know a way to investigate (a) (CACHE FLUSH not being sent correctly)?
> > > > 
> > > > I left the system running (it started from a dirty EXT4 partition), and I am
> > > > seen the following error pop up after a few minutes. The system is not doing
> > > > much (some syslog activity maybe, but not much more):
> > > > 
> > > > [  303.072983] EXT4-fs (mmcblk1p2): error count: 4
> > > > [  303.077558] EXT4-fs (mmcblk1p2): initial error at 1404216838: ext4_mb_generate_buddy:756
> > > > [  303.085690] EXT4-fs (mmcblk1p2): last error at 1404388969: ext4_mb_generate_buddy:757
> > > > 
> > > > What does that mean?
> > > This means that it found previous error in internal ext4's log. Which is
> > > normal because your fs was corrupted before. It is reasonable to
> > > recreate filesystem from very beginning.
> > > 
> > > In order to understand whenever it is regression in eMMC driver it is
> > > reasonable to run integrity test for a device itself. You can run
> > > any integrity test you like, For example just run a fio's job
> > >  "fio disk-verify2.fio" (see attachment), IMPORTANT this script will
> > >  destroy data on test partition. If it failed with errors like
> > >  follows "verify: bad magic header XXX" than it is definitely a drivers issue.
> > 
> > I have been trying to run fio on my board with your configuration file, but I
> > am having problems, and since I am not familiar with fio at all, I can't
> > really figure out what's wrong. My eMMC device is only 916MiB in size, so I
> > edited the last part to be:
> > 
> > offset_increment=100M
> > size=100M
> > 
> > Is that ok?
> > 
> > I still get error messages complaining about blocksize though. Here is the
> > output I get (can't really make sense of it):
> > 
> > # ./fio ../disk-verify2.fio 
> > Multiple writers may overwrite blocks that belong to other jobs. This can cause verification failures.
> > /dev/mmcblk1p2: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> > ...
> > fio-2.1.10-49-gf302
> > Starting 4 processes
> > fio: blocksize too large for data set
> > fio: blocksize too large for data set
> > fio: blocksize too large for data set
> > fio: io_u.c:1315: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' failed.ta 00m:00s]
> > fio: pid=7612, got signal=6
> > 
> > /dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=7612: Fri Jul  4 09:31:15 2014
> >     lat (msec) : 4=0.19%, 10=0.19%, 20=0.19%, 50=0.85%, 100=1.23%
> >     lat (msec) : 250=56.01%, 500=37.18%, 750=1.14%
> >   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
> >   IO depths    : 1=0.1%, 2=0.2%, 4=0.4%, 8=0.8%, 16=1.5%, 32=97.1%, >=64=0.0%
> >      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
> >      issued    : total=r=33/w=1024/d=0, short=r=0/w=0/d=0
> >      latency   : target=0, window=0, percentile=100.00%, depth=32
> > 
> > Run status group 0 (all jobs):
> > 
> > Disk stats (read/write):
> >   mmcblk1: ios=11/1025, merge=0/0, ticks=94/6671, in_queue=7121, util=96.12%
> > fio: file hash not empty on exit
> > 
> > 
> > This assertion bugs me. Is it due to the previous errors ("blocksize too large
> > for data set") or is is because my eMMC drive/kernel is seriously screwed?
> > 
> > Help please!
> Ohhh. Actually this is axboe's crap. Recent fio's version is broken.
> Please use old good commit ffa93ca9d8d37ef
> git checkout git://git.kernel.dk/fio.git
> cd fio
> git checkout -b b2.0.13 ffa93ca9d8d37ef
> make -j4
> ./fio ffa93ca9d8d37ef

Ok, that fixed it... :-)

Here is the output I am getting... AFAICS no problems on the raw device. Is
this sufficient testing, Ted?

# ./fio ../disk-verify2.fio                  
Multiple writers may overwrite blocks that belong to other jobs. This can cause verification failures.
/dev/mmcblk1p2: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
...
/dev/mmcblk1p2: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio-2.0.13
Starting 4 processes
Jobs: 4 (f=4): [wVww] [100.0% done] [339K/523K/0K /s] [84 /130 /0  iops] [eta 00m:00s] 
/dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=1157: Fri Jul  4 11:22:53 2014
  write: io=448828KB, bw=127664 B/s, iops=31 , runt=3600049msec
    slat (msec): min=1 , max=1821 , avg=30.33, stdev=66.98
    clat (usec): min=52 , max=5463.3K, avg=910506.27, stdev=554911.89
     lat (msec): min=5 , max=5531 , avg=940.84, stdev=567.60
    clat percentiles (msec):
     |  1.00th=[  159],  5.00th=[  253], 10.00th=[  351], 20.00th=[  465],
     | 30.00th=[  578], 40.00th=[  685], 50.00th=[  791], 60.00th=[  914],
     | 70.00th=[ 1074], 80.00th=[ 1270], 90.00th=[ 1614], 95.00th=[ 1958],
     | 99.00th=[ 2802], 99.50th=[ 3163], 99.90th=[ 4228], 99.95th=[ 4555],
     | 99.99th=[ 5211]
    bw (KB/s)  : min=    3, max=  944, per=37.55%, avg=139.69, stdev=93.70
    lat (usec) : 100=0.01%
    lat (msec) : 2=0.01%, 4=0.61%, 10=4.33%, 20=5.93%, 50=16.04%
    lat (msec) : 100=18.92%, 250=4.74%, 500=9.38%, 750=12.09%, 1000=9.87%
    lat (msec) : 2000=15.58%, >=2000=2.51%
  cpu          : usr=0.38%, sys=0.59%, ctx=332741, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=111616/d=0, short=r=112207/w=0/d=0
/dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=1158: Fri Jul  4 11:22:53 2014
  read : io=352016KB, bw=946262 B/s, iops=231 , runt=380935msec
    slat (msec): min=2 , max=12334 , avg=261.58, stdev=527.14
    clat (msec): min=18 , max=6145 , avg=59.95, stdev=221.07
     lat (msec): min=21 , max=12360 , avg=321.53, stdev=570.56
    clat percentiles (msec):
     |  1.00th=[   22],  5.00th=[   23], 10.00th=[   23], 20.00th=[   25],
     | 30.00th=[   25], 40.00th=[   26], 50.00th=[   27], 60.00th=[   28],
     | 70.00th=[   29], 80.00th=[   34], 90.00th=[   43], 95.00th=[  198],
     | 99.00th=[  865], 99.50th=[ 1500], 99.90th=[ 3687], 99.95th=[ 3916],
     | 99.99th=[ 6128]
  write: io=352072KB, bw=111995 B/s, iops=27 , runt=3219084msec
    slat (msec): min=1 , max=12214 , avg=36.47, stdev=175.23
    clat (usec): min=20 , max=12325K, avg=224666.84, stdev=487725.70
     lat (msec): min=2 , max=12333 , avg=261.14, stdev=527.05
    clat percentiles (usec):
     |  1.00th=[   25],  5.00th=[   28], 10.00th=[ 8032], 20.00th=[21376],
     | 30.00th=[38144], 40.00th=[57088], 50.00th=[84480], 60.00th=[132096],
     | 70.00th=[224256], 80.00th=[288768], 90.00th=[477184], 95.00th=[782336],
     | 99.00th=[2072576], 99.50th=[2932736], 99.90th=[5865472], 99.95th=[7503872],
     | 99.99th=[12255232]
    bw (KB/s)  : min=    0, max=    8, per=1.13%, avg= 4.20, stdev= 2.05
    lat (usec) : 50=3.49%, 100=0.08%
    lat (msec) : 4=0.20%, 10=2.37%, 20=3.64%, 50=54.33%, 100=9.55%
    lat (msec) : 250=12.29%, 500=8.59%, 750=2.25%, 1000=1.04%, 2000=1.49%
    lat (msec) : >=2000=0.69%
  cpu          : usr=0.28%, sys=0.38%, ctx=199155, majf=0, minf=0
  IO depths    : 1=7.1%, 2=14.3%, 4=28.6%, 8=50.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=0.0%, 8=0.0%, 16=100.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=88004/d=0, short=r=88018/w=0/d=0
/dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=1159: Fri Jul  4 11:22:53 2014
  read : io=270648KB, bw=164244 B/s, iops=40 , runt=1687389msec
    slat (msec): min=1 , max=2338 , avg=28.22, stdev=72.10
    clat (msec): min=1 , max=2747 , avg=24.77, stdev=68.06
     lat (msec): min=3 , max=2753 , avg=52.99, stdev=105.59
    clat percentiles (msec):
     |  1.00th=[    3],  5.00th=[    3], 10.00th=[    4], 20.00th=[    6],
     | 30.00th=[    6], 40.00th=[    7], 50.00th=[    7], 60.00th=[    8],
     | 70.00th=[    9], 80.00th=[   10], 90.00th=[   35], 95.00th=[  178],
     | 99.00th=[  269], 99.50th=[  367], 99.90th=[  734], 99.95th=[  914],
     | 99.99th=[ 1942]
  write: io=270648KB, bw=144929 B/s, iops=35 , runt=1912261msec
    slat (msec): min=1 , max=2338 , avg=28.04, stdev=72.08
    clat (usec): min=20 , max=4560 , avg=27.39, stdev=40.17
     lat (msec): min=1 , max=2338 , avg=28.07, stdev=72.08
    clat percentiles (usec):
     |  1.00th=[   22],  5.00th=[   23], 10.00th=[   23], 20.00th=[   24],
     | 30.00th=[   24], 40.00th=[   25], 50.00th=[   25], 60.00th=[   26],
     | 70.00th=[   26], 80.00th=[   27], 90.00th=[   30], 95.00th=[   41],
     | 99.00th=[   54], 99.50th=[   65], 99.90th=[   81], 99.95th=[   98],
     | 99.99th=[ 2160]
    bw (KB/s)  : min=    1, max=    8, per=1.40%, avg= 5.22, stdev= 1.68
    lat (usec) : 50=49.15%, 100=0.83%, 250=0.01%, 500=0.01%
    lat (msec) : 2=0.31%, 4=7.00%, 10=33.14%, 20=2.84%, 50=2.10%
    lat (msec) : 100=0.89%, 250=2.99%, 500=0.61%, 750=0.09%, 1000=0.03%
    lat (msec) : 2000=0.02%, >=2000=0.01%
  cpu          : usr=0.34%, sys=0.58%, ctx=179182, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=67662/d=0, short=r=67662/w=0/d=0
/dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=1160: Fri Jul  4 11:22:53 2014
  read : io=269304KB, bw=161896 B/s, iops=39 , runt=1703357msec
    slat (msec): min=1 , max=2787 , avg=28.12, stdev=69.99
    clat (msec): min=1 , max=2876 , avg=25.13, stdev=70.53
     lat (msec): min=3 , max=3065 , avg=53.26, stdev=105.59
    clat percentiles (msec):
     |  1.00th=[    3],  5.00th=[    3], 10.00th=[    4], 20.00th=[    6],
     | 30.00th=[    6], 40.00th=[    7], 50.00th=[    7], 60.00th=[    8],
     | 70.00th=[    9], 80.00th=[   10], 90.00th=[   36], 95.00th=[  178],
     | 99.00th=[  269], 99.50th=[  375], 99.90th=[  742], 99.95th=[ 1012],
     | 99.99th=[ 1844]
  write: io=269304KB, bw=145424 B/s, iops=35 , runt=1896288msec
    slat (msec): min=1 , max=2787 , avg=27.94, stdev=69.97
    clat (usec): min=20 , max=4580 , avg=27.51, stdev=44.68
     lat (msec): min=1 , max=2787 , avg=27.98, stdev=69.97
    clat percentiles (usec):
     |  1.00th=[   22],  5.00th=[   23], 10.00th=[   23], 20.00th=[   24],
     | 30.00th=[   24], 40.00th=[   25], 50.00th=[   25], 60.00th=[   25],
     | 70.00th=[   26], 80.00th=[   27], 90.00th=[   30], 95.00th=[   40],
     | 99.00th=[   54], 99.50th=[   65], 99.90th=[   82], 99.95th=[  105],
     | 99.99th=[ 2160]
    bw (KB/s)  : min=    1, max=    8, per=1.42%, avg= 5.30, stdev= 1.56
    lat (usec) : 50=49.18%, 100=0.79%, 250=0.01%, 500=0.01%
    lat (msec) : 2=0.45%, 4=6.66%, 10=33.29%, 20=2.93%, 50=2.03%
    lat (msec) : 100=0.86%, 250=3.03%, 500=0.63%, 750=0.09%, 1000=0.02%
    lat (msec) : 2000=0.02%, >=2000=0.01%
  cpu          : usr=0.35%, sys=0.58%, ctx=179806, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=67326/d=0, short=r=67326/w=0/d=0

Run status group 0 (all jobs):
   READ: io=891968KB, aggrb=523KB/s, minb=158KB/s, maxb=924KB/s, mint=380935msec, maxt=1703357msec
  WRITE: io=1309.5MB, aggrb=372KB/s, minb=109KB/s, maxb=142KB/s, mint=1896288msec, maxt=3600049msec

Disk stats (read/write):
  mmcblk1: ios=514970/335209, merge=2162/0, ticks=17103230/10385442, in_queue=27486452, util=100.00%


Best regards,

-- 
David Jander
Protonic Holland.
