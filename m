Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022104.outbound.protection.outlook.com [52.101.53.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E055A368D4F;
	Sun, 12 Jul 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875455; cv=fail; b=uov57Fd0+6QLLyKvHEggrPd3g3x8J88n6WGMKt2dNPFPltKOTh6sCWQHguiHDizwuf9DEm/wcrSBS+xgh5xiiXchXTD89KUP+HBlaT4BiR6PADQUTkCF2ygIrHICb4wx2zDos5MUpsqciEth92J8oVm4rmTSyI7CMeUhy79fKHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875455; c=relaxed/simple;
	bh=anIY/j2BzOPzs/dGO02zFFA77WzysjKU7EFaCz3mlII=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q3jXj6eeiS7Ki/9wMBG5TB3SewiryspCAJjdPhx+OqoTp1lg4R1IPHZ7dhoAgo3chYwnyxLGT1BD27y4PXt3p8EqItAhZVYHjTyRlZ7NYZyVMq3gg/uoyQDRrbAhUOcFS/frTS8RwiHbn52Kcek88blExjDWysgTmqjQ8n2GknY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=GRTqJh3t; arc=fail smtp.client-ip=52.101.53.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="GRTqJh3t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VChuv3fYK+Pvo0xJFfov0Y8su8IiLcSmIX2PJmKkCdoqvr6Abqc6/Kt7gr+P6zobaogFFsfvaRi0laQJsCZq9TdWcmhOCojl6gM0kdzhiai71delunVEJ+O6CmuhBbR+zDdY0hj6nTjgrjISbKDOEm4+SO6tJJA72iSq/sV8pDfzWlU4Z8lYTCaHb2mMX4yLqbJJZquK2DArc3giHsJwR4XbIJuKp5n3nZib1xXRK70zO0LAsvuFyHbxnwDQkGHxE7wNnRs3AWIo+9H0Td9zkOdhiBv5UKpcfUh6OmvOvonWTgWw8CIVwJLWo8hzcRSETnMC7THdorXD7DjtPDwd9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79oUgI+nwsBduoMt7eEJ8KtI5jtaeCL8jSKzVYuuowo=;
 b=FiTrzkRBeVnxKiHGEa79PAhfJ4MecO/2u66o883241ecI5FfF/7HAvHYD1p3f9R/lpSuAnsFWoc4yYoUPuWJcfpyHi6IqASYOwQolLWmKAVne5l1wdqWkevsBFye3yuReTjmg53Kd1ZpJE3F69B3vOb593c+lWa+Bc6uhNuLEqc7788Euu0SWBhqFlxYCzSdF0btQ93nAzpnxhJ5sXMRI1zdjxNsJwY5GxE0AxH0ZI8wQth2ltBBWVfSAnLpBdm+kLD3ynmWsYaLuwrydKMaPG2O6ddIMFvtv0wIFSD/3cFmIY1jgAf4KzG2jio8E2I3hrjQ+yDA2FZPlQYyUl0/GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79oUgI+nwsBduoMt7eEJ8KtI5jtaeCL8jSKzVYuuowo=;
 b=GRTqJh3tQuPnI1IMwefSjYdw2VISwCQ6lLiyal0PFlwbiCa8/EdAtVPelyR6C8KVEl4gXPVUL4Mx/Ba2kTanj1mDRMuoY32IzfravzvO+3q2DJCpEKda7BP/TzhuQnM1zvn91Vd94GRGbsQ4z6LNg2cTqSVodjdoSL46sixl0pd1IARaUn3/hRqkh5e8nrwSAQBErjxfvksPkQ3G5YhOgQKcg+xk1PIV+0+n8yB5y3DGrmiPQUinm8PKTtHSJrl3n02ZotaaHBZqJos0X+ZLw0gGB/6S6+npICl5VTB/2utzZLZvuPYaIU4h99VkWOW+Y4YtGH0jNJDJM0GVjq/YoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:23 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:23 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 6/9] ext2: annotate ext2_init_block_alloc_info() as requiring truncate_mutex
