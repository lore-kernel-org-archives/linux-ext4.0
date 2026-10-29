Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276834;
	b=fl9tdsENYewkwj2d7qrLNkJXcMp+JuzDecg6nhgRrd1CFQm/zmDTPVZHP+cBdPXRzrk2
	 OkIlfvMfpZaqdEW8gXO4mN7VsL8+6liTFsx7r5MOM0651Sb8NgyHsPRpoN5m5iluxFTzX
	 23o2jCHk/tnT65UbR8K5fTmuEpuNN2cxNzCSJs+ejbe6Lr2MXYQ1/ctEcuo/+ewfkydF7
	 4K7NSMlReJGIYcGObzaMRsbQX6AKT/icFosdBi3TBcJVVxcXOr1wcAFel2aoJtOj7JLQk
	 HkCrv2MOKCT57NuSkcr4mSHAPQKXhVCrkxg8OeYuX3wctKO2g5WwhXnKxPwxBeShDqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276834;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fkPwRSu0lv1F5v9QB9Uh6BLmrt+nL/nlkKNZRngv44k=;
	b=Ic40A05qjudhB7MDuKoX9NgqcIwGuoG57P0wHNbBwSKNHYnyLLnQklSkUPTdw3tz2VN5
	 63fQ0fFeqSsnxWKnk/fS/srVYo7cGHbENhWXplL/fAXVdpBIujDu9CpcIKvb7EiaCigD7
	 61V4lWoczjyBU20Wtj/ysrTqMoFWbm52ydGICP9Ldxuul1BTq2BxGCyYrfBkPEO+ioN9p
	 Ly4SsV9+Rf9MfJjSJSXoKCdGSyuxfeAhr2Goe9d5cCp/PfUE0pPuPaG3crSzR+9pzqZ4K
	 lT9PwbbpK9DAQK93M64vWcH1IRySW2K29u6wQgR5bksU56/ecs5UM/OEAdTO3D+UBig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UMUH90r1;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC9606A336
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91FC9606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UMUH90r1
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e4831c028so1706689f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276832; x=1793881632; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fkPwRSu0lv1F5v9QB9Uh6BLmrt+nL/nlkKNZRngv44k=;
        b=UMUH90r10Naf1HIPV3GcG/Z68ACnaMiuTG6WN537iK+rCYoScjDiIYg68z0HqdZhao
         4EL4r3B6UvY4CwcwhSpGeJx7Aq1BpRzGUR4rCd1qefjmqc3DuW4CB0XqGWdCK2K3BTbN
         6/YqNenox4QNxhrxwu789T6RYGAVZ+etyFhw2llk6V17ftmD2sLs7qJIB7walvClyotO
         GoEfzX2Dk49L5FVRO7U3I4BKKFX12khk+/OZX1X83CWMzdO19VmAr6P+XpHmkFyQo82X
         JKxHUzEDrVP/UQeM0f/8KdU2oKSoaPG1U2pTpLkFVQA44BswM3zoF1dTGQxz6P/lOhxN
         ZywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276832; x=1793881632;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fkPwRSu0lv1F5v9QB9Uh6BLmrt+nL/nlkKNZRngv44k=;
        b=DbHbWPnHYLpYgJml2E44MllwFbMCIgz/vq0qal0G6g65PRjjEk6aFQWCe7xbtM48QD
         o9ywuWYr4CXhBzV03IfMnsJvDjtu136phHFGzjDipptyT/wpGbJfYDTMvcq/wo2O8al/
         YqUrEaIKO05EzaHY6zKnFsbHdWJENeSXKBufCFrNru+u55jaGWpdi9U+TEI75bD9RJz5
         fc0BPG4wP7779NRU1gDfC7DW8qlJdCPa2xPMRXgN/rQ1FDS5qBOn8wZUozQk4wVvFpJF
         OLwV7hJi4fqfGH6LafzGG3aPAnsmH7X23VzOc0nyErHEkA90OKSzlXOp0+HYZkRi0B3s
         obOw==
X-Gm-Message-State: AFq9FYJdHyTJhUYe5ElvrMz+B1P+LpquQ7E+2KLONEYox5nt/wMshC8x
	GNMHcsvf3PdxpIAbA3wfl6xL45kGsRkMbEqiV9ZKCx7V/3QFY/MSGLSD4uS1dHtf
