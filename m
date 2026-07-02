Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11467331EAF
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 15:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007329; cv=none; b=h+Na1vwS+7Q4HGKbO6rsJXY5+63WX/MhN2lV0PFE2gauZR9jVp4lw3OlnOUxn96SVDEDtrMIFq0t10twYKDeTRGitffOmk4hMnVDSvKyxq0CU9vQT71sHqb3LoX5fekKu23xRvDhlFtafYZtna/B0m04NI8S0yIGisCWW5dHKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007329; c=relaxed/simple;
	bh=GHe4f0gJmEY4HTStiVAVdP5FYbjDD0vlOpHVKNuxEy4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A3+1EPRieyGRwX/2ueCmyHHR1R0N/+kZyQAL1GInJFIfxIbHj+kNqm1y3F56lEXc+aEdk4VQTwYlA/qy2oRm4GitaYVROQueC/44PmXugkHoEDXaBUag5hsL7878TzHcH3R6qwum2AHR+ihCNwxMuLlLkjpmz8e2/Q71RpDKaTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=nQFzvMGU; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="nQFzvMGU"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-470174001a0so1462671f8f.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 08:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1783007326; x=1783612126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cKj12gt7daFFKUdXxcgEMCasVJqe5u0XDbVIMbqELsI=;
        b=nQFzvMGUQvQI6EZOe0f5vgqCjTjZ5zGyoHAouupznJn54kFGa+XSQanNNML1Q+prB7
         eh2OTzsy3DVO/c6MJrue4dsvXfZYMHlTYJHM1GNnxz5eCAdHR4PCC2XrUuWKLnnsFJdX
         m23pyJAui+jBLsB+hXtXNc2p0rDEP1H7rRuZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783007326; x=1783612126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKj12gt7daFFKUdXxcgEMCasVJqe5u0XDbVIMbqELsI=;
        b=RrayZmAi/MFozFaWHWx68YajOmxbDtaOKhZWFX9ZaqTHtpQjfDR3sSrXCmj0RlO7CL
         n6WxIPjERKsd6Nl7fxJCRgZ5sf5H1FccZX6GuJu4EIu9M7iVxSugKKo1t1SVC6g0GDXl
         4H1gRpUS9M2klUuwZ23229oQuT+A47dTHvgJZo412FDjugcT3rE7yd9RmPEl095hGj9b
         txIp1hUvcPFqqcOO9lb7CB2pKK1ESLeISJDCxSBArcBSDW1lFevxtBrTK25iFodSBPpr
         NKmsEHY5osFpAxeSiLC8EG2jij98E1rSS6gZ/uHC5yKwBJCBzTHducZoTwoP9+ux0ZfX
         MrNg==
X-Gm-Message-State: AOJu0Yzz1/nH6TNV3ggPoqgxV9iYZPkP/BDKAW9GrUZbO/m6QA1bZM8d
	aTEDy5mnT4X89T+kd8+kpv+TKUIRX1se1tUwPqbyIOiXxrtn764xIHduW1c46A1ttx4=
X-Gm-Gg: AfdE7clHVeHs8GS7nGnrp9JhlWxgp0OutxKIxLfhBPBKJcr89P2M6IwOwzyOrHwEGMM
	Dh0ytOwvDIcN0r/5i4gaTx0iXAbq7tyt6w12U1sPnsIvxQXA7cpSxIbODYTteAYUAx3DlEKFq6B
	8bWUo0L5EaiWIMgfTklKHWjBepkwVOw5X4yAZkAGAsAZ6FRMB6JQtKVnD4ZMxL0t6vdtVgkq9oM
	MZwVsnBaPh4YJP+4fgBT6eFK5nahOPpKOABzYWAM2f1PBIwHr/N1ovvFqu9u6LgnTrTbJ+JEX1l
	lvXMWKiGYa7pZdd6nflvYdHKp2MLPakFEcdDGS6hqEx5Bb2Ndamwzy+kX/joexhkCn/Ej5IjK68
	KucQDQilds26vKeCp4hkXYnIe7EQ/Y3DcoybjcuC6thc+OTUztwJCfHtk4pQrf9e88VjKNmmdl0
	C7rqhx91gTWfJGNZd0kf/JgeBB8DfyTY7ledMgxPy2hGCt2RHw+RhDrj/pvcUAV4YDf9gSRjwF/
	gytaAXsC+vRAMX/bxBw4LhrmELq
X-Received: by 2002:a05:6000:2507:b0:473:975c:4fd1 with SMTP id ffacd0b85a97d-477b3d5c5bfmr8449841f8f.25.1783007326422;
        Thu, 02 Jul 2026 08:48:46 -0700 (PDT)
