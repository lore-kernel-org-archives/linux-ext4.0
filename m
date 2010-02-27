From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s
 limitation/bug?
Date: Sat, 27 Feb 2010 16:30:39 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan> <20100228080100.092c24c2@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Neil Brown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100228080100.092c24c2@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On Sun, 28 Feb 2010, Neil Brown wrote:

> On Sat, 27 Feb 2010 08:47:48 -0500 (EST)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Hello,
>>
>> I have two separate systems and with ext4 I cannot get speeds greater than
>> ~350MiB/s when using ext4 as the filesystem on top of a raid5 or raid0.
>> It appears to be a bug with ext4 (or its just that ext4 is slower for this
>> test)?
>>
>> Each system runs 2.6.33 x86_64.
>
> Could be related to the recent implementation of IO barriers in md.
> Can you try mounting your filesystem with
>   -o barrier=0
>
> and see how that changes the result.
>
> NeilBrown

Hi Neil,

Thanks for the suggestion, it has been used here:
http://lkml.org/lkml/2010/2/27/66

Looks like an EXT4 issue as XFS does ~600MiB/s..?

Its strange though, on a single hard disk, I get approximately the same 
speed for XFS and EXT4, but when it comes to scaling across multiple disks,
in RAID-0 or RAID-5 (tested), there is a performance problem as it hits a
performance problem at ~350MiB/s.  I tried multiple chunk sizes but nothing
seemed to made a difference (whether 64KiB or 1024KiB), XFS performs at
500-600MiB/s no matter what and EXT4 does not exceed ~350MiB/s.

Is there anyone on any of the lists that gets > 350MiB/s on a mdadm/sw raid
with EXT4?

A single raw disk, no partitions:
p63:~# dd if=/dev/zero of=/dev/sdm bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 92.4249 s, 116 MB/s

A single raw disk formatted with XFS, no partitions:
p63:~# mkfs.xfs /dev/sdm > /dev/null 2>&1 
p63:~# mount /dev/sdm -o nobarrier,noatime /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 85.7782 s, 125 MB/s

A single raw disk formatted with EXT4, no partitions:
p63:~# mkfs.ext4 /dev/sdm > /dev/null 2>&1
p63:~# mount /dev/sdm -o nobarrier,noatime /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10737418240 bytes (11 GB) copied, 85.1501 s, 126 MB/s
p63:/r1#

EXT2 vs. EXT3 vs. EXT4
http://lkml.org/lkml/2010/2/27/77

XFS tests: (550-600MiB/s)
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-02/msg10572.html

Justin.
