Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C39514747
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472974; cv=none; b=B4llOQxXgGiQBdMYguEQWjlWZO/YuQSxZaBzNe12gZnFEm6Edc/WHjPtGITOVdQv7w+sJ89O1t0vuVIr4uon+thIfZUfdojueZmX0rIa415TF1g+KsCOCoBTQ/rkMDfAB7gDQnZmYTlzs14O63hGznepomFZ4Px0tIH5KNSmsU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472974; c=relaxed/simple;
	bh=BlDpR+7dTONFyPne/Kv9PXLd3c6LkKMMmY/w/eychVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRcrCsuluNr06ZIwyrmrXszb7nx/sUoEgN0DhwvQBvA6BpxMBTwSA8IBwQm116nhSRmUFoYZMHIDrNA89Me5L45ojSfTNO94zGFCAWTutuontCQK9YWZ0EL568bhleWsz2msXgHhQf2/LoLyY0x80D43WiMadh9EYhNq9yx67pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbQhEzH+; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbQhEzH+"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49b8eeb3ff2so3520295e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472971; x=1789077771; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NSZgyyRtttXhGcERUgoNNq/R4OP09IkUQ+iQ0pINNg0=;
        b=hbQhEzH+XYOJLp8ivMHDRNzuUu0hA8m6sIxzd6yZ0KrJLsnnF496nrZ9vnryCza87t
         zijA9fZWijkJJQR37SHUPmGo2P2fHCLHLId1uy4QtQxrWzJ2T7+LvML/57kQCjoYpl9M
         JrEBeK2lGVmv/F0aUZs3HaRLyNMX/etukKBRhZFtmCFnw0L+Obl5MTtez1sTmJFDj15M
         r99Kv4jZ4ZmXC02kzpRQLMzuwQQYRTHc3UcAzNg+GeJGf08b6L7aSEL1uRv4sjKBSGzX
         YLaoPgNHPTiymLVRgg1eocOUsIDdbZ9qMSByyXtNe2xknx+8hea57VrSHKK4Nov4+FFW
         W4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472971; x=1789077771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSZgyyRtttXhGcERUgoNNq/R4OP09IkUQ+iQ0pINNg0=;
        b=Us/7rih6R6IEGhfzgro6LzEbE7aynWB9NUgHz+TKedw2F/S9iXxoeUclyb8HjPJgSU
         O2KXPHOLLp/jQoDGGUTUOoV3YvtKs6+fA5Ajv9EcPgsMPTrcoyDlWUZbEx6obqpj1dVw
         bbeGviIy7lwKjRMwdNFFnNvexAvYfWUs9tbk9U5xmU2JGeBqit5tAhhhcQK2t32TIffc
         /nPWzKIG3APVoVRFlUMzlgFNRv8fF92wyhDtqMt1B2N7sIXH31Qk3uJmbqcv8JaHeLA1
         fa9A9p1W0YGyJNN3V/aRc24HVlq4f4EgQouh5MaqZt65wGeTVKkOzvfUsXzr1+6Ht0yO
         waEQ==
X-Gm-Message-State: AFuF++l4oecOB8p+4st8Pf6PUic3ruQSnXpkUIJFmDw/iQjnwrPMYAxJ
	OR8ya9NWnCP8Jxd9yqXuaW+HxNk0JJLhBqj1OQJXl1D3N0BnXSro6QG8rVNybNU4
X-Gm-Gg: AYBFou2Di4myXAqE2AKQfeQmrhh6/7islaWf9hj7zrjw25rWqbMzfxkDphCkPVqrbP8
	5bNLfo0NXGCcIs3/xsNF7ZyNdijLovA1H9YteFyBF6hmGy2+LxRCND14zf3ovNkFXQkvsvcPFVH
	AD3kywhSTAqnJJNPM1Iryp3vJTkIw4OWSC75HcAIqNvibA9sTtfxhu41B3Rhzt6WUBx2uws8sFx
	bhA9JaWTAxCFbEu59S4r15ipSF/vehc7pdondlOLt4XOOnoS2mJ8nBZe1VlnljSDTRaxa/mwH6K
	pdpGd0CvkBPgjSLFvMtMh/obygArd0123YJNVDE7PkwVLtLnIVCHWqEfzNClmv+MaQDhmZZoKgO
	NtcF6lBptnBz5CdV2ZLcxP45n2XCh/3n05i9ZOwiX8fev4jAo0D8BEFXcJI8Ca7GYaWW+GXXIX4
	s5mkK/hFjwgnhWAhfrWWQ9dQWVNdUJ+mTtvu/WcOAfg8L7TbWZIgtHJ+nwoLuOWO90XBLSopXVs
	N3wrCcVw8ku6IWFmFmq
