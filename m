Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DC6381AEA
	for <linux-ext4@vger.kernel.org>; Sun,  5 Apr 2026 19:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775418636; cv=none; b=qHmIf/aMeE0OJ7gAngelPdUU6qnZGOUNDsJQmbf9lPzHRjZRGuhwNZl9zXZC5Bu0/0+UfRV3eF7UW0Ruh/0qorR38HyWnBCzfxXHlQDeS4vzPI7t+fD1wyE9gRCX0Zoe+PMk3H3R3Se0FpptaWSwVHX7Zzomfk+oq+XjJ83Mnf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775418636; c=relaxed/simple;
	bh=86iU4DdMA36g4XN2jsK7LFKschNuqEBgNYcZ9RMG0CE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PFMjOA0583BL1DmRsybQMvVv0NIUU2RYItPBvEUbV5qasn8gI52Q0Jx495AlZbXcxVeQfxure+jAnx1VNz1vql0sJ8Ju3GOXtq5ezeXjQT+elWUrOzNzQY4MyW4sJec6/eBQMPGg4t3iVJo2BfOYpGIUjT7AsqwyKkhFpd/SXTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P0d1Y2kO; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P0d1Y2kO"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-40423dbe98bso1253251fac.2
        for <linux-ext4@vger.kernel.org>; Sun, 05 Apr 2026 12:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775418633; x=1776023433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UrIwJqOEWN8CqB58IAv7ymZXeOXfq1k3iasJiHQ/4Y=;
        b=P0d1Y2kOPGY0K2ZXixgTgOIpcsSp8knDSFySoiS9GQX+ePrHlaqU8CyxXsPoPTx2rG
         8dOU2IwEgHerGcaPrmbKNGFsIrQG9KWSFsxalAM6P5L5zd0Qb70rQkDPDZEYlrhkAay8
         rb6ADp7h90opFEQIrbx2HNJGvhRnOmZ/jxs8TsGsGhYqc7SCqykHKB8trD7pJXQNJTiX
         oNGX5y3ZvBlkVt3PMoB1C8iddPe0sCo13fM+DhH+QL5gMonM0u8sgmpmPBGUHq9TPfbH
         Ivv1ZpjDDekkMomU54vRJN4IE/cZ7pWg0tPjpR5AEF6fw7qyyq/pYZTBiOkbmV9q0QQ8
         QUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775418633; x=1776023433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0UrIwJqOEWN8CqB58IAv7ymZXeOXfq1k3iasJiHQ/4Y=;
        b=rxiB9VnX0ZRxeplZdjdW0b7tLvlL2LrbM9JWYvhiz1BqXHZtVAHhMIshqoMgyloWhb
         Fvbn8Zn+wGRL7XPNtKeQxe1et45nmqZBdt/6z+dN5vFYPO4x9Y/JiBoCK1GrOeWp5xFR
         7Vaj1LohQitDzkONm8voncJv9mr4Gn2nzMGgoFSwqojexiQUdNe4itAYuXs39KyoK04p
         UPlC0weLMDdTtkjEVfdMi4WsP/UMr9n3OWD4kpmqLhFZUGsGf23gvxZmpJipEgX5zlMY
         TXtkPqRUq+lAKSKqxKVKLo6r63Hx1GJ/liWIZSjpa8xay6gmIC2/sjfigbFoAAXImNWf
         41Vw==
X-Gm-Message-State: AOJu0YxFVn40j/6oTsqMKSIUO65j8AHeEAaZs3X2UngtEaIGDoCXCnlX
	hMBGKI3xfdTpzdBzFGzRImhu5+Ba8TPm9PuFfMyTZ5AH1KjEPTA1Np5B
X-Gm-Gg: AeBDieuJVchl3sybnSH9sAtcN+vdog5jNtU28c98H6rhxN5hRXlDcj/bN+hMbXhUUwZ
	WmiQyk1zCB+r7t9gWpykkFTulLiLxRoOu33Ag3ElbctwLVqY0aMOVHl5Pue2R4orVioqiikLdo/
	SMG/ScvbVPNuDZHtXhwpthTJmx2/ehgmckjOiSNtDzg24118IE1GaW4Uy5SKLlXpHGkSbawtHxF
	dwWvilet+xYxODL+WuvqqSCUc6o3MaMz/WkTePE1RTcbMUz7kbptPNsI2Ij2Ndl1qyj+pDPzvXn
	IZOQXbNtkiIAs31L3Bs9Ok5I+ES84pwDE+LcIyAS1r3kQ9dDyIRy+2n6HffNijCbnTMwjito4Yd
	ZHFxaiuG2hg4JVHc2i/mB8cz2mEWBDIqEPHNCRc/H7PzASk/mOAzETWKr64pD29NanG4W/N35Lm
	9whurw3/dX8MQMmKo0nyin/9a/S7A1QwRBWsHFLsdeGnxzIwkdF9sBNIsnnMHRY6hOTxlGHWRH7
	OvEP8qxqHDa//I=
