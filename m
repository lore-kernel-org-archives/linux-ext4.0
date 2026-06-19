Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0303254A8
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896322; cv=none; b=ndrC0LyyERLlfwXu5LUI2KYZwb0KgFbRyYkhd5zhbGJdbBrTAd17v0Jl60HpkNTfguoZl7Z9xJWk+fo3JVAkFbTk159zZ/+T+yw0ymd3jcl8aUUJGEp/bZJApj8mRRprrEJlUPGL9Wzgiupl5AkuwojIi/Aa+E1noFZWA76O6k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896322; c=relaxed/simple;
	bh=TRWFV4qmsnmEdOllb78K0pGgfX/XnL6T6fi/31MUNnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=is7QuNqXcelQ3lMWN3FwxEA6R/QYggoc3RFrwidAPAUOZgcK2aB+ImlsUWaTetRN0VtI1RHTT528s1bEETPu9ZKaAepAeIM/VaHm6ga9qtrh+X/DQ0BQQl1uA8/U8ZCzsclks8nLSvzhLnWFE/g6jvuOujwi8UgBGCnUmKkOhpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UT66cUC8; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UT66cUC8"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49249707788so396775e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896319; x=1782501119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bxpDeuXvYdzNz8tijnqXDPnJtNHyMhBHrafRy1Cx+o=;
        b=UT66cUC8PhKSflBoV5VVMb2I9N37Tg1zOJ+GWeSvpQUTnifKSSiI9eegYLfXgZwjWX
         ahr/pI5+LqPgJDWsVJxvOz19vvWy0gAtx9eBLv+e0iOA2h/faskkwQ7KASyy7ry1+mvE
         /iAszDnemMiIPa9zpa36Sq19bRKkO20gufNh+bEIFeOFxC9fUUX2XXcG8HojfjPpFn0M
         L/MHgs9w8+axioCk8STVLjQj+tQtOFdWPNdDdwjFm2C2r4vCKBA3gNkJLekahpSy5GvG
         hf+vMBSK2czf0UWCThB4NSn4gDtcyoE0kvgqjahXO1cOAuNJmu3JHN5oM8BWyua/MEBq
         TcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896319; x=1782501119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5bxpDeuXvYdzNz8tijnqXDPnJtNHyMhBHrafRy1Cx+o=;
        b=spTi2pt/03dgyT5DfQIRUzbG2UWOOX1HJ23qZaDIAOWw68JdnDKRUP856hL9DOJMDx
         a8NgUxMp8t6KZNCWcm6Z6C79FQ/RPH9QX5NtECujAjgGNCqWxWkeJRvjdm1WlgI2NcX8
         TVY4Y5K17PZwlx0noeF8r78MDeq8UVBhp5WSrDbMI2kjLy2RPUkEVTd/uWTLJ7LQd1dn
         L1+jan4wdxx1lvCN4vi5rPd1VuuG3LF9tUP6pFNJg7IZskUv4O4U/p0kI29+j6PA4bmz
         fDfiBuv1fTtR4em3q44Sr2xZ86Xc/7mFDCL8NUYSBsvBeWkDfAe9gdQ89+ikfjhVbsGp
         pWbQ==
X-Gm-Message-State: AOJu0YxiAqGhu0uMgh8GQzuFOENnwoyieOPqLgOYlvJpFI03mxxprOYg
	+6kNWzhOwfhYE7PL56n4Oi7V9+/rcWr3x9zq+COdVNp1RUeRKCwjc9kS79IvbtL+h9a0xQ==
X-Gm-Gg: AfdE7ckf2WMlvatcCQ3M2nYg1fqD2PkEews0Z1gTEdBGQJZQkJ4r1HHH/qJSGAJv+9I
	TOBtGomxDJUKM4xePh0SaAEZDSpQo+7aiB1MkvvFgo60QLlFllY+K7dxT6G7LHznv1I/BkA8K1g
	DYxdJEkjIBn64nTIf+4u5b0GX3EYjKhJVMK5NdYRXAGSrgneEkgWgWREt4fBuF+zALmNAj2ojhn
	LtbeGC4EnYC6MU7vptjjqU4dY4eDFozKahhjDZHWgYJbBY2japtHN9xwhqw4TxDKe6RRL6tUBWa
	H+FyCF3Sv+yxwmDCHlKFyWlBEynG6eGFKfgw4n3OMwry7y5SlbGsmU5NMo9yojXvTgZNBESlGIE
	6rliyNoQcoY85X5quZa6KMQEPNH+qLWPYoZ8XbvwLKo+DGnYrjpb6ZumCiXbdKpQ96+KWi61ooh
	W/0Jp0Ha5jzl3SkDkOk3Eca9Y08rWIT3InqjnxCvZVMw==
