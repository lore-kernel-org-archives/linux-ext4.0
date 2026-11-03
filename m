Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713828;
	b=XK3dZRhyleGsIy9tdn6bxXOfHtUWPbW8ztw/yqgbs0JUSomvG0eshPgnUbau+99FjWoF
	 cs8vvVdq3JtWEQedsMzcsS9+wlhDkTBPxsL37Tu3Q0LuxNDoReIxnpfZgIOOnwltcXilj
	 b2nJhTnc62/LuO9cBRNVwF0v7p+dmq7mXzFd7CVd9HURB+LV8SmQER/59xRZrlF5uBvRu
	 XPV2IAHzybv4PIQRuBe+86KBFyYFKo2hl4B7TV014jAskfEwMzJtHFjCZGubQ9o7WU/VH
	 UW41iD2DGYHMVx9xZjg5xuD8LY2GtrpHMLadKKH6Yl0l7O0TdKoPDoGvjOPiHtAFpig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713828;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SnlfNkEOII6H9pSmbWiqEvrseQKpgPV3ZdsFGKhQdPY=;
	b=IumMqqS5Tht5XNZNkI0OkhI5MEJFU7j9krm7SFDrIELNMqSS8NkBYqtaryYS3kSeS7ik
	 aVj9vEhyWRvMpvIO67kF2ZCeRqo1m2AnSvaqIvWAKk4a4rPaSw8Y0hOZIB74VS69XBMQf
	 EnXzV2yPsJE9mMQbjdxUJY7uhtRVxzsAD3W0x4pFimlG4QPoV6SAzETdVtTQ2rAxeYDqf
	 2aFzivDW+KLGLNbqAwzABhBBJyeZnHlF7ZmN6by8ZkMMrxSaT4iuV9E7R+Q9xN10Yyyw3
	 lWoecqG1Ec1hTO02MBnNOXWJwt/VkQUjxDBgONEkT6uaaB/w3wl3hf2FGkQu5/UgiUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g7T4TvwA;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BC4606A333
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72BC4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g7T4TvwA
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4ac95761c85so27865435e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713826; x=1794318626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SnlfNkEOII6H9pSmbWiqEvrseQKpgPV3ZdsFGKhQdPY=;
        b=g7T4TvwAC49D+w30xJeLJV5vx2odqOcJWl/0nOh1Udsv+uRqM9lpZ4Pq0RhKfTuOAT
         QmXraayJRRniww00LGglt/hQLnBnXNgINf5ns59HoclNvhRPIXF/Z8HHXVUkE5m6a6yJ
         /RC3Qll/0IZqO7IdvMWSAgqzBpMcEIuVIS/jmAGPhhO6Swc6JDFfQ4NZPDLuMyME89eo
         XKfvRvp4OsumTUVAfkDOSumu1zRcHIvhx3jCSFain3CKT0Ovz09DfGYvcdFsVwXaJeii
         X4lFLcNOBDADAXBe7M6AS3lvpa8ZQfixlaY+SHyMWmvro53Xqm030FJZeKX6vCB3b0dI
         R6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713826; x=1794318626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SnlfNkEOII6H9pSmbWiqEvrseQKpgPV3ZdsFGKhQdPY=;
        b=N2m1tnmaeUxdnX4f1p3NeLsuYhuzVMxSDgyiOLCIs6dU1pV/esGza9AvfCJE1BwHsy
         5+qwOpvN+1O0NShlefORvn6zMKI13dNgGR+HbG0h9URAKaiI/xLSOQLupoa6NmqPxYBh
         uizofK6z2ADrcp/wXo3gCfrB/9A5f0bNsraUpwIp7IVj2/ZXyVR8Zp8gey0Qk0YAkUoo
         o1qtb61BXO5UltQV4yKUCeF0XWPxqXvTrfpr6UlIJnMVDcHS2bnleiWh9x+KF9+yPswZ
         spPhiHbzg5ImOPshwF2rY/HvmEKnbJTjtCDLJgcLCbJoRfKD+dLargYHTA19ETMY7JCN
         ft5w==
X-Gm-Message-State: APuU4Z9b4+kItcmdJWYnYIDuPlXDwQ19pDwovp8ZGsru2lmX3Wbo6CP/
	yXJ8K3Mt8FwTedPAgV+ltKdlAEcc7/AKa/UlXbzTqa4grUle4xlVbvwKElfEy197w8g=
