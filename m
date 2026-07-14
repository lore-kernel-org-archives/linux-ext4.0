Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B373BBFAE
	for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784033630; cv=none; b=ja+cRZuA+NtdLYb+z2rS8PVBNMq9db9jo6x2vQp4eFbjV+sRB7l/KsGzdgRxmKsu6196vRv7yBTPxfry8e+VcLEjmuY52Ur2MoEAE+/BuNazBxX3Xnhn4pVAmL3OBSEvD3PNMyGAJGuxixHYsyiBy8Caijb31c+Oq1Faed4Chzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784033630; c=relaxed/simple;
	bh=a6gHXyjJbiAzBmiaHWAExZJQLnpt+HLCrUJVTUwSDvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SIyKUvLjwVu5U3LsvlG+osERu3ZaNpnqXRLBh0+1pd5mBM1WcyxKKX7IO6pI3ZvMTbeywZKbW+pMQPfJFJ1TknXxK7yb2Sbz3gkzT9h8Q5XOJaPRNgysyMaXaoOqIcbSGmnmW7FxMoiSjxqlo6N2vpPzTKIykXr7MWBtCz48Tas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C+UQSuse; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+UQSuse"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493bf73ec2aso29341375e9.2
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jul 2026 05:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784033626; x=1784638426; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dnIEGCw+DLwlyCfYDFZmlpmlslvmNNRLVJ5moOkWAaM=;
        b=C+UQSuse33abqFZ8Y/6wAi9RoXDQix/KzbhrNKnfcU7fBdq/HF425fK7nDcXbUaKP+
         IMbbsPmID1JxyxAQOyGkRxNZPUIpuAcm7mcrjmtu993cgS8xqpZahd4VeGWUiQ64Qr1Q
         8M+FS8pFgLOBFOwE/fr8Appt4I0/eF1YNBG9w3UCgmm+5oaXVW6vS+wZ+vnapWX8Nkpo
         oGAG7PLTHSipUFVOuAo3U6S+SmLSBGYey1HMxoZE+TwC/dTavtr1HSBNcYW51iC6o+ny
         H7EhFEMkRWh1agbeAIjIcF1UI06e5DZmdk9I1gXX32ZQCOq0LoSNA2IfG3HfqM75hLO7
         Z0iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784033626; x=1784638426;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dnIEGCw+DLwlyCfYDFZmlpmlslvmNNRLVJ5moOkWAaM=;
        b=BflYg68MXi3ir1N+W30JuAL6IiHOQ5zVgxZ37zRSoTO6BRkpBPkNUZhiwDRSFb+pku
         DSIJ1cbsTkyOhz/95LddVpexJfoAjBLh/G7EnGwLVAhUwfV4gGuhLSXed0CfI+ZC42m4
         9jd7T55twV1pAkw+NrBrx2uXb4s1V7XpXL7XLM8ACrQcczryZhqA26V0f06FsO/ayz1N
         zceUv0BWzHus68XVqIJDrvw9/I48CuKbfYXtRX/PZad8KFFyOUTfr1j+7r9HEb4KpZ2S
         Y7JISOzmCwNCy84WNBYJjt3OXCk3OdWbtC9zOS9qve2EhIO1BbeHODNcS2cQ4w2gRyue
         gwgQ==
X-Gm-Message-State: AOJu0YwW+CDsotz9eu0HC5Gp3X17I+EKhUzGhzpLk9xi6vjeaypKMe32
	CYdK4Q/Jej3ivs7/nUGa++BSLrHwubyyRa8VOaH1Kz1FV5I9BU3c+pnQYbgA/Uo8+A4=
X-Gm-Gg: AfdE7cmNe50uG39+T4TInptWF9bEk0XkKUy3AYi0Vl9HoGYZ9LUm8QVIvPkxHvRqLVC
	oHq9DOekK4ELUHPfhZWcptE/PnJR0cmzZEXffY+M7eCP7hppd6uC4/blzfJXNx1iIzrCLLfwlYD
	jO0532pL0EisKLlJCd7jqziJ3VpdUH8SFNSTOJmVb13GVk25mRuw5tyyZhtmSr2lREdt4Lm2J5i
	+va2OpHMHvt1wp9Aai6WfxDcJNkcYeUY1yq6oGKpvM4I6HGZjlLwQ/X7Pn0SymZCMUGF3ePsVwa
	F6dLaV3NAsUaTWha8s0ZfHEsKks9OXROmnptM1YnCSTC3yVcJe5E0jwN982OMD8JzwOWjNjjnlp
	IPncvWfKyQjX2ShyhnMAe1QmRBCGuKG5jp5+7uWBaMSCYDNNZ/yRtrRqDDhQn2/i0wxcINuN7sA
	mri5hERd4DqQmal8WE1QVTIzp8WvCVECNR1/IVdGM6sslGzw==
X-Received: by 2002:a05:600c:5307:b0:493:f278:ba2f with SMTP id 5b1f17b1804b1-494033f4fd2mr69413465e9.9.1784033626187;
        Tue, 14 Jul 2026 05:53:46 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:1827:2101:7130:c718:1edf:8590])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a2ed840sm70052405e9.10.2026.07.14.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 05:53:45 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v5 09/11] ext4: add dirdata LUFID support for directory entry rename
