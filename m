Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022104.outbound.protection.outlook.com [52.101.53.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386D02594B9;
	Sun, 12 Jul 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875449; cv=fail; b=QEG1OHqq5jmYAzzhgh5edqLKfhcCRB2gnAcpEFp2a5CvPHW5qKduKcV21abfpQdyqoFpjfW2FekVXffLXj7+bITJNfF/Q5NgqY/mrodfxptVomnUFgnu+Q55+XZ9/cBhCspyqx20GLepPlyOyObXUJ+f6sJTdxYcXMKTzspdKzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875449; c=relaxed/simple;
	bh=ZxEryreiJnGlprW1LvgTRLUZ0wA23Lkt5geqtfD0qgY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hAhw/mzLlTSs+coFThb2/PztXA1z/nFl1p13FcH+AXm7DZZfUU7kSwjI/bky53ygIi5OKuU08vxg2oK2qx0K78ZIw92wPBw2AWEeVvsN/tMDIolCjX2cSaRz6B+MMG1E61xd3OONXpS2xjIBxRyjIRjhSHkWwlvKuXIu3swsuPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=EsWbqi+j; arc=fail smtp.client-ip=52.101.53.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="EsWbqi+j"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPfH5m6DMv3dTcz3+AsNABP57wFuNPAuqMAkGVkrvGHlIifpGXyVH6pa8Fn0WiByAud4bktsuYqFcyzUpJPEQe7No+1ZHu+FBdj/PfPQicMpAnn6u/uYushy4u0fNUWVtBly7Fo9SvY3/xPHJdpOBrDDq4qbHtRLprwHQnYJ7lPtXdin9Zc6UWb3P6xGSfOQ834eQSqouE9CBqe3nsMb7xETAu/hXWvxMwG8dUgyb7mGb4aI0mFpTphiH7GkGM/TdKWFvQC9ZhIl3q6cTHP8xUHHBHnSzmHTh9KKBnTIT/Pp57cUIssihZZqA/llQEM+j6ozZ8/tUzKSEpUDXXE+yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUoB8Su27kjC+Nur4TCWZsLjuXKfaq2oJRGECKkljKk=;
 b=nAGB7C/DRgCQP9W0Ix28bgTThUC1fy2jZFOpXtqBqOP2URUfgZSvFsQELFIHdX3Qo5rnADaaWY+guvOVoN947b2DTpVKIcsSiPZSg6Gaz2a7rGrrDeZ1akxh5SpvCOV/wbqIoZrHnzofEnI1ovMORDP1Z3KsIPk0kd2MV1PvF88I2T3LuddVEI30FiPD/8PFasxfHtNFINAFHLVxgfPtB3kSntAdwuOIJ5JX1zGE5htAajfeEQgS4dqr/21vgYchvSiHK6ELSZB/8w1V0i19cIeCQ4CGFf3leBDr/QaTXIFhQLPngpoAPFPHeTqHz2zwIkZ0mCtXggfwu423AXeq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUoB8Su27kjC+Nur4TCWZsLjuXKfaq2oJRGECKkljKk=;
 b=EsWbqi+jjzrLtQ5oJIJ18zohCuv00MeIjLM8PIf57GoJu+dUOs97Zyu0Nz22w1ryW0QqjT9E9Fyf7aANhVPe9w6wJl9UQesPCx0HON5/l73WAmKeX76JHiERsQOGCOCKtkpg94CjCMdkZmfDwnWuN3riSClqXu2ydM7z66DMeS81uobnfYKAh2shjxbt3+IFWPC5XBJ1qgVtWyO1O1CMZxBZv6h9J7f6zSNvecquz02XRkyEvV5jRdz4biMDSr5f3OPRmk+2eEy68RN4XV38gP39XMonFf8thZDviUVqlqXdghYttlOB6YwUWNbbMH0WMO60zWL4ZonUXsLMYqk+iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:20 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:20 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 2/9] ext2: mark s_next_generation as guarded by s_next_gen_lock
