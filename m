Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713831;
	b=WlUYLvmswBibtcNYPKfznKBYGi+tMhBzKGHfJsp+EHQ+Apjqgs9WUPndbhaIjzhz3XVf
	 u1xIxlrCQyRmrrnKdAxe0pym2e3E/6L/9z3k8KqhvfowYH0TEI/JbPVCKLlLQmDi3oFWw
	 NR7s2C8xD9z5mFm3eDCR2Hrhz8E9onT+ptMKUsL/V4awrnpstNt9OILYuYRAWbYMKgP/G
	 KhcO+Ru9IPQomTr0/8Sv5Nr+LnAEdsy5t7JHSRV9/zldq2FDyWa+Tdhvx9+8l2snx7u9M
	 IALUD14KbHg9tYtdPjnf+hLrK1W41vWCQKPok/k8XhYqJPZYgAcvHfta9Xhe+DZamHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713831;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V2MxoDoEJQL5X2Rcu0PPCrP421S2w5iwAbdv7sbX/MA=;
	b=OyelsEOCpm9ypNIUjpg7t1AGAbntotT15rT1xwfUkjiUzwlFEWWOWjF565sN1Ep7BTSj
	 griDy8YGOf4QMDmb/HYjtn/B9p6pq9kF3UYLcfyDkHxrAzjS8hRRWomk2q1W2eslCOjNC
	 08DCp4yUEBjHLtamPi+rSHL+5k+x14+wwxhqjV13Fath+92/TApYQVlYJ3BPXVPlgeu6N
	 toDk6X6Q75XXzOzqW8A6wpxO7HTtB7At7eYDGf1hMSfaSg1P7Olz0f4w0IHnk6s5NpWCN
	 xYSKaFmAni61t4Rsjbb1QdoROl7id8HdWaCDNR8YySLILAzwjSeaZgUkJyjRMcnAzqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0IT3EDXa;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34AB606D811
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A34AB606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0IT3EDXa
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so42498555e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713829; x=1794318629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V2MxoDoEJQL5X2Rcu0PPCrP421S2w5iwAbdv7sbX/MA=;
        b=0IT3EDXatM7Pf0btu6J577JqtNjuwF/tSmrmpyS0LDQOH7jh19EYF8dY6rXqaDbX3s
         pd9TmxNmrWMYSmj5SYYBIizYk+3zq5oBswZcEeDbqFyWl6pWyiCNlRFyrmpUP15VuLHN
         4+nbuHqixpDVYomlNzt7HE4VqKwpoZXT8CDppCIMJUaHchfYvOhNgJFEAwhJJZ/toW9N
         6PeBNnbCKXwXfI69C1Z1K0FdynsPq749zhKQDopry9lkjgyc7QfN4xFxDRTIXKLbCNXI
         l1T8j1sQnPAVgLrx4nCLiNqcWTA68NNQvwDYSNQKjjcn0s72LEQzVPyBmAJJQsOA+ED0
         LXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713829; x=1794318629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V2MxoDoEJQL5X2Rcu0PPCrP421S2w5iwAbdv7sbX/MA=;
        b=2Zs8t2FQ52mnsLRupBKdjIFh/55QcCUNu1aOrrlWc58qtDtGWCADZfEiTC22953lHA
         Fz5e8RF6wRAo7Nh2ow+yoXoTEtha40qx1qlVkm48PsoymomOTu0DUSPoacBhXicDrwry
         ZVk0HL7MxP/AD99APaqZmRB9S3QXY2ULYxPDWyuZ7OIOc2SHh0mP+fojhtlS1wFMXZm9
         tMU4AC1HV8jxSi6RQWt9sr0Xs+a08PYcYTYlz0oJ/+urI/FArGxHxRPsV4Fyy4/UHiuo
         jEg/kjfp/mquIjGLDAksMgYdvfQlqxU5E1IrQ57LgtEmdivyZUjNb51teLYarYB0U4rB
         lsqw==
