Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202112D661C
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 00:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459341; cv=none; b=XtDCl0RS6/moOsNVU7h49YJKnubQu/HkUOFOgSavMrjVygb2IpAKkd3cMIi+DyPJSzSgWu8931dh/D0dpDqYnghRVnc5Grk+cIJGc2/+gxL+hi2yaJipis0xG3svyE2sT6wNFEHPUdLne6YLDtsAN6GO/P+tvObssm3Ed1I9drI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459341; c=relaxed/simple;
	bh=ycN3Pp+TlB9ODBFJC8n/a/I3XiUMwkiwxQ9pnwqIX8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TymLm1uwq3ScgWtdIakA2Ef3bkBxChm9OpTb0msFUijcKH+MurIEQ/BjNfadO+dcpV32pt/JbuXTqEbTaGWpVdMKnCf+ysLiUaWIi58XiX15letkvkcjZ2PFoIxynWZ5Md+7sJC4JlaTYfJE/o40V+b8M0mIkPdmDtDCUIDWWrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RmrHJevr; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RmrHJevr"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47de008b020so165984f8f.1
        for <linux-ext4@vger.kernel.org>; Thu, 30 Jul 2026 17:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459337; x=1786064137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Uw+1VKpvUdcuEx6q/be0NI8IUj3h3s+2yIFN3Ld0WY=;
        b=RmrHJevrqxpeCFKbe32a/2E+XDDzReJLzTT6aNky7NLLiGbqrBrcwEYOjNdvtfqTEQ
         o4LY476QB+pp7urgis2pp1wp6knafxdm024F9M6Q/tqvPwEEpdCxcGDIcaRX5MCzL8RA
         jZn+z5bKVGmjmcqV0x/GYPFbTOcxh96pk0rp+bdHN0LHUb2g50/WXQpbMNZBeUkrtQTz
         Z9nlPJSgpd4rPJRRowumgsxocNeL1hqo8tplnlyksS2gHnp0jc9Y/d/fsegWkDCfsnRY
         BPCrAXtDQkadrAWcWFP/NT/LAevbtEg8ILMoz1UKPwDTpwGUInlnovI1i9pRR8ZVbf4D
         TUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459337; x=1786064137;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Uw+1VKpvUdcuEx6q/be0NI8IUj3h3s+2yIFN3Ld0WY=;
        b=Ad82yWZrML0+9AvGoxt9cO7yVhWxHQXYi36MzyTo2zGogrzfkWb/luXSaKgyoezwQI
         4UubZRRuY1mGv+NOLdMuq/9hCH+fUaVvvDpEwPLZw4R6VDaZAQ701xSbM5mjJronBSW3
         FT5tMbpTX4cCZYhdD6WsmWicx7dpQVrHySstOTStKhglYJSdlyail7X7ZZohUE+74eap
         7u0hRIWbgHiNaXFx3MfhIBjw11NgTgf5R82REeg1pqInqGkS3lBO+rFb/t937cZ14go0
         KrclparD9IEqV0g8B0buDQZQLcpExA9HmeP2NIZ0DdROcPImctI6OgMselrt+JYsESlF
         G5Hg==
X-Gm-Message-State: AOJu0YxguE8lhFbNz5As7+XKYG/f2USsFENcbaEyofbQAT/KkwE5JUZL
	N09i/FjwGeEwd711J1ijXEF1FIlU7zgDIJeSqvuwve2dnAD/We0wZc9JvRTJIYlr
X-Gm-Gg: AR+sD12aHMqXR7UjctgL+cbwM9iGaULmyV7bvgb/a3zVTiIGXATaQdPBK3RbfQsgVyT
	+RF+zEimTBBoAhPaXBxd86vlhuQaGITkRcj7RVxM0WTFHvRvwWInVgra2BwUFu2qwFibzaLLk8Q
	Mbm8NK3ZptklYPfZD6D0Cfmt06L6YBpSSGx85QJRLUhCoPEbvh3bx2LwJ85hPaHJ/XWkatjc6oh
	ImYVaYcozLHQLXuohfRukYXvcF7l/CQZFrPbbadOh6Rg2ooPk1Y+VuMq20vCpFnzlvwtuYHNCOC
	j2jIY0+4bMS1txoDc02PJVJiwo5cX0ZzmzOX6iKUoDH09c1YUikLOI6KscFrfehiouM+iOWFrbw
	6Lxmtrmvtdbc5W1K7hRuoqTXTCTG5/7ZtxRCxZCBR4Tj+UnynBSIbd3HrU8yAsUweeyLnlv1ayu
	gZ0uF6gnMdrsOLZQIloOaXgsVSJ/Mvpf5B8uXrmbV2oaNd+1f6nAh1L90YMoATF8vP0KbiClKjg
	bQLn081a/b+TfeOD2DRYDlamYQOQE8=
