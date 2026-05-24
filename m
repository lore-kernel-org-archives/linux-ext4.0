Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376BC32B11C
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655054; cv=none; b=H3YsvIGNoxghX7TjcRprHCaCNd9J+DTkdxBiM1yBNHhDmXfK6axUdDWzgU99AsLdea5Xo52QH+7UhX8KXZ4l62y7MfebfxxiYOphWBF8bRJcbyZCS28imqTA05pgj9suPrWArWM5JQYE4TsLVyMQjyHf9TG96W3yarY8Dw21tKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655054; c=relaxed/simple;
	bh=KgtPx8XdBT1wPW5bubM+bs2SL8DtrSMbTZWnx8Tw2Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKPOHlSjZ/co0Maz2lu3IHZ4bA5xHCsYobvlA5MCD8YPEuop7GPw2gYwTy4tuM4WPjoztDsTtqgW2+X84XSWgDaiB78atufFOMz+DvJetOOHZnU+7hZeOP5RW1Ky99dMFgINij8/6Ncafbe8E7GjwH49yK0GB1fUAzueNkGBdSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U3vdGbj2; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U3vdGbj2"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490388fd0dbso33578355e9.0
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655052; x=1780259852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xSKqOFCJOf3p6Gy04EYoRXXlaFWcLfzV0saNKFxlP1E=;
        b=U3vdGbj2KSXf5ESBuPQU5LAMW+O+ixFxuXMeDhVCEaYrtnQ2rUQZmETbq39X/VC/pc
         xh4w+uj/uomUdCgybnYGa2mhgZ0Ce12nIHRjcUG2EbAJVbo/JpWKi8xapBKhgQF9LrZN
         w8llTAyKA3XW3TeVT0/Hrdzr4H/gcI9E5q9/yoYE/UxkAVAwAOOJUJskuBOHZNtXWO85
         80smGoW52z8+YzVt0Mzl9GMdTKUNB1Fc61zNCTKFINavpcS8FL4McoSamvLzyuCnC0CU
         BdBNnqH3xTbu2ybTabvNx7b85lmxtnZfLsayAVt3+aqNRN6u5X+KAUxAgEd3scD3zc4G
         is1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655052; x=1780259852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xSKqOFCJOf3p6Gy04EYoRXXlaFWcLfzV0saNKFxlP1E=;
        b=orsvT4mKrwHEIirWIMw1AMIVHqZlP1SSkLkbp+LL+E2cQw5141/rT0HROkIRYsKSde
         l77TIWRm5+VJdbj2/FUyDFTeIxg/vQeFAAvwdZ4Sq9n7gc3/4N+tnI/nSgElxpsZI3Tu
         XEdGvHLhQsPTxAhTGbGO0cqvcATmFoEY0I3+7WVXSyuZYB7yXWqNM/J769OS3jWnNyry
         T3WjVFGj1TxbzAVKzXEbQYKDqqRGRJP0glZrcayR2no7ekYyXVgz3ZRU2a44mXUgJiC/
         BLCUbzc1Wo8EGWfYL3KrHAn+4QI2XP9YY1Yp2/W7DXB2Wa2SyoktkWBfoN3m+BPUWZDs
         EjNQ==
X-Gm-Message-State: AOJu0YxUXMKpGGh8AtjxFMs8QIfAGipeLGpubiAYni3SoezDvXEejWba
	yVOBZgd65mi/et0gLlx/fZxx/QMq38jpnJR2+9PmXr/WQiMz6YDSkUQWkdmYZGPx
