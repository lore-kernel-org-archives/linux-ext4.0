Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125113C1967;
	Tue, 11 Aug 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464255; cv=fail; b=KbcmD9C+LfnQHBj3OSvwzVv2B7LhSHtzky3VfWfi7uRoPw8xvdvJcadALZ26OgFCoeyo77EwRn3N/Qb7rmukhxAqy5UtuQyjWQ9CD3qtgRRpcEfJGVQdePTKUJhNoFiqjM1Tuz3I0fTpzv7RE4S4i2HqNdpZmaocganH5CuqUnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464255; c=relaxed/simple;
	bh=Eivo8aIPBNtIb5DqM2KTTtzYEim60rujImB4LmrTHPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B0+cI8IQwzB61/RYFoBDKnN0ejeD0BEiqd0A0tpW8YoNVqzjEHhhqTjugdnEAU6jvXizgllJ9SSU7eU9goIWMi8VIT4tM8kaGIIHFb4N701S+U+d+9kCUoaM2+rc/f+wNaYgFqu00eWYKC6l8UOWLI3SJleB64TX0sEJQcz2vfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=DYXxNZDF; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="DYXxNZDF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XO81PhthFDhjmu5hm1U3+YrLi/lxpxEqc6gmsnyT9gY+EiO5C8wHhHKhT5g70veLf95dUQMexqjDVY0WWjnDRpJzP+h3HTP+tV0MFpIiICvfhdDdnpCr1+wEbcE/OyeQaS0lCnl3KjChRSSyz7z0z/TCakTzgp3YYFUeCOGFKeQp/J9ku06DadXmTxZCNExsfL89Ul/H/D/XRHCgN62OG0HcvpD8QsPfS59QyNt3XFv358cC1gKv50tLagjF5sTNQBQeuQK2P6vXsWn1VjIOPrbnI7F5fvNUvAg9gLw2XisRMSkq53ZaJ9Pg+wSps6stxkQpcH8vBgolcFe8Cmbn3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7O+SO9TcW3NA5uqsezSugmmnRy+Q/rliNKxXhLpJrI=;
 b=yr9BItOVgbkhh+kBossZ3plF73DW1td7EJ15H98hTGB+Mc3j6Sa65J1gtNc849ftrTE5OIPOBamiasp7wGFX2hH9hiT4ioLEQux9YK07Fuawyjbd/Pyj706yZQUFKMXp+rC1pM0eviYyQSkyQYIGLpE7rCXsbTw3j0q/zzsL36ilVhRSWyMma8dLXbeLWewD7Ydgv2Mkd2syFmwBi2gATuKwCdcnh48yK1ViRXglhLQ4XGfyXmxcT//fC6CJWNaqQJ9RFhBYlIjp9yms5C9dWiRR/3Gc6kBlJQQ+dHAV4TkQMv/R36lRLWTHWSGHfZtbiv13eFJutSZILK3SXy/pcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7O+SO9TcW3NA5uqsezSugmmnRy+Q/rliNKxXhLpJrI=;
 b=DYXxNZDF1WGSzFMHGZh0E6Mvi3UMN8jTd81IS6I6K/bv6fp436ECdSmG4iNt2uHFaLa5iH7yhNtnu1hu0v0I1TCKvl+XINNyUlK4IAa5Tq1549VwUxqEIX4mxWs2XRrp4wI7E1zXKTcGCww0ThKx1yx1MNLZ7Wur8o5GPrCUgupaoS5jPzrqgZd5wXgzflwlA3JhcH8OFT2PhydaNMpZYRxMPJzE7H1r7k6zsNlvaaLtRmepAWATBK+Gyhfb5A/bfQWoEMFyhDDKOEeuroNc7o/ds0gPjqVKNL6pSSwyAFZc5HM7ELW+ocdhBu7EoAdUSixLKWRany9AHVCE+sD8bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:03 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:03 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 3/8] ext2: mark statfs overhead cache as guarded by s_lock
