Return-Path: <SRS0=xJ0y=PC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:56477 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725822AbeLYORL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 25 Dec 2018 09:17:11 -0500
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To: linux-ext4@vger.kernel.org
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] ext4: don't submit unwritten extent while holding active jbd2 handle
Date: Tue, 25 Dec 2018 22:16:25 +0800
Message-Id: <20181225141625.18141-1-xiaoguang.wang@linux.alibaba.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_writepages(), for every iteration, mpage_prepare_extent_to_map()
will try to find 2048 pages to map and normally one bio can contain 256
pages at most. If we really found 2048 pages to map, there will be 4 bios
and 4 ext4_io_submit() calls which are called both in ext4_writepages()
and mpage_map_and_submit_extent().

But note that in mpage_map_and_submit_extent(), we hold a valid jbd2 handle,
when dioread_nolock is enabled and extent is unwritten, jbd2 commit thread
will wait this handle to finish, so wait the unwritten extent is written to
disk, this will introduce unnecessary stall time, especially longer when the
writeback operation is io throttled, need to fix this issue.

Here for this scene, we accumulate bios in ext4_io_submit's io_bio, and only
submit these bios after dropping the jbd2 handle.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/ext4/ext4.h    | 12 ++++++++++++
 fs/ext4/inode.c   |  5 ++++-
 fs/ext4/page-io.c | 45 ++++++++++++++++++++++++++++++++++-----------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3f89d0ab08fc..cda191616fdb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -209,9 +209,21 @@ typedef struct ext4_io_end {
 
 struct ext4_io_submit {
 	struct writeback_control *io_wbc;
+	/*
+	 * When dioread_nolock is enabled, we don't submit bios for unwritten
+	 * extent while holding jbd2 handle, which can avoid jbd2 commit thread
+	 * wait io to complete, for this case, we will link bios cover the
+	 * extent to io_bio using bio->bi_private.
+	 */
 	struct bio		*io_bio;
 	ext4_io_end_t		*io_end;
 	sector_t		io_next_block;
+	/*
+	 * If not zero, we have an active bio and can submit this bio or add
+	 * new bh to this bio, if zero, we'll need to allocate a new bio.
+	 */
+	int have_active_bio;
+	int can_submit;
 };
 
 /*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 22a9d8159720..09c8da5ef742 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2486,6 +2486,7 @@ static int mpage_map_one_extent(handle_t *handle, struct mpage_da_data *mpd)
 			mpd->io_submit.io_end->handle = handle->h_rsv_handle;
 			handle->h_rsv_handle = NULL;
 		}
+		mpd->io_submit.can_submit = 0;
 		ext4_set_io_unwritten_flag(inode, mpd->io_submit.io_end);
 	}
 
@@ -2908,7 +2909,9 @@ static int ext4_writepages(struct address_space *mapping,
 			handle = NULL;
 			mpd.do_map = 0;
 		}
-		/* Submit prepared bio */
+		/* Submit all prepared bios */
+		if (!mpd.io_submit.can_submit)
+			mpd.io_submit.can_submit = 1;
 		ext4_io_submit(&mpd.io_submit);
 		/* Unlock pages we didn't use */
 		mpage_release_unused_pages(&mpd, give_up_on_write);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db7590178dfc..0b3b6fbccf6b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -346,15 +346,29 @@ static void ext4_end_bio(struct bio *bio)
 
 void ext4_io_submit(struct ext4_io_submit *io)
 {
-	struct bio *bio = io->io_bio;
-
-	if (bio) {
-		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
-				  REQ_SYNC : 0;
-		io->io_bio->bi_write_hint = io->io_end->inode->i_write_hint;
-		bio_set_op_attrs(io->io_bio, REQ_OP_WRITE, io_op_flags);
-		submit_bio(io->io_bio);
+	struct bio *bio = io->io_bio, *next = NULL;
+	int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
+				REQ_SYNC : 0;
+
+	if (!io->can_submit) {
+		/*
+		 * Caller tries to submit this bio, but currently we can not
+		 * submit this bio, we set have_active_bio to zero, then caller
+		 * will allocate a new bio.
+		 */
+		io->have_active_bio = 0;
+		return;
 	}
+
+	for (bio = io->io_bio; bio; bio = next) {
+		next = bio->bi_private;
+		bio->bi_write_hint = io->io_end->inode->i_write_hint;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, io_op_flags);
+		bio->bi_private = ext4_get_io_end(io->io_end);
+		submit_bio(bio);
+
+	}
+	io->have_active_bio = 0;
 	io->io_bio = NULL;
 }
 
@@ -364,6 +378,13 @@ void ext4_io_submit_init(struct ext4_io_submit *io,
 	io->io_wbc = wbc;
 	io->io_bio = NULL;
 	io->io_end = NULL;
+	/*
+	 * When dioread_nolock is enabled and submit unwritten extents,
+	 * set can_submit to zero, then we'll accumulate bios for this
+	 * extent and submit these bios after drop jdb2 handle.
+	 */
+	io->can_submit = 1;
+	io->have_active_bio = 0;
 }
 
 static int io_submit_init_bio(struct ext4_io_submit *io,
@@ -378,8 +399,10 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev(bio, bh->b_bdev);
 	bio->bi_end_io = ext4_end_bio;
-	bio->bi_private = ext4_get_io_end(io->io_end);
+	/* Point to previous bio if there is */
+	bio->bi_private = io->io_bio;
 	io->io_bio = bio;
+	io->have_active_bio = 1;
 	io->io_next_block = bh->b_blocknr;
 	return 0;
 }
@@ -391,11 +414,11 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 {
 	int ret;
 
-	if (io->io_bio && bh->b_blocknr != io->io_next_block) {
+	if (io->have_active_bio && bh->b_blocknr != io->io_next_block) {
 submit_and_retry:
 		ext4_io_submit(io);
 	}
-	if (io->io_bio == NULL) {
+	if (!io->have_active_bio) {
 		ret = io_submit_init_bio(io, bh);
 		if (ret)
 			return ret;
-- 
2.17.2
