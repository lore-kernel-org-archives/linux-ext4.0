Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276885;
	b=bKsYYKVFV6lKpLWKKEvFLoQeQ+b2ialwG72u1sIFHcHmj0y+ra1VJjGtRzgU4ay+JrTh
	 oUlwsuRz9htDPdS6SDlsMnw74/SiG1NWqH59K+LOS6wUGBwE58HkTfXUKb4qQ+oZDKuQv
	 /QOMGba+sUh6s43mOrxEsuauFF8IdnyuTqwEdlMQT0CwkqmxzpwlDJdC6yrcqhEZY10BH
	 yXSGqNwIOImyf1u18Z8fGyJMmPdFIKeq1gImHIJMBS2LLM0knApozP15PHb80Umb/63TE
	 C29va6dglCqxObZIfQIXG2fp38yNoD0HvFpYtXrSoN8qEylBSDZUwrhVgor68M9HfIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=PUb2oFEqqzWFysX2bI/yg1sdKDDlRwer8w5K9tqUBEE=;
	b=AR4Oz4WwgyE1PuSEWNAj/lDeV4foVk5Q7vnil54GuLTequMQo5mLPu/AOjoE0aUsbmnM
	 E8HGt7G9HSv6w2EsM3QJE+PIcbIM7ullGLHSjBUctFeKhwNKu/gRJsECG+ZpwCoKROGTK
	 j0Ltr3wYrQSDYEdH+YVZ0jdMPY/84eN3jEjZh6x0oJlg51u3AnaFVc4UOGaKAKO1roqab
	 WkiuYN1PEgmFLGlPUf8Z7iqACWaPTTTl5Nqt+X12bp9eNFt5m3AdrxbM6lI2WcycveGdm
	 kMfU8TtnmETf1Oud+4C/VFLHpr5puoAUOlBCwMzIU7eeZg8vB5wd+J59cTbP+1iGBEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pqCVkbEp;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AABC606A324
	for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 12:28:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1AABC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pqCVkbEp
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a218c463d1so13574635e9.0
        for <linux-ext4@vger.kernel.org>; Thu, 29 Oct 2026 05:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793276883; x=1793881683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PUb2oFEqqzWFysX2bI/yg1sdKDDlRwer8w5K9tqUBEE=;
        b=pqCVkbEpr1ljfdyzCD5AQLEFmO9ve+wE2H0fIDe0R/oG5Vi3RTTb0UEtxvBHxgNWFc
         oSgVbEWW0Q9MCSPLgpXN2pHIKUJmKZTasIUjDJARj2gLsQZZQxxNrpvURCiohW1CvwrP
         IqKlurm+cSXZR7JvkuK/1N4zs3pySKAorLYSaMQoqjNO+c0IG6wuzJhSz0jhmmUQIgz8
         XJ0u8Ms8MRsIZMpxkSxES4c6KSLz2ltXnJ++JvLiUNSXN86aDzVJqspMTRC9kjzMI07U
         Ppbf0aokT4WIo7H+pYhlZwColq58SlEF4mHIMLaizWvQ9i1dVbZQpg/PlsWvPU8xplGB
         Fw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793276883; x=1793881683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PUb2oFEqqzWFysX2bI/yg1sdKDDlRwer8w5K9tqUBEE=;
        b=wQe30US61S1OiSejtg1hBVHMhQGOwS3GJ4Toq/dClDuFotU71BqJHIdHJ4CI1s4V/b
         j4BWpyqzdOVaFdjhg+lUfEM7ZXHNa8LuJp+tHD/d9OEfgWnaspbdNZmE+UuOjxJzjktS
         oXupIAR6Dfdg4jnruGjwPEmEXw/9JwRMP1QphzU/tG8raL36WDSnTAg0OEnXss5Srtvl
         gdRvkwgloNzBPxmd0HUaJaegCq3+ahkee1d5ZUSuH0uRRgSIHI/D2vCodlJ7e2rdGluw
         59b9Nn3x8G+L/KKsr/qouPhH3ygExWdabNhCYDsqNY4bTVJuOKrbKY9FPmK11txO3nxR
         MSNg==
X-Gm-Message-State: AFq9FYKu37hBiyHbEKUu8WaUfNjJ/Dhu8HRUnTvQE8KVUSfMLV879/sK
	R91SHoz79y2yy7incdZ/INQgMsy9q4tkiTzXAsapfYxNCu+wNPHEXiJr9VMifx8V
