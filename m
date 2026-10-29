Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276838;
	b=C1K1+vckH5n3qK6yWa+0xVcwL1ro0+2zZF3p6m7FRfZKJfTVlmnr8x1vneTINUb2bqVn
	 Kw3il2sgQJWvIlBb4VHUquWS68XSIV1LM1EILS/AOU0jEnSLo89DzyyDjhpv0bdWJSH9B
	 QnJ2HAur3roVFiZbWVu5ol85LsaQSeDmOhMvNqhhyvrZ5uerXmkopOAb41dYFIF/NcbVw
	 lCdIUHAEMqIFS15uCYNwPFcoGt6SAWJj1so8D6RMEPNUddaJv9Cjo+qckc9Feil/qTqOv
	 t1gvXB4K7IdKosyPtplblCYpSKQ5zwr6F+Hn1dpW6+PaYFR5ftYPUF2/4hJrRxqDMjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276838;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=7JLyhZwyoKfcmdbbAgTIBc60cEVdv6uvK5ddNo/gohY=;
	b=ZgLEOpaBm+KnRM65uFKOgwXufaXmwpZAdNp96UnHTapMC3R7q9UtOCwcyGaY+JslqG6/
	 V8WPx08ud51YSTCgfNTJ4Aq6CP6RT99wL4jyvIwmAiO8xzw8ozj5QIhDEVlNAnhKdQU8R
	 Wnp094PIbCb2NRS/Cr1qc+8ja5WL0NvktCYhoSJjfzPijRweBbXuibrl4GKmLTIGLQigL
	 GlMKLTyYzGmUWXqjx5RpVKNAythYd8tJe/doC7oQui+GeM97ClX1BFba1A8+llSLYicza
	 joCFMMiPkL+L7lWlOUc4HY/9foY/jv5i6F0s64f5jsDvo7JQ6mtSmA35AYJ4GSMKkCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V0uwOQr9;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A552606A330
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A552606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=V0uwOQr9
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e0d1da913so454934f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276836; x=1793881636; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7JLyhZwyoKfcmdbbAgTIBc60cEVdv6uvK5ddNo/gohY=;
        b=V0uwOQr98eSQ6ITBpqI7UUz398sncOgvXByoUg2/fCwSGluL3y5smTJ9UtJuuKqY4j
         gwCpmP/We/QeS2Z4jna/6CieQ8CtRn3PVeHwgypQ90hNfKBNtw0CsLDxex5KgwLK+Z0N
         4aSmU0luFJ5WhKP6GYwZyX+Eypg/gjaZ0X88jyKp60VNWxKigj+LwWijEbUVYFRQtWCz
         p20aBf4gugjuwIZUoFW5ilqI1p6cOYFXEuD1taPXhfCKK2KLruXMmJ4L2ffSnvvDCuGc
         2Uk4p/3zV4N/fqHtXdxu+6/FsW7NoAjhKaSCVHWHf3+ag889LPFCPgN9m2YXbM93gTar
         TVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276836; x=1793881636;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7JLyhZwyoKfcmdbbAgTIBc60cEVdv6uvK5ddNo/gohY=;
        b=loYB0JEl4xh5w0+r7Ly7xlMca7SakPs4u2mwScjDDOTvCpO8dKR5NN1CIirkWRH2Fx
         mVnZH7kqjZdVkdKs5erNwqmWF6EvWi5Hb7Wil52GOpjKc/HAwMnp1tTk5lPgwLKyV8f5
         ezy1Uyz99Fl3Zvq7xsdCJRPhr/Dj6TxShThesy1CHUCm2BuOkPW1HMoJXizylCZZ4g09
         AvZBEGOUCfxuKsWat7Le5OQzecwmAkDLKC3pawLCtlrLn/rsrwQcAVvBI3z9vTmCHkK5
         WkJLT0yEYiyDJ5GC1nE8tphVu3bnSEWVPqt3TzIs8Uc0N0t6FiClb/Paldse5aEzGVvL
         infg==
X-Gm-Message-State: AFq9FYJP+/orLfWRej+Ms0lISF3vWtBmLPsD8FICYHDocfpWxIlgFTqy
	iWQSG6Rw2/c4Ro28sPYXquMgaju2+lchr5DCziJFXlvS9exX7lhOE2E5s7gOchhD
X-Gm-Gg: AYBFou3DkP9v6qUdHmkMg85Lz6lk3BkUmfhMfo4GMrid4561Z+VIiVbRzY6v7UUe7gR
	Glt/VL/NOlfdHKIXLwQF7kN+O4LfHJYKSTgIzbbbczpcgGBBQw6TAD/TQkjTSf4C5RAFpNwNccy
	fm5oA+MzDTdaX6jSSFX8Y3hBProiyQvJwlXjSz2WVgNIf75Rqe269Z/ptnrRQPHTjpc+TO/0Y8T
	dU61MJcijwGR09ZBG6R0Acr/kNZd32zKFh81C5ZzyMpfafm/dpqkA1TZs+dBe7RmSEWDaWfOp1Y
	zohxPMGvuYXW+q+NbMt8ZC35vLzJnRb7IKnXPnCE9SFWwX3cOyNPJyXAaLyw93g/dwS0SAY2gPO
	KugZWLzKm0UK72KS2InbLlPa58MNdln1/6GTC2YAWfRGumd5OIy5Qw2fItpZ70hP13CcUCYhxMo
	ygdGpBX8Jttgl3pLbe8VzJBbaW4LA8EYTP18177HWjMq9/tK7FG/WEdlVJ3LcfzG5L7XmTtERah
	oHviK+31Iq6rPJTi9jrWMJB+14iVfx5iQnaRtoIZByzXCW0FtL+GPpT4NlAr2m79xvmZZGUijJe
	aBTdMWQLzG7EXeorFMmdOM6gWkMsrNYx/cAqOFVyA3rAWJRuMoWkS/xrvSaJ
X-Received: by 2002:a05:6000:2c0d:b0:48e:661e:8766 with SMTP id ffacd0b85a97d-48e661e88c5mr5525975f8f.17.1793276835714;
        Thu, 29 Oct 2026 05:27:15 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:15 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 10/11] ext4: add dirdata set/get helpers
Date: Thu, 29 Oct 2026 12:24:09 +0000
Message-ID: <20261029122413.230409-11-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
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
index aea75a320ceb..086a8a0d340f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3980,6 +3980,10 @@ extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
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
index d3dda1d65d06..700a0282278b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1364,14 +1364,20 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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
index 433bee757ea4..5a118320eef9 100644
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
@@ -1529,11 +1765,18 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
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
@@ -1542,11 +1785,6 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
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
@@ -2120,7 +2358,7 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
 					 buf, buf_size, offset))
 			return -EFSCORRUPTED;
-		if (ext4_match(dir, fname, de))
+		if (ext4_match(dir, fname, de, buf_size))
 			return -EEXIST;
 		nlen = ext4_dir_entry_len(de, buf_size, dir);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
@@ -2156,17 +2394,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
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
@@ -3746,6 +3974,43 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
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
@@ -3786,13 +4051,25 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
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
@@ -3800,7 +4077,24 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
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
2.52.0

