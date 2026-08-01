Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97A6212F89
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785608005; cv=none; b=cl9m4lQsPrmuUQveYgIFRqe8BpNypnwWta93a295LJGSm1u7XlX4z7J/NlNYJQ9SQM81OzhA0F7CuO1ftu0Qs2qjYqIiS5i/OFWYDFK2vQ9wobmfLMk9VatMGRqyqwxxCBZvuGyFHL8D0Evc68sFDWR5kykB0+7rQG2J0Cdgb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785608005; c=relaxed/simple;
	bh=SXsivSMh9iWQ24V63T0fg6Kpm+74hNATyZa1/dwTShw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aiEh1953rVq9gYo6ZINA+/+++R4yJXjqgd2YR7B9z9mv6An8YGa/X0GAdTzRlfqvuS7iVnSSbvgo/gF9D+fhHI23jZtl7ZWHHgQc+a2aAKvYLExTd+MdjXjbjuC159Aj1KaMAq9vbwszD28S+DMDjxKQD5BagwIR7eL0SeNSg0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=syQKddqj; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="syQKddqj"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4955aa106b1so7544225e9.0
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785608001; x=1786212801; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hd0ELrFwa/w2Of1qrSLdHbeLZdS0NN7RCYxmYX9Fih8=;
        b=syQKddqjloNuFfBxNxv8Mov3FSo/eCU2yJYeL/S1PIRdwQljsM2RfzcS2LkaNPtRHq
         urOktBSlLsP7uPLUvIC0s3WAoiaK40+ZEWzL3H+vC0fgIaL5JQAfjYu7/FW2+lWH4I/M
         C/mo/hqUZhBqd1JM5gb1wdF/DRQn19+9durjC5sw4zHtl3nCqyQTlxiGsj/YUHNhndOD
         sCG1Cpmk+JxMkSvvXDpUbf24whRdsF/rlwe05jMUsH4Y83XHXnzsqRhOTmF9iZ0WCQ3D
         b3yNnpsW0/8sW1eV4OQh65tJUbvU3JnZ3kIJPUICTg3XYPR5UZ/G6Hv15hoLADd0w7g5
         Ep0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785608001; x=1786212801;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hd0ELrFwa/w2Of1qrSLdHbeLZdS0NN7RCYxmYX9Fih8=;
        b=ssDwQOl4hz/kCS1R6QVmjI+DDyYf/dEhzC5yhk7AEriNabkKCYm3zt+834GO9Y6nkC
         RoUep5jDs7Iss1KL6fZIjJrBN68DVuGJjawxFWPKk9vXJWELUhANjC9HFjTg7+qYFUA5
         OmFIMkxAlY3J8QKcNAAQigbQ6jsUmhdycOVyL1YKwOJt9NxttWjWJFtQphndT+83XUSL
         taKBEtZJ1HVEw3g2GBFfKP5RUIq3/EhainLYlL/MQUbGL+zN3D/lPYyvqBdNLLJAv3n2
         2MLBlTAxVMwzGyjBety9jTb017tQPSXBRjEln4vxp8v/qvnKj+GJjnnbkk6+jnPkAdju
         aQHQ==
X-Gm-Message-State: AOJu0YysdajI7REQqEAJJZ+3xrt6qPHvMWxPZTzhWIMQHRKRCy9MtgbA
	qRizinl69/w9GzqBXpZxrr0LXsSQ0QWtAWEbi0ntf9oMDNw6Q5j27CXxqjsWGQ==
X-Gm-Gg: AR+sD12zqJESE9MsgL2Tnh8MoRC/3Zsg87pAew7sn5VRAgYW6cfgW4SlBChlwxzPvZj
	rqJHsqBBgQzjCWaWEYQMAWFHgeYDvpPhs6KiB/EFlv6/+fRpYnCzduYDo8D+p8rT2WlKDABrEw3
	3VYMPqfvWlC8JWtaiY47ICk6TOxZCYPBb8eJ5vDq/ComSPQr54r7tqDrxU1DINZ2Mb2la+tU+O0
	VLwYpcmgUSqU7xNEygZ90sGkbE5EiYBlLiciV+GhXxUq+MvesCIB7LH1Bdyp4X2kKou4Brv4bNU
	8AD+fIvtN9M56xB604K3f5dLm2pM6yXNlvM68rI+uG9inpl1mULDQJy8Cck7UmnP7VCH9XNnD28
	Yq8NnX3ag56k1lox7Ce+F+C+NU5DFl+HrLpKHfK8dRqryukN28FISXDb+mjk/bJbicpqh01ojnH
	Vgjt0n+QegM4EKWVX/57/jIQFt5BENHobwiCaQGW1fee1EvFk8sMGb+t95RS9EXoDPHfyzqzrR+
	443tzr28TEuyNAcdHaJSh2ht1VQg80=
