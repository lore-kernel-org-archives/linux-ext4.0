Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713833;
	b=V5IVYnhOPwlyR5FX38pQqq/78/GUtHPILxoIs3WZUH3eIpjm6686QlNtazxVbIvrvtxK
	 naHumKjXrX7jpMoF3k4y7qfyB/3pGx5aeTSgVeiJCiGmKeaKuV8nOwnbiH3SQB5Rn+jQD
	 YCIm/AdawY9W0iqsJcHGL+dqYLzRbwaIv7pSx0oXZJQ719bxWyENrk19kVrAppSsnsJ9c
	 IKgZTUCJNdpq2dPQtIun5XY0pe08PR5mSYuDhcLeLYC7UUz7VUWhCRcXmkjh/+aWG/On4
	 a8kJ9y+OX3eq0c0+vVEPV9MjLgAgX2y6JFBzP8bKWFq9iyZPoRnahEj7+2Ioshrvbng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713833;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+yFOPnk8x2kP+Vacn7rKNqUG2kxR0LGnPRPVSbzLBGs=;
	b=GRWkShy47UeIgxDviAG9YyPxtmT9MRMPHDh5/QlncUOS0p5Y8IgURU7Y1PJRqtYHXMsO
	 944OTfGp28pQ+zFqQX8YsuQrkS50J7lvvLd3S0egkqI9Qi1cCurXokE90T9g+YYtdBjsO
	 uA+333pu3KlzAst7WhsRj8fUHRIpMKfdAcPBKGzEs4Vqvoq1bVKbZ0gC1px5k8ipFEaxb
	 qGHDwS2yn6NhpctbemYgathsuPVEDCRp6cjtzqb8+z68TgGP8DTYQkpM54N34j6wOZR6s
	 hG7KhNQNG4pC7z0tee2xE49eiyTW8MISdmfc0mS34QK/Mmw5J0i0+oZQFxR1AbBxecw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nBdvYJmt;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E94606A33F
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91E94606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nBdvYJmt
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso39760775e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713831; x=1794318631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+yFOPnk8x2kP+Vacn7rKNqUG2kxR0LGnPRPVSbzLBGs=;
        b=nBdvYJmtUBu17ApAzX0NLqAhaNBPuz+t3gQ+T8crejx/vXYQZ8FTFIraMH0sInHFSV
         vWhcD8JWEF1C5WeeDQ5BCt097kcVyWM+EMcIpsfss+MbWt+p1lOpXw683zBLLsYwRSr1
         KpKAmEq7qogkvMf8cEZIN1XIbPzajCEtwDDvz2byPJ9LDgPl440P71aimANJkg7lLa3y
         UZbWYryRrQaj8EqGG03aHJAImSl1HRWf7coSp3CCwI5fb8cMym4OMix6NN1r7IsrOm6N
         ekVExeNW9Z1ZB4+y2ilz1QSSfnz67gXQ/uXWNv33w0z4wQzYijYbGooIi9BUjaLTmzFh
         65vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713831; x=1794318631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+yFOPnk8x2kP+Vacn7rKNqUG2kxR0LGnPRPVSbzLBGs=;
        b=ILhGV7s/OXnh1LP73eWyRdrmN/7E9FZZDHh4mb0BU9iA7zURCk/y+AL2Q7mVxifFdC
         ynrrGuGETUhn4BmaKsuYWwQ2UGyRupwMDd7iOL/EwkICxldnkuoySAee2bKfnVQxwXil
         JdO/+LhzXSgV+nUZOTaen9dCC106ydjxQZNBrn1tRUFjUaGcaYYYkT1LJ5qvQsMbLsaY
         p2TO06Mde3/XDwrsjyosoXlVdXgWWeGNCLjeUa13/wSQDbIH9y/aPHrV/D8qQ3vBFxSa
         i69dv6rbWvTml8fuRgWfT0gZ58ktRSAFiAMgutLSGzBY21StvCcv6PK5ZAEChg0uAQsr
         bfAQ==
X-Gm-Message-State: APuU4Z+CYuetFUbiABjxCqW7/X9bIeVXwcP2XbxFki4W7gOllOMZp8WU
	mfsVa1bCRxV79n5McfXjQUHrjuFPqXx8/HQVDqE/z7sDqL26AV0yfKtQABgVr9qgdKs=
