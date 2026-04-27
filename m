Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3966C346AFD
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 22:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777328588; cv=none; b=nl838il/Jk/OajLi4jk9Vbk9C/V6uMyKUblyoL5hCZVSDQEg38AMLS9KFYVqzcaI2AyW8eh7vW7aElXt/oeqr8fWwexc+FSUMhjKvcmvyHdvYkRHSsOCZfwvAHbMoC+0lC3VD7MccjUEdXYMxyq9X7ahv7iuuVW0Shj6Yg4R/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777328588; c=relaxed/simple;
	bh=cnLQ03yJKbFzs/YMJJsj9Uhc8Frpa3LYSsaNU8nZN4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RsSc8efT5wC9NWhrin1SZRFpEuwFuVa4VlrtaLfgadfTaLvCyYaAtSWiihKSJEN60rP8hcU1k6oT/VTsEe4/spnZShHGvO0sGVUb7HSAz+RmwaPmLjMt6wFD1l+BsqlL19v72YEogRJyfPYXlgxLuyaSiUIQxV4cRBSrL1gNa4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvwglyPc; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvwglyPc"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-56f75445470so6167859e0c.2
        for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 15:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777328586; x=1777933386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CW0tLQdd/fFSU3R2B/ztWAeJIMQ2wqigKRMmO6vFKbM=;
        b=cvwglyPcNijgNG9yecCxeiQrkuCohWZjxU994CGDogzG9t+2IppN/wNcCTb3nCZ4mt
         JanGCHMSifJm9YmKO3MuZfdLKmiCEcw7U0I4vkl0zzRpHgjjnTgxCtAN6U4rskkgAcN/
         xDToWJeb3Q7RM9PRmMppdX+w7DL4ASLv6G65JbA1AOASijb1eu2jTXafB1p1JVT1dPcw
         nQMpT17cTO0m32QFbDLFVk011c2IIOIDNCs28YZ32xSMPO6lYxJxurBmSQSThlP1qern
         KeStv4dJ91YagpjPaPgqxePMl8vSL7GPuv0UKzv0fsPF6dP9HIYvELBuxvY00pg/tKVU
         gHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777328586; x=1777933386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CW0tLQdd/fFSU3R2B/ztWAeJIMQ2wqigKRMmO6vFKbM=;
        b=at3shsltxTomXpPMwKVE+BDx7d8Tk59Ype2+LeHLZNaqhHcLkb7ownwW46lJoPP637
         tUCaESjqt0R/JGHjL0nJstqRNmy2M9EKefu9Vn8bn2SQflsvXJtTPsSDrxPWzH9J9a8/
         dYiAfH57+LMysN6OhUBkc/FEbBrEhVrfpyD+8TORiAUIObsG45q07qKofK7EUJwHF8AI
         ekMEumjbZ1vDRfD9vK5442AHR81BRuvlK6Uns1RP7h5bTLJTcvRV2SIWSFeFyc+dRLzO
         PHcaNEI2DYEJHURhqaStPiHrXrdiBeFqTlb2O6bK+gte+tWWP8/QgByYV6sJioBLUWOH
         UB8w==
X-Gm-Message-State: AOJu0YwG/pdeHyMhv1Ps4kClsI9NFqOyin0sQB71RlmprqLfvObU5swT
	a2m2LqxfJNQ2fmP39DoF19uefPLlqIeDDFnwJOLF5Q9q7DEAlhLkalWJN9aNuFrKjl0=
X-Gm-Gg: AeBDievCjLQNy/h6VrsDrSCFRdWovcmjvHXw/BxuTKUFNCns9+mXEhY04FEGzkZfKYh
	IRXZsJgFxAQNYnQAQz4ogMuJ47mf2Do8uW2fxz5BNc6p1lYcv1g4oLC2NEvRoGlfvbkQ2rZ+uwd
	JPnvZEJaENG3Oen6ikq7gQbYevBbxVh6Hj3M62g7Lei/jEeJyqK1BocafuaN+hPLL0GV4OxR2nh
	2iPjjnmXkmhddIfrw+UG8Q0J+z+mZk7bRTrU+4wE7u8V9zDpEAmxtddUG4Lx6aOiDdA6/5gSiVt
	nyxa3t9kse7yvlobFNsT8dsKXKsV9nkIz+2fs1AvQVthoANUOw3bSQG862JSVx6pwNj02qoJ81F
	bX+TAEMOD+Q+TBrAduSasA5/LNdIpLbB4XIwdnaJelzJQ4NLJrqGZBNkH82SIi6xzOgBzbjddZF
	IBZhSnZh0dpaYabjNMKA+jaXhB5E6EV/FB/anedzxYbQTM8s+Ge66F
X-Received: by 2002:a05:6122:3223:b0:56b:7023:1393 with SMTP id 71dfb90a1353d-573a563761dmr325205e0c.11.1777328584746;
        Mon, 27 Apr 2026 15:23:04 -0700 (PDT)