X-Gm-Gg: Acq92OGPTEJ3ywPTtIk7SJlQUau30RvNFOb6zpehc6Jj39A009AZ3gUYGJm3aNHTRWR
	efbMzla3u8HK6EMdgmfafmYaLZnW1lnkTWBnfTpiQ2tPwfGKRC3AzHOm6tSQkf8wYZbF9lQsmdp
	tgmpoExZrwcsgs2ROsvP5Vz7kw0n6Pcah0V4oM+L3Wq4IeQmhNYimm+g5uDHsxVehfNFM58sjV1
	x+7hXx5oV3GzrDjJwRUrjLTwgNT2naay50yX0D5ArwqNYYCYZQQi273ZUG+3wO4Z5YUAhr3JQzF
	pn6uja6euI2gegdnKQpeXgAIhIX8bdRMyF7gEK6dblbWmH8rvRumUGEjRoNwmqDdF3/vpJzRjdU
	tH9mBgUze9qWe7G+rPuFaAGkBsIlIQ5KlEiIg7A7RPdZZwsoN0aPq8nvKY3OEJDZtseQAjgE6rB
	5KghEc+/57Rwla6TJXrL5YvsXw0nckY97vlvEDK3G2
X-Received: by 2002:a05:600c:4ecc:b0:48e:5fb8:f80f with SMTP id 5b1f17b1804b1-490426d1ea7mr186229695e9.24.1779655051565;
        Sun, 24 May 2026 13:37:31 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 09/13] mke2fs/tune2fs: add dirdata feature support
Date: Sun, 24 May 2026 16:36:54 -0400
Message-ID: <20260524203658.12406-10-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
References: <20260524203658.12406-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add user-facing feature support for dirdata in filesystem creation and
modification tools. Users can now create filesystems with the dirdata feature
or enable it on existing filesystems.

Usage examples:
  mke2fs -O dirdata /dev/sda1           # Create filesystem with dirdata
  tune2fs -O dirdata /dev/sda1         # Enable dirdata on existing filesystem

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/pass2.c        | 3 +--
 lib/ext2fs/dirblock.c | 7 ++++---
 lib/ext2fs/ext2fs.h   | 2 +-
 misc/mke2fs.c         | 1 +
 misc/tune2fs.c        | 2 ++
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 938942a80..9a0f6f772 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -435,8 +435,7 @@ void ext2_fix_dirent_dirdata(struct ext2_dir_entry *de)
 int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
 			     unsigned int offset, struct problem_context *pctx)
 {
-	if (!(ctx->fs->super->s_feature_incompat &
-			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
+	if (!ext2fs_has_feature_dirdata(ctx->fs->super)) {
 		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
 			/* clear dirent extra data flags. */
 			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index d1d5a9e7f..fa7cc83ff 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -74,13 +74,14 @@ int ext2_get_dirdata_field_size(struct ext2_dir_entry *de,
 		dirdata_flags >>= 1;
 	}
 
-	/* add NUL terminator byte to dirdata length */
-	return dlen + (dlen != 0);
+	return dlen;
 }
 
 int ext2_get_dirdata_size(struct ext2_dir_entry *de)
 {
-	return ext2_get_dirdata_field_size(de, ~EXT2_FT_MASK);
+	int size = ext2_get_dirdata_field_size(de, ~EXT2_FT_MASK);
+	/* Add 1 becasue NULL after the name */
+	return size + (size ? 1 : 0);
 }
 
 errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cf12716e3..b14ba0a34 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -2276,7 +2276,7 @@ _INLINE_ struct ext2_dx_root_info *ext2fs_get_dx_root_info(ext2_filsys fs,
 	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
 
 	/* dx root info is after dotdot entry */
-	de = EXT2_NEXT_DIRENT(de);
+	de = (struct ext2_dir_entry *)((char *)de + EXT2_DIRENT_REC_LEN(de));
 
 	return (struct ext2_dx_root_info *)de;
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dd8c53d90..2bcb7036e 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1279,6 +1279,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA|
 		EXT4_FEATURE_INCOMPAT_64BIT|
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 3db57632c..c5a40c5c9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -192,6 +192,7 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_EA_INODE|
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
@@ -222,6 +223,7 @@ static __u32 clear_ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
 		EXT4_FEATURE_INCOMPAT_MMP |
+		EXT4_FEATURE_INCOMPAT_DIRDATA |
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
 		EXT4_FEATURE_INCOMPAT_CASEFOLD,
-- 
2.43.7

