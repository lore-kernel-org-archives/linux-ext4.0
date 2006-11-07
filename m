From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Fw: Re: ICP, 3ware,  Areca?
Date: Tue, 7 Nov 2006 17:07:00 -0500
Message-ID: <20061107220700.GG29071@ti64.telemetry-investments.com>
References: <20061107114724.9c2cc644.akpm@osdl.org> <1162933193.8123.36.camel@kleikamp.austin.ibm.com> <20061107134513.fbd5f219.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gw1a.telemetry-investments.com ([64.20.161.180]:13231 "EHLO
	sv1.telemetry-investments.com") by vger.kernel.org with ESMTP
	id S1753471AbWKGWHE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 Nov 2006 17:07:04 -0500
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20061107134513.fbd5f219.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 07, 2006 at 01:45:13PM -0800, Andrew Morton wrote:
> Bill, if you have time it'd be interesting to repeat the comparative
> benchmarking with:
> 
> ext3, data=ordered:
> 
> 	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
> 	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc
> 
> ext4dev:
> 
> 	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
> 	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc
> 
> ext4dev, -oextents
> 
> 	rm foo
> 	dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct
> 	time dd if=/dev/zero of=foo bs=1M count=1000 oflag=direct conv=notrunc
 
Andrew,
 
Will do.

I currently have one of these servers running a production Postgresql
over Ext3.  The warm-standby backup server is not yet fully configured
and in use, so I will do some testing before deploying it.

We are at the tail end of a horrible office move, so I've been a bit
removed from kernel-building.  [Sadly, I have yet to have a chance to test
the excellent sata_nv ADMA work to see whether the latencies are gone.]
I ought to be able to get to testing in the next day or two; sorry in advance
for the delay.

In the e-mail you received, I had omitted the full information from my
original postings.  I don't see the archives online, so I've appended the
full results.  fio-1.5-0.20060728152503 was used; the parameters appear
in the fio output

  -Bill

=========================================================================

 Date: Tue, 22 Aug 2006 12:39:01 -0400
 From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
 To: Chris Caputo <ccaputo@alt.net>
 Cc: linux-ide-arrays@lists.math.uh.edu
 Subject: Re: Areca 1220 Sequential I/O performance numbers
 In-Reply-To: <Pine.LNX.4.64.0608182252550.4337@nacho.alt.net>
 Message-ID: <20060822163901.GA1048@ti64.telemetry-investments.com>


On Fri, Aug 18, 2006 at 10:54:22PM +0000, Chris Caputo wrote:
> I'd run a test with write cache on and one with write cache off and 
> compare the results.  The difference can be vast and depending on your 
> application it may be okay to run with write cache on.

Thanks Chris,

Forcing disk write caching on certainly changes the results
(and the risk profile, of course).  For the archives, here are
some simple "dd" and "fio" odirect results. These benchmarks  
were run with defaults (CFQ scheduler, nr_request = 128).

Again, the machine is a Tyan 2882 dual Opteron with 8GB RAM and an Areca 1220
/ 128MB BBU and 8xWDC WD2500JS-00NCB1 250.1GB 7200 RPM configured as a
RAID6 with chunk size 64K.  [System volume is on an separate MD RAID1 on
the Nvidia controller.]  It's running FC4 x86_64 with a custom-built
2.6.17.7 kernel and the arcmsr driver from scsi-misc GIT, which is
basically 1.20.0X.13 + fixes.  The firmware is V1.41 2006-5-24.


Summary:

Raw partition: 228 MiB/s
XFS:           228 MiB/s
Ext3:      139-151 MiB/s

[N.B.: The "dd" numbers are displayed in MB/s, the "fio" results are in MiB/s.]

=================
= Raw partition =
=================

   % sudo time dd if=/dev/zero of=/dev/sdc2 bs=4M count=1024 oflag=direct
   1024+0 records in
   1024+0 records out
   4294967296 bytes (4.3 GB) copied, 17.7893 seconds, 241 MB/s
   0.00user 0.68system 0:17.86elapsed 3%CPU (0avgtext+0avgdata 0maxresident)k
   0inputs+0outputs (3major+264minor)pagefaults 0swaps

   % sudo fio sequential-write
   client1: (g=0): rw=write, odir=1, bs=131072-131072, rate=0,
                   ioengine=libaio, iodepth=32   
   Starting 1 thread
   Threads running: 1: [W] [100.00% done] [eta 00m:00s]
   client1: (groupid=0): err= 0:
     write: io=  4099MiB, bw=228004KiB/s, runt= 18855msec
       slat (msec): min=    0, max=    0, avg= 0.00, dev= 0.00
       clat (msec): min=    0, max=   83, avg=18.07, dev=26.64
       bw (KiB/s) : min=    0, max=358612, per=98.57%, avg=224741.21, dev=243343.17
     cpu          : usr=0.30%, sys=5.15%, ctx=33015

   Run status group 0 (all jobs): 
     WRITE: io=4099MiB, aggrb=228004, minb=228004, maxb=228004,
            mint=18855msec, maxt=18855msec

   Disk stats (read/write):
     sdc: ios=0/32799, merge=0/0, ticks=0/602466, in_queue=602461, util=99.73%


======================================================
= XFS (/sbin/mkfs.xfs -f -d su=65536,sw=6 /dev/sdc2) =
======================================================

   % sudo time dd if=/dev/zero of=foo bs=4M count=1024 oflag=direct
   1024+0 records in
   1024+0 records out
   4294967296 bytes (4.3 GB) copied, 17.9354 seconds, 239 MB/s
   0.00user 0.80system 0:17.93elapsed 4%CPU (0avgtext+0avgdata 0maxresident)k
   0inputs+0outputs (0major+268minor)pagefaults 0swaps

   % sudo fio sequential-write-foo
   client1: (g=0): rw=write, odir=1, bs=131072-131072, rate=0,
                   ioengine=libaio, iodepth=32
   Starting 1 thread
   client1: Laying out IO file (4096MiB)
   Threads running: 1: [W] [100.00% done] [eta 00m:00s]
   client1: (groupid=0): err= 0:
     write: io=  4096MiB, bw=228613KiB/s, runt= 18787msec
       slat (msec): min=    0, max=    0, avg= 0.00, dev= 0.00
       clat (msec): min=    0, max=  105, avg=18.02, dev=26.63
       bw (KiB/s) : min=    0, max=359137, per=97.62%, avg=223165.97, dev=240029.16
     cpu          : usr=0.21%, sys=5.39%, ctx=32928

   Run status group 0 (all jobs):
     WRITE: io=4096MiB, aggrb=228613, minb=228613, maxb=228613,
            mint=18787msec, maxt=18787msec

   Disk stats (read/write):
     sdc: ios=28/49658, merge=0/1, ticks=520/2564125, in_queue=2564637, util=92.62%

==================================================================
= Ext3 (/sbin/mke2fs -j -J size=400 -E stride=96 /dev/sdc2)      =
= This is with data=ordered; data=writeback was slightly slower. =
==================================================================

   % sudo time dd if=/dev/zero of=foo bs=4M count=1024 oflag=direct
   1024+0 records in
   1024+0 records out
   4294967296 bytes (4.3 GB) copied, 29.4102 seconds, 146 MB/s
   0.00user 1.40system 0:29.95elapsed 4%CPU (0avgtext+0avgdata 0maxresident)k
   0inputs+0outputs (0major+268minor)pagefaults 0swaps

   % sudo fio sequential-write-foo
   client1: (g=0): rw=write, odir=1, bs=131072-131072, rate=0,
                   ioengine=libaio, iodepth=32
   Starting 1 thread
   Threads running: 1: [W] [100.00% done] [eta 00m:00s]0m:10s]
   client1: (groupid=0): err= 0:
     write: io=  4096MiB, bw=151894KiB/s, runt= 28276msec
       slat (msec): min=    0, max=    0, avg= 0.00, dev= 0.00
       clat (msec): min=    0, max=  428, avg=27.23, dev=56.99
       bw (KiB/s) : min=    0, max=266338, per=100.11%, avg=152057.02, dev=173467.74
     cpu          : usr=0.23%, sys=3.64%, ctx=32944

   Run status group 0 (all jobs):
     WRITE: io=4096MiB, aggrb=151894, minb=151894, maxb=151894,
            mint=28276msec, maxt=28276msec

   Disk stats (read/write):
     sdc: ios=0/33867, merge=0/5, ticks=0/934143, in_queue=934143, util=99.96%
