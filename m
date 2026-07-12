Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE37C364EAF;
	Sun, 12 Jul 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875453; cv=fail; b=oZnLVZecT0tKgVocW8yLh5cuUrUODt9RQ/2zpoHTWUNZ5iNf7wNhwHG4iCeQ6ig21uddRCamYvK68OSzqifa2yvmU+318itWFU9GD0sJXcIj5s1pn0lidEwGUS3LvSYVWhoSIJ5xT77vUsjBMGcu7Jgd7Z0SPnIM7P2CVqwX4kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875453; c=relaxed/simple;
	bh=gTEgyssGU1YZKZolRKsRaFR6dfnIJ0LOxscLaIcyMks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qmc4e89C1LtGEhfPrPnwCXebnChH2oNpl+5n15xiXk0xW53Pf3S+UOiEueNd33Rydul4+cYst7nHSduH/KNWQnNhySxkcVxzAbBQjjjHWO0VV61ngM4b8Er9bODv3MgiT4Qz+xDZFJqVDGod9dxeTzcO+PBZ9jIXp+InaW0eH68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=b3dOx+eM; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="b3dOx+eM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ro1ATN9KhelJc2PDC4+yP73a1Y6YuNmP1UMY3tRZhlRMZ+8KEf6O6iFmPEJbp54zhAaQV0h11AVYQDKZ3hlRdyfj+/a2MTE0Qfr7reOXUTcaQjzx98NLRxNZW1yxZEp3i2rS+fujemmrSpIwY9W4YqU+sy5sVssH8XiugFc9/VQKoTfIxdcpv7s2rfxIW2v9lve0t06UtjD6NbsLuLpXKaWEzrZ+nzV3tFrqxWkzE8leJ7CBH3IB7FW+sX8iJzQ9L/RQIn/kxoE6dni49m0IHWhay1HCAcu9HFdsoMM3LE/6+rHEdgiYRPTXR5P//tmDm3ZdkInFC0J7ZuU5gKVGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqhEkUqc7jFgo+k2AjYjr4WS57UmPfkUGmjSg7HOcTc=;
 b=L/A+olGjvE1rXL1IPoL6wVNArcP67NqMJYZdWvmHs2XbnWM4kXPT3iE3pwmPv6hnPekNbG/nWE5vKTiXMjjaCbL5zpopoePloSAk44ctNcE7+eJmeVmNVQ3goWi5XBi2L+mnUJIJO9mX4pVsBqlwk4JF8eOe6RhOK7lvVVGBSL2yaiHF5fu2peEC9q7U3RI1QKvAjs4qk5sgpN1ZVw/vRcWnPXHhUjIWUHtyYrCtEeosM8lFXZRp9HnBYTk9kWKMKycGtGE4eJzRYHd+v4jTEM634h7lxDvTFuPT1Wsj6pTYnBEQIy8tLfqf4cZuE+zQm4nK2kPiA8lvFGgNoAalkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqhEkUqc7jFgo+k2AjYjr4WS57UmPfkUGmjSg7HOcTc=;
 b=b3dOx+eMDFpPZAAbuBsUb1zPRkKzD4L/4zNwx9/zMW5JfD27ANoRduwkrG/z3hPtn4xEc1eBvMxbAqqjWAH5S3nDhxV4NaBO44waozfuO0qr5FSmZJtRsszq4G0NR9+0/sO66LZ4SQZ7WQWeJsJSQTe0tInXWEET7RL71fMh/s7W9K7nGOJjwTo8Ns3RXnTibLFqKaFa3U4w2IlO/kbbYlHgVg5NQgGvdx00UKLEYgxR8aeeBGfU4/3h25wZV10UfM5v6Nw36KuIniEwrr6MbJzKfYO09yFmdcVP3k8RncDBUpEK7/DtaFcnv/5Vubk4YW1my67h1BlL3pHup7oXmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:22 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:22 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 5/9] ext2: mark s_mount_state as guarded by s_lock
