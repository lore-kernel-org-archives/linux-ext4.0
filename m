From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Fri, 29 Mar 2013 15:32:53 +0800
Message-ID: <20130329073253.GA3578@gmail.com>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
 <5149C452.3070206@redhat.com>
 <20130320144523.GF12865@thunk.org>
 <20130326055251.GA17165@gmail.com>
 <20130326203403.GE2082@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:49074 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab3C2HRM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Mar 2013 03:17:12 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so131502dak.34
        for <linux-ext4@vger.kernel.org>; Fri, 29 Mar 2013 00:17:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130326203403.GE2082@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:34:03PM +0100, Jan Kara wrote:
> On Tue 26-03-13 13:52:51, Zheng Liu wrote:
> > Sorry for the late reply.
> > 
> > On Wed, Mar 20, 2013 at 10:45:23AM -0400, Theodore Ts'o wrote:
> > > On Wed, Mar 20, 2013 at 09:14:42AM -0500, Eric Sandeen wrote:
> > > > 
> > > > As an aside, is there any reason to have "dioread_nolock" as an option
> > > > at this point?  If it works now, would you ever *not* want it?
> > > > 
> > > > (granted it doesn't work with some journaling options etc, but that
> > > > behavior could be automatic, w/o the need for special mount options).
> > > 
> > > The primary restriction is that diread_nolock doesn't work when fs
> > > block size != page size.  If your proposal is that we automatically
> > > enable diread_nolock when we can use it safely, that's definitely
> > > something to consider for the next merge window.
> > 
> > Yes, I also think we can automatically enable dioread_nolock because it
> > brings us some benefits.
>   But isn't there also some overhead due to buffered writes having to go
> through uninit->init conversion?

Hi Jan,

Here is my test result.  I use fio to do some performance tests.  The
test environment is a Dell desktop with a Intel(R) Core(TM)2 Duo CPU
E8400  @ 3.00GHz, 4G memory, 1 Intel 320 SSD.  I test three cases that
are sync dio read/write, aio dio read/write, and sync buffered io.
The result is as below.  Due to too many number we post some key data
here.

>From the result we can see that after dioread_nolock enables the max
latency can be reduced dramatically for sync dio and sync bio, and other
value doesn't be affected too much.  If I miss some important test case,
please let me know.

Thanks,
                                                - Zheng

The kernel version is 3.9.0-rc4+.

= sync dio =
== fio config file ==
  [global]
  ioengine=psync
  direct=1
  bs=4k
  thread
  group_reporting
  directory=/mnt/sda1/
  filename=testfile
  filesize=10g
  size=10g
  runtime=120
  iodepth=16
  fallocate=0
  
  [reader]
  rw=randread
  numjobs=8
  
  [writer]
  rw=randwrite
  numjobs=2

== result ==
=== w/o dioread_nolock ===
  read : io=5142.1MB, bw=43885KB/s, iops=10971 , runt=120002msec
    clat (usec): min=123 , max=679911 , avg=727.21, stdev=3986.35
     lat (usec): min=123 , max=679911 , avg=727.40, stdev=3986.35
  write: io=542548KB, bw=4521.2KB/s, iops=1130 , runt=120003msec
    clat (usec): min=136 , max=2743.3K, avg=1766.78, stdev=14844.10
     lat (usec): min=137 , max=2743.3K, avg=1767.14, stdev=14844.10

=== w/ dioread_nolock ===
  read : io=5072.2MB, bw=43282KB/s, iops=10820 , runt=120002msec
    clat (usec): min=158 , max=291847 , avg=737.38, stdev=3944.14
     lat (usec): min=158 , max=291848 , avg=737.56, stdev=3944.14
  write: io=589752KB, bw=4914.6KB/s, iops=1228 , runt=120001msec
    clat (usec): min=138 , max=2048.3K, avg=1625.15, stdev=11344.36
     lat (usec): min=139 , max=2048.3K, avg=1625.50, stdev=11344.35

= aio dio =
== fio config file ==
  [global]
  ioengine=libaio
  direct=1
  bs=4k
  thread
  group_reporting
  directory=/mnt/sda1/
  filename=testfile
  filesize=10g
  size=10g
  runtime=120
  iodepth=64
  fallocate=0
  
  [reader]
  rw=randread
  numjobs=8
  
  [writer]
  rw=randwrite
  numjobs=2

== result ==
=== w/o dioread_nolock ===
  read : io=4865.4MB, bw=41510KB/s, iops=10377 , runt=120014msec
    slat (usec): min=3 , max=320273 , avg=700.79, stdev=6070.93
    clat (usec): min=232 , max=958452 , avg=48627.21, stdev=53296.33
     lat (usec): min=248 , max=958471 , avg=49328.36, stdev=53905.27
  write: io=684100KB, bw=5700.3KB/s, iops=1425 , runt=120013msec
    slat (usec): min=5 , max=349019 , avg=1339.75, stdev=9538.63
    clat (usec): min=140 , max=1060.1K, avg=88459.40, stdev=95903.63
     lat (usec): min=211 , max=1060.1K, avg=89799.48, stdev=97025.95

=== w/ dioread_nolock ===
  read : io=4869.1MB, bw=41544KB/s, iops=10385 , runt=120037msec
    slat (usec): min=4 , max=322951 , avg=700.33, stdev=5987.29
    clat (usec): min=229 , max=703241 , avg=48584.27, stdev=52570.02
     lat (usec): min=248 , max=703247 , avg=49284.94, stdev=53185.97
  write: io=698856KB, bw=5821.1KB/s, iops=1455 , runt=120038msec
    slat (usec): min=7 , max=367042 , avg=1297.87, stdev=9316.21
    clat (usec): min=178 , max=968434 , avg=86625.80, stdev=92500.21
     lat (usec): min=284 , max=1020.8K, avg=87924.01, stdev=93554.86

= sync buffered io =
== fio config file ==
  [global]
  ioengine=psync
  direct=0
  bs=4k
  thread
  group_reporting
  directory=/mnt/sda1/
  filename=testfile
  filesize=10g
  size=10g
  runtime=120
  iodepth=16
  fallocate=0
  
  [reader]
  rw=randread
  numjobs=8
  
  [writer]
  rw=randwrite
  numjobs=2
  
== result ==
=== w/o dioread_nolock ===
  read : io=7577.6MB, bw=64661KB/s, iops=16165 , runt=120001msec
    clat (usec): min=1 , max=3107.8K, avg=493.15, stdev=5368.87
     lat (usec): min=1 , max=3107.8K, avg=493.31, stdev=5368.87
  write: io=764256KB, bw=6350.2KB/s, iops=1587 , runt=120353msec
    clat (usec): min=2 , max=42443K, avg=1257.41, stdev=138832.28
     lat (usec): min=2 , max=42443K, avg=1257.57, stdev=138832.29

=== w/ dioread_nolock ===
  read : io=7613.1MB, bw=64972KB/s, iops=16243 , runt=120001msec
    clat (usec): min=1 , max=1126.4K, avg=490.79, stdev=3742.64
     lat (usec): min=1 , max=1126.4K, avg=490.95, stdev=3742.64
  write: io=763428KB, bw=6351.1KB/s, iops=1587 , runt=120189msec
    clat (usec): min=2 , max=45783K, avg=1258.23, stdev=163258.23
     lat (usec): min=2 , max=45783K, avg=1258.37, stdev=163258.23
