Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4BF3B4E88
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308295; cv=none; b=PTx+lDVFhMPc52dGy1dCDYeDAG6YdDfTJ/DBUemBrBhvvCnYaTGV6FxyCxlNHgIxbkbmpu3OTxNSIfvUhEmeUZa/A1G0QxGT30WgdGs5TLEIYzl/83d36dqcfxyXGNYF82PEkZTk7EpaxSxELLmFtBWNWogLRzUJkhXuaF+4qVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308295; c=relaxed/simple;
	bh=f03u8HfGBEDL/inecbPh3aPWov4tP8hJWX7yoA0oDSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/vBR4BM6tC83ckFQAnjiMMFuNoQuBYtIOYjFIoZYHgSzuCYLMAoKQ49y8yOW22lUd6y7UhVZO2Cndzq6dcD6BpzLJgAqmspK1UQqiSXg9ZJlAZfVUDxgUoeubW5rIUP8L2KyQHHqxaeUZEJ12vTyhS3xAj+SFdS/O0YbRnAB9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ew8Agcnl; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ew8Agcnl"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490ac357c55so9489175e9.1
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308292; x=1782913092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWc7FHfh08QNX8oqqa7lV3wUEsHc8mK5Zw3Ae+p/PR4=;
        b=ew8AgcnlAMVa3pcpTv47hedkkJr4Xqy+2cop12ftTqX7yNTIDSvR9I6NRS9J9861Pm
         HJJ19L+pBzBKxFGikVjyEyQiB9pALFfY1axfRSl7fbp9TXObkNUmBEDNa8wj2ZeAYL5/
         xgEtoXzS0X4/2gTvdP3S+tGj5Tfcic4Ha2WzPXFzH46QObIssbnvxT45jW7fzWYHQuWX
         8mFabjyOgD5W9hSuOdUu0OJjkBGPSOSp/N0jP/Qz0W3g7CmnRHmdaLEXc94ag99Avb2O
         YDFkc2ofP9ADh4SQj5g938okv5w3qRhDM8eZZo1idcy1/ypbxs01wlVpRjmqb0bRwDt7
         pPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308292; x=1782913092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tWc7FHfh08QNX8oqqa7lV3wUEsHc8mK5Zw3Ae+p/PR4=;
        b=LuTM3L6+YBEviNlFo72G2OJM7X6F7QO799IN288xKhS8cYtRnEadWuGAADscb/YhO8
         e3ZlIujpkhgWhmsOS8v4p59iFk2Lsc/3rhFlIDhQgRdkvZlPABgqFhbXnvTNOQgWLtek
         Ok55uYlwY8fcPtUm4I0vkf0JAbu+y0S1D/YCihzNV2dYfmIzvVHhbaJvpR1GTJEvh3HW
         ulkej3iFcUwuUg4MwuSx6tGyuIAUFKRXlyBrQoYoADcNa6VErPepvpst41S9H9CoALhP
         ZfY0HXuShw1grjs+ATeq0kqo8dQF7t5zc1cJ1R31y5pnZomTvakYdYpy/aEIlwFcPfkU
         Z/Lg==
X-Gm-Message-State: AOJu0YzDPAlhc5CjQlClT6T36Eu5BxJ4xngvt+aMLu0jfavIvaLtXOrH
	pdIwj/heltY9oYxLc2iXnAK7wshZSDEKEhX8iM6J0/nXNZ7hN89UYAo8ZzpAaOcgQQ8=
X-Gm-Gg: AfdE7ckhe+YB2osoGU6LphMybQITPUESAa/4Ap3Ydn7/pJHkkhl0te/SB8M2A7d8ETn
	MCkbzrUZKf83c62ekha+A7MwQEiCfyOgWlKacqRisA/rWr601gF5iWI5RhgshAWMSAba506MQdE
	tTIrMn4yOWQn2nLDsGU+ZrypNdgVe5HgJ5O8XaUxtQiLKnN8kZHIQ82kHzvThNSYTLSTIUgOzN6
	pzHa8rqrqhmUG/Xi3Qu0dEjn+4a+hq8dgmd1QtnT99qHj/C3gSDNrB1jdtigmXoiqDbEHFhdqav
	2eAf8bgQhtbyXIk9kMuJxy5NJgsF88HAC/8BIR09IiFtUMv6RW/NBNTzLKssx6K5zCoVxZ2SVZi
	iE2SCm9UvQcBeshTSMGEcEjZc8od9pX5RsOCLwc0nheAOsAlXkVBB6ahVb2jelip+gMspgEJnCj
	2SmPywtjbSH5Sesd7Z6xV+jl3WOVenYzKHVbKGhySXlKdi
X-Received: by 2002:a05:600c:674f:b0:490:c7dd:7cc2 with SMTP id 5b1f17b1804b1-4926086e5c0mr50844735e9.24.1782308291320;
        Wed, 24 Jun 2026 06:38:11 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:10 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 10/11] ext4: add dirdata set/get helpers
Date: Wed, 24 Jun 2026 09:36:39 -0400
Message-ID: <20260624133642.18438-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add helpers to set and retrieve dirdata payload and hook them up at
the appropriate call sites.

