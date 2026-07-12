Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11022104.outbound.protection.outlook.com [52.101.53.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60A8364EB2;
	Sun, 12 Jul 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875452; cv=fail; b=iSKTKsNmiV/eOSeTEPw0CA6l6bb3M9l3s+WLc/AZQw6oq97w31cATKa4lO05Elt1YpZ6eeeYvld6ZZWuAkP0SS3O10hf2TZ0A8bzClj9cGreoN7ezm2yW993qWz+X76gGQRIZsrOTe4/CGF12YZAPbEKSHm0UNA+BXbSaX10IpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875452; c=relaxed/simple;
	bh=rACTJe/i4mTZHSBJXvaVN8M2TIcK7bvDYkfjREX1q2Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bi4xJLyhzLDwLmzAZiPhERB9aKl6i6z4CfRJEB5IOHpqrcfaS4GEbQvpj0rI9G/H4H9bjL277kJoNEnKYyVyksepMjG6FJno1xosL5d4AcVgp7OC+u0Psbq1m4mED2HYDoLKlqVzzCJYieLI1iWWAqlgBBW+FrzGT9g2s+bW7LA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=z9Oo20vY; arc=fail smtp.client-ip=52.101.53.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="z9Oo20vY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1en8rvs9bbN2UNf4nXlxOGSpBOJaUc2u1v/mMOs8uwcO+m+1rHTF9Wu3LaIKRlSC9sKWhUW5aYXOlydJnGLm1H2Nu8c3QY7VSHoWDZaZmnGoc2JfZNuNmyAzWI1yW3hzoRAqf7iJafzEk4EUOmZVsNVM9KyEo2ToZrl1jG8eaSXGJM1Emj3vNPFD1WHdBFXGyZO1BA5SO9Fjxq/a1rXZbQakm7jYdvk3u/WhzAYvb4DMn2bhZ5kq6UtiTmYY5NWMcRQeDjW5biB9f0ZhqnsDtsesPZgqGC8W2M9AlV32kRT0rW5bLW9NfTcgzIWXPIA4jLlYowewbexdPCtewluIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTYP8/sITv/WBVytnlj/RVp9EXiQAdjKBl1CAQ4thuI=;
 b=SEG1oNpkxzV5+Wqt3r0upmde5JZY6VxdoAgKFfzSFNfKK3tsryzWmGpAX+TcI+WbX42/R85QdbfRtqR9C9tcxVyNAkIRadkcF8qXPI4EnbvSY5jvdIkaapbjb5niecEob1ON/MjF1kmXXtM+m9cz3zZ6LhbIo3YjBE4i8wdsmq7TjJ0s//Y3t5u1tm53hF1UFpV2YdnTpmaPcqybBeJTs/I09EkdRWJbwHZucDXO8/cQPjl31QzGeC3KS7ChaGORizPTgMzFAn205lMbZtFdUg5pywrCV9qHm1aP95jX0ue30vFoJKQUrlOdOpb7t1pIkk06cNbgj1URUXSbs/r8Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTYP8/sITv/WBVytnlj/RVp9EXiQAdjKBl1CAQ4thuI=;
 b=z9Oo20vYwwVOEwBFZCiVmHhOdCbS1Q7ekTzxsg8K5+TjKowz1Xz83y84EK/1FPKVilNZxQI/egrVfGmjp/1Fwevg0HhXDq/rWtP9GXpxESpEQVpO1SikP9fExsVN2laNCCJo4gfLuE30+IkcGTAhIcmMy6RV4G7JVox8kcfmKBAV736KMcs5EOGpwiPUhW+ozewe1aAWqNIsUASfyEIKXW8tEzEnIbxTBbOtrth5Khgrpjzgq1TQe4p8wzILSdYammb34SJKPoBl16YhNooGZN+fQFJSv/TDhYBY5dXNanRT0zXC3XLH6JETYe32SXgxMykQsLNNBxXDuSBbqvuevA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:21 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:21 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 4/9] ext2: mark statfs overhead cache as guarded by s_lock
