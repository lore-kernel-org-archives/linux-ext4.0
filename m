Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B11E36B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186820; cv=none; b=f6VFQqItTWwVd3josy3Oddh1e4OjE3Fs2Z/TSvQ3BGcy3iQgwxp2uKrGdSIhmtXboW+QXzwG3CG4h4w5JV4igGSxee/2uJQFapETvOd0/17Wucc3pUCEZMTqx67enkVFjjooHVKGz6bplq8ofxF2elUYNuEcYGXEFkLQMdiyQhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186820; c=relaxed/simple;
	bh=A5gYj5b0DFnqkldJ4lw66tyk4jmnob3e8uPrc2sxs2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmWDFRUs52JQMb5Tr3AyH6ipiETbGTvpJnK9VM/UCAyFVtKqAjEn7VRweBtePBdHk33j1zLfKhQTkVYlGOnIAGkmWDFeD1gTdo1mlsV/Rrt0iPiULOicdjSTzR1LmnUyY3cOxDUF7UQVQvecWUQFXRQ9jxUIhI5xQb8VFHlsRMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p6Cy/EaS; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p6Cy/EaS"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49550ec592cso2101645e9.0
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186817; x=1785791617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OwaBSP2m4QUEV5LLtIVG6CyFH13L3SJZNhFwlSqDMqI=;
        b=p6Cy/EaSuWiu62xJbxdCi6xnNINujNL9llF+El79mp2po4hCgqnNLAqsSEZRbxN9sJ
         TUo88iX7LHYL+f+l0P3ZZiWWWcPOgF305PbXkEJ1m4su0zeoOBBNeb+i1mQsY0ueMgb/
         QjMilfjPZ6voHO0FbibYvMTnZIcj/CW3JHIqm/LatvaCdpMOLtWKb3pBesMaz7Dp7oOo
         WVx7eF82D9HzUCCVPpqADnl8AjWlGkUKp/d0WgR1Wrwc07HHOsIoDR2q1glqJc2hRpY+
         og66PQeFQYVoZKY/XmwuEjIu56Fxm9Zpt3XB+vCeWi8lMUxnY5Sg33fwSOXG3ay5iMJy
         JlDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186817; x=1785791617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OwaBSP2m4QUEV5LLtIVG6CyFH13L3SJZNhFwlSqDMqI=;
        b=tJMb9JMVyRd6r96NILfJjlXFKSlTTRxKl+BPUoLkwP2VTiXc+1kz8ZadnWLnhc0/ql
         YnF0+zjJIP7OP6RHLYKfIMtJuQvDTQZn23oPuVsSbzbDqACY/iOfU38JTVY1eyWf3RMi
         wjIUNFfbdzVLVLsKDDWDwcu4rSa4C2DRdsYuebDS/ZwydmS5fYH2nbBXV5pO3wfoXc43
         7iMlMB43djM8lD0ACWeySza22kx4Z+NygNr4XXSF6xA0+X3wa9kkABK6KiVrabFBUbAM
         p57hpPEYZVUXNzONX1QwwBki5TwOZ7l4SHHroFAF0iz60IScEMbAMNhvbDPns9+B/BwI
         iHhw==
X-Gm-Message-State: AOJu0YxZVP7f5gvADwwLu89vBt6XDxUsMT6ou+4R6fNJGH4/wB4sETZ2
	XhHDFZpqZDM78HaQ8IZmGQ6C7+WtMCA7TAUVvC6YWyKiylqpaabXatBP/iPAIyEJ
X-Gm-Gg: AR+sD13EUwh7hQFLW1Jl6BqBlTWd2Rxk+wQkdBA0TC0ekip4ZRQHqEzkJrr1qOsh3Kc
	Tl81BfAxXcqE1yscn4Kh8zCg9d8l7SG8T/Xlw1NiaLKmYa29nJyTsW022qO7xjxjuXjrmWlOXhR
	B/X77YsMkZG/v2sOCPn4BBmqR1baPraDD0oncVat1XRdd/ajW6kkEs4Lr3um4bMmnZXyvET/y0i
	9CVnWX3E0B4C2dkRnLYAs0xaIqsM7TEpJIdHQt93/wMa1V+AlP5adz4v9mUa2rnh05eInsF1LNu
	W3dmMLsTQRuMq8eAgeebo92sJD86PfSNSXML9w8JOEqxgzA/1f90S735B7AivQbWhNprX34+oYs
	tLqgK38u7ULSNKjpUWrLxcAsOLzO2IBCOSqkjrDHUGlQaQ+4n9KN6t+oFW9MOMtZZ1t1uvO9+k5
	vmfqYI1jd4cgsVwNzdZauYwvkSKauQUHyrzw==
X-Received: by 2002:a05:600c:4fcf:b0:495:495f:bc30 with SMTP id 5b1f17b1804b1-496c567af3amr3443725e9.12.1785186817546;
        Mon, 27 Jul 2026 14:13:37 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:37 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 09/13] mke2fs/tune2fs: add dirdata feature support
Date: Mon, 27 Jul 2026 17:13:18 -0400
Message-ID: <20260727211322.19686-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
References: <20260727211322.19686-1-ablagodarenko@thelustrecollective.com>
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

