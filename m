Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276884;
	b=SZdY64VWtouMon+hjPy++f21RgJwG1efvBguDMGMyz+Wu5LvIdeGyNBaZizIxs+nR9fu
	 coWG2JN5BgaX8NJSB3+tfVgPpzohcvkshdMbg2iCtLXsReMWYjOnlf4IcTD662oi1aia+
	 80rllcZwT6dMzUUF280E2XbMDLwdlZJsnSiNgzf39WHjnAIgt6UQBM6hhcq8TMGY+5Z/N
	 RLf7dKpJtkwQQSA1qLNQ5mU7NcQOOs+2zAfVs/MU+lyNyM56Hl/+bWywXQK+zt4fwI0LV
	 1GvNxBu7JVgBGoyKR5W7My7fPjnl8RMfH/dfh+OU+PxbgF90zrkAvjMoU+I9WTSGhtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276884;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lVBQMQV8Q9kM6ZuAEJlB8OWIGB/W41zRW0HKJ8Lqbt4=;
	b=d0rj64SdKoH8APc3C5jcI8SsYHichwOer04YLixT2hxUUABc/cLoSI2A0AQKqgqjUEuc
	 q0vi1Vt/eExxJTCxvZfUKPvC6Td/1MEUlvv8lxJ/GiubO1It8lSodCqBi0BOnNKvtImFp
	 X/aCWLyWpdybG6O+oyGGJzL5mv/YlJtZoxKZPp+MdZTjZIYVVE/GNj7LPvoBEIX9OjWNX
	 yntRaa+D7qFHNwXDO/8URn3VmgmpHMpfOCO0ecFY/7oO7ySPznE0nyMVuJjTetYE4I8Yg
	 N5UUdZ8r+dBRu0ofzetufm3Q93v3+J6TeWV6qmxhnUFvianImKqptLOsg8QXoUudf8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D8Wy4rg3;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94542606A325
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94542606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=D8Wy4rg3
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so19465205e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276882; x=1793881682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lVBQMQV8Q9kM6ZuAEJlB8OWIGB/W41zRW0HKJ8Lqbt4=;
        b=D8Wy4rg36jEdMEV2R5WcJ6oCaeTtUXqiRd/wvIkukNoNvNIHyEQQZpDNOWORNpY6Np
         Whm0tVjeApUIMgip6BQJZgUDIrD7/wq23zyFLoB9ND3U989O2y94qUFjHfYjU6Adfsic
         /TjwGFZhEmMw4lGJDZRdlH0Lfm74CbMXU1MLuRXrCuckEqoUBa5sc85uonO7kylgEpOo
         YdehJ+0mvz44HEjpVwdrOMx/5PbeHdoHHH09Iab8IjJVItaHj+JfWqWiX5soJC3Ll6XX
         vqkBeFo2gcHQLieITLGE4VJw9rS+Pre4kD/rxr6CydaUaf52kD4qZK467MzqnRDNYVwP
         eKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276882; x=1793881682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lVBQMQV8Q9kM6ZuAEJlB8OWIGB/W41zRW0HKJ8Lqbt4=;
        b=MqrBaAlcitNBYu20WPg5cfPjZUpHKvQVQgIjopIhnwFAHpkMLq/oW9Dlw8E9WUWmDc
         ErJo5wbBf7N+BgrqxVRb2DsaYj+cv9FM5CFGHYn4AgEziI5hgt5NlW1TjVjX8I+47imw
         qKlMOgvExezPgghwKElcda6kwlEg3WNyuHDdxPey5NXi2mypkIBdpbbqKgQkhFji0w/N
         YFGgjeqZ2mSGeuSYDAVRgowqShzejopsPezhynaq8GS4KNQfYmMBkTx9u4slErimhnaa
         F0q0ZiSszV9sZncr2cSue9aOqzYitU4Di8874Rj7e+k2XdCGxZJagiTgnLFOhIWrtvyM
         IHBQ==
X-Gm-Message-State: AFq9FYIMV002+lueRJq2S+KDgPSQs0jXPgSpDB7IajUngLTWvNk/PbRb
	Z7wIQcuU4qt0d4TBZouCzDOzQWrJTZ18Ykbg0n7XYC9f0KPIZ9OsVMV+ciB/LuZp
X-Gm-Gg: AYBFou02W65MAl6EjptuTgk/xZBhw0BJsD7ulzS7dTva/hkzNpM7puGvjPaoovPj3om
	UD1Jq0ihV1AFAg5dfQMk1xdSNR0HuYwNfD4S9j4EGnuUVD81HMNn9zUkL54WdPr/GPWMTXOKe6n
	LvlSZpE6xOytxjLUAYo8MHGYlUa0ISWDHQhFSViKLqKm3HNvFmPhwgmIBRdHWilqkK3YAQ/Q4cg
	O6O/6EFbOV/IMIFtfZ0FcPlofI3OHspAPNBVfV3SOOBgfn69HOHAs1Z6565YZB5CynQ43dB09RL
	mzIlW8RN31tzJHXSaDgsKKmwnw/5DhDmq5dofFfALRaPsfIUKtXKB5UfNmcjNnwlE2RagzX5c2W
	kgwCsBuAAmXmDEonADwc2fScPQjwTfOz9ejv57LCHfyxwgl/aMuNbzV4R9j2sc5Tm3qAgWoVh8D
	h0xUTmJ3kcQm/9kYtbqDoHXJd9z3vphTAoURVlAAS/dDYFcdvD/wquEwgE6uMtHb/+92wsmYJYK
	XBBf9i0d7JT+PEED0AfcHF6uImfvIpvP//MpYdSKasS5LztnFIO6IT110jqcfQ1wMIiRfRCSqqe
	QB1v81irUjufX3s1lOZfzMNq6TS2NKdH2tbNhcB8mU0ra/2w6xsZ1oUM1LXq
X-Received: by 2002:a05:600c:4e90:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4a96179c513mr118303555e9.0.1793276881930;
        Thu, 29 Oct 2026 05:28:01 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:01 -0700 (PDT)
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
Subject: [PATCH v3 05/13] e2fsck: pass2 dirdata validation and repair
Date: Thu, 29 Oct 2026 12:27:36 +0000
Message-ID: <20261029122744.230678-6-ablagodarenko@thelustrecollective.com>
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
index cf1678c8..938942a8 100644
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
index e433281f..afa3d517 100644
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
index ef15b8c8..1ef51990 100644
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
2.52.0