Date: Tue, 11 Aug 2026 12:03:31 -0400
Message-ID: <20260811160336.782342-4-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 726c4db3-95a8-4b19-53c9-08def7c2295f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b5OZi7vJk29nrwNDapRIbiMZVf7QYvj14uVQABuLWxh17M9vlL1viAc+wwSMiZPxOPlG/YvmnbHGtJ/UvlDtrXAXaCh29BnRU+nRwmXotEjaPn/AqxEn11zX5eTcDCMGfkSgTdzIu21UB9K5zYzwicgd6MyzUPjpg8sVICAyCde6TcirJGqnnu3wLf7NMB/qpPY2zFA6C1I/iw+tMX9p9YhXQ5/pmr4dDj/SbC2JEN1PHKa2s0nGLvt2Q/FKu0KeYcO9HilkqRfkn5UpkYz6cfQeRWt+1rjOiAsbU0zqBQGcCwWCm5sr694U3jxfqmhr7LmUUS9JBJzQwyRbsQXzLMqGQoMRmR6rqTk7dPq3w67pqMgoYYUg2tvRxko2ne1PxRxwnZUtOKyIvzx9+lGWgrfbyQe/n0nQMMOsFpTlKIm76H5JFeNsc+4+iuwszjEag8NJTtC+QlbK7fKQiRke5c433bvfu7MemjT1y/qtLYAOubzw/3XbM5pr7QeP7q5sLYChZEBxLLvUFbSg4+QLPGPuM71bS7q5GjgqqMdFb1bYmXAUxl6MiktobBDj16mGCJljX6Ir4KFOs0BnO/QpcMdAapxM2BAkpoZV65fAEDggt7PlcoVPEzgdcIVrpjgInwKNNqkpR1X7Y7BDjTWfWaNTW64DQAfx47817PInHsg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AV4u5uWSjDN95pkf6PrlKLrTEfuGyCsZ5JdY01tKFYc/kl8+QpcJ4EfprvI/?=
 =?us-ascii?Q?IruZeRSUPRi86iL8CitT9OOLoRQvHGOmVhDiOlXnq6l6N1J8c9Osqw1N2jGJ?=
 =?us-ascii?Q?qfyNTqUPuFjyN/LgL+c9V/412UPBF4mpghVZCTpC73OPktM5lUIij2VJzXfy?=
 =?us-ascii?Q?qPfAOZNCkDQNNy09ddLC9bIwTKloDUojAAeRyQa2fVOOu8/d/BhZwv6OuD6i?=
 =?us-ascii?Q?ictqG04VPkNicYTaPAfpnxJxnikmZSzUJnXQEolARaQ/oCHOXkmtW0DjWEbO?=
 =?us-ascii?Q?HQP48si7T/znRAHa1XMwd99PmOizt8ECidU1qPsR7zRwY28vTasg3pIRTsVl?=
 =?us-ascii?Q?TnvWKmjiS9nHh5SJD68ii2cZ/gpyDqmxsyIS5ZaN0MV6+FtDHEFe0wkdi6lT?=
 =?us-ascii?Q?UI9Qb+UdJrZc/lncWPvYfd63l0Ik2kA4nONYm4g07Yl41MXzhcFD1Uy3vYDG?=
 =?us-ascii?Q?g+mIQVzohX3mQiJ2k5fnKrzKe+PC4POnOIUEImVwP/r6YHgtSzJ18TUVYgs1?=
 =?us-ascii?Q?vFqBFTNlpFOQxR/22HLgC/fv3ekyFAdET2fk/iw98vtAdl5o7cSvj+bktE/+?=
 =?us-ascii?Q?IGVwAk8nSkNBYDkvR/k+tbS105w7LAogJ+Qpbju9Eh78lwtWzKKmGHqMMs8L?=
 =?us-ascii?Q?D1of1+IY5qj2rXna7zsYkzIpKafO6RwLnxwZppcErMO+PwjEpvdco7xVpMkn?=
 =?us-ascii?Q?ATXF+94DX/JzJBoQBZVI8qR/Od0r3Q7rM3jG0YrmmdkGP6b5xxeIu5sDLaUt?=
 =?us-ascii?Q?2TeG8sx/DEAU0Eck1TZ1QkhrIPa/OMuzUIjLPLa8BdF8LmWpQxtHQefaRNHj?=
 =?us-ascii?Q?YuVI5Cm7lqnPMWztT87kXfdKF0jUaLVlhOU/sQcPFo648TEPZcUaLXDcIQZb?=
 =?us-ascii?Q?f4jIJpraNmbfT0ONiWLah2nSlRQo4zE2cfMXxSd0GFZJVeJkX73bAsQkh4Be?=
 =?us-ascii?Q?c+HlF4gOdrUdRL3OkdQsFmdna44cKODaDeL9HT9wVA8fWlo79iKg+my7nrO/?=
 =?us-ascii?Q?2S3VwAryTTYg9l3PFTOcU70vF6i5Vys5B++4wPe7ANL64waFxu0L4b/oXTwa?=
 =?us-ascii?Q?LIIPoD/45qzzpIEqc3m/wGWnSuuxIzuxNJ8rffQIhx5FmMGM3vZVzLq2C5Gy?=
 =?us-ascii?Q?5ftTV8nfBry2KIO2xrXeYFacN5FypoCbJyttYr/vBrV1qADofw/RpSHfQf2M?=
 =?us-ascii?Q?xzVRbR4GnS0FunbDYE8UDEDQoKYRUbqh3vj99rNuK4GJgnqTeio5MfM+BkIt?=
 =?us-ascii?Q?bj9C78dRSGDayJHy0pYV4/xKb1evk4M8kopyTC7ymi2RL0YHVXiUrcSKEymA?=
 =?us-ascii?Q?fC/UHJN5yXzFrpj7tx/KWtUlt2Ae8OCnglkYZN2Uhu92uj4P3ISyfUINJY9o?=
 =?us-ascii?Q?VcjNASpLB/iSJU+3YVW1kMSK6bu4buDFMHs2rNg1+Jfc6YpibDjNcfb0Ldqq?=
 =?us-ascii?Q?RvVP2OWJ/eN7I5IrrPdK2qyLVFT598YqeqLmDEGaIVUfiZ83I+IQ5PyWhLjF?=
 =?us-ascii?Q?qSAH2tTJTiFmY0YINCFN4qnOn0wyJrso11AS192Xv/Qx7I1sWq5sRqzs4f8m?=
 =?us-ascii?Q?NFafRWgIt+h5R67qIc5k4Z7aljP+aVEwm8dzNpbQmQHFW0rp9fFLeJ6JLrry?=
 =?us-ascii?Q?wVCOekm4g0nOrJAf8qGxalgN5NEeZCirPUhF2YN4gJzAYEToufuP02a14u79?=
 =?us-ascii?Q?Irl5oP64XqMdVuv3HDr5xMhq3VU0z/xSqmveCJY6Q/9nuiYQxOlhb9deN6y9?=
 =?us-ascii?Q?JtuSwArU9NEYCoLs7ToUYwMG/R8e2RA=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726c4db3-95a8-4b19-53c9-08def7c2295f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:02.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onGFyqLsqZxolN2+ffKuIjXZDe60u/df3KnMdAXNKbPfsUpsLjGqrS6SaOma98NpeIqIqfiZl6T/QlsLT+OurtDoiI/MyBhu72EOF4OqKPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

s_overhead_last and s_blocks_last cache the filesystem overhead
computation and are only ever accessed in ext2_statfs() under s_lock.
Annotate them with __guarded_by() for Clang's context analysis.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index c8bf2e69675d..ecca898653eb 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -77,8 +77,8 @@ struct ext2_sb_info {
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
 	unsigned long s_desc_per_block;	/* Number of group descriptors per block */
 	unsigned long s_groups_count;	/* Number of groups in the fs */
-	unsigned long s_overhead_last;  /* Last calculated overhead */
-	unsigned long s_blocks_last;    /* Last seen block count */
+	unsigned long s_overhead_last __guarded_by(&s_lock);  /* Last calculated overhead */
+	unsigned long s_blocks_last __guarded_by(&s_lock);    /* Last seen block count */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext2_super_block * s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head ** s_group_desc;
-- 
2.43.0