X-Received: by 2002:a05:6000:26cb:b0:47f:853c:ad7b with SMTP id ffacd0b85a97d-47fcbc8971bmr4454879f8f.9.1785459337252;
        Thu, 30 Jul 2026 17:55:37 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f4csm11975801f8f.2.2026.07.30.17.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:55:36 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v9 09/11] ext4: add dirdata LUFID support for directory entry rename
Date: Thu, 30 Jul 2026 20:54:26 -0400
Message-ID: <20260731005430.36801-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
References: <20260731005430.36801-1-ablagodarenko@thelustrecollective.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ext4_setent() updates the inode number and file_type in an existing
directory entry but did not handle the dirdata extension payload.
Extend it with a src_fid parameter so that the source LUFID travels
with the inode through rename.

When src_fid is non-NULL and the destination slot carries a LUFID of
the same on-disk size, the source payload is copied into the destination
before the file_type merge.  When src_fid is NULL (source has no LUFID),
EXT4_DIRENT_LUFID is cleared from the destination entry.

CFHASH bytes are left in place: CFHASH is a property of the destination
filename, not the inode, and it always precedes CFHASH in the extension
layout so its offset is unaffected by the LUFID copy.

Both ext4_rename() and ext4_cross_rename() snapshot the source LUFID
into a stack buffer before any setent() call, so that a cross-directory
swap reads both sides before either is overwritten.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 fs/ext4/namei.c | 190 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 180 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 3a99ce710722..f7813b1043cd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3748,7 +3748,8 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 }
 
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
-		       unsigned ino, unsigned file_type)
+		       unsigned ino, unsigned file_type,
+		       const struct ext4_dirent_fid *src_fid)
 {
 	int retval, retval2;
 
@@ -3758,8 +3759,57 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	if (retval)
 		return retval;
 	ent->de->inode = cpu_to_le32(ino);
-	if (ext4_has_feature_filetype(ent->dir->i_sb))
-		ent->de->file_type = file_type;
+	if (ext4_has_feature_filetype(ent->dir->i_sb)) {
+		/* Copy the source LUFID payload into the destination slot when
+		 * both carry a LUFID of the same on-disk size.  LUFID is
+		 * inode-specific and must travel with the inode through rename.
+		 * CFHASH bytes are left in-place: CFHASH is a function of the
+		 * destination filename, and its bytes sit at the correct offset
+		 * because LUFID always precedes CFHASH in the extension layout.
+		 * When src_fid is NULL, the LUFID flag is synced to the LUFID
+		 * bit already present in file_type: callers that clear LUFID
+		 * (rename of a non-LUFID inode, whiteout) pass file_type with
+		 * LUFID=0; ext4_resetent passes the original file_type so the
+		 * flag is restored for error recovery without overwriting the
+		 * LUFID bytes that are still intact on disk. */
+		if (ext4_has_feature_dirdata(ent->dir->i_sb)) {
+			if (src_fid && (ent->de->file_type & EXT4_DIRENT_LUFID)) {
+				unsigned int rec_len =
+					ext4_rec_len_from_disk(ent->de->rec_len,
+						ent->dir->i_sb->s_blocksize);
+				unsigned int ddh_off =
+					EXT4_BASE_DIR_LEN + ent->de->name_len + 1;
+				struct ext4_dirent_data_header *ddh =
+					(struct ext4_dirent_data_header *)
+					((char *)ent->de + ddh_off);
+				unsigned int copy_len = src_fid->df_header.ddh_length;
+
+				if (ddh_off + sizeof(*ddh) > rec_len ||
+				    ddh->ddh_length != copy_len ||
+				    ddh_off + copy_len > rec_len) {
+					/* Cannot copy: clear the flag so the
+					 * slot does not advertise a stale LUFID
+					 * from the old inode. */
+					ent->de->file_type &= ~EXT4_DIRENT_LUFID;
+				} else {
+					memcpy(ddh, src_fid, copy_len);
+				}
+			} else if (!src_fid) {
+				/* Sync the LUFID flag with what file_type requests.
+				 * For normal rename (source has no LUFID) and for
+				 * the whiteout setent, file_type carries LUFID=0,
+				 * so we clear the stale flag.  For ext4_resetent
+				 * (error recovery), file_type is the original
+				 * file_type with LUFID=1, so we restore the flag —
+				 * the LUFID bytes are still on disk untouched. */
+				ent->de->file_type =
+					(ent->de->file_type & ~EXT4_DIRENT_LUFID) |
+					(file_type & EXT4_DIRENT_LUFID);
+			}
+		}
+		ent->de->file_type = (file_type & EXT4_FT_MASK) |
+				     (ent->de->file_type & ~EXT4_FT_MASK);
+	}
 	inode_inc_iversion(ent->dir);
 	inode_set_mtime_to_ts(ent->dir, inode_set_ctime_current(ent->dir));
 	retval = ext4_mark_inode_dirty(handle, ent->dir);
@@ -3796,7 +3846,7 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 		return;
 	}
 
