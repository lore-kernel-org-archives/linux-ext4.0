From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2 v2] ext4: simplify some code in read_mmp_block()
Date: Fri, 14 Aug 2015 12:47:02 +0300
Message-ID: <20150814094701.GA14179@mwanda>
References: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FC4DED5-76F2-45DE-8E01-8796850CB120@dilger.ca>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

My static check complains because we have:

	if (!*bh)
		return -ENOMEM;
	if (*bh) {

The second check is unnecessary.

I've simplified this code by moving the "if (!*bh)" checks around.  Also
Andreas Dilger says we should probably print a warning if sb_getblk()
fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: move the code around even more, add a warning message

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 8313ca3..0880ec9 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -69,6 +69,7 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 			  ext4_fsblk_t mmp_block)
 {
 	struct mmp_struct *mmp;
+	int ret;
 
 	if (*bh)
 		clear_buffer_uptodate(*bh);
@@ -76,25 +77,24 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	/* This would be sb_bread(sb, mmp_block), except we need to be sure
 	 * that the MD RAID device cache has been bypassed, and that the read
 	 * is not blocked in the elevator. */
-	if (!*bh)
+	if (!*bh) {
 		*bh = sb_getblk(sb, mmp_block);
-	if (!*bh)
-		return -ENOMEM;
-	if (*bh) {
-		get_bh(*bh);
-		lock_buffer(*bh);
-		(*bh)->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
-		wait_on_buffer(*bh);
-		if (!buffer_uptodate(*bh)) {
-			brelse(*bh);
-			*bh = NULL;
+		if (!*bh) {
+			ret = -ENOMEM;
+			goto warn_exit;
 		}
 	}
-	if (unlikely(!*bh)) {
-		ext4_warning(sb, "Error while reading MMP block %llu",
-			     mmp_block);
-		return -EIO;
+
+	get_bh(*bh);
+	lock_buffer(*bh);
+	(*bh)->b_end_io = end_buffer_read_sync;
+	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
+	wait_on_buffer(*bh);
+	if (!buffer_uptodate(*bh)) {
+		brelse(*bh);
+		*bh = NULL;
+		ret = -EIO;
+		goto warn_exit;
 	}
 
 	mmp = (struct mmp_struct *)((*bh)->b_data);
@@ -103,6 +103,10 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 		return -EINVAL;
 
 	return 0;
+
+warn_exit:
+	ext4_warning(sb, "Error while reading MMP block %llu", mmp_block);
+	return ret;
 }
 
 /*
