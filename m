From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: sudden (big) performance drop in writes
Date: Thu, 14 Jun 2012 23:34:59 -0600
Message-ID: <67D336C0-4529-477D-B0B3-D840B8032F6F@dilger.ca>
References: <20442.47124.34363.560455@fisica.ufpr.br>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:29356 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2FOFfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Jun 2012 01:35:00 -0400
In-Reply-To: <20442.47124.34363.560455@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-06-14, at 10:20 PM, Carlos Carvalho wrote:
> Our server has suddenly become extremely slow in writes. With
> 
> % dd if=/dev/zero of=zero bs=2M count=2000
> 
> I get only 1.4MB/s in an almost idle machine. It has a raid6 with 6
> disks, running 3.3.7. 3.4.2 doesn't improve matters.
> 
> The important point is that it became so slow yesterday. No hardware
> has changed and all disks are fine. Reading from the filesystem is
> unaffected, at more than 85MB/s. The problem happens both in the root
> and home partitions.
> 
> During the dd the disk utilization measured by sar is small:
> 
> DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
> sdb     93.30    254.40    931.20     12.71      0.57      6.10      4.16     38.77
> sdc    100.50    244.00    970.40     12.08      0.76      7.59      3.80     38.20
> sdd    101.40    261.60    927.20     11.72      0.68      6.68      3.74     37.90
> sde     86.80    300.00    780.80     12.45      0.69      7.93      4.29     37.20
> sdf     82.90    315.20    810.40     13.58      0.55      6.60      4.39     36.37
> sda     96.70    220.00    984.00     12.45      0.47      4.87      3.72     35.94
> 
> So it seems that it's not a disk problem. Both filesystems reached 90%
> usage in space but less than 10% in inodes shortly before the slowness
> appeared. Now they're at 57% and 77% but still crawl. Could this be
> related?

Definitely yes.  I was going to ask this question even before I got to
the end and saw your comment.  If the filesystem gets too full, it can
cause new allocations to become fragmented, and then even if you delete
other files, the fragmented files end up leaving individual allocated
blocks all around your filesystem, making future allocations bad also.

You can run "e2freefrag" on the block device to report the current sizes
for free space in the filesystem.  There is the "e4defrag" tool that can
defragment files, but I don't recall whether this is working well or not.

Cheers, Andreas





