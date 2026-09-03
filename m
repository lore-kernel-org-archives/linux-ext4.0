Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177A119E97B
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472971; cv=none; b=oSDY+d3X+MTWk0Vnr/1EKpXgMLs53J9lySlSWQFZ+s/mvavA6GUxeKJjtHouGJxAy/Qz06JTGkKcnVe0ePyUgxFoCtVIxLQPRPXf4WuT8YxABbNZ2nn/nV5dDG16MNiq4A37VRrsbFiM8JThvqXBKmH6za5zI/s2Fq+w5iZuKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472971; c=relaxed/simple;
	bh=fxRv11SNMupgJtjD3tQgFB3qYte6YSfNXyA5//1WQFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1sZHte95c5IxGATqVYmlW0DY7nsdLeCEcSSvWEuH2xLKgPUGq5PwUWI+NY8BQ/81x94jbT4zown6SKc1w2jPUcO5rGePdir4jseBGW0Ntddscg6b6pAJ9+6bPQ8rG8J/R1LG0yRLp1SjPxt/10OIUi3mXPhUr1LhRbKAdWG3PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HojHQmeZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HojHQmeZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b8eeb3ff2so3519965e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472967; x=1789077767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WtK+gGT1VoA7wgLd66Zp8jm8x5ESsp8PsDW9JFC3A74=;
        b=HojHQmeZl7NGtTxRZksZo5wrCPtvjqFDkLPQYQojbgQflj60iV3MYu4ISo3s0AUivf
         0Sjv12Qaw/NUz8WUQiAmtZocYx64LT5Uj9v/vlYqG+eoVVkDSVIopNXus3LDzkLpstMI
         KNGaQ0Kj9N/0EoaU6s6gSNgm9odjSXA8tZ7RXeuzj494MxYPtkFvtkuAEl/ZiV91Nqcs
         LM4inys++B20kmajaHQjXo+rnX7dyj5Csj6Vrb7GIsGcImPkcx7hCW+fgYgNNmGTDpLC
         D2cShEn4VQkiawS+Qe+Ll7PYBJuzNp/MTQEro3LFj9mUwco2ydPk8mNHZZlZSz5EJvnc
         jIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472967; x=1789077767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WtK+gGT1VoA7wgLd66Zp8jm8x5ESsp8PsDW9JFC3A74=;
        b=PSfIT1BK03X1WKrpexH+6b/hz/Kzrm5aS58pYN90chcAUhSXCnBT2d681aN6/UBIyr
         2w9utJgK7sgZmBk1fNuEOwlfFlPwonGUnFRu8nYhpI8MUwk7Bhs075emfL06S10IWsi/
         n1c03z4my5H2lXB3SjlHSfr2RDeHRuhLjTVDqmOj+Nr0KraDPb5L/SkXikTQkfuYPadm
         2UkWpJEvGrMWbQS4Y0POsgrFud05VKbG45yaF+XV62kXILNbNE5OV40oYzdRvBFhn6dl
         7GbsbJuuqomQSoQ5HnrLIWMhBrH3GvNKfkv6bdRzb0lVFUKG4xYJjDj+aWMpcqeFpdHg
         HAHw==
X-Gm-Message-State: AFuF++kV7CP1Fp7zruuXkMbduT9dxBc8NU8Ixsgq82nztdvSa6cM7K1q
	3Pm3sQF8CvMd87DdxiAIxolWMDah87Oi21myiZ2C5HvW9R9zUhyUVNkAztZZtDP2
