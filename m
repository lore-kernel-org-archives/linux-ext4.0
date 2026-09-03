Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34D5111A5
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472973; cv=none; b=ZK+ugtiMw2+FroGbPQGOoeair7GghTcPH2x6Fxm5YnAiGGb6vI7vNKggLz5sXmucpyIhtA40mVXio3AbDQF9s0wjRZnALufp5A+aqYjYXk1YxBly+QRDgmvhyKA1nN9zB1OWRz8N/I6+tMg08Rv7vbCYB0u0bpp7xyUP94xOHFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472973; c=relaxed/simple;
	bh=Z87LTJCyd6EC2A6iHca4HpH2Y3oExMJ57byWWabYPlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjBJl9iAmOiqWHNMV/8mx2++IUPqLfYinEpiWREoP1f3KbKRfpdwi/I3lvQcEiZAx0otCZmNlcBl0qkIa+KDDobeMfJ71wbZpF45SU4d50+8Zn/+aWwcydqvmhHqlMHzKRO7kAjZWnjM2imDRwjVB8/AnNJEHKo9TXBfWBpS+DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n4SozTb5; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n4SozTb5"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49954b88fffso2826335e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472969; x=1789077769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q55Cb/VKiChIsM2LN+gj/6NAee4TzRp8DGk3nhPEKqU=;
        b=n4SozTb58HxYYbyj3R8PX0+IT/kVz0WlC4jKRs9yfjFe1I60Tzc6+3OSto5Yi0xlR2
         8YDOLOBHrvd2kDtibgp134PZkYWlSnwCWHaRHjFYzeSdWvd87LLKzOW4AgRB8rAoUM8g
         hCHKjj9w+Z9LUEonUskA5t56KzVKVgOXd4Ne6PikajSfOVQl+5rMyLb30kxCMUdc5FCZ
         c0XOOW5g0Hv4Ekhc4aGvHZ5la2T/eoR41xkwbLl2N35PAtYgOvZWWr597tZpuo2FZZoa
         u7GwzGsorpW9jcqmMfKTkDTEGgAZjGwNQwfS9PX/IzYDhrWNjtUg2BY5UpezalfYxo0a
         n3ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472969; x=1789077769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q55Cb/VKiChIsM2LN+gj/6NAee4TzRp8DGk3nhPEKqU=;
        b=oOn144xPytN8MSqBxMgjTT/s8lgGsfxCA2A8sdNqgyV09T85H0Z0ZRXB+DS7OaDt8i
         rL1quEYtDeiSaWsJ3PQwbTWIK4pmEna+MUAFGhkxn9YwwTTWpj3xum+zSolrySLSVw75
         r/8CiFGYwQergHpZ7r2gebWrvmaUKWlZpgJpJP4MsG/qLWCIFcuoZ7rvI9dm0UMcP2V6
         S1DRvec4rKsWp9IW4FDldkadSUB26dT54W5r7vJBu6B77dcGhBR+iWnXWTslV6zG5sd9
         KkWYMAoPIDdwXwfhAackBNsK1uD2bmRRaO1EAzPbvDsF2Dh0F6jbH7cKhlVcOBfwYJAI
         qRJg==
X-Gm-Message-State: AFuF++kDi1W9PcrV1jkFkeu7QtBuRmnAKHRyvlo1MDgPheXKsnl1NiLg
	grwA2VITVPI5ZZHe+r6Px0KduDIhSlCDKHbMDEWU9vZAXqj/g/qRffWNL7iYFdBJ
X-Gm-Gg: AYBFou3j9VwthZJKEXX21xDoEnR49DvLcJTmP/a3KGtB5KNMjCj6RbZXnmUpz9rNOBC
	nTv0LUueruMGd/55mRC4liCOxP8+w7BX1WzKxyNjnlW17OJSFxcIkZObyMp0aBeo7sKm4bR5KRG
	+PnumzG+P7SgMIZIJ9W+74k6Cf24pyf05N/pCRqN84kCN3BV8IAGPhKX/XgPlEyqt664OCKv/AI
	4G0IPEAMRFKw8+3IfkfsOIUWTSOrfhERsddPBQZVLQnBZzKbuhxBZ/Ep3xrukWyaLmvpxZpCytG
	9VG+8/QDJLEJH0RjHUuBouRYLXpdvEv0gwyA59V20ypNTt81vHZW76PZbGjo95FIDu1SQnusjFd
	uVGAik1WLnBLyvzx7DHrbwp0XV0SM0Q46HARMLkh9PDRGD2GwTK49E8nErsfX/aNFY9AJg5c8kH
	zznJM6knM0grwev7n10WZCIvS8sfGNNGcI0S6eiTq3RbM6ssrY4LllITQqE+KL+NGp8TufQYEql
	53z0F1FRekUOh7NKBv6
X-Received: by 2002:a05:600c:4e46:b0:49b:910c:7703 with SMTP id 5b1f17b1804b1-49cf823f160mr18113045e9.9.1788472969537;
        Thu, 03 Sep 2026 15:02:49 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:49 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 05/13] e2fsck: pass2 dirdata validation and repair