Enable dirdata for casefold+encryption hashes and storing unique
128-bit file identifier in the directory entry for testing.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 foofile.txt      |   0
 fs/ext4/ext4.h   |   4 +
 fs/ext4/inline.c |   6 +-
 fs/ext4/namei.c  | 227 +++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 207 insertions(+), 30 deletions(-)

diff --git a/foofile.txt b/foofile.txt
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1e61ce13ed07..5674a64f830f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3874,6 +3874,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       const struct qstr *d_name, struct dentry *dentry);
+extern unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de,
+				      struct inode *dir,
+				      struct ext4_dirent_fid  *lufid,
+				      struct dx_hash_info *hinfo);
 
 #define S_SHIFT 12
 static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1fff4defd45b..32b4ff83d4df 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1350,10 +1350,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			}
 		}
 
-		if (ext4_hash_in_dirent(dir)) {
-			hinfo->hash = EXT4_DIRENT_HASH(de);
-			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
-		} else {
+		if (!(ext4_dirdata_get(de, dir, NULL, hinfo) &
+							EXT4_DIRENT_CFHASH)) {
 			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 			if (err) {
 				ret = err;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 91def9e0f84d..6fba1a7c0876 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1108,22 +1108,22 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
+		if (de->name_len && de->inode) {
+			/* check for saved hash first, or generate it from name */
+			if (!(ext4_dirdata_get(de, dir, NULL, hinfo) &
+			      EXT4_DIRENT_CFHASH)) {
+				err = ext4fs_dirhash(dir, de->name,
+						     de->name_len, hinfo);
+				if (err < 0) {
+					count = err;
+					goto errout;
+				}
+			 }
 		} else {
-			err = ext4fs_dirhash(dir, de->name,
-					     de->name_len, hinfo);
-			if (err < 0) {
-				count = err;
-				goto errout;
-			}
+			hinfo->hash = 0;
+			hinfo->minor_hash = 0;
 		}
+
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
 		     (hinfo->minor_hash < start_minor_hash)))
@@ -1301,9 +1301,191 @@ static inline int search_dirblock(struct buffer_head *bh,
  */
 
 /*
- * Create map of hash values, offsets, and sizes, stored at end of block.
- * Returns number of entries mapped.
+ * ext4_dirdata_get() - Read dirdata fields from a directory entry.
+ * @de:         directory entry
+ * @dir:        directory inode (used for fscrypt+casefold hash fallback)
+ * @dfid:      if non-NULL and EXT4_DIRENT_LUFID is set, LUFID data is copied
+ * 		here
+ * @hinfo:	if non-NULL, receives the casefold hash and minor hash
+ *
+ * Reads any dirdata stored in @de.  If the dirdata feature is not enabled,
+ * falls back to reading the hash stored inline after the filename (for
+ * compatibility with the older casefold+fscrypt format).
+ *
+ * Returns a bitmask of EXT4_DIRENT_* flags indicating which fields were read.
+ */
+unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
+			       struct ext4_dirent_fid *dfid,
+			       struct dx_hash_info *hinfo)
+{
+	unsigned char ret = 0;
+	unsigned int data_offset = de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len,
+						       dir->i_sb->s_blocksize);
+
+	/* data_offset is relative to de->name, which itself starts
+	 * EXT4_BASE_DIR_LEN bytes into the entry -- rec_len is relative to
+	 * the start of the entry, so add the header size before comparing,
+	 * or this lets reads run EXT4_BASE_DIR_LEN bytes past the entry. */
+	if (EXT4_BASE_DIR_LEN + data_offset > rec_len)
+		return ret;
+
+	/* compatibility: hash stored inline after filename (no dirdata) */
+	if (hinfo && !ext4_has_feature_dirdata(dir->i_sb) &&
+	    ext4_hash_in_dirent(dir)) {
+		hinfo->hash = EXT4_DIRENT_HASH(de);
+		hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+		ret |= EXT4_DIRENT_CFHASH;
+
+		return ret;
+	}
+
+	/*  EXT4_DIRENT_* are not expected without flag in i_sb */
+	if (de->file_type & EXT4_DIRENT_LUFID) {
+		struct ext4_dirent_fid *disk_fid =
+			(struct ext4_dirent_fid *)(de->name + data_offset);
+		unsigned int dlen;
+
+		if (EXT4_BASE_DIR_LEN + data_offset + sizeof(disk_fid->df_header) > rec_len)
+			return ret;
+
+		dlen = disk_fid->df_header.ddh_length;
+		if (dlen < sizeof(*disk_fid) ||
+		    EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len)
+			return ret;
+
+		if (dfid) {
+			/* copy the whole record (header + fid), not just the fid
+			 * payload -- dlen already includes the header's length */
+			memcpy(dfid, disk_fid, dlen);
+			ret |= EXT4_DIRENT_LUFID;
+		}
+		data_offset += dlen;
+	}
+
+	/* Skip INO64 for now*/
+	if (de->file_type & EXT4_DIRENT_INO64) {
+		struct ext4_dirent_data_header *ddh =
+		       (struct ext4_dirent_data_header *)(de->name + data_offset);
+		unsigned int dlen;
+
+		if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*ddh) > rec_len)
+			return ret;
+
+		dlen = ddh->ddh_length;
+		if (dlen < sizeof(*ddh) ||
+		    EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len)
+			return ret;
+
+		data_offset += dlen;
+	}
+
+	if (!hinfo)
+		return ret;
+
+	if (de->file_type & EXT4_DIRENT_CFHASH) {
+		struct ext4_dirent_hash *dh =
+			(struct ext4_dirent_hash *)(de->name + data_offset);
+		unsigned int dlen;
+
+		dlen = dh->dh_header.ddh_length;
+		if (dlen < sizeof(*dh) ||
+		    EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len)
+			return ret;
+
+		hinfo->hash = le32_to_cpu(dh->dh_hash.hash);
+		hinfo->minor_hash = le32_to_cpu(dh->dh_hash.minor_hash);
+		ret |= EXT4_DIRENT_CFHASH;
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
+			     struct ext4_dirent_fid *dfid,
+			     struct ext4_filename *fname)
+{
+	struct dx_hash_info *hinfo = &fname->hinfo;
+	unsigned int data_offset = de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len,
+						       dir->i_sb->s_blocksize);
+
+	/* de->name[] is declared with a fixed EXT4_NAME_LEN size, but the
+	 * real backing storage is this entry's rec_len-sized space in the
+	 * directory block; a max-length name (name_len == EXT4_NAME_LEN)
+	 * leaves no declared array slot for the NUL terminator below, which
+	 * FORTIFY_SOURCE treats as an out-of-bounds array write regardless
+	 * of how much real space the entry has. */
+	if (dfid && de->name_len >= EXT4_NAME_LEN) {
+		EXT4_ERROR_INODE(dir, "Can not insert FID: name_len too long");
+		return;
+	}
+
+	/* always clear the gap byte at de->name[de->name_len], even when no
+	 * FID is being appended -- otherwise it's never initialized before
+	 * dirdata is written right after it, leaking a byte of stale memory
+	 * to disk. Skip it for a max-length name: there's no declared array
+	 * slot for it, and no dirdata can be appended in that case anyway
+	 * (rejected above for dfid; data_offset would already be >= rec_len
+	 * for any other dirdata kind). */
+	if (de->name_len < EXT4_NAME_LEN)
+		de->name[de->name_len] = 0;
+
+	if (dfid) {
+		unsigned int dlen = dfid->df_header.ddh_length;
+
+		if (EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len) {
+			EXT4_ERROR_INODE(dir, "Can not insert FID");
+			return;
+		}
+
+		memcpy(&de->name[de->name_len + 1], dfid,
+		       dlen);
+		de->file_type |= EXT4_DIRENT_LUFID;
+		data_offset += dlen;
+	}
+
+	if (ext4_hash_in_dirent(dir)) {
+		if (ext4_has_feature_dirdata(dir->i_sb)) {
+			struct ext4_dirent_hash *dh =
+			    (struct ext4_dirent_hash *)(de->name + data_offset);
+
+			if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*dh) > rec_len) {
+				EXT4_ERROR_INODE(dir, "Can not insert dhash dirdata");
+				return;
+			}
+
+			dh->dh_header.ddh_length = sizeof(*dh);
+			dh->dh_hash.hash = cpu_to_le32(hinfo->hash);
+			dh->dh_hash.minor_hash = cpu_to_le32(hinfo->minor_hash);
+			de->file_type |= EXT4_DIRENT_CFHASH;
+		} else {
+			/* Compatibility: store hash inline after filename */
+			if (EXT4_BASE_DIR_LEN + data_offset +
+			    sizeof(struct ext4_dir_entry_hash) > rec_len) {
+				EXT4_ERROR_INODE(dir, "Can not insert dhash");
+				return;
+			}
+
+			EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(hinfo->hash);
+			EXT4_DIRENT_HASHES(de)->minor_hash =
+						cpu_to_le32(hinfo->minor_hash);
+		}
+	}
+}
+
+
 static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 		       struct dx_hash_info *hinfo,
 		       struct dx_map_entry *map_tail)
@@ -1323,9 +1505,8 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 					 ((char *)de) - base))
 			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
-			if (ext4_hash_in_dirent(dir))
-				h.hash = EXT4_DIRENT_HASH(de);
-			else {
+			if (!(ext4_dirdata_get(de, dir, NULL, &h) &
+						EXT4_DIRENT_CFHASH)) {
 				int err = ext4fs_dirhash(dir, de->name,
 						     de->name_len, &h);
 				if (err < 0)
@@ -2113,13 +2294,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	if (ext4_hash_in_dirent(dir)) {
-		struct dx_hash_info *hinfo = &fname->hinfo;
-
-		EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(hinfo->hash);
-		EXT4_DIRENT_HASHES(de)->minor_hash =
-						cpu_to_le32(hinfo->minor_hash);
-	}
+	ext4_dirdata_set(de, dir, data, fname);
 }
 
 /*
-- 
2.43.7

