Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F03438944E
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354875; cv=none; b=ntPQG8Qp4SyveFjMfFUahtVooDHtXmXdJQ+vm75Bu7AvOiXPbMixMKY0qIWuY/p+4yTz34d8HlUNAqQuONLLJsnOCctKWZnlxRY+WHOPKHLzdYpQCVklhQbDZlPWTvXc3TgIpQTKrnCv4MfUly/sc1jD93UIPCz+mJzPZIzUNDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354875; c=relaxed/simple;
	bh=5KVuAHqNJAisuGtnOszTOUGJirhbWufOeYYb/Y0NVXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F//paJEKmLB0Tprh9OKWZgUQqXQux8iFIQEkjWwfLSKSu3kWJYiewSTgEt9WZfolwvfOhw+HmgwC4SkofMy/DzIRz3g6JhVXPQEhqGAfPp8eHXPAiKwyh1Pr8KouMXP2yrRJp5Ezs0sEs4VPum/C+9WAJtWT0xyZSvwLmSjgWFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKf8rNm0; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKf8rNm0"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso9723205e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354871; x=1785959671; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g9DVCOTagbQGrksYsi9rOwrOr3TUAxlOKGGMhn7GWHk=;
        b=XKf8rNm0fHaUr2MU+4khTeGXhXLtiURwo5VZJnSYmPUI4aTmfrBpJy/x11y2QOwepT
         b0JS8JqsZGerjLg0qz7NteVfFn0XG3tjTwrIW6AD7CF7AT2o7XZFTxrTLpmWxhJWyu8X
         NYLPXBUXUKXussDD3KnDe3WxveC8wc4KlDOzmdmTbtfgsPF7pXrUgVqTufWnv9IXLpyf
         Zb0clTahIn7dn7nGmS9eXt3c65Ccnzh7wxf/pGqa4j+0ZGwqmMoHhZH+i1/TkPIIZBmW
         EJvydSNB7PZ6AayH9N+VZhzCad/e88j3lJ7+ktf69g0J7uFJ1d+RcXWX9LS4eWDe+zug
         aoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354871; x=1785959671;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g9DVCOTagbQGrksYsi9rOwrOr3TUAxlOKGGMhn7GWHk=;
        b=AY1Gs4ISc+WIXLfsrJuCGfEENIZf72Nvj43m4c7uTSFAaAc4oUhPc173ahZjGbhAML
         jnzuYOJS4J0cIckgYmvCINUHkyTu7NX5v2YhPuwBUXhKPyajRCaHjBCLQX2dKmYWpCIM
         AOitdVtnauv6QIGT+R//fDycEbibsLrtV50owLEJ0oVzYqsI3dLGfY9lHBQVES3zulLA
         bzdIrH4uXd31Ici72bqVz8zDMJP8pK6G6E69ZeVTJ3OP8h11rqfTOaQ4p2rOnGsaWICR
         uO3xnaGVdirJwbgzwOXRdFtPhNDyKjrJ7XCxzjdP3Zv34ccnGA3GQnVl7fhT2znNzsYV
         MRVg==
X-Gm-Message-State: AOJu0YxQKegeHmEOvZvZwCjkWs/wYrslo5PrJs8tA2rknPxfL4K4q3DZ
	aGGiNMMTsBEV7Iizy1u+fIW+WHf+/ZwO0XnRnKXD3ej6X2Un1FTPx0K2vM0zwyP1
