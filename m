Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05E74F798F
	for <linux-ext4@vger.kernel.org>; Thu,  3 Sep 2026 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472972; cv=none; b=jNz33k9pF2GxqjHK3zJpA+QXag0mIxCxFsr3+Rf+YAKbJFxE2hUcIgjUwSNGKEYh1h7lRizkZ/MXYpMnJnbJqy1kT2yYHCKcgUiPIAC328l25POtBKEfWTg5b7781dVaDm7btcfrsyzVtnqGMghr20QdnEAEPCKw9zppGFZa+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472972; c=relaxed/simple;
	bh=LAIn6EpYb58ICtK3Is7806tx1nzVEXcSheTY6eo2PZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3KvlPjUkeTdgsMqysMq0WxjoTnTv37imRoDvbyFuz/wF9ArrFtmYCKiJOYQW+CdX5Db3FCkxsbYaVQ8jgRKN5QB/VK9+unlcXDg4V22NAxn+t7C1sU33FigVCj4rm0aY0Lnzjr8vKVyZ2lFXA0MyqoTc6PmtUatRDb6+Yed5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhwQqFok; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhwQqFok"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b8e527d63so4867425e9.2
        for <linux-ext4@vger.kernel.org>; Thu, 03 Sep 2026 15:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472969; x=1789077769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zTuK9XZMtc9+1AXSlELi2r8768KOpZcGY7rAXOOeIk=;
        b=MhwQqFok8jS0KaPGcf/FkqAElv/syRLYNAsNs+Na3hO8aTYcNmPetug4KO9vB2+2Mg
         HMD8RF0Uo7FwitczAmm9sbcjNT9bUtYu7Coi/KqIyUpiMGIg1jeu+iAjHEoaSwUSVDna
         lFA8WUpaPY2XNSPuYMNBMFWjcjNQdz72CXZVLfCvydMiXp0YVJ0b6jaCAiaJXgzZhKjN
         LkSScfaRrlad/6b/hLDYFeoJLEWcUz6oC4rNASyOnfxboE9SoxGITcUMwBmUKOrprNvm
         ZdHc6FHJfxwX1+9j2ZNKCoUzOtIaEwnSb6hiZ1pvcDNB6HUxImPe/Bf5fuU2yMQl6BPZ
         GZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472969; x=1789077769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7zTuK9XZMtc9+1AXSlELi2r8768KOpZcGY7rAXOOeIk=;
        b=aCbLyIOsnUVAak+OJcqFUgroF4n5HCbLZQwsHE/5tApRU12QH7wjgihBdLD+6D1TGx
         AsPg5mRPO7j7DMlKzr6t7wFZZFTC/ZoHUy3u2mC8MqFh4K3Vk16CFhNkJ+y5SeLyPZYB
         DbZ3YCR8xP/zdGZQwNWuQJl+zhsqmB1IdZ+tgq0mFJ3iPvD6Yzhkcv9HIWmTuZVXRZjA
         HVCFYPf6mEbp0GrYyTOIYhIOlVub1Z+vSX5ocTHgFYczYljN/QNnQqHYzx3UGl4HvsW/
         YIEAOQ/KhDBznT1+INNMTlxF87YV8RHqvLbOVVdrwcsk5LdDH09a7ZkuueEjsjiV4hGP
         zzwQ==
X-Gm-Message-State: AFuF++n2/Hr/SsOQtGG8c/Lk4mBM7K17Q3ThUKGznUhQXDZsIalECbua
	WdqWo0q8To5NPtouUdcup96fBCFAgumQXN7qvX8KdMxo7VpnyWE+9IU2NcPQ1w==
X-Gm-Gg: AYBFou3u0G1eVEW97K2jftAcMJ3xI2fl6m/T4Rzervwca9t0OJ0glzWaldRkJBbKssg
	JFiLqlo8Wa+juWnQl/jKCKR7Ddv9DcgXJ9d9HIdieMgQtJopxD2QSKJz9b1IEo8z5Qf2XQO/33f
	ksdP+R+Kj120tyb1Uh6S4+5i2kswI1p2XIybDnQhMISKG57rppe/44KH8wJSKlcRc3X0V3HX6w2
	JU4jd7kqb815Pm8QYqlzP1zOL/2P07hOrkzoR7//3OOUx9BJzmJd0BAmoU/7Q+91vWFV2lkN7Bq
	moUToC3jxXQoUmu4AicCyOJnypuuPgyg4nj3Y2X+QMzM5B0uJ/s2iZrMAcytJIsHZZ3PH+84+UT
	sjJphGjoKZh+0WYKsjALzxbphurlwAawTl9/Ho3tRpxUGa6mAfymZSi3e4edlCnlSigNIxQn7Hk
	7Dc9B6IfT5GSjE2se2ANnT0ymcTqnPf7aGOz12crdXA2sX7xAQaBbHZBXMtlXiVi+RMqm0qCdqI
	Zf9IbwyJc6lxZ2w6XY3
