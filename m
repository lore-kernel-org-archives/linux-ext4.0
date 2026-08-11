Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAF04052A2;
	Tue, 11 Aug 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464259; cv=fail; b=VcpvpznZeibJPGTWitoEAtI0xZml+TMByBY8dn0AIOA1N+nN6xJYePhzCk8QP8jk3LwMUUQ0C5OpESTuZbMMrT6+JbTd96Ej+pWPeeh7e5NC+P0z5YV8gUYqHZh7htYWogi2tBgU36zBt+AWNwZUMvtAYeOU9FoV2mLS2Q25Vqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464259; c=relaxed/simple;
	bh=aur7htvlO7H91MunC/KN43uoUyf7PsXky7IsRIQ722I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mCsNEufB2Ee2iXYEeDRYk20C1PzbV3hspjOfRS50LtQgukomuRbrmS9fQM6ulAwohCImi3QcZ+qB9Xulps05xJu4yjYpPSRnS3KKexmhUaK+fPZZUi7ldpsvG5rZ6HSYYqa7T3J6/1pEbSAJdwKFGoswQOxBXbWxKz8TazYfGjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=AnyE3iGm; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="AnyE3iGm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KmeULkuR70GP9kOBC7j7Gxw5c92RplPTuJx+sEI9W2if8d6nRmZ+07TpAViXDnCLlvUS6i6I4Km6lDisXw0Ecg6I99iKS6G8LhJSSNp64jR7Ieq2KvWUHmuslY1A2zFS5TodPvG2Rez5YBaMFTLfeRO7nVIZaV0YntRxYlHnKgfTq6wEJb6fmYROnhp/Cs/UI24lbnn/kCKJK80idixez20xxhzLAmVuc+rf4NpaDN5z1REHtxYRxjA4xovpJ8UscMvkXrchs11RzIdkBcoGCZtrInKf2FfeZ6k/V+i7moctFOJ0Ko7MXdo3kZqE7somfMNwBptuEKlYL0erXDtUjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lc9JDEN3qkoknlTvnzbLANnqF0ZLS4aJ/u2eFu7sLh8=;
 b=crDw1jG/fiHi4ImG/0Gr2PPPWWmUs315o0KWV0YXWWqBJoaIewiGl1BLqhy2Sn3HX7hFNIUQPuU8TzhqOPPWSa6g5iwxr3lYDgPXpl7jJL3+j/YQrTiHfvv/rl/+1YKMD668ys6f6Id76KGVHSS9Vfelu0wcJ2Q7R4uwrvpcRLiL4PDrpdVJvM/aTcofj05wrwSNtrzDsWDOrS9+ni9nCO95f0lOJZLGPIyUE5beaqVPyabWHaK9HkLs+a4LzKQkSuaBb9bvTk5bxAGDpq3i967ZOOAXqI5RUMYDcllMtFUKFHjyuT7jfobEyq3412QqEZhOr+UKgU71aX7NX6hYXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lc9JDEN3qkoknlTvnzbLANnqF0ZLS4aJ/u2eFu7sLh8=;
 b=AnyE3iGmKbjTw7fbWudGO+6sqN7NxZgnoeloQc2z5C7jwIZs2Drf3pvtYEL+HMmNRYwP58Rxg4m9aFnUa1Uz+GS5JL6JUvHe7Mz9v9ZauQ/Nc99wgqiOWj8Ge1NVRF/Ua/4H/t5JOzNY8qdOZaC3lROOBojE5GupKlJfPXXLWbODgg0oAnN47yEK0ZVJdQwZZyR8NR8AOtEHcO+V8Xvneo1D62GsEo9IzUjqx+Anj7pc4w47fCkd4AvkUvCJ1kf5ukIOE6noxnRqtggrYNUMUJqh2W2ezZ+vBMld9g7Q1LYeL8LLC0YOE5tJkUVo1VMARrHt0j1nGF1rn0rz2c5Dxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:05 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:05 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 5/8] ext2: annotate ext2_init_block_alloc_info() as requiring truncate_mutex
