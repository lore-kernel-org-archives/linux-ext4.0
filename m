From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Fri, 26 Feb 2010 20:08:30 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan> <4B886CA1.9050906@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lucidpixels.com ([75.144.35.66]:37749 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966723Ab0B0BIc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 20:08:32 -0500
In-Reply-To: <4B886CA1.9050906@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 26 Feb 2010, Eric Sandeen wrote:

> Justin Piszcz wrote:
>> Hello,
>>
>> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
>> I see about half the performance as XFS for sequential writes.
>>
>> I have checked the doc and tried several options, a few of which are shown
>> below (I have also tried the commit/journal_async/etc options but none
>> of them get the write speeds anywhere near XFS)?
>>
>> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
>> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
>>
>> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
>> volume.
>>
>> How do I 'speed' up ext4?  Is it possible?
>
> Aside from Dmitry's suggestion to time sync as well (although for 10G, you are
> likely not leaving much in cache) I'd ask:
>
> What kernel version?  what xfsprogs/e2fsprogs version?
2.6.33/x86_64

ii  xfsprogs                                3.1.1                    Utilities for managing the XFS filesystem
ii  e2fsprogs                               1.41.10-1                ext2/ext3/ext4 file system utilities

>
> Were the filesystems created to align with raid geometry?
Only default options were used except the mount options.  If that is the
culprit, I have some more testing to do, thanks, will look into it.

>
> mkfs.xfs has done that forever; mkfs.ext4 only will do so (automatically)
> with recent kernel+e2fsprogs.
How recent?


