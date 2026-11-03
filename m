Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713853;
	b=kTj7tqZU90F2+fME/w9cLKU/bRNdjztobz0yFYrkX48RGdSRR0o0H79Ic+TCxE3vJHYd
	 hq8C8j4PEvImBQb1UUc4fwHOc0yVhTADRLqUZQqX6k+hJZGfZaeaSkSPY8VOfYjkXWqzg
	 YQX/WOIC79fdjQ+HvtMul7XujSETbF6BSOMW7ntT5pBfKZNyA5RRDnBxvmbTgBp80l6G8
	 y2wMZH174wA7MBdWjXGVceK7U9qPBNWeuopW7JgPLPTjCcOsr1RzAVgUV9l2pDo7Vf0UM
	 d2q0vKH4RvO8I4hjo/4wki2ILqbrt2gXcMMpzsnlFGZXHdakw4uUTeF9nGpWpUNedzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713853;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
	b=zNzghdUaxM4QGlZ4xPaq4LbERuyLLTwZsMFygL7qW7PYXqJvMpD7HW/XI2pR/+VomGVw
	 oC1m6FyVFWmjPUaKTnSkm5YqTkPQ6nS/qmBEizcXiPWGQsx6W04k9cXHfpi8en+afzXUd
	 18EGUDStMc6yhcatCNIRt6FCk5CUyVxh+RJApUA0qkM/feJKX7Y/txNQJevlGgl+i+Eqt
	 FY5sXuomDcIxXCKxo8NkbKmr53BgxT6H4eC2tEUnTkSTUKDvMzrbLJQIZ+mY/Mtd5XxaE
	 AxuK2rM/AyY6EKrzrjgDSE9vX8q70TR47xMM0a3wzkTPPXsMI4jf2a3osJSVpDs/A/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PsLFpnkD;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBA606D83B
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81EBA606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PsLFpnkD
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso42317615e9.3
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713852; x=1794318652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
        b=PsLFpnkDf7vu0jNwz9IoM6oeXaHtSOOIlPZ7PruaHa8wqvW3h4Eh2ne+kxtLVSOQ7/
         eCZOWmD77Mq6dnMNKeqYSZyv384tBWDbkQNHHgqCJ6JOcWoThQLxFSVwFfJTUV5sfpiI
         nTYrpDhEZw8rF9e1DVWZks8mnYqxRqHrHx05S0Srtv5zFdttNAqXJWr+l3Mmc9SYAQ1H
         826QXDr46F4W9O752Pez9Z1z9gTOKQlTFjJYGT2V7MlSfORKHnOhYCUEpd4w+hsZdAvz
         C5XVqmX+UL1ci6PVuNWZGp3xpaJPdVTLtBcSWONI/88sXGqxYF3tX+FGWW0h/lYMvKLI
         O1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713852; x=1794318652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XfVsJgHMFyKDIEGwUeNHPkk/sGiInpFAv4tX7Kdk/L4=;
        b=CnPYTQNOBzrO/Jme8IPMX2ANTH5lJjWqn0PyTXpGNegKxfBVb/i2wqhryf+yZU4Rxg
         KvMkj7HvwCacQhMYmxr2Y2ZBN8ZxQo6Z/H6v+b9itMYxv3b93mV1Pom5rlzrwPO9sn0t
         wPsUR3XtFJI+85z0fG7rXgkgtR0So65mO66evKeN502BQKpQQwtFkkB5i1TRttnnW8T9
         6t4s1tJREdYozRZ+nSwdI/YjFHJTCe7FRXrhyj/HXmz15HdJG+VF53gGNIgvRcU1c53N
         YVGp/xO8ALj1Csmpz75CjDwnnkL7UsaVHUBGalUREDLmI+gW5939w57C2EpG6UXKzhgB
         /tNw==
X-Gm-Message-State: APuU4Z8KPF/aE/UT922jcIxQ1o2EH0N9vfhLfMt1bcrZWJ9ssN0yqfp5
	VOmVRUNt06kfpvtP9JAQSHNl6UTVziOzpfmt9DyhfJmLi/bX5OW8yv2B5YfW59rV8Bk=
X-Gm-Gg: AYBFou07ANc6WAVC/Jb/SLAzD7fGX06n+ocTpM7Hur2bM9e7qm+4hrxQ9wefZ8LqA/e
	dcS3kgD1+5yu77pN7wSK7/e1c8decGHB1C/js+2WfU9ktcHVMZ4TxAya3rhGb3T8iX+YmPLoy1X
	N1P9L5HTVqfrvNR5T6gVM+3Fs/ksRBJmiaPi+PIjbOheo8vmDvK0yqRG9AnAeHcHPqY0QBKvPB8
	SOacz3aPj/Hy7OfrulDm73YriTn2I0d61Ihi9IPcrGRUx/1FqShSbRh0wYQkARcZD9ZBVHdCyyw
	wvkkPKAPPtgdBvGGC7gSci0GYR4P4vNFBcILSBBJ1U/U9sQTmwHl91mm3NCV75HZ6EkqmGJCo3Q
	HS+hoMRY0spI2eLxQkIRZT3fNIlGTRIfpWK5K2p/2eJocOzb8hKmGPh+VicDBy081yrVlea7dGp
	kh2iVqkXeyV8coaIabH/inSS/IuBamr3qLYU49B/zI6i1hNZBZ9ua6u0/sIV2G3wRoTsa49CWO8
	EqZvJLyHYuNC6w4BkzOOh0kiu9WaU9Wd8Q/q42XvF2I6lRAa/e7LfgDh6L3JapUiVG76daGE5iC
	EEQUc7EDTOgaiz5Gg6nO4IMjXDSL74dC+QGObtBFN8uxbn5yh5lIGM35NIxn
X-Received: by 2002:a05:600c:4e11:b0:4a0:eae0:769a with SMTP id 5b1f17b1804b1-4ac185bc7d0mr292124075e9.28.1793713851899;
        Tue, 03 Nov 2026 05:50:51 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:51 -0800 (PST)
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
Subject: [PATCH v4 03/13] ext2fs: dirdata infrastructure and core functions
Date: Tue,  3 Nov 2026 13:50:27 +0000
Message-ID: <20261103135037.610132-4-ablagodarenko@thelustrecollective.com>
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

