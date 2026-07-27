Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA4A36B905
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186816; cv=none; b=cFz6v68p6Al+6SpEFhQMgDouBmJAqIZktr0kRiD+Uctzs+t9Xd932lTwu7eU+HttsjSuD1UlhpOzNFSkXBS+eoA67BuY4DChACAlkLcslTcdyas0Jgi6NvpwEuUiELTewNALJ/HAcf2AvmIXrKF2NuR7wD8q4zol5DraP/Rsk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186816; c=relaxed/simple;
	bh=LAIn6EpYb58ICtK3Is7806tx1nzVEXcSheTY6eo2PZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c9mYKdFQrcacyWPp7hFuH894H6qtUhxMbENmtcKPtaUqDnnXE4uEsoXzeJZJxZJpUbHRBroUSaUk+b7qUVUSmTfNCxWZ0ZsKc5YtVuVYW7+x8n+lXYrfRrpJbwRwaxKu1ToxGwMJ7bNGiXD68QKf1dkwPLhJNp7rIm3YsYA0Na4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkGQEsTU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkGQEsTU"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954aff6088so27173525e9.3
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186813; x=1785791613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zTuK9XZMtc9+1AXSlELi2r8768KOpZcGY7rAXOOeIk=;
        b=QkGQEsTUU5moA5AM+eM2dS+5MhMpFMw/W7Q1tvo4vdSVEx66wvrLRCYmErjJLS8CkG
         3fXUB+WBnjOBp65tDoJjRbXU3ogK/Hr3Ah9Xt4yCaPHi5JxLzJ4MInDiKF2E3z4fhDP9
         HhToCMFQSNj8DJ2rzS14CSv3uMDr9yn3eFT0ROIQVzpTnD6MpyxMtTZ7HWMlw9twRjUL
         MKXAVYKiLY/uqyTqYOPnN1xO1GsgXx+Bjs+dOK0TQE2dcgwWaX+1f1l4Bp8L/K/WkZqu
         jJa/B+2NB4wQ2AmgHYEjepv+XEVOhPLQf4DmkoFaa5/ZxU75yAq0xZdDiVL9kYMeSPIS
         xOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186813; x=1785791613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7zTuK9XZMtc9+1AXSlELi2r8768KOpZcGY7rAXOOeIk=;
        b=Rpou9ZmdFwwDt7xiLBeTfWmEX+ht+nS8piz4x/tHJfdwiEIvz1Qk74Sn6OgirlmcdK
         OeT59XTQVfgQDK8c8Fl7+D6Hpvj/tPTTS9/QE2tEWuwZJ8i/a2NvNPXdwJHWeGg8wRJR
         QCBc4nAOMe58sR87KhEVIVqcfN0GWabkmnchVyD3/3fJ6XU99O67tbgDggGv9dm8fUfp
         GXp2ZO8i5OjqGMDf05PNar5a80Bf0S+4cf9wpIzsQ2go1T2L0Yzh6zvkJN2zxZHOmyCO
         QxyHpuedcS+YgbBkVhk36J7eSU6C9Mfc5jhRDtGp83YxznYIGkB1rEURHNLADF9r7VMP
         BtPg==
X-Gm-Message-State: AOJu0YyoU73gxGp9YLWFp4tcwQozJvVTfErBu/3QQr4fQhrcD7mxtafy
	elTbNDoDknYjO3JQNsEAY87gD5HpAYYRecwS6kVUexVdo8XLLhp7rEg2stTdvrTA
