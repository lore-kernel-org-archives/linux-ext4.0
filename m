Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792857923;
	b=J8NjpnFllLtbJ+f+O140hHFZc5SLy2Cdw86jseeQ9yjfqp46kdIbEBQvMnZdslLVcJF2
	 5+QZYcOxsDA8FPGnkrKz+LgU47xLa4IRhdlk+D7aZCr84k7XoeuWD4sCk1ttvBOhoCPcl
	 /kzO9S5axLstUTvH4psBb9Bzn4c9U7Q9aK8UeS8YJKirg8VxiLnvdBBVyLH3xtA2z+GnC
	 SbsefNwm7xGS+mEELc71OmDRvnpPwg16KDgAJxQTgsPxWMapfE68kN3n8RlD1PKHkcF4L
	 bAkcO/YdGgP473JbPFXBSLrmqguzrxWq8IgqxYRJdPZDIPgyo97dvTXF78ugLoRjfEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792857923;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=PmyL8FnvFWmfO8vCVEIvFSqwZV9Ld3MINRaVhnd4Q4U=;
	b=b2//0+FaDDSSySWYDQdNuF34sOFgh3O5PysoxKXXSZlKKRNl3eXUFGkqMTteNXyVzFS1
	 d+SgRoWR9Abh8JAHBeKY/5ecy6kMP6OVxwn5VaxgLC2F0kLtjUcm6VpgXGnkK8yI5SLmp
	 VS4SSikH+bo+AotnN+aeeZyGUPwu0P82HG6xRN9JjjJWVXg8ia/zjbBBfV3SdbKuj25jD
	 RH9obbqg6lHLd11v1n0z/D/FBiffvZLr9+nYnCpWRB0zjtjefTi8bI04or+MgJHc38pn7
	 AIpKowmONFrzd1OlSpwbUfB4iIeZLxkC0Vn6NPx8/o7heHzaHY3wHLleuUBovlnAM6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=czerner.cz;
	spf=pass smtp.mailfrom=czerner.cz;
	dkim=pass header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=pyCIrv8o;
	arc=none smtp.remote-ip=79.135.106.111
Received: from mail-106111.protonmail.ch (mail-106111.protonmail.ch [79.135.106.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C283606A320
	for <linux-ext4@vger.kernel.org>; Sat, 24 Oct 2026 16:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C283606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=czerner.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=czerner.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=czerner.cz header.i=@czerner.cz header.a=rsa-sha256 header.s=protonmail3 header.b=pyCIrv8o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=czerner.cz;
	s=protonmail3; t=1792857919; x=1793117119;
	bh=PmyL8FnvFWmfO8vCVEIvFSqwZV9Ld3MINRaVhnd4Q4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=pyCIrv8owKqFGLrRxWjQ41mtodKLvx5IWvfCcy7jqPqB8aN+S0dmeKhQUZhXU++AN
	 41iRMQUCFTbm1cddVGJeETiG5vvq5zhENYvMQUE0y3FpJO6GnFZZruBVyn/rRoKCOk
	 3EvVN+soDBX7xQ1HIXe6RNEYbRrCLwjRyAbQLH26kwDD184gpjcSF1BwE4L8o3wHZQ
	 NqUByouHBcOhn1Zr5PQalM7QxRXK7vOSoTIB4SMjOlDhKjn9kMGKImaVHzd73t/ySZ
	 akxeqsar90tRv9MOW9/iCsv4dvhoD578VgvyvSGgaZPH24prMID0z5L1wFy+PhAXf8
	 Wzumcq4Fzou4Q==
X-Pm-Submission-Id: 4jBl8t2NDSz2ScjC
From: Lukas Czerner <lukas@czerner.cz>
To: linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>,
	Lukas Czerner <lukas@czerner.cz>
Subject: [PATCH 3/4] e2fsck: disable resize_inode when too many backups
Date: Sat, 24 Oct 2026 18:04:51 +0200
Message-ID: <20261024160452.1818872-4-lukas@czerner.cz>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261024160452.1818872-1-lukas@czerner.cz>
References: <20261024160452.1818872-1-lukas@czerner.cz>
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

check_resize_inode() requires that every backup sb group has an entry in
the resize inode indirect block, which holds at most fs->blocksize /
sizeof(__u32) entries. On a crafted or corrupted filesystem image with
more backup sb groups than that, the resize inode can never be valid.

Previous fixes prevent OOB read/write, but e2fsck can never succeed in
recreating the resize inode, so the repair never succeeds.

Fix it by checking whether entries can fit into one file system block
and offer to clear the resize_inode feature, clear s_reserved_gdt_blocks
and zero the resize inode.

Signed-off-by: Lukas Czerner <lukas@czerner.cz>
---
 e2fsck/problem.c |  6 ++++++
 e2fsck/problem.h |  3 +++
 e2fsck/super.c   | 27 +++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e433281f..c17f242a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -546,6 +546,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Orphan file (@i %i) size is not multiple of block size. Terminating orphan file recovery.\n"),
 	  PROMPT_NONE, 0 },
 
+	/* More backup-superblock groups than fit in one indirect block */
+	{ PR_0_RESIZE_INODE_TOO_MANY_BACKUPS,
+	  N_("Too many backup superblock groups (%N) to fit in the resize\n"
+	     "@i indirect block. Resize @i should be disabled.  "),
+	  PROMPT_FIX, 0, 0, 0, 0 },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ef15b8c8..4e8a8f43 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -300,6 +300,9 @@ struct problem_context {
 /* Orphan file size isn't multiple of blocks size */
 #define PR_0_ORPHAN_FILE_WRONG_SIZE		0x000055
 
+/* Too many backup-superblock groups to fit the resize inode */
+#define PR_0_RESIZE_INODE_TOO_MANY_BACKUPS	0x000056
+
 /*
  * Pass 1 errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index eb1c7e52..2a5025c3 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -731,6 +731,33 @@ void check_resize_inode(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 
+	/*
+	 * The resize inode must fit backup GDT entries in a single indirect
+	 * block. If it does not, it won't work. Clear it.
+	 */
+	if (ext2fs_has_feature_resize_inode(fs->super) &&
+	    fs->super->s_reserved_gdt_blocks) {
+		dgrp_t three = 1, five = 5, seven = 7, backups = 0;
+
+		while (ext2fs_list_backups(fs, &three, &five, &seven) <
+		       fs->group_desc_count)
+			backups++;
+		if (backups > fs->blocksize / sizeof(__u32)) {
+			pctx.num = backups;
+			if (fix_problem(ctx,
+					PR_0_RESIZE_INODE_TOO_MANY_BACKUPS,
+					&pctx)) {
+				ext2fs_clear_feature_resize_inode(fs->super);
+				fs->super->s_reserved_gdt_blocks = 0;
+				memset(&inode, 0, sizeof(inode));
+				e2fsck_write_inode(ctx, EXT2_RESIZE_INO, &inode,
+						   "clear_resize");
+				ext2fs_mark_super_dirty(fs);
+				goto cleanup;
+			}
+		}
+	}
+
 	if (ext2fs_has_feature_resize_inode(fs->super) &&
 	    ext2fs_has_feature_meta_bg(fs->super) &&
 	    fix_problem(ctx, PR_0_DISABLE_RESIZE_INODE, &pctx)) {
-- 
2.56.0

