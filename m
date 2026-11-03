Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713835;
	b=Qc3Xshev8XbH9i6ohlePH805oGD/SUrlmA1T2kKvGYalY6H86k7s6rvrBnNXZHffr69W
	 uKaIufZdddJkj11Nl9cDg+QW5md0DR27HI1o/YaiXZo1+linR1PhhZB2atkTkDkdFjgze
	 9cKwBIeFWKYMfrLpYx/9xYLAFxy065Si+cYd1rgTOnWpzZfYrQ9ZwdMI2wYCmQndVOcN0
	 a87c7CF1rRFyRBfQVLxKLpYGIJaGqJY14OCl+/y9RSJB05uGbLh62colv07fWfaoVfaV9
	 q9E84LqcP8A8PaS3TiPB8aSCn8YM7u04xhWmEury+dkmTFKFr+TU8hSZXJUof3WNLBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=lXy+hG0FK4vTp5D2gav0+agOvqjQ92uCTd6cghMhb+0=;
	b=uQaXD0DELyun+B2D60P1MTk5RU2p8FvCtnILHLdaXLm2m8a/QzvSXCw0rG7E+0A+p2PF
	 cVkS8umFxO4c4Re9irbVOUfs4rLQ217BsvWkJgWMQ1HRO8vViFveLy5Ne5/rdWqC2UpZO
	 aHb00vneMrXnqr0Sg+FNbLxai/c6I1AefUeUHojWhWBhrxnSXTVF+z5agn+75iq5mPHOr
	 1ICymKusTEQF53pvJLSKvZs+QBnPneGv8e4QyYVa/0VX1AxySQybrs2TvGI/qy4489v5C
	 vFl5EJ+Yts6y8A2EVOXn2uJY+RhVlJ9hL8bUzEnX7qLR7czbGRf2q+GBW6Bf0Y9ImMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zUVrLUjL;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EFF606A32C
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21EFF606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zUVrLUjL
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a214af2076so32266365e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713832; x=1794318632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lXy+hG0FK4vTp5D2gav0+agOvqjQ92uCTd6cghMhb+0=;
        b=zUVrLUjLuylTO0aSQRfrOeBiKj2jCPhSNdBD8vTG7WwFGgHURP7XVKKHLphlSdQpeW
         yZFBIc1VqFCJTJN9CuPxU7guju4PgxvMCaiUKlA2LlUrV7v06wdAu/I4m8BP7qKld7Jr
         9ycxrXTLbBrpZCsQA8a8NKf0FOG8bwqTYIEfnPMjFP0lzIffcZ+QSCB+QhyUAIMEKZsj
         mbRdIh72lDpNvL1n1zmPihJVbfEvHyzhl7BRYSEOfl0ASQYN62fDbsl9b9xs+Vr/gFA+
         B5BT6Pw4OfPxyURDLoHfk6MFDVKL5RlWGOkJ6RHk2aq/Zn1MOLFLvM447PxPiUNfy/pT
         btKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713832; x=1794318632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lXy+hG0FK4vTp5D2gav0+agOvqjQ92uCTd6cghMhb+0=;
        b=LCNj3xCzDP3Sf4POBTB6XPvklY636yVw2/5BL/VST1EsWI2SSZ8YCFURaNnvOt4wuO
         ul1hx53Ooej9CEGbLaai8lFBjcQa6Wup+tqXYhGql6s7RC/P0u3T7pr1uvbOLtFa5+uZ
         GX2dErIWKo4FvacZz09nqexN2cZrRRh4rcYhzv4ldYCdLh9c3bjJL7aK8M6BsZX1R/U4
         7IbiJg6K32KGfoaLgK9g5Q/v/NkEUWCqS2ilZ5+w9w2B+B6fRfkYeeqz+Q1rRKplRV93
         D7vgrdqP2NofidUNnp90g4SUZe7ZZNTyn9GBbCxb3Wrc2nA6VLJ5tV2FPtMrX3q1uxPL
         Vo1w==
X-Gm-Message-State: APuU4Z/rkVALjhWYLRyzI/oy+NRzRya/w9j5QlbJUfTmLpzSEsj76YZ2
	IXSnXy5UnBvrSuFRZVX2t4eXDb+/gu+KdLrjlQNo3po1lYbGbYYY96Ib5o+5vu9KhhA=
