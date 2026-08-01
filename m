Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B263BAD9F
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785608001; cv=none; b=sg10l6QhIliexNjO5K+wWIPRawJdZvY2K6ZdPvgOE79JtGYse8fRu1vXksaiemQgy+uK2Lx00pZgxP41DHPSN69oFa5l3n9hZxt8AdJJUU01eUOz7cmQUS91WX8cyzQ4369Cigw48DueEj+KsvPtCdUA8kc4fk29zlI6+2PLrHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785608001; c=relaxed/simple;
	bh=OJ2WlxFDIxdpWEDV9T/4N1iUTB1yvu6t91HW67MYrHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlWbOiyAz2eK5yAAitosc2/3BZJAiBaRbfYM5q6rj1X8zJETdsUNWR9h/vcpCMm0ZdYKH4Np7FarJoEiLnE4EDuAqdMR8Xdx20R9DN+xKbuo3W3eRx20+Rb3dfM/AqBfdQRsYxHg2iDtja8B75KRjMgpbKWkbSKH3nWjdc5xEIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ocO5tFa6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ocO5tFa6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-495635a85d2so7492815e9.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607998; x=1786212798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CdTq3sOKR+BdBCZUqKY4QuLTSIWRjGP9XgY3MdGHGfI=;
        b=ocO5tFa6nvXcXJhZyMaSKn0Oiae5S7/EeZPPKXvbPu7hy3vpJgWNceUfnLOq2OKZ0E
         CjIUjzqOKdcJOffkkrvQEW4eInJHVmE6PKg5GoxAASync7yV6FR8dZoeBSWPvgAgzeDY
         R3oNyq59OLPt3+no+aEN8UcitvSJ4tGG1ikMw+i2L73pjhJUWzxpvLcuvFW94cur2FJk
         iAFFCplDmau+0L9C3w1UU3f189wZsCa5gcA8DQUAI3BnWa3PbJxvnr/9wXWnOuq7dGv/
         Fi1441owY6ifvZI8LUdrVN08si3TfpLzdA4qBn5xpg9VprytWcQRyRpoH1xe2HlMluF9
         RoOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607998; x=1786212798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CdTq3sOKR+BdBCZUqKY4QuLTSIWRjGP9XgY3MdGHGfI=;
        b=nhVV62Y4scrSWKtPmjF76+MrFO8R7BkIl8mTFXbyRRpRLC+5q4mKNIidNueYss+H82
         a2h0dFKy5AGFKfkX18QfwJgb/qRQuKN/9S/0YsvUEkKJdmEj0sV6q+u9aZD4x8t1FbC0
         ZmU7vPrlrYkODOfUHWBXDy9nyjnGgsADTnk0wJmB0jObtgUewBI7IbZ409+rP9e4Vvhe
         ulTLlI9JnrynipMyZMruWAHvCrkYuKLXv8uPenzyOWhemSoYvygepb+9+QnRGKufH4rA
         1kSGm8b3v5ZAfRuIKMqzQeq+bxCQXxFCMPaS13BbmKC9OVuRuwSfEmQLVvjhJJw02ZM4
         tLXg==
X-Gm-Message-State: AOJu0YzoR0lpbWSuDspXjDNb50xxHOlWt23E2olEvOnrnMeJ8HFNLHe6
	9Aow59HKxwhijq2zkjxkYHdnMx+wUpFdokBFbZ4n1cl9QWdWddNKMs5O0ZOqww==
X-Gm-Gg: AR+sD11+JH9+8eW6NYYL2ZUIihcwAhu2JJTl3n9XApwx6f/DKoVkS+ck9FZyfbYaW6y
	HpRPGox3KGF9DZzgbL9KuYwrluxTC1OXiMIf/6xdAOuNPV67YtqxCAbRRdmpcgE8oGXkp2lyzBr
	mGTpDf9JMZxPpubqsIat4oRl/kLRV/Ix6JSnSLHXtHKoZ2CtvtURqfmguqAsPykIQ2zqqfX5qEl
	QR774uQFJGl915Tvm+7dY4FiHFnEqKhMcefutwvaZ6GkATijMq2BVaaa2Jn8J+/r/RJ72K2JOIV
	KKTM3gXENTeD+dKhvpoBB1QwG32GmvRwmIqDTpGLra/kHP4vm3tM/2BJo1TAYVid76qaPwyP/UD
	o2WsmplBdrOxBDocBxGbxLM0MkvezoKv6assN9DfNmcbxRB+4PIOnR2gw0C1EvstLsI4pQCJdyO
	epoPb34rnw8scXrFRybij7wKPQSjhff3x/oSUtKZJCDoikUqdanVlNy9DGENK8OM8iRZQKSFcaj
	oLwE9CAQwVYaPefYs+a