X-Received: by 2002:a05:600c:6819:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49cf81fb1acmr18214365e9.2.1788472970843;
        Thu, 03 Sep 2026 15:02:50 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:50 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Etienne AUJAMES <eaujames@ddn.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 07/13] e2fsck: directory rehashing with dirdata support
Date: Thu,  3 Sep 2026 18:01:40 -0400
Message-ID: <20260903220146.19752-8-ablagodarenko@thelustrecollective.com>
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

Implement complex directory optimization and rehashing with proper dirdata
handling. This prevents corruption when renaming duplicate entries with name
expansion.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/rehash.c | 235 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 156 insertions(+), 79 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 4847d172e..75339a67e 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -53,6 +53,9 @@
 #include "problem.h"
 #include "support/sort_r.h"
 
+#define min(a, b) ((a) < (b) ? (a) : (b))
+#define max(a, b) ((a) > (b) ? (a) : (b))
+
 /* Schedule a dir to be rebuilt during pass 3A. */
 void e2fsck_rehash_dir_later(e2fsck_t ctx, ext2_ino_t ino)
 {
@@ -86,6 +89,8 @@ struct fill_dir_struct {
 	int compress;
 	ext2_ino_t parent;
 	ext2_ino_t dir;
+	struct ext2_dir_entry *dot_de;
+	struct ext2_dir_entry *dotdot_de;
 };
 
 struct hash_entry {
@@ -187,11 +192,14 @@ static int fill_dir_block(ext2_filsys fs,
 			return BLOCK_ABORT;
 		}
 		if (!fd->compress && (name_len == 1) &&
-		    (dirent->name[0] == '.'))
+		    (dirent->name[0] == '.')) {
+			fd->dot_de = dirent;
 			continue;
+		}
 		if (!fd->compress && (name_len == 2) &&
 		    (dirent->name[0] == '.') && (dirent->name[1] == '.')) {
 			fd->parent = dirent->inode;
+			fd->dotdot_de = dirent;
 			continue;
 		}
 		if (fd->num_array >= fd->max_array) {
@@ -209,7 +217,7 @@ static int fill_dir_block(ext2_filsys fs,
 		}
 		ent = fd->harray + fd->num_array++;
 		ent->dir = dirent;
-		fd->dir_size += ext2fs_dir_rec_len(name_len, extended);
+		fd->dir_size += ext2fs_dirdata_rec_len(dirent, extended);
 		ent->ino = dirent->inode;
 		if (extended) {
 			ent->hash = EXT2_DIRENT_HASH(dirent);
@@ -390,66 +398,128 @@ static errcode_t get_next_block(ext2_filsys fs, struct out_dir *outdir,
 	return 0;
 }
 
+static void increment_name(char *str, int len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		switch(str[i]) {
+		case '~':
+			str[i] = '1';
+			if (i > 0 && len > 2)
+				str[i-1] = '~';
+			break;
+		case '9':
+			if (i > 1) {
+				str[i] = '0';
+				continue;
+			}
+			str[i] = 'a';
+			break;
+		case 'z':
+			str[i] = 'A';
+			break;
+		case 'Z':
+			str[i] = '0';
+			continue;
+		default:
+			if (!isalnum(str[i]))
+				str[i] = '~';
+			else
+				str[i]++;
+		}
+		break;
+	}
+}
+
 /*
  * This function is used to make a unique filename.  We do this by
  * appending ~0, and then incrementing the number.  However, we cannot
  * expand the length of the filename beyond the padding available in
  * the directory entry.
+ * e.g:
+ * - test (max: 6)	-> test~0
+ * - test~9 (max: 6)	-> tes~10
+ * - test (max: 4)	-> te~0
+ * - te (max: 3)	-> t~0
+ * - t (max: 2)		-> t~
+ * - t~ (max: 2)	-> t1
+ * - t9 (max: 2)	-> ta
+ * - tZ (max: 2)	-> u0
+ * - t (max: 1)		-> u
  */
-static void mutate_name(char *str, unsigned int *len)
+static void mutate_name(char *str, int *len, int max_len)
 {
 	int i;
-	unsigned int l = *len;
+	int l = *len;
 
 	/*
 	 * First check to see if it looks the name has been mutated
 	 * already
 	 */
+	max_len = max(max_len, l);
 	for (i = l-1; i > 0; i--) {
-		if (!isdigit(str[i]))
+		if (!isalnum(str[i]))
 			break;
 	}
-	if ((i == (int)l - 1) || (str[i] != '~')) {
-		if (((l-1) & 3) < 2)
-			l += 2;
-		else
-			l = (l+3) & ~3;
-		if (l > 255)
-			l = 255;
+
+	if ((i != l-1 && str[i] == '~') ||
+	    (max_len <= 2 && max_len == l)) {
+		increment_name(str, l);
+		return;
+	}
+
+	/* Add the first suffix: "~0" */
+	l += min(2, max_len - l);
+	if (l > 2) {
 		str[l-2] = '~';
 		str[l-1] = '0';
-		*len = l;
-		return;
+	} else {
+		str[l-1] = '~';
 	}
-	for (i = l-1; i >= 0; i--) {
-		if (isdigit(str[i])) {
-			if (str[i] == '9')
-				str[i] = '0';
-			else {
-				str[i]++;
-				return;
-			}
-			continue;
-		}
-		if (i == 1) {
-			if (str[0] == 'z')
-				str[0] = 'A';
-			else if (str[0] == 'Z') {
-				str[0] = '~';
-				str[1] = '0';
-			} else
-				str[0]++;
-		} else if (i > 0) {
-			str[i] = '1';
-			str[i-1] = '~';
-		} else {
-			if (str[0] == '~')
-				str[0] = 'a';
-			else
-				str[0]++;
+
+	*len = l;
+}
+
+
+static errcode_t rename_dentry(struct ext2_dir_entry *de, char *new_name,
+			       unsigned int new_len)
+{
+	int dirdata_size = ext2_get_dirdata_size(de);
+	int diff = new_len - ext2fs_dirent_name_len(de);
+	int new_dirdata_off = offsetof(typeof(*de), name) + new_len;
+	void *mv_src, *mv_dst;
+
+	if (diff <= 0 || !dirdata_size) {
+		memcpy(de->name, new_name, new_len);
+		ext2fs_dirent_set_name_len(de, new_len);
+	}
+
+	if (!dirdata_size || !diff)
+		return 0;
+
+	/* move dirdata if needed */
+	if (diff > 0 ) {
+		int rec_len = EXT2_DIRENT_REC_LEN(de);
+
+		/* this should nerver happen (see mutate_name()) */
+		if (new_dirdata_off + dirdata_size > rec_len) {
+			com_err("rename_dentry", ERANGE,
+				_("failed to rename %u"), de->inode);
+			return ERANGE;
 		}
-		break;
 	}
+
+	mv_dst = (void *)de + new_dirdata_off;
+	mv_src = mv_dst - diff;
+	memmove(mv_dst, mv_src, dirdata_size);
+
+	if (diff > 0) {
+		memcpy(de->name, new_name, new_len);
+		ext2fs_dirent_set_name_len(de, new_len);
+	}
+
+	return 0;
 }
 
 static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
@@ -462,7 +532,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	blk_t			i, j;
 	int			fixed = 0;
 	char			new_name[256];
-	unsigned int		new_len;
+	int			new_len, max_len;
 	int			hash_alg;
 	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
@@ -507,7 +577,9 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 			continue;
 		}
 		memcpy(new_name, ent->dir->name, new_len);
-		mutate_name(new_name, &new_len);
+		max_len = min(EXT2_NAME_LEN,
+			      new_len + ext2fs_dir_rec_padding(ent->dir));
+		mutate_name(new_name, &new_len, max_len);
 		for (j=0; j < fd->num_array; j++) {
 			if ((i==j) ||
 			    !same_name(cmp_ctx, new_name, new_len,
@@ -515,15 +587,14 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 				       ext2fs_dirent_name_len(fd->harray[j].dir))) {
 				continue;
 			}
-			mutate_name(new_name, &new_len);
+			mutate_name(new_name, &new_len, max_len);
 
 			j = -1;
 		}
 		new_name[new_len] = 0;
 		pctx.str = new_name;
-		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx)) {
-			memcpy(ent->dir->name, new_name, new_len);
-			ext2fs_dirent_set_name_len(ent->dir, new_len);
+		if (fix_problem(ctx, PR_2_NON_UNIQUE_FILE, &pctx) &&
+		    !rename_dentry(ent->dir, new_name, new_len)) {
 			ext2fs_dirhash2(hash_alg, new_name, new_len,
 					fs->encoding, hash_flags,
 					fs->super->s_hash_seed,
@@ -587,8 +658,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
-		rec_len = ext2fs_dir_rec_len(ext2fs_dirent_name_len(ent->dir),
-					     hash_in_entry);
+		rec_len = ext2fs_dirdata_rec_len(ent->dir, hash_in_entry);
 		if (rec_len > left) {
 			if (left) {
 				left += prev_rec_len;
@@ -623,8 +693,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		if (retval)
 			return retval;
 		prev_rec_len = rec_len;
-		memcpy(dirent->name, ent->dir->name,
-		       ext2fs_dirent_name_len(dirent));
+		memcpy(dirent->name, ent->dir->name, rec_len);
 		if (hash_in_entry) {
 			EXT2_DIRENT_HASHES(dirent)->hash = ext2fs_cpu_to_le32(ent->hash);
 			EXT2_DIRENT_HASHES(dirent)->minor_hash =
@@ -655,47 +724,52 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 
 static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 				    ext2_ino_t ino, ext2_ino_t parent,
+				    struct ext2_dir_entry *dot_de,
+				    struct ext2_dir_entry *dotdot_de,
 				    struct ext2_inode *inode)
 {
-	struct ext2_dir_entry 		*dir;
-	struct ext2_dx_root_info  	*root;
+	struct ext2_dir_entry		*dirent;
+	struct ext2_dx_root_info	*root;
 	struct ext2_dx_countlimit	*limits;
-	int				filetype = 0;
 	int				csum_size = 0;
-
-	if (ext2fs_has_feature_filetype(fs->super))
-		filetype = EXT2_FT_DIR;
+	int				offset;
+	int				rec_len;
 
 	memset(buf, 0, fs->blocksize);
-	dir = (struct ext2_dir_entry *) buf;
-	dir->inode = ino;
-	dir->name[0] = '.';
-	ext2fs_dirent_set_name_len(dir, 1);
-	ext2fs_dirent_set_file_type(dir, filetype);
-	dir->rec_len = 12;
-	dir = (struct ext2_dir_entry *) (buf + 12);
-	dir->inode = parent;
-	dir->name[0] = '.';
-	dir->name[1] = '.';
-	ext2fs_dirent_set_name_len(dir, 2);
-	ext2fs_dirent_set_file_type(dir, filetype);
-	dir->rec_len = fs->blocksize - 12;
-
-	root = (struct ext2_dx_root_info *) (buf+24);
+	dirent = (struct ext2_dir_entry *) buf;
+	dirent->inode = ino;
+
+	dirent->name_len = dot_de->name_len;
+	offset = rec_len = dirent->rec_len = dot_de->rec_len;
+	memcpy(dirent->name, dot_de->name, rec_len);
+
+	dirent = EXT2_NEXT_DIRENT(dirent);
+	/* set to jump over the index block */
+
+	dirent->inode = parent;
+
+	dirent->name_len = dotdot_de->name_len;
+	dirent->rec_len = fs->blocksize - rec_len;
+	rec_len = EXT2_DIRENT_REC_LEN(dotdot_de);
+	memcpy(dirent->name, dotdot_de->name, rec_len);
+	offset += rec_len;
+
+	root = (struct ext2_dx_root_info *)(buf + offset);
 	root->reserved_zero = 0;
 	if (ext4_hash_in_dirent(inode))
 		root->hash_version = EXT2_HASH_SIPHASH;
 	else
 		root->hash_version = fs->super->s_def_hash_version;
-	root->info_length = 8;
+	root->info_length = sizeof(*root);
 	root->indirect_levels = 0;
 	root->unused_flags = 0;
+	offset += root->info_length;
 
 	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dx_tail);
 
-	limits = (struct ext2_dx_countlimit *) (buf+32);
-	limits->limit = (fs->blocksize - (32 + csum_size)) /
+	limits = (struct ext2_dx_countlimit *) (buf + offset);
+	limits->limit = (fs->blocksize - (offset + csum_size)) /
 			sizeof(struct ext2_dx_entry);
 	limits->count = 0;
 
@@ -773,6 +847,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				struct out_dir *outdir,
 				ext2_ino_t ino,
 				ext2_ino_t parent,
+				struct ext2_dir_entry *dot_de,
+				struct ext2_dir_entry *dotdot_de,
 				struct ext2_inode *inode)
 {
 	struct ext2_dx_root_info	*root_info;
@@ -782,7 +858,9 @@ static errcode_t calculate_tree(ext2_filsys fs,
 	int				i, c1, c2, c3, nblks;
 	int				limit_offset, int_offset, root_offset;
 
-	root_info = set_root_node(fs, outdir->buf, ino, parent, inode);
+	root_info = set_root_node(fs, outdir->buf, ino, parent, dot_de,
+				  dotdot_de, inode);
+
 	root_offset = limit_offset = ((char *) root_info - outdir->buf) +
 		root_info->info_length;
 	root_limit = (struct ext2_dx_countlimit *) (outdir->buf + limit_offset);
@@ -1087,11 +1165,10 @@ resort:
 	if (retval)
 		goto errout;
 
-	free(dir_buf); dir_buf = 0;
-
 	if (!fd.compress) {
 		/* Calculate the interior nodes */
-		retval = calculate_tree(fs, &outdir, ino, fd.parent, fd.inode);
+		retval = calculate_tree(fs, &outdir, ino, fd.parent,
+					fd.dot_de, fd.dotdot_de, fd.inode);
 		if (retval)
 			goto errout;
 	}
-- 
2.43.7