X-Gm-Gg: AYBFou3+7pVzZfo1BpFO3KKT8bjFLELu4IMMGZFHJj3PDD7U+pw9wE1NA2HnFeKNEnm
	NOBUffvlc9PZw9pn8KLzMPsZbf7HnIPrwypY6kgGu4v5EhUBrkvmQswZHeME5cYCXEh19YkDx2U
	YzCuwGWZalEAaFlPT4oWyU9fWWkDEWD1rxFXwzETL0NOdSgEqWlO4zrv8aHGw6RdvBcuUJNCXBD
	dRawEz415i2TlWQUx4FKgyZR5bMRyuNm3NNksEfs2vF0deUVKhq/fva+GVCTNaedmKU1jPGNm3z
	b7G+DmzRj3qMSKizDbaVQGCSqZnJdwX1ftsaj/gEOnkoYp0JBbfsHt3EdkXdo7ouX0Ooon061r7
	kncCCRgtEj8acltULj0XD6DZr5d/7wBu3w8pPCcGTtU4Yr79y7xmkxQg85X1Mdt64AvYarUsK/1
	VXnVFX/Z+B63sEthAB3XWU+laUkvWI2VtkFhJK/MaOfpdiLG5F5JjUEEPiZ2WeiTOVWqCr1Gr9B
	l0bk4px03C76OpRAYQAZNIfyPAPAlYQJxQLaPCc/58pL1zYQFRoS3/kKqMt8pEVgA5XmAcHwtsF
	tIzn8Nh2y30udab2GAxeq8HmK0UokA/isqiP8ZnJupZctyeEISsrGuVFVP/3QhYLPrK2+r6MSJf
	SAnarTw==
X-Received: by 2002:a05:600c:4585:b0:4a7:8fe8:130c with SMTP id 5b1f17b1804b1-4ac1889d5a1mr293412305e9.28.1793713832232;
        Tue, 03 Nov 2026 05:50:32 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:31 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 12/12] ext4: Add EXT4_IOC_SET_LUFID ioctl for setting LUFID on directory entries
Date: Tue,  3 Nov 2026 13:49:19 +0000
Message-ID: <20261103134921.610047-13-ablagodarenko@thelustrecollective.com>
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

Add a new ioctl command that allows setting LUFID (Locally Unique File ID)
data on existing directory entries. This includes:

- ext4_ioctl_set_lufid(): ioctl handler that validates parameters and
  calls the underlying implementation
- ext4_dirdata_set_lufid(): Core function that performs the operation by:
  * Looking up the target directory entry
  * Retrieving the associated inode
  * Deleting the old entry and re-creating it with LUFID data attached

The LUFID payload is limited to 48 bytes (three FIDs), so that a
directory block split always has room for the new entry, even with
1k blocks, a 255-byte name and a CFHASH record.

The entry is re-created under the name it is stored with, which in a
casefolded directory may differ in case from the name passed in; in an
encrypted directory that name is decrypted first, so the key is needed.
Both names are set up before the old entry is deleted, so a failed
re-add can put the old entry back without allocating memory.  The
directory is locked for the whole operation, its quota is initialized
before the transaction starts, and DIRSYNC is honoured.

