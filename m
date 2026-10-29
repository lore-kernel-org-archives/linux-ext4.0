Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276836;
	b=IGM1uFrleDmvNuTg17tjLjcFIx77NhA1ArBSlqoH16PoBxeopPcaxP68SCFjj89c1iC8
	 cZeDkJ7ivaIni7vLs612yBvZnUeiZK7KWhLZB6xFzAqS1VHeIhPYd82dDq5Qh01BUMFyG
	 DRxTe12l0yWvFeSxclUBd12CS7KYdHq3XLYWfK6qeoiTbYJaug6hwMZHmcTea9Im2KAo1
	 B2qwRByRw5H7UuE/WCrTnRKsU3KspitMBlTzH0+KwxkG+i7W1Ei/kGRyKEC7Hl0wJq0t0
	 G5p/lxagbFiPlURD1h7JrS500HdVQzUD1JwNUrueWv2zG3aldToDnCs9dBKlsz+x9GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276836;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=jwr6+S3kv+7WVoR0mU6s2dINBrzXrxgAHQQTVfhLJ8Q=;
	b=5L5s+QKHCMY5f993SnEH8vZP29gSZ1R2AQq6ZPe4ydgFTY6ZfD4BmpsR8G8q+8iuVsSG
	 Mv1M1wWPjnGWwtsIjmEacZ7vGfLD1ej8Ctu2MwsjCdUQgpX26qiyXZx/ms3juraJiIg4+
	 l/5sG7dSa313y1HZ+hv/RpYwTj3ZP/HQJTtbMZd2PYwmWq6HgcklRm298vomZqmBOv4Pd
	 wYs4mhlMVf9WSWYZAdu7Fq0aSnocpyMpaG5IzoITytpaQ8h1AXbiiaPKo26j1WI7ldbPi
	 vOQuYRcy828N3joA+rPie1b8oF4btr9XK9oeRtd43JjnsIpLoFYdyBNxyDnZ01FEIZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="tCc6y8i/";
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C62606A324
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5C62606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tCc6y8i/
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so24685185e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276834; x=1793881634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwr6+S3kv+7WVoR0mU6s2dINBrzXrxgAHQQTVfhLJ8Q=;
        b=tCc6y8i/MNS4yf4U7/SQNjobmggygFvQ4U6u4UexkN5zDGu1NTfF71sPfQhMPnWAwd
         ACE0q9I2GClenvJsM4c98hsghop2vx6VIjAsIcvUtR7aME0xGlkRzdJC6K8QYC9AfSrG
         6t1qAOV22f+voJFWaVt1DE6wC6NlXf8IEmIfKwmPa0Nx7V6hTjRsMcKW2WjkZspA/tH2
         0EecZj3bHKnSvQbYcEGeGAWvDIIrND7yqImRWu63L1uYE5Ezr12hTrN48Fd24Sq/IE2B
         d5foYSh3vafi/ELd8FC0HOfnKwioymZgn5sCbQPqwQpFklOQRNaS2hqy6pzoTiEOYaw+
         tYCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276834; x=1793881634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jwr6+S3kv+7WVoR0mU6s2dINBrzXrxgAHQQTVfhLJ8Q=;
        b=Z+06dwb9gHNOtm0ovMOk8FAgE8XtoNFw0HLnTxxrk4y2k/vrsCAm+BT6hndNHV5Zdu
         aIjecP7cOGSnJhyYs6BsvIwgCgdFj/l9SEowwo472OTpXoZ5gll8XbpNrVSBPzf3c9Gl
         ux1IwWt4iFq8VtnfPs3DwBjJYI22jxL2xKPwjpbEOCtXFuLfCocRw11N9IRsitupPSaR
         G/WGU1gmw6/5733BmLSel1Foq5atq+Lqc8uM3kLCtaDvDJOO1UDwJbVmK4msM/XCaVBV
         wgCSL5OyzD6bC8qKqrACiTMGsWdbXu3nWbCzPDXukYVLNwz88Y1iUH+W2ch0v38LLcnR
         Tj0A==
X-Gm-Message-State: AFq9FYJzqUxcmebutVl7U8aGVlmpizYiCqx9Y6RNWuPwJ23TmELmGeaI
	D7YmSHejS3hB/eI538g2ftZfNzPh39FM5M2wfpfu2BOYyT/sWBtkPrvsRTXk/aga