X-Received: by 2002:a05:600c:4514:b0:496:bbce:f3 with SMTP id 5b1f17b1804b1-4980eb4e952mr71898915e9.6.1785608000699;
        Sat, 01 Aug 2026 11:13:20 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:20 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 10/11] ext4: add dirdata set/get helpers
Date: Sat,  1 Aug 2026 14:12:24 -0400
Message-ID: <20260801181227.5198-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add helpers to set and retrieve dirdata payload and hook them up at
the appropriate call sites.

Enable dirdata for casefold+encryption hashes and storing unique
128-bit file identifier in the directory entry for testing.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c    |  15 +-
 fs/ext4/ext4.h   |   4 +
 fs/ext4/inline.c |  22 ++-
 fs/ext4/namei.c  | 394 +++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 375 insertions(+), 60 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 50c48c50a29d..2a7d85e60ae2 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -287,8 +287,19 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 					u32 minor_hash;
 
 					if (IS_CASEFOLDED(inode)) {
-						hash = EXT4_DIRENT_HASH(de);
-						minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+						if (ext4_has_feature_dirdata(sb) &&
+						    (de->file_type &
+						     EXT4_DIRENT_CFHASH)) {
+							struct dx_hash_info hi = {};
+							ext4_dirdata_get(de, inode,
+								sb->s_blocksize,
+								NULL, &hi);
+							hash = hi.hash;
+							minor_hash = hi.minor_hash;
+						} else {
+							hash = EXT4_DIRENT_HASH(de);
+							minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+						}
 					} else {
 						hash = 0;
 						minor_hash = 0;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 95771d92f8db..248c8c15e5ba 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3893,6 +3893,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
index 8221459cc656..e8b919430da1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1355,14 +1355,20 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			pos += de_len;
 		}
 