Date: Tue, 14 Jul 2026 08:51:07 -0400
Message-ID: <20260714125111.14699-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
References: <20260714125111.14699-1-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 124 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 115 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a6f7ffa656f..168ffd3751cb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3731,7 +3731,8 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 }
 
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
-		       unsigned ino, unsigned file_type)
+		       unsigned ino, unsigned file_type,
+		       const struct ext4_dirent_fid *src_fid)
 {
 	int retval, retval2;
 
@@ -3741,8 +3742,57 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
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
@@ -3779,7 +3829,7 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 		return;
 	}
 
-	ext4_setent(handle, &old, ino, file_type);
+	ext4_setent(handle, &old, ino, file_type, NULL);
 	brelse(old.bh);
 }
 
@@ -3878,6 +3928,32 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
 	return wh;
 }
 
+/*
+ * ext4_lufid_snapshot - copy the LUFID record from a directory entry
+ *
+ * Allocates and returns a kmemdup'd copy of the full on-disk LUFID record
+ * (header + FID payload of arbitrary length).  Returns NULL if no LUFID is
+ * present, the record is malformed, or allocation fails.  Caller must kfree().
+ */
+static struct ext4_dirent_fid *
+ext4_lufid_snapshot(struct ext4_dir_entry_2 *de, unsigned int blocksize)
+{
+	unsigned int ddh_off = EXT4_BASE_DIR_LEN + de->name_len + 1;
+	unsigned int rec_len = ext4_rec_len_from_disk(de->rec_len, blocksize);
+	struct ext4_dirent_fid *disk_fid;
+	unsigned int dlen;
+
+	if (!(de->file_type & EXT4_DIRENT_LUFID))
+		return NULL;
+	if (ddh_off + sizeof(disk_fid->df_header) > rec_len)
+		return NULL;
+	disk_fid = (struct ext4_dirent_fid *)((char *)de + ddh_off);
+	dlen = disk_fid->df_header.ddh_length;
+	if (dlen < sizeof(disk_fid->df_header) || ddh_off + dlen > rec_len)
+		return NULL;
+	return kmemdup(disk_fid, dlen, GFP_NOFS);
+}
+
 /*
  * Anybody can rename anything with this: the permission checks are left to the
  * higher-level routines.
@@ -3906,6 +3982,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	struct inode *whiteout = NULL;
 	int credits;
 	u8 old_file_type;
+	struct ext4_dirent_fid *old_fid = NULL;
 
 	if (new.inode && new.inode->i_nlink == 0) {
 		EXT4_ERROR_INODE(new.inode,
@@ -4017,7 +4094,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		 * to be still pointing to the valid old entry.
 		 */
 		retval = ext4_setent(handle, &old, whiteout->i_ino,
-				     EXT4_FT_CHRDEV);
+				     EXT4_FT_CHRDEV, NULL);
 		if (retval)
 			goto end_rename;
 		retval = ext4_mark_inode_dirty(handle, whiteout);
@@ -4030,8 +4107,18 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		if (retval)
 			goto end_rename;
 	} else {
+		if (ext4_has_feature_dirdata(old.dir->i_sb)) {
+			old_fid = ext4_lufid_snapshot(old.de,
+						      old.dir->i_sb->s_blocksize);
+			if (old_fid)
+				ext4_fc_mark_ineligible(old.dir->i_sb,
+							EXT4_FC_REASON_DIRDATA,
+							handle);
+			else
+				old_file_type &= ~EXT4_DIRENT_LUFID;
+		}
 		retval = ext4_setent(handle, &new,
-				     old.inode->i_ino, old_file_type);
+				     old.inode->i_ino, old_file_type, old_fid);
 		if (retval)
 			goto end_rename;
 	}
@@ -4118,6 +4205,7 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = 0;
 
 end_rename:
+	kfree(old_fid);
 	if (whiteout) {
 		if (retval) {
 			ext4_resetent(handle, &old,
@@ -4154,8 +4242,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 		.inode = d_inode(new_dentry),
 	};
-	u8 new_file_type;
+	u8 new_file_type, old_de_file_type;
 	int retval;
+	struct ext4_dirent_fid *old_fid = NULL, *new_fid = NULL;
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
@@ -4234,12 +4323,27 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto end_rename;
 	}
 
+	if (ext4_has_feature_dirdata(old.dir->i_sb)) {
+		old_fid = ext4_lufid_snapshot(old.de, old.dir->i_sb->s_blocksize);
+		new_fid = ext4_lufid_snapshot(new.de, new.dir->i_sb->s_blocksize);
+		if (old_fid || new_fid)
+			ext4_fc_mark_ineligible(old.dir->i_sb,
+						EXT4_FC_REASON_DIRDATA, handle);
+	}
+
+	old_de_file_type = old.de->file_type;
+	if (!old_fid)
+		old_de_file_type &= ~EXT4_DIRENT_LUFID;
 	new_file_type = new.de->file_type;
-	retval = ext4_setent(handle, &new, old.inode->i_ino, old.de->file_type);
+	if (!new_fid)
+		new_file_type &= ~EXT4_DIRENT_LUFID;
+	retval = ext4_setent(handle, &new, old.inode->i_ino, old_de_file_type,
+			     old_fid);
 	if (retval)
 		goto end_rename;
 
-	retval = ext4_setent(handle, &old, new.inode->i_ino, new_file_type);
+	retval = ext4_setent(handle, &old, new.inode->i_ino, new_file_type,
+			     new_fid);
 	if (retval)
 		goto end_rename;
 
@@ -4272,6 +4376,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	kfree(old_fid);
+	kfree(new_fid);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
-- 
2.43.7

