Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2463655D5;
	Sun, 12 Jul 2026 16:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875449; cv=fail; b=ANkG24D5Q/9DZNAGvegCM7zhLCQsBMnsu8YJz5sgTH9Cj9WiDPISJM1ytZ2vbvFb2VQ8ut6SprBApzJf7ltYzJF9Gj/2VR9YoeSluZKs95zBu4v782LiokTQKsn7y7umD2JHJepPqndiJh1j+XkTFpPCuKoY9qVIP9Y06MU1VNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875449; c=relaxed/simple;
	bh=Sf+nKHnr9RJWUQ0mFM7CZNl64vzYvyNcbhHXa1SNAjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m3HoKwVu4dqXJrHYNSb1p8Csa++Yv1Og1lAKT0fKN6JSgtJDxKSmK2La8ptHFR/L7MKkBJy68WHoE9sBkSE8QR8MtmMzdsLrqPZQun8icEsrWbIAEvpcq71aOaVTAK1KFOaDeTMKnMvve2/zYnwSbWdjZjBr5tsF6233Xe+2Q2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=bvuq5hK8; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="bvuq5hK8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g61KHAFalhzRYmVjwTaQFoIuMoXROtqJ/G/yHEvg5b5eQCefFKdK0sI7bqPssmUkyIbGZmPN+9ZcZw2BVpE94XassarLS9z5u/U7PgHhBNX2+iRyNqp290JOJ1a3k8uIgyr3Xuf3yxSpExq83K/p5TgpNzloJozDgVJya2wJld1Z6aXM/3ic9jOi59xx8JjefpXOirwxkryTWf92nsPu/7N0F8P9KuGhR1dsI/lUHb+Sp1qvgI1lEQ+efwU8TO2mb3fwNIEJIvCfTk+HAKZCGryjkaQ8QSZeyKNbOGS3N6VGfGFMrCx2Hw4yLG3vL+QUiw38V4NwlPotOrHUe+UIpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5DCl5oJWFakbpn0ejXaAhyNKN/kJuyP3/0nJiQtSBs=;
 b=N1LQuRgXCiHHbWZgUegQhR0u2ImjTk60Am1ZSzB03S3Y4ZHSR8F6N0sjFZUwV04I3KZeS7VORIgNwcluqJUI/13OnE+oNo47XUMakP1dVRQakBkmswipXwlEMyKoTlADfVrVqyR+9B37RW06Bv01iSbm6+q9RC1Ke3Agc5WEWaLOsgG00a+rBi/8oQDIrV2MmAIi1gGrYlOykL536JqYtVnjwBfnWBFLzXZZUrcvrS6RSz8LqwVy/Agtov3oPaRGRR+1cso2IcvGl2VVoFMnRnJadFrq7EySRYJq1epsT4Wlw10fhoN4Dzs74z+LG/htrIQhJ9O8RJntZfPQZ22vHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5DCl5oJWFakbpn0ejXaAhyNKN/kJuyP3/0nJiQtSBs=;
 b=bvuq5hK88vxXNuERPrlhz1pP6MMZ6kB5b2zXShpEDa3+zEakPEinJpWDjKKqHyiT6htRBejNkRhBvRXn5s9SLGxKb9wW0Y9vWF2Xi7JGi1Lu5K6hzq3CztBiPWP2rxuXdjHfUSE2WnYJL0tiwbT3zLaNKhU+tkDcP4dYhVo3DybGEsWhvU34afSoslMneLOk8de4+RyVn981sFaIQL/Xe9HYtEfxyu56eXYQJHP6NXauo3Rujx46dTyLTxPzygczOVp/bsiO1u6EfOHcnCxhWCl0l/rtp25udAlAWSrSsImQBaUENvSb/iQdnd38irNbpEUoPV1cHn+9ZdmMvq8jNg==
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
Subject: [PATCH v1 3/9] ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
Date: Sun, 12 Jul 2026 12:56:04 -0400
Message-Id: <20260712165610.366474-4-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 814be1a0-801c-4b47-a820-08dee036a38f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LUXq2IKS0B4g6PJD1110j5Clccj2N/KiG/AkoSffaRhT0LoLobKF4EgUi29bo9PRCiNGqPT111wFO2l//htwcc0mqgfMidEmGCBRNQStcTO7nkU6VNAipofMduAn+BF+cgfB9uvWF2UqlUQIREn3NgOUVZN1yw3JVeH45AQG79vbBnrc9CxEB3crpB+s501bMn7OkgArIZac5OcBaDT0ayXbMePJP7zSyDHyf0TiyHeWQXKlw5KeYYs5TA6wmo4PpAJa+dA0gCE5a1K9gljt20qraetvmFo1LV8LS5p6hxncTlR3ngzg7QZX1JBAI3DZ1hfzY3TwkCUgqbd22SMnwQ9pp6rS3QYj05YhKlSSx8j3WHECFdojPu5EKu9EqNeHBb+dVRXNwOnrsz28P5k3w3PiLKSTrO+39dATFvYEufamfIH6tfb/nCFUYdLDRHParYHuMi/ZYnV9ng5aD4plHfMdFQyTEkcCULrzXd5AVWdqom14e1+fqndtbOwFYLiKkuzxHsGmIQpFReewWdJs93RBEjurKmfTdXXgULhD1mxNFYLOI952JkNAHrtbD6ic4BQTLeJnYtYQWUGJI53ENjDXa6L7DxNOihv2eLDq/QjUB2CrH6zU6pSk46LZboJK5fwK0IlnUhBdyHNLVgoKpxF998KXAgZ0blUig8hNQwY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GUiIZOO3STE81cZQXIdbplARWrWpoZBFai/4Mm3wyjyXFnDbhp9OIvROjiWg?=
 =?us-ascii?Q?wl7FyeoUtOYW0ixp+aeGbhTRoLhl/7RTS/bV+2P8U0OZU14K//5eBzQpT5nk?=
 =?us-ascii?Q?94zAsdc9jGvUCeZzslrI9Z0g0V7ohDDRenW7i9kE5xwQEohfi1diOurNlSC8?=
 =?us-ascii?Q?t+ph3T2G53eW7tHS6oRwMzUtrP62IFuJxP+Wt6cgNNGCruaVvlPgW+L49ucO?=
 =?us-ascii?Q?668Goc87EUNEw7c0w5Wrp1EMFNDctaOj+MhYR4W+Mj1rCVxuNp0cJs8JJpSj?=
 =?us-ascii?Q?87YxBFVQ19Xwe8+T3g5RdswOCZs+5bYmi1Yg2b84trk0EOFnJib8n18Xsr9A?=
 =?us-ascii?Q?/d7AeKZcqTq7ze6s2rybawcGhFwYVazo6tbuL+k84OSDNUFRfQV8GrbLq6WO?=
 =?us-ascii?Q?rpPAKeTCmkziTFUtawdQFQ/VzhC9+aV4tAVW+3heM7YHff4Kpu5fSXAMl5CY?=
 =?us-ascii?Q?tbxnEHt7tXLfmWxmawvyrYxEilgEmxuUq/OlBJAIKo1RRtV/DXLpmoTrjcoX?=
 =?us-ascii?Q?RqhF10ywsKBmn5DtG6SIWypdA7NX5GiRnwud8fD+JCUC2HG/RAhdLF0aNS5I?=
 =?us-ascii?Q?zXgJAc2oFKXizSSLY2bQOz2fZYEiW1NUWCAHrazGSE404p6ZiwZ2EcL5jC54?=
 =?us-ascii?Q?97zNhJxYWEwGJli7SojhtiwZe7dA0wTaN7wumbtycfcFXlvIJ1WIMxQyyw53?=
 =?us-ascii?Q?es3JXqiYam2JxJmtsNwOkPEv1TvvT+OO1u4/m75Ng0nLEE9GmYoT5JlHRt1+?=
 =?us-ascii?Q?NbXqJ1d6Dkx/n8PWX04OKj2Rx0WOr19U1hQ+WdUu2UaoxpIuy5E8V7mk9drt?=
 =?us-ascii?Q?o9fK4DLooyT8vt97HLVBwk3fd60/xaCWciLqSRy+q+BwwuQdicSzpSbZmL1a?=
 =?us-ascii?Q?m12zv1d4wlV3+1oqPOc2RGjyAw+7JIo0/rMEgTG789uGIPV8zmNxqGZdgvqV?=
 =?us-ascii?Q?9xDoiY9ArbvgGa9LUz5WBvz34PK2rvAXzU0mc2NjQUUpfpcu1YlGSpTs26ft?=
 =?us-ascii?Q?YA+8bhuVsUSj3uH77RL81Bj8Zm3r5MCmJ9SAZXCAYurrnyoQYZ/F+MkaIx9X?=
 =?us-ascii?Q?VXyPoaOuujt+FHByR/b4H245JOUY9Qg8IH8wK+d4Rp+IywFBRYLfzIaehPqX?=
 =?us-ascii?Q?bOsiPGJdS9kbj8Np8s3a/b7iexfEnR3BjiHA2g3fRGXbsBhCOK5BAcYTnNae?=
 =?us-ascii?Q?fpXCcv1bLNPxTVmxtS3/il780Pkpk8mIIj2yctpuhp2VrkFXHRLUeH6LHIuc?=
 =?us-ascii?Q?JQDH3InrvmglSeV9FbA3QUeVVG9eAStzADD8Nz3BIXq7RwlhVODX0z2nFMn2?=
 =?us-ascii?Q?pYDfj8NoJ9ZYP5asqiWyDT2dQMtOdSecBH7FPYoiS7qcnXSrXPE3VgbWCvlj?=
 =?us-ascii?Q?2qrZ12lzN/53W2ldTL5NPynG5kxTj/hRKea+Ykmen+j8filNwNy4PfzhV6Vh?=
 =?us-ascii?Q?8tA0DRlssJyHd9QzPLo84t4gaqX+SiTnFCtDhr4IkKSmGLNZAq7Dku56spX+?=
 =?us-ascii?Q?Z64VI7VyBHePTjDQALHZsgPtNxs1oM7+Ebe8+/lH2NSkf7m8ropmMmVaMXQO?=
 =?us-ascii?Q?avyDyt7MrrFsX7cl/zLkhZ7bZF8jC3KkRLHmMddlAXo9wkQuiKojFwGHwx4p?=
 =?us-ascii?Q?1iJVxaOKD5YwIDZN5MwToaERvLwuGy5hUriudZnXEFlFqPuGN0xa1vg54g24?=
 =?us-ascii?Q?J6DBJ00xQGGGu0DsGGklJyveWKo3/pEjLag0w3fh1spQvo0vXdFY3qxJWl48?=
 =?us-ascii?Q?6uS9y2D4me4sBe5nJw3KV7F/1ORHhoU=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814be1a0-801c-4b47-a820-08dee036a38f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:21.0954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: robUxf4xzB/zWqw3kt4nrPYgSlTExJOyGVX+FM/WvYADCXN7/Uk9CJRoMvWD7EAj/oTd0WpGOjbkWb1r73+GQbt20rDjEI8d7BoWQpoHK44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

ext2_update_dynamic_rev() modifies several fields within
'struct ext2_super_block' and is already documented as requiring
s_lock. Express that with __must_hold() for Clang's context analysis.

Both callers ext2_xattr_update_super_block() and __ext2_write_inode()
already hold s_lock.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h  | 3 ++-
 fs/ext2/super.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index e851d2a6be662..c8bf2e69675dc 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -760,7 +760,8 @@ extern __printf(3, 4)
 void ext2_error(struct super_block *, const char *, const char *, ...);
 extern __printf(3, 4)
 void ext2_msg(struct super_block *, const char *, const char *, ...);
-extern void ext2_update_dynamic_rev (struct super_block *sb);
+extern void ext2_update_dynamic_rev(struct super_block *sb)
+	__must_hold(&EXT2_SB(sb)->s_lock);
 extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait);
 
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 8c7f3772917bb..f742b9b6b017a 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -127,6 +127,7 @@ void ext2_msg(struct super_block *sb, const char *prefix,
  * This must be called with sbi->s_lock held.
  */
 void ext2_update_dynamic_rev(struct super_block *sb)
+	__must_hold(&EXT2_SB(sb)->s_lock)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 
-- 
2.39.5

