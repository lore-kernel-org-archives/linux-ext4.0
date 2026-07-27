Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ECF36B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186792; cv=none; b=izlS13a07fSlk7c4GxhQvvOOmts6igAAGIBQVEkn0Wkq3BAUNhFPZIlpt/kIbAtc0imatpm57tazQuq3piPqGbY1Qbt+tZLrTOwOpmmMvjducNfty3eAP2gCdhG0ujVvAuHxVThEceLxqW3+4xnjhor20Qzmmxz1TP5QObpHxRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186792; c=relaxed/simple;
	bh=GM9OZs7fEaYFjWY8lkW9KFEY6wZCAqcTjh/Q5hZ3o/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfNbY1HpMNw0oMO4oxawqwzEAM8VclgIGFoTSJI7Ro5JVCkzV0nYlj2vZmZrrFZ+3pEZRsvgo31IiKftkH9TI2N6qM83qLMH4nIariub4/UU9iNprCXecdj3j+VPVtyae64QFhVSEz6nuiQGxdTSfHsXeusWRMS9sIn77xalX8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SxbCkEiJ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SxbCkEiJ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso21623195e9.1
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186789; x=1785791589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TVt2/Ro39PWZISIDPfEXnJwdxP6TFAXVdcA4i256kcQ=;
        b=SxbCkEiJKsjCtm49FWaRGcsexRIiTeMyP3XqIlsRNN6lRbMNHQVGPAteJO+bGusitT
         6VwrR4Zc9bGXO+r13Rhi8jr/1C2xJKKPpS5wSlf7hpG5MAUEJVDnbSJBHLJqMevmccYV
         RX527aedd6Fx3mA5EmZzSNVnnSntmYpuJ2s/hrsxpxgecKR3Wff8EvibvupymkjR5i9v
         BC+h/fP9BcbKYHf2XBBfcP2MOjhPlTrgGJbn/nIob8hCcPSdJXwQcirMS1t9lrFmpNLE
         kt1F2qNH7faIO5hapkqzuWzRjNc58440FgJsqAF7xV6WMNEfpxsyD2WaL8J++kBfNgzi
         2DRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186789; x=1785791589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TVt2/Ro39PWZISIDPfEXnJwdxP6TFAXVdcA4i256kcQ=;
        b=Qj4yZ7Gt09/AQ5uozfDMFQxGjtLF3+m8mHMUA0bOBPA+mIqvz6q78O/wlJruMLywLJ
         /C/cAsmfMuaDzBDdusPcj1n7FS9J7k02oa/RyQjNZKAhoRAuC5O7zw7Y8YUTOj7qIl5E
         rTD3Ihj7MzWvhGiqvtvF74+PRQ03ENDRl/NLvcj5pvfNQrIMMwV8HxZlauajXqyTl9Ku
         ElEnMpUXOMqCxOcFpdigDtz2iEltSq3qn2eAbSO4hLvwlkwAMKSuS9XznhdiQMCtU37Z
         qXqGxrj1UMgDHpwYITnwl2OqHehSRVqaCC3X4DWvty6KmH1EDQJ14l+qBVClhBjuwt42
         sCUQ==
X-Gm-Message-State: AOJu0YzVvs+r2O1Hmsr9KZbjlWRAw59IiKi4DkzLrYZLmMfPaf1OGhU0
	pJrQs5LrWTizoiw11sr6+FJommT0CtGjWHfkOXnqXBgj2qvsvY2Z8LqreimxJrw9
