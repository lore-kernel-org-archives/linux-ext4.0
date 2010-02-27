From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Fri, 26 Feb 2010 18:51:45 -0600
Message-ID: <4B886CA1.9050906@redhat.com>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966734Ab0B0Avx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Feb 2010 19:51:53 -0500
In-Reply-To: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Justin Piszcz wrote:
> Hello,
> 
> Is it possible to 'optimize' ext4 so it is as fast as XFS for writes?
> I see about half the performance as XFS for sequential writes.
> 
> I have checked the doc and tried several options, a few of which are shown
> below (I have also tried the commit/journal_async/etc options but none
> of them get the write speeds anywhere near XFS)?
> 
> Sure 'dd' is not a real benchmark, etc, etc, but with 10Gbps between 2
> hosts I get 550MiB/s+ on reads from EXT4 but only 100-200MiB/s write.
> 
> When it was XFS I used to get 400-600MiB/s for writes for the same RAID
> volume.
> 
> How do I 'speed' up ext4?  Is it possible?

Aside from Dmitry's suggestion to time sync as well (although for 10G, you are
likely not leaving much in cache) I'd ask:

What kernel version?  what xfsprogs/e2fsprogs version?

Were the filesystems created to align with raid geometry?

mkfs.xfs has done that forever; mkfs.ext4 only will do so (automatically)
with recent kernel+e2fsprogs.

-Eric

> raid0_11 disks: (XFS)
> # /dev/md0        /r1             xfs     noatime         0       1
> p63:/r1# dd if=/dev/zero of=bigfile1 bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 18.1021 s, 593 MB/s
> p63:/r1#
> 
> raid0_11 disks: (EXT4)
> # /dev/md0        /r1             ext4     noatime         0       1
> # dd if=/dev/zero of=file bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 35.3741 s, 304 MB/s
> p63:/r1#
> 
> Other tests (ext4)
> p63:~# mount /dev/md0 /r1 -o data=writeback
> p63:~# cd /r1
> p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 39.8746 s, 269 MB/s
> p63:/r1#
> 
> p63:~# mount /dev/md0 /r1 -o data=writeback,nobarrier
> p63:/r1# dd if=/dev/zero of=file bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 40.0656 s, 268 MB/s
> 
> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

