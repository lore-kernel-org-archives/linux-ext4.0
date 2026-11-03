Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713855;
	b=KKbDvrcQfZuhOY9PytDgwZ0VLrlJ+gYXqi2UZG7W1et6wPlLI2n8mdwJXJRkEK2d9jvZ
	 qUFRrmmFDkMq6daXIF5CP5JtW1sK1hhART5o0Br8okdrbZbiAUPFsF0nZ38ykLdKid71J
	 MIi/6PtcRChUhI+wKFqcTD33l52lGiuKdTIHhU0KXSzubVckNrcJXhGx4x/ayu17ZlQ/v
	 yqrvfbhVl/xrjqWXwf4WVhgUJZkewJnaVPrl1t65Zdw64ZQtXjMpPIWw3dNpentJX/VfK
	 7X3YLpNfZv31BxnUFjKxhZgJ5pj7SJTqEWCj1aTVnH/LCgTYwCVlXGpcx9lbPyYA2VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=z9X8cGXiPohgYEShqsAGjVQapfDO5R5bIzPMkH92Flc=;
	b=401/yNovQV7Na+B7dGJTReo69mq8uSk6MdJJCYb/94EzTVJe2wExalsIbyWHAZTDluJn
	 CcxY8uXoUqC+bFGs5ozIg0hDx03j+K2R1j1dr+NHXz22CWgyGjRpRrM3ZhuD2IhIKsPzB
	 puh7q52Bw330C0dfxw+a3Txk3dmcJwP2Gv2ODSVU7Yf5N8SQKyhnqdrTxbJ6oZyD9f572
	 87a4Xh07QSPRX+lriznbJiyktdyqmX0zz9EopjrYsGTkT8UTguq5KXuvM+Qw59foXMH1x
	 YwvpL9sqAiK658+duPSo11M3S8y5d/k7j0ElfpbcT90U9i5MDENtzAyhA4ZI8PiSxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=miWcmaiI;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5344E606D80A
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5344E606D80A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=miWcmaiI
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso47100995e9.1
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713854; x=1794318654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z9X8cGXiPohgYEShqsAGjVQapfDO5R5bIzPMkH92Flc=;
        b=miWcmaiI3UjPLCAlePzVp98DubhSlXorrOiiAdRQKcDN/o4wU6PQv1uAjj017kEkie
         hojDsxD+XoBA3Swea9nbxl8U4SJAric0PNEIUP0LqhpRgrnnOzr7lND5jG8abOGaKf3r
         7LnEovYfpes1KE/AovY03dYrhUzCLbUcpmYhzmc8H+vazUNBFBQVzkB9shNNTSrezMwa
         QbyGdqdSUnWOTbmGh3NmHzQPWhyOqaSOgOliwC1osWeTtiLmYOVRRztHqrka81S4THik
         cwoCWZNpT+Hsc9JI/1LoRYu2FrJHdR8vivCE4h0cke0N5GIadOlbw4lRkAEBdWtSKxoW
         grUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713854; x=1794318654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z9X8cGXiPohgYEShqsAGjVQapfDO5R5bIzPMkH92Flc=;
        b=HJtAeYGNu4jARfKhAttblb+lv/eBGMuvOVyNuK0CcmLsmbQe7tI14tRGTzsj6SA1cT
         bXeEz/Mjlg8fExAYSa6qa9palaXs6HhCMGQiiHMxMUXLntZ8DhlCKF6mIqalm43iG49z
         5i+3Ktcj8I7FOgSGDTrC4XveBEWejwzrS9j4xHSFI34WehRHj2L/V87JnvTFM6WSA6U2
         6RMaPsn9ycA+OaOrn+nOCN6gMnGfurgiOJ/4yC2ybNWvE1basSU8UsCa2pLsmdi9Wpv6
         AcQTeMPnMW8F/d23BDUkq/c5qvJrXMtyCzE8iz3/K/3ouHq3NxMwTJKR0lAqpwPUvqnv
         uwZQ==
X-Gm-Message-State: APuU4Z9Pshkn2jP8xq6Xtq5Fw8SR4pOTnEm6Q3dD6ESEr/riT3mRGThu
	St63K3/jm345HY8xrS0SuXE7oTf1/O5ZwC462pFji6DGrjhHG5JRi8OPTQ+MIae/3ok=
