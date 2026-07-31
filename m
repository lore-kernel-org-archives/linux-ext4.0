Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4DD442B3D
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512340; cv=none; b=f/kpr5Nuxe9lVqvS9Nut/Ibl0Z4MXBKgGN6fYnD/HDN5/kMRHqpCjmUeSj8x4THYFYzpm11XHTPSHCVK2MD17usIUd1BFGL8PHc+r1N+kDQznuwqdjLVQ41DSnEEwJuhwcYJNSsnBUaQE72nwwO2xdmIJ+CMKm8UUTzdvPhiDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512340; c=relaxed/simple;
	bh=u6beKG7EtG+5kayDkaO3cB99szTCvY4Sr5JIW9Y2i+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fxUJY9cwnVsXi8S2tgvzXeR7q8MU9K+ZsGEITWbUuhdw1sexcRFW/0OkU/qjNKnpQf7j784oMvDMa0KY45G8r2/TXWZAP8DMyZ/woq9WDdqPpzNGpAj4HbjwB7bFi85VnHjklT900xcF3LqSgRWnxxE1HP/1x3VhbqCNo25vWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCM83xxj; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCM83xxj"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fd4ee0b01so439775f8f.2
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 08:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512337; x=1786117137; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GmKq4jCxCauX8H3GWsFvvhHp3+g+Jn8SjIowmGjl4BQ=;
        b=TCM83xxj0CbGPWqmBTn4gWAevEDy5XT+P5N7T6CDisnbWWSVnWfXJiglmuoNAPocK+
         jaNGpsOJZXMxlxMZt0Wp28TWdUpnzfy61XkT2gLi+r7yFgpcl/hIV2gvFq1tWDV8ojya
         xez2qKuKdCLT7f5TEmH/6Zq5tR9WxgqSEhCyL9+XOthQ6Z/er1CGLxJ6dxavWAGD7de9
         tyLmz5huC4+c29HxAD66AOvlCcv2tWUe0IH4uDVMxujLEr7soBKWY/sX8CQ3aNiQzrm9
         1J3pruBwemRBDYrQeoK8i+HB7LEsF3NyPBMl6GnIlL5aHv72WaKJn1C4tCpPy4iUmFrf
         9ceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512337; x=1786117137;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GmKq4jCxCauX8H3GWsFvvhHp3+g+Jn8SjIowmGjl4BQ=;
        b=MXpucjnv+u8JAMApQoB21cdztlcdjP8qh66CZra8ZQ/PsCBeguMdJlY2P5ulVEYiqZ
         9Npa/UOCI+BJUqHOaGlkQ3U/wNaV+/RTcPd/pHULEAQxxvA3V3hS9XG6lYRt7dhaM22H
         mM/yidyOrVbB7eVlwfZU/C3ThcSQR2AHvv5UW0dZuQvPb57HcVm9bVUvzrQxzs2PhifG
         gbszUlFRDL5G+eJEKzq1mQvvu4tFgt+HRxnwgGnDzN8hCCQN8pUMf3qe7Teagt7s8eP0
         l80O/jCchQagOlerDxZMkBSFOxWrmBybe5apuLNt6bLWDtwosE9PB8a33jqkain4FSLp
         /Lgg==
X-Gm-Message-State: AOJu0YyYJA7in8LjQGKgvXjjnzJ6EUzARcxzB12s4NxYpL9rnvRLSpQ8
	gknUe+cBkA1BT7MvQodvT7o0JQYxwXC9fgmpWzUqEOCLAfJf6qqY7UVAUprXfAKr
