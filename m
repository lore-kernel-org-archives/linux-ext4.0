From: Andreas Dilger <adilger@sun.com>
Subject: Re: What's cooking in e2fsprogs.git (topics)
Date: Mon, 17 Dec 2007 15:34:55 -0700
Message-ID: <20071217223455.GE3214@webber.adilger.int>
References: <E1IooAl-0006SJ-Ki@closure.thunk.org> <20071217171100.GA7070@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:46184 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbXLQWfS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Dec 2007 17:35:18 -0500
Content-Disposition: inline
In-Reply-To: <20071217171100.GA7070@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Dec 17, 2007  12:11 -0500, Theodore Tso wrote:
> * ak/undo-mgr (Mon Aug 13 15:56:26 2007 +0530) 6 commits
>  - e2fsprogs: Make mke2fs use undo I/O manager.

Did you see Eric's report that using the undo manager for mke2fs caused the
performance to completely tank?  There is already enough memory pressure
caused by a regular mke2fs that having to save the blocks into tdb for a
large filesystem makes it unbearably slow.

We had also wanted to move from using db4 to tdb for the Lustre lfsck data
(collection of EA information for distributed fsck) but even at 10000 files
the tdb performance was growing exponentially slower than db4 and we gave up.
I suspect the same problem hits undo manager when the number of blocks to
save is very high.

I think it might be viable to use undo manager for mke2fs when e.g.
uninit_groups and lazy_bg are enabled, since the amount of device IO is
very small then.  Otherwise, it may be that undo manager should be reserved
for e2fsck right now, or possibly reworked to just do IO to a sparse file
similar to doing an e2image before the mke2fs.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