X-Gm-Gg: AYBFou3jFRT6oJFc28lFkXISVScJuVUk7ElSfMpAWOZJhgNkqdeiJnxoiKgEFYmb7ig
	edzlbSg0jt0snPB1Ra5BkKSg+ba+T33AF/lCfbIjB2f5T/wEFrX8rOO2LczRcueCOx84mwqtash
	79o5U0c9IT/IWLK5a8DmxYZqi5Z4c//gQqFKLWp8FzBeQWSHDcH/u439wHe8YB1vXw4gire/9dE
	1fLppn+oT2+ufSx8GpvylzLEg9IXMk6LXbvlAQbKHjQENbdt57zrSA7bMFFlJlHNZI1Krwe9adF
	waK96ad2LzKhj5iIiSdwDNQ0mUYu+8RNVXfMXWnJv5oTlGXUSNFUibDo9I6iBP4R6zvkJXRmwLI
	fbb4r8azs+gUQDWMpThGq4+UEBvJoyUdtqQ0z6hKbupMggDDy0/B+izv8ypqqD1vBU7sKTSQ083
	a5QN6+Mre6GZqo2/SeW8p2xEOqRIKbUHuBBt5gl+hKbVlzzboTjO6y/TFcQkVLRi6Ywf091wxgA
	iQO2bIOpLZZTS1zjCjKR0vjszxw4J0cbH+cZE2R370fuvQRHiLMTKGqoWPxjGPvBWT3tGWmckSX
	jYpGPQzGPKIsYYLk/5slQuUAzXtmcD4+k2K6uo/n2oenjpdOovWz09kQ7dm9RA==
X-Received: by 2002:a5d:4607:0:b0:488:57ad:d5c8 with SMTP id ffacd0b85a97d-48e5d31a0cbmr9531706f8f.3.1793276831783;
        Thu, 29 Oct 2026 05:27:11 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:11 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 05/11] ext4: refactor dx_root to support variable dirent sizes
Date: Thu, 29 Oct 2026 12:24:04 +0000
Message-ID: <20261029122413.230409-6-ablagodarenko@thelustrecollective.com>
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

Split monolithic definition of dx_root struct to separate dx_root_info
from fake struct ext4_dir_entry2 for improved code readability.
This allows "." and ".." dirents to have different sizes if necessary,
since we can't assume the rec_len 12 if dx_root dirents have dirdata.
Adds dx_get_dx_info() accessor instead of complex typecast at callers.
Does not change any functionality.

Also add the ext4_dir_entry_len() helper, which dx_get_dx_info() uses
to step over the "." and ".." entries now that they may carry dirdata.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  |  26 ++++++
 fs/ext4/namei.c | 211 +++++++++++++++++++++++++++++-------------------
 2 files changed, 154 insertions(+), 83 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c79295415c07..edb95cbc4439 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -4234,6 +4234,32 @@ static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de,
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
+ * the directory requires it.
+ */
+static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
+					      unsigned int blocksize,
+					      const struct inode *dir)
+{
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	unsigned int dirdata = ext4_dirent_get_data_len(de, rec_len);
+
+	return ext4_dir_rec_len(de->name_len + dirdata, dir);
+}
+
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 extern const struct iomap_ops ext4_iomap_buffered_write_ops;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 533340c5dbc0..59cc01b91c41 100644
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
@@ -539,6 +530,31 @@ ext4_next_entry(struct ext4_dir_entry_2 *p, unsigned long blocksize)
  * Future: use high four bits of block for coalesce-on-delete flags
  * Mask them off for now.
  */
