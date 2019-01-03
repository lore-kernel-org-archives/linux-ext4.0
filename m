Return-Path: <SRS0=m/y1=PL=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-eopbgr690112.outbound.protection.outlook.com ([40.107.69.112]:51175
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726136AbfACDSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 2 Jan 2019 22:18:51 -0500
Date: Wed, 2 Jan 2019 22:18:40 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
CC: <linux-ext4@vger.kernel.org>, <harshads@google.com>
Subject: Re: [PATCH] ext4: don't submit unwritten extent while holding active
 jbd2 handle
Message-ID: <20190103031840.GB6908@mit.edu>
References: <20181225141625.18141-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20181225141625.18141-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 25, 2018 at 10:16:25PM +0800, Xiaoguang Wang wrote:
> In ext4_writepages(), for every iteration, mpage_prepare_extent_to_map()
> will try to find 2048 pages to map and normally one bio can contain 256
> pages at most. If we really found 2048 pages to map, there will be 4 bios
> and 4 ext4_io_submit() calls which are called both in ext4_writepages()
> and mpage_map_and_submit_extent().
> 
> But note that in mpage_map_and_submit_extent(), we hold a valid jbd2 handle,
> when dioread_nolock is enabled and extent is unwritten, jbd2 commit thread
> will wait this handle to finish, so wait the unwritten extent is written to
> disk, this will introduce unnecessary stall time, especially longer when the
> writeback operation is io throttled, need to fix this issue.
> 
> Here for this scene, we accumulate bios in ext4_io_submit's io_bio, and only
> submit these bios after dropping the jbd2 handle.

I think it would be better if we simply don't even try to *start* the
jbd2 handle at all until we after ext4_end_io_rsv_work() is called.  I
suspect the best place to do this will be in ext4_end_io().  The
shorter time we hold the handle, the better the commit completion
latency will be.  (After all, while we are assembling the bios, memory
allocations could block if the system is under heavy memory pressure,
etc.)

This will also make it a bit easier to support dioread_nolock for
block sizes < page size, since we need to start a separate handle for
each extent that needs to be converted, and if the block size is 4k
and the page size is 64k (for example, on the PowerPC), there might be
as many as 16 extents that have to be modified for a heavily
fragmented file system.

Supporting dioread_nolock for 1k file systems on x86 and 4k file
systems on ppc64/ppc64le will allow us to make dioread_nolock the only
supported write path, dropping the current default.  This will give us
only one write path to optimize, debug, and maintain, which will be a
Good Thing.

Cheers,

						- Ted
