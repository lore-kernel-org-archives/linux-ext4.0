Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276883;
	b=uIOvMXe8MGSeVtRKikAoObD1c74IfhaxRjW0NTHHQWEM0/5QVBQbUwZUVx3AHf7uzORh
	 eU76OCKA22kmEAVPwL20DK1QhK1aeOadQL7Wp8t2zbDpqMas77su9PkU8PsNRWDnSlFbN
	 p4UYCeydWhNN7YyAkACNhsxAUUgFK342w+lKQ9ZK+wnsHw4IdtbxDJECmynpuylld6HY6
	 e9gLZauFQtfXUPpovkMZqVNZ+/wIpcTm+SqmSjfzF86YG1O1lJpF18Akh8Y0HzEyiS+BA
	 oNoVk+WyFTBUVA2LDvse1r8OZzfqQ6NDg36Oyj/UEKMk2hTU+jTfMUyH3RNwN3/B1qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276883;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
	b=USwPuEDcLd1/wMTFYt0uafAuJtimVzO2c/vN5DTvZLzy7ng5y5UMSaGLzuUar+4bfQK0
	 tsSRpc15KgQyI79X1Yu4oowKo9MXd2LkjYSxWezIWm6RGnS70bllglKTjGno9oCbwhvxX
	 lz9TUma/HyT7bOpxyzQJYfap2pDtqTqtM0RtiMvK7OKPRTjRH5nQ/J9hob8AWgX0fD06I
	 YLJQqpzKbOjCDDs2gO3LLAn0Om6T3hZxP/becNZLAgyDH+YBbYT1hnmq1nIme/3e4bRhe
	 g+0dTIxUoiTB7fwYYocsD0gPNpU+vwpMVqzBXaBrxZRHVGVmHaENCY5JxfOnU3xkkHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OxRYrTRV;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7618606A320
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C7618606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OxRYrTRV
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9263645e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276881; x=1793881681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
        b=OxRYrTRVnQbgYuJ2cyXLWVEpSH8PjhZaEc/dqkr6vT3o69rzk5qVw7XBZCKJHK9zMh
         7M3ZZunlBHmLD74kKcAxwslTG24s6jwNG5w9uCY9ic9oqS+umwFpzKnj0xpqZ2makU8d
         I6+IHvYpe+fUwzHA065yiwi8QXELmta75lngEUQVpC2q8u0wVZr3uSQPEPO40I/V+MQT
         Y69ab6kTjWaTuENeg9BRIExiCZUuqPPhRrtDfS0kEs0IO3DWbnSuwF2GqdVpY38rjrG9
         LnSlGH5poTNsoKk9IMKoJf92tns02CW/qzA6ifRqHo/3op/2Fg19a7uzMcLw747ZH1JP
         WFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276881; x=1793881681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
        b=DCCpsNMnIHbwHDUEzhSJtwICEPBjAZ9y+q/YcVg/ESNGBL8gDynpd5Jy7qqTH1zQR7
         4RvDTnu+591R5ZnCmyyciFrEcC9+oaQs+zg5LRV9m3+ZyFivy47cm15RTOKntEZg+d5p
         IIyq3/ONzCR5LTGQUd21AOIZqX9/WvtUj/hlIe2JdEUrXMnWL4NDu0KeCK80kCk9YsVS
         yboo4l271cy80bPYDrz5MaPVPzP6rboJE4YO7Hnz/8cjnHxQCP4NuzLzHVtt1JK3F1Za
         NAt0DJ5ikqc9+FonCmcidrBOooiNuSOY9sPPEXEEm9tBAWSBVkr6fLIIi+O4z6sXnHkU
         tQkA==
X-Gm-Message-State: AFq9FYKFxYKldfxKra+PdpnDdmfUnX32pHDWZWv5ekOQq7IGhFmNc1P4
	zd/lFURmTY4nEsR5uPsNXPDYremVp+24aisplZDAutMQkU32tC6EhSBU8nUGStUR
X-Gm-Gg: AYBFou0E9/regIYLqo75tlsPN78IH+Ga243togV2eczjzM+cgTiEFqpWXk0HHyO+Inr
	Q3CZJ8Ol8o3dxv7ZPit23Jfcto5fIZ6UhV3LOL0ki6+FxpznYJR8P0XvbP412h3CEOAzgbhsDTs
	ftA59Yr0T9AIPQo6DwxhW938/1jmM/sKDLk/k46Vog1hY9browM3JwpSE+Ksxhq1t/qXa49SPXh
	mb5EevaVdkvo6P/jl0rEXDkT9jdGOQqiZPfJbMmC9lt1C8nUhFroJIAGAXxLYN3HpsQBVVkZMwt
	/m6FWuynBvB9WBDMRDTK0NzemXoL/+DCLgAKSxrgv7l8Y9SWrw/EalCMwfLUhs8yv3A3ATLpAgy
	5H2t2XzNhvYp44TR2xGbVq70GlRU0S3u9RrZnLpr6EjUidHUSUuwogJLdSPMffwjKnZopebLF7Y
	xW2y0MR/ZxUfc1bYS2cBv0q0ETju5EPitc/xGpdfxUQiareWs5iYl3r3/1kPVMfWxgqEKqXLwIC
	3brzj1JG73Mhlexx7vqAhX2bhXxJEPKE491U75FSaawtCusgz7MSuiL1rNR5etuuV+Mz1/p7jIS
	hp8peOCfMaFyBU/y40oJgWe2APKH4Sp7FrkDSdHvNl86EA9Ljd0NdMVbal8Y
