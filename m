Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9519302163
	for <linux-ext4@vger.kernel.org>; Sat,  1 Aug 2026 18:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607997; cv=none; b=M+ZPuZKNBYyrp9PoERQp5BzmSxp+9Wi+AVxXnrNzK9/oCPgxsY7GVurfx6GMvN7fe7CfXRQgYhDu3WwO/tcE2CRAS6KhdjNV2szlEKVkrHDrJmD5bSkzoXGVI/nW7xAk7x1DmI0nSdwr6xp44cZjuVBe6IKJoVHchbKVQsZMuTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607997; c=relaxed/simple;
	bh=Z8TMlkUPdQ4Za4MfVF9gFNyLjEpLDL7M3EcCGdjz3bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVfB7lWeN8zvO2O2wIVhoIjWswoIlPOH1VjVIrg2lsxIKVuwoyl8HJiplQL+5zwD2Z2kViHGq9okf15L/diad09ICBlmzZqoljXPOZ34u+tShPWZB9JLDmFruqMaVK7JuHTC+BAf89qOkloHWPZp1gxP7COeo7DmN3ANHYvZMG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W5tjRokX; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W5tjRokX"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47de008b020so1435293f8f.1
        for <linux-ext4@vger.kernel.org>; Sat, 01 Aug 2026 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785607994; x=1786212794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=W5tjRokXxJ6lC5l181FZioIwOOEreYBqWwTU4g5bY7wdxd5ov47fiJI9xmpG7FmNyI
         d/8/pmSzNyFIe0uO6DdnsptS1KvQbCL6uJp9fLgRXkCwxDXqjp2ZfcAra5xAmQxi62eZ
         kM6rPDYBnAHMwDflI8QE9ajNit+VMpdf7Nmdz4B+NVPoOUaFa62fqGQn3RfsSN6HT/Ml
         dWXZDU3tmXUWE4wbkkASwUnMOVo7CHg0q6e5A/AWZcrcblfCW3MQQx/AfXhYrwgsFz+m
         aciBfuaWKx5wdmK6xhjFD4K9sXl23URn3600mqKZU7QTd3yF6H8BxU4SVSCQmq4Fa4GS
         WiaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785607994; x=1786212794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CHd30BKGIiuV71Fr8HIaloI4vSx72662oUfzrq0B9n8=;
        b=gYpGT7GJQvFkv3KtuRXXodHT2nfPxZKGVqODUEnrAeOqCb56iCeXb6ITt5RuqFJAXe
         CvXbI5TNOz4p6rROpDrX9eN7YP4VdCUv3qlybW5DAfwmeyXpqOvUnmGQzQtyxGH0fOv7
         tf7zTqbLmQ7KlD64MZKPk5tXy6uRs2CAZtZGvmm6UalDEUt0+QblEiaPB43FkCr3em+I
         2XjexrPYetCdCHKWJHUU0/+LBt48cyVeFCX4iJXrMhASC8J4WcpTPBY7PWv0vKVoBk0j
         XOSWxTOalkPYUUlivkId0S0eNSaz1F8sn15XP8cJHU5byML/6i9O2TNoIur1I+1iyN+q
         D+AA==
X-Gm-Message-State: AOJu0YwaU/ITBpvNkILu6p2U+nDsmQ3fNYrGZhVHL+1d1u8Q87936/Od
	GFN9+6xj75CzIblg0xHPlLgOylf4nQ1CXVt+gMYRUUEQW5ZNbmXFuMJiB4aYyg==
X-Gm-Gg: AR+sD13WmzGjPD26Ew9E4wwAAixF4zz49q3h2l3gj/BXhbx/B7MAWb0RxRhT8ihSrR1
	M9jWvlKXsV8tQDM0mNuUxJe2N4ovVKHR93PM5qubPybPL+M/6jDZO4+qMHfy/DGLlQYQWaFisbG
	Bstihzti559pj2WuR2DhjTTxoq6UWtyw24SQXtzrmF0MsGZ/OMzDq0VZOPTtxPiO6+pRkaFGpdG
	4zS/9Q1C/0q4stuiw7N9x9GXYGYUlZxs6JAftTf0dtHzajdBEsM74IZ6ioDMYNEAaPyNjp8POFG
	b7L30wkXoGSkPk/rhpIhHQUEK3WQs/j2hswidrCM4iWQJfl+eRhVIWr5ej0jsjq4hOn1e2pi6qX
	a9/kJznb3fehXZRF9lA+kduPsPULTlNtXat3ZLzRowdtnvtIRY8DxJHVV4mTsQp0ztOerAeJ8nX
	ipDPOcz4pZJuHghr9K8+OMsG5ZEWskWfGD3Oop9WXb0UZS3QcOLl4kaqO18ndn34EIkK5fQGIMJ
	cFoaDJA7bMrE0eHwRBa
X-Received: by 2002:a05:6000:481e:b0:47f:8cd3:4bed with SMTP id ffacd0b85a97d-47fd725b19fmr9975894f8f.5.1785607994063;
        Sat, 01 Aug 2026 11:13:14 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458adc9sm18819761f8f.27.2026.08.01.11.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 11:13:13 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v12 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Sat,  1 Aug 2026 14:12:16 -0400
Message-ID: <20260801181227.5198-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
References: <20260801181227.5198-1-ablagodarenko@thelustrecollective.com>
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