X-Gm-Gg: AYBFou03+8+ouXAtf4GXt3W2Lso8JRozAmbaGCLB/SMAxTrNN9luMv2FAtiDuV7p+n5
	iYHK/uxBknxz+bIoTIW6vMvDh3VDlFkwuIS195PMcruqUAwObgpo0ULtX+PsdzJZfmTQ2+Fp7J7
	+e/XopkAHB58BLrjBFBymmxy3AlrZhSzM6Z+YkGpUjFMZpQr1Bj/juYSp9CAkmzx7EhiESMWzse
	v2xyjoeYENAa/EPXd3q233lSjyIYCjx6vWtGFVh1MIGk8CJsUXmS6/lm05MRLQEnhfsqstgJpLe
	2Vtcs+OfRWk2xMo5+4AEG8EjHPMb399t6ChKlP0lEKq9Qr8x0sY6EVGUgLGvVRoasMnTTDqAo3o
	+ozaLns3F4zPFk3hCDH/WQiMbsvkFUQ+7CWK6Tg+DJhSuMCP2Jpz4EtWk8s/IQ5xTeov4utWALy
	neq0dtlcN6Gbf0D4JmY+ZLZ+j6/lR3kkfl/Zhx6D65YKdtWYoL5TJlUdZX1oaJIl4Q9sotVpW+1
	AnNlYcCw4qsFR8NIXWPi9VRF64qsoorhzbx8OOb8c4WH7egHW83eColBgbMJeoDFXG+1FNUInf9
	pVIbarUjXXTvjMSYxHSSxmi83hIPWm0at7LTN/f9JN8cvT99iYVxoLCkRj67
X-Received: by 2002:a05:600c:3b29:b0:4a2:167a:c939 with SMTP id 5b1f17b1804b1-4ac17d19aeamr274472445e9.21.1793713825650;
        Tue, 03 Nov 2026 05:50:25 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:25 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>
Subject: [PATCH v14 06/12] ext4: refactor dx_root to support variable dirent sizes
Date: Tue,  3 Nov 2026 13:49:13 +0000
Message-ID: <20261103134921.610047-7-ablagodarenko@thelustrecollective.com>
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

Split monolithic definition of dx_root struct to separate dx_root_info
from fake struct ext4_dir_entry2 for improved code readability.
This allows "." and ".." dirents to have different sizes if necessary,
since we can't assume the rec_len 12 if dx_root dirents have dirdata.
Adds dx_get_dx_info() accessor instead of complex typecast at callers.

Also add the ext4_dir_entry_len() helper, which dx_get_dx_info() uses
to step over the ".." entry now that it may carry dirdata.

dx_get_dx_info() finds ".." through the rec_len of ".", as the other
users of the root block do, and checks that the root has room for
dx_root_info, two dx_entry slots and the dx_tail.  make_indexed_dir()
calls it before it changes the directory, so a failure leaves the
directory as it was.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/ext4.h  |  31 +++++++
 fs/ext4/namei.c | 224 ++++++++++++++++++++++++++++++------------------
 2 files changed, 173 insertions(+), 82 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d224132fc80b..cebbfac05fa5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4240,6 +4240,37 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
 	return dlen;
 }
 
+/*
+ * ext4_dir_entry_len() - Compute the required rec_len for a directory entry.
+ * @de:        directory entry (used to read name_len and any dirdata length)
+ * @blocksize: size of the buffer @de lives in (the real directory block
+ *             size, or the smaller inline-data buffer size for inline
+ *             directories) -- used only to decode @de->rec_len's "0/65535
+ *             means rest of buffer" sentinel correctly.
+ * @dir:       directory inode (may be NULL for '.' and '..' entries, which
+ *             never carry the casefold+fscrypt hash regardless of the
+ *             directory's feature flags)
+ *
+ * Returns the minimum record length needed to hold @de, rounded up to the
+ * directory alignment and including room for the casefold+fscrypt hash if
+ * the directory requires it.  An entry that carries the hash as a CFHASH
+ * record has it counted in its dirdata length.  Any other entry in such a
+ * directory may hold the hash at the fixed offset after the name, which is
+ * where readers look when there is no valid CFHASH record, so the result
+ * always covers that too.
+ */
+static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
+					      unsigned int blocksize,
+					      const struct inode *dir)
+{
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
+
+	return max(ext4_dir_rec_len(de->name_len + dirdata, NULL),
+		   ext4_dir_rec_len(de->name_len, dir));
+}
+
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 extern const struct iomap_ops ext4_iomap_buffered_write_ops;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6e934e2732fe..c221bcd562cc 100644
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
@@ -535,6 +526,46 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
 		ext4_rec_len_from_disk(p->rec_len, blocksize));
 }
 