Date: Sun, 12 Jul 2026 12:56:06 -0400
Message-Id: <20260712165610.366474-6-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: dce41c4a-3d29-4d85-27ef-08dee036a45c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rzVa/FCs+BDhGZsLFi2OEh9QKce+fp0/a/bmrgYIxiat6HRMQ2mQg8ciCzEqW60U5p/m0DRZvSR7ozd2JOyH2cS05zxI/NqXBRG/l97g8k00DCRxAsByi2wU783RxMwcKyYRASubsFIJ3P5v/9NFmqStTpaZlDAvuCOQErGWVyVJOFLOiveL++DCBSKvHtddTh8FE9GKkyaZEkl89V82LhIYfqK1Bgau2zDlOtxVJ/3En21uVEo+SP0zz2nJ8WcmapJtKN1jyl4k413iEXXv5nZZxYWO8UstX0a9agFLF2gxSMmyRtX0ExHjA+yBp2Kb5VqPTgXnAPW4+VLUhImPt5twY6xuIiyAtHxX9SqF3w2tqG//bee8X+io8EGq2cOT5lngBbwrQ2ODpL3tWmae2N8aLLxLNWma1YLAPX+JplUJo5wgGq7zyguQqsPIiFxFYUILAtSB+uCN6W+h7V4OpMTJohGP4mfubG3yGpV662SeUwEvxi6xDDMHyuprpwlfvXkT23I7jJlruAjcf4h6bFHOzOK1H04cyhbn7b/0A1+pbFNu7E2EWXDam/klglF0CEsROVHZ4p5YfGEpF3DdE+dWZN1/We+xm0Hae642ES4WIr0iFoHFUTcwd8pzy1zGg/XGagUFS+kNlU2yEwD3ThEEXqE83I6zgMCDJYuwqSU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2q3PAP3usbn4mUaHfe3i3KeyR6OsPRoVwBEvTcDyL7/8dF3aICoYZNJg6YfM?=
 =?us-ascii?Q?oG2Q7+g1oCw/aqoIbi4hL/MvKix9RlK10W6mhYLT2SCKDvu4K50N8MTLYg/8?=
 =?us-ascii?Q?a3BUikWfitnFCBdOZKAIdLm5op5pFsEnHd4RndWKXsMs7IT5uBHq71SlB55l?=
 =?us-ascii?Q?xLz6MjyZUzNZi0lXf7EfXUX7SqmGWL2ca0muaeFGhn9wkzHZ5OzEeggGPwWN?=
 =?us-ascii?Q?ckXo5RLD0Su89/STeE4kf9+BSZWXxXuAh1S4vNchd3/1GwL8Z29XDkKGUswN?=
 =?us-ascii?Q?uhrIwP5/15NnPJMbTkWSzkAzUgZtyGUlOTBsJnHDO2r13u2IyZhc0sabsUFy?=
 =?us-ascii?Q?ME77wqjA+RKqImbqhaDwSvCC5UtqN4kk5TCiTm4EjVGOuBMZemICG8VB/OTN?=
 =?us-ascii?Q?8Yhg8MwX5OStru/+CLoBwK1a3xeQ+63/tVzAeMWd+Yz9dt3iRipwwoQfVYDc?=
 =?us-ascii?Q?1PViNP/ezFIC1zpwdSyoF12zJJdDaCAnP6+y2WHLi/UoBifWTFyXNQoHWD60?=
 =?us-ascii?Q?XOJ+ZoOaacsWqdVvvr0oNZ98S5dI7W459K9ZlEt+lgEp1HypgTBSvHA2M0/T?=
 =?us-ascii?Q?uFQoQGJPImwgM2Hb6uRFRlvGoJ8cnuY1Uf0Wp+zPAix5U9w6NaP3PpEZUSl5?=
 =?us-ascii?Q?TbaK9VJcG/dJeHlkRqWzNF/dh4M8XKhNiwEJIUKbrzCEg/1X7laMn/r3Cdmk?=
 =?us-ascii?Q?pLkk8ZXPpfxo0kgZZvuFqwQfoIxiwuIpoifyeDDidnuBI/XIyG82BeBYzFaP?=
 =?us-ascii?Q?/+7vQgvqPVHHXtUAZs4hQUfqyHAZXYGtg/zBBvml0OF5WcBTrxNMtpElUkZs?=
 =?us-ascii?Q?geRKXD5VLwejTIjdHxJOxcCQzeOWI69YWn2iJyq+TOrjxa0Uh4iGpMSN3y51?=
 =?us-ascii?Q?YZGsvQhN8bBt9cPlaJj1hUYJSwarqgYVLW2NeUjQlVT/TZdbj5ft6kii7k4p?=
 =?us-ascii?Q?BimocSog/6/Z1NVtuBfFLDYhTtHfYn3HkRJUWgFuII4D/FDdlmtVlhHOAbDQ?=
 =?us-ascii?Q?S/VAs24cDEZ+UkNUM9MgGqfVcRVPuAojBP+WWlzVwwC6aM0z07eqyC8pcqUU?=
 =?us-ascii?Q?jZILzLx7fBhRMZnKkVlH7s/Q2cwVZKERnGz7mTTTMvGL9bHI4puEXFvlXBOU?=
 =?us-ascii?Q?FSSjwKD/x9KdxhcDxJS1A3nBY2wKhinWUm4UKja76S5vK3H/SzIsRhvB3ylb?=
 =?us-ascii?Q?zTUqBzPmNY63fSJpoK8CEdb5PbMzWIPFv/dejdeLWs+z48Sy+cCOL70xU6HE?=
 =?us-ascii?Q?rQNmmzvtEV/dZHiuqHF5l8pUIVRTXksX9SWz0eY6HepxAvkxKn5ulmV8P8ix?=
 =?us-ascii?Q?guqgrBJxGTjGmBf62AmdRMzPg8u3TAuxg/PxByFsOy/PjON/LdupNA2VyH07?=
 =?us-ascii?Q?HDes8N2aviPGEZbYRtQVI7xLuymUsT/kt+A7lQuqRdcr18cnbpg7T6rSFgrf?=
 =?us-ascii?Q?rZJzvUcy6R+nQ7J7kEkgysHYXRkdg59VMc5WYGgQyF3PrJHD5oEzH91LxRoI?=
 =?us-ascii?Q?shvFFkaL248iq0Nf1FGSQaYvv4BRf5z5H54l2myISJoH3GlYkJGcK0oTFaoF?=
 =?us-ascii?Q?T14P5nNiaTk5wBDH9tne97jjkXIKuf4BjwzF8Tssgu3G+mq0+oqG8KuwTCDE?=
 =?us-ascii?Q?WqtRZNic2Vu83WPFFa8CmRnpNZ+59i1sTHoftkNU5m4qphZ1sD4V/s6Z0icb?=
 =?us-ascii?Q?X+P0Zo+40ui5phHdLhFSqPaRG4vEAA0bgvYOFE1OtNOctpkQSRxrKdmjmZp+?=
 =?us-ascii?Q?PnOqtx6wCKzxCVqocluPM43U8ejKl8k=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dce41c4a-3d29-4d85-27ef-08dee036a45c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:22.4699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eDW4JcX5Rh/C3gxxtNQGubxrTW7w6YN/oScaQn5EO6Dev7UMlKcvsdprODianoNd/e7GkMzQ2UfqpfFf+EPusKiZlhSkt00Df2EffCc6ewo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