X-Gm-Gg: AYBFou3EQyULwpPMVXmiY0LkqUAWqFSAF2WOVatY792y0mZGgG54nsfdGxD4fRgpZ+r
	NYoMSpJ8trvo0CKS5mZFuNB9aT9nUAab6wrFFFX1gjTdywNWEQJZTf4QpPFlz1286pDvigoUAjL
	8c8FweUaoMFRXjZKR3uXXeaWmFz2B675DQxEdxrbMp3bEQGC5zr/ucXYnNgmphZVDTKibwsuyN0
	tPt5ZtAj4cuGT9RyEhe30AsCVe2coDQ4eAiy7RC4664XNaDnkRcoZZC6WOAIY1CQhI0KW8m/ZmY
	YIQ+QezQRuKEeLf5WDGXRSJX32Ct3fyhgQLGTUq7fzmBKjY4LKAiGhl4nM/+md8ub/3oo5GZioU
	H7D+4/fezed7QPWqLZrdH95eu0g9VT3dbtrMXM4OL8IPGOEGxPrw4vMwBfGPNypMHv4kjuc0mb6
	4vD+URPHi18Ugmi30EzliZvugnhTARCfu2mFdMerJpn33aYxj5N5sD4/x4CRkpMf3AxsE1kvyE0
	25lk9H6d8Q4S+K9q2YDyluAmGyh3h5SqbI2c+CY98lCbY/sRKW23LoOXJiBkEywb7suj4EWQRej
	CCoHwjFwma9kwVy2dY5L44c6JTqzn5SDMI/fj7BY0Pk2C9VnWuFrdx9/I74Q
X-Received: by 2002:a05:600c:1987:b0:4a1:6517:ccf1 with SMTP id 5b1f17b1804b1-4ac16fa2edbmr304191665e9.9.1793713830908;
        Tue, 03 Nov 2026 05:50:30 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:30 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 11/12] ext4: add dirdata set/get helpers
Date: Tue,  3 Nov 2026 13:49:18 +0000
Message-ID: <20261103134921.610047-12-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Add helpers to set and retrieve dirdata payload and hook them up at
the appropriate call sites.

Enable dirdata for casefold+encryption hashes and storing unique
128-bit file identifier in the directory entry for testing.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/dir.c    |  15 ++-
 fs/ext4/ext4.h   |   4 +
 fs/ext4/inline.c |  22 ++--
 fs/ext4/namei.c  | 322 ++++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 307 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 15816f2a5f47..12df2d2a0997 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -302,8 +302,19 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
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
index 4a7b36e1910e..32119ab18ac4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3978,6 +3978,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
index 81e0ef1c8833..801fa6555ea9 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1359,14 +1359,20 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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
index bd0f4760f1e3..8f1a6c000373 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1178,22 +1178,34 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1373,6 +1385,204 @@ static inline int search_dirblock(struct buffer_head *bh,
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
+		if (ext4_dirent_rec_len(de->name_len, dir) > rec_len)
+			return ret;
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
+		hinfo->hash = le32_to_cpu(dh->dh_hash);
+		hinfo->minor_hash = le32_to_cpu(dh->dh_minor_hash);
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
+			dh->dh_hash = cpu_to_le32(hinfo->hash);
+			dh->dh_minor_hash = cpu_to_le32(hinfo->minor_hash);
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
@@ -1396,13 +1606,21 @@ static int dx_make_map(struct inode *dir, struct buffer_head *bh,
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
@@ -1503,8 +1721,9 @@ int ext4_fname_setup_ci_filename(struct inode *dir, const struct qstr *iname,
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
 
@@ -1531,10 +1750,29 @@ static bool ext4_match(struct inode *parent,
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
@@ -1565,11 +1803,18 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
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
 		    (!ext4_hash_in_dirent(dir) ||
 		     (char *)de + ext4_dirent_rec_len(de->name_len, dir) <= dlimit) &&
-		    ext4_match(dir, fname, de)) {
+		    ext4_match(dir, fname, de, buf_size)) {
 			/* found a match - just to be sure, do
 			 * a full check */
 			if (ext4_check_dir_entry(dir, NULL, de, bh, search_buf,
@@ -1578,11 +1823,6 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
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
@@ -2153,7 +2393,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(dir, fname, de))
+		if (ext4_match(dir, fname, de, buf_size))
 			return -EEXIST;
 		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
@@ -2189,17 +2429,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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
2.52.0