X-Received: by 2002:a05:6808:1b23:b0:467:2a6e:adad with SMTP id 5614622812f47-46ef4f05067mr4952557b6e.11.1775418633206;
        Sun, 05 Apr 2026 12:50:33 -0700 (PDT)
Received: from localhost.localdomain (c-73-5-99-191.hsd1.la.comcast.net. [73.5.99.191])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46f46160155sm4547428b6e.17.2026.04.05.12.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 12:50:32 -0700 (PDT)
From: Sean Smith <defendthedisabled@gmail.com>
X-Google-Original-From: Sean Smith <DefendTheDisabled@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	tytso@mit.edu,
	dsterba@suse.com,
	david@fromorbit.com,
	brauner@kernel.org,
	osandov@osandov.com,
	almaz@kernel.org,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	Sean Smith <DefendTheDisabled@gmail.com>
Subject: [PATCH 2/6] btrfs: add provenance time (ptime) support
Date: Sun,  5 Apr 2026 14:49:58 -0500
Message-ID: <20260405195007.1306-3-DefendTheDisabled@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.1
In-Reply-To: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
References: <20260405195007.1306-1-DefendTheDisabled@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Store ptime as a dedicated field in btrfs_inode_item reserved space:
struct btrfs_timespec (12 bytes) + __le32 pad (4 bytes) = 16 bytes,
consuming 2 of 4 reserved __le64 slots, leaving 2 free.

In-memory: i_ptime_sec/i_ptime_nsec in struct btrfs_inode.
Persistence: delayed-inode read/write path (the primary persistence
path for normal inodes, not fill_inode_item).
Tree-log: ptime written to log tree for fsync crash recovery.
New inode: initialized to zero (ptime unset).

Getattr reports ptime only when non-zero (distinguishes unset from
supported-but-zero). Setattr accepts ATTR_PTIME and sets
BTRFS_FEATURE_COMPAT_RO_PTIME - old kernels see unknown compat_ro
bit and refuse RW mount, protecting ptime data.

Rename-over preservation: when rename(source, target) replaces an
existing regular file, if source has ptime=0 and target has ptime
set, inherit target ptime to source. Guards: S_ISREG both sides,
nlink==1, not RENAME_EXCHANGE/WHITEOUT. Atomic with rename
transaction. Enables atomic-save survival (write-temp + rename).

Signed-off-by: Sean Smith <DefendTheDisabled@gmail.com>
---
 fs/btrfs/btrfs_inode.h          |  4 ++++
 fs/btrfs/delayed-inode.c        |  4 ++++
 fs/btrfs/fs.h                   |  3 ++-
 fs/btrfs/inode.c                | 42 +++++++++++++++++++++++++++++++++
 fs/btrfs/tree-log.c             |  2 ++
 include/uapi/linux/btrfs.h      |  1 +
 include/uapi/linux/btrfs_tree.h |  4 +++-
 7 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 73602ee8d..bac92f766 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -334,6 +334,10 @@ struct btrfs_inode {
 	u64 i_otime_sec;
 	u32 i_otime_nsec;
 
+	/* Provenance time - original creation date of file content. */
+	u64 i_ptime_sec;
+	u32 i_ptime_nsec;
+
 	/* Hook into fs_info->delayed_iputs */
 	struct list_head delayed_iput;
 
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 7e3d294a6..649de7c29 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1887,6 +1887,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_stack_timespec_sec(&inode_item->otime, inode->i_otime_sec);
 	btrfs_set_stack_timespec_nsec(&inode_item->otime, inode->i_otime_nsec);
+	btrfs_set_stack_timespec_sec(&inode_item->ptime, inode->i_ptime_sec);
+	btrfs_set_stack_timespec_nsec(&inode_item->ptime, inode->i_ptime_nsec);
 }
 
 int btrfs_fill_inode(struct btrfs_inode *inode, u32 *rdev)
@@ -1935,6 +1937,8 @@ int btrfs_fill_inode(struct btrfs_inode *inode, u32 *rdev)
 
 	inode->i_otime_sec = btrfs_stack_timespec_sec(&inode_item->otime);
 	inode->i_otime_nsec = btrfs_stack_timespec_nsec(&inode_item->otime);
