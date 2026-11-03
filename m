Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713832;
	b=w4/nYI1KxV/wb7HBrgd1iZeOWv2yQPxoBunnZwU85uYVqfpKg1TZqPJBYYC9IAjgTsH4
	 7kRjqNSfIhfRMgEUL+Tsu547qCKqKER8UyJrqKkXEy2LgzqdVkCl1oZpHrrdAYGdhFRzI
	 PzK1RfiLL6qVAizHwvPX7px0paCeQnrEvHDv6qEhPa3in6sOrggbBflO5/lZ0vGp7Hgm+
	 EOYbipdocDP1fyCxHqpUVs9UkEPmNesbdq1Y9wdupn+sOBH2yNt1tRidNsVAXJljpX6TM
	 3OC+WyS91lcnWnhgh0tr9hyQ+Wpl1FYV70ARhSFRmYYA1/my5h1jieA76ZSI9Rv9xMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713832;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=2Rvcnz2bZpukE6jl0ni/GzFq3x05wPe7s1F+xDUMD+o=;
	b=xR50QoNos1wAz8xx0c7pMh5ZKJEsJXXk949Nj+udBp17mGCRD0ntURYiXP7rvmzpckpQ
	 UOEe5Qnu7fq++CBIlQhPV8mOkNYeGGSz+VdhB6YuNg9t5C4njZO/V1sgoraVukXh+9G9u
	 HyuTqzb1ygpYW486+ir1mNwRlfrAQ20SUDdAT4GEdYjSbx9109zwcoF3rYFDp9y6lA/c+
	 iaNIixPmTX1/an4emvGr9bYpj0Duv43lCJ7wllVgYoas448nECCmFk7iAlN8W55qa9Dd9
	 DG0HrzAjsxY+3rLLzT9bXTNNexQeB216YAwasA2cl9/yvEuCDGHjB0xF5ReiQxWnBNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YbBV7J8S;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD228606D81A
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD228606D81A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YbBV7J8S
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a60f9474c4so42711825e9.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713830; x=1794318630; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2Rvcnz2bZpukE6jl0ni/GzFq3x05wPe7s1F+xDUMD+o=;
        b=YbBV7J8S4gVJOfD7zY4L19LIvSekTkklFtoYgBEt4io4sU/Qq7MaT7oQK3tbMtcwPP
         QkewV0w7WR/vaDEj59vJw1kMMSarF1iqLgqwOWPg3e0sJdtjT0XWTRzAoMlF9d5y8/Dp
         /BVk+HGNz9oeXhQGHM4fmcLc0vz+Y96ldoZmmveYIgKQjOSC7jDo54AFzWSoHbS7/h8b
         XSaNlODv1oXJ1Fo4fJKtdevZr3oRF7whwe2F+vQD0MTtfp65XyiBwCurnn3n7KAK9n/N
         ZO+mHXugOnyhFuXn1ynfy14hJnf85ElLTlVieK7tI9JcSBWKZomqC7i0ll2Sy+CosQAZ
         7tBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713830; x=1794318630;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2Rvcnz2bZpukE6jl0ni/GzFq3x05wPe7s1F+xDUMD+o=;
        b=ck4cL6cmTqXEJrtX8TL613WcEIBSgCMMm8eKxZhrkm423hhL6pezr/DesTHhKoR8JL
         88LsgwhGid5lWHgMvQJJ+S786LbSz2B0M4Cno8SSG9Itp5zLOOyj2hBaBJaUnoyA+jRA
         hoSw8a+1b9zGQ4jxslbaXNL9gh8zIG2UHaesLlgv5YzsfbO5pe6amaDNz6sjKTwM5b8P
         V+3CqTMgujsNhpfXUNn/GfrIbXaVfHuJYP9i7kvoau87qDAo0CKGvcVGw9Dkh5FoMf4E
         HArOhR6LuO68nXqg11qxDI/fV5x4n++ufsTVnxn8ymTzPPWIjsYeKImuJJLgGMtbX2yC
         SxXw==
X-Gm-Message-State: APuU4Z/LdWEFYQOPnHvHRiNw9IayrN6LTtT+hsgaYpXh8rWaGZYfYnam
	8CNwF3mVD9XFDKW1Dl8PAsacDSGhvhiCnGHCxDboRiqUjdX+bF+0K7wfGx16c/BcYWo=