Received: from syssplab.cs.fiu.edu (nat1.cs.fiu.edu. [131.94.134.89])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-573a4338401sm625614e0c.4.2026.04.27.15.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 15:23:04 -0700 (PDT)
From: Chao Shi <coshi036@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	Chao Shi <coshi036@gmail.com>,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dave Tian <daveti@purdue.edu>,
	Weidong Zhu <weizhu@fiu.edu>
Subject: [PATCH] ext4: avoid __GFP_NOFAIL in __ext4_get_inode_loc allocation
Date: Mon, 27 Apr 2026 18:23:00 -0400
Message-ID: <20260427222300.1284855-1-coshi036@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When kswapd shrinks the dcache, the last iput() on an ext4 inode can
trigger ext4_orphan_del(), which calls ext4_reserve_inode_write() and
ultimately __ext4_get_inode_loc().  That function calls sb_getblk(),
which wraps __getblk() and carries implicit __GFP_NOFAIL.  Because
kswapd runs with PF_MEMALLOC set, combining NOFAIL with a non-reclaimable
context trips WARN_ON_ONCE(current->flags & PF_MEMALLOC) inside
__alloc_pages_slowpath(), producing a spurious splat even though the
allocation could simply fail and return -ENOMEM to the caller.

Switch both sb_getblk() call sites in __ext4_get_inode_loc() to
sb_getblk_gfp() with the same flags minus __GFP_NOFAIL
(mapping_gfp_constraint(~__GFP_FS) | __GFP_MOVABLE), computing the gfp
value once and reusing it for the optional bitmap_bh optimisation fetch.
All callers of __ext4_get_inode_loc() -- reached via ext4_get_inode_loc(),
__ext4_get_inode_loc_noinmem(), and ext4_get_fc_inode_loc() -- already
propagate a non-zero return as an error without aborting the filesystem.
Both sb_getblk() call sites in __ext4_get_inode_loc() are converted; the
bitmap_bh fetch already falls back to make_io on NULL, so allowing it to
fail is a no-op there.

Reproduced under syzkaller+FEMU based fuzz tool (FuzzNvme) on x86_64 QEMU,
based on mainline 894009e2ef10:

  WARNING: CPU: 0 PID: 55 at mm/page_alloc.c:4722
                                    __alloc_pages_slowpath
  Comm: kswapd0 Not tainted 6.19.0+ #14
  Call Trace:
   __alloc_pages_slowpath
   alloc_pages_mpol
   folio_alloc_noprof
   filemap_alloc_folio_noprof
   __filemap_get_folio
   grow_dev_folio
   grow_buffers
   __getblk_slow
   bdev_getblk
   __ext4_get_inode_loc
   ext4_get_inode_loc
   ext4_reserve_inode_write
   ext4_orphan_del
   ext4_evict_inode
   evict
   iput
   dentry_unlink_inode
   __dentry_kill
   shrink_dentry_list
   prune_dcache_sb
   super_cache_scan
   do_shrink_slab
   shrink_slab
   shrink_node
   balance_pgdat
   kswapd
   kthread
   ret_from_fork

Related: see d8b90e6387a ("ext4: add ext4_sb_bread_nofail() helper
function for ext4_free_branches()") for the same strategy applied to
the read path in ext4_free_branches().
Link: https://lore.kernel.org/all/?q=PF_MEMALLOC+nofail+ext4+iput

Acked-by: Sungwoo Kim <iam@sung-woo.kim>
Acked-by: Dave Tian <daveti@purdue.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
---
 fs/ext4/inode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3..1b2a7bd59b8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4859,6 +4859,7 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	ext4_fsblk_t		block;
 	struct blk_plug		plug;
 	int			inodes_per_block, inode_offset;
+	gfp_t			gfp;
 
 	iloc->bh = NULL;
 	if (ino < EXT4_ROOT_INO ||
@@ -4887,7 +4888,14 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	}
 	block += (inode_offset / inodes_per_block);
 
-	bh = sb_getblk(sb, block);
+	/*
+	 * No __GFP_NOFAIL: this can run from reclaim context (kswapd
+	 * shrinker -> iput -> ext4_orphan_del path) where NOFAIL trips
+	 * WARN_ON_ONCE in __alloc_pages_slowpath().
+	 */
+	gfp = mapping_gfp_constraint(sb->s_bdev->bd_mapping, ~__GFP_FS) |
+		__GFP_MOVABLE;
+	bh = sb_getblk_gfp(sb, block, gfp);
 	if (unlikely(!bh))
 		return -ENOMEM;
 	if (ext4_buffer_uptodate(bh))
@@ -4912,7 +4920,7 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 		start = inode_offset & ~(inodes_per_block - 1);
 
 		/* Is the inode bitmap in cache? */
-		bitmap_bh = sb_getblk(sb, ext4_inode_bitmap(sb, gdp));
+		bitmap_bh = sb_getblk_gfp(sb, ext4_inode_bitmap(sb, gdp), gfp);
 		if (unlikely(!bitmap_bh))
 			goto make_io;
 
-- 
2.43.0

