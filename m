Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022104.outbound.protection.outlook.com [52.101.53.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA03612DB;
	Sun, 12 Jul 2026 16:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875458; cv=fail; b=RodMLc9SLbp8yUu2i+dx6cxa5St7o/zYJ1Qo2aQP/Ry1L1z7D8hneKEPydm5D4qPnwJ2Myh7zNTR5mTAGa6TI6TXi8U6oW4E1VvU2zZoEIxP0jmif90pbyLTwxZCDBFXd+ZkFQcSv44kAf+Zq+R7hE4cKD/DSJfezbcHHA/TTiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875458; c=relaxed/simple;
	bh=U6+Hhpi/YpCgU7Len+8w1PfEFh5y9hJULQS8GBjSb78=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WwYXNnxhJAMVAYCpG217SQkBLotNLf+f34ycKBnzIVfzqLTQHFBuNfEEGN2Xoyqnv5f16+NgCH98EdpTJT/9l2TDIRG2cd/59b+3my9KBgopx6Q9RPN/W9vL6UfGfyCxZzmwRpciZ13vuIV72hes2gOaFl1cYfHWcmwchZVHx64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=HTV/Nf9+; arc=fail smtp.client-ip=52.101.53.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="HTV/Nf9+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pMaBmEGwCgVAtQ0XL8nSs4olORpkR9R9IGzJFpuygbrFB4yONHUme1vynGAqJhtKidJg3gffU4Y+jBvRjJleQ6yRDSBJl9OwL9tl636NNHF8/BBSru1J5E2CMPCcUa8E6PKy29XjAA4K1i08+mgpmm/ag5Wuwiy2ZWNS5toRnK5hSGVUZIJx01Wg1Os5yzmHznfD1C9+XmqDCrUjZ3Qc5YMz89ExmusX1ZAo5ZikqnTHBdc3tvScUrvJ7DfFQQhjmB6QI+zvEyIQRXMqGHLtGr6qumef/NgtuKrAm++aUOAvE2HIp4B0Gn37WSvyQUwkxBlybG9jfJYscFm8Xk3lVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9JQuet7vaDV1mLmEnGfls18Gbv+0ndrgVNngdlwJHw=;
 b=N55feJACRWFrKIx3GV5V2LURQ43QqQnAvokIdtSrA9eQF5two/XIIDZl7OD1KFi20Cl46kX5m98oQpgfcidz8RkSMxNA66jnd2A2iIRYCaAOWnLzEfZIwErKde+TDbq3Xbx8t3+HCHAVT/6uEUgeg5HxFHu/JfnGdpm+O1rMouqNgpFdLg+Gf1Emor9npJtnWCw0HyOWBqOFhK6N7C9btCpUTNduJueP7m/efCYKyzL2h1fDkW0qhE0vCUt0ZiKrsJyBKnL2IbAXyYrRaxmGwBxXGEd0lHM71uyBhUtnisf0AQ1wnB8ING7NfBurlCh2ReQZp/XGM+h6UMjITJiJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9JQuet7vaDV1mLmEnGfls18Gbv+0ndrgVNngdlwJHw=;
 b=HTV/Nf9+nE0NmDxp7QHHql+lr9s5QjD0hVHbXImEBL3cOVUzlppNTXjfdKC4jQaS9VEV67DQGD4V2j9EDLYFQTHxOf+4TW2NLBknHcZJdBpl/RCHs4f7LMeDGrZIl90BUiyJOX0eEGWkw+gDIJhrVtoBSihhTyuqqaNqpbf+5GtZKSvj0ta0GsAO2etBtXxfHBFirmA4xqK8eTDfMTrv4jM1FZ9MtcYNUNJp6ITP3DRzrHrxYJ2f9aWYjRnEd907TT4mLblOnbeZe5mGddz7YJxdWEkN0rlV8XfjfGXmjt+uo8auxDRjq+b1kk4NOlAUWGNPXSNsHjQBMv0FukPL2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:24 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:24 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 8/9] ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