X-Gm-Gg: AYBFou2+EAXp+Io8zVB5WLZXcl5VpYfN3JPvrXPMkP11yDBiU1ZzKVhZXQepdSNlOsh
	1yVvJkWMtokDIvSkPrJwK4fGhtK+1ccE+QdMyGYt7846wt+X0iZujj6N2A72ZWuST2MV1dBIxLQ
	sGcSbdrsTiHMgvDagd+qvF5p7MvRh5IVF199M2p6VKhEDJyKnkTJew6dvjrNdkncQBws+QnWBo3
	BFvXyBpoaV93rOw+fysRVDhNP9K+1McNCmXzX0Qius2J+1jJzs9+nW3Jh/PyTnluQEjirwqRW1S
	EkRe0yXlH02mCwtZiuRCRLlSUm3MmhK46s3MBDZBsilwIpZZpsi094kWg+AuXeiILERWLGOoeJg
	DP3OzsSVlJ8W+JrB50TJGuTvelupIx8Q8+BHw15l6E7mQg7uhyCFpivZwb+gIOnmR59yI9udkuM
	7KIHFnsNONrGXokLuck/i8Zp45eh4OinBt2qmT3eh6ntwXdKalmbD0a7zZ/hRCc29kEFXLMvD3c
	e/6bHnMQzP4wqqGnvuxHIfRkb4548KIiagcV8n9ySKRPzHCprevvdWVi3GIi8eAZsRENaNy0EEV
	MZyyN8Z7FJ6JjYwLJbBWqcI9bgDWfoejf6sWs8/kyIvkYGrZKMcnqU/BkeC+
X-Received: by 2002:a05:600c:4e12:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4ac1765cf2cmr312876455e9.19.1793713829762;
        Tue, 03 Nov 2026 05:50:29 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abeb77af8csm457146785e9.1.2026.11.03.05.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:29 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v14 10/12] ext4: add dirdata LUFID support for directory entry rename
Date: Tue,  3 Nov 2026 13:49:17 +0000
Message-ID: <20261103134921.610047-11-ablagodarenko@thelustrecollective.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_setent() updates the inode number and file_type in an existing
directory entry but did not handle the dirdata extension payload.
Extend it with a src_fid parameter so that the source LUFID travels
with the inode through rename.

When the destination entry has a LUFID record of the same size, the
source record is copied over it.  Otherwise the LUFID record of the
destination is removed, moving any records that follow it down, and
the source record is added in place if the entry has room for it.  If
it has not, the entry is left without a LUFID.

CFHASH is a property of the destination name, not of the inode, so it
is kept.

Both ext4_rename() and ext4_cross_rename() snapshot the source LUFID
into a stack buffer before any setent() call, so that a cross-directory
swap reads both sides before either is overwritten.  When a
RENAME_WHITEOUT rename fails after the old entry became the whiteout,
ext4_resetent() puts the snapshot back into the old entry.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 fs/ext4/namei.c | 257 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 239 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4f0465d49887..bd0f4760f1e3 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3619,11 +3619,6 @@ int __ext4_link(struct inode *dir, struct inode *inode,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	/* Fast-commit does not record dirdata in its journal format; force a
-	 * full journal commit so the LUFID survives crash+replay. */
-	if (ext4_dentry_get_fid(dir->i_sb, dentry ? dentry->d_fsdata : NULL))
-		ext4_fc_mark_ineligible(dir->i_sb, EXT4_FC_REASON_DIRDATA, handle);
-
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
 
@@ -3796,8 +3791,81 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 	return 0;
 }
 
