Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713859;
	b=r6BeLIaZraDn2lk+CciHhTrqpijMGdIooCwlCnTMnxxcBUuiFIVTDKhnHM5TsV7kirs0
	 SAvCJ7NN+GtQDx48Klt4VGUIJuUSEJdFyyQHZn0WWESU3LB/vrAdPILPgkmilGJl63DJq
	 Blelh1NB8ubojXhj1dkckgFf5kvnFEcaAsTbdKcAxSpuGXjLCWXuorlVXyMil9fEGnCtf
	 WJwUbhxMWfR1NY12kAYhQG6w+Ae0U7IFG0rlpCTs22+jYL/X0lWkRfkHXRxSdfHjN2FzU
	 kvIOLAQ86SWJlmv/wGm++aiEqVGLTF02jWdeRrZFehp4EtBqUn6jx1Xql7Str1clktA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=E+XGOdV9Ng43y7QoYPGs0jtHE/NJkGVytBAQnXl0czs=;
	b=g0bKxW3L4ydW6OMjt23C7/68SXFtkniezJnnZR/MFtaeYldOdhusrVCgYXsbtZuvecNF
	 Qh9l31ayMy2PsG+L2jkaYX6HTeSWSHuqAMjIeuo6n+3LrFnep9vCdMBrKZF+3wFEgCmPK
	 6dGDg4jfgbxOCyIIIomfoFNR3IE19pZVFKM96S6qEeeenuUDfp5nMQU2KaVS4rdAj/ml/
	 EmMR8E7USfsX2NRreFofUfsFXIOB35BXHLwdDE1rnWKyeNIaqv6GPoLpymWpZqW2Uc1Lt
	 iKzZsIEixpnjNsPxOiXdUU6Q8fZuGW+cnSYdTulKXp3OOg5+6zgokyf1V0KRqu2cqgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SRnWmlPV;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2187606EEA3
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2187606EEA3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SRnWmlPV
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a208d93758so44809935e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713857; x=1794318657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E+XGOdV9Ng43y7QoYPGs0jtHE/NJkGVytBAQnXl0czs=;
        b=SRnWmlPVijWnRSQBmFDg2EefRutv+rs7OGQfkeke1Bw5idKYpctmLywjoS0zFy1dgm
         qpLeSwtCsfyNz/1zfjCDdxT9qkrGabs55fGIEqFKVV4Rp2bc6d1uWU8mpoK3bv/aEWfn
         OgDEi0mXGjslKk/lxMRgTWoHzx1qdnk7OGJCKKe0JQ6nlxWOiza717PitStfQKpXNJeF
         qvoRUlxjgrh2mhe1aXIK8h/rUxMWrYKpI55VjGPtnGK4zluDDpMcC07f4a6RELgXwPRq
         Cycu+39Dxvi+cKdm7bPyN3mLIEuhD+p0+N8WgoUHGwR81j4pKmuOYEI0tOrMo/xsrJ0z
         d7vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713857; x=1794318657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E+XGOdV9Ng43y7QoYPGs0jtHE/NJkGVytBAQnXl0czs=;
        b=r48k66kNoJamu7Z5x+eVYAX/R0IDXzR1TMQNP4N9OYawBVY90AUKq+AIpN9GWZ0QN3
         tXMpauLqtI9IWfkG/xU9YKIiWt1mqBW6cw42fXY8vypOYiXLH5KuJn51BJtpE3NxOqDB
         64nxVIlR0PI59ASqUB/vul3Xi5XNcKgA2VDJ2GYFUU8gXRImw06iChCN/dzrGoJ1Vx2P
         tZAz8EIDYyJIwHPwgJAvX7sOvh1emw6dxZfD69WWg6RSdDGJNTgJgDdqBkFoqdewj9C6
         Ixyu0AooAJkSMZDXzgxN7k2bsM2q99+2QBovRk7C8KjGhR+61zjNxkwdDXlzMI0UVD7l
         d9xA==
X-Gm-Message-State: APuU4Z92h7DutFrNnl/UAU92VZGr3MI3PaQtl16w6V1uoKYYg6r8MKRF
	B5uPhxS6cd4VFuT98rTELDp7xlshBgDKDp5hLWCgJI50zLji6O8LqLBB14+bux2Q+1M=
X-Gm-Gg: AYBFou087QycXdYhVgdixG4Y4onBBqHqUtS8qtOQSiWcf/o2o+O9TO6n0t/tMqeDO6S
	mvP3oj3QX/MclScr/ddYIhxEMjZJBvBg1r818vX9CEtsp53uzrhR6AqfOsdQ5lz14Gw4zysXP3t
	9zM7C9+KW2Z+FBmal+HuXdranz4Vrq/F+oR0hhrxzokuaEEYYrIsnz76udLOb62WQex/ubPP5de
	7Q5RArPSTlt03tN5hdZoiIMx70PwiJ4F7X4U6qRdMHfh9mKU6yHTHYr7oTDAf/FCeDMl7da+yu2
	Whcuy7QgnsLFm9BAWdkqo1tT+1nbO1ePEp752K3ObnVOp12KrXxqR/vYhYcDl5A6OAhhkkqen0t
	UETwUQmXGcj6OnDHFolby9/5dcfL7fLmVJ9+ph/mc+sIAAX/UWAFQTj1vipA4x0DQLmVvqxKbIT
	xLoxB5hxwHkjgHfCrNpWm1pzScsAqN6GMnRqozgsIOCft7umInfsO0xJDfa5c9ZsdYq2xYQl7ui
	RthPl/EsVD9zjyxjNGol4wffpTJxEcy7FC+RFw0ocyccnWeb+ee71QWsLun1G+/iV61pXUM+qGv
	vCif9iAWcdmXDpBlwP724vpCq6pDsFl/dqCh156+eD2y21zvKqBRhZcodA9y
X-Received: by 2002:a05:600c:5397:b0:4a4:4d57:8462 with SMTP id 5b1f17b1804b1-4ac18b7e65bmr297292595e9.24.1793713857136;
        Tue, 03 Nov 2026 05:50:57 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:56 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v4 09/13] mke2fs/tune2fs: add dirdata feature support
Date: Tue,  3 Nov 2026 13:50:33 +0000
Message-ID: <20261103135037.610132-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
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
index 639a84a6..3127ac87 100644
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
index d1d5a9e7..fa7cc83f 100644
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
index cb946b2a..61029689 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -2278,7 +2278,7 @@ _INLINE_ struct ext2_dx_root_info *ext2fs_get_dx_root_info(ext2_filsys fs,
 	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
 
 	/* dx root info is after dotdot entry */
-	de = EXT2_NEXT_DIRENT(de);
+	de = (struct ext2_dir_entry *)((char *)de + EXT2_DIRENT_REC_LEN(de));
 
 	return (struct ext2_dx_root_info *)de;
 }
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index dd8c53d9..2bcb7036 100644
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
index 2d85fb70..7adc5183 100644
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
2.52.0

