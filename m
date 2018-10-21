Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41350 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbeJUUGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Oct 2018 16:06:34 -0400
Date: Sun, 21 Oct 2018 07:52:25 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Stuart Richards <sjr101@yahoo.com>, 907634@bugs.debian.org
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH] e4defrag: handle failure to open the file system gracefully
Message-ID: <20181021115225.GD1617@thunk.org>
References: <153563436079.3063.9374091462103822599.reportbug@raspberrypi>
 <20181020200646.GA1617@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181020200646.GA1617@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If e4defrag is run by root, it will try to open the underlying file
system for files that it is trying to defrag so it can get the file
system parameters.  It's currently doing this by searching /etc/mtab.
This isn't the best way to go about doing things, but we'll leave it
for now, at least for a maintenance release.  (The better way to do
things would be to look up the device using the blkid library, but
that's a more involved change.)

Since the file system parameters isn't strictly speaking necessary
(after all we get by without them when not running as root), we'll
allow e4defrag to continue running if we can't find the file system.
This can happen if /etc/mtab is pointing at /proc/mounts, and the
kernel can't properly identify the root file system, it is reported as
"/dev/root".

Addresses-Debian-Bug: #907634

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/e4defrag.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/misc/e4defrag.c b/misc/e4defrag.c
index 5ac251dc5..9d237da24 100644
--- a/misc/e4defrag.c
+++ b/misc/e4defrag.c
@@ -1016,7 +1016,9 @@ static int get_best_count(ext4_fsblk_t block_count)
 	int ret;
 	unsigned int flex_bg_num;
 
-	/* Calculate best extents count */
+	if (blocks_per_group == 0)
+		return 1;
+
 	if (feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
 		flex_bg_num = 1 << log_groups_per_flex;
 		ret = ((block_count - 1) /
@@ -1508,10 +1510,7 @@ static int file_defrag(const char *file, const struct stat64 *buf,
 		goto out;
 	}
 
-	if (current_uid == ROOT_UID)
-		best = get_best_count(blk_count);
-	else
-		best = 1;
+	best = get_best_count(blk_count);
 
 	if (file_frags_start <= best)
 		goto check_improvement;
@@ -1805,17 +1804,16 @@ int main(int argc, char *argv[])
 					  block_size, unix_io_manager, &fs);
 			if (ret) {
 				if (mode_flag & DETAIL)
-					com_err(argv[1], ret,
-						"while trying to open file system: %s",
-						dev_name);
-				continue;
+					fprintf(stderr,
+						"Warning: couldn't get file "
+						"system details for %s: %s\n",
+						dev_name, error_message(ret));
+			} else {
+				blocks_per_group = fs->super->s_blocks_per_group;
+				feature_incompat = fs->super->s_feature_incompat;
+				log_groups_per_flex = fs->super->s_log_groups_per_flex;
+				ext2fs_close_free(&fs);
 			}
-
-			blocks_per_group = fs->super->s_blocks_per_group;
-			feature_incompat = fs->super->s_feature_incompat;
-			log_groups_per_flex = fs->super->s_log_groups_per_flex;
-
-			ext2fs_close_free(&fs);
 		}
 
 		switch (arg_type) {
-- 
2.18.0.rc0
