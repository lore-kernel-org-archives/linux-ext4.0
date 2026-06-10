Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44973DDDB8
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105136; cv=none; b=sk0Xwu+mO9aDGpTPo1TVDAxn2vFdEwbekXPe9xhOsndfuKW6DZwOZgppRmy4M+udk3cFn2dI4iZ1Zkx4mKsn98Jns8MaiBOVJME0PW4Byu/zx9dLT0/Da+uoCFHwvUUmkSPDJRZTETtwHDj5FQG65WqFET0LMiSzL9U2whZy2zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105136; c=relaxed/simple;
	bh=//tuF8ajv9v1sDxaFizHJuZF3K+BJ2hAu1/8lrGhlso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSuP4jLBljdBkj5Vb+RzuZylc1EOumxW7k2+wIAaGZyPoz2Uqx5b2V/1yM+vkFHWg0kfz2HwYlrOtey0OfKnGAktMR4m+ZBVX0MPl0JWSuplaSzbM+nzrn7czb57Y+6zpUMVH4SLdJJE3nsZ6qjPWIQg7Oey7GP+ae4g9Mae1f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YiPwjXMY; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YiPwjXMY"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso50511985e9.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 08:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781105133; x=1781709933; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTCJFV5eTJQyXBT+Frp1TWPPfAMYrH1FS/ZKAxqqceg=;
        b=YiPwjXMYynfQc7V693pPCL0Q+soAXtuw7TkVnM4s/mbw7/2EnWtuHmwqDu1pbz6K9U
         4tC62NQeZXtnhFb8oSST29YdvKKy941q7oHhnevC3fhmg0irUIG95QDJHdEPsplX8g5R
         8LEfuU2I9TYbMWliq2GqVlbuKQ+S08vXmUWxa6iTkmgbAh4OQlZCo3V6sbRrbFZ0WzuP
         c1SL2yWtHdopc77Gl0wRYlEbFJfqrY7XRL9qckylmPnaRYcVHBrDQROuEu5HlhgkYIbE
         dyPIP1AauHAXCUtRHx2aV/CgC3EHI8d5icIcYkxN2kDKRNQGB5FYNrxGfN+IrRrTPeXe
         STYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781105133; x=1781709933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LTCJFV5eTJQyXBT+Frp1TWPPfAMYrH1FS/ZKAxqqceg=;
        b=RCJvpIOYabhnUXYv6M8IFBeyPqvdc2fJLhyRv02ShiVyrmAA4s/KYRuhMjFwfNOXA0
         dDWjFwFnHpVwiUeYUrLkzBBFBNrfASnR7cdYPpR+5cgDd6cRYA8P8DBL1onuzdmgljFA
         UQvVK8bvc3GkAUF+kDUy5Td/XQ2oRqLzZ3C0yVXDK7d7AB/B2APkMkOagpmp4HDgLuP4
         IzFzo71G0QVXxxtirTokVQEmF4R0iUG6HvNjpEvHgQlcHdBlOIDeI056Um79zPEDrMtc
         0r47FfG1R+tL8VBJaPGU7RcF62jM51kiFwD0XCZA7KYgrOl/s9AgOxSAflJp6DxIXfRy
         MfzA==
X-Gm-Message-State: AOJu0YxBY4e6vgASljexh4tmvuYkI1xMhfm5fFNsPPjiTohaRKpx3xi4
	rD1VBy80pNW6nvE2o0W9bcvUFPqADdo/d3bf5rxCAA1m7m+ui40/45SxZPt9K4qPt4Y=
X-Gm-Gg: Acq92OEivI8F2pmU0P6KQObXti2fzUScElj8SLW8OdmVliIqEhyCbzvvdB07PLUINJy
	8hGdc6htKcT095PlhvuokCAEa0NLi1Bs3WJKZjROtQri3Zongq+rdE10dntit8WB5b7fkFsffYK
	ipJwCxKGWLs9ikF0JgffKxO2wKMGGl8gfx8jvhVOCVGZ1Zwtt7D5blUwkx/O3ZYz5y8NeDV/Bg8
	mlonjWDWeff+I6qZAbmzlay0ywlhToONQ7SF2MKxopD9b02qVXQV8/21BoAHFXBpnb0Tn7eb8ax
	z/kZ/WYGtsdsMI2t7awEP691xa/a8kDcStx6WqFsE5PXzoUYHP4KeIr3B6rCcWaBqBdufjuh2iN
	kj9xM3KGbEVutoa53qYJPW2o1Pio3ddvUB+7anT7Bl+6jfRIi3ZwkuKcUfDtRlfyv5nHVV/lG8O
	+N+MLBB//ayu8xzvTpudvJvjqHEsArlev9NOJfYSMEKD1suA+ssJMfGc8daE3fSm4=
X-Received: by 2002:a05:600c:1f90:b0:490:c032:ae92 with SMTP id 5b1f17b1804b1-490c2610b21mr411177145e9.33.1781105132972;
        Wed, 10 Jun 2026 08:25:32 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3d6c65sm559103835e9.12.2026.06.10.08.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 08:25:32 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Wed, 10 Jun 2026 11:24:04 -0400
Message-ID: <20260610152417.13576-2-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a47fbd8dd30..5805001ff1d9 100644
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
@@ -485,7 +485,7 @@ static int ext4_dx_csum_verify(struct inode *inode,
 	return 1;
 }
 
-static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry *dirent)
+static void ext4_dx_csum_set(struct inode *inode, struct ext4_dir_entry_2 *dirent)
 {
 	struct dx_countlimit *c;
 	struct dx_tail *t;
@@ -515,7 +515,7 @@ static inline int ext4_handle_dirty_dx_node(handle_t *handle,
 					    struct inode *inode,
 					    struct buffer_head *bh)
 {
-	ext4_dx_csum_set(inode, (struct ext4_dir_entry *)bh->b_data);
+	ext4_dx_csum_set(inode, (struct ext4_dir_entry_2 *)bh->b_data);
 	return ext4_handle_dirty_metadata(handle, inode, bh);
 }
 
@@ -1488,7 +1488,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
-			       struct ext4_dir_entry *de)
+			       struct ext4_dir_entry_2 *de)
 {
 	struct super_block *sb = dir->i_sb;
 
@@ -1619,7 +1619,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
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

