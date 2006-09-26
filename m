From: Andrew Morton <akpm@osdl.org>
Subject: ext3 merge status
Date: Tue, 26 Sep 2006 13:41:56 -0700
Message-ID: <20060926134156.9c2f5c57.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44518 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932290AbWIZUmJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 16:42:09 -0400
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


I'll plan on merging the following patches into Linus's tree this week:

jbd-add-lock-annotation-to-jbd_sync_bh.patch
ext3-and-jbd-cleanup-remove-whitespace.patch
jbd-use-build_bug_on-in-journal-init.patch
fix-ext3-mounts-at-16t.patch
fix-ext3-mounts-at-16t-fix.patch
fix-ext2-mounts-at-16t.patch
fix-ext2-mounts-at-16t-fix.patch
ext3-inode-numbers-are-unsigned-long.patch
ext3-inode-numbers-are-unsigned-long-fix.patch
jbd-16t-fixes.patch
ext3-turn-on-reservation-dump-on-block-allocation-errors.patch
ext3-add-more-comments-in-block-allocation-reservation-code.patch
ext3-wrong-error-behavior.patch
ext3-more-whitespace-cleanups.patch
ext3-fix-sparse-warnings.patch
more-ext3-16t-overflow-fixes.patch
more-ext3-16t-overflow-fixes-fix.patch
fs-conversions-from-kmallocmemset-to-kzcalloc.patch
fs-removing-useless-casts.patch
really-ignore-kmem_cache_destroy-return-value.patch

Once that's done, the remaining patches touch on ext3:

git-block.patch
inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default.patch
vectorize-aio_read-aio_write-fileop-methods.patch
remove-readv-writev-methods-and-use-aio_read-aio_write.patch
fs-cache-provide-a-filesystem-specific-syncable-page-bit.patch
r-o-bind-mount-unlink-monitor-i_nlink.patch
r-o-bind-mount-prepwork-inc_nlink-helper.patch
r-o-bind-mount-monitor-zeroing-of-i_nlink.patch

These are harder.

Jens needs to get a wiggle on with merging the block tree (please).

The inode-diet stuff I guess I'll merge next week.  It'll need a splitup
because it has gfs2 bits in it, and boy it has needed a lot of fixups...

The AIO vectorisation work can maybe be merged next week, but I need to
check whether doing do will complicate the needed fixups and speedups in
the core writev() code.

I don't know if we'll be merging the fs-cache code this time around - it's
largely in Trond and Christoph's hands.

I think the r-o-bind-mount stuff is ready to go, but it's simply banked up
behind a _lot_ of other stuff (including various subsystem trees) and it'll
take some time.

So I cannot guarantee that all this will be flushed by the time we do
the ext4 copy-n-paste.  Nor can I guarantee that I'll be sufficiently
awake to spot (and handle) all patches which touch on ext3/jbd but which
fail to update ext4.  Help.

