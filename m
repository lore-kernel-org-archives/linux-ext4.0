Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276887;
	b=jeNqJTfHf1Hh7oA60sYw1EaIE1cW0jtWYh/Q2MkAv99iwdlgRU54gkGID/q7fwkWd6tk
	 6SkYrDnP5KKp/Me/AwOPFLJyZiLztZC8Ab9PYYUt6ByA4JdfWCmHWXj1iz8DI9f6kRXBS
	 h3Xd968/ij5s+WDPBvl2CrJd+jQbSdV7rhgdVRkPsOVLxz0qbHQpHKUE40atfxyBpeW7Y
	 ewwVp+Yd/cNjTorNOM2poccPeiaT64wlq3evnCrMjSx2tzG+JWuWENF3TC42XxqF1Cjd+
	 pj8qpqfGfhrz20j9CC1X/xTRv1QmenYOSejiZuE0FREP7LCxmkHMPVJjzKFjcT4ySfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276887;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TEkKpc4ZJqJjA8Cb+RENsMDeLli51ln07ZFydsKdQgE=;
	b=a/9Dtczum7F2/O2AcXJ71oUc4MFJaZJCavNGeId9kFgioytgqlx+SiLsQuqaA96RSWml
	 w5h5PZV2IyWhF3kzQek6oppeBiMj+qmAMx3DLTd3sFSdf8Yl2iIO8WOujW1kLHsHLGvI1
	 iVKsymod13enrb2skNkIz2p8SNlOahMvSlfCES2qZEF4HrPJv/XJG16oxI3QMuOk4QtE2
	 GbvNP8UEI/eA0Gjoq51nL1kGMqeIONsYny0hAJgFCp4JzVS6ILqQX1m24sv8lGqoXL+kV
	 9levMp21PEUMogVbFZP/deeQjPYjhzkehW93hUYNBJz+M5JGns7+P1k9qP2l3j9zB9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=em7GE5Yk;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4515606A321
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4515606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=em7GE5Yk
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e00eee27dso1529216f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276885; x=1793881685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TEkKpc4ZJqJjA8Cb+RENsMDeLli51ln07ZFydsKdQgE=;
        b=em7GE5YkmaaZCMA9Kj96mq1VMVincR29waZ+t8B8q6JPvVNCTPp6FP0dh7ktC38A+i
         UxCy9N2ZMC6QasZzwCT1DCQl6fmykH3ok2Q3q10bxSFPVfsS9byFYhZRS9hJuD+3mnqk
         Oht/dWlpK4+E3PS6EQ/WFpakvvuB0eC79t70FH41OOwOVSu2lnTVMD7sumhzUu1RKS3E
         nBMqBSEEXt+7r/1qdg6XEYRYLwYJiq46q8bNoLBCVj/5AsNWVtyB9fz2AU/AdgMwU5Nv
         H6xg9voGNcEczXM6DaCAqbrcW6CCgXYjsgm377nY8CSSFXTMJb033EdA8xHDJt+WHdwq
         lPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276885; x=1793881685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TEkKpc4ZJqJjA8Cb+RENsMDeLli51ln07ZFydsKdQgE=;
        b=RgYUzuFc0osO1DqPxX7g1YDtgbRiZI0cATLXYNBYgYMD/QuYL+le/4PmzbQCP8dAcQ
         Kb5uYgXVJ2dG7tt86GwHttgP4U46ytCgGgLKjcTphT7u9Og2GrvIiUOaLflxsFK8pCaB
         mb12RWOltQLSlpETRNiLczZmt3CbHe28Uet/aIrlfF3ITdOJpwXIDxHW0br1vzohr7YH
         ryVSuBtWllEu36qqZOEyRBHI+/7/5kk6ixjph7XmM960u4TDDRN6AeldTBKYPZhLFPPj
         vYYJhgBM9spF7yF5c80s1VekPs372+Sm17U7y6eAtMtqkl+5+8kiQTC0rIDpmbT3NK2N
         dyEA==
X-Gm-Message-State: AFq9FYLqrhgjZr4V45e5WIAy1xmHJJjoB04swqDjXXflsz8eb0m+ygT4
	z5wpvfAJMsQS04M9KHKCa59lPCJDXLuODkFPtTkOFOecJ0KFQxV2nL2u767+67gp
X-Gm-Gg: AYBFou3cYYEEH1i1FOZUAVNSSuDar2dAHs1RewvIaldBSh7VmIPtaihPlHyo3J9G2Rx
	ypjoEmaWASc+Bg73/YWdadqx8nPpa7iXAkAiYrYtjJgVYaocPiAfwz6m/fluHPANFvJvnnOwlP+
	oD3w22WEZjuuK9JY0B74bxpyBMIO7shcR+8q8neTjYnlTmnV2Zxv8RFPq8S1/+DW1fqR0di4V8e
	N+oRA+a+nZSoLVkr3ryCvbvIceHrHkK6szLso5MqR7mXY41IUYl3oIwT78xGcWFqoIXv3wfLQEN
	HummmgmpVK2/nwxuP/Fx8OhO9Qvox6s//0DK70FwDAolULzVnPiOi3PBu94eozs9h6vqlfYI3a9
	tM/Ps47j7hVmnImr3Q33c+WMlDn26/KAPAzL/mwaW+yCd62rUoNZhqBNZoH3U30N5Q0Krz+7Wo5
	hBwPp83VL1rxhpZMUTIE9TkJIqNLGciSOY2uGE/VUrtrfMDm81epm2QWbmXsrZCW0CdCInSankl
	YV79gftMX61Nwum1w+haV8OK4UFNEkxiwznWjzg1vgstWTpwMKh7Gsa3nFSAmLI91TALDOk3uv9
	LGqYaQsxugvhpQ2UD11rWT/aQEWqKhE+Vwq4ekdP6I7po8rYfWWGJn7SWz0c
X-Received: by 2002:a05:600c:3e0a:b0:4a0:1c0e:b057 with SMTP id 5b1f17b1804b1-4a9640f1fbdmr124072415e9.4.1793276884961;
        Thu, 29 Oct 2026 05:28:04 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:04 -0700 (PDT)
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
Subject: [PATCH v3 09/13] mke2fs/tune2fs: add dirdata feature support
Date: Thu, 29 Oct 2026 12:27:40 +0000
Message-ID: <20261029122744.230678-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
References: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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
index 938942a8..9a0f6f77 100644
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
index cf12716e..b14ba0a3 100644
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