+static struct dx_root_info *dx_get_dx_info(struct inode *dir, void *de_buf)
+{
+	unsigned int blocksize = dir->i_sb->s_blocksize;
+	void *base = de_buf;
+
+	/* '.' and '..' never carry the casefold+fscrypt hash, so pass NULL
+	 * for dir regardless of the directory's flags */
+	if (ext4_rec_len_from_disk(((struct ext4_dir_entry_2 *)de_buf)->rec_len,
+				   blocksize) < EXT4_BASE_DIR_LEN)
+		return ERR_PTR(-EFSCORRUPTED);
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
+
+	/* dx root info is after dotdot entry */
+	if (de_buf < base || (char *)de_buf - (char *)base +
+	    EXT4_BASE_DIR_LEN > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
+	de_buf += ext4_dir_entry_len(de_buf, blocksize, NULL);
+
+	if (de_buf < base || (char *)de_buf - (char *)base +
+			      sizeof(struct dx_root_info) +
+			      sizeof(struct dx_entry) > blocksize)
+		return ERR_PTR(-EFSCORRUPTED);
+
+	return (struct dx_root_info *)de_buf;
+}
 
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry)
 {
@@ -593,8 +609,10 @@ static inline unsigned dx_root_limit(struct inode *dir, unsigned infosize)
 
 static inline unsigned dx_node_limit(struct inode *dir)
 {
+	/* dx_node fake_dirent is always 8 bytes — it never carries a casefold
+	 * hash, so pass NULL to suppress the hash-size term. */
 	unsigned int entry_space = dir->i_sb->s_blocksize -
-			ext4_dir_rec_len(0, dir);
+			ext4_dir_rec_len(0, NULL);
 
 	if (ext4_has_feature_metadata_csum(dir->i_sb))
 		entry_space -= sizeof(struct dx_tail);
@@ -786,7 +804,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 {
 	unsigned count, indirect, level, i;
 	struct dx_entry *at, *entries, *p, *q, *m;
-	struct dx_root *root;
+	struct dx_root_info *info;
 	struct dx_frame *frame = frame_in;
 	struct dx_frame *ret_err = ERR_PTR(ERR_BAD_DX_DIR);
 	u32 hash;
@@ -798,23 +816,31 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
@@ -822,7 +848,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	}
 	if (fname)
 		hinfo = &fname->hinfo;
-	hinfo->hash_version = root->info.hash_version;
+	hinfo->hash_version = info->hash_version;
 	if (hinfo->hash_version <= DX_HASH_TEA)
 		hinfo->hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo->seed = EXT4_SB(dir->i_sb)->s_hash_seed;
@@ -838,13 +864,13 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
@@ -857,14 +883,12 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
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
 
@@ -941,7 +965,7 @@ dx_probe(struct ext4_filename *fname, struct inode *dir,
 	return ret_err;
 }
 
-static void dx_release(struct dx_frame *frames)
+static void dx_release(struct inode *dir, struct dx_frame *frames)
 {
 	struct dx_root_info *info;
 	int i;
@@ -950,7 +974,18 @@ static void dx_release(struct dx_frame *frames)
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
@@ -1256,12 +1291,12 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
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
 
@@ -1761,7 +1796,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 errout:
 	dxtrace(printk(KERN_DEBUG "%s not found\n", fname->usr_fname->name));
 success:
-	dx_release(frames);
+	dx_release(dir, frames);
 	return bh;
 }
 
@@ -2164,44 +2199,38 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
@@ -2219,16 +2248,15 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
@@ -2245,17 +2273,20 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 		return retval;
 	}
 
-	root = (struct dx_root *) bh->b_data;
-	if (!ext4_check_dx_root(dir, root)) {
+	dot_de = (struct ext4_dir_entry_2 *)bh->b_data;
+	if (ext4_rec_len_from_disk(dot_de->rec_len, blocksize) < EXT4_BASE_DIR_LEN ||
+	    ext4_rec_len_from_disk(dot_de->rec_len, blocksize) >= blocksize - EXT4_BASE_DIR_LEN) {
+		brelse(bh);
+		return -EFSCORRUPTED;
+	}
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
@@ -2286,24 +2317,32 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
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
+	dx_info = dx_get_dx_info(dir, dot_de);
+	if (IS_ERR(dx_info)) {
+		brelse(bh2);
+		brelse(bh);
+		return PTR_ERR(dx_info);
+	}
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
@@ -2346,7 +2385,7 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
 	 */
 	if (retval)
 		ext4_mark_inode_dirty(handle, dir);
-	dx_release(frames);
+	dx_release(dir, frames);
 	brelse(bh2);
 	return retval;
 }
@@ -2613,7 +2652,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			if (restart || err)
 				goto journal_error;
 		} else {
-			struct dx_root *dxroot;
+			struct dx_root_info *info;
 			memcpy((char *) entries2, (char *) entries,
 			       icount * sizeof(struct dx_entry));
 			dx_set_limit(entries2, dx_node_limit(dir));
@@ -2621,11 +2660,17 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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
@@ -2649,7 +2694,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
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