X-Gm-Message-State: APuU4Z/trhwxvrr2+ndbHvGmbpKcTvxImDm7Xu0edEczpHuhwQUrodTB
	CGoCN01CT5yvS6L+UQrulpLFhMFmszAUGuSL1VnU+j0J3GdBei67kqqxi6EotGCFSDA=
X-Gm-Gg: AYBFou0pYLF01Ob9YUY1BYBbAQUUSXcxbakuYAlhxvFJt+7KbUcKNHDO4xlhxcZZyse
	n9uZoHaYy+bX+4btOftte1byKxd7oPDHTdfq10R+dEpxJvXLhq+0ZqSmnYn4eslyA/O2dWgAZxf
	t6Hbbsyq39d4IoUUCsI+Rtvpmjr8J7QQQrKS7zsBOl3LqO5M9MsZ5LI7HLvmGE3kefm7LYxAQ7p
	F11nL5ei2IIyXetcXtrRJnCT/HZjO2/fs9CmFIaYr7PPlUM6b3DM5QFbtLx24eWHcrfDDUKCVat
	gzM8ZWLp0M+9o7hpPgkSaqfgHJ6kUiIhwW/KrIR3gpA4uHnb/qcQqzmw9T1uQf8fdH4gXWQG5Ey
	Yqhya3NMJqRpEwLJHOQoe69VXJ97eJw68aLVhD9nIXg6wN7zH8RjLdEBpD+zxPLcuyR0StnWwLS
	7TpjEc3z/ZTDHu1dPd+wYtAJ7nt9vhbxleLB3KRiHXYhOViJKxXkX8LH0FVnulQ+LY4he7bZMIl
	xKBvdtHL9x7xQfrF8d70HsraKGfGJrybkUdCCTflSGQeZmiV7KX6vJCZD8J4FPsjLvU+66k8Z94
	fOVvOSpPeTuoL1To7cXc/g+nDJL5Im/uMfZgKrxY3pjhDGkJUWN8azGe6s3m82k2fhdtLOWUGMo
	wKRve6g==
X-Received: by 2002:a05:600c:1385:b0:4a3:5991:718 with SMTP id 5b1f17b1804b1-4ac182dc0a1mr321834735e9.16.1793713828841;
        Tue, 03 Nov 2026 05:50:28 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:28 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>
Subject: [PATCH v14 09/12] ext4: dirdata feature
Date: Tue,  3 Nov 2026 13:49:16 +0000
Message-ID: <20261103134921.610047-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
References: <20261103134921.610047-1-ablagodarenko@thelustrecollective.com>
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

When fscrypt and casefold are enabled together for a directory,
all ext4_dir_entry[_2] in that directory store a n 8-byte hash
of the filename after 'name' between 'name_len' and 'rec_len'.

However, there is no clear indication there is important data
stored in these bytes, which are only for padding and alignment
in other directory entries.  This adds complexity to code handling
the on-disk directory entries, and there is no provision for other
metadata to be stored in each dir entry after 'name'.

The dirdata feature adds a mechanism to store multiple metadata
entries in each dir entry after 'name' (including the fchash).
The unused high 4 bits of 'file_type' are used to indicate whether
additional data fields are stored after 'name'.  If a bit is set,
the corresponding dirdata record is present, starting after a NUL
filename terminator.  If present, a record starts with a 1-byte
length (including the length byte itself) and the data immediately
follows the length byte without any alignment.

This allows up to four different dirdata records to be stored in
each entry, and allows unhandled record bytes to be skipped without
having to process the contents, providing forward compatibility.

If and when the fourth and last dirdata record is needed, it is
recommended to further subdivide it into sub-records, with
the first byte being the total length, and then there being a
second byte that gives the sub-record length, etc. as long as
the total record length is less than 255 bytes.  However, this
would not affect compatibility with the current code since the
record length would allow it to be skipped without processing.

