Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713857;
	b=bZMuB5kCG2LLjF5CzVTrcAkvnh5Aa1IQigLNQhsomTFSSdwMpn2BdlI0rB+gLuYGCufq
	 CzObLGX33ZD3skuQCPv4+l0Diryx3SWCDCoAWCxRSErj38A2MvoI6Wvac3+1jYgDHIO7/
	 Vw3pJazqnryrzZ9z7piLjQAaCVallu5VAx4nDVEEJzMWMhsQEvv71oTiGn2itv25Jr+qS
	 4URXeIR/eH2gJLJAfTI70ml1i/Tk6+HhB2/Gt1dLGfCoeRznwlYUjwzHF7RgxDQpQKZB5
	 nwGy/CH2JT0LGMeGbprk0vXM3TMGH9AhBNeN7XwcbmKxlOxAYO8FDoO8/swrXmMMjRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713857;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=hwM3Zd65FAOXocql/ufO7Zfl9GgVko8/UOtwqnv9Jp8=;
	b=4cp5j6Z386jytATlKEeYq77cECgrjJhthfOuZ36yELXd07Oq3x153PBLOPN6nOVCRn7/
	 vxHBGnpMkcyrBoJPKyRiyOChcpplUSBM55F6KIn0SuVZwxe3XwCCJ5tHw4aP6bQ8b6NqQ
	 KYV6kELt+CjlZq1tpS8wEwIZEljRARlQEdMkA0m6WCbWG/74aC10mMFIr/P24ybjXRaCx
	 Du5PI2Qh6sOcogw9ygLVLD1pc/bjpyifnRpQgwVISdym8GcnEdD0ZgYvPEiNn4tUP50tX
	 DZOkylTgZw9kwtkqGHDKW+cq4UdGICVhCDTiU0KEnIL4Zx2gkcB43jQFG5zcovXPyyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fc+gctvu;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCC2606EE93
	for <linux-ext4@vger.kernel.org>; Tue,  3 Nov 2026 13:50:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BCC2606EE93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fc+gctvu
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48dfaa3fa12so465700f8f.0
        for <linux-ext4@vger.kernel.org>; Tue, 03 Nov 2026 05:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713856; x=1794318656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hwM3Zd65FAOXocql/ufO7Zfl9GgVko8/UOtwqnv9Jp8=;
        b=fc+gctvuedEzvAU2oIi4cJ2o8Rs0rwbpJThjPT9VhKYl0VAlf3SFzEZLephnT4j/ar
         5/0NyQZKDY7ZzrYAv1SS4Vq+9ggGkua7syfvzxsVIQlagGfkmavKbg5n6w9zwSJC7220
         gzD1ziIOidaSHkCmX94ds7QBhnh5dTuRRTn9TGWWU68zg7clYcLR0qkFq17SjM4F50NO
         G8FILWm45WunXsyxwfJxQ2qfHTNmunONQlzE2cGDQWqP9xOSf0Yuy8HvO0U9EMrI+3Oj
         eOtT3Vb4G1/GWZMRfXYN4kUVAIwau+gSMPTpvRzdbswVszXe84qVyUseaVPi/KNA8Qx8
         X2WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713856; x=1794318656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hwM3Zd65FAOXocql/ufO7Zfl9GgVko8/UOtwqnv9Jp8=;
        b=X+3DIEcNi7SBEhnrtuR4k9fSqG1PbOZIlPph9tyRMDZ4vrVSK+ZACgvgabftfGOxV9
         ueqjVyvqXu3is6yupqM3DV/JMylOs7zeBFq/X45Tw5cIgQc0V2wnPZybXB5wakV3esOh
         fupF2sYSBeIwN62w7upXi+DnL9IfanOxdReWhjjhNRSph5KcAiomtT440Yyq7W81jzH4
         5H5R+M5XYMfiP/fHv0IWf3v/sEv4Lwgz9StLe6WBleL8liHLWDVApIOEbrhQEBIBSggC
         8xUpWqOP9v8sBd7TPIbS8bpZi7zzxwS0O5DMSOSR9u4w9f3laCB28z3q34Iq9AcUtb/l
         AzkA==
X-Gm-Message-State: APuU4Z8c3jhCVMA4zN9mEqaiidqa9+gjP3YBHwVLc4P3jXIH36MYb++S
	yBU0EXYQfnGfHw9rlMv5XmurEP78YfkvmuD8/yW80gAaFFdqy8J+RWWyDotS0hkgVEM=
X-Gm-Gg: AYBFou0CBp/xLHPH374MCORRoK5r024ATxQKnYX2+yqM0EeANX9qyHD3hfZrp8b6vin
	zwTI0vFnXINA+6IR+MVGp5qqq14u9elg258xHv/xVPGbJr1Ur5O8hNSv/2AHdXcaVQK4nrSBkWe
	aVd/moZt7E7VsqszNjA382NUaEAXZOr2uz6SLYmCl28y9HNcrg6/3sM9nSSVXmdH1a4OXPZ5tyT
	EbdGwtifHd3S85bce8GADZT9eXvOAx1WHgiQ8qfs3FIPEuBDoG9dkq+sKeJ2l8Tnh+3EpIUiHG6
	v550JliVPzpZlZnbUBi2lG2feX5j3hhCIX+QynUVa6LND4zkfvH+LYIQ8idqwaAt3nD3k/+Dhzs
	gWRv5PvnHc0s9WpSDg7afC1/4E/VRqG+iENNTMuuv7nyMoo+KWLl3Oj0YalPd7vqA+82yDTSu9w
	ln5NtxJKBxZTc+uoTJTZRr+sBMyewEgNgaMbvCXsyAdxJVj39EJqoHlxqGRGasq4I9CZTPp4xTu
	wjNaUlRYC1hrO7i2iIVWAHtNVPruW8g8x+9E1/m9QQJmuVf+aEg4stcsHYb/Jt/w3/5ZGFAKUZr
	GoEtixJcKIDDbb5ecmu1g5TITKsVxjjU80mJGdUnnFiPYoAygssDagtzj5d3