Date: Sun, 12 Jul 2026 12:56:03 -0400
Message-Id: <20260712165610.366474-3-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1f67b0f0-72db-41a0-a8a4-08dee036a320
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	E9dUw4UIqWzVFE+8on81wUc7m6OwLH//S5RmWxHlnbOV6umUjPFou/72wsa/YNHlmBjTP+VQceYmPkXjrZR78eIRYoFZT96RXZcrYH50fxGAbWumJ6tLoFhLzIpUD+f/7J/Dvk1h29agoEuQA2TqRHsv54HnD7YvFmzb8a2D2bn9CmnR62E9otepJgOgZKhkabZVPmQwFTykVMvGmuw/Id0M+TU9+gzDQuWPLMHNgMVj8t9WfmUl56wrk75wwVPbDFBjHuMfs0vFw+8Sq26TB4FO8eAI7eJ1FLqmoTf14H2SOO+qcIUPMsAyz36yqeZSDgoLrUQA+yewZXuxXqHUJdNkRYIHcmA049p/qia6CFlEAv5aD9M1jTif5Qawkf6+lzfsIIzWtPDEwWdOG9/9i2kL368TPFJM9CU8psR4lnMpuiPdCIrgFdR32QqJB6SvLemOC6/BuojKwwU8EAAAtukGXIQeQJz47Ft9JzBT3EdWaEr/dG95df17GGlUTLiOQUI5Cc+HmLaxzK9y0tj4C5dkK36LflNUogsR0uI26DFVNj//hhIuvBxMNwNtoby/tjU7dQJmzanNVFJzMOXJhc2ykyiNtOGTuP7DFq39EzTvousDjRno9kdgCKrEiWNn/ER5zJXHWQUZ39ub5yJXcjVUsWC0KQUharLwg4ZWU34=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F2MzTblItKhDNrgSwn/fDb9qDGKsyTSh9xiWJU+vcQOc2/1x4Xo8SwBrt4Qb?=
 =?us-ascii?Q?hYaUQ1INZ7+xFGfArNIT+rOSnV0LKx/4jnfd9cdIdnqxBl9Hn2dWggTYz0iR?=
 =?us-ascii?Q?Dhezn+TnYCSC0l9HSGlVzcidyBrmjdN9KBVpg6Tk0+CH1R21r3G8k2J4nGqf?=
 =?us-ascii?Q?2OtHAvpr5IoJVEgjTscihI9DE+hMdD/HRwp1HZEDb+UtxxvnWZGlIkbgiZ29?=
 =?us-ascii?Q?loMo5x1UcK1IX8cb71rhZXH3hmLd02rdC6LzgR3XV5sR6rn+lmQn6c32yw2C?=
 =?us-ascii?Q?nbNdZuhTfC7TrMQZvvUH9NqnqgyUpfrdobKyKwo8Lb1f/tAB5nkc8g6THK+S?=
 =?us-ascii?Q?hURCjeyUYalQkc8NQ1V62SBLaQlhG5OfLra1VBe48XjaqbzUpCnvIeyPFESl?=
 =?us-ascii?Q?2lzRtHVEK6Ye7q0ecnY+xCBPesYay7VAM9eik1Ezl1exco5Do4IoKvRwAfHc?=
 =?us-ascii?Q?/XuXCgNanlNC0iQUGDjn53/awAG6+3i7WrraRXLHOhevt0efcCqUzqhPFJQo?=
 =?us-ascii?Q?D/FPFR+wLF6nBNchWVPgb/WxrC3raKKMH65vNI9goEu9sZzX3SlvMWYi0d2c?=
 =?us-ascii?Q?aNO7NM9slzDkkdbn5nDQ4EI158fx3mJY/vvlKtDMOM15hbGCDQrjYUOZb0wv?=
 =?us-ascii?Q?JD5FcFkTc4Shv3PWXJSHb1LUAsTniAAlUwxgflYAGU4yeWeK59Mai8BDJWpR?=
 =?us-ascii?Q?AgbiNEzCBWB352E8jq8PL27Df4jirdGGcEMJ5cY1YNqK7TA+OkGfeXNLwJRf?=
 =?us-ascii?Q?iCZmJ7XxlSs0RKJGhJkaEqduwQ2/HwU1pDjHRMC4r7Xom50EAdYvv4kgFM/r?=
 =?us-ascii?Q?DkZ9olXCP4GBEtCevInOyXtkWafS33YLV2xxgkHPdUzn5X4gvObYjqwf2jYm?=
 =?us-ascii?Q?xkG4kgXmwQmq5QQW9rbkQoUVvWiOfRpkJPYsk8q0HCt+17V2azw3feS2ssyX?=
 =?us-ascii?Q?NLT64/pCbBXqVwsZwBkKdzeZRUxlB/ROKm/LpCL/aH0u5H5uCrwvV2jok6fA?=
 =?us-ascii?Q?5nsfd4PvYTEaN/Nt0NDqtvCzqAo2yk5jmEDfkBHgDBpXlckv8oMQR0NX5p2i?=
 =?us-ascii?Q?GwIdIYLZO6OdqXU8HlB/p49Y3V5n28WNQyR+LkNR5hb7R+OnN8a8yKpuE8++?=
 =?us-ascii?Q?MNjv22b4tiNXWpp98/bg46evWNYKeqbZgcCxZINiPPNbe3c2gjthQsYuNATs?=
 =?us-ascii?Q?ESIkqd87e+5pa17dcmyFaIG8JhCENtsu6UogPcV0nncbWoQQg//9+SEHmDZl?=
 =?us-ascii?Q?ozw3PbuiA46gpp+slwThk/9OCzxXKHKBwH0J/dEbzgSJegMsTo/p+GR6bQ+W?=
 =?us-ascii?Q?14WD4KR+b50RLAm7ADh+uhgL6j0HgBBvHB0PCjPZw++4Z1WgMETGCe6BvuVO?=
 =?us-ascii?Q?jbsipGr3vmCnCPWofOVOL/sz+LSqU4TE0YQOydjQcE3hrs/ZX1bbQO8KnMHy?=
 =?us-ascii?Q?VcxAFWk8vRZn0MsNWvkH3qoo1MoiTZ0hEky9aEskRdww6/Rm9y7Jh8tUr51v?=
 =?us-ascii?Q?XF/teC4OPCp7/qNyez1Wrq3VNLJbwF6CaayPqPiz1NPUdD8vXP++44xi+lvG?=
 =?us-ascii?Q?E6vt30dPCvRLe9rTYHRSRWjfHrb3pEG9aE+MIPg3R+QSwjBovSQZ9M8N5K4h?=
 =?us-ascii?Q?P2YUXF5ucjBgK8BR7QN2wwNr/aV+SQaLuMF9NX0xY25+EJBrhyzV2XE8j86A?=
 =?us-ascii?Q?kq6jVClX2hUJmOIwRhrHkYCDhJ6YjLj6kp+Tewn5fzCbs32fJq3rL6gnNW2n?=
 =?us-ascii?Q?sFibFVZuA7PS9WeM1ir8VCrbNeP8Nbg=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f67b0f0-72db-41a0-a8a4-08dee036a320
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:20.3883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WK9OzQfDNLA+GO6GfAE8LtbvhaWNxrQgHmqT2tL52UdV9vgedDZfiChzT/Ilq+m2byOi4F21woD/SoytZGRnaNwU8l3X9OgPNE+TE7wTJXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

