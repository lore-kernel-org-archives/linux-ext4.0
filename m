Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41B9369990
	for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776461861; cv=none; b=NOJo4CdhxCmUMS0KD/Ecokicj+yxbK0Bc+KTJkY5iLpmvnB6rTVD+SJ2YM85lP3h5blXfYYvaMaAwviCENfpOgaSctul3+q1DK+KmcieCw8R/0IjCY3gLp0b9WBaEppU8vzgYRXspmLEN/lZiHD0Lq58mqRG8zDvdoqxdMzvrWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776461861; c=relaxed/simple;
	bh=CO64/L2VEZHXhyQuZN9K5sXJUy4ueCobKpwYH8YzQuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwUGkB8hF0YqSpyabg82uZ3sZN6e63gHFd3hcmM+gGZwiMX8k524H5HVJ7DCiv37Ov5t8jqEO0PRzht8jgw62ANFArvNPgCt1uj0hVKK8+2jpu/LvG7G42bf4nMLlR/mDSo9CkhaTwxpMnhwjiwwVi1tV8o+R3mK63uDoQ/Ggxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+RfYXeX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+RfYXeX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso19530245e9.1
        for <linux-ext4@vger.kernel.org>; Fri, 17 Apr 2026 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776461858; x=1777066658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G6tFieCJAiC5nh8dd2uucoWVK3zmd0x9+zdqU6Vsths=;
        b=K+RfYXeXrBnznzlueTo1QVt9D8jhXQs1qaHORyX6Tt/K2U+YNKpmnmixqThTOBWDRf
         s14OphL0FvN3CIyxfnkUPCy4YmR3N6tgif/mLiCeCGVF8Npa6KvtkYEOZD7m9sasa+9z
         S0UDdYFncM9rYkqnF9NVYfILitfP9Slir0YUnkgfLsavMBpGDRdydvnotvTvjtZwgmdL
         wljLwqHvoNkgxbIiBClXej4OJyUIIdn1qX1k5Gphd+gU+CM6a6rNxs3TU7mpnzJPlZC9
         5b5KA/8NJu1grDytDKY8zDacGxV4c1rYTnty8GkwdbYo/06gTC1CnrNfNv2s1rc7COEq
         NVsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776461858; x=1777066658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G6tFieCJAiC5nh8dd2uucoWVK3zmd0x9+zdqU6Vsths=;
        b=YU5sTOflPTH9MTaTR7/wfMgNlGlFyuviV9ho2MBBfwnJJefcIjm2n9d0yihx4HdUR5
         gW/9CUkCY/S13tG7Q7jwIksgg1whEoC1LU3z6jbAvm+yCNVGgTMCbFH5nb1A6+24kHnu
         iyZe9uVjJF3OU0KpDE2Ll5MINtukLnN8QIrPE9asx2C3/b7W3dzHGSNw42boWBCzt3QZ
         fkKrx3L0psvvad3vc3eT2fY6XcCHER3Mh/XmjBt2HpctlOGiJ54ch4EQIIxCV++oBJ8/
         +XnhwCjo8XTdaHgWPgXMFpASoGKo1VHng64gkj0TfuX4o517JVOTPqSgN/qblAEc2Sc/
         3dCA==
X-Gm-Message-State: AOJu0Yw5XXiNpory9uCp5kroRLi4MALt0aApHosJ2rB7AMmMcnVLPWW1
	S0AF8yow3S4g5udZPco3yBDcalg+nS8mcCAldqblfdXjVwjrP+GZNfn4FHfnHw==
X-Gm-Gg: AeBDievb7ALHFfJ6C28OfX13I7T/09Y8Zd/QCYlL4975Pj6V6nAWFcC5aWUNxckmsHy
	G3OzQkNtDYhdZAwlaqKx1tJEEiOM+vacIp5ZkTzWJf4NjaqhtVkPQYQs2d4sUgjnfBo02+q1W4l
	vKRqb+KHwQMW8GHBNK65qnmpmFUMTSnEBuumOStO9ZKuj8lguy7pfuuOMiWpVRfwBWVEZZhpxmg
	AjPRxdbNdoMRwhiLrqmgCGN983waPccP4dMDfsSey4rrfARuSDjR2YNx9tVdZt5TmVIwL4WxmSN
	lSCXQkih7CAtdyU6aqJF994CbotrR4zed4vsJ1nswimWSko8kqHBveOZHHwIfDqonD5hCSPl8+1
	4KW5crRS3RmOTcDSiW+R5uOqr2CtlBUCZgLdx154HaCtxvLg0f2mId11xZ5NIX+xA7/xx1c2wLX
	b0CQcr/AL3J+yHVvQeyhphYSwpQNlhpLWgDOJnSLTS9CD8eYVUtj205SnAGN5ALYzGJRnUG9EZE
	fDQg2RE9Vb9
X-Received: by 2002:a05:600c:5488:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-488fb8b1b21mr52674565e9.11.1776461858074;
        Fri, 17 Apr 2026 14:37:38 -0700 (PDT)
Received: from localhost.localdomain ([2a00:23c7:90c1:9201:f5b4:1568:453c:b849])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb762f56sm25725645e9.15.2026.04.17.14.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:37:37 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/3] ext4: add dirdata support structures and helpers
Date: Fri, 17 Apr 2026 22:37:19 +0100
Message-ID: <20260417213723.74204-3-artem.blagodarenko@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Space after the name is currently used to store hashes for
fscrypt and casefold. The dirdata feature will add structures
to store different types of data there (including the hash).