s_mount_state tracks the filesystem's mount/error state and is protected
by s_lock everywhere it is accessed. Annotate it with __guarded_by() for
Clang's context analysis.

ext2_setup_super() reads s_mount_state and is called with s_lock held
from the remount path, so annotate it with __must_hold().

There are two accesses (the initial read in ext2_fill_super() and the
setup_super() call) in the mount flow. This is before the superblock
is live, so no concurrent access should be possible. Since the s_lock
isn't being taken in this case, wrap them in context_unsafe().

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h  | 2 +-
 fs/ext2/super.c | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index ecca898653eb8..4c30d6f5c9726 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -86,7 +86,7 @@ struct ext2_sb_info {
 	unsigned long s_sb_block;
 	kuid_t s_resuid;
 	kgid_t s_resgid;
-	unsigned short s_mount_state;
+	unsigned short s_mount_state __guarded_by(&s_lock);
 	unsigned short s_pad;
 	int s_addr_per_block_bits;
 	int s_desc_per_block_bits;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index f742b9b6b017a..a5a5285dd5784 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -633,6 +633,7 @@ static int ext2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 static int ext2_setup_super (struct super_block * sb,
 			      struct ext2_super_block * es,
 			      int read_only)
+	__must_hold(&EXT2_SB(sb)->s_lock)
 {
 	int res = 0;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
@@ -1035,7 +1036,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	sbi->s_desc_per_block = sb->s_blocksize /
 					sizeof (struct ext2_group_desc);
 	sbi->s_sbh = bh;
-	sbi->s_mount_state = le16_to_cpu(es->s_state);
+	/* concurrent access is not possible before the mount completes */
+	context_unsafe(sbi->s_mount_state = le16_to_cpu(es->s_state));
 	sbi->s_addr_per_block_bits =
 		ilog2 (EXT2_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits =
@@ -1203,7 +1205,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (EXT2_HAS_COMPAT_FEATURE(sb, EXT3_FEATURE_COMPAT_HAS_JOURNAL))
 		ext2_msg(sb, KERN_WARNING,
 			"warning: mounting ext3 filesystem as ext2");
-	if (ext2_setup_super (sb, es, sb_rdonly(sb)))
+	/* concurrent access is not possible before the mount completes */
+	if (context_unsafe(ext2_setup_super(sb, es, sb_rdonly(sb))))
 		sb->s_flags |= SB_RDONLY;
 	ext2_write_super(sb);
 	return 0;
-- 
2.39.5

