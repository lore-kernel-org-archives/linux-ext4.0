Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161AA2EF67A
	for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785354873; cv=none; b=kLPkBa/qmA1r3tvU4GeVycYs00sO9M1ZHcgpdzQISityu9jSNIEuoj/IOor8TqAhA0il6JcOIQqsWUCvbEpFtrYmqkfYOhmk0zsQ4pF1arg3lQ6FkB6PRov2xyPBemoSYyXCwGiCpf+b505JL56E3jRkiEu9vc0yPzCLjxujDIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785354873; c=relaxed/simple;
	bh=Z8TMlkUPdQ4Za4MfVF9gFNyLjEpLDL7M3EcCGdjz3bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoL5WdlNOwZ5o3mpse/7hulBT9vJCdPlN9mdzrCHvlazxjOhsE5dbW6lRjxDqBCUmjv50BHVUhRK6e9DJBtJTrBz+n2ilIlSFxtqlW34xbOeFCa3l2HpXzZ1v+y0TJG8HNdktFqdlz0W0+XrP4ffARGC256ploIYgCtI+v2iNgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/8Bcbgr; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/8Bcbgr"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-496b7622a83so8951845e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 29 Jul 2026 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785354870; x=1785959670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=C/8BcbgrLgx9wrTGwaQLGNSEuU1CaXEojd6vEdZ07hLlWCLo6A1Uh/xZwOuJxhYWMY
         mSM3cxKapFDfGyzAsY0Yn2Dw4QEvEZ4ulINeUzM2X6pWxxpljRz6+utT4d0YHKUzliIx
         tl01925mYAwZ/Z42Ek8ZVS1AArji9IoPD1OMDs7/CpAn44nLBZPf3pPMZVHGmFo2C4K5
         CJC6clEjZopH7gKUZb7ImcncElOTpTbDBcvA2k/VNP/bUIcTIPazDC0sMzATP7bxD+4y
         r5mfWiFLyvq/8BxEoJJcVr/KqhGNL+zjhbexh3GRaJEXajrYqiuytTlICxbcQh1i/21B
         86xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785354870; x=1785959670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=gVyUi7fbMMRtcfwE3YIJ2Z1PDbqfrFkWx2ex59GB1MsZodMwvnUhg2jKnMxDIYHhmU
         eWaRpWIltJuy5I1UoPPs/ibFQCw87XQRTZ8Wlh3XFLxe7moq4OOjQND0ZkYtH6wyZl6Z
         fbNi2hTzAx7yQu8Hd59i3zKYlZc3dYHPFXNJR/3aP5I+zDtOgRCS9xPvlxhtZzen37mz
         uIz7KCDJGAAx56YeHlJPkpQ/UZPsDWkDL/y5XYXtOwhsd2Ou4Uep5t/F0gQAlj5Ww3s5
         LFBAc5ObZ86i/+RboACJ3fERAkBMfIXnPwaNBarBGzm8TJw3iZwb4RC4gCjGlOE7hZTe
         mszA==
X-Gm-Message-State: AOJu0YwcGRMFKjcJiMCAj+kee7pi7ZBmxeE71iyDz/PelmsdFK9GyFPA
	3zlOkSSbDVcowSYelbXzEiZmf8b0kP1AUnLzy4nWIKNPo5l25UbRRHYnX0OPxkGs
X-Gm-Gg: AR+sD12+jIL+qd4Cyxa+rg2DwlDB/Kl7u9OsS6oNPv6sH3bCow8dNIG5eRwkLwU/51D
	yN7AJeWyoCkNaoJgUUcq21hju388I/3XuHP0vDrlUNabx1dA5Pmm5CyWez2uQoBKr6t+qvbb59Z
	c15yJ+c7W8N4Cuqwmhaf5dpbR8pyUtUJVml4bSp6ulC6c2Vg+hPHD4m5YBr7wyJVOqvii/mEu2+
	dDfHjUYN21BhenvJ647f9NNCIiBY9f4K7EBwwzJtfx+Pm2ZuaX0dYebdUII0KJpC9KkEckOA2OH
	rwF7HHH1E7ZlrdzWj3hj9zOQZ+Rdy+6T8tDYb7r4io5AcFnhFCPyOo6yzVRbu3GCuUfxzASNZim
	vv9mRiZ9xh8Ft0We/VGcdH5Uf8/ROVAr7qoWkhvkW3tol+ISyVlke0JH1uZPQGWz5csNo4exH5f
	F61m9jwTIPcTYUPZsrLxT9qor5xT2xxy14tk2cJsbYJO1slTq73Q3Sq23e0ihfgeeWwKbwU7orT
	u+8WIJphAiAOKT7/w58OxQD+X/y5lZ2
X-Received: by 2002:a05:600c:a45:b0:497:ffd4:6304 with SMTP id 5b1f17b1804b1-497ffd46321mr6700585e9.37.1785354870120;
        Wed, 29 Jul 2026 12:54:30 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4976bd6d226sm82076865e9.10.2026.07.29.12.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:54:29 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v8 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Wed, 29 Jul 2026 15:53:20 -0400
Message-ID: <20260729195333.20626-3-ablagodarenko@thelustrecollective.com>
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

