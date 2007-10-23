From: akpm@linux-foundation.org
Subject: - ext2-avoid-rec_len-overflow-with-64kb-block-size.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:46:34 -0700
Message-ID: <200710230646.l9N6kYje004221@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext2: avoid rec_len overflow with 64KB block size
has been removed from the -mm tree.  Its filename was
     ext2-avoid-rec_len-overflow-with-64kb-block-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: avoid rec_len overflow with 64KB block size
From: Jan Kara <jack@suse.cz>

With 64KB blocksize, a directory entry can have size 64KB which does not
fit into 16 bits we have for entry length.  So we store 0xffff instead and
convert the value when read from / written to disk.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c           |   44 +++++++++++++++++++++++++++-----------
 include/linux/ext2_fs.h |    1 
 2 files changed, 33 insertions(+), 12 deletions(-)

diff -puN fs/ext2/dir.c~ext2-avoid-rec_len-overflow-with-64kb-block-size fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-avoid-rec_len-overflow-with-64kb-block-size
+++ a/fs/ext2/dir.c
@@ -28,6 +28,24 @@
 
 typedef struct ext2_dir_entry_2 ext2_dirent;
 
+static inline unsigned ext2_rec_len_from_disk(__le16 dlen)
+{
+	unsigned len = le16_to_cpu(dlen);
+
+	if (len == EXT2_MAX_REC_LEN)
+		return 1 << 16;
+	return len;
+}
+
+static inline __le16 ext2_rec_len_to_disk(unsigned len)
+{
+	if (len == (1 << 16))
+		return cpu_to_le16(EXT2_MAX_REC_LEN);
+	else if (len > (1 << 16))
+		BUG();
+	return cpu_to_le16(len);
+}
+
 /*
  * ext2 uses block-sized chunks. Arguably, sector-sized ones would be
  * more robust, but we have what we have
@@ -106,7 +124,7 @@ static void ext2_check_page(struct page 
 	}
 	for (offs = 0; offs <= limit - EXT2_DIR_REC_LEN(1); offs += rec_len) {
 		p = (ext2_dirent *)(kaddr + offs);
-		rec_len = le16_to_cpu(p->rec_len);
+		rec_len = ext2_rec_len_from_disk(p->rec_len);
 
 		if (rec_len < EXT2_DIR_REC_LEN(1))
 			goto Eshort;
@@ -204,7 +222,8 @@ static inline int ext2_match (int len, c
  */
 static inline ext2_dirent *ext2_next_entry(ext2_dirent *p)
 {
-	return (ext2_dirent *)((char*)p + le16_to_cpu(p->rec_len));
+	return (ext2_dirent *)((char *)p +
+			ext2_rec_len_from_disk(p->rec_len));
 }
 
 static inline unsigned 
@@ -316,7 +335,7 @@ ext2_readdir (struct file * filp, void *
 					return 0;
 				}
 			}
-			filp->f_pos += le16_to_cpu(de->rec_len);
+			filp->f_pos += ext2_rec_len_from_disk(de->rec_len);
 		}
 		ext2_put_page(page);
 	}