-	ext4_setent(handle, &old, ino, file_type);
+	ext4_setent(handle, &old, ino, file_type, NULL);
 	brelse(old.bh);
 }
 
@@ -3895,6 +3945,67 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
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
+	dlen = disk_fid->df_header.ddh_length;
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
@@ -3923,6 +4034,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	struct inode *whiteout = NULL;
 	int credits;
 	u8 old_file_type;
+	struct ext4_lufid_snap old_snap = {};
 
 	if (new.inode && new.inode->i_nlink == 0) {
 		EXT4_ERROR_INODE(new.inode,
@@ -4028,27 +4140,60 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
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
+		if (old_snap.fid)
+			ext4_fc_mark_ineligible(old.dir->i_sb,
+						EXT4_FC_REASON_DIRDATA, handle);
+		else
+			old_file_type &= ~EXT4_DIRENT_LUFID;
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
+		struct ext4_dentry_param *edp = NULL;
+		if (old_snap.fid) {
+			/* Wrap the snapshotted LUFID in an ext4_dentry_param so
+			 * ext4_add_entry() picks it up via d_fsdata. */
+			unsigned fid_size = old_snap.fid->df_header.ddh_length;
+
+			edp = kmalloc(offsetof(struct ext4_dentry_param,
+					       edp_dfid) + fid_size, GFP_NOFS);
+			if (!edp) {
+				retval = -ENOMEM;
+				goto end_rename;
+			}
+			edp->edp_magic = EXT4_LUFID_MAGIC;
+			memcpy(&edp->edp_dfid, old_snap.fid, fid_size);
+		}
+		new.dentry->d_fsdata = edp;
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
+		new.dentry->d_fsdata = NULL;
+		kfree(edp);
 		if (retval)
 			goto end_rename;
 	} else {
 		retval = ext4_setent(handle, &new,
-				     old.inode->i_ino, old_file_type);
+				     old.inode->i_ino, old_file_type, old_snap.fid);
 		if (retval)
 			goto end_rename;
 	}
@@ -4135,6 +4280,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
 	if (whiteout) {
 		if (retval) {
 			ext4_resetent(handle, &old,
@@ -4171,8 +4317,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 		.inode = d_inode(new_dentry),
 	};
-	u8 new_file_type;
+	u8 new_file_type, old_de_file_type;
 	int retval;
+	struct ext4_lufid_snap old_snap = {}, new_snap = {};
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
@@ -4251,12 +4398,33 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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
 
@@ -4289,6 +4457,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
+	ext4_lufid_snap_release(&new_snap);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
-- 
2.43.7

