Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FFA37CD2F
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 21:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776461863; cv=none; b=CJGQywkxI2Ec24vp8UpKweHtMinVpRvsnMaap/LAEdcnF+VAVPYQUV/092i5Ud9aFUGuLuW4g2LVoowAg+DxNtcXxQbocCP1BwJDuEow7j746UdG4/o9+Yb9nOgg7gelaBPn8IDcyk1aB85PR8LCPha0NkHrhVeisC08AJ6FNrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776461863; c=relaxed/simple;
	bh=gEm4GekL+CeEFYSr4ZYmEllAm+8MnwLP+JusDakRilY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSOG9zVNJLZ+YLgtxoQPMhwqf0JxIiaez3Cnyx1/c/DizzDQ+lz/BDOQ8OrqNjn+GrAme/9L+mkXMBpH1YSa0k5S3XQSgITlUbDZdplfpd97UfqZCpi2H4LJ7Nd9AXLXjrnYb51MBygJvxq5qb6X4806BphEBmPWh3xD+qyXNPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=blEsfkZ0; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="blEsfkZ0"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4887fd35e60so7306685e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 14:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776461859; x=1777066659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81rBFMMXVe/MdUhbExIXCzmGWZB3MRuXFLnT+ibcJhc=;
        b=blEsfkZ0y9XhBWlXznanvI1LJAU920GfDCdTpgAlgZYfRH3NIgpqvwOCjgKXNEGJOq
         zqLrup7Jryg7GQAtWtXC5DAZ5iOQwMR6UCDH7sqP3aQ4dz41HQ4kVVjzqCe/ZP8xtyth
         S/eeac0wXWFYAmwDyixorffBSReK6Sxy8EJ2bErxUKc/EL63T5RmUxPhEP6oO1C5QBM3
         InCLWfdOpnStXqogllzFWwVfFOvB3vNgNV5f9X4L+Mo+0HS2qsatEqbDztks+gy8zX46
         ePBBmLBgGew1UhoSssRNdywYYP0CHfHjoqLwXL9ZrxppYZuDbfTDbzQ/d/hwghVTiVWV
         4bCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776461859; x=1777066659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=81rBFMMXVe/MdUhbExIXCzmGWZB3MRuXFLnT+ibcJhc=;
        b=dm9qq5rG7t8LYRJ+QlPjYG6UVoGDpdbc+96pR5+GgSWzRVRKXr1mguhdkXmOPAttMO
         VNadaHlmEdCFRmIn0KKkfMmoQuxKovFuLbqMgWtUe4hZID9YHWiSPj6+2PZ909XDdHlr
         1eS2b4d8X0RsCF5V48NtGd6OwsQPFvmXXwjG7RlfK2DJIAdX3iZWN6VJido13ymlYCIo
         enstlxtqqhU6tPMm5A3JRn2uiUjCSQ6jGTWipQxFhlrhOTapw6QHC5qIkY311ER/ftF+
         aole2Zk1oxjNL3ArVpfM0sU9ZzQfA6pxFCeDAVs/j3j/i9TIRdgpqeEdHjozezsGMbjZ
         f5sw==
X-Gm-Message-State: AOJu0Yz6ABeKAn8jompHr0+Ie39/j5VuuJh1eHRIxUoTmo2Z4j9snk2S
	H44Y/u5t6y2tKVqISQSrXHiWcrG2Kub2TKndAbRnQ8SJMQ5Gt7SpFqyigU7lWg==
X-Gm-Gg: AeBDietI1MdQdtXhakNIPLrepq1F+hYjDPG5TE+ljSIb3zxKTdYDr+EQir1S/9WyiGT
	iurGkYD2aX4XFY8ZaItbuTWdv9yolWCD/BuP95ey35E27EFxQlyRJS2iox3BJscdFBSzk9i/KVu
	6KN8XJW/to7F2yelSaAX45DFHCqvW57iM0nNvnETuYuPirQook3V6zPGhy1E5Xfpl3vsqjl87K1
	OfjQKBS3DvpRxHEkj1tm/m6XrggZsuTiwVxPcc2eqKBe9XXz8x5c0qJPaZyrp7gfvVGI3Isnlot
	BkQnAgmO4PYfCbLvWpAiRKfrWiyE8MeIiYFnQSIUSkHA4UjS1uMYsf3wjJk6F08BS1Axv/H2Hkb
	A6LealZppR8yAUOaGhbBOFp6AXC96jADPCIjU8q9YagFw9wI/AukiJsbvxWah8E7S36TkREYDIl
	rD9rxl7Z1PZTM5MTkRmwWF2mjgRHvJ7heZWjT5iRo803ce1XiUbVxo3HjWKEZtRmlLEBSbaxu1r
	BIvKL80VX2rTslpDwqlV8g=