X-Gm-Gg: AYBFou2GPPjxpzLkYxj0zsShF81kWubhxmElMrVHomFkPMz+m5tEV/uoPPV6/G5Xrql
	drTike+gQJLakCh/9+zA4UqnsJxa7Bvon8toWmsdeFjBjEQ4FQcIZQ2YQiFEZARvKet6MbAFwcB
	89AiqT1NOuM/skWDt0zJKkms2SwxaV9rv7xZs6Lyefo2G7RlryHKilwcTRZJsTzKaOv+3MHEmmJ
	7kiET/9OjwYZPPUi2EJF4gTsLZW4BC8W8WIzhLRzX+7ZtmcJZd9jz0srQ1AgN+JRloLoWoTZus1
	CfnR2s4YBSXv8YXB5f/2nOuHQm5np/3ZfXCNd0EVy81k2zEUMOEoUB10AMn6Ujj1gaFEhAQOYB7
	XaGkZCSv7GIbTFqsnwIC/C9qp15IyfIddma4M7G1G/EAqDX+zMhdwEh2jC8dwUc5udAH0vkMWlD
	Pfz36s6PCqra3YkHQjfUD5kXNGQUTu4fsV691th66YkdkDSLU/wxSavnJdrKWtz3MQuOmXgNH1Q
	1Rdg8Eudsc69bArYT0f7jhn6Mud5ab75g5GACJ4pNrQQlwcqxoqirphtU6R/hNniLvwjzhyHpUX
	QLoba4ea55hqc37/egbaJ6GvPMEw154914MGbrb0aPWke8NGDuhoPvCjG7ah
X-Received: by 2002:a05:600c:3f10:b0:4a7:9025:5c3b with SMTP id 5b1f17b1804b1-4ac1889cc2fmr284516415e9.19.1793713853567;
        Tue, 03 Nov 2026 05:50:53 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:53 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>
Subject: [PATCH v4 05/13] e2fsck: pass2 dirdata validation and repair
Date: Tue,  3 Nov 2026 13:50:29 +0000
Message-ID: <20261103135037.610132-6-ablagodarenko@thelustrecollective.com>
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

Implement comprehensive validation and repair logic for dirdata fields in
pass 2 of e2fsck. This ensures directory entries with embedded Lustre FID
data are properly checked and corrected.

In a casefolded+encrypted directory on a dirdata filesystem the
kernel stores each entry's hash in a CFHASH record, not at the fixed
position after the name.  Add ext2fs_dirent_hashes() to find it, and
use it when pass 2 checks the min/max hash of htree leaf blocks.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 e2fsck/pass2.c      | 133 +++++++++++++++++++++++++++++++++++++++-----
 e2fsck/problem.c    |   5 ++
 e2fsck/problem.h    |   3 +
 lib/ext2fs/ext2fs.h |  22 ++++++++
 4 files changed, 149 insertions(+), 14 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index cf1678c8..639a84a6 100644
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
@@ -1643,7 +1747,8 @@ skip_checksum:
 
 			if (dx_dir->hashversion == EXT2_HASH_SIPHASH) {
 				if (dot_state > 1)
-					hash = EXT2_DIRENT_HASH(dirent);
+					hash = ext2fs_le32_to_cpu(
+					    ext2fs_dirent_hashes(dirent)->hash);
 			} else {
 				ext2fs_dirhash2(dx_dir->hashversion,
 						dirent->name,
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
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cf12716e..cb946b2a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1998,6 +1998,8 @@ extern int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry);
 extern void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len);
 extern int ext2fs_dirent_file_type(const struct ext2_dir_entry *entry);
 extern void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type);
+extern struct ext2_dir_entry_hash *
+ext2fs_dirent_hashes(struct ext2_dir_entry *entry);
 extern struct ext2_inode *ext2fs_inode(struct ext2_inode_large * large_inode);
 extern const struct ext2_inode *ext2fs_const_inode(const struct ext2_inode_large * large_inode);
 extern int ext2fs_inodes_per_orphan_block(ext2_filsys fs);
@@ -2378,6 +2380,26 @@ _INLINE_ void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type
 	entry->name_len = (entry->name_len & 0xff) | (type << 8);
 }
 
+/*
+ * Hash of an entry in a directory that keeps it in the entry (casefolded
+ * and encrypted): the CFHASH record when the entry has one, otherwise the
+ * fixed position after the name.  The records before CFHASH are skipped
+ * using their length bytes, which the caller must have checked.
+ */
+_INLINE_ struct ext2_dir_entry_hash *
+ext2fs_dirent_hashes(struct ext2_dir_entry *entry)
+{
+	if (ext2fs_dirent_file_type(entry) & EXT2_DIRENT_CFHASH) {
+		char *rec = entry->name + ext2fs_dirent_name_len(entry) + 1 +
+			ext2_get_dirdata_field_size(entry, EXT2_DIRENT_LUFID |
+							   EXT2_DIRENT_INO64);
+
+		/* skip the record length byte */
+		return (struct ext2_dir_entry_hash *)(rec + 1);
+	}
+	return EXT2_DIRENT_HASHES(entry);
+}
+
 _INLINE_ struct ext2_inode *ext2fs_inode(struct ext2_inode_large * large_inode)
 {
 	/* It is always safe to convert large inode to a small inode */
-- 
2.52.0