X-Received: by 2002:a05:600c:4fc5:b0:495:4e1d:82df with SMTP id 5b1f17b1804b1-4980f233e12mr67731645e9.10.1785607997733;
        Sat, 01 Aug 2026 11:13:17 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:17 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 07/11] ext4: rename ext4_dir_rec_len() and clarify dirdata usage
Date: Sat,  1 Aug 2026 14:12:21 -0400
Message-ID: <20260801181227.5198-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Rename ext4_dir_rec_len() to ext4_dirent_rec_len() to better
reflect that it computes the record length for a directory
entry based on the provided name length.

Update the comment to clarify handling of dirdata-enabled
directories and document the use of ext4_dir_entry_len()
when dirdata is present.

No functional changes.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c    | 11 +++++------
 fs/ext4/ext4.h   | 14 ++++++++++----
 fs/ext4/inline.c | 17 ++++++++++-------
 fs/ext4/namei.c  | 25 +++++++++++++------------
 4 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 17edd678fa87..3294947f8555 100644
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
-		error_msg = "rec_len is too small for name_len";
 	else if (unlikely(next_offset > size))
 		error_msg = "directory entry overrun";
-	else if (unlikely(next_offset > size - ext4_dir_rec_len(1,
+	else if (unlikely(rlen < ext4_dir_entry_len(de, size, fake ? NULL : dir)))
+		error_msg = "rec_len is too small for name_len";
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
index 68eaefa93085..806f80126546 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2614,11 +2614,16 @@ struct ext4_dirent_hash {
  * casefolded and encrypted need to store the hash as well, so we add room for
  * ext4_extended_dir_entry_2. For all entries related to '.' or '..' you should
  * pass NULL for dir, as those entries do not use the extra fields.
+ *
+ * For directories with the dirdata feature, extra data may follow the filename.
+ * Use ext4_dir_entry_len() to compute the length of a directory entry
+ * including any dirdata, or ext4_dirent_rec_len() directly when the total
+ * name_len (including dirdata length) is already known.
  */
-static inline unsigned int ext4_dir_rec_len(__u8 name_len,
+static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
 						const struct inode *dir)
 {
-	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
+	unsigned int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
 	/*
 	 * Without dirdata, the casefold+fscrypt hash lives at a fixed position
@@ -3034,7 +3039,8 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size,
 			     struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 **dest_de);
+			     struct ext4_dir_entry_2 **dest_de,
+			     int dlen);
 void ext4_insert_dentry(struct inode *dir, struct inode *inode,
 			struct ext4_dir_entry_2 *de,
 			int buf_size,
@@ -4167,7 +4173,7 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
 	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
 	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
 
-	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+	return ext4_dirent_rec_len(de->name_len + dirdata, dir);
 }
 
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..90ac8314b21d 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -976,8 +976,11 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	int		err;
 	struct ext4_dir_entry_2 *de;
 
+	/* 'dlen' reserves space for dirdata extensions (LUFID, CFHASH) in the
+	 * slot.  The dirdata types are defined in the next patch; until then
+	 * dlen stays 0 and ext4_find_dest_de() ignores dirdata overhead. */
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de);
+				inline_size, fname, &de, 0);
 	if (err)
 		return err;
 
@@ -1055,7 +1058,7 @@ static int ext4_update_inline_dir(handle_t *handle, struct inode *dir,
 	int old_size = EXT4_I(dir)->i_inline_size - EXT4_MIN_INLINE_DATA_SIZE;
 	int new_size = get_max_inline_xattr_value_size(dir, iloc);
 
-	if (new_size - old_size <= ext4_dir_rec_len(1, NULL))
+	if (new_size - old_size <= ext4_dirent_rec_len(1, NULL))
 		return -ENOSPC;
 
 	ret = ext4_update_inline_data(handle, dir,
@@ -1309,7 +1312,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 1;
 			memcpy(fake.name, ".", 2);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1319,7 +1322,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			fake.name_len = 2;
 			memcpy(fake.name, "..", 3);
 			fake.rec_len = ext4_rec_len_to_disk(
-					  ext4_dir_rec_len(fake.name_len, NULL),
+					  ext4_dirent_rec_len(fake.name_len, NULL),
 					  inline_size);
 			ext4_set_de_type(inode->i_sb, &fake, S_IFDIR);
 			de = &fake;
@@ -1427,8 +1430,8 @@ int ext4_read_inline_dir(struct file *file,
 	 * So we will use extra_offset and extra_size to indicate them
 	 * during the inline dir iteration.
 	 */
-	dotdot_offset = ext4_dir_rec_len(1, NULL);
-	dotdot_size = dotdot_offset + ext4_dir_rec_len(2, NULL);
+	dotdot_offset = ext4_dirent_rec_len(1, NULL);
+	dotdot_size = dotdot_offset + ext4_dirent_rec_len(2, NULL);
 	extra_offset = dotdot_size - EXT4_INLINE_DOTDOT_SIZE;
 	extra_size = extra_offset + inline_size;
 
@@ -1463,7 +1466,7 @@ int ext4_read_inline_dir(struct file *file,
 			 * failure will be detected in the
 			 * dirent test below. */
 			if (ext4_rec_len_from_disk(de->rec_len, extra_size)
-				< ext4_dir_rec_len(1, NULL))
+				< ext4_dirent_rec_len(1, NULL))
 				break;
 			i += ext4_rec_len_from_disk(de->rec_len,
 						    extra_size);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index f98e05f9dcf9..7854f6558218 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1106,7 +1106,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 	/* csum entries are not larger in the casefolded encrypted case */
 	top = (struct ext4_dir_entry_2 *) ((char *) de +
 					   dir->i_sb->s_blocksize -
-					   ext4_dir_rec_len(0,
+					   ext4_dirent_rec_len(0,
 							   csum ? NULL : dir));
 	/* Check if the directory is encrypted */
 	if (IS_ENCRYPTED(dir)) {
@@ -1900,7 +1900,7 @@ dx_move_dirents(struct inode *dir, char *from, char *to,
 	while (count--) {
 		struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *)
 						(from + (map->offs<<2));
-		rec_len = ext4_dir_rec_len(de->name_len, dir);
+		rec_len = ext4_dir_entry_len(de, blocksize, dir);
 
 		memcpy (to, de, rec_len);
 		((struct ext4_dir_entry_2 *) to)->rec_len =
@@ -1933,7 +1933,7 @@ static struct ext4_dir_entry_2 *dx_pack_dirents(struct inode *dir, char *base,
 	while ((char*)de < base + blocksize) {
 		next = ext4_next_entry(de, blocksize);
 		if (de->inode && de->name_len) {
-			rec_len = ext4_dir_rec_len(de->name_len, dir);
+			rec_len = ext4_dir_entry_len(de, blocksize, dir);
 			if (de > to)
 				memmove(to, de, rec_len);
 			to->rec_len = ext4_rec_len_to_disk(rec_len, blocksize);
@@ -2085,10 +2085,11 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
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
@@ -2101,7 +2102,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			return -EFSCORRUPTED;
 		if (ext4_match(dir, fname, de))
 			return -EEXIST;
-		nlen = ext4_dir_rec_len(de->name_len, dir);
+		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
 			break;
@@ -2124,7 +2125,7 @@ void ext4_insert_dentry(struct inode *dir,
 
 	int nlen, rlen;
 
-	nlen = ext4_dir_rec_len(de->name_len, dir);
+	nlen = ext4_dir_entry_len(de, buf_size, dir);
 	rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 	if (de->inode) {
 		struct ext4_dir_entry_2 *de1 =
@@ -2993,7 +2994,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dir_rec_len(de->name_len, NULL),
+	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
 					   blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
@@ -3005,7 +3006,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 	if (inline_buf) {
 		de->rec_len = ext4_rec_len_to_disk(
-					ext4_dir_rec_len(de->name_len, NULL),
+					ext4_dirent_rec_len(de->name_len, NULL),
 					blocksize);
 		de = ext4_next_entry(de, blocksize);
 		header_size = (char *)de - bh->b_data;
@@ -3014,7 +3015,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dir_rec_len(1, NULL)),
+					(csum_size + ext4_dirent_rec_len(1, NULL)),
 					blocksize);
 	}
 
@@ -3137,8 +3138,8 @@ bool ext4_empty_dir(struct inode *inode)
 	}
 
 	sb = inode->i_sb;
-	if (inode->i_size < ext4_dir_rec_len(1, NULL) +
-					ext4_dir_rec_len(2, NULL)) {
+	if (inode->i_size < ext4_dirent_rec_len(1, NULL) +
+					ext4_dirent_rec_len(2, NULL)) {
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return false;
 	}
-- 
2.43.7