X-Received: by 2002:a05:600c:500d:b0:492:37b7:6080 with SMTP id 5b1f17b1804b1-49249083ccamr8051385e9.7.1781896318717;
        Fri, 19 Jun 2026 12:11:58 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:58 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 08/10] ext4: dirdata feature
Date: Fri, 19 Jun 2026 15:10:12 -0400
Message-ID: <20260619191022.27008-9-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
References: <20260619191022.27008-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

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
 fs/ext4/ext4.h   | 27 +++++++++++++++++++++------
 fs/ext4/inline.c | 19 +++++++++++++++----
 fs/ext4/namei.c  | 43 +++++++++++++++++++++----------------------
 fs/ext4/sysfs.c  |  2 ++
 4 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 682dd141072d..d4ec450c05f2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2334,6 +2334,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_EA_INODE| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \
@@ -3035,10 +3036,18 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 **dest_de,
 			     int dlen);
-void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname);
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
@@ -3283,8 +3292,14 @@ extern int ext4_ext_migrate(struct inode *);
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
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 5b3faacdf143..c57a8ebe4f94 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -973,11 +973,16 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 				     struct ext4_iloc *iloc,
 				     void *inline_start, int inline_size)
 {
-	int		err;
+	int		err, dlen = 0;
 	struct ext4_dir_entry_2 *de;
+	unsigned char *data = NULL;
+
+	/* Deliver data in any appropriate way here. Now it is NULL */
+	if (data)
+		dlen = (*data) + 1;
 
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de, 0);
+				inline_size, fname, &de, dlen);
 	if (err)
 		return err;
 
@@ -986,7 +991,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, NULL);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1326,7 +1331,13 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			pos = EXT4_INLINE_DOTDOT_SIZE;
 		} else {
 			de = (struct ext4_dir_entry_2 *)(dir_buf + pos);
-			pos += ext4_rec_len_from_disk(de->rec_len, inline_size);
+			/* Use ext4_dir_entry_len to account for dirdata extensions */
+			pos += ext4_dir_entry_len(de, dir);
+			/* Validate pos doesn't exceed buffer to prevent use-after-free */
+			if (pos > inline_size) {
+				ret = count;
+				goto out;
+			}
 			if (ext4_check_dir_entry(inode, dir_file, de,
 					 iloc.bh, dir_buf,
 					 inline_size, pos)) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 7bca813c0627..e230fa1094ff 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -401,23 +401,24 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 {
 	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
-	int count_offset;
+	int count_offset, dotdot_rec_len;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
-	if (rlen == blocksize)
+	if (rlen == blocksize) {
 		count_offset = sizeof(struct dx_node);
-	else if (rlen == 12) {
-		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
+	} else {
+		de = (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
+		if (le16_to_cpu(de->rec_len) != (blocksize - rlen))
 			return NULL;
-		root = (struct dx_root_info *)(((void *)de + 12));
+		/* de->rec_len covers whole dx_root block, calculate actual length */
+		dotdot_rec_len = ext4_dir_entry_len(de, inode);
+		root = (struct dx_root_info *)(((char *)de + dotdot_rec_len));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
-		count_offset = 32;
-	} else
-		return NULL;
+		count_offset = root->info_length + rlen + dotdot_rec_len;
+	}
 
 	if (offset)
 		*offset = count_offset;
@@ -707,7 +708,7 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dir_rec_len(de->name_len, dir);
+			space += ext4_dir_entry_len(de, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -2081,13 +2082,10 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry(struct inode *dir,
-			struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname)
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de, int buf_size,
+			     struct ext4_filename *fname, void *data)
 {
-
 	int nlen, rlen;
 
 	nlen = ext4_dir_entry_len(de, dir);
@@ -2129,15 +2127,15 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
 	int		err, err2, dlen = 0;
-	unsigned char	*data = NULL;
+	struct ext4_dirent_fid *dfid = NULL;
 
 	/* Deliver data in any appropriate way here. Now it is NULL */
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	if (!de) {
-		if (data)
-			dlen = (*data) + 1;
+		if (dfid)
+			dlen = dfid->df_header.ddh_length;
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
 					blocksize - csum_size, fname, &de, dlen);
 		if (err)
@@ -2152,7 +2150,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2991,8 +2989,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
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
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..80074fb15ee9 100644
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
2.43.7