X-Gm-Gg: AR+sD11JaNxqCbkr3HGhoAtH2ASchDC9dlIfhXfpf0Dl5OOEP6K2e0393bwl3clkyNJ
	a+qQ9KYHyFwI9TnHENd1+tI9VmlJz+Z76rHS7cfxj0defIEGvHql0sia/DX5SOOMSnujZZMBZ1k
	8q97/O0mzDBgwrAUM+o1EKfObIuKELLLKSC3wFHnZg+EMUYn5uYbUVptPlrfFpHTUUHMi/q9mwj
	pSg/5VzZTO47FBdJv/pWUaoKuqcz01GaWm/Wwa6S6RFg7uaMUsWfe68v3cceu0v2xHqm1p6SKRc
	r1LhvuodBaQTp0/eQJ88yTWyBW/xjzXVX/efKBYawrpKr5uUWghF6t+UJdEW2f7sDz0F1kZ5/NZ
	tke2pehXiDqDH5SosKXmZWmsLCNCSLTJUmgD9BdSgvXCnY8lvDdR9m30K6yMTfTmISRQ3MHybBZ
	wyeY0/I8XV3MfZ6jjGItEcM/s4nrlprT6w8AhxRWfPyoB4FQq3E/5UWJuChg0TwrXFJjYGsIk2L
	qxQTEYsRwlZE9ob0Twk
X-Received: by 2002:a05:600c:3b1f:b0:495:4cba:e288 with SMTP id 5b1f17b1804b1-496c653eb6amr88329295e9.15.1785354871363;
        Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v8 04/11] ext4: refactor dx_root to support variable dirent sizes
Date: Wed, 29 Jul 2026 15:53:22 -0400
Message-ID: <20260729195333.20626-5-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Split monolithic definition of dx_root struct to separate dx_root_info
from fake struct ext4_dir_entry2 for improved code readability.
This allows "." and ".." dirents to have different sizes if necessary,
since we can't assume the rec_len 12 if dx_root dirents have dirdata.
Adds dx_get_dx_info() accessor instead of complex typecast at callers.
Does not change any functionality.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/namei.c | 215 +++++++++++++++++++++++++++++-------------------
 1 file changed, 132 insertions(+), 83 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index da12911bd754..aa2474379f37 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -244,22 +244,13 @@ struct dx_entry
  * hash version mod 4 should never be 0.  Sincerely, the paranoia department.
  */
 
-struct dx_root
+struct dx_root_info
 {
-	struct fake_dirent dot;
-	char dot_name[4];
-	struct fake_dirent dotdot;
-	char dotdot_name[4];
-	struct dx_root_info
-	{
-		__le32 reserved_zero;
-		u8 hash_version;
-		u8 info_length; /* 8 */
-		u8 indirect_levels;
-		u8 unused_flags;
-	}
-	info;
-	struct dx_entry	entries[];
+	__le32 reserved_zero;
+	u8 hash_version;
+	u8 info_length; /* 8 */
+	u8 indirect_levels;
+	u8 unused_flags;
 };
 
 struct dx_node
