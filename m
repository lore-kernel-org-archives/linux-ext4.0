Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7ED44330F
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512332; cv=none; b=gcg+j+U/ag1dm2eGpQ0SZ758XFXF7IfwqDXV9qE1dg+iV/CteUYKce/r3r6qcavHWWx/fQdIjOtMDlNYB93MkxdnhbzWWcq6xPm+etdye2BzDOGCsUPeRqw6jK09YfQ+or886BlS9OL5qCSjxWl2ZX6mm5P+RcFPkUzUl6KdfPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512332; c=relaxed/simple;
	bh=Z8TMlkUPdQ4Za4MfVF9gFNyLjEpLDL7M3EcCGdjz3bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX322UOwSoVOHPdBesmdB/N+L+nRgJAXcP4ap2yKMi2404pP50xq5ZxUam72LPrC5gjbZzm0phgh0DperF2OWM5qY3BbtHB+FfFoWf0LqYijo1QO/Se1ShI5dIcWIvxniuH7dwftSpDdvDUxNPbPH9TuH0laRXnjKcS3K+TyA3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/19QAN8; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/19QAN8"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47f96c5b722so713853f8f.0
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512329; x=1786117129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=T/19QAN8TRxhHAMKQZLVOWQdYU1UgbIQbPW4XKM8nTqAheNFk+jcC1v9XHOc9/WMdc
         Sc2G8pnVlaVoLYFpqEEpQ5eno9Ri62lbYcRxWbek+wwnjtLpb6ofcazm0+69iIvzOVfB
         x0mK4Awt2frDviNiVeIBXTgvkwlmgYGr8BcXR8kHPoPb3w0MpCDmES/bCw6eNWMrQgCs
         RRAYk30IiHvVEl66E1NfNQuqojP0L22GW+1GVKJgt0MmvWdP4fQ1Ykkn0vLgnpT+5nPT
         TP+CdQ6+XJHREVejWKI2Y/w/ZHzQ0NhFOpynLFsiI++E25jR5MnhSt652DoPH1aA6AC7
         P6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512329; x=1786117129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=nb4WgyzFIEcoP4uGLPkF6Tb2aAKc2eT3dwDzW2YBQOnqaDMAwBtS3pFLwbdXe6T/tp
         6X19UXR7NQwtneBuJhytwClY52O+dqSzEnAHK/2Y6cGO4HjWg/k/BIrOz7w7ckMNwCAd
         UBCUdaKRZAB0THGRB2TvGq3cIQHbnHnaqDOAkI7Wewn74SCMxKmXEt8EPbgrWWTAmx+d
         bXGkhQC+smvIB/RhyIeDyKAVv4yXzCzpVTNw4bZJEOuhepu6xn8CfE2nY8fWtOATxdpt
         6dLppLY96tf2HvRcaR6pT8JwbQ4eX2eqk1PNpOiG4tBZGd9eLUtsPZrflTMeF3+oCdAV
         tulQ==
X-Gm-Message-State: AOJu0YyCCYpHjNynuFgAS23MrzxmRuiMzbyr5MfLCpZsPyPM1fc5xBed
	az3sb+Wz5ACQXXJff2LINVTPpGXKOzBNzNe40MuFOWKMe13jJXNgQ50ZS876IYX7
X-Gm-Gg: AR+sD13B9ODqd38CVivL8Lt8cWtEZ8G9LHVHVTMZZVls06ETK6aoibzc4WIO2r4EkAC
	H1EvMJEcVALioI3M1GL1Sv9v0v1T8neOgJeba474zmRri2At790x1VBAH0Rn8SZdVpHt0hqTUKu
	N4AQU7H8cD4y/f5nr19UVS7jRjQurdw+kSj1l55qG/pD6N+m6mDdlMlZ0dbgO1yqwJCii0rApw/
	xnfTaFbx04ur0f3TKEi6CaN8UQn3e6P+a57Nv9VIr1+cc0B6p7t+Se2lo09UCD899NWP/g2L0c5
	QhH2n3K1UuvQfNIS0LkmgnnJlWxkFbN1XZN0EOmvxhfpJ76zdrSL06D8J0MXsYsJPP7dwG+As36
	CColBlUnEA8UfO7+Qpn5TLHdJi9h7yqLuzomL+TEGfPWKRQtEjhM4Vbnrw2I2Swjmlqu6uRbBwD
	7wVgrGZWWPz/tN8ViwZwNT7F4Qi6vR2RvjrPkTvrnHC2HfS1akX0CXmaiuDCKPuldedNfjk61YL
	FbzBqZvmedA/cY3H2Me
X-Received: by 2002:a05:6000:c46:b0:47f:7786:b00d with SMTP id ffacd0b85a97d-47fd72e19cfmr146415f8f.24.1785512328963;
        Fri, 31 Jul 2026 08:38:48 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:47 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v10 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Fri, 31 Jul 2026 11:37:36 -0400
Message-ID: <20260731153753.28309-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
References: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Artem Blagodarenko <artem.blagodarenko@gmail.com>

Replace remaining uses of struct ext4_dir_entry in namei.c
with struct ext4_dir_entry_2.

The code paths affected by this change already depend on the
filetype feature, so using struct ext4_dir_entry_2 is
appropriate and avoids mixing the two directory entry types
unnecessarily.