X-Gm-Gg: AYBFou378EzaGxyIXz58+95E347BN67gct1Rw2Xc2WdGXt8OTtzPr/QtBMLs/czqoDD
	wVm4wUMNoV74Fr2y5VY6W0HubHoz6triZivJPqDO3rAndw5Jf/XTijXDZrKtqpjAdA77QvSpQgA
	1O2sNxAzMPC0uoL1n8quhneEJXE58iZR28fGIwo06GQiA8O0BeNWG5DTeedk+qwosTOzE6zNnL3
	LD8w8gATvI1fxFHLzGylgBn5/ZeE5uZxm6w5WY3xBPXsVGMVQIQVwP4njsc1BIVUuD46z8pJ9cq
	/cygfKk6BXKOnsYpwwR8RU2X/2uTsHSESzM4cI2HtwKC1nwyDmIbk0JO8C7sZkvnUBaICguZ1WG
	r62La42LWo6SnprvF6iJdGQC9iSCMwpB5fJiip2mJPHvSqfLy4+KIJs7C4GFwE7FF0qW56U15b9
	C6UhnSfG/cabcDw796pl3kEUtbrese6ou7XLs1bXxaO6R6q1WW5Rj1lUMI6VeVRt6fD4WAER85M
	eUGmeC5Ieg2XiRVCNDsPGzynKjbi8jT
X-Received: by 2002:a05:600c:350f:b0:499:b65d:124f with SMTP id 5b1f17b1804b1-49cf825d1dcmr11352105e9.11.1788472966853;
        Thu, 03 Sep 2026 15:02:46 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:46 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 02/13] ext2fs: Clean up directory entry handling APIs
Date: Thu,  3 Sep 2026 18:01:35 -0400
Message-ID: <20260903220146.19752-3-ablagodarenko@thelustrecollective.com>
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

Refactor directory entry manipulation code to use more appropriate macros
and simplify API usage:

- Replace EXT2_DIR_REC_LEN(namelen) with EXT2_DIR_NAME_LEN(namelen)
  to correctly calculate name length overhead instead of full record length

- Rename EXT2_DIR_REC_LEN to EXT2_DIRENT_REC_LEN to show that it counts dirent.
  Pass directory entry structs directly to EXT2_DIRENT_REC_LEN() instead of
  extracting name_len field separately, leveraging helper function in macro

- Use EXT2_FT_MASK constant instead of EXT2FS_LINK_FT_MASK for consistency
  with standard ext2fs conventions

This improves code clarity and reduces API misuse by matching intent
(calculating name space vs. total record space) with the appropriate macro.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/pass1.c           |  2 +-
 e2fsck/pass2.c           | 15 +++++++--------
 lib/ext2fs/dirblock.c    | 33 +++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_fs.h     | 17 ++++++++++++++++-
 lib/ext2fs/inline_data.c | 14 +++++++-------
 lib/ext2fs/link.c        | 11 +++++------
 lib/ext2fs/newdir.c      |  4 ++--
 7 files changed, 71 insertions(+), 25 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index fdde76cc2..39d1255f9 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -770,7 +770,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		 */
 		memcpy(&dotdot, inode->i_block, sizeof(dotdot));
 		memcpy(&de, ((char *)inode->i_block) + EXT4_INLINE_DATA_DOTDOT_SIZE,
-		       EXT2_DIR_REC_LEN(0));
+		       EXT2_DIR_NAME_LEN(0));
 		dotdot = ext2fs_le32_to_cpu(dotdot);
 		de.inode = ext2fs_le32_to_cpu(de.inode);
 		de.rec_len = ext2fs_le16_to_cpu(de.rec_len);
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 036c0022d..319e7e0e3 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -862,11 +862,11 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 	d = dirbuf;
 	top = EXT2_DIRENT_TAIL(dirbuf, fs->blocksize);
 