Date: Sun, 12 Jul 2026 12:56:09 -0400
Message-Id: <20260712165610.366474-9-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260712165610.366474-1-timday@thelustrecollective.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b4f6fa1-9f3a-4b32-b5b6-08dee036a5c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	UtgZYEW1lMNtbtlGs/mdPBfuCvZ/NeEG0jgyJAVV1HKzVb7LMyOLdpTA8VO0Rg2fQPWGGLvxSDHyXm2BnpbbHfEk+5zvUDodZlMqfeL3PJoaVHX9TC8xV3es1mRTz+NVQuMhe5paXq3pyJzRoE/9I5Zu91KnH5czUb0RCzzLFhQwRIGZACW73/ajIGqAIvgONyXj4XbiIgVvxm3gyD6NGF3JzWLacsIeLBHHcUxx0iZFlFhNqPZTR6dvzYHztlOllesS0wJGbq7e5EMLerN6U2xNxNPhCNaJgi7NtvHVhGaUgTx1OSgfgc+ngZTcdvCdfiyiwlhHXDQrC+1vGrsGPTvpNhlru5kt04dmnWd/LH7q38QGoLnqP+1s5kdlFHPF+QRMqf12Ffqa7rUENiy1u9kF5cG2MRU0sVhGVx73ZhNjJCcOnb9J6YnIZ4GKXOor7XKg0M244aRZt/iwA8Xgn3SC+G1EJ/QFGLG21UV+8a1xh2wRK+ZL5HKPc9cTOGlqN5XT1nZF7PKd9rY0usYDgirUWc9gVNe0zcPJ9dwAHLKVwTa/zBMXe3J4JwPZWEuW2awHGHsupZNvEJu6dmZkpQxX2EIccV+KxRoedd5cxuMgkM/WC7vfnirMuwQ/+FT2uQIBNImgUDziqpJjvqZMr56hsvcys1dNpczNeWPp0Wk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6M0ViT/Be0/volUC6F4L8kv7BhAtXAjjMFicQUDPAKQs54Jk407Q0+e/Uf8t?=
 =?us-ascii?Q?RsdLHkfT97+L8HwKQvw2SsmSN53EbcetH8rcjzEKo2+XJ+Xu/dfiVIqmFbmf?=
 =?us-ascii?Q?kHNZbsJc1vsnJgGxpC+jyTP9tV3za+Ev8lOrssqBciJMQW4aJiAEZF60+ajV?=
 =?us-ascii?Q?wo50KGy4uOuKIWIjdJzoe+sXLtka3mdmZ5/kSN2PWE20gUpHkYY/8DHU0Mdw?=
 =?us-ascii?Q?jGgcZyHL6TYIk9YlYt3BacgQ0MbKLiRieifXMM2HGZtmG2Fbsv5mclxI9wWX?=
 =?us-ascii?Q?yh7Ynr4aMRXEVk5+y6kOvvXVrdGyIrMOB83LEkwNxsxH9b/2vxWCzXV3R/DE?=
 =?us-ascii?Q?0oJNUpv0h1nHZvTTKI35IQXkkOZO6N2MTZaTwLufuxFm0DWELbnJTsIHhQBs?=
 =?us-ascii?Q?iVEIx+iHifscUAnzoB7Iqecr6ZLvzXh9Cw/i1E3F3wu1L8ZDJ6h83HMS+1et?=
 =?us-ascii?Q?F0DH4qNgvRyCESyI2QN4M7yuRr+FboBZI17328rO2JVVTtQO1ns8XyvKaG1l?=
 =?us-ascii?Q?UlX0MQ+HaSp+uyQlOcWXBRGUvDNNhQ1buit0wGWCYnAuDqLqtREoyFmEDX0K?=
 =?us-ascii?Q?JRu+8PsknY0LU8bRW02tkQ+naXdDAROKjzBAviaCC8yYT9Enx7ENL5dAeFYi?=
 =?us-ascii?Q?IaDB0hKPSO5uI2hb/5jP2K91uRvnaJYwKHHzAjNsINUtYQQa+KNJtendBB4P?=
 =?us-ascii?Q?qW0MTBjw7NqO1yi/mSsUjQigYOlxi9ksnGE2F3DwfEoosgUJ767BTn965XXy?=
 =?us-ascii?Q?pZms6eikibWFdFsgitlUgOG39v9h4jY/jBwZxiWD/9gcRCxDPI6tUVN9BhzB?=
 =?us-ascii?Q?5iynTD/hmavC29vWBHEpsLaW757bNtr1Ei6rvweyztqpu9dKXMbw+Rt6vruZ?=
 =?us-ascii?Q?pfStBwoszN3YxWf+KfSdEQxQiwMMmDrSL1Ri7jfe3PBRmqj4Wyg7opKcFrQO?=
 =?us-ascii?Q?sFiHFS80ZoCi+dhWKAHLaM6lBeqvcqb9LGkEkLvC4r9IfY8+sxMvidvXHbLn?=
 =?us-ascii?Q?8LykL+0NIF0nbEj1DFQzPTghMvglcn+ZAMDdqNtA50j9zup2R+U77TQ+PM3t?=
 =?us-ascii?Q?yiC/kiWOfYw5PRong8U8939jI7qs6Id3RBKkAj2PFzCAlJ2fQB1dJmTYIKVq?=
 =?us-ascii?Q?6Enm9zN0MgSjZ3MOsNaFyQQvA6GXe2rPTPMwJAwbhytCLZxppI5ucJhqx5G6?=
 =?us-ascii?Q?8Is8Ok3XQKEJr8f7GrsBimgNZRyWvtxGNLlEPdHFsQpF8YES9/3xoPvjxdk2?=
 =?us-ascii?Q?KC3pqnRq1vDi/7OooaSgA4RrRacCRJbpn+EkpmhllJfOairXq3uCHUnycfV9?=
 =?us-ascii?Q?KN6QYJGxyMBhtjxYrLfxq71Ih7wrDFDI9IG4u3yo1did4E2lkBTTOv4XVAcz?=
 =?us-ascii?Q?k1WC6WQwWHSk7rCBbd0J/cwrwQTILTNuv7qGJDYkyxrqEl9SSeymQnAEuHXB?=
 =?us-ascii?Q?D69oPw6eO/qF5ZlBsSZJBUlQdG0eDsMn/rTAY63/4PpyRX1s7Thgp6XHZJ2E?=
 =?us-ascii?Q?lvEcbhm45iXxFPA5c3Fty+mrwlYEh3aK1Dy/AVPqN3QwRfu9PBRwR5QFVarU?=
 =?us-ascii?Q?MMKHUsiGelBsK5uCImhCVbfejHOq2JFunxJX+1GGVgVte0LQ8l1dxpDS4oS3?=
 =?us-ascii?Q?TyPt7Om9/WppqvipnBpadf03es264OmDIj+sQHD7ZDiNFQAXHSgTDN6rlq+P?=
 =?us-ascii?Q?4bFyjAqozKp/PVqwhAXBPGIlHssZBUC3hDyWGkIRI97rUcKEYFEFl5QvYvYS?=
 =?us-ascii?Q?MWtmXerUMYD4N5cjIPgl9afXAVgxYHc=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b4f6fa1-9f3a-4b32-b5b6-08dee036a5c7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:24.8343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUDfOzBvdEq2HXw/dBeFDDndL25q+ZBtIQpHApa07pGyzG7Q6a8rYUZ3YIGUiEwREgCxNVqpZPiqScWJHH3jcRJhT1fCGj808QUwUTFy2mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