This change does not affect support for 16-bit rec_len.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h  |  6 ++----
 fs/ext4/namei.c | 38 +++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..aa8a37566a38 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2472,10 +2472,8 @@ static inline int ext4_emergency_state(struct super_block *sb)
  * Structure of a directory entry
  */
 #define EXT4_NAME_LEN 255
-/*
- * Base length of the ext4 directory entry excluding the name length
- */
-#define EXT4_BASE_DIR_LEN (sizeof(struct ext4_dir_entry_2) - EXT4_NAME_LEN)
+/* offsetof avoids sizeof()+padding giving 9 instead of the correct on-disk 8 */
+#define EXT4_BASE_DIR_LEN offsetof(struct ext4_dir_entry_2, name)
 
 struct ext4_dir_entry {
 	__le32	inode;			/* Inode number */
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a283e285937a..c2f330c75c81 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -102,7 +102,7 @@ static struct buffer_head *ext4_append(handle_t *handle,
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,
-			       struct ext4_dir_entry *dirent);
+			       struct ext4_dir_entry_2 *dirent);
 
 /*
  * Hints to ext4_read_dirblock regarding whether we expect a directory
@@ -128,7 +128,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 						unsigned int line)
 {
 	struct buffer_head *bh;
-	struct ext4_dir_entry *dirent;
+	struct ext4_dir_entry_2 *dirent;
 	int is_dx_block = 0;
 
 	if (block >= inode->i_size >> inode->i_blkbits) {
@@ -160,7 +160,7 @@ static struct buffer_head *__ext4_read_dirblock(struct inode *inode,
 	}
 	if (!bh)
 		return NULL;
-	dirent = (struct ext4_dir_entry *) bh->b_data;
+	dirent = (struct ext4_dir_entry_2 *) bh->b_data;
 	/* Determine whether or not we have an index block */
 	if (is_dx(inode)) {
 		if (block == 0)
@@ -317,13 +317,13 @@ static struct ext4_dir_entry_tail *get_dirent_tail(struct inode *inode,
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 
 #ifdef PARANOID
-	struct ext4_dir_entry *d, *top;
+	struct ext4_dir_entry_2 *d, *top;
 
-	d = (struct ext4_dir_entry *)bh->b_data;
-	top = (struct ext4_dir_entry *)(bh->b_data +
+	d = (struct ext4_dir_entry_2 *)bh->b_data;
+	top = (struct ext4_dir_entry_2 *)(bh->b_data +
 		(blocksize - sizeof(struct ext4_dir_entry_tail)));
 	while (d < top && ext4_rec_len_from_disk(d->rec_len, blocksize))
-		d = (struct ext4_dir_entry *)(((void *)d) +
+		d = (struct ext4_dir_entry_2 *)(((void *)d) +
 		    ext4_rec_len_from_disk(d->rec_len, blocksize));
 
 	if (d != top)
@@ -410,22 +410,22 @@ int ext4_handle_dirty_dirblock(handle_t *handle,
 }
 
 static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
-					       struct ext4_dir_entry *dirent,
+					       struct ext4_dir_entry_2 *dirent,
 					       int *offset)
 {
-	struct ext4_dir_entry *dp;
+	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
 	int count_offset;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
 	if (rlen == blocksize)
-		count_offset = 8;
+		count_offset = sizeof(struct dx_node);
 	else if (rlen == 12) {
-		dp = (struct ext4_dir_entry *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(dp->rec_len, blocksize) != blocksize - 12)
+		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
+		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
 			return NULL;
-		root = (struct dx_root_info *)(((void *)dp + 12));
+		root = (struct dx_root_info *)(((void *)de + 12));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
@@ -438,7 +438,7 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 	return (struct dx_countlimit *)(((void *)dirent) + count_offset);
 }
 
-static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
+static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry_2 *dirent,
 			   int count_offset, int count, struct dx_tail *t)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
@@ -456,7 +456,7 @@ static __le32 ext4_dx_csum(struct inode *inode, struct ext4_dir_entry *dirent,
 }
 
 static int ext4_dx_csum_verify(struct inode *inode,
-			       struct ext4_dir_entry *dirent)
+			       struct ext4_dir_entry_2 *dirent)
 {
 	struct dx_countlimit *c;
 	struct dx_tail *t;
@@ -489,7 +489,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	return 1;
 }
 
-static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
+static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *dirent)
 {
 	struct dx_countlimit *c;
 	struct dx_tail *t;
@@ -523,7 +523,7 @@ static inline int ext4_handle_dirty_dx_node(handle_t *handle,
 					    struct inode *inode,
 					    struct buffer_head *bh)
 {
-	ext4_dx_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
+	ext4_dx_csum_set(inode, (struct ext4_dir_entry_2 *)bh->b_data);
 	return ext4_handle_dirty_metadata(handle, inode, bh);
 }
 
@@ -1496,7 +1496,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
-			       struct ext4_dir_entry *de)
+			       struct ext4_dir_entry_2 *de)
 {
 	struct super_block *sb = dir->i_sb;
 
@@ -1627,7 +1627,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		}
 		if (!buffer_verified(bh) &&
 		    !is_dx_internal_node(dir, block,
-					 (struct ext4_dir_entry *)bh->b_data) &&
+					 (struct ext4_dir_entry_2 *)bh->b_data) &&
 		    !ext4_dirblock_csum_verify(dir, bh)) {
 			EXT4_ERROR_INODE_ERR(dir, EFSBADCRC,
 					     "checksumming directory "
-- 
2.43.7

