Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA13211A14
	for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779838592; cv=none; b=dyaAg39aRIGHABHghpteVkcKFWwQl/nIfUsywSlGq3TTkR83GJ+f20Xd43ITsLmc2pUOasWLg1Jy6/lT4mtnI+8FfR0GcsddQn8XKde5pkMph5mZQZ/o4n8VHQoSIW8FG4eDaa9bNEa6hrqjMNs3htKE3ZCJyjHVNkbfwCifgVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779838592; c=relaxed/simple;
	bh=NigLCNX/oxCTYkHCOKOjgqFuAXqEpM4AGLHC1f/xabU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RpiA5Nu/JCdJQegnEg5hagr+YfioPOH+KKDlLaCWiWZe+a5N4xFDysgSadUqm5t9ZfMk0QilC9mcgf5JGrwcOMIzQ4pg9LCx5AX/kPoAywEJW49Hrpzfzir6mrc4VASWbmstBOXM+1k4MHrZ/qXDTPnbhzButNPJfmCJrEbAhHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sUDolCOV; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sUDolCOV"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4905e190c71so32004475e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 26 May 2026 16:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779838589; x=1780443389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EBTU8cCZkXEldylsFVejom3DYLX55cqwkGlJmx8ZL6c=;
        b=sUDolCOVERwFSG89uuUsBm5gJXaoe3I4pHg2X4YheDkgmOixej8VyXNtoIsZP82BUv
         g0UxbhIfjx3Qrom6YwkuTg2koQwSIAPhKcvGUuRI5MVGPHEBayVa/GFXXm8koYdAw6aJ
         bxuabGFgFq626LXwklLhmULMh38b3ADfE7tVCeOA7E8eIEqUldRM5N1eaf2f1Ag6IhGc
         cONMQtTejEZMx+yrfTmiGDFSBinNJrOwADVKWsbLqe/tx22viuVKXymkGr3zW85bHUCI
         gekqa3wuoHEULNYHWdy4/OF6jFluv7exgJAv67s3TjLaUKPWfbZe5qe4zFKdOJ5tvGXC
         Xb1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779838589; x=1780443389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBTU8cCZkXEldylsFVejom3DYLX55cqwkGlJmx8ZL6c=;
        b=XDIY4zYyLOJ7gzYDTALK6WJC5sQKuaD3uSsZrI7WLUO9sWos5wxHH0eYNskaEgSG6v
         tCw53/7g/QBaQfsJo4tATGf1htVjXUqWegSvSc81PVm6HBmw5YnLqq83tqjQf0cLdTL/
         nSJGSoPgSnsqq4uJy4q7QMDsLf7S4D2Y73ZVqUzjfv3WMt61Dq1hL/JLnEgcX2Q+S9G3
         vdqdhkJk0gLwEjqYrkxz4gU84LxprJA2kVWK7jYyzijDG+F7ba43mxHsI98Yt+33FZzE
         brQw/SPO4qvJr1k/TWZUVZi3tGJDv0tJHVNuJthrjPLNWJxn756C8uN9CmFKsMGjxIhF
         6EEw==
X-Gm-Message-State: AOJu0Ywp/xSFxMxk1Y7XgnPKnDq3QJrQKaJobAvvoDFEsuPoXedpLVZN
	ynlMOdawK56zQssZwIIHdXm3mnpHOIPs351Zg/OjiFQSmlI18AFoG9sCLH1stgHr
X-Gm-Gg: Acq92OFu9lrJ51ZuTD5q6zo1pahdyAKW+ZO8RuJwVQhBJ6nxcljPwl9n8gwDT9rhU5c
	tTvgy1UG1aEzpbNoNG4VJ5LQSSelwtltywr8jImoxJE9hsB+kJSNTO1ARh9ApHT7tsWn14dDT0o
	leOzFOPP3O91P4iWrh705HTG+BB1TKuMtZx2grb7EIwmA4XpS5TjpdxgbliXJYKsAEFpjU9zifz
	rcwFZNHbqD1y1uqGakldtXPuBxO2uJBbISJmboohp40L6u+gMvjnRnvJcXblMXwvHlVffQ0Ax9h
	HNs/g2Zg0znNfUaDnEIdekIE7qWFFEudJnrD4KKVwXwHDXLZ3+CwF1WLz8kOktHKFEsIsWX8Dxz
	mPBwZS6vKJQBL469AoUgK6gTgfcaqY7wskD4kw3+dU7F7HfudEPewoGzDbOVXVSiP5q0USuCKHk
	xOB9WoPs1CQ7vOBaKDC6G3/Nqcivbp8RA7+tPpng6JHQQQ9IuT0MgAPgPZFiJjQts=
X-Received: by 2002:a05:600c:c4a3:b0:488:ac01:72b6 with SMTP id 5b1f17b1804b1-490426ceed2mr346904375e9.21.1779838588622;
        Tue, 26 May 2026 16:36:28 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49045620c05sm357354775e9.14.2026.05.26.16.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 16:36:27 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Tue, 26 May 2026 19:36:08 -0400
Message-ID: <20260526233608.7600-1-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
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
---
 fs/ext4/namei.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a47fbd8dd30..a316fc2ac41b 100644
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
@@ -410,10 +410,10 @@ int ext4_handle_dirty_dirblock(handle_t *handle,
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
@@ -422,10 +422,10 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 	if (rlen == blocksize)
 		count_offset = 8;
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