+/*
+ * ext4_dirent_drop_lufid() - remove the LUFID record from a directory entry
+ * @de:      directory entry
+ * @rec_len: decoded rec_len of @de
+ *
+ * The records that follow LUFID (such as CFHASH) are moved down so they
+ * stay where the parser expects them.  If the records cannot be parsed,
+ * none of them can be trusted and all dirdata flags are cleared.
+ */
+static void ext4_dirent_drop_lufid(struct ext4_dir_entry_2 *de,
+				   unsigned int rec_len)
+{
+	unsigned int off = EXT4_BASE_DIR_LEN + de->name_len + 1;
+	unsigned int dlen, end, llen;
+
+	if (!(de->file_type & EXT4_DIRENT_LUFID))
+		return;
+	dlen = ext4_dirent_get_data_len(de, rec_len);
+	if (!dlen) {
+		de->file_type &= EXT4_FT_MASK;
+		return;
+	}
+	/* ext4_dirent_get_data_len() checked every record against rec_len */
+	llen = *((u8 *)de + off);
+	end = EXT4_BASE_DIR_LEN + de->name_len + dlen;
+	memmove((char *)de + off, (char *)de + off + llen, end - off - llen);
+	de->file_type &= ~EXT4_DIRENT_LUFID;
+}
+
+/*
+ * ext4_dirent_add_lufid() - add a LUFID record to a directory entry in place
+ * @dir:     directory inode
+ * @de:      directory entry without a LUFID record
+ * @rec_len: decoded rec_len of @de
+ * @fid:     LUFID record to add
+ *
+ * LUFID is the first record, so any records already present are moved up.
+ * Returns false, leaving @de untouched, when the entry has no room.
+ */
+static bool ext4_dirent_add_lufid(struct inode *dir,
+				  struct ext4_dir_entry_2 *de,
+				  unsigned int rec_len,
+				  const struct ext4_dirent_fid *fid)
+{
+	unsigned int off = EXT4_BASE_DIR_LEN + de->name_len + 1;
+	unsigned int flen = fid->df_header.ddh_length;
+	unsigned int dlen = ext4_dirent_get_data_len(de, rec_len);
+	unsigned int end;
+
+	if ((de->file_type & ~EXT4_FT_MASK) && !dlen)
+		return false;
+	/* without a CFHASH record the hash sits right after the name */
+	if (ext4_hash_in_dirent(dir) && !(de->file_type & EXT4_DIRENT_CFHASH))
+		return false;
+	end = dlen ? EXT4_BASE_DIR_LEN + de->name_len + dlen : off;
+	if (end + flen > rec_len)
+		return false;
+	memmove((char *)de + off + flen, (char *)de + off, end - off);
+	*((char *)de + EXT4_BASE_DIR_LEN + de->name_len) = 0;
+	memcpy((char *)de + off, fid, flen);
+	de->file_type |= EXT4_DIRENT_LUFID;
+	return true;
+}
+
+/*
+ * ext4_setent() - point a directory entry at another inode
+ * @src_fid: LUFID record of that inode, or NULL
+ *
+ * LUFID is inode-specific, so the record of @ent is replaced by @src_fid.
+ * Other records (CFHASH) belong to the name and are kept.  If the entry
+ * has no room for @src_fid, the entry is left without a LUFID.
+ */
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
-		       unsigned ino, unsigned file_type)
+		       unsigned ino, unsigned file_type,
+		       const struct ext4_dirent_fid *src_fid)
 {
 	int retval, retval2;
 
@@ -3807,8 +3875,33 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	if (retval)
 		return retval;
 	ent->de->inode = cpu_to_le32(ino);
-	if (ext4_has_feature_filetype(ent->dir->i_sb))
-		ent->de->file_type = file_type;
+	if (ext4_has_feature_filetype(ent->dir->i_sb)) {
+		if (ext4_has_feature_dirdata(ent->dir->i_sb)) {
+			unsigned int rec_len =
+				ext4_rec_len_from_disk(ent->de->rec_len,
+						ent->dir->i_sb->s_blocksize);
+			unsigned int off =
+				EXT4_BASE_DIR_LEN + ent->de->name_len + 1;
+			struct ext4_dirent_fid *fid =
+				(struct ext4_dirent_fid *)((char *)ent->de + off);
+
+			if (src_fid &&
+			    (ent->de->file_type & EXT4_DIRENT_LUFID) &&
+			    ext4_dirent_get_data_len(ent->de, rec_len) &&
+			    fid->df_header.ddh_length ==
+			    src_fid->df_header.ddh_length) {
+				memcpy(fid, src_fid,
+				       src_fid->df_header.ddh_length);
+			} else {
+				ext4_dirent_drop_lufid(ent->de, rec_len);
+				if (src_fid)
+					ext4_dirent_add_lufid(ent->dir, ent->de,
+							      rec_len, src_fid);
+			}
+		}
+		ent->de->file_type = (file_type & EXT4_FT_MASK) |
+				     (ent->de->file_type & ~EXT4_FT_MASK);
+	}
 	inode_inc_iversion(ent->dir);
 	inode_set_mtime_to_ts(ent->dir, inode_set_ctime_current(ent->dir));
 	retval = ext4_mark_inode_dirty(handle, ent->dir);
@@ -3824,7 +3917,8 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 }
 
 static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
-			  unsigned ino, unsigned file_type)
+			  unsigned ino, unsigned file_type,
+			  const struct ext4_dirent_fid *fid)
 {
 	struct ext4_renament old = *ent;
 	int retval = 0;
@@ -3845,7 +3939,7 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 		return;
 	}
 