Signed-off-by: Pravin Shelar <pravin.shelar@sun.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/dir.c         |  22 +++++++--
 fs/ext4/ext4.h        |  79 ++++++++++++++++++++++++++++++---
 fs/ext4/fast_commit.c |   1 +
 fs/ext4/fast_commit.h |   1 +
 fs/ext4/inline.c      |  29 ++++++++----
 fs/ext4/namei.c       | 101 +++++++++++++++++++++++++++++-------------
 fs/ext4/sysfs.c       |   2 +
 7 files changed, 186 insertions(+), 49 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 38911ae2bcfc..15816f2a5f47 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -483,27 +483,43 @@ void ext4_htree_free_dir_info(struct dir_private_info *p)
  * The decrypted filename is passed in via ent_name.  parameter.
  */
 int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
-			     __u32 minor_hash,
+			     __u32 minor_hash, int buf_size,
 			    struct ext4_dir_entry_2 *dirent,
 			    struct fscrypt_str *ent_name)
 {
 	struct rb_node **p, *parent = NULL;
 	struct fname *fname, *new_fn;
 	struct dir_private_info *info;
+	int extra_data = 0;
 
 	info = dir_file->private_data;
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	new_fn = kzalloc_flex(*new_fn, name, ent_name->len + 1);
+	if (dirent->file_type & ~EXT4_FT_MASK) {
+		unsigned int rec_len =
+			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
+		extra_data = ext4_dirent_get_data_len(dirent, rec_len);
+	}
+
+	/* exta_data contains +1 byte for NULL */
+	new_fn = kzalloc_flex(*new_fn, name, ent_name->len +
+			      (extra_data ? extra_data : 1));
 	if (!new_fn)
 		return -ENOMEM;
 	new_fn->hash = hash;
 	new_fn->minor_hash = minor_hash;
 	new_fn->inode = le32_to_cpu(dirent->inode);
-	new_fn->name_len = ent_name->len;
 	new_fn->file_type = dirent->file_type;
+	new_fn->name_len = ent_name->len;
 	memcpy(new_fn->name, ent_name->name, ent_name->len);
+	if (extra_data)
+		/* Dirdata bytes lie past the __counted_by(name_len) bound but
+		 * within the kzalloc_flex allocation; use unsafe_memcpy to
+		 * avoid a FORTIFY_SOURCE false positive. */
+		unsafe_memcpy(new_fn->name + ent_name->len,
+			      dirent->name + dirent->name_len, extra_data,
+			      /* within kzalloc_flex allocation */);
 
 	while (*p) {
 		parent = *p;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e42e5bcc2f28..4a7b36e1910e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2369,6 +2369,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(casefold,		CASEFOLD)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_EA_INODE| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
 					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
 					 EXT4_FEATURE_INCOMPAT_CASEFOLD | \
@@ -2639,6 +2640,18 @@ struct ext4_dirent_hash {
 	__le32				dh_minor_hash;
 } __packed;
 
+static inline
+struct ext4_dirent_fid *ext4_dentry_get_fid(struct super_block *sb,
+					    struct ext4_dentry_param *p)
+{
+	if (!ext4_has_feature_dirdata(sb))
+		return NULL;
+	if (p && p->edp_magic == EXT4_LUFID_MAGIC)
+		return (struct ext4_dirent_fid *)p->edp_dfid;
+
+	return NULL;
+}
+
 #define EXT4_FT_DIR_CSUM	0xDE
 
 /*
@@ -2754,6 +2767,8 @@ struct ext4_filename {
 #if IS_ENABLED(CONFIG_UNICODE)
 	struct qstr cf_name;
 #endif
+	/* LUFID/dirdata payload to embed in the new directory entry, or NULL */
+	struct ext4_dirent_fid *dfid;
 };
 
 #define fname_name(p) ((p)->disk_name.name)
@@ -3065,7 +3080,7 @@ extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 	unlikely(__ext4_check_dir_entry(__func__, __LINE__, (dir), (filp), \
 				(de), (bh), (buf), (size), (offset)))
 extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
-				__u32 minor_hash,
+				__u32 minor_hash, int buf_size,
 				struct ext4_dir_entry_2 *dirent,
 				struct fscrypt_str *ent_name);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