-	while (d->rec_len && !(d->rec_len & 0x3) && NEXT_DIRENT(d) <= top)
-		d = NEXT_DIRENT(d);
+	while (d->rec_len && !(d->rec_len & 0x3) && EXT2_NEXT_DIRENT(d) <= top)
+		d = EXT2_NEXT_DIRENT(d);
 
 	if (d != top) {
-		unsigned int min_size = EXT2_DIR_REC_LEN(
+		unsigned int min_size = EXT2_DIR_NAME_LEN(
 				ext2fs_dirent_name_len(dirbuf));
 		if (min_size > (char *)top - (char *)d)
 			return EXT2_ET_DIR_NO_SPACE_FOR_CSUM;
@@ -881,7 +881,6 @@ static errcode_t insert_dirent_tail(ext2_filsys fs, void *dirbuf)
 
 	return 0;
 }
-#undef NEXT_DIRENT
 
 static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
 				     size_t *inline_data_size,
@@ -900,7 +899,7 @@ static errcode_t fix_inline_dir_size(e2fsck_t ctx, ext2_ino_t ino,
 	 */
 	if (old_size > EXT4_MIN_INLINE_DATA_SIZE &&
 	    old_size < EXT4_MIN_INLINE_DATA_SIZE +
-		       EXT2_DIR_REC_LEN(1)) {
+		       EXT2_DIR_NAME_LEN(1)) {
 		old_size = EXT4_MIN_INLINE_DATA_SIZE;
 		new_size = old_size;
 	} else
@@ -1187,7 +1186,7 @@ inline_read_fail:
 	if (((inline_data_size & 3) ||
 	     (inline_data_size > EXT4_MIN_INLINE_DATA_SIZE &&
 	      inline_data_size < EXT4_MIN_INLINE_DATA_SIZE +
-				 EXT2_DIR_REC_LEN(1))) &&
+				 EXT2_DIR_NAME_LEN(1))) &&
 	    fix_problem(ctx, PR_2_BAD_INLINE_DIR_SIZE, &pctx)) {
 		errcode_t err = fix_inline_dir_size(ctx, ino,
 						    &inline_data_size, &pctx,
@@ -1409,7 +1408,7 @@ skip_checksum:
 				memset(&dot, 0, sizeof(dot));
 				dirent = &dot;
 				dirent->inode = ino;
-				dirent->rec_len = EXT2_DIR_REC_LEN(1);
+				dirent->rec_len = EXT2_DIR_NAME_LEN(1);
 				dirent->name_len = 1 | filetype;
 				dirent->name[0] = '.';
 			} else if (dot_state == 1) {
@@ -1417,7 +1416,7 @@ skip_checksum:
 				dirent = &dotdot;
 				dirent->inode =
 					((struct ext2_dir_entry *)buf)->inode;
-				dirent->rec_len = EXT2_DIR_REC_LEN(2);
+				dirent->rec_len = EXT2_DIR_NAME_LEN(2);
 				dirent->name_len = 2 | filetype;
 				dirent->name[0] = '.';
 				dirent->name[1] = '.';
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index 54b277728..d1d5a9e7f 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -50,6 +50,39 @@ errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 	return ext2fs_read_dir_block4(fs, block, buf, flags, 0);
 }
 
+/*
+ * Compute the dirdata length. This includes only optional extensions.
+ * Each extension has a bit set in the high 4 bits of
+ * de->file_type, and the extension length is the first byte in each entry.
+ */
+int ext2_get_dirdata_field_size(struct ext2_dir_entry *de,
+				 __u8 dirdata_flags)
+{
+	char *lenp = de->name + (de->name_len & EXT2_NAME_LEN) + 1 /* NUL */;
+	__u8 extra_data_flags = (de->name_len & ~(EXT2_FT_MASK << 8)) >> 12;
+	int dlen = 0;
+
+	dirdata_flags >>= 4;
+	while ((extra_data_flags & dirdata_flags) != 0) {
+		if (extra_data_flags & 1) {
+			if (dirdata_flags & 1)
+				dlen += *lenp;
+
+			lenp += *lenp;
+		}
+		extra_data_flags >>= 1;
+		dirdata_flags >>= 1;
+	}
+
+	/* add NUL terminator byte to dirdata length */
+	return dlen + (dlen != 0);
+}
+
+int ext2_get_dirdata_size(struct ext2_dir_entry *de)
+{
+	return ext2_get_dirdata_field_size(de, ~EXT2_FT_MASK);
+}
+
 errcode_t ext2fs_read_dir_block2(ext2_filsys fs, blk_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)))
 {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fcd420556..a4141eb71 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -1091,6 +1091,10 @@ struct ext2_dir_entry_tail {
 #define EXT2_FT_SYMLINK		7
 
 #define EXT2_FT_MAX		8
+#define EXT2_FT_MASK		0x0f
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
 
 /*
  * Annoyingly, e2fsprogs always swab16s ext2_dir_entry.name_len, so we
@@ -1100,6 +1104,9 @@ struct ext2_dir_entry_tail {
  */
 #define EXT2_DIR_NAME_LEN_CSUM	0xDE00
 
+int ext2_get_dirdata_field_size(struct ext2_dir_entry *de, __u8 dirdata_flags);
+int ext2_get_dirdata_size(struct ext2_dir_entry *de);
+
 /*
  * EXT2_DIR_PAD defines the directory entries boundaries
  *
@@ -1109,7 +1116,13 @@ struct ext2_dir_entry_tail {
 #define EXT2_DIR_ENTRY_HASH_LEN		8
 #define EXT2_DIR_PAD			4
 #define EXT2_DIR_ROUND			(EXT2_DIR_PAD - 1)
-#define EXT2_DIR_REC_LEN(name_len) ext2fs_dir_rec_len(name_len, 0)
+#define EXT2_DIR_NAME_LEN(name_len)	(((name_len) + \
+					  EXT2_DIR_ENTRY_HEADER_LEN + \
+					  EXT2_DIR_ROUND) & \
+					 ~EXT2_DIR_ROUND)
+#define EXT2_DIRENT_REC_LEN(de)	(EXT2_DIR_NAME_LEN(((de)->name_len &  \
+						     EXT2_NAME_LEN) +         \
+						    ext2_get_dirdata_size(de)))
 
 static inline unsigned int ext2fs_dir_rec_len(__u8 name_len,
 						int extended)
@@ -1202,4 +1215,6 @@ struct mmp_struct {
 
 #define EXT4_ENC_STRICT_MODE_FL			(1 << 0) /* Reject invalid sequences */
 
+#define EXT2_NEXT_DIRENT(d)	((void *)((char *)(d) + (d)->rec_len))
+
 #endif	/* _LINUX_EXT2_FS_H */
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index bd52e3770..c8d2fa0ce 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -149,7 +149,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 	/* we first check '.' and '..' dir */
 	dirent.inode = ino;
 	dirent.name_len = 1;
-	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(2), &dirent);
+	ext2fs_set_rec_len(fs, EXT2_DIR_NAME_LEN(2), &dirent);
 	dirent.name[0] = '.';
 	dirent.name[1] = '\0';
 	ctx->buf = (char *)&dirent;
@@ -160,7 +160,7 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 
 	dirent.inode = ext2fs_le32_to_cpu(inode.i_block[0]);
 	dirent.name_len = 2;
-	ext2fs_set_rec_len(fs, EXT2_DIR_REC_LEN(3), &dirent);
+	ext2fs_set_rec_len(fs, EXT2_DIR_NAME_LEN(3), &dirent);
 	dirent.name[0] = '.';
 	dirent.name[1] = '.';
 	dirent.name[2] = '\0';
@@ -296,14 +296,14 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	ext2fs_dirent_set_name_len(dir, 1);
 	ext2fs_dirent_set_file_type(dir, filetype);
 	dir->name[0] = '.';
-	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
-	dir->rec_len = EXT2_DIR_REC_LEN(1);
+	rec_len = (fs->blocksize - csum_size) - EXT2_DIR_NAME_LEN(1);
+	dir->rec_len = EXT2_DIR_NAME_LEN(1);
 
 	/*
 	 * Set up entry for '..'
 	 */
 	dir = (struct ext2_dir_entry *) (bbuf + dir->rec_len);
-	dir->rec_len = EXT2_DIR_REC_LEN(2);
+	dir->rec_len = EXT2_DIR_NAME_LEN(2);
 	dir->inode = ext2fs_le32_to_cpu(((__u32 *)ibuf)[0]);
 	ext2fs_dirent_set_name_len(dir, 2);
 	ext2fs_dirent_set_file_type(dir, filetype);
@@ -313,11 +313,11 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	/*
 	 * Adjust the last rec_len
 	 */
-	offset = EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2);
+	offset = EXT2_DIR_NAME_LEN(1) + EXT2_DIR_NAME_LEN(2);
 	dir = (struct ext2_dir_entry *) (bbuf + offset);
 	memcpy(bbuf + offset, ibuf + EXT4_INLINE_DATA_DOTDOT_SIZE,
 	       size - EXT4_INLINE_DATA_DOTDOT_SIZE);