Date: Thu,  3 Sep 2026 18:01:38 -0400
Message-ID: <20260903220146.19752-6-ablagodarenko@thelustrecollective.com>
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

Implement comprehensive validation and repair logic for dirdata fields in
pass 2 of e2fsck. This ensures directory entries with embedded Lustre FID
data are properly checked and corrected.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/pass2.c   | 130 ++++++++++++++++++++++++++++++++++++++++++-----
 e2fsck/problem.c |   5 ++
 e2fsck/problem.h |   3 ++
 3 files changed, 125 insertions(+), 13 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index cf1678c85..938942a80 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -395,13 +395,103 @@ static EXT2_QSORT_TYPE special_dir_block_cmp(const void *a, const void *b)
 	return (int) (db_a->blockcnt - db_b->blockcnt);
 }
 
+void ext2_fix_dirent_dirdata(struct ext2_dir_entry *de)
+{
+	__u16 file_type = de->name_len & (EXT2_FT_MASK << 8);
+	__u8 de_flags = (de->name_len >> 8) & ~EXT2_FT_MASK;
+	__u8 name_len = de->name_len & EXT2_NAME_LEN;
+	__u8 new_flag = 0;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		__u8 flags = new_flag | (1 << i) << 4;
+
+		/* new_flag is accumulating flags that are set in de_flags
+		 * and still fit inside rec_len. ext2_get_dirent_dirdata_size()
+		 * returns the size of all the dirdata entries in flags, and
+		 * chops off any that are beyond rec_len.
+		 */
+		if ((de_flags & flags) == flags) {
+			int dirdatalen = ext2_get_dirdata_field_size(de,flags);
+			int rlen = EXT2_DIR_NAME_LEN(name_len + 1 +
+						     dirdatalen);
+
+			if (rlen > de->rec_len)
+				break;
+
+			new_flag |= flags;
+		}
+	}
+
+	de->name_len = name_len | file_type | (new_flag << 8);
+}
+
+/*
+ * check for dirent data in ext4 dirent.
+ * return 0 if dirent data is ok.
+ * return 1 if dirent data does not exist.
+ * return 2 if dirent was modified due to error.
+ */
+int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry *de,
+			     unsigned int offset, struct problem_context *pctx)
+{
+	if (!(ctx->fs->super->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
+		if ((de->name_len >> 8) & ~EXT2_FT_MASK) {
+			/* clear dirent extra data flags. */
+			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+				de->name_len &= (EXT2_FT_MASK << 8) |
+						EXT2_NAME_LEN;
+				return 2;
+			}
+		}
+		return 1;
+	}
+
+	if (!((de->name_len >> 8) & ~EXT2_FT_MASK))
+		return 1;
+
+	if (de->rec_len >= EXT2_DIRENT_REC_LEN(de) ||
+	    de->rec_len + offset == EXT2_BLOCK_SIZE(ctx->fs->super)) {
+		int lufid_size, cshash_size;
+
+		lufid_size = ext2_get_dirdata_field_size(de,
+						 EXT2_DIRENT_LUFID);
+
+		if (lufid_size != 0 && lufid_size %
+		    EXT2_DIRENT_LUFID_SIZE != 1) /* size byte */
+			goto fix;
+
+		cshash_size = ext2_get_dirdata_field_size(de,
+						 EXT2_DIRENT_CFHASH);
+
+		if (cshash_size != 0 && cshash_size !=
+		     sizeof(struct ext2_dir_entry_hash) + 1) /* size byte */
+			goto fix;
+
+		return 0;
+	}
+
+fix:
+	/* just clear dirent data flags for now */
+	if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+		ext2_fix_dirent_dirdata(de);
+		if (ext2_get_dirdata_field_size(de,
+						 EXT2_DIRENT_LUFID) %
+		    EXT2_DIRENT_LUFID_SIZE != 1)
+			de->name_len &= ~(EXT2_DIRENT_LUFID << 8);
+
+		return 2;
+	}
+	return 1;
+}
 
 /*
  * Make sure the first entry in the directory is '.', and that the
  * directory entry is sane.
  */
 static int check_dot(e2fsck_t ctx,
-		     struct ext2_dir_entry *dirent,
+		     struct ext2_dir_entry *dirent, unsigned int offset,
 		     ext2_ino_t ino, struct problem_context *pctx)
 {
 	struct ext2_dir_entry *nextdir;
@@ -410,6 +500,7 @@ static int check_dot(e2fsck_t ctx,
 	int		created = 0;
 	problem_t	problem = 0;
 	int		ftype = EXT2_FT_DIR;
+	int		dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
@@ -419,12 +510,14 @@ static int check_dot(e2fsck_t ctx,
 	else if (dirent->name[1] != '\0')
 		problem = PR_2_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
+
 	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (problem) {
 		if (!ext2fs_has_feature_filetype(ctx->fs->super))
 			ftype = EXT2_FT_UNKNOWN;
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (rec_len < 12 && dir_data_error)
 				rec_len = dirent->rec_len = 12;
 			dirent->inode = ino;
 			ext2fs_dirent_set_name_len(dirent, 1);
@@ -443,7 +536,7 @@ static int check_dot(e2fsck_t ctx,
 	}
 	if (rec_len > 12) {
 		new_len = rec_len - 12;
-		if (new_len > 12) {
+		if (new_len > 12 && dir_data_error) {
 			if (created ||
 			    fix_problem(ctx, PR_2_SPLIT_DOT, pctx)) {
 				nextdir = (struct ext2_dir_entry *)
@@ -480,12 +573,13 @@ static int check_dot(e2fsck_t ctx,
  * here; this gets done in pass 3.
  */
 static int check_dotdot(e2fsck_t ctx,
-			struct ext2_dir_entry *dirent,
+			struct ext2_dir_entry *dirent, unsigned int offset,
 			ext2_ino_t ino, struct problem_context *pctx)
 {
 	problem_t	problem = 0;
 	unsigned int	rec_len;
 	int		ftype = EXT2_FT_DIR;
+	int		dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT_DOT;
@@ -496,12 +590,14 @@ static int check_dotdot(e2fsck_t ctx,
 	else if (dirent->name[2] != '\0')
 		problem = PR_2_DOT_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx, dirent, offset, pctx);
+
 	(void) ext2fs_get_rec_len(ctx->fs, dirent, &rec_len);
 	if (problem) {
 		if (!ext2fs_has_feature_filetype(ctx->fs->super))
 			ftype = EXT2_FT_UNKNOWN;
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (rec_len < 12 && dir_data_error)
 				dirent->rec_len = 12;
 			/*
 			 * Note: we don't have the parent inode just
@@ -597,6 +693,12 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 	int	filetype = ext2fs_dirent_file_type(dirent);
 	int	should_be = EXT2_FT_UNKNOWN;
 	struct ext2_inode	inode;
+	__u8    dirdata = 0;
+
+	if (ext2fs_has_feature_dirdata(ctx->fs->super)) {
+		dirdata = filetype & ~EXT2_FT_MASK;
+		filetype = filetype & EXT2_FT_MASK;
+	}
 
 	if (!ext2fs_has_feature_filetype(ctx->fs->super)) {
 		if (filetype == 0 ||
@@ -627,8 +729,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 	if (fix_problem(ctx, filetype ? PR_2_BAD_FILETYPE : PR_2_SET_FILETYPE,
 			pctx) == 0)
 		return 0;
-
-	ext2fs_dirent_set_file_type(dirent, should_be);
+	ext2fs_dirent_set_file_type(dirent, should_be | dirdata);
 	return 1;
 }
 
@@ -660,8 +761,8 @@ static void parse_int_node(ext2_filsys fs,
 		printf("\t Indirect levels: %u\n", root->indirect_levels);
 		printf("\t Flags: %x\n", root->unused_flags);
 #endif
-
-		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
+		ent = (struct ext2_dx_entry *)((char *)root +
+					       root->info_length);
 
 		if (failed_csum &&
 		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
@@ -669,7 +770,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	} else {
-		ent = (struct ext2_dx_entry *) (block_buf+8);
+		ent = (struct ext2_dx_entry *)(block_buf + 8);
 
 		if (failed_csum &&
 		    (e2fsck_dir_will_be_rehashed(cd->ctx, cd->pctx.ino) ||
@@ -851,7 +952,6 @@ static void salvage_directory(ext2_filsys fs,
 	}
 }
 
-#define NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
 static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 {
 	struct ext2_dir_entry *d;
@@ -1427,10 +1527,10 @@ skip_checksum:
 		}
 
 		if (dot_state == 0) {
-			if (check_dot(ctx, dirent, ino, &cd->pctx))
+			if (check_dot(ctx, dirent, offset, ino, &cd->pctx))
 				dir_modified++;
 		} else if (dot_state == 1) {
-			ret = check_dotdot(ctx, dirent, ino, &cd->pctx);
+			ret = check_dotdot(ctx, dirent, offset, ino, &cd->pctx);
 			if (ret < 0)
 				goto abort_free_dict;
 			if (ret)
@@ -1446,6 +1546,10 @@ skip_checksum:
 		if (!dirent->inode)
 			goto next;
 
+		ret = e2fsck_check_dirent_data(ctx, dirent, offset, &cd->pctx);
+		if (ret == 2)
+			dir_modified++;
+
 		/*
 		 * Make sure the inode listed is a legal one.
 		 */
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e433281fa..afa3d517a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1875,6 +1875,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@E references EA @i %Di.\n"),
 	  PROMPT_CLEAR, 0, 0, 0, 0 },
 
+	/* Directory entry dirdata length set incorrectly */
+	{ PR_2_CLEAR_DIRDATA,
+	  N_("@E dirdata length set incorrectly.\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ef15b8c84..1ef519908 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1070,6 +1070,9 @@ struct problem_context {
 /* EA inode referenced from directory */
 #define PR_2_EA_INODE_DIR_LINK 0x020055
 
+/* Entry dirdata length set incorrectly */
+#define PR_2_CLEAR_DIRDATA		0x020057
+
 /*
  * Pass 3 errors
  */
-- 
2.43.7