@@ -3074,10 +3089,18 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 **dest_de,
 			     int dlen);
-void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname);
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de,
+			     int buf_size,
+			     struct ext4_filename *fname,
+			     void *data);
+static inline void ext4_insert_dentry(struct inode *dir, struct inode *inode,
+				      struct ext4_dir_entry_2 *de,
+				      int buf_size,
+				      struct ext4_filename *fname)
+{
+	ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
+}
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
 	if (!ext4_has_feature_dir_index(inode->i_sb) &&
@@ -3334,8 +3357,14 @@ extern int ext4_ext_migrate(struct inode *);
 extern int ext4_ind_migrate(struct inode *inode);
 
 /* namei.c */
-extern int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode);
+extern int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+				  struct inode *inode,
+				  const void *data1, const void *data2);
+static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
+				    struct inode *inode)
+{
+	return ext4_init_new_dir_data(handle, dir, inode, NULL, NULL);
+}
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
@@ -4278,6 +4307,42 @@ static inline unsigned int ext4_dir_entry_len(struct ext4_dir_entry_2 *de,
 		   ext4_dirent_rec_len(de->name_len, dir));
 }
 
+/*
+ * ext4_dirent_new_data_len() - dirdata length for a new entry in @dir
+ * @dir:  directory inode
+ * @dfid: LUFID record to store, or NULL
+ *
+ * Returns the bytes of dirdata records (without the NUL byte after the
+ * name) that ext4_dirdata_set() will write: the LUFID record, and on a
+ * dirdata filesystem the casefold+fscrypt hash as a CFHASH record.
+ */
+static inline unsigned int
+ext4_dirent_new_data_len(const struct inode *dir,
+			 const struct ext4_dirent_fid *dfid)
+{
+	unsigned int dlen = dfid ? dfid->df_header.ddh_length : 0;
+
+	if (ext4_hash_in_dirent(dir) && ext4_has_feature_dirdata(dir->i_sb))
+		dlen += sizeof(struct ext4_dirent_hash);
+	return dlen;
+}
+
+/*
+ * ext4_dirent_new_rec_len() - record length for a new entry in @dir
+ * @dir:      directory inode
+ * @name_len: length of the name
+ * @dlen:     dirdata length from ext4_dirent_new_data_len()
+ */
+static inline unsigned int ext4_dirent_new_rec_len(const struct inode *dir,
+						   unsigned int name_len,
+						   unsigned int dlen)
+{
+	/* With dirdata the hash, if any, is a record counted in @dlen */
+	if (dlen)
+		return ext4_dirent_rec_len(name_len + 1 + dlen, NULL);
+	return ext4_dirent_rec_len(name_len, dir);
+}
+
 
 extern const struct iomap_ops ext4_iomap_ops;
 extern const struct iomap_ops ext4_iomap_report_ops;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0cac890cf370..876a863d6c01 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -2686,6 +2686,7 @@ static const char * const fc_ineligible_reasons[] = {
 	[EXT4_FC_REASON_MIGRATE] = "Inode format migration",
 	[EXT4_FC_REASON_VERITY] = "fs-verity enable",
 	[EXT4_FC_REASON_MOVE_EXT] = "Move extents",
+	[EXT4_FC_REASON_DIRDATA] = "Dirdata LUFID (not recorded by fast-commit)",
 };
 
 int ext4_fc_info_show(struct seq_file *seq, void *v)
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 2f77a37fb101..899faeb4e6e0 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -100,6 +100,7 @@ enum {
 	EXT4_FC_REASON_MIGRATE,
 	EXT4_FC_REASON_VERITY,
 	EXT4_FC_REASON_MOVE_EXT,
+	EXT4_FC_REASON_DIRDATA,
 	EXT4_FC_REASON_MAX
 };
 
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index bdf6f45a3de4..81e0ef1c8833 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -984,12 +984,12 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 {
 	int		err;
 	struct ext4_dir_entry_2 *de;
+	/* fname->dfid was set in ext4_add_entry() */
+	struct ext4_dirent_fid *dfid = fname->dfid;
+	unsigned int dlen = ext4_dirent_new_data_len(dir, dfid);
 
-	/* 'dlen' reserves space for dirdata extensions (LUFID, CFHASH) in the
-	 * slot.  The dirdata types are defined in the next patch; until then
-	 * dlen stays 0 and ext4_find_dest_de() ignores dirdata overhead. */
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de, 0);
+				inline_size, fname, &de, dlen);
 	if (err)
 		return err;
 