This implementation requires the dirdata feature to be enabled on the
filesystem.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/dir.c             |   3 +-
 fs/ext4/ext4.h            |  36 ++--
 fs/ext4/inline.c          |   4 +-
 fs/ext4/ioctl.c           |  87 +++++++++
 fs/ext4/namei.c           | 358 +++++++++++++++++++++++++++++++++-----
 include/uapi/linux/ext4.h |  14 ++
 6 files changed, 447 insertions(+), 55 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 12df2d2a0997..dca6796d5fe2 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -507,7 +507,8 @@ int ext4_htree_store_dirent(struct file *dir_file, __u32 hash,
 	p = &info->root.rb_node;
 
 	/* Create and allocate the fname structure */
-	if (dirent->file_type & ~EXT4_FT_MASK) {
+	if (ext4_has_feature_dirdata(dir_file->f_inode->i_sb) &&
+	    (dirent->file_type & ~EXT4_FT_MASK)) {
 		unsigned int rec_len =
 			ext4_rec_len_from_disk(dirent->rec_len, buf_size);
 		extra_data = ext4_dirent_get_data_len(dirent, rec_len);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 32119ab18ac4..95e81179e435 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2624,6 +2624,14 @@ struct ext4_dirent_fid {
 };
 
 #define EXT4_LUFID_MAGIC    0xAD200907UL
+
+/*
+ * Largest LUFID payload accepted from EXT4_IOC_SET_LUFID.  do_split() needs
+ * every entry to fit in the free part of either half of a split block; with
+ * a 255-byte name, the NUL byte, a CFHASH record and 1k blocks that limits a
+ * LUFID record to about 57 bytes.  Three FIDs leave some headroom.
+ */
+#define EXT4_LUFID_MAX_DATA_LEN	(3 * sizeof(struct ext4_fid))
 struct ext4_dentry_param {
 	__u32	edp_magic;	/* EXT4_LUFID_MAGIC */
 	__u8	edp_dfid[];	/* struct ext4_dirent_fid payload */
@@ -2679,6 +2687,11 @@ static inline unsigned int ext4_dirent_rec_len(unsigned int name_len,
 {
 	unsigned int rec_len = (name_len + 8 + EXT4_DIR_ROUND);
 
+	/*
+	 * Reserve the casefold+fscrypt hash at its fixed position after the
+	 * name.  Callers whose length already includes the hash as a CFHASH
+	 * dirdata record pass a NULL @dir (see ext4_dir_entry_len()).
+	 */
 	if (dir && ext4_hash_in_dirent(dir))
 		rec_len += sizeof(struct ext4_dir_entry_hash);
 	return (rec_len & ~EXT4_DIR_ROUND);
@@ -3089,17 +3102,17 @@ extern int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 			     struct ext4_filename *fname,
 			     struct ext4_dir_entry_2 **dest_de,
 			     int dlen);
-void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
-			     struct ext4_dir_entry_2 *de,
-			     int buf_size,
-			     struct ext4_filename *fname,
-			     void *data);
-static inline void ext4_insert_dentry(struct inode *dir, struct inode *inode,
-				      struct ext4_dir_entry_2 *de,
-				      int buf_size,
-				      struct ext4_filename *fname)
+int ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			    struct ext4_dir_entry_2 *de,
+			    int buf_size,
+			    struct ext4_filename *fname,
+			    void *data);
+static inline int ext4_insert_dentry(struct inode *dir, struct inode *inode,
+				     struct ext4_dir_entry_2 *de,
+				     int buf_size,
+				     struct ext4_filename *fname)
 {
-	ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
+	return ext4_insert_dentry_data(dir, inode, de, buf_size, fname, NULL);
 }
 static inline void ext4_update_dx_flag(struct inode *inode)
 {
@@ -3367,6 +3380,9 @@ static inline int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 }
 extern int ext4_dirblock_csum_verify(struct inode *inode,
 				     struct buffer_head *bh);
+extern int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
+			   const char *filename, int namelen,
+			   struct ext4_dentry_param *edp);
 extern int ext4_htree_fill_tree(struct file *dir_file, __u32 start_hash,
 				__u32 start_minor_hash, __u32 *next_hash);
 extern int ext4_search_dir(struct buffer_head *bh,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 801fa6555ea9..1667c68c683e 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -998,7 +998,9 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 					    EXT4_JTR_NONE);
 	if (err)
 		return err;
-	ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
+	err = ext4_insert_dentry_data(dir, inode, de, inline_size, fname, dfid);
+	if (err)
+		return err;
 
 	ext4_show_inline_dir(dir, iloc->bh, inline_start, inline_size);
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1f6d7afb62ec..68054e9f8d77 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1536,6 +1536,90 @@ static int ext4_ioctl_set_tune_sb(struct file *filp,
 	return ret;
 }
 
+/*
+ * ext4_ioctl_set_lufid() - Set LUFID on a directory entry
+ * @filp:	file pointer (parent directory)
+ * @arg:	pointer to ext4_set_lufid structure with filename and LUFID data
+ *
+ * This ioctl allows setting LUFID data on an existing
+ * directory entry. It is called on the parent directory with a filename and
+ * LUFID data.
+ */
+static long ext4_ioctl_set_lufid(struct file *filp, unsigned long arg)
+{
+	struct inode *dir = file_inode(filp);
+	struct mnt_idmap *idmap = file_mnt_idmap(filp);
+	struct ext4_set_lufid lufid_args;
+	struct {
+		__u32 edp_magic;
+		struct ext4_dirent_data_header df_header;
+		char df_fid[EXT4_LUFID_MAX_DATA_LEN];
+	} edp;
+	int err;
+
+	/* Check if parent is a directory */
+	if (!S_ISDIR(dir->i_mode))
+		return -ENOTDIR;
+
+	/* This ioctl mutates directory entries; merely having the directory
+	 * open (which only ever requires read access) is not enough.
+	 * MAY_EXEC is required for entry lookup; MAY_WRITE for modification. */
+	err = inode_permission(idmap, dir, MAY_WRITE | MAY_EXEC);
+	if (err)
+		return err;
+
+	/* Copy arguments from user space */
+	if (copy_from_user(&lufid_args, (struct ext4_set_lufid __user *)arg,
+			   sizeof(lufid_args)))
+		return -EFAULT;
+
+	/* Validate parameters.  esl_name_len is NUL-excluded length (1-255). */
+	if (lufid_args.esl_name_len == 0 || lufid_args.esl_name_len > EXT4_NAME_LEN)
+		return -EINVAL;
+
+	/*
+	 * The payload is capped so that a directory block split always has
+	 * room for the new entry, see EXT4_LUFID_MAX_DATA_LEN
+	 */
+	if (lufid_args.esl_data_len == 0 ||
+	    lufid_args.esl_data_len > EXT4_LUFID_MAX_DATA_LEN)
+		return -EINVAL;
+
+	/* Ensure filename is NUL-terminated at exactly esl_name_len */
+	if (lufid_args.esl_name[lufid_args.esl_name_len] != '\0')
+		return -EINVAL;
+
+	/* '.' and '..' are not ordinary entries -- they must stay the first
+	 * two entries in the directory's first block, so they can't go
+	 * through the general delete+re-add path this ioctl uses */
+	if (!strcmp(lufid_args.esl_name, ".") || !strcmp(lufid_args.esl_name, ".."))
+		return -EINVAL;
+
+	/* Prepare the dentry param struct with LUFID data. ddh_length is
+	 * documented (see struct ext4_dirent_data_header) as the length of
+	 * the header plus the whole data blob -- include the header here so
+	 * every dirdata reader/writer that takes ddh_length at face value
+	 * (e.g. ext4_dirdata_set()'s memcpy) copies the full LUFID payload
+	 * instead of silently dropping its last byte. */
+	edp.edp_magic = EXT4_LUFID_MAGIC;
+	edp.df_header.ddh_length = lufid_args.esl_data_len +
+				    sizeof(edp.df_header);
+	memcpy(edp.df_fid, lufid_args.esl_data, lufid_args.esl_data_len);
+
+	/* Want write access */
+	err = mnt_want_write_file(filp);
+	if (err)
+		return err;
+
+	/* Call the helper function to do the actual work */
+	err = ext4_dirdata_set_lufid(idmap, dir, lufid_args.esl_name,
+				    lufid_args.esl_name_len,
+				    (struct ext4_dentry_param *)&edp);
+
+	mnt_drop_write_file(filp);
+	return err;
+}
+
 static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1922,6 +2006,8 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 					      (void __user *)arg);
 	case EXT4_IOC_SET_TUNE_SB_PARAM:
 		return ext4_ioctl_set_tune_sb(filp, (void __user *)arg);
+	case EXT4_IOC_SET_LUFID:
+		return ext4_ioctl_set_lufid(filp, arg);
 	default:
 		return -ENOTTY;
 	}