X-Received: by 2002:a05:600c:890c:b0:485:3ff1:d5ed with SMTP id 5b1f17b1804b1-488fb739cd9mr49005835e9.1.1776461859263;
        Fri, 17 Apr 2026 14:37:39 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c7:90c1:9201:f5b4:1568:453c:b849])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb762f56sm25725645e9.15.2026.04.17.14.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:37:38 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 3/3] ext4: dirdata feature
Date: Fri, 17 Apr 2026 22:37:20 +0100
Message-ID: <20260417213723.74204-4-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fscrypt and casefold are enabled together for a directory,
all ext4_dir_entry[_2] in that directory store a n 8-byte hash
of the filename after 'name' between 'name_len' and 'rec_len'.

However, there is no clear indication there is important data
stored in these bytes, which are only for padding and alignment
in other directory entries.  This adds complexity to code handling
the on-disk directory entries, and there is no provision for other
metadata to be stored in each dir entry after 'name'.

The dirdata feature adds a mechanism to store multiple metadata
entries in each dir entry after 'name' (including the fchash).
The unused high 4 bits of 'file_type' are used to indicate whether
additional data fields are stored after 'name'.  If a bit is set,
the corresponding dirdata record is present, starting after a NUL
filename terminator.  If present, a record starts with a 1-byte
length (including the length byte itself) and the data immediately
follows the length byte without any alignment.

This allows up to four different dirdata records to be stored in
each entry, and allows unhandled record bytes to be skipped without
having to process the contents, providing forward compatibility.

If and when the fourth and last dirdata record is needed, it is
recommended to further subdivide it into sub-records, with
the first byte being the total length, and then there being a
second byte that gives the sub-record length, etc. as long as
the total record length is less than 255 bytes.  However, this
would not affect compatibility with the current code since the
record length would allow it to be skipped without processing.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c    |   9 +-
 fs/ext4/ext4.h   |  50 +++++++++---
 fs/ext4/inline.c |  22 ++---
 fs/ext4/namei.c  | 208 ++++++++++++++++++++++++++++++++++++-----------
 fs/ext4/super.c  |   4 +-
 fs/ext4/sysfs.c  |   2 +
 6 files changed, 219 insertions(+), 76 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 28b2a3deb954..08833524e499 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -89,16 +89,15 @@ int __ext4_check_dir_entry(const char *function, unsigned int line,
 	bool fake = is_fake_dir_entry(de);
 	bool has_csum = ext4_has_feature_metadata_csum(dir->i_sb);
 
-	if (unlikely(rlen < ext4_dir_rec_len(1, fake ? NULL : dir)))
+	if (unlikely(rlen < ext4_dirent_rec_len(1, fake ? NULL : dir)))
 		error_msg = "rec_len is smaller than minimal";
 	else if (unlikely(rlen % 4 != 0))
 		error_msg = "rec_len % 4 != 0";
-	else if (unlikely(rlen < ext4_dir_rec_len(de->name_len,
-							fake ? NULL : dir)))
+	else if (unlikely(rlen < ext4_dir_entry_len(de, fake ? NULL : dir)))
 		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
+	else if (unlikely(next_offset > size - ext4_dirent_rec_len(1,
 						  has_csum ? NULL : dir) &&
 			  next_offset != size))
 		error_msg = "directory entry too close to block end";
@@ -245,7 +244,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 				 * failure will be detected in the
 				 * dirent test below. */
 				if (ext4_rec_len_from_disk(de->rec_len,
-					sb->s_blocksize) < ext4_dir_rec_len(1,
+					sb->s_blocksize) < ext4_dirent_rec_len(1,
 									inode))
 					break;
 				i += ext4_rec_len_from_disk(de->rec_len,
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 09d277e24dde..28271d42bfaf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1217,6 +1217,7 @@ struct ext4_inode_info {
  * Mount flags set via mount options or defaults
  */
 #define EXT4_MOUNT_NO_MBCACHE		0x00001 /* Do not use mbcache */
+#define EXT4_MOUNT_DIRDATA		0x00002 /* Data in directory entries */
 #define EXT4_MOUNT_GRPID		0x00004	/* Create files with directory's group */
 #define EXT4_MOUNT_DEBUG		0x00008	/* Some debugging messages */
 #define EXT4_MOUNT_ERRORS_CONT		0x00010	/* Continue on errors */
@@ -2253,6 +2254,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
 					 EXT4_FEATURE_INCOMPAT_CSUM_SEED | \
 					 EXT4_FEATURE_INCOMPAT_LARGEDIR)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
@@ -2937,11 +2939,20 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
-void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de,
+			     int buf_size,
+			     struct ext4_filename *fname,
+			     void *data);
+static inline void ext4_insert_dentry(struct inode *dir, struct inode *inode,
+				      struct ext4_dir_entry_2 *de,
+				      int buf_size,
+				      struct ext4_filename *fname)
+{
+	ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
+}
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!ext4_has_feature_dir_index(inode->i_sb) &&
@@ -2955,9 +2966,9 @@ static const unsigned char ext4_filetype_table[] = {
 	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
 };
 
-static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
+static inline unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	unsigned char  fl_index = filetype & EXT4_FT_MASK;
+	unsigned char fl_index = filetype & EXT4_FT_MASK;
 
 	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
@@ -3186,8 +3197,17 @@ extern int ext4_ext_migrate(struct inode *);
 extern int ext4_ind_migrate(struct inode *inode);
 
 /* namei.c */
-extern int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode);
+extern int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+				  struct inode *inode,
+				  const void *data1, const void *data2);
+static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
+				    struct inode *inode)
+{
+	return ext4_init_new_dir_data(handle, dir, inode, NULL, NULL);
+}
+extern int ext4_add_dot_dotdot(handle_t *handle, struct inode *dir,
+			       struct inode *inode,
+			       const void *data1, const void *data2);
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
@@ -3762,6 +3782,9 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       struct dentry *dentry);
+extern unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de,
+				      struct inode *dir,
+				      void *data, u32 *hash, u32 *minor_hash);
 
 #define S_SHIFT 12
 static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
