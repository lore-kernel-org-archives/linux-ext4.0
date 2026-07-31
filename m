Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAE32641C6
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459336; cv=none; b=YUWJ4+MEYtIVaWMBl24XIK/mjmX2PL4fYl/uwmCMl69zgzxGFfI4ZciKw26neFubFGe92PCfVb8cWRv9nzU92vRlhy1gguqBvSZtpjTimgUwgZT/qouGjToM8CbiNrAMa8Y7sK5QuiRbtifiATutGQ+awBVManOho5mh9+O3IFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459336; c=relaxed/simple;
	bh=Z8TMlkUPdQ4Za4MfVF9gFNyLjEpLDL7M3EcCGdjz3bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jnk/4DhaK5PiNsY+EnGuOp02BSW9n022kT0/bIk1jlo2wP1DKUmBJAg3q9cC36VfVXerzAQ5X5AgE3GStLFCa7TdQ6cwMuAxZW/XQKav8D38Zmeh6MHS5tjCpR4AOtG11oJtDSsD+JtdmsGl1M4YFtRgnslmd5BQZI8f0p1MLew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7yPXx6z; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7yPXx6z"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f707e5d75so191226f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459333; x=1786064133; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=h7yPXx6z7Rc7QNK+WNvSKbaBr1sFO9c+SRUaUpzMvaa40X9nK0SKQPMOR+hxmVGDnR
         kxjSztR82u0ZjJjSIyPHvahz+P88i5ckgdH+SotA9kzbCDLCfqq4V+U4pPCvZgxRl86x
         sMS/EISyyDMDtUdXkTOU8nmYOpKJDOhZ0g+1OODV3RlV6unInQyzlJm2ClaDlUeqLtzD
         qeN6EPpaBP+RH4w+IDlBLxA+HxqLcWrxIlB1WhSTHaOWE0ufsCFelmhpo6IkkmVvcJwz
         3hXDVpvsAChqrN2wZx6iAjn8Kg/PQU0nnHDg++PnKUSBHOJMQJgCLHKD9p55nyNeU3WW
         4kPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459333; x=1786064133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=ed1pXxwWvN9CxPaHp6VGA0/Z73XEbtDTe9H5zgxZdnCAbU2QeuIhOAp9w9A/eILa40
         fG3DKPHOZJW3W0R5D+pINR8IyEiAlN4/yuljyH508l8FKvghvOCAha5e8qwRkhe/+VJ1
         hC376/YNdGHGOgMr4dgySCw+FESvMhiJ0A8A6IXzRwWq2+XnwGqZLrzU/uHdEMnBnO4u
         qeeQ80h4nTaCMkRUNmtCTw69rqFL8k53TE01tmq6EQjKNTGBh2O+ueQVHtR3AHVm8Cyv
         zBdLpK51QkXz+y7Y3mXK0zZncdFnKCNqcg8j0Ta10Glf0BA+c+Vm1FW7GOp4D4RxQHxG
         oiTQ==
X-Gm-Message-State: AOJu0YwmrVu8nCJWc9rzxSEFmpfWKDKw9y2iEZuOnaYOLDDk6nzso3ac
	PzkEo9jSo3QucpWSZm0faFUaPYCT4hZdaqwuZVNBKRuCqArmZ2FvFm9nyM3uKA==
X-Gm-Gg: AR+sD11gmdB7ZlYOGhMwY6qHXcVOCwcyY6wFHS3qBhFd/wCIOUrleDrYRqW4lE1QFAb
	XEECxJirVFtv/YA60wo9lxCghFVsN7OuS+5agk+XV6wgrwr89gFj/nujkBxX0ksbiJMm85QNipk
	DKUKwspLAfiUWuBpi276udBGCyQOQ/EdySB2iFtHfasXf6tXc92mCg6kcMkrQfwX52FaPycjofL
	ish3JAPJNRQVTfonH8APdPAPAFkIx7axSDzxoJ1JS6yx9G6gngKTdraPCO0AJ5DA37P7n4Oze7Q
	0yqCJ4IV3R/PRwETXZ6QU6IsyIrQhJL4lSbp8+Yuji1TniOebEKoea3KCZxMX+fKvCkdmOhWunG
	ljYTGRQQ4/FzS8nSp3LaHqbteZ0UnbHzGlPlYr7lAocs+dUPWKJ7d2UYf4XjIikWIYDdwjUS9h9
	u9opUOKyUhcTsw2HbsZ3jQ/dKNlw79pxl+AyZKjLay/jEkv+1I1hJsqiIORbhxE2s5KNvHTfybN
	nxT94/+tuJLtzwrmwI9
X-Received: by 2002:a05:6000:3113:b0:47f:5b52:5579 with SMTP id ffacd0b85a97d-47fd2acce98mr393231f8f.18.1785459332683;
        Thu, 30 Jul 2026 17:55:32 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:32 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v9 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Thu, 30 Jul 2026 20:54:19 -0400
Message-ID: <20260731005430.36801-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
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

