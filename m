From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't try to modify s_flags if the the file system is read-only
Date: Wed, 12 Feb 2014 12:17:49 -0500
Message-ID: <1392225469-5163-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57131 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaBLRRx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Feb 2014 12:17:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an ext4 file system is created by some tool other than mke2fs
(perhaps by someone who has a pathalogical fear of the GPL) that
doesn't set one or the other of the EXT2_FLAGS_{UN}SIGNED_HASH flags,
and that file system is then mounted read-only, don't try to modify
the s_flags field.  Otherwise, if dm_verity is in use, the superblock
will change, causing an dm_verity failure.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0491c81..8161c28 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3695,16 +3695,22 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	i = le32_to_cpu(es->s_flags);
-	if (i & EXT2_FLAGS_UNSIGNED_HASH)
-		sbi->s_hash_unsigned = 3;
-	else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
+	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+		i = le32_to_cpu(es->s_flags);
+		if (i & EXT2_FLAGS_UNSIGNED_HASH)
+			sbi->s_hash_unsigned = 3;
+		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
 #ifdef __CHAR_UNSIGNED__
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-		sbi->s_hash_unsigned = 3;
+			if (sb->s_flags & MS_RDONLY)
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
+			sbi->s_hash_unsigned = 3;
 #else
-		es->s_flags |= cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
+			if (sb->s_flags & MS_RDONLY)
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
 #endif
+		}
 	}
 
 	/* Handle clustersize */
-- 
1.8.5.rc3.362.gdf10213

