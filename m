From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: short-cut orphan cleanup on error
Date: Sun, 10 Jul 2016 00:50:04 +0200
Message-ID: <1468104604-18997-1-git-send-email-vegard.nossum@oracle.com>
Cc: linux-ext4@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17385 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbcGIWuP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 9 Jul 2016 18:50:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we encounter a filesystem error during orphan cleanup, we should stop.
Otherwise, we may end up in an infinite loop where the same inode is
processed again and again.

    EXT4-fs (loop0): warning: checktime reached, running e2fsck is recommended
    EXT4-fs error (device loop0): ext4_mb_generate_buddy:758: group 2, block bitmap and bg descriptor inconsistent: 6117 vs 0 free clusters
    Aborting journal on device loop0-8.
    EXT4-fs (loop0): Remounting filesystem read-only
    EXT4-fs error (device loop0) in ext4_free_blocks:4895: Journal has aborted
    EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
    EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
    EXT4-fs error (device loop0) in ext4_ext_remove_space:3068: IO failure
    EXT4-fs error (device loop0) in ext4_ext_truncate:4667: Journal has aborted
    EXT4-fs error (device loop0) in ext4_orphan_del:2927: Journal has aborted
    EXT4-fs error (device loop0) in ext4_do_update_inode:4893: Journal has aborted
    EXT4-fs (loop0): Inode 16 (00000000618192a0): orphan list check failed!
    [...]
    EXT4-fs (loop0): Inode 16 (0000000061819748): orphan list check failed!
    [...]
    EXT4-fs (loop0): Inode 16 (0000000061819bf0): orphan list check failed!
    [...]

See-also: c9eb13a9105 ("ext4: fix hang when processing corrupted orphaned inode list")
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/super.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 05ec0a7..b92802d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2284,6 +2284,16 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 	while (es->s_last_orphan) {
 		struct inode *inode;
 
+		/*
+		 * We may have encountered an error during cleanup; if
+		 * so, skip the rest.
+		 */
+		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
+			jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+			es->s_last_orphan = 0;
+			break;
+		}
+
 		inode = ext4_orphan_get(sb, le32_to_cpu(es->s_last_orphan));
 		if (IS_ERR(inode)) {
 			es->s_last_orphan = 0;
-- 
1.9.1