@@ -539,6 +530,30 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
+static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
+{
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	void *base = de_buf;
+
+	/* '.' and '..' never carry the casefold+fscrypt hash, so pass NULL
+	 * for dir regardless of the directory's flags */
+	if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
+				   blocksize) < EXT4_BASE_DIR_LEN)
+		return ERR_PTR(-EFSCORRUPTED);
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
+
+	/* dx root info is after dotdot entry */
+	if (de_buf < base || (char *)de_buf - (char *)base +
+	    EXT4_BASE_DIR_LEN > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
+
+	if (de_buf < base || (char *)de_buf - (char *)base +
+			      sizeof(struct dx_root_info) > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
+
+	return (struct dx_root_info *)de_buf;
+}
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
 {
@@ -585,6 +600,11 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 	unsigned int entry_space = dir->i_sb->s_blocksize -
 			ext4_dir_rec_len(1, NULL) -
 			ext4_dir_rec_len(2, NULL) - infosize;
+	struct dx_root_info *info;
+
+	info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(info))
+		return 0;
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -593,8 +613,10 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 
 static inline unsigned dx_node_limit(struct inode *dir)
 {
+	/* dx_node fake_dirent is always 8 bytes — it never carries a casefold
+	 * hash, so pass NULL to suppress the hash-size term. */
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dirent_rec_len(0, NULL);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -786,7 +808,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 {
 	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *info;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
@@ -798,23 +820,31 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	if (IS_ERR(frame->bh))
 		return (struct dx_frame *) frame->bh;
 
-	root = (struct dx_root *) frame->bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY &&
-	    root->info.hash_version != DX_HASH_SIPHASH) {
-		ext4_warning_inode(dir, "Unrecognised inode hash code %u",
-				   root->info.hash_version);
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data);
+	if (IS_ERR(info))
+		goto fail;
+	if (info->info_length != sizeof(struct dx_root_info)) {
+		ext4_warning_inode(dir, "corrupted htree: info_length %u",
+				   info->info_length);
+		goto fail;
+	}
+	if (info->hash_version != DX_HASH_TEA &&
+	    info->hash_version != DX_HASH_HALF_MD4 &&
+	    info->hash_version != DX_HASH_LEGACY &&
+	    info->hash_version != DX_HASH_SIPHASH) {
+		ext4_warning(dir->i_sb,
+			"Unrecognised inode hash code %d for directory #%llu",
+			info->hash_version, dir->i_ino);
 		goto fail;
 	}
 	if (ext4_hash_in_dirent(dir)) {
-		if (root->info.hash_version != DX_HASH_SIPHASH) {
+		if (info->hash_version != DX_HASH_SIPHASH) {
 			ext4_warning_inode(dir,
 				"Hash in dirent, but hash is not SIPHASH");
 			goto fail;
 		}
 	} else {
-		if (root->info.hash_version == DX_HASH_SIPHASH) {
+		if (info->hash_version == DX_HASH_SIPHASH) {
 			ext4_warning_inode(dir,
 				"Hash code is SIPHASH, but hash not in dirent");
 			goto fail;
@@ -822,7 +852,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 	if (fname)
 		hinfo = &fname->hinfo;
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -838,13 +868,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 	hash = hinfo->hash;
 
-	if (root->info.unused_flags & 1) {
+	if (info->unused_flags & 1) {
 		ext4_warning_inode(dir, "Unimplemented hash flags: %#06x",
-				   root->info.unused_flags);
+				   info->unused_flags);
 		goto fail;
 	}
 
-	indirect = root->info.indirect_levels;
+	indirect = info->indirect_levels;
 	if (indirect >= ext4_dir_htree_level(dir->i_sb)) {
 		ext4_warning(dir->i_sb,
 			     "Directory (ino: %llu) htree depth %#06x exceed"
@@ -857,14 +887,12 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		goto fail;
 	}
 
-	entries = (struct dx_entry *)(((char *)&root->info) +
-				      root->info.info_length);
+	entries = (struct dx_entry *)(((char *)info) + info->info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
+	if (dx_get_limit(entries) != dx_root_limit(dir, info->info_length)) {
 		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
 				   dx_get_limit(entries),
-				   dx_root_limit(dir, root->info.info_length));
+				   dx_root_limit(dir, info->info_length));
 		goto fail;
 	}
 
@@ -941,7 +969,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
-static void dx_release(struct dx_frame *frames)
+static void dx_release(struct inode *dir, struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
@@ -950,7 +978,18 @@ static void dx_release(struct dx_frame *frames)
 	if (frames[0].bh == NULL)
 		return;
 
-	info = &((struct dx_root *)frames[0].bh->b_data)->info;
+	info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)frames[0].bh->b_data);
+	if (IS_ERR(info)) {
+		/* Cannot determine indirect_levels; release all frame buffers
+		 * that may have been loaded to avoid leaking them. */
+		for (i = 0; i < EXT4_HTREE_LEVEL; i++) {
+			if (!frames[i].bh)
+				break;
+			brelse(frames[i].bh);
+			frames[i].bh = NULL;
+		}
+		return;
+	}
 	/* save local copy, "info" may be freed after brelse() */
 	indirect_levels = info->indirect_levels;
 	for (i = 0; i <= indirect_levels; i++) {
@@ -1256,12 +1295,12 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		    (count && ((hashval & 1) == 0)))
 			break;
 	}
-	dx_release(frames);
+	dx_release(dir, frames);
 	dxtrace(printk(KERN_DEBUG "Fill tree: returned %d entries, "
 		       "next hash: %x\n", count, *next_hash));
 	return count;
 errout:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return (err);
 }
 
@@ -1759,7 +1798,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return bh;
 }
 
@@ -2162,44 +2201,38 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	return err ? err : err2;
 }
 
-static bool ext4_check_dx_root(struct inode *dir, struct dx_root *root)
+static bool ext4_check_dx_root(struct inode *dir,
+			       struct ext4_dir_entry_2 *dot_de,
+			       struct ext4_dir_entry_2 *dotdot_de,
+			       struct ext4_dir_entry_2 **entry)
 {
-	struct fake_dirent *fde;
 	const char *error_msg;
-	unsigned int rlen;
 	unsigned int blocksize = dir->i_sb->s_blocksize;
-	char *blockend = (char *)root + dir->i_sb->s_blocksize;
+	struct ext4_dir_entry_2 *de = NULL;
 
-	fde = &root->dot;
-	if (unlikely(fde->name_len != 1)) {
+	if (unlikely(dot_de->name_len != 1)) {
 		error_msg = "invalid name_len for '.'";
 		goto corrupted;
 	}
-	if (unlikely(strncmp(root->dot_name, ".", fde->name_len))) {
+	if (unlikely(strncmp(dot_de->name, ".", dot_de->name_len))) {
 		error_msg = "invalid name for '.'";
 		goto corrupted;
 	}
-	rlen = ext4_rec_len_from_disk(fde->rec_len, blocksize);
-	if (unlikely((char *)fde + rlen >= blockend)) {
-		error_msg = "invalid rec_len for '.'";
-		goto corrupted;
-	}
 
-	fde = &root->dotdot;
-	if (unlikely(fde->name_len != 2)) {
+	if (unlikely(dotdot_de->name_len != 2)) {
 		error_msg = "invalid name_len for '..'";
 		goto corrupted;
 	}
-	if (unlikely(strncmp(root->dotdot_name, "..", fde->name_len))) {
+	if (unlikely(strncmp(dotdot_de->name, "..", dotdot_de->name_len))) {
 		error_msg = "invalid name for '..'";
 		goto corrupted;
 	}
-	rlen = ext4_rec_len_from_disk(fde->rec_len, blocksize);
-	if (unlikely((char *)fde + rlen >= blockend)) {
+	de = ext4_next_entry(dotdot_de, blocksize);
+	if ((char *)de >= (((char *)dot_de) + blocksize)) {
 		error_msg = "invalid rec_len for '..'";
 		goto corrupted;
 	}
-
+	*entry = de;
 	return true;
 
 corrupted:
@@ -2217,16 +2250,15 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 			    struct inode *inode, struct buffer_head *bh)
 {
 	struct buffer_head *bh2;
-	struct dx_root	*root;
 	struct dx_frame	frames[EXT4_HTREE_LEVEL], *frame;
 	struct dx_entry *entries;
-	struct ext4_dir_entry_2	*de, *de2;
+	struct ext4_dir_entry_2	*de, *de2, *dot_de, *dotdot_de;
 	char		*data2, *top;
 	unsigned	len;
 	int		retval;
 	unsigned	blocksize;
 	ext4_lblk_t  block;
-	struct fake_dirent *fde;
+	struct dx_root_info *dx_info;
 	int csum_size = 0;
 
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
@@ -2243,17 +2275,20 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		return retval;
 	}
 
-	root = (struct dx_root *) bh->b_data;
-	if (!ext4_check_dx_root(dir, root)) {
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
+	if (ext4_rec_len_from_disk(dot_de->rec_len, blocksize) < EXT4_BASE_DIR_LEN ||
+	    ext4_rec_len_from_disk(dot_de->rec_len, blocksize) >= blocksize - EXT4_BASE_DIR_LEN) {
+		brelse(bh);
+		return -EFSCORRUPTED;
+	}
+	dotdot_de = ext4_next_entry(dot_de, blocksize);
+	if (!ext4_check_dx_root(dir, dot_de, dotdot_de, &de)) {
 		brelse(bh);
 		return -EFSCORRUPTED;
 	}
 
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	len = ((char *) root) + (blocksize - csum_size) - (char *) de;
+	len = ((char *)dot_de) + (blocksize - csum_size) - (char *)de;
 
 	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append(handle, dir, &block);
@@ -2284,24 +2319,32 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		ext4_initialize_dirent_tail(bh2, blocksize);
 
 	/* Initialize the root; the dot dirents already exist */
-	de = (struct ext4_dir_entry_2 *) (&root->dotdot);
-	de->rec_len = ext4_rec_len_to_disk(
-			blocksize - ext4_dir_rec_len(2, NULL), blocksize);
-	memset (&root->info, 0, sizeof(root->info));
-	root->info.info_length = sizeof(root->info);
+	dotdot_de->rec_len =
+		ext4_rec_len_to_disk(blocksize - le16_to_cpu(dot_de->rec_len),
+				     blocksize);
+
+	/* initialize hashing info */
+	dx_info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(dx_info)) {
+		brelse(bh2);
+		brelse(bh);
+		return PTR_ERR(dx_info);
+	}
+	memset(dx_info, 0, sizeof(*dx_info));
+	dx_info->info_length = sizeof(*dx_info);
 	if (ext4_hash_in_dirent(dir))
-		root->info.hash_version = DX_HASH_SIPHASH;
+		dx_info->hash_version = DX_HASH_SIPHASH;
 	else
-		root->info.hash_version =
+		dx_info->hash_version =
 				EXT4_SB(dir->i_sb)->s_def_hash_version;
 
-	entries = root->entries;
+	entries = (void *)dx_info + sizeof(*dx_info);
 	dx_set_block(entries, 1);
 	dx_set_count(entries, 1);
-	dx_set_limit(entries, dx_root_limit(dir, sizeof(root->info)));
+	dx_set_limit(entries, dx_root_limit(dir, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
-	fname->hinfo.hash_version = root->info.hash_version;
+	fname->hinfo.hash_version = dx_info->hash_version;
 	if (fname->hinfo.hash_version <= DX_HASH_TEA)
 		fname->hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	fname->hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -2344,7 +2387,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	 */
 	if (retval)
 		ext4_mark_inode_dirty(handle, dir);
-	dx_release(frames);
+	dx_release(dir, frames);
 	brelse(bh2);
 	return retval;
 }
@@ -2611,7 +2654,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			if (restart || err)
 				goto journal_error;
 		} else {
-			struct dx_root *dxroot;
+			struct dx_root_info *info;
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
@@ -2619,11 +2662,17 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			dxroot = (struct dx_root *)frames[0].bh->b_data;
-			dxroot->info.indirect_levels += 1;
+			info = dx_get_dx_info(dir, (struct ext4_dir_entry_2 *)
+					      frames[0].bh->b_data);
+			if (IS_ERR(info)) {
+				err = PTR_ERR(info);
+				brelse(bh2);
+				goto journal_error;
+			}
+			info->indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
-				       dxroot->info.indirect_levels));
+				       info->indirect_levels));
 			err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 			if (err) {
 				brelse(bh2);
@@ -2647,7 +2696,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 	ext4_std_error(dir->i_sb, err); /* this is a no-op if err == 0 */
 cleanup:
 	brelse(bh);
-	dx_release(frames);
+	dx_release(dir, frames);
 	/* @restart is true means htree-path has been changed, we need to
 	 * repeat dx_probe() to find out valid htree-path
 	 */
-- 
2.43.7