-	ext4_setent(handle, &old, ino, file_type);
+	ext4_setent(handle, &old, ino, file_type, fid);
 	brelse(old.bh);
 }
 
@@ -3944,6 +4038,69 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
 	return wh;
 }
 
+/*
+ * Stack buffer sized for 1-byte header + 4 × 16-byte FIDs, covering virtually
+ * all real-world LUFID payloads without a heap allocation.  ddh_length is u8
+ * so the absolute maximum is 255 bytes; larger payloads fall back to kmalloc.
+ */
+#define EXT4_LUFID_INLINE_SIZE  65
+
+struct ext4_lufid_snap {
+	struct ext4_dirent_fid *fid;	/* NULL or valid; never ERR_PTR */
+	bool on_heap;
+	u8 buf[EXT4_LUFID_INLINE_SIZE];
+};
+
+/*
+ * ext4_lufid_snapshot - copy the LUFID record from a directory entry
+ *
+ * Fills @snap with a copy of the on-disk LUFID record.  For payloads up to
+ * EXT4_LUFID_INLINE_SIZE bytes the inline buffer is used; larger payloads
+ * fall back to a heap allocation.  Returns 0 on success (snap->fid is NULL
+ * when no LUFID is present), or -ENOMEM when a heap allocation fails.
+ * Call ext4_lufid_snap_release() when done.
+ */
+static int ext4_lufid_snapshot(struct ext4_dir_entry_2 *de,
+			       unsigned int blocksize,
+			       struct ext4_lufid_snap *snap)
+{
+	unsigned int ddh_off = EXT4_BASE_DIR_LEN + de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	struct ext4_dirent_fid *disk_fid;
+	unsigned int dlen;
+
+	snap->fid = NULL;
+	snap->on_heap = false;
+
+	if (!(de->file_type & EXT4_DIRENT_LUFID))
+		return 0;
+	if (ddh_off + sizeof(disk_fid->df_header) > rec_len)
+		return 0;
+	disk_fid = (struct ext4_dirent_fid *)((char *)de + ddh_off);
+	dlen = READ_ONCE(disk_fid->df_header.ddh_length);
+	if (dlen < sizeof(disk_fid->df_header) || ddh_off + dlen > rec_len)
+		return 0;
+
+	if (dlen <= sizeof(snap->buf)) {
+		memcpy(snap->buf, disk_fid, dlen);
+		snap->fid = (struct ext4_dirent_fid *)snap->buf;
+	} else {
+		snap->fid = kmemdup(disk_fid, dlen, GFP_NOFS);
+		if (!snap->fid)
+			return -ENOMEM;
+		snap->on_heap = true;
+	}
+	/* the length byte may have changed under us: keep the checked one */
+	snap->fid->df_header.ddh_length = dlen;
+	return 0;
+}
+
+static void ext4_lufid_snap_release(struct ext4_lufid_snap *snap)
+{
+	if (snap->on_heap)
+		kfree(snap->fid);
+}
+
 /*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
@@ -3970,8 +4127,10 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	int force_reread;
 	int retval;
 	struct inode *whiteout = NULL;
+	struct ext4_dentry_param *edp = NULL;
 	int credits;
 	u8 old_file_type;
+	struct ext4_lufid_snap old_snap = {};
 
 	if (new.inode && new.inode->i_nlink == 0) {
 		EXT4_ERROR_INODE(new.inode,
@@ -4077,29 +4236,65 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	force_reread = (new.dir->i_ino == old.dir->i_ino &&
 			ext4_test_inode_flag(new.dir, EXT4_INODE_INLINE_DATA));
 
+	if (ext4_has_feature_dirdata(old.dir->i_sb)) {
+		/* Snapshot before whiteout's ext4_setent() clears the LUFID
+		 * flag in old.de; the snapshot is also needed for the !new.bh
+		 * path below where we must carry the LUFID to the new entry. */
+		retval = ext4_lufid_snapshot(old.de,
+					     old.dir->i_sb->s_blocksize,
+					     &old_snap);
+		if (retval)
+			goto end_rename;
+		if (!old_snap.fid)
+			old_file_type &= ~EXT4_DIRENT_LUFID;
+	}
+
+	/* Allocate the LUFID wrapper for ext4_add_entry() before any
+	 * destructive changes to the old entry.  An OOM failure after
+	 * ext4_setent() has already compacted the extensions would trigger
+	 * the lossy resetent path; pre-allocating here avoids that. */
+	if (!new.bh && old_snap.fid) {
+		unsigned fid_size = old_snap.fid->df_header.ddh_length;
+
+		edp = kmalloc(offsetof(struct ext4_dentry_param,
+				       edp_dfid) + fid_size, GFP_NOFS);
+		if (!edp) {
+			retval = -ENOMEM;
+			goto end_rename;
+		}
+		edp->edp_magic = EXT4_LUFID_MAGIC;
+		memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
+	}
+
 	if (whiteout) {
 		/*
 		 * Do this before adding a new entry, so the old entry is sure
 		 * to be still pointing to the valid old entry.
 		 */
 		retval = ext4_setent(handle, &old, whiteout->i_ino,
-				     EXT4_FT_CHRDEV);
+				     EXT4_FT_CHRDEV, NULL);
 		if (retval)
 			goto end_rename;
 		retval = ext4_mark_inode_dirty(handle, whiteout);
 		if (unlikely(retval))
 			goto end_rename;