This patch adds some structures, values, and functions that
will be used by the dirdata feature.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/ext4.h | 123 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..09d277e24dde 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2472,6 +2472,34 @@ struct ext4_dir_entry_tail {
 #define EXT4_FT_SYMLINK		7
 
 #define EXT4_FT_MAX		8
+#define EXT4_FT_MASK		0xf
+
+#if EXT4_FT_MAX > EXT4_FT_MASK
+#error "conflicting EXT4_FT_MAX and EXT4_FT_MASK"
+#endif
+
+/*
+ * d_type has 4 unused bits, so it can hold four types of data. These different
+ * types of data (e.g. lustre data, high 32 bits of 64-bit inode number) can be
+ * stored, in flag order, after file-name in ext4 dirent.
+ *
+ * These flags are added to d_type if ext4 dirent has extra data after
+ * filename. This data length is variable and length is stored in first byte
+ * of data. Data starts after filename NUL byte.
+ */
+#define EXT4_DIRENT_LUFID		0x10
+#define EXT4_DIRENT_INO64		0x20
+#define EXT4_DIRENT_CFHASH		0x40
+
+struct ext4_dirent_data_header {
+	/* length of this header + the whole data blob */
+	__u8	ddh_length;
+} __packed;
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header	dh_header;
+	struct ext4_dir_entry_hash	dh_hash;
+} __packed;
 
 #define EXT4_FT_DIR_CSUM	0xDE
 
@@ -2489,17 +2517,25 @@ struct ext4_dir_entry_tail {
  * casefolded and encrypted need to store the hash as well, so we add room for
  * ext4_extended_dir_entry_2. For all entries related to '.' or '..' you should
  * pass NULL for dir, as those entries do not use the extra fields.
+ *
+ * For directories with the dirdata feature, extra data may follow the filename.
+ * Use ext4_dir_entry_len() to compute the length of a directory entry
+ * including any dirdata, or ext4_dirent_rec_len() directly when the total
+ * name_len (including dirdata length) is already known.
  */
-static inline unsigned int ext4_dir_rec_len(__u8 name_len,
+static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
 						const struct inode *dir)
 {
-	int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
+	unsigned int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
 	if (dir && ext4_hash_in_dirent(dir))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
 	return (rec_len & ~EXT4_DIR_ROUND);
 }
 
+/* Compute rec_len for a given name_len without a directory inode context */
+#define __EXT4_DIR_REC_LEN(name_len)	ext4_dirent_rec_len((name_len), NULL)
+
 static inline unsigned int
 ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
 {
@@ -2921,10 +2957,16 @@ static const unsigned char ext4_filetype_table[] = {
 
 static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	unsigned char  fl_index = filetype & EXT4_FT_MASK;
+
+	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	if (!test_opt(sb, DIRDATA))
+		return ext4_filetype_table[fl_index];
+
+	return (ext4_filetype_table[fl_index]) |
+		(filetype & ~EXT4_FT_MASK);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
@@ -3917,6 +3959,79 @@ static inline void ext4_clear_io_unwritten_flag(ext4_io_end_t *io_end)
 		io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
 }
 
+/*
+ * Advance to the next dirdata record header starting from @ddh.
+ */
+#define ext4_dirdata_next(ddh) \
+	((struct ext4_dirent_data_header *)((char *)(ddh) + (ddh)->ddh_length))
+
+/*
+ * ext4_dir_entry_is_tail() - Check if a directory entry is a tail entry.
+ * @de: directory entry to check
+ *
+ * Returns true if @de is a directory block tail entry (checksum record).
+ */
+static inline bool ext4_dir_entry_is_tail(struct ext4_dir_entry_2 *de)
+{
+	struct ext4_dir_entry_tail *t = (struct ext4_dir_entry_tail *)de;
+
+	return !t->det_reserved_zero1 &&
+	       le16_to_cpu(t->det_rec_len) == sizeof(*t) &&
+	       !t->det_reserved_zero2 &&
+	       t->det_reserved_ft == EXT4_FT_DIR_CSUM;
+}
+
+/*
+ * ext4_dirent_get_data_len() - Compute the total dirdata length for an entry.
+ * @de: directory entry
+ *
+ * Computes the length of optional data stored after the filename (and its
+ * implicit NUL terminator).  Each extension is indicated by a bit in the
+ * high 4 bits of de->file_type; the first byte of each extension is its
+ * length (including that length byte itself).
+ *
+ * Returns 0 for tail entries and for entries with no dirdata.
+ */
+static inline int ext4_dirent_get_data_len(struct ext4_dir_entry_2 *de)
+{
+	__u8 extra_data_flags;
+	struct ext4_dirent_data_header *ddh;
+	int dlen = 0;
+
+	if (ext4_dir_entry_is_tail(de))
+		return 0;
+
+	extra_data_flags = (de->file_type & ~EXT4_FT_MASK) >> 4;
+	ddh = (struct ext4_dirent_data_header *)(de->name + de->name_len +
+						 1 /* NUL terminator */);
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			dlen += ddh->ddh_length + (dlen == 0);
+			ddh = ext4_dirdata_next(ddh);
+		}
+		extra_data_flags >>= 1;
+	}
+	return dlen;
+}
+
+/*
+ * ext4_dir_entry_len() - Compute the required rec_len for a directory entry.
+ * @de:  directory entry (used to read name_len and any dirdata length)
+ * @dir: directory inode (may be NULL for '.' and '..' entries)
+ *
+ * Returns the minimum record length needed to hold @de, rounded up to the
+ * directory alignment and including room for the casefold+fscrypt hash if
+ * the directory requires it.
+ */
+static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
+					      const struct inode *dir)
+{
+	unsigned int dirdata = ext4_dirent_get_data_len(de);
+
+	return ext4_dirent_rec_len(de->name_len + dirdata, dir);
+}
+
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
 
-- 
2.43.5