The per-filesystem reservation window rb-tree (s_rsv_window_root) is
protected by s_rsv_window_lock. Mark the s_rsv_window_root field
with __guarded_by() for Clang's context analysis.

The helpers (ext2_rsv_window_add, rsv_window_remove, and
find_next_reservable_window) that mutate or walk the tree are all
called with the s_rsv_window_lock held. Annotate these helpers
with __must_hold().

The accesses in ext2_fill_super() are before the superblock is live.
Since no concurrent access should be possible, s_rsv_window_lock
is not taken. Hence, wrap these accesses in context_unsafe().

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/balloc.c | 3 +++
 fs/ext2/ext2.h   | 5 +++--
 fs/ext2/super.c  | 6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 53c91cb38bdee..80acc1e193871 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -334,6 +334,7 @@ search_reserve_window(struct rb_root *root, ext2_fsblk_t goal)
  */
 void ext2_rsv_window_add(struct super_block *sb,
 		    struct ext2_reserve_window_node *rsv)
+	__must_hold(&EXT2_SB(sb)->s_rsv_window_lock)
 {
 	struct rb_root *root = &EXT2_SB(sb)->s_rsv_window_root;
 	struct rb_node *node = &rsv->rsv_node;
@@ -373,6 +374,7 @@ void ext2_rsv_window_add(struct super_block *sb,
  */
 static void rsv_window_remove(struct super_block *sb,
 			      struct ext2_reserve_window_node *rsv)
+	__must_hold(&EXT2_SB(sb)->s_rsv_window_lock)
 {
 	rsv->rsv_start = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
 	rsv->rsv_end = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
@@ -759,6 +761,7 @@ static int find_next_reservable_window(
 				struct super_block * sb,
 				ext2_fsblk_t start_block,
 				ext2_fsblk_t last_block)
+	__must_hold(&EXT2_SB(sb)->s_rsv_window_lock)
 {
 	struct rb_node *next;
 	struct ext2_reserve_window_node *rsv, *prev;
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index b6ae29b2e6ec1..404f4223a6bdc 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -102,7 +102,7 @@ struct ext2_sb_info {
 	struct blockgroup_lock *s_blockgroup_lock;
 	/* root of the per fs reservation window tree */
 	spinlock_t s_rsv_window_lock;
-	struct rb_root s_rsv_window_root;
+	struct rb_root s_rsv_window_root __guarded_by(&s_rsv_window_lock);
 	struct ext2_reserve_window_node s_rsv_window_head;
 	/*
 	 * s_lock protects against concurrent modifications of s_mount_state,
@@ -712,7 +712,8 @@ extern void ext2_discard_reservation (struct inode *);
 extern int ext2_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext2_init_block_alloc_info(struct inode *inode)
 	__must_hold(&EXT2_I(inode)->truncate_mutex);
-extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_window_node *rsv);
+extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_window_node *rsv)
+	__must_hold(&EXT2_SB(sb)->s_rsv_window_lock);
 
 /* dir.c */
 int ext2_add_link(struct dentry *, struct inode *);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index a5a5285dd5784..693e59c1aba5a 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1135,7 +1135,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	/* per filesystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
-	sbi->s_rsv_window_root = RB_ROOT;
+	/* concurrent access is not possible before the mount completes */
+	context_unsafe(sbi->s_rsv_window_root = RB_ROOT);
 	/*
 	 * Add a single, static dummy reservation to the start of the
 	 * reservation window list --- it gives us a placeholder for
@@ -1146,7 +1147,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	sbi->s_rsv_window_head.rsv_end = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
 	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
 	sbi->s_rsv_window_head.rsv_goal_size = 0;
-	ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
+	/* concurrent access is not possible before the mount completes */
+	context_unsafe(ext2_rsv_window_add(sb, &sbi->s_rsv_window_head));
 
 	err = percpu_counter_init(&sbi->s_freeblocks_counter,
 				ext2_count_free_blocks(sb), GFP_KERNEL);
-- 
2.39.5

