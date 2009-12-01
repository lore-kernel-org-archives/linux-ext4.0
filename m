From: Jan Kara <jack@suse.cz>
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
Date: Tue, 1 Dec 2009 17:03:24 +0100
Message-ID: <20091201160324.GA25873@quack.suse.cz>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
 <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
 <1259667765.9614.19.camel@marge.simson.net>
 <20091201143558.GB12730@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Y Knight <foom@fuhm.net>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	npiggin@suse.de
To: Mike Galbraith <gleep@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbZLAQD2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Dec 2009 11:03:28 -0500
Content-Disposition: inline
In-Reply-To: <20091201143558.GB12730@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 01-12-09 15:35:59, Jan Kara wrote:
> On Tue 01-12-09 12:42:45, Mike Galbraith wrote:
> > On Mon, 2009-11-30 at 19:48 -0500, James Y Knight wrote:
> > > On Nov 30, 2009, at 3:55 PM, James Y Knight wrote:
> > > 
> > > > This test case fails in 2.6.23-2.6.25, because of the bug fixed in 864f24395c72b6a6c48d13f409f986dc71a5cf4a, and now again in at least 2.6.31 and 2.6.32pre8 because of a *different* bug. This test *does not* fail 2.6.26. I have not tested anything between 2.6.26 and 2.6.31.
> > > > 
> > > > The bug in 2.6.31 is definitely not the same bug as 2.6.23's. This time, the zero'd area of the file doesn't show up immediately upon writing the file. Instead, the kernel waits to mangle the file until it has to flush the buffer to disk. *THEN* it zeros out parts of the file.
> > > > 
> > > > So, after writing out the new file with writev, and checking the md5sum (which is correct), this test case asks the kernel to flush the cache for that file, and then checks the md5sum again. ONLY THEN is the file corrupted. That is, I won't hesitate to say *incredibly evil* behavior: it took me quite some time to figure out WTH was going wrong with my program before determining it was a kernel bug.
> > > > 
> > > > This test case is distilled from an actual application which doesn't even intentionally use writev: it just uses C++'s ofstream class to write data to a file. Unfortunately, that class smart and uses writev under the covers. Unfortunately, I guess nobody ever tests linux writev behavior, since it's broken _so_much_of_the_time_. I really am quite astounded to see such a bad track record for such a fundamental core system call....
> > > > 
> > > > My /tmp is an ext3 filesystem, in case that matters.
> > > 
> > > Further testing shows that the filesystem type *does* matter. The bug does not exhibit when the test is run on ext2, ext4, vfat, btrfs, jfs, or xfs (and probably all the others too). Only, so far as I can determine, on ext3.
> > 
> > I bisected it this morning.  Bisected cleanly to...
> > 
> > 9eaaa2d5759837402ec5eee13b2a97921808c3eb is the first bad commit
>   OK, I've debugged it. This commit is really at fault. The problem is
> following:
>   When using writev, the page we copy from is not paged in (while when we
> use ordinary write, it is paged in). This difference might be worth
> investigation on its own (as it is likely to heavily impact performance of
> writev) but is irrelevant for us now - we should handle this without data
> corruption anyway. Because the source page is not available, we pass 0 as
> the number of copied bytes to write_end and thus ext3_write_end decides to
> truncate the file to original size. This is perfectly fine. The problem is
> that we do this by ext3_truncate() which just frees corresponding block but
> does not unmap buffers. So we leave mapped buffers beyond i_size (they
> actually never were inside i_size) but the blocks they are mapped to are
> already free. The write is then retried (after mapping the page),
> block_write_begin() sees the buffer is mapped (although it is beyond
> i_size) and thus it does not call ext3_get_block() anymore. So as a result,
> data is written to a block that is no longer allocated to the file. Bummer
> - welcome filesystem corruption.
>   Ext4 also has this problem but delayed allocation mitigates the effect to
> an error in accounting of blocks reserved for delayed allocation and thus
> under normal circumstances nothing bad happens.
>   The question is how to solve this in the cleanest way. We can call
> vmtruncate() instead of ext3_truncate() as we used to do but Nick wants to
> get rid of that (that's why I originally changed the code to what it is
> now). So probably we could just manually call truncate_pagecache() instead.
> Nick, I think your truncate calling sequence patch set needs similar fix
> for all filesystems as well.
  The patch below fixes the issue for me...

									Honza

>From 1b2ad411dd86afbfdb3c5b0f913230e9f1f0b858 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 1 Dec 2009 16:53:06 +0100
Subject: [PATCH] ext3: Fix data / filesystem corruption when write fails to copy data

When ext3_write_begin fails after allocating some blocks or
generic_perform_write fails to copy data to write, we truncate blocks already
instantiated beyond i_size. Although these blocks were never inside i_size, we
have to truncate pagecache of these blocks so that corresponding buffers get
unmapped. Otherwise subsequent __block_prepare_write (called because we are
retrying the write) will find the buffers mapped, not call ->get_block, and
thus the page will be backed by already freed blocks leading to filesystem and
data corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/inode.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 354ed3b..f9d6937 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1151,6 +1151,16 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ext3_journal_get_write_access(handle, bh);
 }
 
+/*
+ * Truncate blocks that were not used by write. We have to truncate the
+ * pagecache as well so that corresponding buffers get properly unmapped.
+ */
+static void ext3_truncate_failed_write(struct inode *inode)
+{
+	truncate_inode_pages(inode->i_mapping, inode->i_size);
+	ext3_truncate(inode);
+}
+
 static int ext3_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -1209,7 +1219,7 @@ write_begin_failed:
 		unlock_page(page);
 		page_cache_release(page);
 		if (pos + len > inode->i_size)
-			ext3_truncate(inode);
+			ext3_truncate_failed_write(inode);
 	}
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
@@ -1304,7 +1314,7 @@ static int ext3_ordered_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1330,7 +1340,7 @@ static int ext3_writeback_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
@@ -1383,7 +1393,7 @@ static int ext3_journalled_write_end(struct file *file,
 	page_cache_release(page);
 
 	if (pos + len > inode->i_size)
-		ext3_truncate(inode);
+		ext3_truncate_failed_write(inode);
 	return ret ? ret : copied;
 }
 
-- 
1.6.4.2