Date: Sun, 12 Jul 2026 12:56:05 -0400
Message-Id: <20260712165610.366474-5-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4ea2b5a8-3d17-425e-586a-08dee036a3f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Tm30iYnB9YVXkPbpvVj35cPwahmvsmOy4jqK1w7Y5JNoJ9QvaE35c6mIrypskRKWlqvqJUqzcdu8+ZtvzUgNkHvhA9HOdHuYpt3ibM1KBYmnMUgN0+BkikOZxdVyZicX5gaOgIXYHlPzlTZ9LY75kINfeK3Wdbza7YQrd45+qdkLSAqmjyjNyt0EvVn4OADUkf0VA3J8n0j0J07DSA9DJyphEamwN53XifoYBSmi5otUV1YiKR+JNwPXhFab/jLnRQ95jK+N4JSrn2QEQdGtz/Vo5J67ok2Z3icToGH8H7VgMPF/KjHhWWGurS9L3GHe5aRZaONLU73iFpu7hABn2E6r0lWE3iZGNXfO80EpBhhhorfiym+ah8leO+fbcP2tu3c1hxnken3VpKg5rVyQBP0MfX7h1DUcNUPc/v1UMtQtQE6pTtsENSUAlm9UM5r4bVlrLNQwFyiMSzI79nAuPcBwI0wwkTCc3bJqSxsSuRhds62DfwnHUAZ9d0TiaIJxd8tSFxzwwQYLOfho5ZlKhPUetjUxZjcY/N8syrkaoqym/JKRPt1923ZfCGxEgO3jQaedIl1pF4GAcsoa/zgJ1iM4z3DC5QwbSrDc/Wl8kS16+Oy110gh1/Ez5x6j0nOpEaLtXoFCmiN+knmGs/A/KMzohhKKLjl8E95nCVSwejY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QA3aP0Hx3NbUZL/QkWPU/1X8mLodyHeRfzIkB/bSwaB8BjaCWgd1hUorqfY0?=
 =?us-ascii?Q?+VltKoTTsbJgOj3Q68IreGqIqfxX+1rGBsP3H/Z+cF1JTPYRhkah1grjNDnm?=
 =?us-ascii?Q?m0f83A7gBZaRl/38CEb4lqPq0gofmbzhB1u5o/FLCwBmHhgtR4yOkkOPHaPL?=
 =?us-ascii?Q?SBWt+c9uQ6BPqxVk0VAJvgTcQVhicnWxBGkESmnp7e/JBHo4rck9+P2tyEww?=
 =?us-ascii?Q?O0fCFHkcPE59NKTaHpmMjoUCI/nkuE0nK0CYA91rFvly8/D6txqf5WgHBO43?=
 =?us-ascii?Q?7k5WsxsrxBKEKhrUYM/D5apHwky0GvSUiDKtOsiFPAN1LgWZEHNR4jEDhKV1?=
 =?us-ascii?Q?14M/7E7QkXGSOFYgZn0ZeYU+O2OM2svnY8oAHi0jDIAv6/OAtbFG2sdR1Ndj?=
 =?us-ascii?Q?X8xfjvlH3LYMxfECNrKKMBYOptVv91wqKhIZYds5DrnOHgepNseOKVN4r0VZ?=
 =?us-ascii?Q?QmhObwNEoRpFINOELbteUdLtc8S84eFohC7K/xTF07geJujHkpCFjaeorpB7?=
 =?us-ascii?Q?gk1vk3pfWPvpYIAmVseQIHwyACHmf79zknqvhx0YSatZrPgWcO0ds8lEw5d5?=
 =?us-ascii?Q?T5bJWmb0xdspXPDBzTvP2RPrUu1C1ZoAppvkwj8rC591iCbSSQ6zS3OGQ5VZ?=
 =?us-ascii?Q?xyCjx60f62YTaejNHsJRUK8VIADuSMZEckbnlQYE70OVCFimyeaR/cun2MV5?=
 =?us-ascii?Q?ROO85pIf6ElZrD3odrRQsMce5W7dsVE6HPdSV/pql6lUepQMjhyNcB+BiZ1Z?=
 =?us-ascii?Q?fAHA0JgvqQS5A3NA3TJAMZ2iYH1gB5pb9QE6EYhOz0Sx2eXHBqo0cST4b4xV?=
 =?us-ascii?Q?AmlQT6VKv76zO/EQBqpmyLr2hChPqodzPRx2hsAuDyymAPTT12wB1yhDtRPm?=
 =?us-ascii?Q?pKcvjFtWUfiCoIJNQvP6kaf1ARkDCILa41WTUrc1C3/ONEaZivJ4x+5rfomS?=
 =?us-ascii?Q?hcta0QUvMStkJA9B3+SDrk4kYduh4rVKve+Y+jZqZOJdzVyJ2dC156ZANcTg?=
 =?us-ascii?Q?uou80pe107WXJpWTS3uyflwqP1cU4RDNuF4A1e0wCuY9OIIJPPkmFiV+5TgG?=
 =?us-ascii?Q?0Nc2LLhUK0sUiO7p+2f4ZlmWxjMU9IgDROcySfi5iize23phF7DzfeSyi7jt?=
 =?us-ascii?Q?Z0C/7+s1tkiwjcuHhJ+BzLd8S8tsuIdvdAChtLEtcEk4Q4DGbuEoquoqFSJF?=
 =?us-ascii?Q?P8MjsGBbWS8CGWVBYwb+r7kauPuDHnK/c11DL6cyVFnFIwxUjUoIwoVpyMDY?=
 =?us-ascii?Q?RgTJgrz1E7bUvh7hmd7wgKOqjUdrKD6rj8RoHlc4qOQ5+a58C7YTkymbzHnC?=
 =?us-ascii?Q?d4ntz7vHhrCJkNGGuRZd7VRepJRsP0ZS/PQdNG7o9a+9JTv/0HDIMkoq0Itr?=
 =?us-ascii?Q?CMOJBLR40YnMv3+FRRO7lt58+WnDw+Dul1zvjKUltZiTRkYxa4bBApZDtLh4?=
 =?us-ascii?Q?s8ywbpjoGnrjqjGnKdqYsZTkLTMDh5ZzmaljcRU8NnCPXroBBDTHuhAgPyn+?=
 =?us-ascii?Q?yOF9wgM68K7NDEaXNs5GE6cslyZsV1xVi2C57p6xA1SLxH1ug5zxGVAWjSYx?=
 =?us-ascii?Q?fUSzgsS+EcPwXku5JG2wghWNWEdMNvJKa9xmC58bkrAAEbV1WZDTCeKNi3k3?=
 =?us-ascii?Q?BzI9n2dwwXJbgXMZPpzGwn1H03Rmcj47i6Dzfn0LHzCQSDFBxdRhxtb5sLRm?=
 =?us-ascii?Q?S5Rd6u5m2/isHzsudw72UoSj6V7IWsxzBklY9xYnR1NW7WGGujEum91pKYnw?=
 =?us-ascii?Q?jX3JMEq2yxyRYGo81nnC2qLkQgTpetY=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea2b5a8-3d17-425e-586a-08dee036a3f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:21.7862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLCG36wms3XyJAyRgSaE3DnpHRUCjZjFGudM/s5UMcLe5xGPHyXj8JodDWeJ/ujZ9X0ZeAtyE4Lqib56xB7exjgln/ypxauyYrMstHrVNh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

s_overhead_last and s_blocks_last cache the filesystem overhead
computation and are only ever accessed in ext2_statfs() under s_lock.
Annotate them with __guarded_by() for Clang's context analysis.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index c8bf2e69675dc..ecca898653eb8 100644
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
2.39.5