-	size += EXT2_DIR_REC_LEN(1) + EXT2_DIR_REC_LEN(2) -
+	size += EXT2_DIR_NAME_LEN(1) + EXT2_DIR_NAME_LEN(2) -
 		EXT4_INLINE_DATA_DOTDOT_SIZE;
 
 	do {
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index eccbf0d23..151274663 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -197,7 +197,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	if (ls->done)
 		return DIRENT_ABORT;
 
-	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
+	rec_len = EXT2_DIR_NAME_LEN(ls->namelen);
 
 	ls->err = ext2fs_get_rec_len(ls->fs, dirent, &curr_rec_len);
 	if (ls->err)
@@ -226,7 +226,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	 * truncate it and return.
 	 */
 	if (dirent->inode) {
-		min_rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(dirent));
+		min_rec_len = EXT2_DIRENT_REC_LEN(dirent);
 		if (curr_rec_len < (min_rec_len + rec_len))
 			return ret;
 		rec_len = curr_rec_len - min_rec_len;
@@ -254,8 +254,7 @@ static int link_proc(ext2_ino_t dir EXT2FS_ATTR((unused)),
 	ext2fs_dirent_set_name_len(dirent, ls->namelen);
 	strncpy(dirent->name, ls->name, ls->namelen);
 	if (ext2fs_has_feature_filetype(ls->sb))
-		ext2fs_dirent_set_file_type(dirent,
-					    ls->flags & EXT2FS_LINK_FT_MASK);
+		ext2fs_dirent_set_file_type(dirent, ls->flags & EXT2_FT_MASK);
 
 	ls->done++;
 	return DIRENT_ABORT|DIRENT_CHANGED;
@@ -331,8 +330,8 @@ static errcode_t dx_move_dirents(ext2_filsys fs, struct dx_hash_map *map,
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	for (i = 0; i < count; i++) {
-		de = (struct ext2_dir_entry *) ((char *)from + map[i].off);
-		rec_len = EXT2_DIR_REC_LEN(ext2fs_dirent_name_len(de));
+		de = from + map[i].off;
+		rec_len = EXT2_DIRENT_REC_LEN(de);
 		memcpy(to, de, rec_len);
 		retval = ext2fs_set_rec_len(fs, rec_len, to);
 		if (retval)
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index 7f4728500..f168d6686 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -64,8 +64,8 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 		ext2fs_dirent_set_name_len(dir, 1);
 		ext2fs_dirent_set_file_type(dir, filetype);
 		dir->name[0] = '.';
-		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_REC_LEN(1);
-		dir->rec_len = EXT2_DIR_REC_LEN(1);
+		rec_len = (fs->blocksize - csum_size) - EXT2_DIR_NAME_LEN(1);
+		dir->rec_len = EXT2_DIR_NAME_LEN(1);
 
 		/*
 		 * Set up entry for '..'
-- 
2.43.7

