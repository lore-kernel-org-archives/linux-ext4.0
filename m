Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3458A5111A5
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472975; cv=none; b=d0k3OEwWtKRjOnP8q6BDxqvQHbuPa5QdQ2IHXeHg20WZaBTGKZfc/FnFms6shrN1glDXlW6d1CWLyjmVM+p/7S/QPe9tsCZmhq2Ky+Qpvd1KDrtMvk1YE9xr/hbbqB3FkFJg8UOTl7XERLUDguV3nwvSkWfXPpSTCMCkF7TwgHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472975; c=relaxed/simple;
	bh=A5gYj5b0DFnqkldJ4lw66tyk4jmnob3e8uPrc2sxs2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAgMW2gdNtkPoDDf8+6tmbSRUB6uEjMsmpPhPFtT9PlQGJH24Sp8CqwwlwxftSClyV/0b8dXQzX8rJUCn4TiuBlb5+IWlfBW42rTSZSeDfkzRuZogxO14Xa3EjDmmZCDowxL5vxFxa4QM+rzi9NC7lFr7qMBh+/EFWO4Vtb7nFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H4aAKr2u; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4aAKr2u"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b0dd3c9a0so3244005e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472972; x=1789077772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OwaBSP2m4QUEV5LLtIVG6CyFH13L3SJZNhFwlSqDMqI=;
        b=H4aAKr2u8X3MMLrPY33gKwvrWYp4wWdvwzNiCQP27oRgv5JJvtuDLoT5iCCyBPyXJf
         XXXFi97ir8lXDjCrVvnDpsudAixwU4KglLW2Gr86QuJzCfKTdcK/R/vlcqNfcYQHBQtO
         Iqrxa6awfLC0NJKygUZjOwtaDmsBM/WrtZ58C4UDwFJGnWh/8F2kYXomewcQBx5zl3ud
         qFcgUgxc6AZhkY53g9DBCJ1F0QnjzO5tkRxyHYck8cSV7VgoL5EYUkct5lQAENeIyQzU
         c1geQEY2y1wnvyCol8QfCSCJIuyjoByK2Ftt4484RXlbKq62k7rOWRnvpXvIsWH8qHr6
         geyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472972; x=1789077772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OwaBSP2m4QUEV5LLtIVG6CyFH13L3SJZNhFwlSqDMqI=;
        b=bdS/kU0Gm0HCsi7wcQL/9TI8dciogdE89uFB98RoIau+EJv+kqrq23SqtxU6EAV/m1
         39cx06CkYp9g58ducTgj0eesvnXsfWhY/rOfwSKFPEcWlgZQ15MX5VV/y997ksgKlMst
         GLZebE/I4O57YyK8/AwSP1NTczEYRLrTYq+k/dsdpvpEhSKJW7cCosl64b0xcswieXll
         8Q72JFrJ9G+QPOBExLtUnsIw38jHC0vElKzWRgxIszey6r7xh8/8FN6VgQTgYvGCdo+q
         JWa5gbyYsiM/PjclFu1uBannK/LPtPdJKRAn4AC9Dx8RdTxiGSenb13oxFgfcpHaOmIt
         jliA==
X-Gm-Message-State: AFuF++lnVu/fhGHhMTWkhTMNMIJHJ5mrLp7VUdzsbfN3HTOWjAJHj0YA
	Mh2IrpMLpXRBY55yhvjf6Ge9T1fV3s/4TpZxVC1IT4m24zTw8ulQ78voYvAMkzPA
X-Gm-Gg: AYBFou0rGYr5OSsTnCNxzo7wpO3R/pgkzIO6seTGbTe9QjzbbmH5rKWB18eZt2jSWNA
	ba3BSrwnYv6Pc2US91IoyaROJG6poUqNXuOJPbnozPpxrVf5TF/S986z8gRyzw16atXtOt9JPQL
	EDWkVqAvdv9XyNFruUjDwTjm1B3G72shY0wo/itQJVYaYpXTChhwAjK0Vi711vZYjQmX9tAtmG8
	TmNbW5EJCKjDQRZrTzjVip0YEREEQ002HbNtFH8Jb0rkw51MY/tk9zQ/DcbmwUQ6FgMogrqXF2v
	eLnsxnPuIaKKNYu1dbmol6me/WIPr8xMTyd0y21wd6XtYjWbNbuU/z2xrAahab3JKlobakycBBi
	ey1ogHNSoknoo7x8Bdpu+PvvTj4DZrt5KhDCV3OumtRCJCHNAbupxf4QZGJzX5ODY3Nap0hcxTD
	jkLZuuwGIIn80g6MSse1h0KcPtkyuGk648QmCbN2Ts8mIhCjO9GjrYk445pzgltO8SEHj8C52GX
	oMugqBZqCJEROWRWpdu
X-Received: by 2002:a05:600c:468b:b0:49b:9105:cdaf with SMTP id 5b1f17b1804b1-49cf8214eaemr11257535e9.8.1788472972231;
        Thu, 03 Sep 2026 15:02:52 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:51 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 09/13] mke2fs/tune2fs: add dirdata feature support
Date: Thu,  3 Sep 2026 18:01:42 -0400
Message-ID: <20260903220146.19752-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
References: <20260903220146.19752-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
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

