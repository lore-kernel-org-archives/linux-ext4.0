Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19C5342C80
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 21:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776461860; cv=none; b=dt5rMjhlnQB7JQhuD+rg1DW8myOnf2+XQZkYlsL9sFG0WGH0hCJxrBVxiphBGYsh9NEgVvJw90kRJQHqshy949F97qdSJR7JD8iZGGOPwOmQPSs4iyXKlDnXs6lUVCL+XNR01JzX0sJsBVqaouDu9AObXE5FTeRHkOtcfskYM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776461860; c=relaxed/simple;
	bh=MhyVsmzNh3N09QKspt4804SsuZZ6rewljKuMNTozB98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cj8dwwD6t7Rd66aQ/gJcgJfuVgdQPfsnyjeYTbzE/IpmyWJvCFMcvuqMB9wEXZ2YsPtCW28NgeDufDxwYsveZPAB3sIhPoHsb/UPi5I5TgEbPGrird3+A3HwQYCCALeB+fBkojzarNIlTv50ScfCbnHo3g3xLHq3g9utrI0YELw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNp+DYZq; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNp+DYZq"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so14434405e9.0
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 14:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776461857; x=1777066657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaQDN4Yo+aCWIVuwO1Ffv7uu9lPnMVpiMPGxN3arduA=;
        b=WNp+DYZqkl7NK92siNsBpzFNr+JdJKQ7SV0Ajcu3mBHaxQRVZNMTsOX2vJtjvXRlND
         /ksmbKO/o088Fk+3dA5ZeDOuZt2Yx/bi+HHbqZXOZSgKN4a7jxqu/H/8YwwiftByNRFA
         FsAGFh77znL2LCe93yilJC3aE/WwNA3P7afPQ07s3xGP2vd2ByqVhAM44u1bW3pFywKb
         V19jqq3SYRZPCvxILTc3VHj+Tfe4Yl0QuMHTStuXlvfQBo8ilblaRZOulX0RBqKQANnV
         cUm6SY0Ir/IvHq2to+tqx9pOIIqModox9d/IUcpqyUf3gTrRpzgzp4qg3g6b5RfH9VEQ
         aX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776461857; x=1777066657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vaQDN4Yo+aCWIVuwO1Ffv7uu9lPnMVpiMPGxN3arduA=;
        b=Uz8sNOYzbSQm7AC2KsRST99/bxQKplwn0rKtq5iB7NtfN7+Thz+AaoUXXS1gD7abX3
         IJIABm7vy4aSghdWSNPvAFSFqlLOvJHqMhlognDM5PzYznbTItC8upc6O8CX94dq4Qbl
         kOYRAvScxnXxsJeGgl/0HkWImu7s7XU3krLLRA0NA1fsg+AeL1Dfdl0ueWYzvWiMtxQA
         EpHAZjp5wznVmRtEjQr85g6rUDM0NjIMmbYhJgLtfthzcWOjrWBSCrzNoAsfoG9rhOOK
         vgfmRZ3BcR8SszLsGlpLtKSlpcqbAvqi3V+G7yRYOL5lKPQqCSt3/mk6jh9IfypOLw7N
         1e4Q==
X-Gm-Message-State: AOJu0YwJeqyh2WhHiMxDhIWEjVr2Kcq3Bg6s4auXlGK4CSYfBOika9Tl
	ReJ8AzzXvhhNNnEE409dj0OJevZWLegIGWKri7nRdp0tY4JIV8sk87UcafV6yA==