@@ -2001,6 +2087,7 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case FS_IOC_SETFSLABEL:
 	case EXT4_IOC_GETFSUUID:
 	case EXT4_IOC_SETFSUUID:
+	case EXT4_IOC_SET_LUFID:
 		break;
 	default:
 		return -ENOIOCTLCMD;
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8f1a6c000373..68c5caff4707 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1523,9 +1523,9 @@ unsigned char ext4_dirdata_get(struct ext4_dir_entry_2 *de, struct inode *dir,
  * directories requires an e2fsck migration pass before tune2fs sets the
  * EXT4_FEATURE_INCOMPAT_DIRDATA superblock flag.
  */
-static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
-			     struct ext4_dirent_fid *dfid,
-			     struct ext4_filename *fname)
+static int ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
+			    struct ext4_dirent_fid *dfid,
+			    struct ext4_filename *fname)
 {
 	struct dx_hash_info *hinfo = &fname->hinfo;
 	unsigned int data_offset = de->name_len + 1;
@@ -1546,7 +1546,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 		if (EXT4_BASE_DIR_LEN + data_offset + dlen > rec_len) {
 			EXT4_ERROR_INODE(dir, "Can not insert FID");
-			return;
+			return -EIO;
 		}
 
 		memcpy((char *)de + EXT4_BASE_DIR_LEN + data_offset, dfid, dlen);
@@ -1561,7 +1561,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 
 			if (EXT4_BASE_DIR_LEN + data_offset + sizeof(*dh) > rec_len) {
 				EXT4_ERROR_INODE(dir, "Can not insert dhash dirdata");
-				return;
+				return -EIO;
 			}
 
 			dh->dh_header.ddh_length = sizeof(*dh);
@@ -1569,11 +1569,18 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 			dh->dh_minor_hash = cpu_to_le32(hinfo->minor_hash);
 			de->file_type |= EXT4_DIRENT_CFHASH;
 		} else {
-			/* Compatibility: store hash inline after filename */
-			if (EXT4_BASE_DIR_LEN + data_offset +
-			    sizeof(struct ext4_dir_entry_hash) > rec_len) {
+			/* Compatibility: store hash inline after filename.
+			 * EXT4_DIRENT_HASHES places the hash at the
+			 * 4-byte-aligned offset (8 + name_len + 3) & ~3, which
+			 * may be less than EXT4_BASE_DIR_LEN + data_offset when
+			 * name_len is a multiple of 4 (gap byte counted twice).
+			 * Use the same aligned offset for the bounds check. */
+			unsigned int hash_off =
+				(EXT4_BASE_DIR_LEN + de->name_len + 3) & ~3;
+
+			if (hash_off + sizeof(struct ext4_dir_entry_hash) > rec_len) {
 				EXT4_ERROR_INODE(dir, "Can not insert dhash");
-				return;
+				return -EIO;
 			}
 
 			EXT4_DIRENT_HASHES(de)->hash = cpu_to_le32(hinfo->hash);
@@ -1581,6 +1588,7 @@ static void ext4_dirdata_set(struct ext4_dir_entry_2 *de, struct inode *dir,
 						cpu_to_le32(hinfo->minor_hash);
 		}
 	}
+	return 0;
 }
 
 /*
@@ -2409,9 +2417,9 @@ int ext4_find_dest_de(struct inode *dir, struct buffer_head *bh,
 	return 0;
 }
 
-void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
-			     struct ext4_dir_entry_2 *de, int buf_size,
-			     struct ext4_filename *fname, void *data)
+int ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
+			    struct ext4_dir_entry_2 *de, int buf_size,
+			    struct ext4_filename *fname, void *data)
 {
 	int nlen, rlen;
 
@@ -2429,7 +2437,7 @@ void ext4_insert_dentry_data(struct inode *dir, struct inode *inode,
 	ext4_set_de_type(inode->i_sb, de, inode->i_mode);
 	de->name_len = fname_len(fname);
 	memcpy(de->name, fname_name(fname), fname_len(fname));
-	ext4_dirdata_set(de, dir, data, fname);
+	return ext4_dirdata_set(de, dir, data, fname);
 }
 
 /*
@@ -2491,7 +2499,11 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	}
 
 	/* By now the buffer is marked for journaling */
