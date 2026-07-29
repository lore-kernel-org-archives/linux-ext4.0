Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923C3CB57A
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354879; cv=none; b=KfrBjjnHZkwxRjTFBk0GBctbsUTipUve9h7BQVJZp8n2DSpWS9CuryDJJWv5kBcDbbJ73e1IQUTOO2YCfOYJIfjiVpCJGp5YZZK+lolXwZAXdh7v1Stqyb+OdxZ8X5GJoxEkKCkTMsi+iWuQCys8Gp3+3B/8GLyWU/WPruzFD8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354879; c=relaxed/simple;
	bh=VIwKS8FsPg/HMAGNnBAMOY0MG3z94BlbXVca/cn+ybA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KupNUiz38dGFW96YutaZNMVg9PgW3C8jZ2ZaUkhmdrB5lJQwwEdCHfiR6Ld0ZfwAHamBOzm/Y+tFadYv/YgoG+zIdMObeGwMjpZhjBOsdWn8GQzegqghjCjONmeVyo7VPBl/XUhAN9GPAlok9Ay0+0AIWAZ9uky+59gl6IP36ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZCvC6F+E; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZCvC6F+E"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49550ec592cso526105e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354876; x=1785959676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2y+9T/Ey+TCu+LSrL5OtCmeXvKjA90NPxvnz1O1hEig=;
        b=ZCvC6F+EpuYfoU3A6Xnettgj3ELMIqMhI3FTIgvuHnoCUDBcfNgu2nDlgDUzX/fCbE
         nZSJLDMf1wGAWo0WfzAmQIpwYlckQ+clN7u5E6lfuatnInC0QFtKPAF5a1ebi5ZH1iyl
         efzajyKTAnUYQfNTuaxW9e5QKcsxmXP7xVL/7Vr2Q6ZUvq0/5lJbHT5gBew1nzRHR1qU
         RFhoG9zgf2lXkMJOjNaL+Ui/A3MYkGkm9QYfJ2xSF7KisSyqZnlGnp7GmQP+t6tBSyXr
         06NW6P1ksMM58X85UTcMZamQpFucbtOf8CjyKiYqvNcAcdXN3NA3ExzmmNwSO5Dwsk7y
         jaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354876; x=1785959676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2y+9T/Ey+TCu+LSrL5OtCmeXvKjA90NPxvnz1O1hEig=;
        b=oUK2NtF4QusojpvOyD5RUPuzjpY0xT6aJCQkJZ2yiHLJLSfz6m5yJzN7EIBKZ+ult4
         GSph74i9WrLE1Erz8VbbodBTDvM6oRHewiVLSqDLQRYQzoa1sOZ7NyfMQlxQvRsNeuPC
         EmSS/H3prTYPqfz7v13WtVWzcoqc8+sv8rZz440273ViOoWJom8zNKvNSMFbkw6zA9FP
         5sH6qHcSJccyg6pD5EqpL38k9KN8c6q0aRlSpmsNhZoCYN3g++enc8xf4jNiyOU+aK3C
         cmgPTBD5d8aK3Su5aeemG+gkVnyYPOIs+YS6mn5C7kn6kRV4WSVn1nwIbwETYdifX2Tk
         EDIA==
X-Gm-Message-State: AOJu0YxfeBSIFE1pxvMqK1NEs6oCbjurwAwqKszw90xqZLa9OMQYHtNs
	/WhCvwmY6W+dWi/9nRgrMwxLRb4wjKz3pbuPLOAeb71NuhYfbw+0dlonkUbyZq/2
X-Gm-Gg: AR+sD124CiPRQkyu5fGNEHrZKv/NpUCKvPar5mCj8I4hBRhn+32Ruxnax99mgs7LTFN
	DhfJpTaDOqc+QgVJG+khw8CxfAKO5f5bWylMm98brNpudQZyVsvviNMcSZm8vCbAzoIVMSUPoMm
	1WxPE5ebYZi4bluHCt7XSmg0s43J4Tr12GcCyOII16+XqPHi07XRjkqe6QUp/IFDyUHvEBKhne/
	yhqGQaRE9mcAXy4P61stHEnyyOUAibmrRWSXeOtTaJgGZhCXMWPTd/LPMK59SUj9aGRsrBFwZfI
	JgLghjb2X0U2ter2l7cKEiMLKiGH+FOdbS105KWLHkV91tog+rkiUby3/W0+SwEw/0k4SViZ5FS
	N74WZud0wnEhsueNX8RbZ5i2DzuIKY9SUBIT6GSweWLXYE5KmC89yR2faxbEH9CjOkOEo7wrKCJ
	mbicYsvQUV0eXtHfg+3Pcc5FwrfvBtXbPxjhhdsMvWEFZoywn5jPLegMsQdQId6wR2DgNTnPY4/
	3eiRbRu4zCr7/agjxQBpg==
X-Received: by 2002:a05:600c:4f93:b0:493:f478:4c71 with SMTP id 5b1f17b1804b1-497fd2f9df1mr39382665e9.7.1785354875413;
        Wed, 29 Jul 2026 12:54:35 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:35 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v8 10/11] ext4: add dirdata set/get helpers
Date: Wed, 29 Jul 2026 15:53:28 -0400
Message-ID: <20260729195333.20626-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
References: <20260729195333.20626-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/inline.c |  22 ++--
 fs/ext4/namei.c  | 297 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 279 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 63d022ba5484..bdce927505d1 100644
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
index d5ca9049171e..5c0805e1d535 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1140,22 +1140,34 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1335,6 +1347,202 @@ static inline int search_dirblock(struct buffer_head *bh,
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
@@ -1358,13 +1566,21 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
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
@@ -1493,10 +1709,29 @@ static bool ext4_match(struct inode *parent,
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
+						 parent->i_sb->s_blocksize,
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
@@ -2152,17 +2387,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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
-- 
2.43.7