+/*
+ * dx_get_dx_info() - locate the dx_root_info in an htree root block
+ * @dir:    directory inode
+ * @de_buf: start of the root block (the '.' entry)
+ *
+ * '..' is found through the rec_len of '.', as every other user of the
+ * root block does.  The rec_len of '..' covers the rest of the block, so
+ * dx_root_info starts at the real length of '..'.  '.' and '..' never carry
+ * the casefold+fscrypt hash, so their length is computed with a NULL @dir.
+ * The root must have room for dx_root_info, two dx_entry slots (the first
+ * split needs them) and, with metadata_csum, the dx_tail.
+ */
+static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
+{
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	struct ext4_dir_entry_2 *de = de_buf;
+	unsigned int off, rlen, need;
+
+	rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	if (rlen < EXT4_BASE_DIR_LEN || rlen + EXT4_BASE_DIR_LEN > blocksize ||
+	    ext4_dir_entry_len(de, blocksize, NULL) > rlen)
+		return ERR_PTR(-EFSCORRUPTED);
+	off = rlen;
+
+	de = (struct ext4_dir_entry_2 *)((char *)de_buf + off);
+	rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	if (rlen < EXT4_BASE_DIR_LEN || off + rlen > blocksize ||
+	    ext4_dir_entry_len(de, blocksize, NULL) > rlen)
+		return ERR_PTR(-EFSCORRUPTED);
+	off += ext4_dir_entry_len(de, blocksize, NULL);
+
+	need = sizeof(struct dx_root_info) + 2 * sizeof(struct dx_entry);
+	if (ext4_has_feature_metadata_csum(dir->i_sb))
+		need += sizeof(struct dx_tail);
+	if (off + need > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
+
+	return (struct dx_root_info *)((char *)de_buf + off);
+}
+
 /*
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
@@ -807,7 +838,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 {
 	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *info;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
@@ -819,23 +850,31 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
@@ -843,7 +882,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 	if (fname)
 		hinfo = &fname->hinfo;
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -859,13 +898,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
@@ -878,14 +917,12 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
 
@@ -962,7 +999,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
-static void dx_release(struct dx_frame *frames)
+static void dx_release(struct inode *dir, struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
@@ -971,7 +1008,18 @@ static void dx_release(struct dx_frame *frames)
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
@@ -1277,12 +1325,12 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
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
 
@@ -1782,7 +1830,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return bh;
 }
 
@@ -2185,44 +2233,38 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
@@ -2240,16 +2282,15 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
@@ -2266,17 +2307,28 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		return retval;
 	}
 
-	root = (struct dx_root *) bh->b_data;
-	if (!ext4_check_dx_root(dir, root)) {
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
+	if (ext4_rec_len_from_disk(dot_de->rec_len, blocksize) < EXT4_BASE_DIR_LEN ||
+	    ext4_rec_len_from_disk(dot_de->rec_len, blocksize) >= blocksize - EXT4_BASE_DIR_LEN) {
 		brelse(bh);
 		return -EFSCORRUPTED;
 	}
+	dotdot_de = ext4_next_entry(dot_de, blocksize);
+	if (!ext4_check_dx_root(dir, dot_de, dotdot_de, &de)) {
+		brelse(bh);
+		return -EFSCORRUPTED;
+	}
+
+	/* Find room for the hashing info before the directory is changed */
+	dx_info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(dx_info)) {
+		EXT4_ERROR_INODE(dir, "no room for htree root info");
+		brelse(bh);
+		return PTR_ERR(dx_info);
+	}
 
 	/* The 0th block becomes the root, move the dirents out */
-	fde = &root->dotdot;
-	de = (struct ext4_dir_entry_2 *)((char *)fde +
-		ext4_rec_len_from_disk(fde->rec_len, blocksize));
-	len = ((char *) root) + (blocksize - csum_size) - (char *) de;
+	len = ((char *)dot_de) + (blocksize - csum_size) - (char *)de;
 
 	/* Allocate new block for the 0th block's dirents */
 	bh2 = ext4_append(handle, dir, &block);
@@ -2307,24 +2359,26 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
@@ -2367,7 +2421,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	 */
 	if (retval)
 		ext4_mark_inode_dirty(handle, dir);
-	dx_release(frames);
+	dx_release(dir, frames);
 	brelse(bh2);
 	return retval;
 }
@@ -2634,7 +2688,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			if (restart || err)
 				goto journal_error;
 		} else {
-			struct dx_root *dxroot;
+			struct dx_root_info *info;
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
@@ -2642,11 +2696,17 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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
@@ -2670,7 +2730,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 	ext4_std_error(dir->i_sb, err); /* this is a no-op if err == 0 */
 cleanup:
 	brelse(bh);
-	dx_release(frames);
+	dx_release(dir, frames);
 	/* @restart is true means htree-path has been changed, we need to
 	 * repeat dx_probe() to find out valid htree-path
 	 */
-- 
2.52.0