Received: from FRSMI25-LASER.home (2a01cb001331aa00c56cc01f8c3c1c95.ipv6.abo.wanadoo.fr. [2a01:cb00:1331:aa00:c56c:c01f:8c3c:1c95])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477de3dc77bsm10042468f8f.33.2026.07.02.08.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 08:48:46 -0700 (PDT)
From: Yoann Congal <yoann.congal@smile.fr>
To: stable@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Ts'o <tytso@mit.edu>,
	Yoann Congal <yoann.congal@smile.fr>,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH 6.6.y] ext4: get rid of ppath in get_ext_path()
Date: Thu,  2 Jul 2026 17:48:10 +0200
Message-ID: <20260702154810.3435236-1-yoann.congal@smile.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 6b854d552711aa33f59eda334e6d94a00d8825bb ]

The use of path and ppath is now very confusing, so to make the code more
readable, pass path between functions uniformly, and get rid of ppath.

After getting rid of ppath in get_ext_path(), its caller may pass an error
pointer to ext4_free_ext_path(), so it needs to teach ext4_free_ext_path()
and ext4_ext_drop_refs() to skip the error pointer. No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/20240822023545.1994557-13-libaokun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
---
 fs/ext4/extents.c     |  5 +++--
 fs/ext4/move_extent.c | 34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a94798e23c1af..9c2d23958146b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -114,7 +114,7 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 {
 	int depth, i;
 
-	if (!path)
+	if (IS_ERR_OR_NULL(path))
 		return;
 	depth = path->p_depth;
 	for (i = 0; i <= depth; i++, path++) {
@@ -125,6 +125,8 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
 
 void ext4_free_ext_path(struct ext4_ext_path *path)
 {
+	if (IS_ERR_OR_NULL(path))
+		return;
 	ext4_ext_drop_refs(path);
 	kfree(path);
 }
@@ -4242,7 +4244,6 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	path = ext4_find_extent(inode, map->m_lblk, NULL, 0);
 	if (IS_ERR(path)) {
 		err = PTR_ERR(path);
-		path = NULL;
 		goto out;
 	}
 
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d5636a2a718a8..96a84de321690 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -17,27 +17,23 @@
  * get_ext_path() - Find an extent path for designated logical block number.
  * @inode:	inode to be searched
  * @lblock:	logical block number to find an extent path
- * @ppath:	pointer to an extent path pointer (for output)
+ * @path:	pointer to an extent path
  *
- * ext4_find_extent wrapper. Return 0 on success, or a negative error value
- * on failure.
+ * ext4_find_extent wrapper. Return an extent path pointer on success,
+ * or an error pointer on failure.
  */
-static inline int
+static inline struct ext4_ext_path *
 get_ext_path(struct inode *inode, ext4_lblk_t lblock,
-		struct ext4_ext_path **ppath)
+	     struct ext4_ext_path *path)
 {
-	struct ext4_ext_path *path = *ppath;
-
-	*ppath = NULL;
 	path = ext4_find_extent(inode, lblock, path, EXT4_EX_NOCACHE);
 	if (IS_ERR(path))
-		return PTR_ERR(path);
+		return path;
 	if (path[ext_depth(inode)].p_ext == NULL) {
 		ext4_free_ext_path(path);
-		return -ENODATA;
+		return ERR_PTR(-ENODATA);
 	}
-	*ppath = path;
-	return 0;
+	return path;
 }
 
 /**
@@ -95,9 +91,11 @@ mext_check_coverage(struct inode *inode, ext4_lblk_t from, ext4_lblk_t count,
 	int ret = 0;
 	ext4_lblk_t last = from + count;
 	while (from < last) {
-		*err = get_ext_path(inode, from, &path);
-		if (*err)
-			goto out;
+		path = get_ext_path(inode, from, path);
+		if (IS_ERR(path)) {
+			*err = PTR_ERR(path);
+			return ret;
+		}
 		ext = path[ext_depth(inode)].p_ext;
 		if (unwritten != ext4_ext_is_unwritten(ext))
 			goto out;
@@ -634,9 +632,11 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		int offset_in_page;
 		int unwritten, cur_len;
 
-		ret = get_ext_path(orig_inode, o_start, &path);
-		if (ret)
+		path = get_ext_path(orig_inode, o_start, path);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
 			goto out;
+		}
 		ex = path[path->p_depth].p_ext;
 		cur_blk = le32_to_cpu(ex->ee_block);
 		cur_len = ext4_ext_get_actual_len(ex);
