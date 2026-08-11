Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020104.outbound.protection.outlook.com [52.101.56.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0857D3BE62A;
	Tue, 11 Aug 2026 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464254; cv=fail; b=TgTZv8VZzXOJj0/dCmrdI1xjn+EAv8aq5CHn7wdHrkEI1NmYgXISuoifSQTarHe4wXXf29CYUIwmGLPorqyYYQZcfJ14dJQdkrrR7qt1RBE6YIJ5Q68pfUi+8ChKvqwt3TkuFO/I+nGbP+HnstSqyLxChdhs6au4fXTAQHs25j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464254; c=relaxed/simple;
	bh=/DWLHtUsN0/cwJ1DVJQtKZuisOJ0dF5JuLfO2XC+bnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Be/Ixa6rTfywCCxQv7dJXkjJeTKGZnFfphVu1VZxLzAFttdhM/E+lo9wDAt1re1gBWYrjPrDOFnXGxxD6dICJEA5e3qW+rGeTp7de8dKiOJZOKAl+WzFX0EGk9CZ8mxzRcYNrRYs4fLxWc8hCvXl1YjpN9qh9CS8t7PV/vuflFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=RzBG45x7; arc=fail smtp.client-ip=52.101.56.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="RzBG45x7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aLMxfbOGM65vIgeC17HM3CI0JfqQM4moM6TdU243nJhmKvZ+F3kZNw1NOdo6zbmCBm4dbI6TJcNZW02Qc3INimdsJwOlrfrm7QrXATVf4e6fAlCKBFId/EL8TJ2wp6QGgnAVg20itYLaHQCi3d1nY4ZgtzK8rGg1TKO2O/iw93Qp6+ZA34/AyibGOt2a5xTn8QBbx9l0utxH1qTX74YTSN9FjDVHCPiz3W3ADdH0FyUEUPeOktGF4i6uPDlFWnQz/wf93IeC2IPBfKwzFgp7PdwnuLsBA7RD2xkPHCKsP9+9yDZm6Yb3zt3lp8lnFrQ+6aAXLVTlr4m6PUHUfxCm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiGmgEa/mNJP8olaGmSmcQP1+QOFhR0a4Ax6vqwjsOU=;
 b=oM+94DGcbP3OzEIiESOUix5okWv7+EC9e9Td/ci2GV+3NsFkSR7SI7IZfoU6P/VUGKQXpsQbYV5JbRCi/iS8BcTKzimAhQVx2JQ9TUBRI/qRW/1R0dqLrc9QVMIh56xKJ+GV1wdYN/z6GwM6lSK6g8lCwJDM0pkNa2VVsN8O+dP9CcP2xf1TZuGoyaEGhBWrZcIpQm8riAhE9LK6ePRWDSHHD/cxSdLwycbDG0kA8Ek3n4ERBKZAjGmrwP2ZjCOzUEsXA4X/nK/3iD9PcjhA3lkn85/hdAjfb0LRJ889MZtIDA37CGT+RGXybGCY6gvlNKE05aFUAw+YHmldfC6/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiGmgEa/mNJP8olaGmSmcQP1+QOFhR0a4Ax6vqwjsOU=;
 b=RzBG45x7e7LZ2gqDR/NpmhE1wP7tkjmlwZejU0oN+QqDcLG5rKEOCHSMaYFOynVYBTaXVKqclh40lFmegURffw8h34i+clV5c5jbn0vK6FHoCnuEyjn2lJxFr0sTKjllh8wRTQb1GKmVCLLdU09xAFFQ+s/gZsViejjfVD57iTBUfXAyn/HbjHjJaI15ci0drW8hC+d9UUhdSjwFC1GBQknQYh1pbmJOxDrtEufvuveeqUp4Vy5LmSVKrsWP1ROwBXy2CwZeZCbzwkgi3wn9iZmLb84mVd1Gfq3kSCucdQS+uaX5CV9ATuDQJEhzPP2uzsX1sRA6ByaXDH5HVB3pMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB8258.namprd04.prod.outlook.com (2603:10b6:a03:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 16:04:09 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:07 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 7/8] ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
Date: Tue, 11 Aug 2026 12:03:35 -0400
Message-ID: <20260811160336.782342-8-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811160336.782342-1-timday@thelustrecollective.com>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::19) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB8258:EE_
X-MS-Office365-Filtering-Correlation-Id: 14abcb37-79ec-4be3-f919-08def7c22b60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	zE4jT0aP8A30u3BT/bMkrNDVOI1lgn3zdddBul7vnQRXRt26qXoGu7wKxhLx7tq3eAEBCEEJZWgrfp0dB5yxF4uaJBwyN6k4/uW9qNR5pCv/8L66Jym/7nPBrLbrYPeC5cPrSCQ5EO2Ag/4r/O8KW3tN3eynk9FgDo6OPGePigfallXZRJG9KgiIqyItsDwNbY/s2sdhNcW9SEu5FZY6R61pPMJqAJQnt+DI0USMJXJHdeaSYNecoYMH1z731vyyhIolMMEdKcAVrBBPKlS9W/qKZDLMehSewWNtw4PmxX4i5C/Awst3kDpbwOWu/Epkvt1gGkysRTc8Q1UMixlGYOu+96RcUNuMokXTzLPUtq+QSlHcyoNhjGvAPxmVrabs1bXScOZ9C7mNx/VnNvGYdYwT+P0Aiv4WozO1hGmj4rnfLlazWqFDGka1EKXBAwtBpr1Upil2HO8BMWarAz9HAqco7Zh17RgXvm07XFcPOAaF/K9msH4tgUCNcRzu12CvgMnygqAY48rOahCQw5+xSkYUxNNNPRFop7JaEufL3ZO4p8dRQSXg7yGSCpfR1c8PYF8Qte48vIQhQ8e6o4bw01T9U2blg0Tn54ExVRnf36jKPzpMkcSjX3KFALwJrQu5nQkNYKdcPsc/I9RsoH6TPLt5cywIJOmkzH54Dn4jagU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JkI05RGQk0USFjw4JzDhZZSgIg9rUUOc0hYKvwEqCLVLJOiENgqrouyTldkj?=
 =?us-ascii?Q?7zyWW/JvhyMQp6JlN+HCAgWWxj7WML0fQzjYsMN/QbL/9copcQlfOQ5eBnu3?=
 =?us-ascii?Q?YP4iQ4j90mIZJSCkP7S1K0HX80eYR+2zDkx2R1ZmOIH6zQH3QvxcvMOWBilA?=
 =?us-ascii?Q?DlP5Alz2MxAI+1U3+EyBgfxkUd1TNqxGC1jQWttVaLq4CR7zL0wAtul37NG2?=
 =?us-ascii?Q?XFca9BGs56y8INVZPFyeHkEq5hErHCxEF4bdCHVHUluku+5pfBgmRYzWR8pU?=
 =?us-ascii?Q?HtsM+Vh4jwH0TRT4FuoJIuMswsfvyul/zLlPYcGQLStaIYyf/a/C0qkXNECW?=
 =?us-ascii?Q?2ISH2ztl3okDLqhAGSPPHpy6hgOdIcf1nIruq3cX83m0U4o+mOaLNjKAqbbb?=
 =?us-ascii?Q?ztsGs6WeAFkhspNjLC38G6zrqgeZUpQDFIkDYpUNZJEzPoqlX5k/UhqtMW6e?=
 =?us-ascii?Q?JNkk/kUD1i36Ew056FV6suBHFZc19YkLgJog9DHwy3g9VMkCyuVHJoh67N3v?=
 =?us-ascii?Q?hD5HTc/Nz1680uy1riKvdynjV4LDFHng5NEd2qnJt2SM33ayU3HBbHuWDRDH?=
 =?us-ascii?Q?TIHWSFimG0Ni+beAncImHi+MyByrSXv/CPCUhdT9vW5yL3ZsukWXm2fG9nYm?=
 =?us-ascii?Q?9ChMcXQ4z5FTV+0qKLAk0BGBzR99NGwvurudf9sEo/o93jzU6AGnB/wcBmlj?=
 =?us-ascii?Q?hN32GoqkTResZ7OOv711Nj6k+wk74OIjRNYQDPVLPIPCIqmdW40cVPYwJ7Fz?=
 =?us-ascii?Q?zQ/wKkxD1/d0krCwUv5Kue8bb+FYou7gP1l8YQ7S55TP6kNiM0R8FXDIUQYR?=
 =?us-ascii?Q?won1lxHwVcIgmAUYQlBUQphy//1IjbPBG9YxxDwIaCzF6YDQRUBYkex4NOVV?=
 =?us-ascii?Q?dtOYz86yeCg4is+jet42qRnz1Xkb8QVuYidE3vx4JKkV1ZKtx/M81pV1bKDg?=
 =?us-ascii?Q?FVjEHsH6nUPIMoXbv2lP6QLg2OSvlS1+s61kZvHPpJpRNNVzeIbezwE65ULG?=
 =?us-ascii?Q?w6DPY4QtBFGjZonORXOg2YgwHJbXoROPGei2i3KlEq6+Vah0FLmvxz6xALkl?=
 =?us-ascii?Q?bkDdDlzDJF8bDfZjNkwaFm2iFMTTcQ/TNVjZzziQU28rb2axjLj1uMs0w/Vv?=
 =?us-ascii?Q?XogYza87IYFBWNC+yBM1g/JLU5E5XxfH4yFEah0DC96pWGqNWduaZam2JRUb?=
 =?us-ascii?Q?pMEuuGyn6DUgzKX5ErhPRsn7iOuLHSQjwy6Zglj1Z/teyt5nLPeLXoQ4rjI7?=
 =?us-ascii?Q?Pz/O6hTVa0DsULM0LieWX2IS8esMQCxwKpwOP2AenUiucfuTdh72GWx/rqWR?=
 =?us-ascii?Q?626zHws5Uc5NVwmNlYkrNuuCvhEjGQZSUiXS8oLTNxth1ZmfSSw5hHK6GGbl?=
 =?us-ascii?Q?4SahJOfeI29yfQd04h/PIRJAG824f11s3UMutW5EKdWDlGnY66OCMEYnpQ/T?=
 =?us-ascii?Q?iRTvYs5P7zbnyMfXMQmEi2gQB3DWKsSWHGyo4wlcIjvchUCGaE+tMAni5vXr?=
 =?us-ascii?Q?rNAdo9jLY98RrSiARP4rn6wzBmUDQ9knlu+V3NY/1zHwFF0kLNHal4NWsywV?=
 =?us-ascii?Q?OQIOdbjSWpg6axo4lWZ4rUqaTFNgx8VJ3NTYyPeEF8TX5TekCZum4ywtu2de?=
 =?us-ascii?Q?egur/FlXdon97vrIscnlVV3g3owmWBWsK6BXKsF4XF60MaH85KVuYmECgUr+?=
 =?us-ascii?Q?vCCQqCRAcGSV0b2MwaIEXvLjH34RSRvy3dpSjBGbIbxNi5+/PP58E579sKAF?=
 =?us-ascii?Q?ukN8uoms6zWhkFuYdNqu/zuMnN7krQY=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14abcb37-79ec-4be3-f919-08def7c22b60
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:05.8292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWO/uad3636KeliSfcw3EnHpoXxvdYdc9ChpAaA57mOM6uPBECXaXS8ssJj6PjZZK3mi/PCwZvoZQ1U6oSLtORui8FRtm+qPq/RIV13VfVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8258

