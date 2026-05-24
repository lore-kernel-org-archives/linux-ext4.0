Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EDA311969
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 20:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779655055; cv=none; b=po104zv+A3sZhu6cHxyNrPuqtODAQ/72Okjgwz9eF9qTNlvbGIRRdTAdCDSsnzGbkI0TpDcniwkjpF+6kYgTJLWLsucbro2dGmqlRvsIbTvlZJpYsRJXevpupotzzN9PobJUR091Mz3OaZUzTl7Cl4ZCuNrVVAbg8Zpf2n/q02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779655055; c=relaxed/simple;
	bh=mxGjt3Zlev4eJ6iQsTebeLW5QjKAg+y8lRSXJCLwSis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzBVEr4awB2BNNHK6NLsYX1Ggbn+1xj1wqLyWtwhDGOtR2Jxsl+so3Hq90FhXLQ8+jN2AKYw4JN3RkKd52nnbMCmeFeUlSEE0nj7GbXDOSjWsL2qEY94goR1/wLy27TeqiW2Ket4yPMywA48nxWPjG/fKfNj1gCqD6h5BJt9SgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cm2/XT8Y; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cm2/XT8Y"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4903fd19957so29601605e9.1
        for <linux-ext4@vger.kernel.org>; Sun, 24 May 2026 13:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779655048; x=1780259848; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pz050xX401BGYEgmGhUdiyyeGpbred/jjTdHHnkxops=;
        b=cm2/XT8YyeI2wvoplV2Z3XAzMRlQGTGnEHGR21WD4IbX3v9pyy76vCsBgrJKJRCzov
         F4+qwTVoBRlYmvrqNg4flMB3zblPkaZzNr3+XmL/cvCC0Y0YI75MMJN9NVHH3s/nv2ql
         9mkJF7CozRhu7pVlsXm6J9pT+Q/Q0PLNRU1ZKFF4mSrsv1nmR3i8FWAN9NTlvByK2T7l
         iESDSrKKjRoh8ebbkg7l4A2kuJ9MG2tWS/M1ACKZdL7oVC1jUrpQSmJPcpCrzhlCvYUK
         /x8OKUSw10O4trvRyB/eCjqekptMjxxxwHpDoVLcIGu8upzRZViCccR30b+xPImBlPNU
         tPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779655048; x=1780259848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pz050xX401BGYEgmGhUdiyyeGpbred/jjTdHHnkxops=;
        b=VzPHQ/WU5nyv3XVKFw0RIysrC10+yEV36YHzXrdiMJ8goJvdHEfH5byGpF51WZuiae
         PucYmsG/HTJei5xehbYFXsrCfp16zfJI+eKhD1Dsrj/2+I1xDko0r0hOdGWk93dwuxOo
         STArleO8fWVJH3OZlafuIysvw9MK2rvu7Pi2z6mRIVSXLB424XzhIx0QpZquwM7bu0Q5
         tBZhMO4fGqaqJpplHXbdSIs/7Q0kMU4ATDTXeL5JuP04UWPxAafb9/TUsKrzoOIPGCok
         6kgQ3orUI71PqzNwUfMm610fsUsW233wD34GdigNxOaFn4IM5NK7C4LkszNTpmfvuCC5
         I5eg==
X-Gm-Message-State: AOJu0YxUQA3DbJbtteYO9vPKebq9hCS4nSogF0B1fMOCwpr+nYMnJpSj
	o+sTdScEl3nkWpOMpynYNH8Y/nRDIsVpi1vfmsrhNS46f3oCc/qPeamloNBbsEQY
X-Gm-Gg: Acq92OFrg2o6DlCdxkdGAn/uqQtBbFEfqw3eEOEKhI7PvB2l8v5ZdtDnSAv83iWb31g
	mnqHHT6/YU0g3670zaNJq2+VKeGucgipTVBz1SV8XnmO5JxR0blglFqkZWOpNHIa3ZDEsiDAh0A
	V5ai8T9ixkhp4sC8xnpQhCqLj36dVm0QnV0riLBWBTm8sPC3RdIhpAM/Wjxs5dpFAgUdMlPNy/4
	X944xZyD+1fK8tRnQ59ad7J3YNdCIfA9f4WWx2+T2w71JaHcgc147FuASE4IWobl1s6CjXuoxBs
	q3zIA0djp1Tei9D08BWtZ3GwFudoHIgyfnvppSiNZUGUa3xB7tiHuUqnjgUcaseFkcLVTgdXdZn
	Ktgnx52ozdYDbt/KZhnmUT9OGrIHGt6PT09lfExg/PAZNfqBfWpBs1ZeXRFaEGkybUww7KNrJKQ
	rNktddLWascOJOXXHUQ6ACFoz81Ub/rKLDFQdJQQxc
X-Received: by 2002:a05:600c:3e12:b0:490:40f1:5314 with SMTP id 5b1f17b1804b1-49042482845mr206667675e9.1.1779655047916;
        Sun, 24 May 2026 13:37:27 -0700 (PDT)
Received: from Cluster1.local ([2a00:23c7:90c1:9201:ef47:d559:d907:fd0b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904526ca50sm187279145e9.2.2026.05.24.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 13:37:27 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 03/13] ext2fs: dirdata infrastructure and core functions
Date: Sun, 24 May 2026 16:36:48 -0400
Message-ID: <20260524203658.12406-4-artem.blagodarenko@gmail.com>
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