Date: Tue, 11 Aug 2026 12:03:33 -0400
Message-ID: <20260811160336.782342-6-timday@thelustrecollective.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|MN2PR04MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bfd618c-45d7-461e-ae0a-08def7c22a5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2LkAmFA9DTSBTlBFFFwniUGC7GfSkDZvSgz5Ywh/WT6+F4eNLswdLFeIKQyvY1leodHqhRQEoAahQhr0OaLazChkmy3+8Eo5/K3OBtnsbLQkDWzJkZni6E8wAS8+aHM7VVsx1b/6FRnv/jdhTQhrgNU3a0NENV6e9Lw5nZxQFaCs7hjqWi2Z2ke50/v5JxrrnjEoFXm9FchxUxYazEDZX22hYRnMk+Zl/EJYyxVpi7W9rObexCIz6vIjSWo6ul3/MwBebUsbbm5gPs4Nm/DxhGP5cHqfHgMWGLLgNQ00kwhjhFoy4lZ7V2dOEtXVkC8jmxE/6lQrQr0UQ7PF2q/pOtJr7ORXwQUynfL74V1lrGnla5xAGRtbc0Ny4SCmR2Q0G8kqw9dLir4k2l/KcGlEXWzBbk98xD/Qai7rL/DT5WQkLAM+1Ch7uKFFndAznD2wyiPh0+OetrMRs78stVzlqu2eLeWtaEm6zUSquqqPy7gwQjAS6fcLwDOBuCsPCZilBQzlrFK14VeG54lwmjWFUFUGXQNTP7dOs3DMxLVWtTxHwJAIi2E9hgruGW8uZUHX3qNbL4jSgbSfVE/sTT3kWVL1pzvTopqu7qvFY2ELOzCqBDBFb6tHz997WzeEWMUel43C6NYdM40qSvCAryPXZqXRxjR2Dp3mqNTBvK4qkQI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dB3yyzwYa7jbRlSmo9CAAaIv9jXoXlWsx/aJ8+V8n4XiezsT6H8I8+OyiCvz?=
 =?us-ascii?Q?QZPPYG7BrlrKCqdKXIWpUFlEslzoL8U/MpYS+etF8YuwMeyr0siG3LJrByMh?=
 =?us-ascii?Q?EOnBMznY3iFownu4lpoFy0NLtvA8uojwOkUbU6YCqMSGay7Ykaa5DRNlDL68?=
 =?us-ascii?Q?5305EAMi170n2td9dRWyZ899l14YVs7x6xPa4AXNYGNcgoovJKZU2FvqGsB2?=
 =?us-ascii?Q?zm9GIuo8K9gFme856yOT+UCg8l+z9z7GDjy2RqLL9ItCAuvy/afJ/LZiOP3C?=
 =?us-ascii?Q?zJEMfQgH3+qH0HPhF1CC2geXGOSzrCEIZEN1V7+CbeMLHRUsHCjmZENIjUjH?=
 =?us-ascii?Q?kTRcRjOTtESqplYtJG+GIB1lsx0Xf8qt4F3lSIPqhRVM40uW5G3O0AWWIOER?=
 =?us-ascii?Q?LwoCAR9Uq/hRYrX506rDwSXaYW0S3MP5fepWavujpn17RErx7d0Del53q3AP?=
 =?us-ascii?Q?aYwS+f6U9rX2GY0POX1Of/T2Vo+Fj0RfVaRPZ8gCSYOKRgsRmIIbmU4yHeoc?=
 =?us-ascii?Q?3SqV9244ZvPziu7lMQ5WQ4s0Ch+oW+IJoWMc4K7LecA/JjZYeWv+JGwSss26?=
 =?us-ascii?Q?CZ5dL2lzQTU9i+p/GEVQWmTj0p6dTTLEuO59QkYHlHIxBhnVXdy7ag8E9vq5?=
 =?us-ascii?Q?un3OJLgGD4nE8IuH+5rUNU0AEFaq5i6Ujxfsdiyb4y5xtN3KbK5O4W9h7F/6?=
 =?us-ascii?Q?ND+NVS6Oo4mAAM2cmTSnul+4AnzPM/kRl9D+3D4jyUJNctkBwp/fyPlhzJfo?=
 =?us-ascii?Q?djofRA7XDD2QbIPTISUfzn4IJzy0NzDxcQMP0c4T3P6mAH8QNSnb8ifaqfIX?=
 =?us-ascii?Q?RQ3Pzwl2fg3EnIREYiHML5qfspNUwUI5vdijSaSMm5n+0+McPvh+9+ZvivZR?=
 =?us-ascii?Q?YcYCK7SOfI27B37hj7E2fgiulvpiuG0IOmyCLFlhV4Mk+0pgeGRiXhnd/jKg?=
 =?us-ascii?Q?G3fTz7DloLorbu9U1IqwGCYB9qyYZLh1t/rhgjsjLg3C/uvizbWOJpc8lMRX?=
 =?us-ascii?Q?UCLiiS40g33IYfXOUu6gj2ude7mEvpVqe4lJYEd7IMTDxJZC8mpXv+KjF17f?=
 =?us-ascii?Q?HpKnPvoCI5cQMMcNMPnbuPUPwXlcrWDClksDlu4gCKvHRtyRQ5yq4Dxjfb3W?=
 =?us-ascii?Q?57qNC0YHxGuKTWyolE4f3hIvQmKWIGygwwwqDlWR0Iw+a9DvTV5886fEJ2YC?=
 =?us-ascii?Q?2h+HHCckG9aRL5MPfRGSgsaQjhwjQFRx0sDPT0h7tMGHttg7RyTlJVk0lR+W?=
 =?us-ascii?Q?+V+MPkzEFZLSmThJGS+wo1Yrkddd1Salgst2Wa/sv8TJQ2A8JJH26WTOYt8B?=
 =?us-ascii?Q?ztjIX7JN3+jjrRBLuJiNpba9rIgDGH/bHKI3QTzxbSnf/rVBZPHXJYAi0PRy?=
 =?us-ascii?Q?fGVQyohxWNFLxCB5OQxIcg0BnV1z6ohxkGV6wxGPH2675Wd4UGgaGpagQ7y3?=
 =?us-ascii?Q?IJ4XRRpYr4YbG3mOmvUlK/59gGKezZbFo5pb9CYxuVF8D4Y+yT9odzpeRPQJ?=
 =?us-ascii?Q?xlYjwLIPGzTD61jRPn8r/jBFya/OsiNY2jKy9QOu/aAWzeZ7Q7yIehGfNMYU?=
 =?us-ascii?Q?ERMxOel4utz7rYQ3vSZDMmtg0AwZLMymJe9hcD7TlP/Fb9Cr00SvKPInl9On?=
 =?us-ascii?Q?M8+UHA+DBymvs+vRqmSWN4BsTOEvdhkiU1pvNKWYKg7blghp4sIogBuUUr7u?=
 =?us-ascii?Q?pmo103jgJw3EAWu7kRyGmJk0a7u/cBuNJFjFsdqUaztz50VXocURk7i/cSD+?=
 =?us-ascii?Q?ACCTDFl3L6vkHODkSZS46m+GjioVvts=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bfd618c-45d7-461e-ae0a-08def7c22a5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:04.1386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1qiBf7y2l9574/iE8NDX7hUyZAxxy7rwLG3qJgOYbHg1hp7D6EBO0+H36GWt7H2Zsw1kPM/MCDbQU0xruqUyKX1qb/CdXoipAoeM3AfpXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

