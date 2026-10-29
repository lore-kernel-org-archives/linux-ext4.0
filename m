Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276837;
	b=3/cR/ujIs37LtPn+RJIwRVy/UYJzw1gihXXZPqQ+dKYuW9Oqu941nhqVisvuL+9sRb78
	 iTIhWBXd1DdncOsQeDoYs1rIbvuJ1T69FsGcfoAxE0uxRWvs7+H8r8y5o027RaV4Og3Vh
	 YMC7J0h9zYWeATfrBpJ7CKKd3ozVA+g/RnudVIDr0IdQcgg+iCAOTjRc5QissQsL0buhW
	 FVxcJSuU2F2vvQwJ29YU1445KH/CSo71gyaKNHgsYRnrzZNfsfySTqdw+I8eq0MR2igfp
	 vqaqkLjH0DIO4jxslXR9QzY1M9LesruIRguO7m0sgNDY354bazx8Xmpdg/kxYxZfwGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276837;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=fjM8LhBCXsl33h+DxRYnnwJnW2mT/oPo2BN/DLKmoaI=;
	b=eseXYYOalgc3MGxAE9wDLpD68X7WdyocmR1u35phklCqQYmdzZPu11umNbHTBz4j5xn5
	 ayVup+xul9nEssXKEZE5hcEwj5nwkVCvkF3OOvQjhDsYEO6d0EDK38IAQUWQSAwMJvWU2
	 myNpbzhFKseAd9lDUMS0VWzIOmQUdQ+KUI2vwvWQLJkw4LYybDNvpcxpvhD8BSKf0kJ1K
	 4IGlQKrKQydEKd3l2UHNC4vmhyKiMvMGAKI0vkqsGWVKA6ERFDuXCkmdv0srdZQ2wNOYD
	 u6dI8jZeoFaKOnJGApvQWtDWvCLklJWtBJsDsQBnmGS8gE9/RXV2C3YLSrE8VVBfUrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j+HBRERm;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95CD606A31E
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B95CD606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j+HBRERm
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b042c0759so1067179f8f.2
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276835; x=1793881635; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fjM8LhBCXsl33h+DxRYnnwJnW2mT/oPo2BN/DLKmoaI=;
        b=j+HBRERmci6UE7nyggMEtP2S79GYrb5aOQqgHSK6b9R4zrJrQwDjN8mXsz4/AWfj73
         2hIjaSvpHge0Q9BcHbyOUiWGsUXqv75lAE+5ZAz60sVzB+ZJUXNa2H0YtUcwYzJMyiJ2
         znR69fz04W5j9Nu8fmph1ali7M0XBEot6lekRaqwYc2IXjHRgqpk6cdTiecYcPSY3kzt
         B/d6aYvuHaDS8ADkE1d7pM0Fk8rGKXz47fDkJHQS3TJii3EPhWbGnoMGvPgQapsv/SAe
         wkwu5cSOpq4JdEu2/npGqabOw7oJNcr/tHlKuv3UENlXsJmfxrsR6DiwTpX0Y/9xdsCM
         fTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276835; x=1793881635;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjM8LhBCXsl33h+DxRYnnwJnW2mT/oPo2BN/DLKmoaI=;
        b=0LDQkuntrXXpnoiXV+bjPk23cOf4riuuuSBsWq8uYNzTG/TYxhPnga/jmmTHUy7uQq
         VpY90RkUWjMksOWNkrfFT+sI8qT4U8tSgo6XY/jZMzQPFG8RWlqnlmjYZ62ztHtfldv2
         NfLEaMExuEnaB6hKhYWGEzabDhp7NrmPQe3jLlRKvoKGz3mSQASIpTLs5RgKSoK8A/yx
         XAJh4pl0ptekewJw96VYDcnCKQuSJL9381oO023TRX2V9adrp303Hpl+J0/G2pU5dJpV
         P0qVwqMmeyFg5EqnJWr0Cs7rU/OePCq3s20fX3W8eOhUyIebKotNqcq0UJwSRcOKmwVa
         TCvg==
X-Gm-Message-State: AFq9FYKrVvHN2W2wC88XdiOW48S+lOuySwdhxXCezl0CUX01t+UuPU0U
	HSFZDxh5Ii93ZYJRCx86uliX/pR9pqZ1AWJCBqP6CTlyRPyusO4CvEfwoKqftA3Y