@@ -998,7 +998,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1276,12 +1276,14 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 	int err = 0, count = 0;
 	unsigned int parent_ino;
 	int pos;
+	unsigned int de_len;
 	struct ext4_dir_entry_2 *de;
 	struct inode *inode = file_inode(dir_file);
 	int ret, inline_size = 0;
 	struct ext4_iloc iloc;
 	void *dir_buf = NULL;
-	struct ext4_dir_entry_2 fake;
+	/* zeroed: without the filetype feature, file_type is never set */
+	struct ext4_dir_entry_2 fake = {};
 	struct fscrypt_str tmp_str;
 
 	ret = ext4_get_inode_loc(inode, &iloc);
@@ -1337,14 +1339,24 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			de = &fake;
 			pos = EXT4_INLINE_DOTDOT_SIZE;
 		} else {
+			if (pos + EXT4_BASE_DIR_LEN > inline_size) {
+				ret = count;
+				goto out;
+			}
 			de = (struct ext4_dir_entry_2 *)(dir_buf + pos);
-			pos += ext4_rec_len_from_disk(de->rec_len, inline_size);
+			de_len = ext4_rec_len_from_disk(de->rec_len, inline_size);
+			if (de_len < EXT4_BASE_DIR_LEN ||
+			    pos + de_len > (unsigned int)inline_size) {
+				ret = count;
+				goto out;
+			}
 			if (ext4_check_dir_entry(inode, dir_file, de,
 					 iloc.bh, dir_buf,
 					 inline_size, pos)) {
 				ret = count;
 				goto out;
 			}
+			pos += de_len;
 		}
 
 		if (ext4_hash_in_dirent(dir)) {
@@ -1366,7 +1378,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, hinfo->hash,
-					      hinfo->minor_hash, de, &tmp_str);
+					      hinfo->minor_hash, inline_size,
+					      de, &tmp_str);
 		if (err) {
 			ret = err;
 			goto out;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 0c91e4da00fb..4f0465d49887 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -402,23 +402,33 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
 {
 	struct ext4_dir_entry_2 *de;
 	struct dx_root_info *root;
-	int count_offset;
+	int count_offset, dotdot_rec_len;
 	int blocksize = EXT4_BLOCK_SIZE(inode->i_sb);
 	unsigned int rlen = ext4_rec_len_from_disk(dirent->rec_len, blocksize);
 
-	if (rlen == blocksize)
+	if (rlen == blocksize) {
 		count_offset = sizeof(struct dx_node);
-	else if (rlen == 12) {
-		de = (struct ext4_dir_entry_2 *)(((void *)dirent) + 12);
-		if (ext4_rec_len_from_disk(de->rec_len, blocksize) != blocksize - 12)
+	} else {
+		if (rlen < EXT4_BASE_DIR_LEN ||
+		    rlen + EXT4_BASE_DIR_LEN > blocksize)
+			return NULL;
+		de = (struct ext4_dir_entry_2 *)(((char *)dirent) + rlen);
+		if (ext4_rec_len_from_disk(de->rec_len, blocksize) !=
+		    (unsigned int)(blocksize - rlen))
+			return NULL;
+		/* de->rec_len covers whole dx_root block, calculate actual length.
+		 * This is the '..' entry, which never carries the casefold+fscrypt
+		 * hash, so pass NULL for dir regardless of the directory's flags */
+		dotdot_rec_len = ext4_dir_entry_len(de, blocksize, NULL);
+		if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) +
+		    sizeof(struct dx_countlimit) > blocksize)
 			return NULL;
-		root = (struct dx_root_info *)(((void *)de + 12));
+		root = (struct dx_root_info *)(((char *)de + dotdot_rec_len));
 		if (root->reserved_zero ||
 		    root->info_length != sizeof(struct dx_root_info))
 			return NULL;
-		count_offset = 32;
-	} else
-		return NULL;
+		count_offset = root->info_length + rlen + dotdot_rec_len;
+	}
 
 	if (offset)
 		*offset = count_offset;