ext2_init_block_alloc_info() sets up the inode's block reservation info
and is already documented as needing truncate_mutex protection. Express
that with __must_hold() for Clang's context analysis.

Both callers (ext2_get_blocks() and ext2_ioctl()) already hold
truncate_mutex.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/balloc.c | 1 +
 fs/ext2/ext2.h   | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index adf0f31fbddd..53c91cb38bde 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -414,6 +414,7 @@ static inline int rsv_is_empty(struct ext2_reserve_window *rsv)
  * Needs truncate_mutex protection prior to calling this function.
  */
 void ext2_init_block_alloc_info(struct inode *inode)
+	__must_hold(&EXT2_I(inode)->truncate_mutex)
 {
 	struct ext2_inode_info *ei = EXT2_I(inode);
 	struct ext2_block_alloc_info *block_i;
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 4c30d6f5c972..b6ae29b2e6ec 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -710,7 +710,8 @@ extern struct ext2_group_desc * ext2_get_group_desc(struct super_block * sb,
 						    struct buffer_head ** bh);
 extern void ext2_discard_reservation (struct inode *);
 extern int ext2_should_retry_alloc(struct super_block *sb, int *retries);
-extern void ext2_init_block_alloc_info(struct inode *);
+extern void ext2_init_block_alloc_info(struct inode *inode)
+	__must_hold(&EXT2_I(inode)->truncate_mutex);
 extern void ext2_rsv_window_add(struct super_block *sb, struct ext2_reserve_window_node *rsv);
 
 /* dir.c */
-- 
2.43.0

