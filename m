Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3FF3438B8
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781896317; cv=none; b=uAHDBJq+1TVPs1EryvNAbjsCNUqJjiBeIgzll3WZtVUL6ESvK4n1PJGu+ng7KBi+vcF+Fp+a2KaQnU5/mXU9JQmrkKRWNwNs4BMAYswkTTGyWvikP/9N9Ho0GalQ8jAyy+rIxC9NYUhLcKd9XwIiTOB1PyOGiLNMxkq9cPFLm3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781896317; c=relaxed/simple;
	bh=PSWmDYBBBgTxUtlYJyUhHh5Q7Ze499uJnshO2Q9LPv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7HrXd40Mgg9R7TAc+DglhDGZc5Bcc0zrIyL35/1prpvWi2xDUilwoVZkz4f/NF/5RqSYHz1UONrTGJjR/i/KtwmkA+XFtgxqFnUra2Z7RhsWNpZBumDOqGs7PlLVQep6elNYIswN6v1ooppeo9pYc8Zyn17wBWia0NIgVVHyI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2YlsCGA; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2YlsCGA"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490c0c92cffso16436975e9.2
        for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 12:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781896314; x=1782501114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T2vokOOqyh9HIOtCrLk787ypQb8JtCOBPhrZkWzLDY0=;
        b=F2YlsCGAApsr0SZFcmBC8b/hcVzSagTWrzk0NdUtf7+sWXS0NluzJfEnqmtd9cDota
         4v3YKhqP3eufnSW1qDl/FVMj6cFZ0s2IEdB9SZEUpyelMgt8/rokdDik/6o6NB0PVkc8
         A6Sn3AGwaS37fSmBH3ud1Fr4C/uJOBlN4RhD4ViNgnhb/QxsUM8zgE3bREv2vTkXRenK
         5pdlA2mmbG47GjFrk9r1ib9mDqZpQnQttIWuhctDaIYCncRECIYULKom82VC6QgEqdzU
         hNYplgmw0IG8HAC4UMqj1J+27s1adiIQaln/ImpvivXw70BmdQsjLF6iPQYTNUdilGzW
         CntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781896314; x=1782501114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T2vokOOqyh9HIOtCrLk787ypQb8JtCOBPhrZkWzLDY0=;
        b=QdUFS3y3/qVDiRva1eBAOsIbbN6B1XZnr/uiJkiIx6IROXO1Wx+arIuFcVxIKs8mZ8
         c9u9OpOyAtzf6/lBj1XCMWDDKwJwtVW+yoFQ/CYe3AxJKoRFms0YeGl2KYf6TJDd4b38
         TRdMRhXwUg9VSSJZtOcdUOCzy2zQCBwQPU9EAN22O2tRpslwkSYpiVtsrHZDWP4owkwq
         +4FV3qHyk+4rnFGcKV2c8QxiMrdpXqMSrqYqTutZYO8g+tIQ21JP5Y9WEVd/ChQO2pGc
         o3M2kFtkIlePw78zDQRcn2t4jEdHG9tEG1oMNGDF2AM+lSZusKYizih5UMqcjEYbQTKq
         nQIA==
X-Gm-Message-State: AOJu0Yx41+3f0YlwJS4NIfvKEW2/XEyVDYI4L80tuq6u6h+xkr93JOVm
	/XZxmmR2QM5NCj88Dr/dkAaE+3b6zQK8gheqbsHbnRzleMMyKCmF4am34kFrRGZQ2lSESg==
X-Gm-Gg: AfdE7clvyfXReZ3rFkv4QKVqzoDU2JJXAfiReBsmxQmXQIV+/hgJFxQug5sq7JlYZ1/
	PrZP4G3vN1kXEdahaZLqP007Uqp2424vIazi0FvuBCTTT5GSdO9mnHuKBjrCJ63rXE1zTcx1gIw
	/UBVnnFpn9iYUEFcjiXhs5CyC3uBM/bcTqEkQBqOHF9vLTbt8BVsQNPldk3Thagx0Lp7sSazQm0
	bECN9S+sgmmgaEQz4Tpa5WWDn+gAsGmy3U/GLZFu3dYpvd5LviioXdrnBC9u+xbK7Y2/M8b6/sZ
	9AAdYU4qFxsLWAWIN4InHLpm4/17clvyEcnnpuwbM5UHqQ7GKww4mBJw6Dd7H3g2ieBF3JQ/dUh
	9jdR7yliiRIntyJ1e+YJ6ic/M/O/Staw18F3sYysWZQVlmyH95OVNBDLEIqWOZnooR6OH/SDyOq
	xmdSNKvSy1me4tn5D7plIcgX2bCRNAYf30M70B/fFaTQ==
X-Received: by 2002:a05:600c:8716:b0:490:c032:ae92 with SMTP id 5b1f17b1804b1-49240ea870emr73662535e9.33.1781896313690;
        Fri, 19 Jun 2026 12:11:53 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466643f4e93sm1384222f8f.7.2026.06.19.12.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 12:11:53 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 01/10] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Fri, 19 Jun 2026 15:10:05 -0400
Message-ID: <20260619191022.27008-2-ablagodarenko@thelustrecollective.com>
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
index cc49ae04a6f6..2c951570990f 100644
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

