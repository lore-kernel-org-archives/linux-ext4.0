Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A43F330328
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655051; cv=none; b=ON27C58auUkB3zHdtsw2/iu5gMfUijk8VwNI0cAEUYqGkTh8xnT53O2H0pJr4yLF4u61yIXgWzZaMTYC5nLkNpwH7kcwm0dHSv0nMOrWc+zBmIN9nROOEdiZeA7h9/RSD+auMHVNs4HO8w0hKKFUrFRSE3cQaketdRbZm1ZJbr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655051; c=relaxed/simple;
	bh=WSSAuSMuoMZ7r1EelhfSt1PMtHOVgGxhYzrKQnh7vsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPX7JR+y95ohA38LQ2SD3iSXZjWVYhj6oABOvsis5JDSKEgLBD2G3sJMzk6Fs6EEGEqFE/Olv81aVfsXax+XeELOJXu+35RsCpViF873J1PN8UJNM2icMzzDnEKdp6j6qtqq4bqMewvnRJHzlijrw/p73vsEYM0S/QO6CH3gcvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IGKUllbk; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IGKUllbk"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49068493267so54245e9.1
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655048; x=1780259848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylt4CaQ9IEidvZAKlReCi87S3p+cBM1XsALjotXwyco=;
        b=IGKUllbk19R6ZRyyjf9eDYrXN0rrZ2rmnCuBPmURqu67l9idzfZ1TM1XmwXoEzUGoo
         e8jsfHuNf55hyKjBsrNC74DLa0BSLAKwCCwayS05aOEkk4M1a7HMEAdxXPT52q68B0w9
         00mq3ONI4eF8vNYWCP7hYzhlOd3mg74S3+DHJ2haNfHXQYZbfVGor2GqKmwE95ey/C0G
         SJz74Kq7aqZn3oN9pM5hsydpU3eXhploOxLoQSPytK6FxC0St3Rd2pV9B9YqkNmFQnlP
         T3KUyDwhcK1u6jWhbFTrM1aF8Ypl7Nn/PxkKCpA/cx/H+X34tzlXOPUk6hcOpjj5CLCF
         y7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655048; x=1780259848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ylt4CaQ9IEidvZAKlReCi87S3p+cBM1XsALjotXwyco=;
        b=C0ouvMowDx90OrYyjSzyW7V8yyY8K2cExqeaWj58ZTYmB9ebhtFZEnbsNjSAsHTjUt
         uwS+hJma5TuyOwzmSW7oLvbWCllb9dzxrcg/Nt5xGtFd529CpsAJu5RxOmoi55i1D+CL
         SNkbquQ21gGUBf7N6vy8qVzB/rkcGmhL42dpygdMC7fogb2SCpNp1MD02xKxU5sItfSE
         L479YPlt8NJ9QUzYA0Q9M3Yy7D01HV29PidLcvZBhyhfZXMUk2BruY5hHVi+KS4DEHBR
         JlTsjb3xJlz7vPydT4P5ljxiB5bJ+iWbgRDiHLfg7+Cw/ZaLnG2GqOZdzHsKKijRQlJb
         X0OQ==
X-Gm-Message-State: AOJu0Ywi4X37TLNfZsYL4TZyRPyvKSWA7jbMBEMMEGY9l/8urJT3aHBG
	7OpHv8MyuHIG1oj1nDWzkf6e+9jkVh/A6xFOTSxGUUlqh2VK0qanjUHa4lerCw==
X-Gm-Gg: Acq92OHZ6NZKADcInWEQDdV708Z3WmQKKKe3CXCaSgiYtY5943k5ZRE89gaU4c5aA1g
	4vg7jZn8QGQQ/ssJOdsd1eOKsbUl36FKil8OzS9w6g3yTKCyLG7jIe9Y5vgHD6W3U3uDebSc8IK
	c5Lr2pNB8Mqh11Ht554PBpGA71NmdXRCbGWQYetpCKopzaesecBU8W0a7Nds9VUlI/SPSCoqHxp
	AV27aw3KC8JoVv/gvfKAdnsc5BoPFgg14fOFf3fo4ZhCXivD2qT+60joVPtyIYh6cVB0h77KcWh
	ghQb3NwrsuIbt5mhF0DCfIz4Uk+/feoxAA5kp8vnpMSu109RPbD7QJR7MzrOYfvAMq4pdPfN9hQ
	JCCf9tuQiOeWeJGXDOri78jz/sU9BfatS5ebBYH2Uk2Y+I/oGfxx3jFa1Q8NoSyASgRlPcRtQU/
	sDok85YvhWKvM/JSm5GIYE2dJEd1i0FqDWChnSvgWMBkCDkSgA/m0=
X-Received: by 2002:a05:600c:8285:b0:490:601f:d766 with SMTP id 5b1f17b1804b1-490601fd959mr52647765e9.1.1779655048461;
        Sun, 24 May 2026 13:37:28 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:28 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 04/13] libext2fs: add helper for dx_root_info lookup
Date: Sun, 24 May 2026 16:36:49 -0400
Message-ID: <20260524203658.12406-5-artem.blagodarenko@gmail.com>
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