X-Gm-Gg: AeBDievZNSj6i/6ew4EptDakzwpGgTMTXyscJoi4f9tmYtnaD8TaIFrtsS1bSnedAeZ
	utp6gq/qjWLk4d+zxAOqp8ch1wyKYzlbSEJbm0yGCpH1vN4CZBSDNs2qjZSeNKLqj0z22pFV0hJ
	HvHEzCPdK9gJajz124z4LnLpWIDa+L30/8XgWIABwYG/Hwt1//fCGL9/67kGt5e0VUmsFSBbXyO
	Xby/tIaTZ/A6YRxFsltTaP0Y7/BF3ou3JFXl99q6wNzEO4JL0KKk91xQVniTypblNxsE4Wb2MRe
	5d6r6rcp9zCQv7xwqv7tNDIAp0G3QUNYsYVQMYfySI5T7BEOL6QMXZB0gvL6W55Tpp506dYWxra
	ovAcG5f3tpwQTyuQx9wxqF06re4ijfbQEIYX6WhyIAS2N7vijWCh9TIF6qSyCNTNuG4FkiWFWnY
	NkdYBaaixemzOPm3RMTu4c0KLqnQ/uvufvIXbyewcEq8/snvIFPCNXgG22a9pwIY5V3vXK9gWu2
	OC5VjFax3t1W/NSE4O0BHA=
X-Received: by 2002:a05:600c:3546:b0:488:81b1:ae36 with SMTP id 5b1f17b1804b1-488fb7880camr67411125e9.23.1776461857054;
        Fri, 17 Apr 2026 14:37:37 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c7:90c1:9201:f5b4:1568:453c:b849])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb762f56sm25725645e9.15.2026.04.17.14.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:37:36 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/3] ext4: make dirdata work with metadata_csum
Date: Fri, 17 Apr 2026 22:37:18 +0100
Message-ID: <20260417213723.74204-2-artem.blagodarenko@gmail.com>
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
 fs/ext4/namei.c | 177 ++++++++++++++++++++++++------------------------
 1 file changed, 89 insertions(+), 88 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252af0e..ab2b4bb4a93d 100644
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
@@ -334,11 +325,7 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 	t = EXT4_DIRENT_TAIL(bh->b_data, EXT4_BLOCK_SIZE(inode->i_sb));
 #endif
 
-	if (t->det_reserved_zero1 ||
-	    (ext4_rec_len_from_disk(t->det_rec_len, blocksize) !=
-	     sizeof(struct ext4_dir_entry_tail)) ||
-	    t->det_reserved_zero2 ||
-	    t->det_reserved_ft != EXT4_FT_DIR_CSUM)
+	if (!ext4_dir_entry_is_tail((struct ext4_dir_entry_2 *)t))
 		return NULL;
 
 	return t;