X-Gm-Gg: AR+sD13byeiqtumFXjzjt8i0gMxnZZM3vYWwSzVoZ8xZ/OXwou5v4ZV4fc1djPVMUO+
	0Ptk9NO1vy8D3zFMRNCOtOihtwc3vMn55Saf7wU/b2ye5ISQCM6rarBPLC9D8fMDmRlhaYcKcE8
	tJvdSWflN30gNDoHB+Jwuh6yir/9FkEGhgSJWN5U6iDgAcplG0dvyXhb8TLOD0dyDyfLYcgOE1A
	Kn1lP1iprbrGg5sLuvTL5JKzH40DEz3UgLqhSsx/ukM0F2VTLxumJYmMl6lXBDM0PlsX7fGYaGr
	oK2lcYYdTds23UEzsMtkyKCwq5USO8UtvoEzy8sbVfBKYDheb4DxsjEDBc6HFcjlSlFlztD4Cr8
	/iVj6iRanEBsmDPeNlyKSVVje3jhfhCArEckrhUzMQ3Vm4MjImLTdF0DTmkZX81i3UhQ0JkT4P/
	5EFKK1moCV19JEiz9YNtlzxhxEeR2d+4JK3g==
X-Received: by 2002:a05:600c:56c5:b0:495:401d:9f4f with SMTP id 5b1f17b1804b1-496c4fce758mr4722725e9.25.1785186812761;
        Mon, 27 Jul 2026 14:13:32 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:32 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 04/13] libext2fs: add helper for dx_root_info lookup
Date: Mon, 27 Jul 2026 17:13:13 -0400
Message-ID: <20260727211322.19686-5-ablagodarenko@thelustrecollective.com>
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

Add dirdata support infrastructure in the new lfsck.h header, with
data structures (lu_fid, ext4_dirent_data_header, ext4_dirent_hash)
related to dirdata fields.

Also changes to ext2_fs.h and ext2fs.h to support INCOMPAT_DIRDATA.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/htree.c     |  2 +-
 e2fsck/pass1.c      |  2 +-
 e2fsck/pass2.c      |  7 +++----
 lib/ext2fs/ext2fs.h | 19 +++++++++++++++++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4ea8f30b3..efb858271 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -298,7 +298,7 @@ void do_htree_dump(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		goto errout;
 	}
 
-	rootnode = (struct ext2_dx_root_info *) (buf + 24);
+	rootnode = ext2fs_get_dx_root_info(current_fs, buf);
 
 	fprintf(pager, "Root node dump:\n");
 	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 39d1255f9..12925ce2f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2801,7 +2801,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 		return 1;
 
 	/* XXX should check that beginning matches a directory */
-	root = (struct ext2_dx_root_info *) (block_buf + 24);
+	root = ext2fs_get_dx_root_info(fs, block_buf);
 
 	if ((root->reserved_zero || root->info_length < 8) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 319e7e0e3..cf1678c85 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -650,7 +650,7 @@ static void parse_int_node(ext2_filsys fs,
 	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
-		root = (struct ext2_dx_root_info *) (block_buf + 24);
+		root = ext2fs_get_dx_root_info(fs, block_buf);
 
 #ifdef DX_DEBUG
 		printf("Root node dump:\n");
@@ -677,8 +677,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	}
-
-	limit = (struct ext2_dx_countlimit *) ent;
+	limit = (struct ext2_dx_countlimit *)ent;
 
 #ifdef DX_DEBUG
 	printf("Number of entries (count): %d\n",
@@ -1236,7 +1235,7 @@ inline_read_fail:
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
-			root = (struct ext2_dx_root_info *) (buf + 24);
+			root = ext2fs_get_dx_root_info(fs, buf);
 			dx_db->type = DX_DIRBLOCK_ROOT;
 			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 91d269865..cf12716e3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -2262,6 +2262,25 @@ _INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
 						sizeof(struct ext2_dx_entry));
 }
 
+_INLINE_ struct ext2_dx_root_info *ext2fs_get_dx_root_info(ext2_filsys fs,
+							 char *buf)
+{
+	struct ext2_dir_entry *de = (struct ext2_dir_entry *)buf;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return (struct ext2_dx_root_info *)(buf +
+						    EXT2_DIR_NAME_LEN(1) +
+						    EXT2_DIR_NAME_LEN(2));
+
+	/* get dotdot first */
+	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
+
+	/* dx root info is after dotdot entry */
+	de = EXT2_NEXT_DIRENT(de);
+
+	return (struct ext2_dx_root_info *)de;
+}
+
 /*
  * log base 2, rounded down
  */
-- 
2.43.7