Date: Sun, 12 Jul 2026 12:56:07 -0400
Message-Id: <20260712165610.366474-7-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: b7ddd097-344b-4bf3-c4ae-08dee036a4d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kg8Ilp9WTve++KGeN5CmR/9nCd1Z2emHv/8eF1RDmVV2DBEJiiGgO7d/7lPgLu+1c2h8i/O7HFIBvYRCDa9BeCFm37YB6Fq3uXcyK3yypLnNaf/sohbq3tm1QD73M3HaSkjt7RMgiEYFuTb8/9ALA/46UFfNZFLotXzpE7Hl2Q5Z17bN/giVOwKrMYV7wcHsdv0Bc1xq8d/M+cPIq6aAh7sp8iD+Qhyju1yPcVUYVV6nKy+mRghjoMV8KM5Sg8MkPaVj3gF1+fIiBaPjlmOQ9QHZ/GMzWRy/86bEDqJiLWxCRx9cB0PwDhxWGkOzvlgwDNpOMbO559hH5Vi2Jib+Rdf+GeOFV4D7UaFi75SsMK6dEua4Hf3csZBnG7xbqnJWqsR58Otol8RtIj6M0nX0kPbnEB2soGSZdt9uV1uVCDGQYI9DRl843GxDU7Wi5B9qOTRxe2z5UnbExS2yslb7+xc8c5Zf9x5gePYzDdfIPgVAq0kOek8d2j+7Sq5wQBg46vJ4o5EQqilD22fv8y10xTWQC7WyLNFD2egQhad9c3xrwFWO3lCuhpFrugwNixKWWxg0lkIMJkHCbC+/OucxKJ9vclS8ztuwuE+Qf6HewTs/fZg3OqxArcFb3w5S+5P97Y/fLeM0BZgaTQgqMxAXhEZuoPGdr6CZBJZ1GmRK3Q8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wtdYBP2IQJK4IMx7Kt2X6v3IyehS5DbyEhCo024Hqv3fRNKPP77ZmHdseuAJ?=
 =?us-ascii?Q?prBlqEUxLiE6EezjNKEV59vv+89Nh7ubb70mv7CgEgDvV7IVJr7tdbUQotsk?=
 =?us-ascii?Q?KHkwIa+fiBb1/UBz7epUH7RQ2bS6Y6AACiGfocWZvXDXW+T2fI1BlLgvO5Wn?=
 =?us-ascii?Q?5/WnBWPEIA2UvxpRxj4lrY2JSGT2nmk15y0h/87W92nvkyYmIcoaaKwj68WI?=
 =?us-ascii?Q?oVsJ2pZfqU9VuDB5dR2Ddjrs4IbEGtAeVpp0Tgues7lHCsM2+KMOpdMM5ql8?=
 =?us-ascii?Q?pqJR99IfYzZ6kVZ39d/pPEcVs82kMXwRDktgXWpqsCxxxrVM+a6K5B5AWkk/?=
 =?us-ascii?Q?0zkkrOSSLV39q/XoVgZ4SYcZPYs/AXwB+OKtBlxpIIShnXLzfl1aiDUV5XUu?=
 =?us-ascii?Q?MQHacJhYoPfnrbo758QOLn2BrUWGITYLqEXPncE3qYpzNKGCUrBEa1/Z93Lb?=
 =?us-ascii?Q?5LbKzALhmJ3NzCDoKfzptaIVU40kPHsPChGZxaez0tdUsViTbFWj+W9PPq6z?=
 =?us-ascii?Q?u8rHhg4k2QpZj5A26RCnWnQOQrhnCOP1NM31q2JpOSXjjiYdb43CmrS9SDlg?=
 =?us-ascii?Q?xwzoXv84iZlBnkCYSoB3P78RghViL+G21EzJzdsSYZguVEpOBRz8PjSSrVJ9?=
 =?us-ascii?Q?APNl25eDxroDSEaeQP94O7YFtnimv0T62eYIxvoGw8qYO7Q1CU906iKRJeS3?=
 =?us-ascii?Q?2xyFiZ11NWeMMMvVx/1uIq6XqouUBAIHULA7c5rYp6GZJ6fSfQ7Ufe2VZkVA?=
 =?us-ascii?Q?ofJvTOORv6cwdikYZbpHoDPZfZYYe2tm7n+CwLHr7MIn0OC/wMo4+uLHbgEP?=
 =?us-ascii?Q?8MkL7JAZ1kCf+SJv9DNM3Ex0P29lwJrSIdpilzMjqqEM+l2kj6vb0xBektrX?=
 =?us-ascii?Q?gahxPXtEEGY1M8YrqiokrTRFOToZ6Rl0Y4UxvhRQaH1VsPmrcvtzHYWlSFSN?=
 =?us-ascii?Q?oqCLL7xLELiHSNQlP68JXoXCnWrMH1ebEBAKZPJN2/trwb9x3vPIcIG4L+iR?=
 =?us-ascii?Q?lalyHWxzoOz3OGqNsrM+HbhyBCiUZvkkWgPSNBF9hfBHxovz/i2t2n6J2ZOU?=
 =?us-ascii?Q?2eVGLK+Sb6JWsRgjvau2gM6YgM0B/3t2Qcb5Elv1mPlbVOmt8CcnFK3hdU3J?=
 =?us-ascii?Q?fo/ItAwaf84+ER+bEQ9MN9BifRiG/4/bxQ2Zg/66ltLB+LswjaPlEXre34WG?=
 =?us-ascii?Q?LV78EHn/9WApBlcsWhnnOsQUCiB7TAQEstIpTFpA1NX8bKVcskBzyMCFjXWw?=
 =?us-ascii?Q?jaOZF17/ndktWPagsy97rurJh/9ecWVKXlH3eWJLvrU1lMKkgKndJbbq1qcF?=
 =?us-ascii?Q?zv/TllUeiISWP9dvE06zmz4qIfPrm3jB+kWw+Nqs0eQPBgbJ7aJkjY/L1zIb?=
 =?us-ascii?Q?dEJFlZkPBMGYV5aFHd3dQtDKTRafzuqfZK8RO1D8sgttitzhyStzpX1perjF?=
 =?us-ascii?Q?ZblU6sy9wgXU2hz4oZHevOSsZGmh7coEPQicyVekt1yw8xgWpiu5KcUMByzp?=
 =?us-ascii?Q?glfH+BG+akucPdtNjT+sBF4Mv7q6nIfM8BGCPVndYqldiZnO9d/IQdIgMKqB?=
 =?us-ascii?Q?/YZ7oNEST6mBSDuP8Jldvd6YMT4FQVY71yibMY2uVvS7u5LOd9gqz0mEkfDj?=
 =?us-ascii?Q?7sa0+19EAQpnm9ulEaqIBZ8t0yfkTD5z67PfLTAXcRNsCMpBolFMli1U2pnD?=
 =?us-ascii?Q?n+P898QIReq+p6Mz756OTAFs8oJ0MnO4JXxkiSylYCfh7mIjEIPA3u+XDzih?=
 =?us-ascii?Q?lx7Sx9rtALFYzkTHeIn40OwTZ5iCO7U=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ddd097-344b-4bf3-c4ae-08dee036a4d2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:23.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RTXq6K/8X9o31yPl6BXWb2SWEMLeqnsmdZrmPbLiNpDPY6Ee6Xz/GEX0oW1bYXfl8NjhrACWgAX96lej37i6yYx84tJmKzHFm5lUEgR1baI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

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
index adf0f31fbddd1..53c91cb38bdee 100644
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
index 4c30d6f5c9726..b6ae29b2e6ec1 100644
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
2.39.5