@@ -4007,7 +4030,14 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
 
 	while (extra_data_flags) {
 		if (extra_data_flags & 1) {
-			dlen += ddh->ddh_length + (dlen == 0);
+			/*
+			 * The first dirdata field is preceded by a NUL
+			 * terminator byte that is already included in ddh's
+			 * pointer offset, but must be counted in dlen.
+			 */
+			if (dlen == 0)
+				dlen = 1; /* NUL terminator */
+			dlen += ddh->ddh_length;
 			ddh = ext4_dirdata_next(ddh);
 		}
 		extra_data_flags >>= 1;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1f6bc05593df..071a637c8869 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -969,7 +969,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	struct ext4_dir_entry_2 *de;
 
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de);
+				inline_size, fname, &de, 0);
 	if (err)
 		return err;
 
@@ -978,7 +978,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, NULL);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1047,7 +1047,7 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
 	int new_size = get_max_inline_xattr_value_size(dir, iloc);
 
-	if (new_size - old_size <= ext4_dir_rec_len(1, NULL))
+	if (new_size - old_size <= ext4_dirent_rec_len(1, NULL))
 		return -ENOSPC;
 
 	ret = ext4_update_inline_data(handle, dir,
@@ -1301,7 +1301,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 1;
 			memcpy(fake.name, ".", 2);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1311,7 +1311,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 2;
 			memcpy(fake.name, "..", 3);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1327,9 +1327,9 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			}
 		}
 