X-Received: by 2002:a05:600c:4ecd:b0:49b:c8e:8e6 with SMTP id 5b1f17b1804b1-49cf7f4a5efmr15704095e9.0.1788472968766;
        Thu, 03 Sep 2026 15:02:48 -0700 (PDT)
Received: from Cluster1.powerhub ([2a0a:ef40:18b5:9e01:f5de:1ef8:371:ee89])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm104346975e9.0.2026.09.03.15.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 15:02:48 -0700 (PDT)
From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <ablagodarenko@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: adilger.kernel@dilger.ca,
	Artem Blagodarenko <artem.blagodarenko@gmail.com>,
	Andreas Dilger <adilger@dilger.ca>
Subject: [RESEND v2 04/13] libext2fs: add helper for dx_root_info lookup
Date: Thu,  3 Sep 2026 18:01:37 -0400
Message-ID: <20260903220146.19752-5-ablagodarenko@thelustrecollective.com>
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

Add dirdata support infrastructure in the new lfsck.h header, with
data structures (lu_fid, ext4_dirent_data_header, ext4_dirent_hash)
related to dirdata fields.

Also changes to ext2_fs.h and ext2fs.h to support INCOMPAT_DIRDATA.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/htree.c     |  2 +-
 e2fsck/pass1.c      |  2 +-
 e2fsck/pass2.c      |  7 +++----
 lib/ext2fs/ext2fs.h | 19 +++++++++++++++++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 4ea8f30b3..efb858271 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -298,7 +298,7 @@ void do_htree_dump(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		goto errout;
 	}
 
-	rootnode = (struct ext2_dx_root_info *) (buf + 24);
+	rootnode = ext2fs_get_dx_root_info(current_fs, buf);
 
 	fprintf(pager, "Root node dump:\n");
 	fprintf(pager, "\t Reserved zero: %u\n", rootnode->reserved_zero);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 39d1255f9..12925ce2f 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2801,7 +2801,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 		return 1;
 
 	/* XXX should check that beginning matches a directory */
-	root = (struct ext2_dx_root_info *) (block_buf + 24);
+	root = ext2fs_get_dx_root_info(fs, block_buf);
 
 	if ((root->reserved_zero || root->info_length < 8) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 319e7e0e3..cf1678c85 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -650,7 +650,7 @@ static void parse_int_node(ext2_filsys fs,
 	int		csum_size = 0;
 
 	if (db->blockcnt == 0) {
-		root = (struct ext2_dx_root_info *) (block_buf + 24);
+		root = ext2fs_get_dx_root_info(fs, block_buf);
 
 #ifdef DX_DEBUG
 		printf("Root node dump:\n");
@@ -677,8 +677,7 @@ static void parse_int_node(ext2_filsys fs,
 				&cd->pctx)))
 			goto clear_and_exit;
 	}
-
-	limit = (struct ext2_dx_countlimit *) ent;
+	limit = (struct ext2_dx_countlimit *)ent;
 
 #ifdef DX_DEBUG
 	printf("Number of entries (count): %d\n",
@@ -1236,7 +1235,7 @@ inline_read_fail:
 		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
-			root = (struct ext2_dx_root_info *) (buf + 24);
+			root = ext2fs_get_dx_root_info(fs, buf);
 			dx_db->type = DX_DIRBLOCK_ROOT;
 			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 91d269865..cf12716e3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -2262,6 +2262,25 @@ _INLINE_ int ext2fs_htree_intnode_maxrecs(ext2_filsys fs, int blocks)
 						sizeof(struct ext2_dx_entry));
 }
 
+_INLINE_ struct ext2_dx_root_info *ext2fs_get_dx_root_info(ext2_filsys fs,
+							 char *buf)
+{
+	struct ext2_dir_entry *de = (struct ext2_dir_entry *)buf;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
+		return (struct ext2_dx_root_info *)(buf +
+						    EXT2_DIR_NAME_LEN(1) +
+						    EXT2_DIR_NAME_LEN(2));
+
+	/* get dotdot first */
+	de = (struct ext2_dir_entry *)((char *)de + de->rec_len);
+
+	/* dx root info is after dotdot entry */
+	de = EXT2_NEXT_DIRENT(de);
+
+	return (struct ext2_dx_root_info *)de;
+}
+
 /*
  * log base 2, rounded down
  */
-- 
2.43.7