X-Gm-Gg: AR+sD11KhOJHLXj5yYvw7jQZSZdIAppQEm/jyaOerMzenpUcKmvXQzGzey/RWp99L38
	gop2OHsMFoGbSWglw76+2cMegmS716p0Jz0l/b1FRkGErOmacQsGz3HTrOgPns9e+nvtKedfqQK
	f1ry4vu3gPrZ0a9Mw9fH6Vm4hLFhrPzCLQxjLMrKwkV3th64/R+4R7a94F1EVEy1rNd8WDL1INY
	RqynaOfn7tEjpjp/eEEfCAA6VGBEywayO9rDAeYhlV4hKQbhiNO6hcxfby5toaZ6ORtiAFSFbn1
	VuKUW2HH9wReUmp4QpwxP3gJ4VpDywZdm7UUxJ/SbQdKi8gb+gMkjpmr4ebpFS4FskGUdk4HdEr
	bwFN2N4Ns8sk66SEIsfLv2dtzyYRGaSCTezgbP89TLvzrEE29S50gcGz4M38qWV3QSFYRhfFeGa
	T2tbU4SwzcJxlXBzRPJOl0jF8iLOBWCnnHJQ==
X-Received: by 2002:a05:600c:5955:b0:496:c18c:f998 with SMTP id 5b1f17b1804b1-496c4fce883mr4036395e9.19.1785186788844;
        Mon, 27 Jul 2026 14:13:08 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44afaecsm24910245e9.2.2026.07.27.14.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:08 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v6 10/11] ext4: add dirdata set/get helpers
Date: Mon, 27 Jul 2026 17:11:22 -0400
Message-ID: <20260727211125.19632-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
References: <20260727211125.19632-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/ext4.h   |   4 +
 fs/ext4/inline.c |   6 +-
 fs/ext4/namei.c  | 239 ++++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 221 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a7e7e2ac0538..099303c1f672 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3894,6 +3894,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
 			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       const struct qstr *d_name, struct dentry *dentry);
+extern unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de,
+				      struct inode *dir, int buf_size,
+				      struct ext4_dirent_fid  *lufid,
+				      struct dx_hash_info *hinfo);
 
 #define S_SHIFT 12
 static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8221459cc656..1bbf89e18076 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1355,10 +1355,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			pos += de_len;
 		}
 
