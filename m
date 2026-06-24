Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4303B4E88
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782308288; cv=none; b=Q/h7aNWJCrslrF8jpv+qqYGZixMQCo9BeJ2g8RdbOchEL0YpXZ9QsLhP4etFz3fLbW9UGNZznwBLzqlXtzagGtsVrevJlbnyx88T4oQ6vBYzMgu/d7bhz55Y7NcVTTqP4F6Rk9mSYBwagx/w3FUSWqm8KwFYvpIGlr1Omrf3kzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782308288; c=relaxed/simple;
	bh=cTz4//zQMftThxkY+RFC0pM+ajkaKrZAyg64o+wBJT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4BdOnlAKXW8H/Zu9ryPEWEfcA4jgumUA07PSw2QVRsZazRljWsQK4A34ITRrsYVuZZGQJIiIEUxrHZLBEmzrrYElBvmXISz0oTlG+72ZV+hhLAtUyPBoLS5Lhtl336YB/Z8ubvcY9W1iHRMi4Gb7RnOJgOnc22XHy+uVmcBeps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W+zCI29v; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W+zCI29v"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so10445605e9.0
        for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 06:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782308285; x=1782913085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tY8Rhm91+CMmqUrFRoluBeVyTiqJHjkdog2RH8pcv/M=;
        b=W+zCI29vhltCnBa/1NQELYHK0oDlmejdH/JSQEOo2CWh1Lvb6fx2xXMg/RaGaE4N36
         D5Vztgok0SD2G+41hoNlHIAbEfJQVGkxovnIEiGzcIRkjlim/SYKieHUJEFBID3i7XbO
         /ItKBzD8vNNgXltmVlvoFPu2FXdORUa1VARvYq+YvPVYTjHBQbMzGqQGjOd6mMOBEV+O
         75a9tvtXKbg7EuYHN6BeVN3vvze4fA0blL5Da1gAZjAhd5pOb7+SCNidOz+Bbn8s8p6h
         YtGXJJjvA1WSQAF83F3VvT+HEZjMDTUikNdH9Zgpy35KV9jD5m2z9ZGIpVCGDFGIyLWo
         eNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782308285; x=1782913085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tY8Rhm91+CMmqUrFRoluBeVyTiqJHjkdog2RH8pcv/M=;
        b=jVa7NgkhpS95GyrpbTJCAZcZAG4jv6fx2rWdfAB+9Eqkc1DicILr7LSHz1eXfZZism
         fJprSWtcHT24A0BbyBYTGR2oPRvSavpBvR4HiXrbpfnoKsBmC5+P1nm0SBpalUWtmIXG
         3s8zsQC7W3uULCmA4H8WF7TVbYDKpK2q06ztxcb2nuxuJe2I4IkJ6Tq0dgqoHm8vXz7X
         Mzh0t8+AvmKl7Qp6kMOu8hReodX/n0y7u9G0o/2RsG2UouFJOVTzc9Y8m7zycLwsWiPw
         alPD4YwcWgk91rTL7wS1flhHf+XJ2qCoHhH5kyWsxvehH+3muJbhM4E2uMB+Y0yv6XEA
         fJ1g==
X-Gm-Message-State: AOJu0YxYFE5ONnqhP6GXhXwklsUP1C42ZLHC03k4U82G0D+PxbxrMQ27
	eZbzXV74NGNWTlmQYqDaETVLDSP4H1ZJqapes9qsWyEUdhZVoCxXWXwTiXTETnLJXtE=
X-Gm-Gg: AfdE7cl9sFMQfyUUtxHJGHjaNyoAm04+i28WzlvrNFjbrtbJfdZKxUtCMOWo2lwRFaL
	mGDpnaz5SnFEYepL7R+5CGm2OS47iv74WBlE+Cx6kPjH21vXqstQXPxNndAz1ws3H9xAVPiPyIg
	azUhXUQVJgA8kjPL4xUUv43K/Vwg9TkRRGaZYzqEP+eOQ+Av54bcZkpbGIEcHVSNS1tN7noqi2i
	hpBfeIhVQ/YnIlxeIOA4l9nen2uX0uYdJZe5lGqhtB07WgToRlPUvZnyUJ2VT8L75Ls+zEUGvsg
	MFY+1fNaUWNdO1cYwr87GxMeL6b849W3MnDyOTKUkjXuVwd8COvpzJX3rcwt7y7q3KmJCTOxNPu
	iKWgYtltWjAPb8otl8JYDGynHIzx6P3VaTSA4rYP1jJwZR18Iw9E2A3ToOp6oqOpZupFB5X2ADk
	DKPcSmj+69hjj5V/L4mI1vhl5z+yBhl3lzkCOwwfG3SuBz
X-Received: by 2002:a05:600c:3e05:b0:492:3fb5:3a17 with SMTP id 5b1f17b1804b1-4926329a882mr7019295e9.2.1782308285094;
        Wed, 24 Jun 2026 06:38:05 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:8ee:1201:acf4:9ddd:6ede:2d9a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd33dafsm501416155e9.8.2026.06.24.06.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 06:38:04 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Wed, 24 Jun 2026 09:36:31 -0400
Message-ID: <20260624133642.18438-3-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
References: <20260624133642.18438-1-ablagodarenko@thelustrecollective.com>
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