X-Gm-Gg: AR+sD125e94Dpy3cf++F3QWHqRXIIY5ilCHV4hQsSnvy6vJqWOLNFi4ZKPr3vx+Zpoa
	j4KawqLO4bA/55ASnTlD+ILYDadHOifgTq699KNg0YPYsJXfzyOKYhgovaDuDoRrG1b65PimplF
	AELkRRp/e7v61iSOsbH6r+vWU3rRorb/ss2SIti1sEfjnXLDzDbyR3My+Co5Hu9pqm5lfDa+u7g
	csiUMExDLLlfz6eZW28DDqAIa13NP+No3eF3alHAa7fK28t+I9qQrTnWdsCUZ2ONx/cEiS41GCp
	T1qgWBfQ4lwOfltHmeM4rWR9OyMQWl+Vi3Jqlp+YhrpOtg2T/u6tZeIfZepkxjjsUaTyPo1Gox1
	jk1GAN4POHqfSERbyXCNWI3QlDsK54Dhnv0LdEx2L8S8zdHaytuV3slRC8fUZhB5jkncVmAN5kF
	IsApGwk8NRoEWfXOpohiOUsV33SlTwB3pT+wCdpVGU3r7BLIxc2H9+rwmsVyrBZf9lDwgmcLTid
	zD0dmIXPuuPuLbV2bHGNqa2tWbZ+dI=
X-Received: by 2002:a5d:525c:0:b0:47f:8b9e:f44e with SMTP id ffacd0b85a97d-47fd72ab56cmr242355f8f.12.1785512336609;
        Fri, 31 Jul 2026 08:38:56 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd41cfde0sm5098345f8f.3.2026.07.31.08.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:38:56 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v10 09/11] ext4: add dirdata LUFID support for directory entry rename
Date: Fri, 31 Jul 2026 11:37:43 -0400
Message-ID: <20260731153753.28309-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
References: <20260731153753.28309-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 198 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 183 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5c8204df26f8..a83342fc81c4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3571,11 +3571,6 @@ int __ext4_link(struct inode *dir, struct inode *inode,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	/* Fast-commit does not record dirdata in its journal format; force a
-	 * full journal commit so the LUFID survives crash+replay. */
-	if (ext4_dentry_get_fid(dir->i_sb, dentry ? dentry->d_fsdata : NULL))
-		ext4_fc_mark_ineligible(dir->i_sb, EXT4_FC_REASON_DIRDATA, handle);
-
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
 
@@ -3749,7 +3744,8 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 }
 
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
-		       unsigned ino, unsigned file_type)
+		       unsigned ino, unsigned file_type,
+		       const struct ext4_dirent_fid *src_fid)
 {
 	int retval, retval2;
 
@@ -3759,8 +3755,57 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
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
@@ -3797,7 +3842,7 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 		return;
 	}
 
-	ext4_setent(handle, &old, ino, file_type);
+	ext4_setent(handle, &old, ino, file_type, NULL);
 	brelse(old.bh);
 }
 
@@ -3896,6 +3941,67 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
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
@@ -3924,6 +4030,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	struct inode *whiteout = NULL;
 	int credits;
 	u8 old_file_type;
+	struct ext4_lufid_snap old_snap = {};
 
 	if (new.inode && new.inode->i_nlink == 0) {
 		EXT4_ERROR_INODE(new.inode,
@@ -4029,29 +4136,65 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
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
+			 * ext4_add_entry() picks it up via d_fsdata; it will call
+			 * ext4_fc_mark_ineligible() inside __ext4_add_entry(). */
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
+		/* ext4_setent() writes the LUFID in-place without going through
+		 * __ext4_add_entry(), so mark ineligible here if needed. */
+		if (old_snap.fid)
+			ext4_fc_mark_ineligible(old.dir->i_sb,
+						EXT4_FC_REASON_DIRDATA, handle);
 	}
 	if (force_reread)
 		force_reread = !ext4_test_inode_flag(new.dir,
@@ -4136,6 +4279,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
 	if (whiteout) {
 		if (retval) {
 			ext4_resetent(handle, &old,
@@ -4172,8 +4316,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 		.inode = d_inode(new_dentry),
 	};
-	u8 new_file_type;
+	u8 new_file_type, old_de_file_type;
 	int retval;
+	struct ext4_lufid_snap old_snap = {}, new_snap = {};
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
@@ -4252,12 +4397,33 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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
 
@@ -4290,6 +4456,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
+	ext4_lufid_snap_release(&new_snap);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
-- 
2.43.7

