Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9583513578
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472971; cv=none; b=i9wHbrSfR+CEvH/ZkvRvqISfOfvm0z4ooWNApoBqRH9HegYpEU7pG7Q0jwxExxO/TLzixO/HMGQPOxnXH8AunMkXRhTVdDk5tKtEfJ35Fo0+ooJCIPhK4xU/j4hXt0vulsb4Jnrj/j+QWwgqIw2NCNzZXkkdmz5vf/Gxbf72pU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472971; c=relaxed/simple;
	bh=SFS4KTaNjP43GEo84W3dmgT5BD9WMreBx2ZNSNMJclo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EN3JZMYDrQeXgJSNvMVFPAouXhEBt8o8pcQeaezr0IuPtxNTZuRxJsyBGAVuNbK+fmIxbveDLegkWmlie9iay8UC07GmLQKVbXHfzLiS/JYi7aFbuejIkcgbhhJfY/R45CcBtQObzMapp6fBHE2Hj9UpNStylcG7t0hOxgRqHRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BH9WVztG; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BH9WVztG"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49b8ce9b733so3346965e9.1
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472968; x=1789077768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F7FM4fCWcFADqh/QMTWVQ2aYK/6QpQQvnSwtEe/df5s=;
        b=BH9WVztGlRQOVryjQFauUMdkJEHeovsEJo+jyJn7s+w4qvQt8VzHgZpYhNYO+LZo+9
         fWwgjiXblxNHiv6+mvWfY5jwFavpG4sgZwlesqEudC2JE98o6J2F/RirRNlXzOxDbO1R
         h7gsShx2BNoK4kwPYM1Ub4rzLeOjHgFF3DKxdLeUswiZpETxWFjPD0J+HRT2q96O2dQq
         8AReM/lMBCPZ8IrQphABnpV6Pf3VxRgie7H4gg5uPeNFK/nheBqsTrm6oqh4IUKnJJIy
         PYmsd2dUtaJbtIblP1KdpmbDEgHOIzt/dj4lG5kMNvr/nq4TzTSVetG2RPuj/f0zp+th
         Bxew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472968; x=1789077768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F7FM4fCWcFADqh/QMTWVQ2aYK/6QpQQvnSwtEe/df5s=;
        b=Qhk02MAPoCeVgbLnpkOyABeoiN0LxbuvD92YFQ2TYycDFKNpgt8WpCbyVXK2WUgxPi
         16xJovjkv7X7pB+ForJjE3X2vQ9LiqvYLQnGVN/2cjDp4/b6TjeDBA2Q6qQNELmd9r35
         DwMEHz5wYyrTtmfB0sdIEY0YIyx8wxxDWEZ84RaTjk4iGoqSJJAaoGVxlFhqpnD4oMRa
         THTRNpnMca+IIYyOlWu+UJj3Bc1btEBazzu5bxr9w/IDo0e/gwP5at5h/y74zVix4zDY
         cIgMe1dY6gC7d5bonx+mDWiWHXceVZfvHYfp5KMWlTKW3AeZh1jvTHH44nb+/udMuC73
         P1DA==
X-Gm-Message-State: AFuF++n1A8aqi9Si645bd14qJsHSRCq1kwNOQTtHmbsE+4/2DgqnCI3U
	I33CtV+g5D6CPIYA8dr/24GAdrRPpnvY4kh2TtIhWEjjJy1d/vKUFmDxEnXuJWQQ
X-Gm-Gg: AYBFou3skoYvba7sYfc4dFuMGUufumTSAn6ctLVPnCTxmQEVp100S73E38qDxn042cM
	o0GOJ1xJK54Ke5IOpq/DGYRd36QEAfBnBnZDORu3XUozFsorM5IHEtf6fIaEsYJj14MUjmAkpZe
	cFr6p5IWgOlLKTp8rezV5Bq8opRrZ3glBdnekOR6V4votJwx/9gIWe6URx95IEsa17KOUuB6JmA
	+yJuOtHEdRwpXJMVlPQRP+KDrd2ctUdu2HuFwKMxdfK3ocsE057EuHgH5aZ30mJg7wsUBl9KdjF
	xl6Ka3ti0MLUkEUV4xnTb/rrT6KQoj8yNtpdeQUmxSdekMT3lZwdYpJ/kWeFnZysFj3HnAX6/Um
	skpdaF6icFgicLKuOXTMQ8NysD5Aii7doBmrHPYEKCQMRG7D1y28mCUewWadaSTaMQJjXNz+0qy
	hDcUu+wc0uhHEL6ST05AKiDU4CVwio5TfkidUN0XsCun/H3i2Doxt1AcSwhUsfU5l2iNj8xaaj2
	qnmfMhHZQ18S+WnsG5I
X-Received: by 2002:a05:600c:8b32:b0:49b:d03:8d3a with SMTP id 5b1f17b1804b1-49cf8244878mr17889895e9.11.1788472968179;
        Thu, 03 Sep 2026 15:02:48 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:47 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 03/13] ext2fs: dirdata infrastructure and core functions
Date: Thu,  3 Sep 2026 18:01:36 -0400
Message-ID: <20260903220146.19752-4-ablagodarenko@thelustrecollective.com>
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

