From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH v1.1 1/10] ext4: Introduce DX_HASH_UNSIGNED_DELTA
Date: 23 Sep 2014 17:06:08 -0400
Message-ID: <20140923210608.27396.qmail@ns.horizon.com>
References: <20140923100352.27027.qmail@ns.horizon.com>
Cc: linux@horizon.com, tytso@mit.edu
To: adilger@dilger.ca, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:39356 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753540AbaIWVGJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 17:06:09 -0400
In-Reply-To: <20140923100352.27027.qmail@ns.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The existing hash algorithms each come in signed and unsigned variants,
with the latter indicated by EXT2_FLAGS_UNSIGNED_HASH.  Internally, ext4
represents those by adding a delta to the hash algorithm identifier that
takes them out of the range permitted on disk.

In the ext4_sb_info, s_def_hash_version is the value that actually
appears on disk, and s_hash_unsigned is the extra delta that is
inferred from the flags.

It used to be simply the magic value 3, but give it a symbolic name so
it can be changed freely if more on-disk values are added.

Signed-off-by: George Spelvin <linux@horizon.com>
---
This is my draft with clarified comments.  Any better?

 fs/ext4/ext4.h  | 16 ++++++++++++----
 fs/ext4/super.c |  7 ++++---
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1bbe7c31..07b13c7c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1216,7 +1216,7 @@ struct ext4_sb_info {
 	u32 s_next_generation;
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
-	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
+	int s_hash_unsigned;	/* DX_HASH_UNSIGNED_DELTA, or 0 if signed */
 	struct percpu_counter s_freeclusters_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
@@ -1737,9 +1737,17 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_LEGACY		0
 #define DX_HASH_HALF_MD4	1
 #define DX_HASH_TEA		2
-#define DX_HASH_LEGACY_UNSIGNED	3
-#define DX_HASH_HALF_MD4_UNSIGNED	4
-#define DX_HASH_TEA_UNSIGNED		5
+
+#define DX_HASH_UNSIGNED_DELTA	3 /* One more than ever appears on disk! */
+
+/*
+ * For historical reasons, the first three hash algorithms
+ * have signed and unsigned variants.  The following values
+ * never appear on disk, but are used by the software.
+ */
+#define DX_HASH_LEGACY_UNSIGNED   (DX_HASH_LEGACY   + DX_HASH_UNSIGNED_DELTA)
+#define DX_HASH_HALF_MD4_UNSIGNED (DX_HASH_HALF_MD4 + DX_HASH_UNSIGNED_DELTA)
+#define DX_HASH_TEA_UNSIGNED      (DX_HASH_TEA      + DX_HASH_UNSIGNED_DELTA)
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4566c2fe..6eb2c47a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3721,16 +3721,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-	if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
+	if (sbi->s_def_hash_version <= DX_HASH_TEA &&
+	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_DIR_INDEX)) {
 		i = le32_to_cpu(es->s_flags);
 		if (i & EXT2_FLAGS_UNSIGNED_HASH)
-			sbi->s_hash_unsigned = 3;
+			sbi->s_hash_unsigned = DX_HASH_UNSIGNED_DELTA;
 		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
 #ifdef __CHAR_UNSIGNED__
 			if (!(sb->s_flags & MS_RDONLY))
 				es->s_flags |=
 					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-			sbi->s_hash_unsigned = 3;
+			sbi->s_hash_unsigned = DX_HASH_UNSIGNED_DELTA;
 #else
 			if (!(sb->s_flags & MS_RDONLY))
 				es->s_flags |=
-- 
2.1.0

