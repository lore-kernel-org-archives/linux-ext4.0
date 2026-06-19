Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFBE54652
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896323; cv=none; b=aTloMsnR1h4DP/JUPxkBda4eXXUg5Z+WYH/f4q2or0SqjyCR6oZH0xIs1meWnTbXBb7aQljFVPjDyM/Os0obbacFv4cDuqk8yICpfzBu8/pEHFjO5/CVS3VWx3mHcdam+3GkqbU4JTlh9hCpUQPJ1U2LQC+ORqxgz7YcKlWU4L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896323; c=relaxed/simple;
	bh=9PnVdC1uoGRYDORWf6jgmYT6Ri+k9N/VIPJaZZQUhKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dstIEReBikqE+iv+HPS9YWK0lE5VFA9KvMXCj1ER8kxGjdklA0jpuHBq76TthNLBrZsevc/CmasZ0k1j2FPsKGZpVXr3O19n1o4wtraK/wPy/zl5GFKC5TjttotzOJEJQxayP6h7tvU5s/4ttmaB0tODBvqLbXlD4XLD+/sK4PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=baU2Hq5W; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="baU2Hq5W"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45fd461e4a5so1881653f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896320; x=1782501120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zE1FkQ2xkCqSaESpTlfH603VYp6B4/DEmIbW7e2tfLs=;
        b=baU2Hq5WOeApRSJpQogHRtDrYVPW03Eyby6yJa69AQUace9puMwDfrRLoYTplChTba
         z7h625YlhEZgK6oDxEXH7v494QZqCMDcXWvDnrN5ljOSRwe9I9U3Ky3Wm/YnncJgVdEQ
         lGnRE2LHkq66m7NWf8EtHeLdUQMRPsJn0W1RIxOGpN979bHtKw7cUziR4EBfHtGxPnEg
         fvpSvRwBixlbcUhaJEPDKQQmUzFQCvkOhH6aOQyMj8nWGQI1rxawFJSE08dW5Yi4OUBR
         8DZ+RJNzI7+kCDeQfj/vThifLpRJPW8t697GNTf9DmphG7u1tPQdaY0M8hKFVogOvN4I
         Tu6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896320; x=1782501120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zE1FkQ2xkCqSaESpTlfH603VYp6B4/DEmIbW7e2tfLs=;
        b=QKi12WQ54RJuIFV7Rrlb52oXYrqefPFOmxg1mTLCHVOLnb38U619rH91/8C9Wai5iO
         p8+RshVVI0Vezms62nz2gZBeTydj54v7S8ZO7JOq6rrPSxuzLFfw8IKGgqRirqVqMo22
         NSFQYkmQhrqYV+aTs7j1kEn3jSK1rBrPj333u+CUk7ZOCHUuwx9qJIpNpygDiuhwZDOB
         sgO93LtxoTgb58cPOqyq+zgxH7nGQtrll5K6OYOPxV+EeM3B4VeGLK52MZwCmr6OS8zP
         bzvneHykpGiBD3TastXiktwgg58UNmTFUSsGIuq+pezwN2Z318F6cqRe67mXeV7MPnef
         yscg==
X-Gm-Message-State: AOJu0YxQxlPV5LT2yUW8M8IOm86v8QZLoxDITIGnJ9OAPh+En/dqZ7MD
	K8ILtxRXykwRMN7thbk08BrhSO3v/b1sWxDq/KT8ZCVi1/XGdKRJ6mUYvq0A57qItpCs2g==
X-Gm-Gg: AfdE7cnwFvYxCqhKeZJpLc6j9w4lKBKoU6B+SGgf6TukuN+XL/xj+mZpWDSUd+Lb1Ts
	FAz8sjdr57crF/W4B4q3PJjQ3QW+dUSm1NVMVktzyTaWFYlP9dTPgQb33IUH0YQ4WeSXvAAZgx2
	EJlyr8KPhTz4jk0vccX7D3tainhRJsLVkjkPDCCLXpFoyGgJS03oTKRCn2mgzLKyGl0+3O9NQbV
	XJHxdnEvcfgtGPOPzP3Me/7Yi2h7pR+jx3TSQn/0K1gbLT6zJ7XNs8VAOzNJmHV6zQDdhARcoMH
	X0ak0bt+VzL2bM4C87v2G4ww6oTN0/EKuklPlAeuBpiU+J+yhg42gLEq7fg7iWKneine5WVH1m9
	tkA8Erd1BkLlT6j1hQKYSi5nJDqPlgEcJnr7oxKH+ertNu2Rg4acRCdi7adCMsCOHzR9aTB68Zt
	mzTTUTS+kTZZWw/BB9vcBuUkb2tGO0y9isGs94eZUOwA==
X-Received: by 2002:a05:6000:1844:b0:45e:f8d0:d22c with SMTP id ffacd0b85a97d-4656dff26f7mr5788824f8f.25.1781896319808;
        Fri, 19 Jun 2026 12:11:59 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:59 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 09/10] ext4: add dirdata set/get helpers
Date: Fri, 19 Jun 2026 15:10:13 -0400
Message-ID: <20260619191022.27008-10-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c  | 201 +++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 181 insertions(+), 30 deletions(-)

diff --git a/foofile.txt b/foofile.txt
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d4ec450c05f2..543c8e87f207 100644
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
index c57a8ebe4f94..71c395c9a162 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1346,10 +1346,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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
index e230fa1094ff..c8fa8d4940c2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1097,22 +1097,22 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1290,9 +1290,165 @@ static inline int search_dirblock(struct buffer_head *bh,
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
  */
+unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
+			       struct ext4_dirent_fid *dfid,
+			       struct dx_hash_info *hinfo)
+{
+	unsigned char ret = 0;
+	unsigned int data_offset = de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len,
+						       dir->i_sb->s_blocksize);
+
+	if (data_offset > rec_len)
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
+		if (data_offset + sizeof(disk_fid->df_header) > rec_len)
+			return ret;
+
+		dlen = disk_fid->df_header.ddh_length;
+		if (dlen < sizeof(*disk_fid) || data_offset + dlen > rec_len)
+			return ret;
+
+		if (dfid) {
+			memcpy(dfid, disk_fid->df_fid,
+			       disk_fid->df_header.ddh_length);
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
+		if (data_offset + sizeof(*ddh) > rec_len)
+			return ret;
+
+		dlen = ddh->ddh_length;
+		if (dlen < sizeof(*ddh) || data_offset + dlen > rec_len)
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
+		if (dlen < sizeof(*dh) || data_offset + dlen > rec_len)
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
+
+	if (dfid) {
+		unsigned int dlen = dfid->df_header.ddh_length;
+
+		if (data_offset + dlen > rec_len) {
+			EXT4_ERROR_INODE(dir, "Can not insert FID");
+			return;
+		}
+
+
+		de->name[de->name_len] = 0;
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
+			if (data_offset + sizeof(*dh) > rec_len) {
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
+			if (data_offset + sizeof(struct ext4_dir_entry_hash) >
+								rec_len) {
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
@@ -1312,9 +1468,8 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
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
@@ -2102,13 +2257,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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

