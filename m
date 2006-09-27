From: Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: ext3 merge status
Date: Tue, 26 Sep 2006 22:48:49 -0500
Message-ID: <1159328929.14015.15.camel@kleikamp.austin.ibm.com>
References: <20060926134156.9c2f5c57.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36274 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S932368AbWI0Dsz
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Sep 2006 23:48:55 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8R3mqdY018513
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 23:48:52 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8R3mqMA237410
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 21:48:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8R3mphb015967
	for <linux-ext4@vger.kernel.org>; Tue, 26 Sep 2006 21:48:52 -0600
To: Andrew Morton <akpm@osdl.org>
In-Reply-To: <20060926134156.9c2f5c57.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2006-09-26 at 13:41 -0700, Andrew Morton wrote:
> I'll plan on merging the following patches into Linus's tree this week:
> 
> jbd-add-lock-annotation-to-jbd_sync_bh.patch
> ext3-and-jbd-cleanup-remove-whitespace.patch
> jbd-use-build_bug_on-in-journal-init.patch
> fix-ext3-mounts-at-16t.patch
> fix-ext3-mounts-at-16t-fix.patch
> fix-ext2-mounts-at-16t.patch
> fix-ext2-mounts-at-16t-fix.patch
> ext3-inode-numbers-are-unsigned-long.patch
> ext3-inode-numbers-are-unsigned-long-fix.patch
> jbd-16t-fixes.patch
> ext3-turn-on-reservation-dump-on-block-allocation-errors.patch
> ext3-add-more-comments-in-block-allocation-reservation-code.patch
> ext3-wrong-error-behavior.patch
> ext3-more-whitespace-cleanups.patch
> ext3-fix-sparse-warnings.patch
> more-ext3-16t-overflow-fixes.patch
> more-ext3-16t-overflow-fixes-fix.patch
> fs-conversions-from-kmallocmemset-to-kzcalloc.patch
> fs-removing-useless-casts.patch
> really-ignore-kmem_cache_destroy-return-value.patch
> 
> Once that's done, the remaining patches touch on ext3:
> 
> git-block.patch
> inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default.patch
> vectorize-aio_read-aio_write-fileop-methods.patch
> remove-readv-writev-methods-and-use-aio_read-aio_write.patch
> fs-cache-provide-a-filesystem-specific-syncable-page-bit.patch
> r-o-bind-mount-unlink-monitor-i_nlink.patch
> r-o-bind-mount-prepwork-inc_nlink-helper.patch
> r-o-bind-mount-monitor-zeroing-of-i_nlink.patch
> 
> These are harder.
> 
> Jens needs to get a wiggle on with merging the block tree (please).
> 
> The inode-diet stuff I guess I'll merge next week.  It'll need a splitup
> because it has gfs2 bits in it, and boy it has needed a lot of fixups...
> 
> The AIO vectorisation work can maybe be merged next week, but I need to
> check whether doing do will complicate the needed fixups and speedups in
> the core writev() code.
> 
> I don't know if we'll be merging the fs-cache code this time around - it's
> largely in Trond and Christoph's hands.
> 
> I think the r-o-bind-mount stuff is ready to go, but it's simply banked up
> behind a _lot_ of other stuff (including various subsystem trees) and it'll
> take some time.
> 
> So I cannot guarantee that all this will be flushed by the time we do
> the ext4 copy-n-paste.  Nor can I guarantee that I'll be sufficiently
> awake to spot (and handle) all patches which touch on ext3/jbd but which
> fail to update ext4.  Help.

We've got the ext4 patchset arranged as patches against a verbatim copy
of ext3, so it should be easy enough to clone ext4 from whatever is in
ext3 at the time.  (The same for jbd2.)  I can monitor the changes to
ext3/jbd after that and make sure equivalent changes are made to
ext4/jbd2.  It's pretty easy to use git to find those patches.

-- 
David Kleikamp
IBM Linux Technology Center