-	ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
+	err = ext4_insert_dentry_data(dir, inode, de, blocksize, fname, dfid);
+	if (err) {
+		ext4_std_error(dir->i_sb, err);
+		return err;
+	}
 
 	/*
 	 * XXX shouldn't update any times until successful
@@ -2718,15 +2730,17 @@ static int make_indexed_dir(handle_t *handle, struct ext4_filename *fname,
  * may not sleep between calling this and putting something into
  * the entry, as someone else might have used it while you slept.
  */
-static int __ext4_add_entry(handle_t *handle, struct inode *dir,
-			  const struct qstr *d_name,
-			  struct inode *inode,
-			  struct ext4_dentry_param *edp)
+/*
+ * ext4_add_fname() - add an entry for a name that is already set up
+ *
+ * @fname->dfid is the LUFID record to store with the entry, or NULL.
+ */
+static int ext4_add_fname(handle_t *handle, struct inode *dir,
+			  struct ext4_filename *fname, struct inode *inode)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_dir_entry_2 *de;
 	struct super_block *sb;
-	struct ext4_filename fname;
 	int	retval;
 	int	dx_fallback=0;
 	unsigned blocksize;
@@ -2739,22 +2753,11 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 	sb = dir->i_sb;
 	blocksize = sb->s_blocksize;
 