The per-filesystem reservation window rb-tree (s_rsv_window_root) is
protected by s_rsv_window_lock. Mark the s_rsv_window_root field
with __guarded_by() for Clang's context analysis.

The helpers (ext2_rsv_window_add, rsv_window_remove, and
find_next_reservable_window) that mutate or walk the tree are all
called with the s_rsv_window_lock held. Annotate these helpers
with __must_hold().

The accesses in ext2_fill_super() are before the superblock is live.
Since no concurrent access should be possible, s_rsv_window_lock
is not taken. Convert the spinlock initialization to use
scoped_guard(spinlock_init, ...) and place the writes under the
guard to prevent warnings.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/balloc.c |  3 +++
 fs/ext2/ext2.h   |  5 +++--
 fs/ext2/super.c  | 27 ++++++++++++++-------------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 53c91cb38bde..80acc1e19387 100644
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
index b6ae29b2e6ec..404f4223a6bd 100644
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
index 0fa7914e5f04..b7f042e42009 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1131,19 +1131,20 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 		sbi->s_next_generation = get_random_u32();
 
 	/* per filesystem reservation list head & lock */
-	spin_lock_init(&sbi->s_rsv_window_lock);
-	sbi->s_rsv_window_root = RB_ROOT;
-	/*
-	 * Add a single, static dummy reservation to the start of the
-	 * reservation window list --- it gives us a placeholder for
-	 * append-at-start-of-list which makes the allocation logic
-	 * _much_ simpler.
-	 */
-	sbi->s_rsv_window_head.rsv_start = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
-	sbi->s_rsv_window_head.rsv_end = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
-	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
-	sbi->s_rsv_window_head.rsv_goal_size = 0;
-	ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
+	scoped_guard(spinlock_init, &EXT2_SB(sb)->s_rsv_window_lock) {
+		sbi->s_rsv_window_root = RB_ROOT;
+		/*
+		 * Add a single, static dummy reservation to the start of the
+		 * reservation window list --- it gives us a placeholder for
+		 * append-at-start-of-list which makes the allocation logic
+		 * _much_ simpler.
+		 */
+		sbi->s_rsv_window_head.rsv_start = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
+		sbi->s_rsv_window_head.rsv_end = EXT2_RESERVE_WINDOW_NOT_ALLOCATED;
+		sbi->s_rsv_window_head.rsv_alloc_hit = 0;
+		sbi->s_rsv_window_head.rsv_goal_size = 0;
+		ext2_rsv_window_add(sb, &sbi->s_rsv_window_head);
+	}
 
 	err = percpu_counter_init(&sbi->s_freeblocks_counter,
 				ext2_count_free_blocks(sb), GFP_KERNEL);
-- 
2.43.0