X-Gm-Gg: AYBFou07+09XzKAgsbyzsBbtUpWiPwwfWeqdNbQukNuXmrw0AnyJYh9x+9zeEOj7zBg
	5N7BsnHXRrUMLETEKtTwrBMKbtPFQ9LMk03eAkwEGCYLbu4fNz34inpStVyWS/o3WI1TLORVoRc
	05gT21XWTJil8LdEsdX6fHoVPCRKeLkhRW51fSRAd+Xor5KwQbrhOHeXuHcCe1xmTpPJHk+8ocf
	FDH0dL/mLqr40xQBOTd6Pb3zx+ra6Md75aNTLz5tQ08lFgext9DoTKRq9KxQ6+lwuBPGOlEpVZe
	b4G86gDHIMHJnAxKXPXUWVQvcADL/UBch1PdulhbHMLug+lkWNq5plKYbVU0mqHpYl+IYXI0byp
	re4WOMDCoAer/805EZyaoob/ejw9wlUvA0nbfx2TehLwnqKi22uRzr3Htw6Xm0AB2Z3ixf1zeGH
	zyMQ02qSGfqFiXoQo2DVYmACyYSqha5Nu9F/71UVBMweEhuXZIsa8veuiTvFA41CgbV+oZIijP9
	UvF84M4RihhtlNpJK//HIFoBO3nX13MSj7117eGEG+ND2Zs9DsyHGj45iY35iFX183TSNOYFZ8k
	MtprpIN3PLtVS2GfB4pQIPm9+nupXPzkdom2wnxfCyYGOZKVieZnD6n5h+dVSMSEpWogLK4ekSd
	//GeK3Q==
X-Received: by 2002:a05:600c:8b77:b0:4a2:cbe:bebc with SMTP id 5b1f17b1804b1-4a966c3ff3amr107018905e9.23.1793276834090;
        Thu, 29 Oct 2026 05:27:14 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:13 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Pravin Shelar <pravin.shelar@sun.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v13 08/11] ext4: dirdata feature
Date: Thu, 29 Oct 2026 12:24:07 +0000
Message-ID: <20261029122413.230409-9-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
References: <20261029122413.230409-1-ablagodarenko@thelustrecollective.com>
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
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 fs/ext4/dir.c         |  22 +++++++--
 fs/ext4/ext4.h        |  43 ++++++++++++++---
 fs/ext4/fast_commit.c |   1 +
 fs/ext4/fast_commit.h |   1 +
 fs/ext4/inline.c      |  34 ++++++++++----
 fs/ext4/namei.c       | 107 ++++++++++++++++++++++++++++++------------
 fs/ext4/sysfs.c       |   2 +
 7 files changed, 163 insertions(+), 47 deletions(-)

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
index 839274c4d7fc..aea75a320ceb 100644
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
@@ -2633,6 +2634,18 @@ struct ext4_dirent_hash {
 	struct ext4_dir_entry_hash	dh_hash;
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
@@ -2756,6 +2769,8 @@ struct ext4_filename {
 #if IS_ENABLED(CONFIG_UNICODE)
 	struct qstr cf_name;
 #endif
+	/* LUFID/dirdata payload to embed in the new directory entry, or NULL */
+	struct ext4_dirent_fid *dfid;
 };
 
 #define fname_name(p) ((p)->disk_name.name)
@@ -3067,7 +3082,7 @@ extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
 	unlikely(__ext4_check_dir_entry(__func__, __LINE__, (dir), (filp), \
 				(de), (bh), (buf), (size), (offset)))
 extern int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
-				__u32 minor_hash,
+				__u32 minor_hash, int buf_size,
 				struct ext4_dir_entry_2 *dirent,
 				struct fscrypt_str *ent_name);
 extern void ext4_htree_free_dir_info(struct dir_private_info *p);
@@ -3076,10 +3091,18 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
@@ -3336,8 +3359,14 @@ extern int ext4_ext_migrate(struct inode *);
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
index bdf6f45a3de4..d3dda1d65d06 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -982,14 +982,20 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 				     struct ext4_iloc *iloc,
 				     void *inline_start, int inline_size)
 {
-	int		err;
+	int		err, dlen = 0;
 	struct ext4_dir_entry_2 *de;
+	struct ext4_dirent_fid *dfid = NULL;
+
+	/* fname->dfid was set in ext4_add_entry() */
+	dfid = fname->dfid;
+	if (dfid)
+		dlen = dfid->df_header.ddh_length;
+	if (ext4_hash_in_dirent(dir) &&
+	    ext4_has_feature_dirdata(dir->i_sb))
+		dlen += sizeof(struct ext4_dirent_hash);
 
-	/* 'dlen' reserves space for dirdata extensions (LUFID, CFHASH) in the
-	 * slot.  The dirdata types are defined in the next patch; until then
-	 * dlen stays 0 and ext4_find_dest_de() ignores dirdata overhead. */
 	err = ext4_find_dest_de(dir, iloc->bh, inline_start,
-				inline_size, fname, &de, 0);
+				inline_size, fname, &de, dlen);
 	if (err)
 		return err;
 
