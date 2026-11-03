Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713825;
	b=vSZ0TV8f6tkgyXrpMQPCRuhWJ5zGbuKjsueTAcuwZaqTsVOk4yGXPYYUY3HMdrbXHh7b
	 vpo9gY+eXpHBw/W54wKQkjafO7CvC82AV2jsdGsI5b5jQnLeKlmVZLc2umT8Jqjsh5c77
	 Hlz/c+fCdf43GWZrwWlHk7PtpvbU8a+nb0WS0tbUHblt19J9V3nQWUiea40YWSuXmIoMF
	 8XLlJZjsGiOIuOguazowTEF7Y+JBWN8lwkxt7naHvp9FJjJA5zOZg6pt3Em978eWAv7+a
	 fxeAXFijDBbZlAHDHzX8ZFoTuOYelVj8/xVBK+sbsu/b835p7kew1T0y7fOfkhOqw5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713825;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MKRQnzkde5k38ZJI7kLKecM/sFKHCLQnMlatmlXA+mA=;
	b=LgHWX2mcdHOeuTBcutAumW1bNhBKSW0EcoXKArAh8PA4EtVsauK4liELybPr0YUF5/wr
	 ta3TZMsEBs2Wh5R/vt02PRD9wNsuWFkZUr4faYZBgZhG9ridECUgnTh+4YZmp2ym0qKr6
	 fNiWwFncz7kuSqd4qU/z5WNGaGg8ve48eKD4hYo0Uwaqmt+CNGAH5zjS6tJFij2al/3ul
	 osumAjlghDdBjSz7cLzflgxFoHxTiMfbEM1FUJ1cSe/Va6vqUjuJmQdbxeHEnAQHtJeyQ
	 gE9saigdvBM++NLngagk02Dd8wE3cr0666Z64cDwq6vAhYSuva1w1TSLU/RUfkDMsiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bftalugI;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF7E606A338
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FF7E606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bftalugI
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a208d93758so44802945e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713823; x=1794318623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MKRQnzkde5k38ZJI7kLKecM/sFKHCLQnMlatmlXA+mA=;
        b=bftalugI0WAUUn2dHiZeGI8dSLYKr20ztt4M+SWtrFQhGI7/0Fk2Pc21xCV6JWRyen
         E0Yc3r618cigf/YosjEbFLqY0/d3+uq8OPj6SH9Xg+99fG4fV59JPVtRenPIhAwLvwtm
         kw4M756xfEgwIsANF/kXepxOrqyGeWW8HH2guFB0batHunjW7v/X4s4b2i9Z9t5ahmeY
         VMLgfG8OEyNolkp5m19NvLBFfvdDVqiLDWcx8FGxFR9hN/5GRsZqbKpLzD94Hhi3C3Kh
         NkS4SslByNwUyxje0/D/YPUR8RjKiidvGrz6E4ghoZnn5GR2v4pd7cKUVWXDKn5I6Akn
         r4Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713823; x=1794318623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MKRQnzkde5k38ZJI7kLKecM/sFKHCLQnMlatmlXA+mA=;
        b=tz2NzCTy+MP+V+AeSHa/G8KnmBvdMcumD3066LDBTYTGlc6Gg5Qw8ibsh5S0IxIoLH
         RgLYtP1y1OwCVumLp1Adg6J4QPBje+Ai2qK9RftvjxJP/0YDI6s/Ae4hE0+pC5ATmX7U
         1sPw4EXOtIeBm3HSzj+kIsRX+09S6L5fzLK6AeQxcD+oN+sJI3EB+wmBkQy3HlD/7pH1
         ucyzhhjEPEt/OEUOjHFzmGYnP0wcEWhOySVi6qXJ0nhpXVCMjLHcFve8L28zisgUy78U
         zNLv4ipHY7y/XLBERvhhhWkRYAn74IA+n3NiPGEyfHsoSLikdV2linKOX8JPbC/HvIEG
         UuVA==
X-Gm-Message-State: APuU4Z+WCwmn8l4pnhnsAvdD2YsxX2nvU7/ImnN60h21JrhCk3Mcw425
	5z7EnRK4cF/5r0E9PpnE3S1diFq5lUxK7l/U+p5V1nbszwSxlfZLvQak4qelXb9kQNQ=
X-Gm-Gg: AYBFou2SZA3RAeYPe3xP8LYs+l09L+bFPQqRZlyVYkqFYkcdBDNnADLkhJew5Y40Run
	k/kfs3i0jXyZzWhWdTzU1NigudaxG9hYZRTDblJtOLM+PClEp6qICBx9AFWtZC3PNii+Yi0j/41
	v9guikGEYAQyOOhC+tj78BEIQHgS9cpwLGVHhOtpyB3fxof0FvVyo72tf5vUVfrmELNJ1/H25ib
	TuWJ1+Y1wtvWiJIhgepbVMTQfHG6r8svY6wyDYKGDwXkNGZ2dbJVwiq53Ou4isQypTHfj/+b+Xf
	jg/6YYwOVDOLR2cTXQC6oEAKSmT+9yfQemZmN3acEe5YZGBjpzGGIY6YG9bAluDaiI99G0INcft
	BZB9El4AgBwaUlaYmGciznWQP4RP3CVOeps+BjG6NncgcMTaJX3ozI5p14Ex0uu2bvsbUb5Ld/+
	j5dAaXyEe3ulbBH2pRBp5ityfuSNgimnb6hSG3n8PS17zc9wczFUslvum13v14I3TS+0iZTOp8e
	TlgWqmcBAl90tSbL+CFj4vtOJi9daN5p9aUQ/x9pZUah7CMbLRUApPspgVU4TG3Xq55EQRaL9at
	edyUyzAjlOUaCPkfpbJ3LY3TRHxSUN5f2YHlKDIYIV9Dpx/m0e4NfmPJQld1
X-Received: by 2002:a05:600c:3b18:b0:4a1:c5eb:b445 with SMTP id 5b1f17b1804b1-4ac1932b542mr312629075e9.35.1793713823000;
        Tue, 03 Nov 2026 05:50:23 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:22 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v14 03/12] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Tue,  3 Nov 2026 13:49:10 +0000
Message-ID: <20261103134921.610047-4-ablagodarenko@thelustrecollective.com>
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
index 8d3af062a830..16df13874559 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2507,10 +2507,8 @@ static inline int ext4_emergency_state(struct super_block *sb)
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
index 3d69b6739cfe..dc8035707feb 100644
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
 
@@ -1519,7 +1519,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
-			       struct ext4_dir_entry *de)
+			       struct ext4_dir_entry_2 *de)
 {
 	struct super_block *sb = dir->i_sb;
 
@@ -1650,7 +1650,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		}
 		if (!buffer_verified(bh) &&
 		    !is_dx_internal_node(dir, block,
-					 (struct ext4_dir_entry *)bh->b_data) &&
+					 (struct ext4_dir_entry_2 *)bh->b_data) &&
 		    !ext4_dirblock_csum_verify(dir, bh)) {
 			EXT4_ERROR_INODE_ERR(dir, EFSBADCRC,
 					     "checksumming directory "
-- 
2.52.0