-		if (ext4_hash_in_dirent(dir)) {
-			hinfo->hash = EXT4_DIRENT_HASH(de);
-			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+		if (ext4_dirdata_get(de, dir, NULL, &hinfo->hash,
+				     &hinfo->minor_hash) & EXT4_DIRENT_CFHASH) {
+			/* hash retrieved from dirdata or inline hash */
 		} else {
 			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 			if (err) {
@@ -1419,8 +1419,8 @@ int ext4_read_inline_dir(struct file *file,
 	 * So we will use extra_offset and extra_size to indicate them
 	 * during the inline dir iteration.
 	 */
-	dotdot_offset = ext4_dir_rec_len(1, NULL);
-	dotdot_size = dotdot_offset + ext4_dir_rec_len(2, NULL);
+	dotdot_offset = ext4_dirent_rec_len(1, NULL);
+	dotdot_size = dotdot_offset + ext4_dirent_rec_len(2, NULL);
 	extra_offset = dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
 	extra_size = extra_offset + inline_size;
 
@@ -1455,7 +1455,7 @@ int ext4_read_inline_dir(struct file *file,
 			 * failure will be detected in the
 			 * dirent test below. */
 			if (ext4_rec_len_from_disk(de->rec_len, extra_size)
-				< ext4_dir_rec_len(1, NULL))
+				< ext4_dirent_rec_len(1, NULL))
 				break;
 			i += ext4_rec_len_from_disk(de->rec_len,
 						    extra_size);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index ab2b4bb4a93d..3d478d7ef339 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -305,7 +305,6 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 						   struct buffer_head *bh)
 {
 	struct ext4_dir_entry_tail *t;
-	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
 	struct ext4_dir_entry *d, *top;
@@ -402,23 +401,24 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 {
 	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
-	int count_offset;
+	int count_offset, dot_rec_len, dotdot_rec_len;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
-	if (rlen == blocksize)
+	if (rlen == blocksize) {
 		count_offset = 8;
-	else if (rlen == 12) {
-		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
+	} else {
+		dot_rec_len = le16_to_cpu(dirent->rec_len);
+		de = (struct ext4_dir_entry_2 *)(((char *)dirent) + dot_rec_len);
+		if (le16_to_cpu(de->rec_len) != (blocksize - dot_rec_len))
 			return NULL;
-		root = (struct dx_root_info *)(((void *)de + 12));
+		dotdot_rec_len = ext4_dir_entry_len((struct ext4_dir_entry_2 *)de, NULL);
+		root = (struct dx_root_info *)(((char *)de + dotdot_rec_len));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
-		count_offset = 32;
-	} else
-		return NULL;
+		count_offset = 8 + dot_rec_len + dotdot_rec_len;
+	}
 
 	if (offset)
 		*offset = count_offset;
@@ -590,7 +590,7 @@ static inline unsigned dx_root_limit(struct inode *dir,
 static inline unsigned dx_node_limit(struct inode *dir)
 {
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dirent_rec_len(0, dir);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -700,7 +700,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			space += ext4_dir_entry_len(de, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -1062,7 +1062,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1087,21 +1087,20 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			/* silently ignore the rest of the block */
 			break;
 		}
-		if (ext4_hash_in_dirent(dir)) {
-			if (de->name_len && de->inode) {
-				hinfo->hash = EXT4_DIRENT_HASH(de);
-				hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
-			} else {
-				hinfo->hash = 0;
-				hinfo->minor_hash = 0;
-			}
-		} else {
+		if (de->name_len && de->inode &&
+		    (ext4_dirdata_get(de, dir, NULL, &hinfo->hash,
+				      &hinfo->minor_hash) & EXT4_DIRENT_CFHASH)) {
+			/* hash retrieved from dirdata or inline hash */
+		} else if (de->name_len && de->inode) {
 			err = ext4fs_dirhash(dir, de->name,
 					     de->name_len, hinfo);
 			if (err < 0) {
 				count = err;
 				goto errout;
 			}
+		} else {
+			hinfo->hash = 0;
+			hinfo->minor_hash = 0;
 		}
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
@@ -1280,9 +1279,95 @@ static inline int search_dirblock(struct buffer_head *bh,
  */
 
 /*
- * Create map of hash values, offsets, and sizes, stored at end of block.
- * Returns number of entries mapped.
+ * ext4_dirdata_get() - Read dirdata fields from a directory entry.
+ * @de:         directory entry
+ * @dir:        directory inode (used for fscrypt+casefold hash fallback)
+ * @data:       if non-NULL and EXT4_DIRENT_LUFID is set, LUFID data is copied here
+ * @hash:       if non-NULL, receives the casefold hash
+ * @minor_hash: if non-NULL, receives the casefold minor hash
+ *
+ * Reads any dirdata stored in @de.  If the dirdata feature is not enabled,
+ * falls back to reading the hash stored inline after the filename (for
+ * compatibility with the older casefold+fscrypt format).
+ *
+ * Returns a bitmask of EXT4_DIRENT_* flags indicating which fields were read.
+ */
+unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
+			       void *data, u32 *hash, u32 *minor_hash)
+{
+	unsigned char ret = 0;
+	int data_offset = de->name_len + 1;
+
+	/* compatibility: hash stored inline after filename (no dirdata) */
+	if (!ext4_has_feature_dirdata(dir->i_sb) && ext4_hash_in_dirent(dir)) {
+		*hash = EXT4_DIRENT_HASH(de);
+		*minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+		ret |= EXT4_DIRENT_CFHASH;
+		return ret;
+	}
+
+	/*  EXT4_DIRENT_* are not expected without flag in i_sb */
+	if (de->file_type & EXT4_DIRENT_LUFID) {
+		if (data) {
+			memcpy(data, de->name + de->name_len + 1 + 1,
+			       de->name[de->name_len + 1]);
+			ret |= EXT4_DIRENT_LUFID;
+		}
+		data_offset += de->name[data_offset] + 1;
+	}
+
+	if (!hash || !minor_hash)
+		return ret;
+
+	if (de->file_type & EXT4_DIRENT_CFHASH) {
+		struct ext4_dirent_hash *dh =
+			(struct ext4_dirent_hash *)(de->name + data_offset);
+
+		*hash = le32_to_cpu(dh->dh_hash.hash);
+		*minor_hash = le32_to_cpu(dh->dh_hash.minor_hash);
+		ret |= EXT4_DIRENT_CFHASH;
+		return ret;
+	}
+
+	return ret;
+}
+
+/*
+ * ext4_dirdata_set() - Write dirdata fields into a directory entry.
+ * @de:    directory entry (name must already be set)
+ * @dir:   directory inode
+ * @data:  LUFID data to store (or NULL)
+ * @fname: filename info carrying the casefold hash
+ *
+ * Writes any required dirdata into @de after the filename.  If the dirdata
+ * feature is not enabled, falls back to writing the hash inline after the
+ * filename (for compatibility with the older casefold+fscrypt format).
  */
+static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
+			     void *data, struct ext4_filename *fname)
+{
+	int data_offset = de->name_len + 1;
+
+	if (data) {
+		de->name[de->name_len] = 0;
+		memcpy(&de->name[de->name_len + 1], data, *(char *)data);
+		de->file_type |= EXT4_DIRENT_LUFID;
+		data_offset += *(char *)data + 1;
+	}
+
+	if (ext4_hash_in_dirent(dir)) {
+		struct ext4_dirent_hash *dh =
+			(struct ext4_dirent_hash *)(de->name + data_offset);
+		struct dx_hash_info *hinfo = &fname->hinfo;
+
+		dh->dh_header.ddh_length = sizeof(*dh);
+		dh->dh_hash.hash = cpu_to_le32(hinfo->hash);
+		dh->dh_hash.minor_hash = cpu_to_le32(hinfo->minor_hash);
+		de->file_type |= EXT4_DIRENT_CFHASH;
+	}
+}
+
+
 static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 		       struct dx_hash_info *hinfo,
 		       struct dx_map_entry *map_tail)
@@ -1302,9 +1387,9 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 					 ((char *)de) - base))
 			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
-			if (ext4_hash_in_dirent(dir))
-				h.hash = EXT4_DIRENT_HASH(de);
-			else {
+			if (!(ext4_dirdata_get(de, dir, NULL, &h.hash,
+					       &h.minor_hash) &
+						EXT4_DIRENT_CFHASH)) {
 				int err = ext4fs_dirhash(dir, de->name,
 						     de->name_len, &h);
 				if (err < 0)
@@ -1856,7 +1941,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1889,7 +1974,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2041,10 +2126,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      void *buf, int buf_size,
 		      struct ext4_filename *fname,
-		      struct ext4_dir_entry_2 **dest_de)
+		      struct ext4_dir_entry_2 **dest_de,
+		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dir_rec_len(fname_len(fname), dir);
+	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2057,7 +2143,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2071,16 +2157,17 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry(struct inode *dir,
-			struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname)
+void ext4_insert_dentry_data(struct inode *dir,
+			     struct inode *inode,
+			     struct ext4_dir_entry_2 *de,
+			     int buf_size,
+			     struct ext4_filename *fname,
+			     void *data)
 {
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2094,7 +2181,9 @@ void ext4_insert_dentry(struct inode *dir,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	if (ext4_hash_in_dirent(dir)) {
+	if (ext4_has_feature_dirdata(inode->i_sb)) {
+		ext4_dirdata_set(de, dir, data, fname);
+	} else if (ext4_hash_in_dirent(dir)) {
 		struct dx_hash_info *hinfo = &fname->hinfo;
 
 		EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(hinfo->hash);
@@ -2118,14 +2207,18 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err, err2;
+	int		err, err2, dlen = 0;
+	unsigned char	*data = NULL;
 
+	/* Deliver data in any appropriate way here. Now it is NULL */
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (!de) {
+		if (data)
+			dlen = (*data) + 1;
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de);
+					blocksize - csum_size, fname, &de, dlen);
 		if (err)
 			return err;
 	}
@@ -2138,7 +2231,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, data);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2927,7 +3020,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -2939,7 +3032,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -2948,7 +3041,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -2960,8 +3053,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	return ext4_handle_dirty_dirblock(handle, inode, bh);
 }
 
-int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode)
+int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+			   struct inode *inode,
+			   const void *data1, const void *data2)
 {
 	struct buffer_head *dir_block = NULL;
 	ext4_lblk_t block = 0;
@@ -2986,6 +3080,22 @@ int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	return err;
 }
 
+int ext4_add_dot_dotdot(handle_t *handle, struct inode *dir,
+			struct inode *inode,
+			const void *data1, const void *data2)
+{
+	struct buffer_head *dir_block = NULL;
+	ext4_lblk_t block = 0;
+	int err;
+
+	dir_block = ext4_append(handle, inode, &block);
+	if (IS_ERR(dir_block))
+		return PTR_ERR(dir_block);
+	err = ext4_init_dirblock(handle, inode, dir_block, dir->i_ino, NULL, 0);
+	brelse(dir_block);
+	return err;
+}
+
 static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 				 struct dentry *dentry, umode_t mode)
 {
@@ -3071,8 +3181,8 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 
 	sb = inode->i_sb;
-	if (inode->i_size < ext4_dir_rec_len(1, NULL) +
-					ext4_dir_rec_len(2, NULL)) {
+	if (inode->i_size < ext4_dirent_rec_len(1, NULL) +
+					ext4_dirent_rec_len(2, NULL)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return false;
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..28151a99e126 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1673,7 +1673,7 @@ enum {
 	Opt_data_err_abort, Opt_data_err_ignore, Opt_test_dummy_encryption,
 	Opt_inlinecrypt,
 	Opt_usrjquota, Opt_grpjquota, Opt_quota,
-	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err,
+	Opt_noquota, Opt_barrier, Opt_nobarrier, Opt_err, Opt_dirdata,
 	Opt_usrquota, Opt_grpquota, Opt_prjquota,
 	Opt_dax, Opt_dax_always, Opt_dax_inode, Opt_dax_never,
 	Opt_stripe, Opt_delalloc, Opt_nodelalloc, Opt_warn_on_error,
@@ -1783,6 +1783,7 @@ static const struct fs_parameter_spec ext4_param_specs[] = {
 	fsparam_u32	("stripe",		Opt_stripe),
 	fsparam_flag	("delalloc",		Opt_delalloc),
 	fsparam_flag	("nodelalloc",		Opt_nodelalloc),
+	fsparam_flag	("dirdata",		Opt_dirdata),
 	fsparam_flag	("warn_on_error",	Opt_warn_on_error),
 	fsparam_flag	("nowarn_on_error",	Opt_nowarn_on_error),
 	fsparam_u32	("debug_want_extra_isize",
@@ -1911,6 +1912,7 @@ static const struct mount_opts {
 							MOPT_CLEAR | MOPT_Q},
 	{Opt_usrjquota, 0, MOPT_Q},
 	{Opt_grpjquota, 0, MOPT_Q},
+	{Opt_dirdata, EXT4_MOUNT_DIRDATA, MOPT_SET},
 	{Opt_jqfmt, 0, MOPT_QFMT},
 	{Opt_nombcache, EXT4_MOUNT_NO_MBCACHE, MOPT_SET},
 	{Opt_no_prefetch_block_bitmaps, EXT4_MOUNT_NO_PREFETCH_BLOCK_BITMAPS,
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index b87d7bdab06a..1f5e9627e735 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -362,6 +362,7 @@ EXT4_ATTR_FEATURE(verity);
 #endif
 EXT4_ATTR_FEATURE(metadata_csum_seed);
 EXT4_ATTR_FEATURE(fast_commit);
+EXT4_ATTR_FEATURE(dirdata);
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 EXT4_ATTR_FEATURE(encrypted_casefold);
 #endif
@@ -385,6 +386,7 @@ static struct attribute *ext4_feat_attrs[] = {
 #endif
 	ATTR_LIST(metadata_csum_seed),
 	ATTR_LIST(fast_commit),
+	ATTR_LIST(dirdata),
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 	ATTR_LIST(encrypted_casefold),
 #endif
-- 
2.43.5

