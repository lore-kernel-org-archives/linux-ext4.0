Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276831;
	b=SOSMzTbIukiF33dmDb8qA0vYhFxsGMIHXJv533+5rC5B/Qo0fLcGIZAZGWFphxJupZiE
	 6wCVY+zWA8NTBf5yWqt66ymPdzI4mB+ER1u5V/J/uacYAlDh6Nkpcbw+llcuVTyJUgiQa
	 /z0iICZPVhw0n1M20ASiJpu5fp0OnkD6cLHiuQheeXqRxSfj78Yo+UBvk9GndJ4XyaqL8
	 aHkhPZfAhO0Q4KnpbPSntO+zVjdaDaX+uyBmrrCiWufYBWmiXtXmGhLIQTTpiUc/6RFs4
	 rhGBrrOZ4utbX8W/8gwXoP+YXEZtXft7L/Qh37u5xwGMw5RJcmwLCx8gRy/Wa3RRcHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jLMQxcFh7u2oIxtLn62J3705vfi0r36fWD7gCfWAg7E=;
	b=OTcYImZGHuGXym4P+NN5/E2hJhv4lDSR9AxMyIPXUIpez+obIFfiMsYvAJQIknatDFon
	 IEjAF3TBzGjSSCY3S2AqVmkmWlMm84kuos1TkWKa0t21cqg+ZJpp/JD4UUvfBkJdoO5lT
	 jXhAYd4ptGkTmABIJMZ5i42b3hXR2yDoyeDFtB7H+6eb+79cO1L57bNdk1qcy/hsJ423h
	 It+KyVPX9A4z5+vlpc4Lkq0Mdpekwt4kd2r+b+V0DI4OygBEbHvmDkFLJe/6hSHfrLokV
	 CU6vQI9s4i/WBMv9rjfojamI/LHg13BEHMLDTXiBbTpwOPkVz7wIhToXAkoAwVjISyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0HslJDS+;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F55D606A324
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F55D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0HslJDS+
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso1190346f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276830; x=1793881630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLMQxcFh7u2oIxtLn62J3705vfi0r36fWD7gCfWAg7E=;
        b=0HslJDS+6vD5me95PqL2CD9Sjecho2xzTgSFlp37DZUsUM55dU8uHV984d8f86pLAK
         iZh568/obiZ27H1b53ilv8/e9PA347uVt1hBHb1usa+dR31pf2X1CpeNCs6Q19qnWRZu
         RtFvB9p3lyyUdyN0oh+uAoz1ofANswu6VWbfzlwjI0EPwiKP88oVtbjtBV5/g9OgCdUn
         5bRfFNW9j13f6dQKmFmRjKo7yZpaa9q0uJrvIr+AC2Mt+qHLFcBwNaadsc+i7wYcT2AE
         epceuT8dBUB4OmIYtbhfrDeLyQ2TUTFjz//PlzvjABgrg+584kH11U502BlKbbidOVJG
         hO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276830; x=1793881630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jLMQxcFh7u2oIxtLn62J3705vfi0r36fWD7gCfWAg7E=;
        b=eu9WQsvfx1ikxUHWCHPSPIxltediitY4B4U3CmiNpf8bAAwIwijDyWPamiF+lagkk/
         LZqXcSqHhgFaXiC7IA0ZkeRh5HOC/IHclO5wwLaqTaffpSFseERYLwKfMSyQIXLZFBwq
         /4kAqgUsXE8IW3ybsgkMh27kyUJ5wdCDEHREPSU53opCcUQRLWxnTPPXjaYhOS6SiLSs
         hFg1l5d85WBgO9nVk0y6CqrAdDQk8Zl7d60O+o6/9+Q+Z3da8l171S11YKqfL8mMNrUg
         gWqIYNiRqdYQT1wZL5DsovgqmQMSXZ4SuK/k5zCv1nHhi5sjCwjl6ujwlpG8tYBKN9/h
         3tPA==
X-Gm-Message-State: AFq9FYJOi6NfbIh3BxWlyGxA4R/ktwjxD6kc05hnduW1fYss92NfVtZP
	eCF26xXDGwLKqNe2gNoYNX/d7Qognp+dJyGt2spAqAdbxb7DcNdL1GkogQMYW4fx
X-Gm-Gg: AYBFou0jEfH/N7KhIhWllXFxLGzlIezAwOlnFbSx8FOz6mdJYSqn484vp3+i3uaFZgq
	YL4SmNt92oWXjkHMFg/rIevE7ajmRFijzndsZqNMPFQsvncqCeNZhnUJvG/osOz0lOIRhzgE1QL
	sM/Jv9YmP+t5wJOMNFB7Bm8IWfnbGF8pCvSU4ubpetzY9/srKKPQOXPTmxJO3NQSbh/Q9MG2Z9b
	WtUV9I9U1Y3224I9ztKX5UgXPFjbwbG7F+JCiE0UPfq5PJpYu0Jl6IfsEJc8KvMlHmof1Q2ahQJ
	NC94iifKjRiYa5pz77rEXTX3gHsqXdFTqdvQWakOzEYctOFzDHse67bVmyVsVyLCquH+1IPMgen
	JI9LeIGwZWQQGFhBqx9kyU/vBUmECIRJaDWGWM7X9i87sfV3v85l7aqrS8AzTuhZztEBi2PiSE3
	2uzRI6TMwxMaeAOApTccA0fSZD4JLyG/PqwIRrccIuygfE91TDakZxIu/02GbvFcLw3fAU4KUmj
	1rZQr3+alawqSRou/AYbSnYpzX+JJ1MbZvIiSy6d+qVF0+2Vkj9xl1+3a4WFyfTRo0Z0epBIsX3
	uOKjANABerECSErCZw9e8Qa6vQBGH3nZg9D2rJddnEDMj+JRTzcV4wSVmWHD
X-Received: by 2002:a05:6000:40d9:b0:48e:d36:77 with SMTP id ffacd0b85a97d-48e5d567ddemr12687681f8f.4.1793276829476;
        Thu, 29 Oct 2026 05:27:09 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:09 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 02/11] ext4: replace ext4_dir_entry with ext4_dir_entry_2
Date: Thu, 29 Oct 2026 12:24:01 +0000
Message-ID: <20261029122413.230409-3-ablagodarenko@thelustrecollective.com>
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
index 76b9aa3fb03c..ec23e72cc422 100644
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
 
@@ -1498,7 +1498,7 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
-			       struct ext4_dir_entry *de)
+			       struct ext4_dir_entry_2 *de)
 {
 	struct super_block *sb = dir->i_sb;
 
@@ -1629,7 +1629,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
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

