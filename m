Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713853;
	b=w6DkTKcTSAfi1WqjxSlcDwaJk4AWapnGFDZsWZfOJ1U4mhXGKIKdJZQtAHX6ajMXr6i0
	 /eZI4gVF1+Jlg6MyhVp0re2gr84Y0OdRD9xsC6sQE2Yy23muGXWDhn11O2WcBl3iHj4c2
	 LAlv1wLXUUrlvKJlMD0sgCTzI/tAZu1L7dnZzSgE1w+JkLPPMCdrcH9/hGfqbEjt/meYw
	 Ozk7aHvrexUDfuvkmZZqIih+nYBlK99gRK90k82UkKy3n8x46FLz0IxygQlymw0Logo+j
	 KmxL6QINgdWMtoECVLIqM2wF9reC0AmqFnNo9+NgOMDA4IOLHKe1sA5s/Jwc/DV+YiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DCqWqP4ddTLRsbl2mP3DoKXY8NPop2A5xNgRv8tJoHg=;
	b=qgGcWuwdf0zUTqYbUdujucebPjhpsL4cF9whKQCqhLKKFKUAuBU4phwQJtNB/JxuH/At
	 +czWjkAL9kWJkWWxiAkcEALbGKpQip8079CRgiiGmJpQu5OY78xuwjCDLNWVtdVwtePqt
	 Qs0CpSLKdMekaEjAJArXlqOic4rNufuftDHe5cYJuDSnXRF2F3G3ZFyNE4aLIT6Zu60By
	 Dvt2595I+uDy29IcBMzjRJ5wovj41o9G72LDDvo6M4n3uf4s/7pq3M5ONbeQjfXqUc/6R
	 kjNzDKl92aQkbmZdaxc9ppQ3q8FYTpDBtgHsthbkXGydsJxZjc7VM2r8KqgQYUE0Xpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="OHxAJ/tR";
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF685606D815
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF685606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OHxAJ/tR
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e0d885929so3370897f8f.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713851; x=1794318651; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DCqWqP4ddTLRsbl2mP3DoKXY8NPop2A5xNgRv8tJoHg=;
        b=OHxAJ/tRdX5fa6rUul2qPstSiVJnX0ClnN1fH1sQXWQBbX1yArR4ElvHtRUcpmPuvT
         UYY6QrwxDY42apc99R1RNJKZXT3138upJEkY4xV8dvn6q4ORt852QS2Whxyq82mr+Mh1
         FNrAJdJrFDiOmeo0i4rVrBQaoCFLbl6J6Sq1EkbJ6w1SZWvjloIA0OFlmnikCh/7Ri6X
         ZVJqE/7utlhlPm+92WMhi+gIJI/QCG8V9te4nXbAh+P4Pba2qrAqquLUDyljGQ6jPvhm
         T47YqeZVtheXL0uNdOV3tmP3xTRBXXl/RX1yb7u5rjtF5YT9jGGnh1Yjx7YyBWWaHEL/
         s4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713851; x=1794318651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DCqWqP4ddTLRsbl2mP3DoKXY8NPop2A5xNgRv8tJoHg=;
        b=YtscfrCLVni+tZdKb01QNq2wOymPqq3XCjuUh2A/j6+6+xYUHWJyS5FCF8sjdSbmq0
         P5scku7UZ4kSuB3XzQTEuMIzPaG8p62Bxx7+/a+5P0+FAptSm4yM7RashP7G9qjRFkGF
         zBzklT35vbhtpt48eTU+c/W1aQ2iz5f8Ueurx0ukEvkIhcWOZ/JsGE2qYCe98cx2lAwm
         85OYHoAsL3i7NW0Un3Uz6PSjUNAYz+SCxGhn9FCPWWmL6Be9FLWIypMxSwQ6PUX77bJa
         eklBRakDhgjQUAMXKicICsSgTGkwF43mIz+EIwqcuoNt1k2ms/Noa/FQtyxMIy6WeqUP
         EPtQ==
X-Gm-Message-State: APuU4Z/g3GPmvy3u453HthyKCDaGrb9FLRLeqM47v1kFPMenTtwWfMMR
	wx2O4qKhc7lZGNoAPbrB2PhIkFeuXme+TrFVs9nuSDcdj5YPcbB9Ie/y3bv4eP707o0=
X-Gm-Gg: AYBFou0WsHu7hEvE+MEZ2MWNE1aVp958SiYRSTFzvr5+shmRHAZZmHGcqIsYtvJEGCs
	r2Ia9f2Iwt9ol+v6Dyb/L8I70zGLkPoWs5rvXamnm2FN9GlR0FN7+5UtJJ2DCd85D2L4DrQ2umX
	viHjEUVJG7XIbBtCLSK9rDVwfBF0aEoPL9BRyQ23ZQpt/AAV2hdrlzwCvJyMU4MMui1ON8Bshnc
	NySEumO5Q+5eFQY0UgX9eF/JXQLCdOn7Vdu3psaoNGGUJcFPE5C9RyjfY0mZ0+c1B9lFfKsaNRz
	bymc9Wqn202YT+I8SpWnOE8NWK3NMLYXQr+d3ZmkSOzvf7ess3eUrwAFYrDwinpeUNbhKgLrSYw
	N5SeIQ2szYsoyiR0XC3Dn/DHcYgwDA1VgGHUjYr5F37igVm+F4O93dJWp+Pi6jE4qjrbsWcAZ/3
	UgJn7Omgvj8AfLdUqHfIk2TcrkhBpkyRLdi+e0zuukWAAYibIUsjsxEvGbbFEyyV5IFa6dpDM/k
	P8YeC6L7N0aJbaILLsv6le8v5zzzCPB1VW8MdSEfDYfdyRARmtMDg9a7DKf9Cpt44Ql8iMiEOzR
	fwb/dEy6+NYkfbVG7cK3RpMqmO+CiTlJa6F13kP6isj0re1ecdnKTimiazaD
X-Received: by 2002:a05:6000:40cf:b0:48d:c29e:40c3 with SMTP id ffacd0b85a97d-48e6e5008f5mr30700650f8f.33.1793713851164;
        Tue, 03 Nov 2026 05:50:51 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:50 -0800 (PST)
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
Subject: [PATCH v4 02/13] ext2fs: Clean up directory entry handling APIs
Date: Tue,  3 Nov 2026 13:50:26 +0000
Message-ID: <20261103135037.610132-3-ablagodarenko@thelustrecollective.com>
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
index c9711446..0331711a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -773,7 +773,7 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		 */
 		memcpy(&dotdot, inode->i_block, sizeof(dotdot));
 		memcpy(&de, ((char *)inode->i_block) + EXT4_INLINE_DATA_DOTDOT_SIZE,
-		       EXT2_DIR_REC_LEN(0));
+		       EXT2_DIR_NAME_LEN(0));
 		dotdot = ext2fs_le32_to_cpu(dotdot);
 		de.inode = ext2fs_le32_to_cpu(de.inode);
 		de.rec_len = ext2fs_le16_to_cpu(de.rec_len);
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 036c0022..319e7e0e 100644
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
index 54b27772..d1d5a9e7 100644
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
index fcd42055..a4141eb7 100644
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
index bd52e377..c8d2fa0c 100644
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
index eccbf0d2..15127466 100644
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
index 7f472850..f168d668 100644
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
2.52.0