-	if (!generic_ci_validate_strict_name(dir, d_name))
-		return -EINVAL;
-
-	retval = ext4_fname_setup_filename(dir, d_name, 0, &fname);
-	if (retval)
-		return retval;
-
-	/* Resolve the LUFID payload once here and store it in fname so every
-	 * add_dirent_to_buf() call in this add operation uses the same value
-	 * without touching the shared EXT4_I(inode)->i_dirdata field. */
-	fname.dfid = ext4_dentry_get_fid(sb, edp);
-	if (fname.dfid)
+	if (fname->dfid)
 		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_DIRDATA, handle);
 
 	if (ext4_has_inline_data(dir)) {
-		retval = ext4_try_add_inline_entry(handle, &fname, dir, inode);
+		retval = ext4_try_add_inline_entry(handle, fname, dir, inode);
 		if (retval < 0)
 			goto out;
 		if (retval == 1) {
@@ -2764,7 +2767,7 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 	}
 
 	if (is_dx(dir)) {
-		retval = ext4_dx_add_entry(handle, &fname, dir, inode);
+		retval = ext4_dx_add_entry(handle, fname, dir, inode);
 		if (!retval || (retval != ERR_BAD_DX_DIR))
 			goto out;
 		/* Can we just ignore htree data? */
@@ -2793,14 +2796,14 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 			bh = NULL;
 			goto out;
 		}
-		retval = add_dirent_to_buf(handle, &fname, dir, inode,
+		retval = add_dirent_to_buf(handle, fname, dir, inode,
 					   NULL, bh);
 		if (retval != -ENOSPC)
 			goto out;
 
 		if (blocks == 1 && !dx_fallback &&
 		    ext4_has_feature_dir_index(sb)) {
-			retval = make_indexed_dir(handle, &fname, dir,
+			retval = make_indexed_dir(handle, fname, dir,
 						  inode, bh);
 			bh = NULL; /* make_indexed_dir releases bh */
 			goto out;
@@ -2821,15 +2824,39 @@ static int __ext4_add_entry(handle_t *handle, struct inode *dir,
 	if (csum_size)
 		ext4_initialize_dirent_tail(bh, blocksize);
 
-	retval = add_dirent_to_buf(handle, &fname, dir, inode, de, bh);
+	retval = add_dirent_to_buf(handle, fname, dir, inode, de, bh);
 out:
-	ext4_fname_free_filename(&fname);
 	brelse(bh);
 	if (retval == 0)
 		ext4_set_inode_state(inode, EXT4_STATE_NEWENTRY);
 	return retval;
 }
 
+static int __ext4_add_entry(handle_t *handle, struct inode *dir,
+			  const struct qstr *d_name,
+			  struct inode *inode,
+			  struct ext4_dentry_param *edp)
+{
+	struct ext4_filename fname;
+	int retval;
+
+	if (!generic_ci_validate_strict_name(dir, d_name))
+		return -EINVAL;
+
+	retval = ext4_fname_setup_filename(dir, d_name, 0, &fname);
+	if (retval)
+		return retval;
+
+	/* Resolve the LUFID payload once here and store it in fname so every
+	 * add_dirent_to_buf() call in this add operation uses the same value
+	 * without touching the shared EXT4_I(inode)->i_dirdata field.
+	 */
+	fname.dfid = ext4_dentry_get_fid(dir->i_sb, edp);
+	retval = ext4_add_fname(handle, dir, &fname, inode);
+	ext4_fname_free_filename(&fname);
+	return retval;
+}
+
 static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 			  struct inode *inode)
 {
@@ -3307,14 +3334,15 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 	struct ext4_dir_entry_2 *de = (struct ext4_dir_entry_2 *) bh->b_data;
 	size_t			blocksize = bh->b_size;
 	int			csum_size = 0, header_size;
+	unsigned int		dot_rec_len;
 
 	if (ext4_has_feature_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
 
 	de->inode = cpu_to_le32(inode->i_ino);
 	de->name_len = 1;
-	de->rec_len = ext4_rec_len_to_disk(ext4_dirent_rec_len(de->name_len, NULL),
-					   blocksize);
+	dot_rec_len = ext4_dirent_rec_len(de->name_len, NULL);
+	de->rec_len = ext4_rec_len_to_disk(dot_rec_len, blocksize);
 	memcpy(de->name, ".", 2);
 	ext4_set_de_type(inode->i_sb, de, S_IFDIR);
 
@@ -3334,7 +3362,7 @@ int ext4_init_dirblock(handle_t *handle, struct inode *inode,
 			blocksize - csum_size);
 	} else {
 		de->rec_len = ext4_rec_len_to_disk(blocksize -
-					(csum_size + ext4_dirent_rec_len(1, NULL)),
+					(csum_size + dot_rec_len),
 					blocksize);
 	}
 
@@ -3367,6 +3395,12 @@ int ext4_init_new_dir_data(handle_t *handle, struct inode *dir,
 	dir_block = ext4_append(handle, inode, &block);
 	if (IS_ERR(dir_block))
 		return PTR_ERR(dir_block);
+	/*
+	 * data1 and data2 are reserved for callers that need to embed
+	 * dirdata into the '.' and '..' entries of a new directory.
+	 * That path is not yet implemented here; a caller requiring it
+	 * must write the dirdata entries after this function returns.
+	 */
 	err = ext4_init_dirblock(handle, inode, dir_block, dir->i_ino, NULL, 0);
 out:
 	brelse(dir_block);
@@ -4486,14 +4520,13 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	if (!new.bh && old_snap.fid) {
 		unsigned fid_size = old_snap.fid->df_header.ddh_length;
 
-		edp = kmalloc(offsetof(struct ext4_dentry_param,
-				       edp_dfid) + fid_size, GFP_NOFS);
+		edp = kmalloc(sizeof(*edp) + fid_size, GFP_NOFS);
 		if (!edp) {
 			retval = -ENOMEM;
 			goto end_rename;
 		}
 		edp->edp_magic = EXT4_LUFID_MAGIC;
-		memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
+		memcpy(edp->edp_dfid, old_snap.fid, fid_size);
 	}
 
 	if (whiteout) {
@@ -4825,6 +4858,245 @@ static int ext4_rename2(struct mnt_idmap *idmap,
 	return ext4_rename(idmap, old_dir, old_dentry, new_dir, new_dentry, flags);
 }
 
+/*
+ * ext4_dirdata_set_lufid() - Set LUFID data on an existing directory entry
+ * @dir:        parent directory inode
+ * @filename:   name of the file in the directory
+ * @namelen:    length of filename
+ * @edp:        pointer to initialized dentry param with LUFID data
+ *
+ * This function finds an existing directory entry, deletes it, and re-creates it
+ * with LUFID data attached. Used by the EXT4_IOC_SET_LUFID ioctl.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int ext4_dirdata_set_lufid(struct mnt_idmap *idmap, struct inode *dir,
+			   const char *filename, int namelen,
+			   struct ext4_dentry_param *edp)
+{
+	struct super_block *sb = dir->i_sb;
+	/* zero-init: safe to free on any path */
+	struct ext4_filename new_fname = {}, old_fname = {};
+	struct ext4_dir_entry_2 *de = NULL;
+	struct buffer_head *bh = NULL;
+	struct inode *inode = NULL;
+	handle_t *handle = NULL;
+	struct ext4_lufid_snap old_snap = {};
+	struct qstr d_name = QSTR_INIT(filename, namelen);
+	/* the name as stored on disk, for casefolded directories */
+	struct fscrypt_str stored = FSTR_INIT(NULL, 0);
+	struct qstr stored_name;
+	const struct qstr *add_name = &d_name;
+	__u32 ino;
+	int err, err2;
+
+	if (!ext4_has_feature_dirdata(sb))
+		return -EOPNOTSUPP;
+
+	if (namelen > EXT4_NAME_LEN)
+		return -ENAMETOOLONG;
+	if (namelen != strnlen(filename, namelen + 1))
+		return -EINVAL;
+
+	/* the entry is re-created from its plaintext name */
+	if (IS_ENCRYPTED(dir) && !fscrypt_has_encryption_key(dir))
+		return -ENOKEY;
+
+	err = dquot_initialize(dir);
+	if (err)
+		return err;
+
+	/*
+	 * The lookup and the change must both be under the directory lock.
+	 * The entry is deleted and re-added in the same directory, so the
+	 * target inode itself is not changed and is not locked.
+	 */
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	/*
+	 * Look up the entry first to get the inode for the permission
+	 * checks, without holding a journal handle.
+	 */
+	bh = ext4_find_entry(dir, &d_name, &de, NULL);
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
+		bh = NULL;
+		goto out_unlock_dir;
+	}
+	if (!bh) {
+		err = -ENOENT;
+		goto out_unlock_dir;
+	}
+	ino = le32_to_cpu(de->inode);
+	brelse(bh);
+	bh = NULL;
+	de = NULL;
+
+	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		inode = NULL;
+		goto out_unlock_dir;
+	}
+
+	/* Enforce sticky-bit restriction: on a sticky directory only the
+	 * directory owner, the file owner, or a privileged process may
+	 * modify entries.  inode_permission(MAY_WRITE) alone does not cover
+	 * this, so check it explicitly here as may_delete() does. */
+	err = check_sticky(idmap, dir, inode);
+	if (err)
+		goto out_iput;
+
+	/* The ioctl calls ext4_delete_entry() on the parent directory, which
+	 * bypasses the VFS may_delete() path.  inode_permission(MAY_WRITE)
+	 * above blocks IS_IMMUTABLE(dir) but does NOT block IS_APPEND(dir):
+	 * append-only directories allow new entries but forbid deletion, and
+	 * that restriction lives only in may_delete(), not in
+	 * inode_permission().  Enforce it explicitly here. */
+	if (IS_APPEND(dir)) {
+		err = -EPERM;
+		goto out_iput;
+	}
+
+	/* The ioctl deletes and re-creates the directory entry, which
+	 * effectively modifies the target file's namespace presence.
+	 * Refuse if the target itself is immutable or append-only. */
+	if (IS_IMMUTABLE(inode) || IS_APPEND(inode)) {
+		err = -EPERM;
+		goto out_iput;
+	}
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    3 * EXT4_DATA_TRANS_BLOCKS(sb) +
+				    2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		handle = NULL;
+		goto out_iput;
+	}
+	if (IS_DIRSYNC(dir))
+		ext4_handle_sync(handle);
+
+	/*
+	 * Look up the entry again inside the handle and check that it still
+	 * refers to the same inode (an unlink and create could have run in
+	 * between).
+	 */
+	bh = ext4_find_entry(dir, &d_name, &de, NULL);
+	if (IS_ERR(bh)) {
+		err = PTR_ERR(bh);
+		bh = NULL;
+		goto out_journal;
+	}
+	if (!bh) {
+		err = -ENOENT;
+		goto out_journal;
+	}
+	if (le32_to_cpu(de->inode) != ino) {
+		err = -ENOENT;
+		goto out_brelse;
+	}
+
+	/*
+	 * In a casefolded directory the lookup ignores case, so the caller's
+	 * name may differ from the stored one.  Re-add the stored name, or
+	 * the entry would be renamed.  In an encrypted directory the stored
+	 * name is ciphertext, so decrypt it.  Elsewhere the names match.
+	 */
+	if (IS_CASEFOLDED(dir)) {
+		if (IS_ENCRYPTED(dir)) {
+			struct fscrypt_str disk = FSTR_INIT(de->name,
+							    de->name_len);
+
+			err = fscrypt_fname_alloc_buffer(EXT4_NAME_LEN, &stored);
+			if (err)
+				goto out_brelse;
+			err = fscrypt_fname_disk_to_usr(dir, 0, 0, &disk,
+							&stored);
+			if (err)
+				goto out_brelse;
+		} else {
+			stored.name = kmemdup(de->name, de->name_len, GFP_NOFS);
+			if (!stored.name) {
+				err = -ENOMEM;
+				goto out_brelse;
+			}
+			stored.len = de->name_len;
+		}
+		stored_name = (struct qstr)QSTR_INIT(stored.name, stored.len);
+		add_name = &stored_name;
+	}
+
+	/* The add checks this too, but only after the entry is gone */
+	if (!generic_ci_validate_strict_name(dir, add_name)) {
+		err = -EINVAL;
+		goto out_brelse;
+	}
+
+	/* Copy the old LUFID so a failed re-add can restore it */
+	err = ext4_lufid_snapshot(de, sb->s_blocksize, &old_snap);
+	if (err)
+		goto out_brelse;
+
+	/*
+	 * Set up both names before the entry is deleted, so neither the
+	 * re-add nor the rollback has to allocate memory afterwards.
+	 */
+	err = ext4_fname_setup_filename(dir, add_name, 0, &new_fname);
+	if (err)
+		goto out_brelse;
+	new_fname.dfid = ext4_dentry_get_fid(sb, edp);
+	err = ext4_fname_setup_filename(dir, add_name, 0, &old_fname);
+	if (err)
+		goto out_brelse;
+	old_fname.dfid = old_snap.fid;
+
+	err = ext4_delete_entry(handle, dir, de, bh);
+	if (err)
+		goto out_brelse;
+
+	brelse(bh);
+	bh = NULL;
+
+	err = ext4_add_fname(handle, dir, &new_fname, inode);
+	if (err) {
+		/*
+		 * The old entry fits in the space it was deleted from, so
+		 * this needs no new block.
+		 */
+		err2 = ext4_add_fname(handle, dir, &old_fname, inode);
+		if (err2)
+			EXT4_ERROR_INODE(dir,
+				"Failed to set LUFID on '%.*s' (err=%d) and failed to restore the original directory entry (err=%d); inode %llu may be orphaned",
+				namelen, filename, err, err2,
+				(unsigned long long)inode->i_ino);
+		goto out_journal;
+	}
+
+	inode_set_ctime_current(dir);
+	inode_inc_iversion(dir);
+	ext4_mark_inode_dirty(handle, dir);
+
+out_brelse:
+	brelse(bh);
+out_journal:
+	ext4_fname_free_filename(&new_fname);
+	ext4_fname_free_filename(&old_fname);
+	kfree(stored.name);
+	ext4_lufid_snap_release(&old_snap);
+	if (handle) {
+		err2 = ext4_journal_stop(handle);
+		if (!err)
+			err = err2;
+	}
+out_iput:
+	iput(inode);
+out_unlock_dir:
+	inode_unlock(dir);
+
+	return err;
+}
+
 /*
  * directories can handle most operations...
  */
diff --git a/include/uapi/linux/ext4.h b/include/uapi/linux/ext4.h
index 9c683991c32f..5d5c8c3df2a4 100644
--- a/include/uapi/linux/ext4.h
+++ b/include/uapi/linux/ext4.h
@@ -35,6 +35,7 @@
 #define EXT4_IOC_SETFSUUID		_IOW('f', 44, struct fsuuid)
 #define EXT4_IOC_GET_TUNE_SB_PARAM	_IOR('f', 45, struct ext4_tune_sb_params)
 #define EXT4_IOC_SET_TUNE_SB_PARAM	_IOW('f', 46, struct ext4_tune_sb_params)
+#define EXT4_IOC_SET_LUFID		_IOW('f', 47, struct ext4_set_lufid)
 
 #define EXT4_IOC_SHUTDOWN _IOR('X', 125, __u32)
 
@@ -92,6 +93,19 @@ struct move_extent {
 	__u64 moved_len;	/* moved block length */
 };
 
+/*
+ * Structure for EXT4_IOC_SET_LUFID
+ * Sets LUFID on a directory entry
+ * Called on parent directory with filename and LUFID data as arguments
+ */
+struct ext4_set_lufid {
+	__u8 esl_name_len;	/* length of filename, NOT including NUL terminator
+				 * (valid range: 1-255, matching EXT4_NAME_LEN) */
+	char  esl_name[255 + 1]; /* filename (NUL-terminated) */
+	__u8 esl_data_len;	/* length of LUFID data (1-48) */
+	char  esl_data[255]; /* LUFID data (raw bytes) */
+};
+
 /*
  * Flags used by EXT4_IOC_SHUTDOWN
  */
-- 
2.52.0

