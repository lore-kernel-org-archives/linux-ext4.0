From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Clean up applications to not use EXT2FS_ENABLE_SWAPFS or EXT2_FLAG_SWAP_BYTES
Date: Sun, 12 Aug 2007 12:57:20 -0400
Message-ID: <11869378423190-git-send-email-tytso@mit.edu>
References: <20070809214254.GB5438@thunk.org>
 <1186937841369-git-send-email-tytso@mit.edu>
 <11869378411811-git-send-email-tytso@mit.edu>
 <11869378412404-git-send-email-tytso@mit.edu>
 <11869378412289-git-send-email-tytso@mit.edu>
 <1186937842710-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: jrs@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46665 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925AbXHLQ6j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Aug 2007 12:58:39 -0400
In-Reply-To: <1186937842710-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/logdump.c |    2 +-
 e2fsck/journal.c  |    2 +-
 e2fsck/util.c     |    2 +-
 misc/dumpe2fs.c   |    7 -------
 misc/e2image.c    |    8 +++-----
 5 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 2bf67b5..724193e 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -350,7 +350,7 @@ static void dump_journal(char *cmdname, FILE *out_file,
 
 	jsb = (journal_superblock_t *) buf;
 	sb = (struct ext2_super_block *) (buf+1024);
-#ifdef ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 	if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC)) 
 		ext2fs_swap_super(sb);
 #endif
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 756bbcb..eebd22f 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -385,7 +385,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + 1024,
 		       sizeof(jsuper));
 		brelse(bh);
-#ifdef EXT2FS_ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 		if (jsuper.s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC)) 
 			ext2fs_swap_super(&jsuper);
 #endif
diff --git a/e2fsck/util.c b/e2fsck/util.c
index 59a08b9..ba7ef4a 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -481,7 +481,7 @@ blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
 		if (io_channel_read_blk(io, superblock,
 					-SUPERBLOCK_SIZE, buf))
 			continue;
-#ifdef EXT2FS_ENABLE_SWAPFS
+#ifdef WORDS_BIGENDIAN
 		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
 			ext2fs_swap_super(sb);
 #endif
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b1dc607..d4d95bb 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -344,7 +344,6 @@ int main (int argc, char ** argv)
 	int		force = 0;
 	int		flags;
 	int		header_only = 0;
-	int		big_endian;
 	int		c;
 
 #ifdef ENABLE_NLS
@@ -415,12 +414,6 @@ int main (int argc, char ** argv)
 	if (print_badblocks) {
 		list_bad_blocks(fs, 1);
 	} else {
-		big_endian = ((fs->flags & EXT2_FLAG_SWAP_BYTES) != 0);
-#ifdef WORDS_BIGENDIAN
-		big_endian = !big_endian;
-#endif
-		if (big_endian)
-			printf(_("Note: This is a byte-swapped filesystem\n"));
 		list_super (fs->super);
 		if (fs->super->s_feature_incompat &
 		      EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
diff --git a/misc/e2image.c b/misc/e2image.c
index dd13cea..1fbb267 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -346,9 +346,8 @@ static void scramble_dir_block(ext2_filsys fs, blk_t blk, char *buf)
 	for (p = buf; p < end-8; p += rec_len) {
 		dirent = (struct ext2_dir_entry_2 *) p;
 		rec_len = dirent->rec_len;
-#ifdef EXT2FS_ENABLE_SWAPFS
-		if (fs->flags & EXT2_FLAG_SWAP_BYTES) 
-			rec_len = ext2fs_swab16(rec_len);
+#ifdef WORDS_BIGENDIAN
+		rec_len = ext2fs_swab16(rec_len);
 #endif
 #if 0
 		printf("rec_len = %d, name_len = %d\n", rec_len, dirent->name_len);
@@ -359,8 +358,7 @@ static void scramble_dir_block(ext2_filsys fs, blk_t blk, char *buf)
 			       "bad rec_len (%d)\n", (unsigned long) blk, 
 			       rec_len);
 			rec_len = end - p;
-#ifdef EXT2FS_ENABLE_SWAPFS
-			if (fs->flags & EXT2_FLAG_SWAP_BYTES) 
+#ifdef WORDS_BIGENDIAN
 				dirent->rec_len = ext2fs_swab16(rec_len);
 #endif
 			continue;
-- 
1.5.3.rc4.67.gf9286