+	inode->i_ptime_sec = btrfs_stack_timespec_sec(&inode_item->ptime);
+	inode->i_ptime_nsec = btrfs_stack_timespec_nsec(&inode_item->ptime);
 
 	vfs_inode->i_generation = inode->generation;
 	if (S_ISDIR(vfs_inode->i_mode))
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 8ffbc40eb..7c8105ecf 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -284,7 +284,8 @@ enum {
 	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
 	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
 	 BTRFS_FEATURE_COMPAT_RO_VERITY |		\
-	 BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE)
+	 BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE | \
+	 BTRFS_FEATURE_COMPAT_RO_PTIME)
 
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_SET	0ULL
 #define BTRFS_FEATURE_COMPAT_RO_SAFE_CLEAR	0ULL
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 13f1f3b52..dce80561a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4029,6 +4029,8 @@ static int btrfs_read_locked_inode(struct btrfs_inode *inode, struct btrfs_path
 
 	inode->i_otime_sec = btrfs_timespec_sec(leaf, &inode_item->otime);
 	inode->i_otime_nsec = btrfs_timespec_nsec(leaf, &inode_item->otime);
+	inode->i_ptime_sec = btrfs_timespec_sec(leaf, &inode_item->ptime);
+	inode->i_ptime_nsec = btrfs_timespec_nsec(leaf, &inode_item->ptime);
 
 	inode_set_bytes(vfs_inode, btrfs_inode_nbytes(leaf, inode_item));
 	inode->generation = btrfs_inode_generation(leaf, inode_item);
@@ -4220,6 +4222,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
+	btrfs_set_timespec_sec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_nsec);
 
 	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
 	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
@@ -5424,6 +5428,12 @@ static int btrfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	}
 
 	if (attr->ia_valid) {
+		if (attr->ia_valid & ATTR_PTIME) {
+			BTRFS_I(inode)->i_ptime_sec = attr->ia_ptime.tv_sec;
+			BTRFS_I(inode)->i_ptime_nsec = attr->ia_ptime.tv_nsec;
+			btrfs_set_fs_compat_ro(BTRFS_I(inode)->root->fs_info, PTIME);
+		}
+
 		setattr_copy(idmap, inode, attr);
 		inode_inc_iversion(inode);
 		ret = btrfs_dirty_inode(BTRFS_I(inode));
@@ -8007,6 +8017,8 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	ei->i_otime_sec = 0;
 	ei->i_otime_nsec = 0;
+	ei->i_ptime_sec = 0;
+	ei->i_ptime_nsec = 0;
 
 	inode = &ei->vfs_inode;
 	btrfs_extent_map_tree_init(&ei->extent_tree);
@@ -8159,6 +8171,14 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
+	if (request_mask & STATX_PTIME) {
+		if (BTRFS_I(inode)->i_ptime_sec ||
+		    BTRFS_I(inode)->i_ptime_nsec) {
+			stat->ptime.tv_sec = BTRFS_I(inode)->i_ptime_sec;
+			stat->ptime.tv_nsec = BTRFS_I(inode)->i_ptime_nsec;
+			stat->result_mask |= STATX_PTIME;
+		}
+	}
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
 	stat->btime.tv_nsec = BTRFS_I(inode)->i_otime_nsec;
 	if (bi_flags & BTRFS_INODE_APPEND)
@@ -8675,6 +8695,28 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 			btrfs_abort_transaction(trans, ret);
 			goto out_fail;
 		}
+		/*
+		 * ptime rename-over preservation: if a file with no ptime
+		 * is being renamed over a file that has ptime (the atomic
+		 * save pattern: write-to-temp + rename over original),
+		 * inherit the target's ptime so provenance survives.
+		 */
+		if (new_inode && S_ISREG(old_inode->i_mode) &&
+		    S_ISREG(new_inode->i_mode) && old_inode->i_nlink == 1 &&
+		    !(flags & (RENAME_EXCHANGE | RENAME_WHITEOUT))) {
+			struct btrfs_inode *old_bi = BTRFS_I(old_inode);
+			struct btrfs_inode *new_bi = BTRFS_I(new_inode);
+			if (!old_bi->i_ptime_sec && !old_bi->i_ptime_nsec &&
+			    (new_bi->i_ptime_sec || new_bi->i_ptime_nsec)) {
+				old_bi->i_ptime_sec = new_bi->i_ptime_sec;
+				old_bi->i_ptime_nsec = new_bi->i_ptime_nsec;
+			}
+		}
+		/* Note: if rename fails below, ptime mutation is harmless —
+		 * the source file keeps its previous ptime=0 semantics since
+		 * the rename didn't complete. The in-memory value will be
+		 * overwritten on next inode read from disk. */
+
 		ret = btrfs_update_inode(trans, BTRFS_I(old_inode));
 		if (unlikely(ret)) {
 			btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6c40f48cc..7ed09af22 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4640,6 +4640,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 
 	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
+	btrfs_set_timespec_sec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->ptime, BTRFS_I(inode)->i_ptime_nsec);
 
 	/*
 	 * We do not need to set the nbytes field, in fact during a fast fsync
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index e8fd92789..d2c542425 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -313,6 +313,7 @@ struct btrfs_ioctl_fs_info_args {
  * reducing mount time for large filesystem due to better locality.
  */
 #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE	(1ULL << 3)
+#define BTRFS_FEATURE_COMPAT_RO_PTIME			(1ULL << 4)
 
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index fc29d2738..719c00363 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -890,7 +890,9 @@ struct btrfs_inode_item {
 	 * a little future expansion, for more than this we can
 	 * just grow the inode item and version it
 	 */
-	__le64 reserved[4];
+	struct btrfs_timespec ptime;
+	__le32 __reserved_pad;
+	__le64 reserved[2];
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
-- 
2.53.0

