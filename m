From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 43/53] ext4: Remove extraneous newlines in ext4_msg() calls
Date: Sun, 30 May 2010 22:49:56 -0400
Message-ID: <1275274206-3900-43-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Curt Wohlgemuth <curtw@google.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44578 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402Ab0EaCuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:16 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Curt Wohlgemuth <curtw@google.com>

commit fbe845ddf368f77f86aa7500f8fd2690f54c66a8 upstream (as of v2.6.34-git13)

Addresses-Google-Bug: #2562325

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |    6 +++---
 fs/ext4/super.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ba7549f..faa8c95 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2294,7 +2294,7 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 		ext4_msg(mpd->inode->i_sb, KERN_CRIT,
 			 "delayed block allocation failed for inode %lu at "
 			 "logical offset %llu with max blocks %zd with "
-			 "error %d\n", mpd->inode->i_ino,
+			 "error %d", mpd->inode->i_ino,
 			 (unsigned long long) next,
 			 mpd->b_size >> mpd->inode->i_blkbits, err);
 		printk(KERN_CRIT "This should not happen!!  "
@@ -2956,7 +2956,7 @@ retry:
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-			       "%ld pages, ino %lu; err %d\n", __func__,
+			       "%ld pages, ino %lu; err %d", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
 			goto out_writepages;
 		}
@@ -3031,7 +3031,7 @@ retry:
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,
 			 "This should not happen leaving %s "
-			 "with nr_to_write = %ld ret = %d\n",
+			 "with nr_to_write = %ld ret = %d",
 			 __func__, wbc->nr_to_write, ret);
 
 	/* Update index */
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bf3ca2c..ea9ad5b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2902,7 +2902,7 @@ no_journal:
 	err = ext4_setup_system_zone(sb);
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize system "
-			 "zone (%d)\n", err);
+			 "zone (%d)", err);
 		goto failed_mount4;
 	}
 
-- 
1.6.6.1.1.g974db.dirty

