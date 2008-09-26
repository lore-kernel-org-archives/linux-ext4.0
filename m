From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 5/10] gfs2: Fix error handling in write_super_lockfs/unlockfs
Date: Fri, 26 Sep 2008 17:58:21 +0900
Message-ID: <20080926175821t-sato__11499.9034595259$1222419662$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60757 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbYIZI6p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 04:58:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changed write_super_lockfs so that it returns an error in case of an failure.
unlockfs always returns 0.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 ops_super.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-reiserfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super
.c linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c
--- linux-2.6.27-rc7-lockfs-reiserfs/fs/gfs2/ops_super.c	2008-09-26 12:24:01.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-gfs2/fs/gfs2/ops_super.c	2008-09-26 17:02:06.000000000 +0900
@@ -161,18 +161,18 @@ static int gfs2_sync_fs(struct super_blo
 }
 
 /**
- * gfs2_write_super_lockfs - prevent further writes to the filesystem
+ * gfs2_freeze - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return -EINVAL;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -192,17 +192,19 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
- * gfs2_unlockfs - reallow writes to the filesystem
+ * gfs2_unfreeze - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unfreeze(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
@@ -505,8 +507,8 @@ const struct super_operations gfs2_super
 	.put_super		= gfs2_put_super,
 	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
-	.write_super_lockfs 	= gfs2_write_super_lockfs,
-	.unlockfs		= gfs2_unlockfs,
+	.freeze_fs 		= gfs2_freeze,
+	.unfreeze_fs		= gfs2_unfreeze,
 	.statfs			= gfs2_statfs,
 	.remount_fs		= gfs2_remount_fs,
 	.clear_inode		= gfs2_clear_inode,