-		if (ext4_hash_in_dirent(dir)) {
-			hinfo->hash = EXT4_DIRENT_HASH(de);
-			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
-		} else {
+		if (!(ext4_dirdata_get(de, dir, inline_size, NULL, hinfo) &
+							EXT4_DIRENT_CFHASH)) {
 			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
 			if (err) {
 				ret = err;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6bf553415707..f1985f1d9b60 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1135,22 +1135,23 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
+			if (!(ext4_dirdata_get(de, dir, dir->i_sb->s_blocksize,
+					       NULL, hinfo) &
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
@@ -1330,6 +1331,202 @@ static inline int search_dirblock(struct buffer_head *bh,
  * Directory block splitting, compacting
  */
 
+/*
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
+ *
+ * Compatibility note: enabling EXT4_FEATURE_INCOMPAT_DIRDATA on a filesystem
+ * that already has casefolded+encrypted directories is NOT safe without a
+ * prior migration pass.  Before dirdata, the casefold+fscrypt hash was stored
+ * as a raw 8 bytes immediately after the filename with no flag in file_type.
+ * After dirdata is enabled, this function expects the hash to be present only
+ * when EXT4_DIRENT_CFHASH (0x40) is set in file_type; existing entries that
+ * carry the raw hash are silently misread as having no hash at all, breaking
+ * directory lookups.  e2fsck must be run to convert all affected entries to
+ * the EXT4_DIRENT_CFHASH extension format before the feature flag is set with
+ * tune2fs.  Detection heuristic: in a casefold+encrypted directory, an entry
+ * with rec_len >= round_up(name_len, 4) + 8 and no EXT4_DIRENT_CFHASH bit
+ * carries a raw pre-dirdata hash that must be migrated.
+ */
+unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
+			       int buf_size,
+			       struct ext4_dirent_fid *dfid,
+			       struct dx_hash_info *hinfo)
+{
+	unsigned char ret = 0;
+	unsigned int data_offset = de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, buf_size);
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
+		return ret;
+	}
+
+	/* EXT4_DIRENT_* bits are only meaningful when the feature is enabled */
+	if (!ext4_has_feature_dirdata(dir->i_sb))
+		return ret;
+
+	if (de->file_type & EXT4_DIRENT_LUFID) {
+		struct ext4_dirent_fid *disk_fid =
+			(struct ext4_dirent_fid *)((char *)de +
+			EXT4_BASE_DIR_LEN + data_offset);
+		unsigned int dlen;
+		/* struct ext4_fid df_fid[] does not provide the array size.
+		 * First, verify that the header lies within the valid area, then
+ 		 * verify that the entire record fits within it. */
+		if (EXT4_BASE_DIR_LEN + data_offset +
+		    sizeof(disk_fid->df_header) > rec_len)
+			return ret;
+
+		dlen = disk_fid->df_header.ddh_length;
+		if (dlen == 0 ||
+		    EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len)
+			return ret;
+
+		if (dfid) {
+			memcpy(dfid, disk_fid, dlen);
+			ret |= EXT4_DIRENT_LUFID;
+		}
+		data_offset += dlen;
+	}
+
+	/* Skip INO64 for now*/
+	if (de->file_type & EXT4_DIRENT_INO64) {
+		struct ext4_dirent_data_header *ddh =
+		       (struct ext4_dirent_data_header *)((char *)de + EXT4_BASE_DIR_LEN + data_offset);
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
+			(struct ext4_dirent_hash *)((char *)de + EXT4_BASE_DIR_LEN + data_offset);
+		unsigned int dlen;
+
+		if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*dh) > rec_len)
+			return ret;
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
+ *
+ * See ext4_dirdata_get() for the compatibility constraint: enabling the
+ * dirdata feature on a filesystem with existing casefolded+encrypted
+ * directories requires an e2fsck migration pass before tune2fs sets the
+ * EXT4_FEATURE_INCOMPAT_DIRDATA superblock flag.
+ */
+static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
+			     struct ext4_dirent_fid *dfid,
+			     struct ext4_filename *fname)
+{
+	struct dx_hash_info *hinfo = &fname->hinfo;
+	unsigned int data_offset = de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len,
+						       dir->i_sb->s_blocksize);
+
+	/* Clear the gap byte between the filename and the first dirdata
+	 * extension to avoid leaking stale memory to disk.  Use pointer
+	 * arithmetic rather than de->name[name_len] to stay within the
+	 * declared name[] array bounds under FORTIFY_SOURCE.  Only write it
+	 * when there is actually room (entries that exactly fill their slot
+	 * have rec_len == EXT4_BASE_DIR_LEN + name_len with no gap). */
+	if (EXT4_BASE_DIR_LEN + data_offset <= rec_len)
+		*((char *)de + EXT4_BASE_DIR_LEN + de->name_len) = 0;
+
+	if (dfid) {
+		unsigned int dlen = dfid->df_header.ddh_length;
+
+		if (EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len) {
+			EXT4_ERROR_INODE(dir, "Can not insert FID");
+			return;
+		}
+
+		memcpy((char *)de + EXT4_BASE_DIR_LEN + data_offset, dfid, dlen);
+		de->file_type |= EXT4_DIRENT_LUFID;
+		data_offset += dlen;
+	}
+
+	if (ext4_hash_in_dirent(dir)) {
+		if (ext4_has_feature_dirdata(dir->i_sb)) {
+			struct ext4_dirent_hash *dh =
+			    (struct ext4_dirent_hash *)((char *)de + EXT4_BASE_DIR_LEN + data_offset);
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
 /*
  * Create map of hash values, offsets, and sizes, stored at end of block.
  * Returns number of entries mapped.
@@ -1353,9 +1550,9 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 					 ((char *)de) - base))
 			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
-			if (ext4_hash_in_dirent(dir))
-				h.hash = EXT4_DIRENT_HASH(de);
-			else {
+			if (!(ext4_dirdata_get(de, dir, dir->i_sb->s_blocksize,
+					       NULL, &h) &
+						EXT4_DIRENT_CFHASH)) {
 				int err = ext4fs_dirhash(dir, de->name,
 						     de->name_len, &h);
 				if (err < 0)
@@ -2147,13 +2344,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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