-
 	}
 	if (!new.bh) {
+		new.dentry->d_fsdata = edp;
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
+		new.dentry->d_fsdata = NULL;
 		if (retval)
 			goto end_rename;
 	} else {
 		retval = ext4_setent(handle, &new,
-				     old.inode->i_ino, old_file_type);
+				     old.inode->i_ino, old_file_type, old_snap.fid);
 		if (retval)
 			goto end_rename;
+		/* ext4_setent() writes the LUFID in-place without going through
+		 * __ext4_add_entry(), so mark ineligible here if needed. */
+		if (old_snap.fid)
+			ext4_fc_mark_ineligible(old.dir->i_sb,
+						EXT4_FC_REASON_DIRDATA, handle);
 	}
 	if (force_reread)
 		force_reread = !ext4_test_inode_flag(new.dir,
@@ -4184,10 +4379,11 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = 0;
 
 end_rename:
+	kfree(edp);
 	if (whiteout) {
 		if (retval) {
-			ext4_resetent(handle, &old,
-				      old.inode->i_ino, old_file_type);
+			ext4_resetent(handle, &old, old.inode->i_ino,
+				      old_file_type, old_snap.fid);
 			drop_nlink(whiteout);
 			ext4_mark_inode_dirty(handle, whiteout);
 			ext4_orphan_add(handle, whiteout);
@@ -4199,6 +4395,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		ext4_journal_stop(handle);
 	}
 release_bh:
+	ext4_lufid_snap_release(&old_snap);
 	brelse(old.dir_bh);
 	brelse(old.bh);
 	brelse(new.bh);
@@ -4220,8 +4417,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 		.inode = d_inode(new_dentry),
 	};
-	u8 new_file_type;
+	u8 new_file_type, old_de_file_type;
 	int retval;
+	struct ext4_lufid_snap old_snap = {}, new_snap = {};
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
@@ -4300,12 +4498,33 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 
+	if (ext4_has_feature_dirdata(old.dir->i_sb)) {
+		retval = ext4_lufid_snapshot(old.de, old.dir->i_sb->s_blocksize,
+					     &old_snap);
+		if (retval)
+			goto end_rename;
+		retval = ext4_lufid_snapshot(new.de, new.dir->i_sb->s_blocksize,
+					     &new_snap);
+		if (retval)
+			goto end_rename;
+		if (old_snap.fid || new_snap.fid)
+			ext4_fc_mark_ineligible(old.dir->i_sb,
+						EXT4_FC_REASON_DIRDATA, handle);
+	}
+
+	old_de_file_type = old.de->file_type;
+	if (!old_snap.fid)
+		old_de_file_type &= ~EXT4_DIRENT_LUFID;
 	new_file_type = new.de->file_type;
-	retval = ext4_setent(handle, &new, old.inode->i_ino, old.de->file_type);
+	if (!new_snap.fid)
+		new_file_type &= ~EXT4_DIRENT_LUFID;
+	retval = ext4_setent(handle, &new, old.inode->i_ino, old_de_file_type,
+			     old_snap.fid);
 	if (retval)
 		goto end_rename;
 
-	retval = ext4_setent(handle, &old, new.inode->i_ino, new_file_type);
+	retval = ext4_setent(handle, &old, new.inode->i_ino, new_file_type,
+			     new_snap.fid);
 	if (retval)
 		goto end_rename;
 
@@ -4338,6 +4557,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
+	ext4_lufid_snap_release(&new_snap);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
-- 
2.52.0

