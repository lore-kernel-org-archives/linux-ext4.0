Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B259F3ED11B
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 21:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785186815; cv=none; b=pkL3s9OI321ZCFF53iJjQq4TDlh+sTe6uZZf47ZqkkTp4qrM0iKLZ8M83b/57CllGSUaf9sZ44DvDoQ2C4L/7EXrDfC/S9Sd/UiaLgWl/Im5+NeC20QXTewtUDtmmQ8M7SrUY5RQj2vjyNcEtA6SH43AZ1rOMtUhCc1N7lozC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785186815; c=relaxed/simple;
	bh=SFS4KTaNjP43GEo84W3dmgT5BD9WMreBx2ZNSNMJclo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWnCVa0H6Zz99DRGwwAV+gbLJRXRJI7V1DpfA4ZMqCVO4DnpaDjV/s1kGxfP5Ub3PGsiI6nSEmG0b7NrSJylRkkHiMSYH+LmR2+++cMULyQuCafDptalEhU5VGeualRxLDEVciD5NCbPnx1ImLR/Sd8AnXbr8I+kjDQ2w0+c4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jf1Fv7bE; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jf1Fv7bE"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so34353255e9.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 14:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785186812; x=1785791612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F7FM4fCWcFADqh/QMTWVQ2aYK/6QpQQvnSwtEe/df5s=;
        b=jf1Fv7bEzXYa7stkl2Dr68Nr5ve6tzoxYyICPYL+/DqPePznQpOj3FVNwwHV9jo5/w
         Fi+fd0SaXU/C7tXOiDvm5NB0ck0cAFVaGaB9mJIbXFRUXcAYpZSOGic9832/1G6aUycr
         bBNUThythJ4hUqG43NQI0wIdmDZxKsfuNSWMCI2lZTC5xxTs2n53z305icmK56ICFufZ
         mwen7zEFbq6M3cL5M5U1O2o0K5n/edq6RKCRmPPJypYLSzPewcuBG72IgHwSVk0Pxgmc
         IkyrTKcF5jIBI+h9XSCbtc4F9CEQX49VkErtlrkE98tI74X7xMz3Avi+z5w7CY/pEoyC
         4Cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785186812; x=1785791612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F7FM4fCWcFADqh/QMTWVQ2aYK/6QpQQvnSwtEe/df5s=;
        b=WpBW3EMY+4N2d7HQu1Gvu3v19Bfwkx46LRJ5/uvwez3ulCCOiQAtDPHEPClP+CKHKZ
         M0lIguNBLaVYeM1adESkr0y1lqcxnIBkETkHKPLUNw00HG3kcx283nfi7yMzgpK5UGDU
         hQ6PEXWkz0zz97gnTGujf2i+5VlIiStHYtU9SbqIAZfHgWXIO6RB6qVrC4i6O5O9Llv4
         7rqBslLNtiAoYAEhIkRdeMnyqYF1n14nvOAXZhL8nlSjeiHrkyNPsZUxtqun0Ju94+bi
         yDnQtrSVDKaJ6jvACckNYEGe4hpDwKMZKCUKbVlPyuT9Dg6s7D5Do43u2moAW0yXw2/V
         3+FQ==
X-Gm-Message-State: AOJu0Ywb5rvg1rMpkZzm+7vpISvz+e19QQlJFAijuTLzmao0oR4UaMQn
	aO/KZvS9a/HoLtXCxrdZTg1C8/CwEMwz3GUUFLNNbHdCw2HVObxAqJ5BLPvt7Pg7
X-Gm-Gg: AR+sD12don5ntfOSF7FDUjvqXB13qnlJtCxJU4j/xhbEr5H0cZlwHpFFGy7z0gkjtCi
	VotXnGIIG/UD5gfqHr00kaTrJfPJHa8eQGeCV99tQDaGsSMmn59hwJ6mIrDnKjJurzua+qLaG3J
	zmDlfGQmbRBJF7U2FEN5eA4tQtWe1UZnWJdiMnSkwvudm+oBiXhfDyfeA7FsFhW0JDtsMblnfoy
	728nwW+y/5tivjVfBp0sdR63jHNIdzw4G5/MkMHOq2LJQQUZZCOg5U4b7LTMNeinfBNB6HZ3cpQ
	7KzmuglEpivOuNi4KIjSdAoG5+3TyCJ9yi7ZSK4rguYdQKZzSRSvArNqsbHB69Tc7GSQcj6bZ8S
	qZnwMpn2BO1RBiX4ZEpeELOUVkvn0X/UjgvAWGxReFU1EG97HhMlmOTapxJCXicYmTcso/pUbq1
	+yQr8Yo+zDvjceMuOHxRorg0L4UPwPBCKBd7/Wy/b4w3yE
X-Received: by 2002:a05:600c:8b47:b0:493:f176:dc69 with SMTP id 5b1f17b1804b1-496b572e886mr139358165e9.37.1785186812016;
        Mon, 27 Jul 2026 14:13:32 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm270073775e9.1.2026.07.27.14.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 14:13:31 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 03/13] ext2fs: dirdata infrastructure and core functions
Date: Mon, 27 Jul 2026 17:13:12 -0400
Message-ID: <20260727211322.19686-4-ablagodarenko@thelustrecollective.com>
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

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a4141eb71..73e93f9b9 100644
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
index 374b8289e..91d269865 100644
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
index 000000000..ec763f720
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
2.43.7

