From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm software raid + ext4, capped at ~350MiB/s
 limitation/bug?
Date: Sun, 28 Feb 2010 10:00:06 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002280958540.22822@p34.internal.lan>
References: <alpine.DEB.2.00.1002270840410.27192@p34.internal.lan> <20100228080100.092c24c2@notabene.brown> <alpine.DEB.2.00.1002271624480.12663@p34.internal.lan> <4B89B44A.70005@tmr.com> <alpine.DEB.2.00.1002280444530.16775@p34.internal.lan>
 <4B8A7D24.5040404@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Bill Davidsen <davidsen@tmr.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:48511 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968610Ab0B1PAI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Feb 2010 10:00:08 -0500
In-Reply-To: <4B8A7D24.5040404@tmr.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Sun, 28 Feb 2010, Bill Davidsen wrote:

> Justin Piszcz wrote:
>>

[ .. ]

>> fdatasync:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1002.3/01507.html
>> 
> I wasn't expecting a huge change in value, your data size is large. But 
> thanks, the total time without sync can be off by at least seconds, making it 
> hard to duplicate results. You missed nothing this time.
>
> Did you use any of the options with ext4? I found about 15-20% with options, 
> but I didn't take good enough notes to quote now. :-(
> That doesn't mean there wasn't more, I tested on FC9, ext4 was experimental 
> then.

Yes:

I tried nearly every option in the ext4 readme:

more:

p63:~# tune2fs -o journal_data_writeback /dev/md0
tune2fs 1.41.10 (10-Feb-2009)
p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr
p63:~#

p63:~# cd /r1
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 35.7193 s, 301 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.5846 s, 351 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,max_batch_time=0
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.8501 s, 348 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,min_batch_time=10000
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 31.0127 s, 346 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,journal_ioprio=0
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 31.1559 s, 345 MB/s
p63:/r1# cd


p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,journal_ioprio=7
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 31.4713 s, 341 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,journal_async_commit
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.7633 s, 349 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,journal_async_commit,oldalloc
p63:~#
p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 30.7607 s, 349 MB/s
p63:/r1#

p63:~# mount /dev/md0 /r1 -o noatime,barrier=0,data=writeback,nobh,commit=100,nouser_xattr,nodelalloc,journal_async_commit,stripe=1024
p63:~#

Justin.