@@ -413,7 +400,7 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 					       struct ext4_dir_entry *dirent,
 					       int *offset)
 {
-	struct ext4_dir_entry *dp;
+	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
 	int count_offset;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
@@ -422,10 +409,10 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 	if (rlen == blocksize)
 		count_offset = 8;
 	else if (rlen == 12) {
-		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(dp->rec_len, blocksize) != blocksize - 12)
+		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
+		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
 			return NULL;
-		root = (struct dx_root_info *)(((void *)dp + 12));
+		root = (struct dx_root_info *)(((void *)de + 12));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
@@ -533,6 +520,16 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
+static struct dx_root_info *dx_get_dx_info(void *de_buf)
+{
+	/* get dotdot first */
+	de_buf = de_buf + ext4_dirent_rec_len(1, NULL);
+
+	/* dx root info is after dotdot entry */
+	de_buf = de_buf + ext4_dirent_rec_len(2, NULL);
+
+	return (struct dx_root_info *)de_buf;
+}
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
 {
@@ -574,11 +571,16 @@ static inline void dx_set_limit(struct dx_entry *entries, unsigned value)
 	((struct dx_countlimit *) entries)->limit = cpu_to_le16(value);
 }
 
-static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
+static inline unsigned dx_root_limit(struct inode *dir,
+	struct ext4_dir_entry_2 *dot_de, unsigned infosize)
 {
-	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(1, NULL) -
-			ext4_dir_rec_len(2, NULL) - infosize;
+	struct ext4_dir_entry_2 *dotdot_de;
+	unsigned entry_space;
+
+	dotdot_de = ext4_next_entry(dot_de, dir->i_sb->s_blocksize);
+	entry_space = dir->i_sb->s_blocksize -
+		ext4_dir_entry_len(dot_de, NULL) -
+		ext4_dir_entry_len(dotdot_de, NULL) - infosize;
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -780,7 +782,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 {
 	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *info;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
@@ -792,23 +794,24 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	if (IS_ERR(frame->bh))
 		return (struct dx_frame *) frame->bh;
 
-	root = (struct dx_root *) frame->bh->b_data;
-	if (root->info.hash_version != DX_HASH_TEA &&
-	    root->info.hash_version != DX_HASH_HALF_MD4 &&
-	    root->info.hash_version != DX_HASH_LEGACY &&
-	    root->info.hash_version != DX_HASH_SIPHASH) {
-		ext4_warning_inode(dir, "Unrecognised inode hash code %u",
-				   root->info.hash_version);
+	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frame->bh->b_data);
+	if (info->hash_version != DX_HASH_TEA &&
+	    info->hash_version != DX_HASH_HALF_MD4 &&
+	    info->hash_version != DX_HASH_LEGACY &&
+	    info->hash_version != DX_HASH_SIPHASH) {
+		ext4_warning(dir->i_sb,
+			"Unrecognised inode hash code %d for directory #%lu",
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
@@ -816,7 +819,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 	if (fname)
 		hinfo = &fname->hinfo;
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -832,13 +835,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
 			     "Directory (ino: %lu) htree depth %#06x exceed"
@@ -851,14 +854,17 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 		goto fail;
 	}
 
-	entries = (struct dx_entry *)(((char *)&root->info) +
-				      root->info.info_length);
+	entries = (struct dx_entry *)(((char *)info) +
+				      info->info_length);
 
-	if (dx_get_limit(entries) != dx_root_limit(dir,
-						   root->info.info_length)) {
+	if (dx_get_limit(entries) !=
+	    dx_root_limit(dir, (struct ext4_dir_entry_2 *)frame->bh->b_data,
+			  info->info_length)) {
 		ext4_warning_inode(dir, "dx entry: limit %u != root limit %u",
 				   dx_get_limit(entries),
-				   dx_root_limit(dir, root->info.info_length));
+				   dx_root_limit(dir,
+				   (struct ext4_dir_entry_2 *)frame->bh->b_data,
+				   info->info_length));
 		goto fail;
 	}
 
@@ -944,7 +950,7 @@ static void dx_release(struct dx_frame *frames)
 	if (frames[0].bh == NULL)
 		return;
 
-	info = &((struct dx_root *)frames[0].bh->b_data)->info;
+	info = dx_get_dx_info((struct ext4_dir_entry_2 *)frames[0].bh->b_data);
 	/* save local copy, "info" may be freed after brelse() */
 	indirect_levels = info->indirect_levels;
 	for (i = 0; i <= indirect_levels; i++) {
@@ -2156,44 +2162,38 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
@@ -2211,16 +2211,15 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
@@ -2237,17 +2236,15 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		return retval;
 	}
 
-	root = (struct dx_root *) bh->b_data;
-	if (!ext4_check_dx_root(dir, root)) {
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
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
@@ -2278,24 +2275,27 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
+	dx_info = dx_get_dx_info(dot_de);
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
+	dx_set_limit(entries, dx_root_limit(dir, dot_de, sizeof(*dx_info)));
 
 	/* Initialize as for dx_probe */
-	fname->hinfo.hash_version = root->info.hash_version;
+	fname->hinfo.hash_version = dx_info->hash_version;
 	if (fname->hinfo.hash_version <= DX_HASH_TEA)
 		fname->hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	fname->hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -2598,7 +2598,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			if (restart || err)
 				goto journal_error;
 		} else {
-			struct dx_root *dxroot;
+			struct dx_root_info *info;
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
@@ -2606,8 +2606,9 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			/* Set up root */
 			dx_set_count(entries, 1);
 			dx_set_block(entries + 0, newblock);
-			dxroot = (struct dx_root *)frames[0].bh->b_data;
-			dxroot->info.indirect_levels += 1;
+			info = dx_get_dx_info((struct ext4_dir_entry_2 *)
+					      frames[0].bh->b_data);
+			info->indirect_levels = 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
 				       dxroot->info.indirect_levels));
-- 
2.43.5