s_next_generation is only ever modified while holding s_next_gen_lock
(in ext2_new_inode()), so annotate it with __guarded_by() for Clang's
context analysis.

The only other write is the initialisation in ext2_fill_super(), which
runs before the superblock is live. No concurrent access should be
possible. Since the s_next_gen_lock isn't being taken in this
case, wrap it in context_unsafe().

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h  | 2 +-
 fs/ext2/super.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 79f7b395258c2..e851d2a6be662 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -93,7 +93,7 @@ struct ext2_sb_info {
 	int s_inode_size;
 	int s_first_ino;
 	spinlock_t s_next_gen_lock;
-	u32 s_next_generation;
+	u32 s_next_generation __guarded_by(&s_next_gen_lock);
 	unsigned long s_dir_count;
 	u8 *s_debts;
 	struct percpu_counter s_freeblocks_counter;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3999f8f3b156e..8c7f3772917bb 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1125,9 +1125,11 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_mount2;
 	}
 	sbi->s_gdb_count = db_count;
-	sbi->s_next_generation = get_random_u32();
 	spin_lock_init(&sbi->s_next_gen_lock);
 
+	/* concurrent access is not possible before the mount completes */
+	context_unsafe(sbi->s_next_generation = get_random_u32());
+
 	/* per filesystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
 	sbi->s_rsv_window_root = RB_ROOT;
-- 
2.39.5