X-Received: by 2002:a05:6000:2285:b0:48d:ed0e:6bb4 with SMTP id ffacd0b85a97d-48e6494c244mr41798738f8f.4.1793713855430;
        Tue, 03 Nov 2026 05:50:55 -0800 (PST)
Received: from Cluster2.powerhub ([2a0a:ef40:18b5:9e01:225:90ff:fefc:9ffe])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a6bsm25036829f8f.27.2026.11.03.05.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:50:54 -0800 (PST)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	ablagodarenko@thelustrecollective.com,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	Pravin Shelar <pravin@clusterfs.com>,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH v4 07/13] e2fsck: directory rehashing with dirdata support
Date: Tue,  3 Nov 2026 13:50:31 +0000
Message-ID: <20261103135037.610132-8-ablagodarenko@thelustrecollective.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
References: <20261103135037.610132-1-ablagodarenko@thelustrecollective.com>
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

Read and write the entry hash with ext2fs_dirent_hashes(), so that
e2fsck -D sorts casefolded+encrypted directories by the hash in the
CFHASH record, as the kernel does.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: Pravin Shelar <pravin@clusterfs.com>
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Assisted-by: Claude:claude-opus-5-5
---
 e2fsck/rehash.c | 249 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 165 insertions(+), 84 deletions(-)

diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index c9a47ad6..d9ed7984 100644
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
@@ -210,11 +218,14 @@ static int fill_dir_block(ext2_filsys fs,
 		}
 		ent = fd->harray + fd->num_array++;
 		ent->dir = dirent;
-		fd->dir_size += ext2fs_dir_rec_len(name_len, extended);
+		fd->dir_size += ext2fs_dirdata_rec_len(dirent, extended);
 		ent->ino = dirent->inode;
 		if (extended) {
-			ent->hash = EXT2_DIRENT_HASH(dirent);
-			ent->minor_hash = EXT2_DIRENT_MINOR_HASH(dirent);
+			struct ext2_dir_entry_hash *h =
+				ext2fs_dirent_hashes(dirent);
+
+			ent->hash = ext2fs_le32_to_cpu(h->hash);
+			ent->minor_hash = ext2fs_le32_to_cpu(h->minor_hash);
 		} else if (fd->compress) {
 			ent->hash = ent->minor_hash = 0;
 		} else {
@@ -391,66 +402,128 @@ static errcode_t get_next_block(ext2_filsys fs, struct out_dir *outdir,
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
@@ -463,7 +536,7 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
 	blk_t			i, j;
 	int			fixed = 0;
 	char			new_name[256];
-	unsigned int		new_len;
+	int			new_len, max_len;
 	int			hash_alg;
 	int hash_flags = fd->inode->i_flags & EXT4_CASEFOLD_FL;
 
@@ -508,7 +581,9 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
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
@@ -516,15 +591,14 @@ static int duplicate_search_and_fix(e2fsck_t ctx, ext2_filsys fs,
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
@@ -588,8 +662,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		ent = fd->harray + i;
 		if (ent->dir->inode == 0)
 			continue;
-		rec_len = ext2fs_dir_rec_len(ext2fs_dirent_name_len(ent->dir),
-					     hash_in_entry);
+		rec_len = ext2fs_dirdata_rec_len(ent->dir, hash_in_entry);
 		if (rec_len > left) {
 			if (left) {
 				left += prev_rec_len;
@@ -624,12 +697,13 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 		if (retval)
 			return retval;
 		prev_rec_len = rec_len;
-		memcpy(dirent->name, ent->dir->name,
-		       ext2fs_dirent_name_len(dirent));
+		memcpy(dirent->name, ent->dir->name, rec_len);
 		if (hash_in_entry) {
-			EXT2_DIRENT_HASHES(dirent)->hash = ext2fs_cpu_to_le32(ent->hash);
-			EXT2_DIRENT_HASHES(dirent)->minor_hash =
-							ext2fs_cpu_to_le32(ent->minor_hash);
+			struct ext2_dir_entry_hash *h =
+				ext2fs_dirent_hashes(dirent);
+
+			h->hash = ext2fs_cpu_to_le32(ent->hash);
+			h->minor_hash = ext2fs_cpu_to_le32(ent->minor_hash);
 		}
 		offset += rec_len;
 		left -= rec_len;
@@ -656,47 +730,52 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 
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
 
@@ -790,6 +869,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 				struct out_dir *outdir,
 				ext2_ino_t ino,
 				ext2_ino_t parent,
+				struct ext2_dir_entry *dot_de,
+				struct ext2_dir_entry *dotdot_de,
 				struct ext2_inode *inode)
 {
 	struct ext2_dx_root_info	*root_info;
@@ -804,7 +885,8 @@ static errcode_t calculate_tree(ext2_filsys fs,
 		.done = false
 	};
 
-	root_info = set_root_node(fs, outdir->buf, ino, parent, inode);
+	root_info = set_root_node(fs, outdir->buf, ino, parent, dot_de,
+				  dotdot_de, inode);
 	root_limit = (void *)((char *)root_info + root_info->info_length);
 
 	/* Write out the pointer blocks */
@@ -1031,11 +1113,10 @@ resort:
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

