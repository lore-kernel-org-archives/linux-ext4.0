Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3180548989D
	for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 23:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785541872; cv=none; b=Hb6+LO5pyCQpnYPYtHmua/WON/2Gp7DGX6zI61Qw4LcIOGbnMJH5rAKJtC3CGj+boDatiu84h0LSsgNex5rmqk/2+1/jSEb6wMuhUQi7AXlMp+FmnYj77Upp5ia5NfbyDLo1X5rnwEvaqmzKiyuPDvQN5cyYAt5gFDc5qNHtC/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785541872; c=relaxed/simple;
	bh=u6beKG7EtG+5kayDkaO3cB99szTCvY4Sr5JIW9Y2i+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=asc6Z3k30mgXn7ZiEsAPtgs/7u6cweFsrEDu0GPGh7hQjxBGHGc80RENKRCis9w1NtfyEyawJgN1ppFZHub21vfGZLt5PTR1xoapPdoesg0lFFpCIDCNc+8TPKeFUHEScoDZQteAlWqmz4dJCr9mCTgVsRzRmjKBqNl8fqyWotw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YJNdM8bx; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YJNdM8bx"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4798bea72f9so1149138f8f.1
        for <linux-ext4@vger.kernel.org>; Fri, 31 Jul 2026 16:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785541868; x=1786146668; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GmKq4jCxCauX8H3GWsFvvhHp3+g+Jn8SjIowmGjl4BQ=;
        b=YJNdM8bxP6Qvved9tyQ73jpz7V0BeuThn3olNOQwHHtsceFybCVpqiJ5B1vHfMEwD7
         25sodgCJvdDPgx7cJc+Ol74PwCAPQQWm7Iex4whjJT3MbOa1qoyFV/WszkAfFFD6dlkf
         NfP2PEda8722fcs2Kt2UA2RYzZYaYBGoTqU+DxPfmnefTjpuQOvm8herPNluzg4EUJm9
         7AQW49uwtO69Z4Tuk5v963Iw2U0URMnwdLbQWIw5e9uLNtcRCmpZo4QrcFiULHt18Dj/
         WU804kVhjCZJR7zySteVsgtivV5tdb6lxLP9u46/piH9h7Ly1f5XpsCnr+9+JdNyrJ2u
         rSpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785541868; x=1786146668;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GmKq4jCxCauX8H3GWsFvvhHp3+g+Jn8SjIowmGjl4BQ=;
        b=Gr0CHEDNykzHVv1I5RDeG6jN5JK7drUDjVRgRY3wrx9wyMk3MS+3oZIk1g+wzaxgsl
         t7cUIYvv82Z7mDhNSAN7kTjuqbsGhAFKkBWI85FGSshC1x2fN53siBl+pd96UDjxxD8t
         paTT2CqKMP04JuXtpFwvTgdWWpqgZl4Nw6LBrZb/WO+J3LzyzQCmNjDjAQsIesltHJrS
         epRo0ieaQYl4MNj8RGVDWTTXq/zgvMx82gj0EFuj7HRIA0eL0bZGxTNv4w85elTzNUpW
         gLKajjLEVwOChf9vcuqlU3r0ny56NtCFqhPePXzfPeDKvgXVou3SflWqe8VlCns/Ip5y
         n+8Q==
X-Gm-Message-State: AOJu0Yz6J3OwTj5YU9iQ5X7klRo48eXgFyp2kNqSGMoxASUDDX+NF7xi
	gwBJCRuzBxIxZnSlslgH6Rjh409QZ06Ff/SE9GiiD2Oz8ov8KT72G1vncq1MYqN9
X-Gm-Gg: AR+sD13l8r1fhX7ZRFlb4yYKuku3yf0d3qNyPM7u994CMZ3IN7IGzOruN4A1i60n37t
	wABPaVzaXo3r3rqVLll7VG0NgQ1fQI9JDMf/lEnHwYx8BkO5pu3hG2I319F85Q+VoVlOeDC80q5
	1ipjFYMan40/kcj/0A4FsJQ5Kdcf9O9Sm3+01HC46ZlJZ1yLQQUJdbUnIvHo15MlTqgcUHfHe/x
	3bp0t+FAWUcVPAiuB9BLEaHnfud6aFEKI7JkujV03uHr5w8F6LqUsIqs2YOD0siDRuNC5uVi3vh
	74QYGsi7moQj+2mA1Y8+x4iiLBbFG9nJX+P/Fqd1zStJE+bw5u+Sgj5093eXEBwmxKE7ZkPuh0k
	mladUHvolSfbipIyG2++mPOkThIJmtGqGe4dUZoggeTCNP6d4IJTC+BvXbQy1730zjDhGy8z3kK
	CrG6i1GdOlBXAt4rVvzL5/kTrPR5y3pnI5LsQXULlgoRrpsHo+2dNxfSIAABrSbARKRwE2mlwDa
	GZAWhZnFnQ7AqLb06MJ
X-Received: by 2002:a05:600c:840f:b0:495:4b24:1b64 with SMTP id 5b1f17b1804b1-4980c601d19mr2636455e9.0.1785541868244;
        Fri, 31 Jul 2026 16:51:08 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49807b85be7sm5338715e9.2.2026.07.31.16.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 16:51:07 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <ablagodarenko@thelustrecollective.com>,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v11 09/11] ext4: add dirdata LUFID support for directory entry rename
Date: Fri, 31 Jul 2026 19:50:39 -0400
Message-ID: <20260731235043.44068-10-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
References: <20260731235043.44068-1-ablagodarenko@thelustrecollective.com>
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

