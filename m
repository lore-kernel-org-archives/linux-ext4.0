From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the
	inode table
Date: Wed, 24 Sep 2008 10:20:34 -0400
Message-ID: <1222266034.7160.191.camel@think.oraclecorp.com>
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
	 <20080923101613.58768083@lxorguk.ukuu.org.uk>
	 <20080923115045.GI10950@webber.adilger.int> <48D8DEAE.4080309@redhat.com>
	 <20080924013014.GA9747@mit.edu>  <48DA3F56.8090806@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-83XhVpUNfzCV/6ISQLNt"
Cc: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:46801 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbYIXOV2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Sep 2008 10:21:28 -0400
In-Reply-To: <48DA3F56.8090806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-83XhVpUNfzCV/6ISQLNt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2008-09-24 at 09:23 -0400, Ric Wheeler wrote:
> Theodore Tso wrote:
> > On Tue, Sep 23, 2008 at 08:18:54AM -0400, Ric Wheeler wrote:

[ numbers ]

> > Given these numbers, I'm using a default of inode_readahead_bits of 5
> > (i.3., 32 blocks, or 128k for 4k blocksize filesystems).  For a
> > workload that is 100% stat-based, without any I/O, it is possible to
> > get better results by using a higher number, yes, but I'm concerned
> > that a larger readahead may end up interfering with other reads.  We
> > need to run some other workloads to be sure a larger number won't
> > cause problems before we go more aggressive on this parameter.
>
> That sounds about right for modern S-ATA/SAS drives. I would expect that 
> having this be a tunable knob might help for some types of storage (SSD 
> might not care, but should be faster in any case?).

For the test runs being done here, there's a pretty high chance that all
of the inodes you read ahead will get used before the pages are dropped,
so we want to find a balance between those and the worst case workloads
where inode reads are basically random.  One good data point is the
completion time for IOs of different sizes.

I used fio to measure the latencies on O_DIRECT randomreads of given
sizes on a fast 500GB sata drive.  Here is the output for a 4k run (I
used elevator=noop, but cfq was about the same):

f4k: (groupid=6, jobs=1): err= 0: pid=22877
  read : io=15816KiB, bw=539KiB/s, iops=131, runt= 30004msec
    clat (usec): min=555, max=20909, avg=7581.38, stdev=2475.88
     issued r/w: total=3954/0, short=0/0
     lat (usec): 750=0.03%
     lat (msec): 2=0.03%, 4=7.08%, 10=71.60%, 20=21.24%, 50=0.03%

clat is completion latency, but note fio switches between usec and msec
just to keep us on our toes.  Other important numbers are iop/s and
total issued ios.  The test limits the run on each IO size to 30
seconds.

The 4k run gets 131 iop/s, so my sata drive can read 131 inodes/second
in a worst case random workload.  iop rates for the others:

4k	131
8k	130
16k	128
32k	126
64k	121
128k	113
256k	100

A slightly trimmed job output is below, and the fio job file I used is
attached if anyone wants to try this on their own machines.  I'd stick
with either 32k or 64k as the sweet spots, but a tunable is definitely a
good idea.

-chris

f256k: (groupid=0, jobs=1): err= 0: pid=22871
  read : io=770816KiB, bw=26309KiB/s, iops=100, runt= 30001msec
    clat (msec): min=1, max=45, avg= 9.96, stdev= 2.63
     issued r/w: total=3011/0, short=0/0
     lat (msec): 2=0.03%, 10=50.35%, 20=49.58%, 50=0.03%

f128k: (groupid=1, jobs=1): err= 0: pid=22872
  read : io=434560KiB, bw=14830KiB/s, iops=113, runt= 30005msec
    clat (msec): min=1, max=72, avg= 8.83, stdev= 2.82
     issued r/w: total=3395/0, short=0/0
     lat (msec): 2=0.06%, 4=0.62%, 10=63.62%, 20=35.64%, 100=0.06%

f64k: (groupid=2, jobs=1): err= 0: pid=22873
  read : io=233280KiB, bw=7961KiB/s, iops=121, runt= 30006msec
    clat (usec): min=815, max=14931, avg=8225.21, stdev=2471.22
     issued r/w: total=3645/0, short=0/0
     lat (usec): 1000=0.05%
     lat (msec): 4=2.50%, 10=69.11%, 20=28.34%

f32k: (groupid=3, jobs=1): err= 0: pid=22874
  read : io=121472KiB, bw=4144KiB/s, iops=126, runt= 30010msec
    clat (usec): min=715, max=53124, avg=7898.75, stdev=2613.35
     issued r/w: total=3796/0, short=0/0
     lat (usec): 750=0.03%
     lat (msec): 4=4.77%, 10=70.10%, 20=25.08%, 100=0.03%

f16k: (groupid=4, jobs=1): err= 0: pid=22875
  read : io=61584KiB, bw=2101KiB/s, iops=128, runt= 30001msec
    clat (msec): min=1, max=16, avg= 7.79, stdev= 2.46
     issued r/w: total=3849/0, short=0/0


--=-83XhVpUNfzCV/6ISQLNt
Content-Disposition: attachment; filename=read-lat
Content-Type: text/plain; name=read-lat; charset=utf-8
Content-Transfer-Encoding: 7bit

[global]
filename=/dev/sdb
numjobs=1
size=16g
rw=randread
direct=1

[f256k]
bs=256k
runtime=30
stonewall

[f128k]
bs=128k
runtime=30
stonewall

[f64k]
bs=64k
runtime=30
stonewall

[f32k]
bs=32k
runtime=30
stonewall

[f16k]
bs=16k
runtime=30
stonewall

[f8k]
bs=8k
runtime=30
stonewall

[f4k]
bs=4k
runtime=30
stonewall

--=-83XhVpUNfzCV/6ISQLNt--