@@ -425,7 +444,7 @@ void ext2_set_link(struct inode *dir, st
 {
 	loff_t pos = page_offset(page) +
 			(char *) de - (char *) page_address(page);
-	unsigned len = le16_to_cpu(de->rec_len);
+	unsigned len = ext2_rec_len_from_disk(de->rec_len);
 	int err;
 
 	lock_page(page);
@@ -482,7 +501,7 @@ int ext2_add_link (struct dentry *dentry
 				/* We hit i_size */
 				name_len = 0;
 				rec_len = chunk_size;
-				de->rec_len = cpu_to_le16(chunk_size);
+				de->rec_len = ext2_rec_len_to_disk(chunk_size);
 				de->inode = 0;
 				goto got_it;
 			}
@@ -496,7 +515,7 @@ int ext2_add_link (struct dentry *dentry
 			if (ext2_match (namelen, name, de))
 				goto out_unlock;
 			name_len = EXT2_DIR_REC_LEN(de->name_len);
-			rec_len = le16_to_cpu(de->rec_len);
+			rec_len = ext2_rec_len_from_disk(de->rec_len);
 			if (!de->inode && rec_len >= reclen)
 				goto got_it;
 			if (rec_len >= name_len + reclen)
@@ -518,8 +537,8 @@ got_it:
 		goto out_unlock;
 	if (de->inode) {
 		ext2_dirent *de1 = (ext2_dirent *) ((char *) de + name_len);
-		de1->rec_len = cpu_to_le16(rec_len - name_len);
-		de->rec_len = cpu_to_le16(name_len);
+		de1->rec_len = ext2_rec_len_to_disk(rec_len - name_len);
+		de->rec_len = ext2_rec_len_to_disk(name_len);
 		de = de1;
 	}
 	de->name_len = namelen;
@@ -550,7 +569,8 @@ int ext2_delete_entry (struct ext2_dir_e
 	struct inode *inode = mapping->host;
 	char *kaddr = page_address(page);
 	unsigned from = ((char*)dir - kaddr) & ~(ext2_chunk_size(inode)-1);
-	unsigned to = ((char*)dir - kaddr) + le16_to_cpu(dir->rec_len);
+	unsigned to = ((char *)dir - kaddr) +
+				ext2_rec_len_from_disk(dir->rec_len);
 	loff_t pos;
 	ext2_dirent * pde = NULL;
 	ext2_dirent * de = (ext2_dirent *) (kaddr + from);
@@ -574,7 +594,7 @@ int ext2_delete_entry (struct ext2_dir_e
 							&page, NULL);
 	BUG_ON(err);
 	if (pde)
-		pde->rec_len = cpu_to_le16(to - from);
+		pde->rec_len = ext2_rec_len_to_disk(to - from);
 	dir->inode = 0;
 	err = ext2_commit_chunk(page, pos, to - from);
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME_SEC;
@@ -610,14 +630,14 @@ int ext2_make_empty(struct inode *inode,
 	memset(kaddr, 0, chunk_size);
 	de = (struct ext2_dir_entry_2 *)kaddr;
 	de->name_len = 1;
-	de->rec_len = cpu_to_le16(EXT2_DIR_REC_LEN(1));
+	de->rec_len = ext2_rec_len_to_disk(EXT2_DIR_REC_LEN(1));
 	memcpy (de->name, ".\0\0", 4);
 	de->inode = cpu_to_le32(inode->i_ino);
 	ext2_set_de_type (de, inode);
 
 	de = (struct ext2_dir_entry_2 *)(kaddr + EXT2_DIR_REC_LEN(1));
 	de->name_len = 2;
-	de->rec_len = cpu_to_le16(chunk_size - EXT2_DIR_REC_LEN(1));
+	de->rec_len = ext2_rec_len_to_disk(chunk_size - EXT2_DIR_REC_LEN(1));
 	de->inode = cpu_to_le32(parent->i_ino);
 	memcpy (de->name, "..\0", 4);
 	ext2_set_de_type (de, inode);
diff -puN include/linux/ext2_fs.h~ext2-avoid-rec_len-overflow-with-64kb-block-size include/linux/ext2_fs.h
--- a/include/linux/ext2_fs.h~ext2-avoid-rec_len-overflow-with-64kb-block-size
+++ a/include/linux/ext2_fs.h
@@ -561,6 +561,7 @@ enum {
 #define EXT2_DIR_ROUND 			(EXT2_DIR_PAD - 1)
 #define EXT2_DIR_REC_LEN(name_len)	(((name_len) + 8 + EXT2_DIR_ROUND) & \
 					 ~EXT2_DIR_ROUND)
+#define EXT2_MAX_REC_LEN		((1<<16)-1)
 
 static inline ext2_fsblk_t
 ext2_group_first_block_no(struct super_block *sb, unsigned long group_no)
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