@@ -763,7 +773,9 @@ static struct stats dx_show_leaf(struct inode *dir,
 				       (unsigned) ((char *) de - base));
 #endif
 			}
-			space += ext4_dirent_rec_len(de->name_len, dir);
+			if ((char *)de + EXT4_BASE_DIR_LEN > base + size)
+				break;
+			space += ext4_dir_entry_len(de, size, dir);
 			names++;
 		}
 		de = ext4_next_entry(de, size);
@@ -1192,8 +1204,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 			tmp_str.name = de->name;
 			tmp_str.len = de->name_len;
 			err = ext4_htree_store_dirent(dir_file,
-				   hinfo->hash, hinfo->minor_hash, de,
-				   &tmp_str);
+				   hinfo->hash, hinfo->minor_hash,
+				   dir->i_sb->s_blocksize, de, &tmp_str);
 		} else {
 			int save_len = fname_crypto_str.len;
 			struct fscrypt_str de_name = FSTR_INIT(de->name,
@@ -1208,8 +1220,9 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 				goto errout;
 			}
 			err = ext4_htree_store_dirent(dir_file,
-				   hinfo->hash, hinfo->minor_hash, de,
-					&fname_crypto_str);
+						hinfo->hash, hinfo->minor_hash,
+						dir->i_sb->s_blocksize, de,
+						&fname_crypto_str);
 			fname_crypto_str.len = save_len;
 		}
 		if (err != 0) {
@@ -1287,6 +1300,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 0, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -1298,6 +1312,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 2, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -2126,7 +2141,8 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
+	unsigned short reclen = ext4_dirent_new_rec_len(dir, fname_len(fname),
+							dlen);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2153,13 +2169,10 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry(struct inode *dir,
-			struct inode *inode,
-			struct ext4_dir_entry_2 *de,
-			int buf_size,
-			struct ext4_filename *fname)
+void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			     struct ext4_dir_entry_2 *de, int buf_size,
+			     struct ext4_filename *fname, void *data)
 {
-
 	int nlen, rlen;
 
 	nlen = ext4_dir_entry_len(de, buf_size, dir);
@@ -2176,6 +2189,10 @@ void ext4_insert_dentry(struct inode *dir,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
+	/* 'data' (the LUFID payload) and the CFHASH are written by
+	 * ext4_dirdata_set(), which is introduced in the next patch that adds
+	 * the dirdata set/get helpers.  Until then, only the casefold hash is
+	 * stored at the legacy fixed offset for encrypted+casefolded dirs. */
 	if (ext4_hash_in_dirent(dir)) {
 		struct dx_hash_info *hinfo = &fname->hinfo;
 
@@ -2200,14 +2217,20 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err, err2;
+	int		err, err2, dlen = 0;
+	struct ext4_dirent_fid *dfid;
 
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
+	/* dfid is resolved once by ext4_add_entry() and stored in fname so
+	 * that all add_dirent_to_buf() calls within the same add operation
+	 * use a consistent value without touching the shared i_dirdata field. */
+	dfid = fname->dfid;
+	dlen = ext4_dirent_new_data_len(dir, dfid);
 	if (!de) {
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de, 0);
+					blocksize - csum_size, fname, &de, dlen);
 		if (err)
 			return err;
 	} else {
@@ -2221,8 +2244,8 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 		unsigned int rlen = ext4_rec_len_from_disk(de->rec_len,
 							   blocksize);
 
-		if (nlen > rlen ||
-		    rlen - nlen < ext4_dirent_rec_len(fname_len(fname), dir)) {
+		if (nlen > rlen || rlen - nlen <
+		    ext4_dirent_new_rec_len(dir, fname_len(fname), dlen)) {
 			EXT4_ERROR_INODE(dir,
 				"no room for new entry in split block %llu",
 				(unsigned long long)bh->b_blocknr);
@@ -2238,7 +2261,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2467,7 +2490,8 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
  */
 static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 			  const struct qstr *d_name,
-			  struct inode *inode)
+			  struct inode *inode,
+			  struct ext4_dentry_param *edp)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
@@ -2492,6 +2516,13 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 	if (retval)
 		return retval;
 
+	/* Resolve the LUFID payload once here and store it in fname so every
+	 * add_dirent_to_buf() call in this add operation uses the same value
+	 * without touching the shared EXT4_I(inode)->i_dirdata field. */
+	fname.dfid = ext4_dentry_get_fid(sb, edp);
+	if (fname.dfid)
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_DIRDATA, handle);
+
 	if (ext4_has_inline_data(dir)) {
 		retval = ext4_try_add_inline_entry(handle, &fname, dir, inode);
 		if (retval < 0)
@@ -2576,7 +2607,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
-	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
+	return __ext4_add_entry(handle, dir, &dentry->d_name, inode,
+				dentry->d_fsdata);
 }
 
 /*
@@ -3084,8 +3116,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	return ext4_handle_dirty_dirblock(handle, inode, bh);
 }
 
-int ext4_init_new_dir(handle_t *handle, struct inode *dir,
-			     struct inode *inode)
+int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
+			   struct inode *inode,
+			   const void *data1, const void *data2)
 {
 	struct buffer_head *dir_block = NULL;
 	ext4_lblk_t block = 0;
@@ -3586,10 +3619,16 @@ int __ext4_link(struct inode *dir, struct inode *inode,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
+	/* Fast-commit does not record dirdata in its journal format; force a
+	 * full journal commit so the LUFID survives crash+replay. */
+	if (ext4_dentry_get_fid(dir->i_sb, dentry ? dentry->d_fsdata : NULL))
+		ext4_fc_mark_ineligible(dir->i_sb, EXT4_FC_REASON_DIRDATA, handle);
+
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
 
-	err = __ext4_add_entry(handle, dir, d_name, inode);
+	err = __ext4_add_entry(handle, dir, d_name, inode,
+			       dentry ? dentry->d_fsdata : NULL);
 	if (!err) {
 		err = ext4_mark_inode_dirty(handle, inode);
 		/* this can happen only for tmpfile being
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 923b375e017f..80074fb15ee9 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -362,6 +362,7 @@ EXT4_ATTR_FEATURE(verity);
 #endif
 EXT4_ATTR_FEATURE(metadata_csum_seed);
 EXT4_ATTR_FEATURE(fast_commit);
+EXT4_ATTR_FEATURE(dirdata);
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 EXT4_ATTR_FEATURE(encrypted_casefold);
 #endif
@@ -385,6 +386,7 @@ static struct attribute *ext4_feat_attrs[] = {
 #endif
 	ATTR_LIST(metadata_csum_seed),
 	ATTR_LIST(fast_commit),
+	ATTR_LIST(dirdata),
 #if IS_ENABLED(CONFIG_UNICODE) && defined(CONFIG_FS_ENCRYPTION)
 	ATTR_LIST(encrypted_casefold),
 #endif
-- 
2.52.0