X-Gm-Gg: AYBFou1o1wdRF2wr8agbbC0so16Xd8KZnKiwW5e06nS7y+yrzUDfO91jJ/J0JcD2Lw+
	WGPOQJ3V8GAWT6unn694Gbv4MWgwi9/mc80kcoebAbDDtZPEpABUwR7s57/OcMeLB+fTM/Wxy5F
	qA+MGxJMzLrhS40dV3ITSV2Pn+uOENEQoJG71XRIhw91VzTvRLB4o4BvW97LO8AEdWWC5roaK8W
	xMZYwcBVWHcY9HkRqhtUHpsOpbdn4PHRFCWcnTwT3GxmWYfYwyQP8JTvYHCVDa/NTAsZft8BV+x
	7qY/UMQ+zoWUQI+cFfE3cdxYx7j9yFXmN69rB1a0BCl4fW3t9RRtGA1STDCYEwoVrUVh37doLSg
	53qro5w+RWJqrwUBkl6xFT/KPDImThWq9+cJlQ6uEyBx0oOU5Zc2I/Fr1OZLlRBQz8xGrg3YyLC
	4s2wmhP7O4ElEMFTVizrWIj1gXub6bvl7L51w1EKBpNXfkDD0mRAQ6b01TXuKY7XMVAPMHXGWC6
	uiNF8IduUAc2+FET8vyiq5+hxzPY9c0kUgbk0N1eezEFZxgLgKbx52uqbPPPrlEhoiSIgSkcp1Q
	c/yxA/NSFwPvX6VULqRK2Me/KeaCRry9YRPuo7bjs6UWS4ylxkIHA7JqTk00
X-Received: by 2002:a05:6000:29cf:b0:487:1575:ebef with SMTP id ffacd0b85a97d-48e5d311eb9mr8556633f8f.47.1793276834902;
        Thu, 29 Oct 2026 05:27:14 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e412cc164sm32305679f8f.7.2026.10.29.05.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:27:14 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	jack@suse.cz,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v13 09/11] ext4: add dirdata LUFID support for directory entry rename
Date: Thu, 29 Oct 2026 12:24:08 +0000
Message-ID: <20261029122413.230409-10-ablagodarenko@thelustrecollective.com>
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
 fs/ext4/namei.c | 200 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 185 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 30bbf6a56bf6..433bee757ea4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3574,11 +3574,6 @@ int __ext4_link(struct inode *dir, struct inode *inode,
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	/* Fast-commit does not record dirdata in its journal format; force a
-	 * full journal commit so the LUFID survives crash+replay. */
-	if (ext4_dentry_get_fid(dir->i_sb, dentry ? dentry->d_fsdata : NULL))
-		ext4_fc_mark_ineligible(dir->i_sb, EXT4_FC_REASON_DIRDATA, handle);
-
 	inode_set_ctime_current(inode);
 	ext4_inc_count(inode);
 
@@ -3752,7 +3747,8 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 }
 
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
-		       unsigned ino, unsigned file_type)
+		       unsigned ino, unsigned file_type,
+		       const struct ext4_dirent_fid *src_fid)
 {
 	int retval, retval2;
 
@@ -3762,8 +3758,57 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
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
@@ -3800,7 +3845,7 @@ static void ext4_resetent(handle_t *handle, struct ext4_renament *ent,
 		return;
 	}
 
-	ext4_setent(handle, &old, ino, file_type);
+	ext4_setent(handle, &old, ino, file_type, NULL);
 	brelse(old.bh);
 }
 
@@ -3899,6 +3944,67 @@ static struct inode *ext4_whiteout_for_rename(struct mnt_idmap *idmap,
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
@@ -3925,8 +4031,10 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	int force_reread;
 	int retval;
 	struct inode *whiteout = NULL;
+	struct ext4_dentry_param *edp = NULL;
 	int credits;
 	u8 old_file_type;
+	struct ext4_lufid_snap old_snap = {};
 
 	if (new.inode && new.inode->i_nlink == 0) {
 		EXT4_ERROR_INODE(new.inode,
@@ -4032,29 +4140,65 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
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
@@ -4139,6 +4283,8 @@ static int ext4_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 	retval = 0;
 
 end_rename:
+	kfree(edp);
+	ext4_lufid_snap_release(&old_snap);
 	if (whiteout) {
 		if (retval) {
 			ext4_resetent(handle, &old,
@@ -4175,8 +4321,9 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 		.dentry = new_dentry,
 		.inode = d_inode(new_dentry),
 	};
-	u8 new_file_type;
+	u8 new_file_type, old_de_file_type;
 	int retval;
+	struct ext4_lufid_snap old_snap = {}, new_snap = {};
 
 	if ((ext4_test_inode_flag(new_dir, EXT4_INODE_PROJINHERIT) &&
 	     !projid_eq(EXT4_I(new_dir)->i_projid,
@@ -4255,12 +4402,33 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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
 
@@ -4293,6 +4461,8 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	retval = 0;
 
 end_rename:
+	ext4_lufid_snap_release(&old_snap);
+	ext4_lufid_snap_release(&new_snap);
 	brelse(old.dir_bh);
 	brelse(new.dir_bh);
 	brelse(old.bh);
-- 
2.52.0

