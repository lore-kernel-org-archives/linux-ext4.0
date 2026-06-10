Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65C427A14
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105142; cv=none; b=e+MEBhchnsNGEtSe/nbTVmxBL2/oGBgWBoeAP5gE51D1kl1aWE+pxAkKv21TDhh6Ve9WKuA6yfzYTQ2clmQVslNDXOb9AhwX5bvNJh9DDYEZDFcIPJuAcMWPMs/YEcv97yML24VlY6Y9FEKqS/fr/5zRdT9JpLCUMDMWrJaBRv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105142; c=relaxed/simple;
	bh=CDKhbO/rjE8ZGGWLk6gMHxwsilyKJF1G7WOUJK7OOCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcTTQOo69GrJawPmWDJgx0zRfBB+i+j5DfVzo68N95wxnKtdfPw8WrY/DXvU9WICVTIpU6RIisSBtOqlcetlxvlavyrovkwqmzwJE2Q0v2s+lrmKwPtrMSC7dgzU8BTEiR2LRL+aqItbZgCuAtI3+8bcsrZzE/eY2iQJUgfWEMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tbeb6djy; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tbeb6djy"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490cdae130cso23920805e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105138; x=1781709938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2zx0nEPL7VMIMp2uYVMz4yuYCimMFeWx76JuNd7bAA4=;
        b=Tbeb6djyQ7ynMtxJzstIetp1m5JEXDmN2c7/po4aOjKhWu/nsifimVCr60YrSBr/PO
         +OdMSt9H0DpXoUNK1d+65wVWqLi+vvFZnEjPIoidy0damjEi2KJTRs9UIFtY/1fskchv
         6dSl8ih8l2dnnasfsPqNqHoBSkYkriJu/Bd6GRWSA8lngxZ0ts3JH/et4xzh3ZlKXwmC
         RmvdLld/OFlBHymD9uAxNsN5u7vJ95YwnUkfGFvVw6kccH01xaM/6GOsEkLMVDlJc2bi
         7V4NgAiZ1I3pAnmSfw8iIlRPMWprNZK/efVEOw4siP2xs57Bz6r6qDP4FUFqfaOKMCXq
         2/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105138; x=1781709938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2zx0nEPL7VMIMp2uYVMz4yuYCimMFeWx76JuNd7bAA4=;
        b=OF/D48j02DST26HZyveAP4ZBi9xSAjxqEkB1aZc5u8yxTpast4ry5kIw6bc0p7ddU+
         Hm631TJK4ueLP7gtUWSmhB1OGZp9Hys+USj8aZzdoeN7ibexM4IOV96iQq6BJlhbE9kX
         nmLWFdg3k3o+OCEeMCLlWDcccJ6CJ4GwIsbjNLid5dI6y4F7k4XojnzWp6Q8uqIZeXC/
         f0PKlCIu5m2SMO7e8Nj/vlTsiI9sBTmUcBapYhnHOB+uCWB9DM7gf9xNDcDzSRdY2Az8
         qkb7PNuD1yFc0UE+XihGy1xFdJXEyWtpo3e3W28uhbGKtC0MrPgqjl3jQLFSeCNmWtt6
         lFag==
X-Gm-Message-State: AOJu0YwyVR9WYMDlK6jX0v8wylvJz6l0n2oYwHRzCQA7Hsg/ywHqJica
	9zzT4cR8XS6wqIwTx2UDVg53S7zUgArIDiMGe+EARPle6PeJLiOaIC3vpSOk3LqJZ+8=
X-Gm-Gg: Acq92OGaBPIdNktxWIovqfz+wYC2S/FBWo24qkFZRNR+bX7jOD7Sj/nWToTNrGeTeQq
	sTqK+XS1Y3WzKKYG4uEy9YZ8VUTCh6QmcUVrSqokLhGvE0DoPfXV1HenyTb55kz1pI7tdX54s+O
	g9L0fiiTM9gefsa0QDBnmihEdeB8aevCt2liVH6xRungFLbdiUMf6pO183TV5k2XnFWjixrL8Aa
	6dUj3xOKqTrWfSf0pvROcGLlK90yYrwRnrzxht/DwSZ55SSI1HIVD2AR41g+8UNmQlQiN68agaD
	26z0Cmzm7nP0OFADxYaVpZDDsN24sXQ+rEAORH3EujVL9g9AnMktxjqOUzMtFK/HCxfs1v10h/s
	smmPsdHZul5/CuWUoTUIcRmwo35o211Nncgx41OxwGklkt47Bh0c+3XmVFzBn8/Y3boJKLTUe5e
	Pt+dXrW/M8+tebt+wXVuguN84BhoY1UL9aIjANwAysZbwGl/MnKAkGzalvQrOdxl4=
X-Received: by 2002:a05:600c:34c5:b0:490:be9e:fd07 with SMTP id 5b1f17b1804b1-490c25ae3e8mr409953595e9.10.1781105138159;
        Wed, 10 Jun 2026 08:25:38 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:37 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 09/10] ext4: add dirdata set/get helpers
Date: Wed, 10 Jun 2026 11:24:12 -0400
Message-ID: <20260610152417.13576-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
References: <20260610152417.13576-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c  | 196 ++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 176 insertions(+), 30 deletions(-)

diff --git a/foofile.txt b/foofile.txt
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ef99e4fa99d7..defa18d98c74 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3787,6 +3787,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
index 40a3394f7eac..c799f87d7459 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1084,22 +1084,22 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1277,9 +1277,160 @@ static inline int search_dirblock(struct buffer_head *bh,
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
+
+	if (data_offset > de->rec_len)
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
+		struct ext4_dirent_fid *dfid =
+			(struct ext4_dirent_fid *)(de->name + data_offset);
+		unsigned int dlen;
+
+		if (data_offset + sizeof(dfid->df_header) > de->rec_len)
+			return ret;
+
+		dlen = dfid->df_header.ddh_length;
+		if (dlen < sizeof(*dfid) || data_offset + dlen > de->rec_len)
+			return ret;
+
+		if (dfid) {
+			memcpy(dfid, dfid->df_fid, dfid->df_header.ddh_length);
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
+		if (data_offset + sizeof(*ddh) > de->rec_len)
+			return ret;
+
+		dlen = ddh->ddh_length;
+		if (dlen < sizeof(*ddh) || data_offset + dlen > de->rec_len)
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
+		if (dlen < sizeof(*dh) || data_offset + dlen > de->rec_len)
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
+
+
+	if (dfid) {
+		unsigned int dlen = dfid->df_header.ddh_length;
+
+		if (data_offset + dlen > de->rec_len) {
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
+			if (data_offset + sizeof(*dh) > de->rec_len) {
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
+								de-> rec_len) {
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
@@ -1299,9 +1450,8 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
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
@@ -2089,13 +2239,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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

