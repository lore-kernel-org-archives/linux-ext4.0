From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext4: simplify some code in read_mmp_block()
Date: Tue, 11 Aug 2015 00:34:17 +0300
Message-ID: <20150810213416.GB31724@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

My static checker complains because it is not necessary to test
"if (*bh)" when we just tested "if (!*bh)" on the lines before.
We can remove the condition and pull everything in one indent level.

Then we have another "if (unlikely(!*bh))" check and the only way that
can be true is if the "if (!buffer_uptodate(*bh))" condition was true so
we can combine them together.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 8313ca3..736f12e 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -80,18 +80,15 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 		*bh = sb_getblk(sb, mmp_block);
 	if (!*bh)
 		return -ENOMEM;
-	if (*bh) {
-		get_bh(*bh);
-		lock_buffer(*bh);
-		(*bh)->b_end_io = end_buffer_read_sync;
-		submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
-		wait_on_buffer(*bh);
-		if (!buffer_uptodate(*bh)) {
-			brelse(*bh);
-			*bh = NULL;
-		}
-	}
-	if (unlikely(!*bh)) {
+
+	get_bh(*bh);
+	lock_buffer(*bh);
+	(*bh)->b_end_io = end_buffer_read_sync;
+	submit_bh(READ_SYNC | REQ_META | REQ_PRIO, *bh);
+	wait_on_buffer(*bh);
+	if (!buffer_uptodate(*bh)) {
+		brelse(*bh);
+		*bh = NULL;
 		ext4_warning(sb, "Error while reading MMP block %llu",
 			     mmp_block);
 		return -EIO;