@@ -998,7 +1004,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry(dir, inode, de, inline_size, fname);
+	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
@@ -1276,6 +1282,7 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 	int err = 0, count = 0;
 	unsigned int parent_ino;
 	int pos;
+	unsigned int de_len;
 	struct ext4_dir_entry_2 *de;
 	struct inode *inode = file_inode(dir_file);
 	int ret, inline_size = 0;
@@ -1337,14 +1344,24 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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
@@ -1366,7 +1383,8 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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
index e54608950fb3..30bbf6a56bf6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -402,23 +402,32 @@ static struct dx_countlimit *get_dx_countlimit(struct inode *inode,
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
+		if (rlen + dotdot_rec_len + sizeof(struct dx_root_info) > blocksize)
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
@@ -728,7 +737,9 @@ static struct stats dx_show_leaf(struct inode *dir,
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
@@ -1157,8 +1168,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1173,8 +1184,9 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
@@ -1252,6 +1264,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 0, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -1263,6 +1276,7 @@ int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 		tmp_str.name = de->name;
 		tmp_str.len = de->name_len;
 		err = ext4_htree_store_dirent(dir_file, 2, 0,
+					      dir->i_sb->s_blocksize,
 					      de, &tmp_str);
 		if (err != 0)
 			goto errout;
@@ -2091,7 +2105,11 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 		      int dlen)
 {
 	struct ext4_dir_entry_2 *de;
-	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen, dir);
+	/* When dirdata extensions are present, a NUL gap byte sits between
+	 * the filename and the first extension; account for it so the found
+	 * slot is always large enough for ext4_dirdata_set() to write into. */
+	unsigned short reclen = ext4_dirent_rec_len(fname_len(fname) + dlen +
+						    (dlen ? 1 : 0), dir);
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
@@ -2118,13 +2136,10 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
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
@@ -2141,6 +2156,10 @@ void ext4_insert_dentry(struct inode *dir,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
+	/* 'data' (the LUFID payload) and the CFHASH are written by
+	 * ext4_dirdata_set(), which is introduced in the next patch that adds
+	 * the dirdata set/get helpers.  Until then, only the casefold hash is
+	 * stored at the legacy fixed offset for encrypted+casefolded dirs. */
 	if (ext4_hash_in_dirent(dir)) {
 		struct dx_hash_info *hinfo = &fname->hinfo;
 
@@ -2165,14 +2184,28 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
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
 	if (!de) {
+		if (dfid)
+			dlen = dfid->df_header.ddh_length;
+		/* ext4_dirent_rec_len() does not add CFHASH size when dirdata is
+		 * enabled (it assumes the caller included it in name_len).  Add
+		 * it here so ext4_find_dest_de() allocates a slot large enough
+		 * for ext4_dirdata_set() to write the hash extension. */
+		if (ext4_hash_in_dirent(dir) &&
+		    ext4_has_feature_dirdata(dir->i_sb))
+			dlen += sizeof(struct ext4_dirent_hash);
 		err = ext4_find_dest_de(dir, bh, bh->b_data,
-					blocksize - csum_size, fname, &de, 0);
+					blocksize - csum_size, fname, &de, dlen);
 		if (err)
 			return err;
 	}
@@ -2185,7 +2218,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry(dir, inode, de, blocksize, fname);
+	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2412,7 +2445,8 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
  */
 static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 			  const struct qstr *d_name,
-			  struct inode *inode)
+			  struct inode *inode,
+			  struct ext4_dentry_param *edp)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
@@ -2437,6 +2471,13 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
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
@@ -2521,7 +2562,8 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 
 	if (fscrypt_is_nokey_name(dentry))
 		return -ENOKEY;
-	return __ext4_add_entry(handle, dir, &dentry->d_name, inode);
+	return __ext4_add_entry(handle, dir, &dentry->d_name, inode,
+				dentry->d_fsdata);
 }
 
 /*
@@ -3029,8 +3071,9 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
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
@@ -3531,10 +3574,16 @@ int __ext4_link(struct inode *dir, struct inode *inode,
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