-		if (ext4_hash_in_dirent(dir)) {
-			hinfo->hash = EXT4_DIRENT_HASH(de);
-			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
-		} else {
-			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
-			if (err) {
-				ret = err;
-				goto out;
+		if (!(ext4_dirdata_get(de, dir, inline_size, NULL, hinfo) &
+							EXT4_DIRENT_CFHASH)) {
+			if (ext4_hash_in_dirent(dir)) {
+				/* Un-migrated entry: hash at legacy fixed
+				 * offset. */
+				hinfo->hash = EXT4_DIRENT_HASH(de);
+				hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+			} else {
+				err = ext4fs_dirhash(dir, de->name,
+						     de->name_len, hinfo);
+				if (err) {
+					ret = err;
+					goto out;
+				}
 			}
 		}
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index be2df5f58d8b..41719844e8f0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1142,22 +1142,34 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
+				if (ext4_hash_in_dirent(dir)) {
+					/* Un-migrated entry: hash is at the
+					 * legacy fixed offset, not in a CFHASH
+					 * extension.  Read it directly rather
+					 * than hashing the encrypted name. */
+					hinfo->hash = EXT4_DIRENT_HASH(de);
+					hinfo->minor_hash =
+						EXT4_DIRENT_MINOR_HASH(de);
+				} else {
+					err = ext4fs_dirhash(dir, de->name,
+							     de->name_len,
+							     hinfo);
+					if (err < 0) {
+						count = err;
+						goto errout;
+					}
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
@@ -1337,6 +1349,202 @@ static inline int search_dirblock(struct buffer_head *bh,
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
@@ -1360,13 +1568,21 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
 					 ((char *)de) - base))
 			return -EFSCORRUPTED;
 		if (de->name_len && de->inode) {
-			if (ext4_hash_in_dirent(dir))
-				h.hash = EXT4_DIRENT_HASH(de);
-			else {
-				int err = ext4fs_dirhash(dir, de->name,
-						     de->name_len, &h);
-				if (err < 0)
-					return err;
+			if (!(ext4_dirdata_get(de, dir, dir->i_sb->s_blocksize,
+					       NULL, &h) &
+						EXT4_DIRENT_CFHASH)) {
+				if (ext4_hash_in_dirent(dir)) {
+					/* Un-migrated entry: hash at legacy
+					 * fixed offset. */
+					h.hash = EXT4_DIRENT_HASH(de);
+					h.minor_hash =
+						EXT4_DIRENT_MINOR_HASH(de);
+				} else {
+					int err = ext4fs_dirhash(dir, de->name,
+							     de->name_len, &h);
+					if (err < 0)
+						return err;
+				}
 			}
 			map_tail--;
 			map_tail->hash = h.hash;
@@ -1467,8 +1683,9 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
  * Return: %true if the directory entry matches, otherwise %false.
  */
 static bool ext4_match(struct inode *parent,
-			      const struct ext4_filename *fname,
-			      struct ext4_dir_entry_2 *de)
+		       const struct ext4_filename *fname,
+		       struct ext4_dir_entry_2 *de,
+		       int buf_size)
 {
 	struct fscrypt_name f;
 
@@ -1495,10 +1712,29 @@ static bool ext4_match(struct inode *parent,
 		 * considering the calculated hash.
 		 */
 		if (sb_no_casefold_compat_fallback(parent->i_sb) &&
-		    IS_ENCRYPTED(parent) && fname->cf_name.name &&
-		    (fname->hinfo.hash != EXT4_DIRENT_HASH(de) ||
-		     fname->hinfo.minor_hash != EXT4_DIRENT_MINOR_HASH(de)))
-			return false;
+		    IS_ENCRYPTED(parent) && fname->cf_name.name) {
+			__u32 de_hash, de_minor_hash;
+
+			if (ext4_has_feature_dirdata(parent->i_sb) &&
+			    (de->file_type & EXT4_DIRENT_CFHASH)) {
+				/* Hash is in a CFHASH extension at a variable
+				 * offset (past any LUFID bytes). Read it via
+				 * ext4_dirdata_get() to get the correct offset. */
+				struct dx_hash_info dirent_hinfo = {};
+
+				ext4_dirdata_get(de, parent,
+						 buf_size,
+						 NULL, &dirent_hinfo);
+				de_hash = dirent_hinfo.hash;
+				de_minor_hash = dirent_hinfo.minor_hash;
+			} else {
+				de_hash = EXT4_DIRENT_HASH(de);
+				de_minor_hash = EXT4_DIRENT_MINOR_HASH(de);
+			}
+			if (fname->hinfo.hash != de_hash ||
+			    fname->hinfo.minor_hash != de_minor_hash)
+				return false;
+		}
 		/*
 		 * Treat comparison errors as not a match.  The
 		 * only case where it happens is on a disk
@@ -1529,9 +1765,16 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 	dlimit = search_buf + buf_size;
 	while ((char *) de < dlimit - EXT4_BASE_DIR_LEN) {
 		/* this code is executed quadratically often */
-		/* do minimal checking `by hand' */
+		/* Decode rec_len before ext4_match() so that ext4_dirdata_get()
+		 * inside ext4_match() never uses an unvalidated rec_len as a
+		 * read bound.  A crafted entry with rec_len > buf_size would
+		 * let ext4_dirdata_get() read past the block buffer. */
+		de_len = ext4_rec_len_from_disk(de->rec_len,
+						dir->i_sb->s_blocksize);
+		if (de_len <= 0 || (char *)de + de_len > dlimit)
+			return -EFSCORRUPTED;
 		if (de->name + de->name_len <= dlimit &&
-		    ext4_match(dir, fname, de)) {
+		    ext4_match(dir, fname, de, buf_size)) {
 			/* found a match - just to be sure, do
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
@@ -1540,11 +1783,6 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 			*res_dir = de;
 			return 1;
 		}
-		/* prevent looping on a bad block */
-		de_len = ext4_rec_len_from_disk(de->rec_len,
-						dir->i_sb->s_blocksize);
-		if (de_len <= 0)
-			return -EFSCORRUPTED;
 		offset += de_len;
 		de = (struct ext4_dir_entry_2 *) ((char *) de + de_len);
 	}
@@ -2118,7 +2356,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(dir, fname, de))
+		if (ext4_match(dir, fname, de, buf_size))
 			return -EEXIST;
 		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
@@ -2154,17 +2392,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	/* 'data' (the LUFID payload) and the CFHASH are written by
-	 * ext4_dirdata_set(), which is introduced in the next patch that adds
-	 * the dirdata set/get helpers.  Until then, only the casefold hash is
-	 * stored at the legacy fixed offset for encrypted+casefolded dirs. */
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
@@ -3743,6 +3971,43 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 	return 0;
 }
 
+/*
+ * When LUFID is cleared from an entry that also carries CFHASH, the CFHASH
+ * bytes are stranded: LUFID precedes CFHASH in the layout, so removing LUFID
+ * shifts the expected CFHASH offset.  Slide CFHASH into the vacated slot so
+ * the parser finds it at the right position.  If the headers are malformed,
+ * clear CFHASH instead of risking a corrupt read.
+ */
+static void ext4_setent_compact_exts(struct ext4_renament *ent,
+				     struct ext4_dirent_data_header *lddh,
+				     unsigned int lufid_off,
+				     unsigned int rec_len)
+{
+	struct ext4_dirent_data_header *cddh;
+	unsigned int coff;
+
+	if (!(ent->de->file_type & EXT4_DIRENT_CFHASH))
+		return;
+	if (lufid_off + sizeof(*lddh) > rec_len ||
+	    !lddh->ddh_length ||
+	    lufid_off + lddh->ddh_length > rec_len) {
+		ent->de->file_type &= ~EXT4_DIRENT_CFHASH;
+		return;
+	}
+
+	coff = lufid_off + lddh->ddh_length;
+	cddh = (struct ext4_dirent_data_header *)((char *)ent->de + coff);
+
+	if (coff + sizeof(*cddh) > rec_len ||
+	    !cddh->ddh_length ||
+	    coff + cddh->ddh_length > rec_len) {
+		ent->de->file_type &= ~EXT4_DIRENT_CFHASH;
+		return;
+	}
+
+	memmove(lddh, cddh, cddh->ddh_length);
+}
+
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 		       unsigned ino, unsigned file_type,
 		       const struct ext4_dirent_fid *src_fid)
@@ -3783,13 +4048,25 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 				if (ddh_off + sizeof(*ddh) > rec_len ||
 				    ddh->ddh_length != copy_len ||
 				    ddh_off + copy_len > rec_len) {
-					/* Cannot copy: clear the flag so the
-					 * slot does not advertise a stale LUFID
-					 * from the old inode. */
+					/* Cannot copy in-place (size mismatch).
+					 * If CFHASH is also present, slide it
+					 * into the LUFID slot so the parser
+					 * finds it at the correct offset after
+					 * the LUFID flag is cleared. */
+					ext4_setent_compact_exts(ent, ddh,
+							ddh_off, rec_len);
 					ent->de->file_type &= ~EXT4_DIRENT_LUFID;
 				} else {
 					memcpy(ddh, src_fid, copy_len);
 				}
+			} else if (src_fid) {
+				/* Destination has no LUFID slot; cannot
+				 * propagate in-place.  Clear the flag from
+				 * the on-disk entry directly — clearing only
+				 * the local file_type variable has no effect
+				 * because the final assignment takes the high
+				 * bits from ent->de->file_type, not file_type. */
+				ent->de->file_type &= ~EXT4_DIRENT_LUFID;
 			} else if (!src_fid) {
 				/* Sync the LUFID flag with what file_type requests.
 				 * For normal rename (source has no LUFID) and for
@@ -3797,7 +4074,24 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 				 * so we clear the stale flag.  For ext4_resetent
 				 * (error recovery), file_type is the original
 				 * file_type with LUFID=1, so we restore the flag —
-				 * the LUFID bytes are still on disk untouched. */
+				 * the LUFID bytes are still on disk untouched.
+				 * When clearing LUFID and CFHASH is present, slide
+				 * CFHASH bytes into the LUFID slot first so the
+				 * parser finds CFHASH at the expected offset. */
+				if (!(file_type & EXT4_DIRENT_LUFID) &&
+				    (ent->de->file_type & EXT4_DIRENT_LUFID)) {
+					unsigned int loff =
+						EXT4_BASE_DIR_LEN +
+						ent->de->name_len + 1;
+					unsigned int rlen =
+						ext4_rec_len_from_disk(
+							ent->de->rec_len,
+							ent->dir->i_sb->s_blocksize);
+					ext4_setent_compact_exts(ent,
+						(struct ext4_dirent_data_header *)
+						((char *)ent->de + loff),
+						loff, rlen);
+				}
 				ent->de->file_type =
 					(ent->de->file_type & ~EXT4_DIRENT_LUFID) |
 					(file_type & EXT4_DIRENT_LUFID);
-- 
2.43.7