X-Received: by 2002:a05:600c:8485:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4aa87d6fcdamr60702535e9.13.1793276880604;
        Thu, 29 Oct 2026 05:28:00 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:00 -0700 (PDT)
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
Subject: [PATCH v3 03/13] ext2fs: dirdata infrastructure and core functions
Date: Thu, 29 Oct 2026 12:27:34 +0000
Message-ID: <20261029122744.230678-4-ablagodarenko@thelustrecollective.com>
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

Add dirdata support infrastructure in the new lfsck.h header, with
data structures (lu_fid, ext4_dirent_data_header, ext4_dirent_hash)
related to dirdata fields.

Define dirdata feature add some other helper functions.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 lib/ext2fs/ext2_fs.h | 30 +++++++++++++++++++++++++++-
 lib/ext2fs/ext2fs.h  |  3 ++-
 lib/ext2fs/lfsck.h   | 47 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+), 2 deletions(-)
 create mode 100644 lib/ext2fs/lfsck.h

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a4141eb7..73e93f9b 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -977,7 +977,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		4, CASEFOLD)
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP| \
 				       EXT4_FEATURE_INCOMPAT_LARGEDIR| \
-				       EXT4_FEATURE_INCOMPAT_EA_INODE)
+				       EXT4_FEATURE_INCOMPAT_EA_INODE| \
+				       EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -1135,6 +1136,33 @@ static inline unsigned int ext2fs_dir_rec_len(__u8 name_len,
 	return rec_len;
 }
 
+static inline unsigned int ext2fs_dirdata_rec_len(struct ext2_dir_entry *de,
+						   int extended)
+{
+	int rec_len = EXT2_DIRENT_REC_LEN(de);
+
+	if (extended)
+		rec_len += EXT2_DIR_ENTRY_HASH_LEN;
+	return rec_len;
+}
+
+static inline unsigned int ext2fs_dir_rec_padding(struct ext2_dir_entry *de)
+{
+	unsigned int len = (de->name_len & EXT2_NAME_LEN) +
+		ext2_get_dirdata_size(de);
+
+	len &= EXT2_DIR_ROUND;
+	if (len)
+		len = EXT2_DIR_PAD - len;
+	return len;
+}
+
+/* lu_fid size and NUL char */
+#define EXT2_DIRENT_LUFID_SIZE		16
+#define EXT2_DIRENT_LUFID		0x10
+#define EXT2_DIRENT_INO64		0x20
+#define EXT2_DIRENT_CFHASH		0x40
+
 #define EXT4_ORPHAN_BLOCK_MAGIC 0x0b10ca04
 
 /* Structure at the tail of orphan block */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 374b8289..91d26986 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -735,6 +735,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_EA_INODE|\
+					 EXT4_FEATURE_INCOMPAT_DIRDATA|\
 					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
@@ -2340,7 +2341,7 @@ _INLINE_ __u64 ext2fs_div64_ceil(__u64 a, __u64 b)
 
 _INLINE_ int ext2fs_dirent_name_len(const struct ext2_dir_entry *entry)
 {
-	return entry->name_len & 0xff;
+	return entry->name_len & EXT2_NAME_LEN;
 }
 
 _INLINE_ void ext2fs_dirent_set_name_len(struct ext2_dir_entry *entry, int len)
diff --git a/lib/ext2fs/lfsck.h b/lib/ext2fs/lfsck.h
new file mode 100644
index 00000000..ec763f72
--- /dev/null
+++ b/lib/ext2fs/lfsck.h
@@ -0,0 +1,47 @@
+#ifndef LFSCK_H
+#define LFSCK_H
+
+struct ext4_dirent_data_header {
+	/* length of this header + the whole data blob */
+	__u8    ddh_length;
+} __attribute__((packed));
+
+#ifndef DFID
+#define DFID "[%#llx:0x%x:0x%x]"
+#define PFID(fid) (unsigned long long)(fid)->f_seq, (fid)->f_oid, (fid)->f_ver
+struct lu_fid {
+	__u64   f_seq;
+	__u32   f_oid;
+	__u32   f_ver;
+};
+#endif /* !DFID */
+
+static inline void fid_be_to_cpu(struct lu_fid *dst, struct lu_fid *src)
+{
+	dst->f_seq = ext2fs_be64_to_cpu(src->f_seq);
+	dst->f_oid = ext2fs_be32_to_cpu(src->f_oid);
+	dst->f_ver = ext2fs_be32_to_cpu(src->f_ver);
+}
+
+struct ext4_dirent_lufid {
+	struct ext4_dirent_data_header df_header;
+	struct lu_fid                df_fid[];
+};
+
+struct ext4_dir_entry_hash {
+        __le32 hash;
+        __le32 minor_hash;
+};
+
+struct ext4_dirent_hash {
+	struct ext4_dirent_data_header  dh_header;
+	struct ext4_dir_entry_hash      dh_hash;
+} __attribute__((packed));
+
+static inline void hash_le_to_cpu(struct ext4_dirent_hash *dst,
+				  struct ext4_dirent_hash *src)
+{
+	dst->dh_hash.hash = ext2fs_le32_to_cpu(src->dh_hash.hash);
+	dst->dh_hash.minor_hash = ext2fs_le32_to_cpu(src->dh_hash.minor_hash);
+}
+#endif /* LFSCK_H */
-- 
2.52.0