X-Gm-Gg: AYBFou1ccggbsbeWI+F9MRAor4Qg/OnHQjoNeNhHwXPLt+GMUaOM9wd+lWr9YX0ApTy
	tQb7cf7n75x6esmI5j9+NC918gx3OdsT+tJ7hwV6WSxSWJCjry4C/ai4gvcfzryTLpgyWeFVh+l
	/FhLKIXTDJPqfI5YSSUexQ3MYJObc1a5wTm7KffBK3Cy5wgPjy+bqVsNQZLyO2m1YFyLvKtDXST
	loylrwvKPgiYRrPuoMgaQllHtnXMFoLdYqt1s8FDYzTDaiyGiPiXgleVKHHlCPDpbRCQbSRfiZ8
	+ew45EiN3Tv25ndRDDZuLm+GaKSAGK8ucsn22jat7nkuBqLupXTimKTrS1ucRH8B0QrSVSGmGwR
	whbB7Hd0HCTV6zJ0tOD4Z3PRZIZLfmTPbYwGP+s8pkzdFmWB70nkYcrW8KQ0eSFpU99aSYnJHFG
	0FEY3pqqWeLVk5SaSZhctl1TgyAA4vaMtjbLjLlvxd+AjUoXdC+ifWQyPOFcIexCJhGIk2oMt/0
	Meg1ZJvZsHjVomtW4vp71JLyjoVgY1EreghAimVUVoPbqm9Xo8bAmEKI5OK1rIIADHOseXjNPPn
	xxRsnMU6uCBNpp71p03TvLwraT7G+JleAUYfOkyHVxEU8F5ZKW8kAOzil53k
X-Received: by 2002:a05:600c:1d1a:b0:4a1:f688:a5d5 with SMTP id 5b1f17b1804b1-4a966c41de5mr120076385e9.23.1793276883350;
        Thu, 29 Oct 2026 05:28:03 -0700 (PDT)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7f322c46sm59729615e9.2.2026.10.29.05.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 05:28:02 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Etienne AUJAMES <eaujames@ddn.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v3 07/13] e2fsck: directory rehashing with dirdata support
Date: Thu, 29 Oct 2026 12:27:38 +0000
Message-ID: <20261029122744.230678-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
References: <20261029122744.230678-1-ablagodarenko@thelustrecollective.com>
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

Implement complex directory optimization and rehashing with proper dirdata
handling. This prevents corruption when renaming duplicate entries with name
expansion.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/rehash.c | 234 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 155 insertions(+), 79 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index c9a47ad6..7659ddd5 100644
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
@@ -188,11 +193,14 @@ static int fill_dir_block(ext2_filsys fs,
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
@@ -210,7 +218,7 @@ static int fill_dir_block(ext2_filsys fs,
 		}
 		ent = fd->harray + fd->num_array++;
 		ent->dir = dirent;
-		fd->dir_size += ext2fs_dir_rec_len(name_len, extended);
+		fd->dir_size += ext2fs_dirdata_rec_len(dirent, extended);
 		ent->ino = dirent->inode;
 		if (extended) {
 			ent->hash = EXT2_DIRENT_HASH(dirent);
@@ -391,66 +399,128 @@ static errcode_t get_next_block(ext2_filsys fs, struct out_dir *outdir,
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
@@ -463,7 +533,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	blk_t			i, j;
 	int			fixed = 0;
 	char			new_name[256];
-	unsigned int		new_len;
+	int			new_len, max_len;
 	int			hash_alg;
 	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
@@ -508,7 +578,9 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
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
@@ -516,15 +588,14 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
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
@@ -588,8 +659,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
-		rec_len = ext2fs_dir_rec_len(ext2fs_dirent_name_len(ent->dir),
-					     hash_in_entry);
+		rec_len = ext2fs_dirdata_rec_len(ent->dir, hash_in_entry);
 		if (rec_len > left) {
 			if (left) {
 				left += prev_rec_len;
@@ -624,8 +694,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		if (retval)
 			return retval;
 		prev_rec_len = rec_len;
-		memcpy(dirent->name, ent->dir->name,
-		       ext2fs_dirent_name_len(dirent));
+		memcpy(dirent->name, ent->dir->name, rec_len);
 		if (hash_in_entry) {
 			EXT2_DIRENT_HASHES(dirent)->hash = ext2fs_cpu_to_le32(ent->hash);
 			EXT2_DIRENT_HASHES(dirent)->minor_hash =
@@ -656,47 +725,52 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 
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
 
@@ -790,6 +864,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				struct out_dir *outdir,
 				ext2_ino_t ino,
 				ext2_ino_t parent,
+				struct ext2_dir_entry *dot_de,
+				struct ext2_dir_entry *dotdot_de,
 				struct ext2_inode *inode)
 {
 	struct ext2_dx_root_info	*root_info;
@@ -804,7 +880,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 		.done = false
 	};
 
-	root_info = set_root_node(fs, outdir->buf, ino, parent, inode);
+	root_info = set_root_node(fs, outdir->buf, ino, parent, dot_de,
+				  dotdot_de, inode);
 	root_limit = (void *)((char *)root_info + root_info->info_length);
 
 	/* Write out the pointer blocks */
@@ -1031,11 +1108,10 @@ resort:
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
2.52.0

