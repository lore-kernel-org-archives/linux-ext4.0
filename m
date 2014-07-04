From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: ext4: journal has aborted
Date: Fri, 04 Jul 2014 20:04:13 +0900
Message-ID: <53B68A2D.9070902@samsung.com>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile> <20140701084206.GG9743@birch.djwong.org>
 <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
 <20140703134338.GE2374@thunk.org> <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org> <20140704114031.2915161a@archvile>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:48149 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaGDLEP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 07:04:15 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N86005GSPF1SQC0@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 04 Jul 2014 20:04:14 +0900 (KST)
In-reply-to: <20140704114031.2915161a@archvile>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi, David.

On 07/04/2014 06:40 PM, David Jander wrote:
> 
> Hi Dmitry,
> 
> On Thu, 03 Jul 2014 18:58:48 +0400
> Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> 
>> On Thu, 3 Jul 2014 16:15:51 +0200, David Jander <david@protonic.nl> wrote:
>>>
>>> Hi Ted,
>>>
>>> On Thu, 3 Jul 2014 09:43:38 -0400
>>> "Theodore Ts'o" <tytso@mit.edu> wrote:
>>>
>>>> On Tue, Jul 01, 2014 at 10:55:11AM +0200, Matteo Croce wrote:
>>>>> 2014-07-01 10:42 GMT+02:00 Darrick J. Wong <darrick.wong@oracle.com>:
>>>>>
>>>>> I have a Samsung SSD 840 PRO
>>>>
>>>> Matteo,
>>>>
>>>> For you, you said you were seeing these problems on 3.15.  Was it
>>>> *not* happening for you when you used an older kernel?  If so, that
>>>> would help us try to provide the basis of trying to do a bisection
>>>> search.
>>>
>>> I also tested with 3.15, and there too I see the same problem.
>>>
>>>> Using the kvm-xfstests infrastructure, I've been trying to reproduce
>>>> the problem as follows:
>>>>
>>>> ./kvm-xfstests  --no-log -c 4k generic/075 ; e2fsck -p /dev/heap/test-4k ; e2fsck -f /dev/heap/test-4k 
>>>>
>>>> xfstests geneeric/075 runs fsx which does a fair amount of block
>>>> allocation deallocations, and then after the test finishes, it first
>>>> replays the journal (e2fsck -p) and then forces a fsck run on the
>>>> test disk that I use for the run.
>>>>
>>>> After I launch this, in a separate window, I do this:
>>>>
>>>> 	sleep 60  ; killall qemu-system-x86_64 
>>>>
>>>> This kills the qemu process midway through the fsx test, and then I
>>>> see if I can find a problem.  I haven't had a chance to automate this
>>>> yet, and it is my intention to try to set this up where I can run this
>>>> on a ramdisk or a SSD, so I can more closely approximate what people
>>>> are reporting on flash-based media.
>>>>
>>>> So far, I haven't been able to reproduce the problem.  If after doing
>>>> a large number of times, it can't be reproduced (especially if it
>>>> can't be reproduced on an SSD), then it would lead us to believe that
>>>> one of two things is the cause.  (a) The CACHE FLUSH command isn't
>>>> properly getting sent to the device in some cases, or (b) there really
>>>> is a hardware problem with the flash device in question.
>>>
>>> Could (a) be caused by a bug in the mmc subsystem or in the MMC peripheral
>>> driver? Can you explain why I don't see any problems with EXT3?
>>>
>>> I can't discard the possibility of (b) because I cannot prove it, but I will
>>> try to see if I can do the same test on a SSD which I happen to have on that
>>> platform. That should be able to rule out problems with the eMMC chip and
>>> -driver, right?
>>>
>>> Do you know a way to investigate (a) (CACHE FLUSH not being sent correctly)?
>>>
>>> I left the system running (it started from a dirty EXT4 partition), and I am
>>> seen the following error pop up after a few minutes. The system is not doing
>>> much (some syslog activity maybe, but not much more):
>>>
>>> [  303.072983] EXT4-fs (mmcblk1p2): error count: 4
>>> [  303.077558] EXT4-fs (mmcblk1p2): initial error at 1404216838: ext4_mb_generate_buddy:756
>>> [  303.085690] EXT4-fs (mmcblk1p2): last error at 1404388969: ext4_mb_generate_buddy:757
>>>
>>> What does that mean?
>> This means that it found previous error in internal ext4's log. Which is
>> normal because your fs was corrupted before. It is reasonable to
>> recreate filesystem from very beginning.
>>
>> In order to understand whenever it is regression in eMMC driver it is
>> reasonable to run integrity test for a device itself. You can run
>> any integrity test you like, For example just run a fio's job
>>  "fio disk-verify2.fio" (see attachment), IMPORTANT this script will
>>  destroy data on test partition. If it failed with errors like
>>  follows "verify: bad magic header XXX" than it is definitely a drivers issue.
> 
> I have been trying to run fio on my board with your configuration file, but I
> am having problems, and since I am not familiar with fio at all, I can't
> really figure out what's wrong. My eMMC device is only 916MiB in size, so I
> edited the last part to be:

Which eMMC host controller did you use?

> 
> offset_increment=100M
> size=100M
> 
> Is that ok?
> 
> I still get error messages complaining about blocksize though. Here is the
> output I get (can't really make sense of it):
> 
> # ./fio ../disk-verify2.fio 
> Multiple writers may overwrite blocks that belong to other jobs. This can cause verification failures.
> /dev/mmcblk1p2: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
> ...
> fio-2.1.10-49-gf302
> Starting 4 processes
> fio: blocksize too large for data set
> fio: blocksize too large for data set
> fio: blocksize too large for data set
> fio: io_u.c:1315: __get_io_u: Assertion `io_u->flags & IO_U_F_FREE' failed.ta 00m:00s]
> fio: pid=7612, got signal=6
> 
> /dev/mmcblk1p2: (groupid=0, jobs=1): err= 0: pid=7612: Fri Jul  4 09:31:15 2014
>     lat (msec) : 4=0.19%, 10=0.19%, 20=0.19%, 50=0.85%, 100=1.23%
>     lat (msec) : 250=56.01%, 500=37.18%, 750=1.14%
>   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
>   IO depths    : 1=0.1%, 2=0.2%, 4=0.4%, 8=0.8%, 16=1.5%, 32=97.1%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued    : total=r=33/w=1024/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
> 
> Disk stats (read/write):
>   mmcblk1: ios=11/1025, merge=0/0, ticks=94/6671, in_queue=7121, util=96.12%
> fio: file hash not empty on exit
> 
> 
> This assertion bugs me. Is it due to the previous errors ("blocksize too large
> for data set") or is is because my eMMC drive/kernel is seriously screwed?
> 
> Help please!
> 
>> If my theory is true and it is storage's driver issue than JBD complain
>> simply because it do care about it's data (it does integrity checks).
>> Can you also create btrfs on that partition and performs some io
>> activity and run fsck after that. You likely will see similar corruption
> 
> Best regards,
> 

