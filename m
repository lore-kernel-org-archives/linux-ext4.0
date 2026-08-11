Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C3C3BFAEE;
	Tue, 11 Aug 2026 16:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464253; cv=fail; b=bej911JD5Ung9yHfMTJ++v+6dA8vsIk96TNTuqxAP3+JEolzF2W9hP7bCYLEByMQVpwp/I8j/S4m5x35WKnDjSlEZjzyf8FsJrSfqF/UMHSGeY2JnKjeLLvQZJYzf0O+/nBYRPD8F3qMd9rk9BwsiGBnnF4WPLOSPM9wH7OiFKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464253; c=relaxed/simple;
	bh=wvFPTKN7/iTz0wEr9D58Ho4Tqy/ZAMeM723IsFNTdWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=numHHG1A7knvUTXtMADRn15jND33A5xwnm5RnexMrC7092+FmI2Lkc3aQatwPkmvPCY2sFDaa4yreFATDzT5mOx9N5y1xraLolkw2fhidWZ40dRrYGNCn9dDt5WOWjnkvpZRJZUQx6OYV1q8/DhwScsGytOV6TlN0zJdfvLPu/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=i16V/UQD; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="i16V/UQD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGwzGhmCuUMEJLAo9ybP3PbMj1msijKBQ7TnJwI11gDgTW4yEB1AvfhoBXunIiG/KQnwbcLbTFOx2upCsQJcBGDWBOosAHGaeh5yB8FPzHpIEtn/T5s/ySLvrYwzTJgbJHTYI/72cUqjJ9+Gp1RDfDED9W/HLMXNpY6g9TUGRsUoH6cpe3isDKKpvMZS2VNt98EWIGwKdadlsoStTtxzD/rgoNycfTS9NEdmEhy2hgIHMIfnm+3jHsfRZHmJIX5YtAAASH3ED3RJ6sntgHT5kEKYuT2rBHOZc7gP55C3dfCukHFp6ASnHoEsYtp1UEK09LvuvQV/DoW7ZNxE/E9zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7o1SZWh8GIRrXgPo374tuvGLGAfgwR2pcbHAhNFdGkg=;
 b=VM7ne715wlSJ6TYB2X+d0Y9Wakj8/JsXn0vTqz5RoI4Q3Zk3FynSwpdismP9hskbf/FqAV7NnbdZPVJ9pw5dR5PdWnDX4tALDrA5ibgYDXrzjGU/dkNPfrnvgrxiuOMaC9G3nslnGy00sULEu17WMMEONzWwPSZMq/XBl7p6vsdLhpp3ccB6ghNe5GlpDwAN9zEtoPiQFH46EC1ZBaDKF7JzC3P0iFvY07KxMSqq0KbFNdGMw4yHTq9Y10k7ZhQyliQhFikK1VQsBswSMPFuq18Z4eEgjyrc7mGJMQUCf2HJd8DYStTsHeMDOWadjgbCuX56QDSIbNTI2SvB7h+Aow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7o1SZWh8GIRrXgPo374tuvGLGAfgwR2pcbHAhNFdGkg=;
 b=i16V/UQDi1LkHUsz9Jgbp4z4nyAlahS8Gb/UcuNtbGyRRJZnW0Z0wgryNSPrBxnQPCIkQT/Gc94xw0R4Xbz0k5KsxA2+RNtC9cPP1518WS3MWud6dCYmR/l2hA7BPZju2KWqesglalXnJz3vufU+K/HcsB98QO3Id3CkmnhFG9xysz22Uxq+mFLs0DumDsDnHXQ3bG6St86F5bLDHzh7LPvdYyTfat18DZjez3OkyHhcJWB7HhGNm+Nbs06N4T7FFZeBT+YLns6ADQ5z/EIkwxqGGAfknjQWqqbjAuINcr4u7LxEw925mljyEPEa37y2tRACm8q2G1fcrzVD2VOhig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:03 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:01 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 2/8] ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
Date: Tue, 11 Aug 2026 12:03:30 -0400
Message-ID: <20260811160336.782342-3-timday@thelustrecollective.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6123f9cd-6887-44ad-1116-08def7c228a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	BN8Ow+BW11nwxXBhlFG/4X/9ok6geBWfdREoLQohBGDN/q9pkzI3JJ8rdfZewy5aOGZxKsdQ82kRmKSgBbjwBCTmVd7ckZKQJhoJ+8RtH0Zdr1DS8sOVjyY9pPVpji4TN+xLrWGoF7RptNO6c1U/QFM9k6MXhx+f2qW7Fikgw0gmikoBWAhcoQ8F8P7RsAdwdJN/KB5ffeT9WLE0Pl9C/SBsToRKuqQxpt7yv4mJOM1lhdNnkTtac6Edd0+IPMc3Oa0l5Yu2nU36/thYt8o1G/KG+DAWvPSjOKvmIvya99fYRL/rnJ+krcaUOyWrof4Fms6+FToHUiy0Go7XsQSJd/4KDf6t4bfQBlMqQ/0taphklR1AxhSr8sOJx/mf8Clc9zP+mdkj59tXEs4+1+GfwrPPa6IiIJXSiXErBlen5l43YYrzBo3hyto8WG35yCHusIRuV2eorKLlkM0AoRmJowKd/myAFc3LXA8JEfqQP3IXaR/FblexlIwQJI2qQdcLmEHhmsdCYLTK86FcZkqr8ZQYfRfzqxwskDpz55Iw5xs78dbNAxPzEVt6M1O362Y0KA2f1dU6bmGNCRYD9l+eDQHzW4kvB3RTbMYEDn7VMe1yk1yPL0AwK6gjqrcFp8zAKaPwHIhBfsJzBq83rm07YF6INqE/APLoEO53/JD9Xe8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KeRaIvtb4hE6pFxiJf2pcI0Djyrb19qCoKtkrv6QN99eIXwCy7YjIdQcWWnz?=
 =?us-ascii?Q?2qnyAOb94R32bcUOsPyOXbniwoDsYPXspGcJBbqtC1apePHD4pQTszePvIwy?=
 =?us-ascii?Q?zJTffNiDGRkx6ik3WoFEIq9hFPd6QyJL0U/5+d0q8/zXEOX4JuTw0sDw7e/a?=
 =?us-ascii?Q?/74BsZAcpty/PeIEjmiqTiojN6UYIg87ij2Z0DTIj6cDrdov3aBSNgEZg1x8?=
 =?us-ascii?Q?53ARveqEEGwbo0D0d9XIOGmDObZzkdpKNAtwm390+vSqE9Q5VJ/U9Ma55/Dq?=
 =?us-ascii?Q?pr0B98hDa48H2dp9FVeAVz+BVnTDD9/cLW7wq8kfiDPfULDwCcVeYboKm8Q+?=
 =?us-ascii?Q?aZQOsZejti/lppYkZHxpAteiakrOAFOC2/r4Bo41YRCw+5F47YPOdoFpRVZK?=
 =?us-ascii?Q?p/Izubch9Xn98DBYMXu/CgNXZaTK//B9lTwhz+M21G63CnDof81x3Onn2rb9?=
 =?us-ascii?Q?QT1bOxjx2lq1YMO2Bzzr3vP6YzTOUgtZZSfTWzGZzGgKdPydcJXo67MKpcAP?=
 =?us-ascii?Q?DC9u8e9CZhZlpJifWUCU5BG1myV/VBMoX56BVhE6h4m+0MKuID66pg5bbhh+?=
 =?us-ascii?Q?ntfYDHMYBybp6/yV+KftEB94cqS4QTCt73S+GJfzP6uDKF/8jxxnucr458jL?=
 =?us-ascii?Q?qEJpB7K83/kI5MOlNo5D6dIJZK2S6vsfv6IX4K9ZDqsKWZDY7bw3mMwkJrjG?=
 =?us-ascii?Q?AjObMVL1voWYNDOsV6IPIudsVbM+rsTrM0ULjt1aOCPtFUeLhGmRRppVGiw+?=
 =?us-ascii?Q?mEzWrPlkxTyLEAd9xr+CcZbpb5CRC2wst1cEU1zKv41o4H1rYejfLv+SLDMU?=
 =?us-ascii?Q?U8RLcZBpP2c6x13zYPtFA+c1QdeYNCWTB8Awg0ZwCZr/XFgr/7XiWhnBIUFd?=
 =?us-ascii?Q?kLI/2jjqSnEXAcpoG6EJ7P+I8dxr8kyBkJnvi0Bwh2W63g8Fo6xlmLsTCQeO?=
 =?us-ascii?Q?apGdkMBaZFvTiFOedPUmn6iC3bxMoSvyLtv0CQe/t3giuUcVOlW6hA44RDXt?=
 =?us-ascii?Q?4UTHboNAdkzeU5REZdxs3KF5iyt8TP/qp6FW48uI4eM2xeke8OE2saW5IY1Q?=
 =?us-ascii?Q?W5XSmzwq/5oAVpaEcgcW37prXFJOAcKe/CKSVSNJoVHKG5JGTXbYcW877oz5?=
 =?us-ascii?Q?/RsR8ohWkBYz34pTyQoo8AqQK34feO8wilFzNffF2B/udb1isGNWXoNObJf9?=
 =?us-ascii?Q?YVwJwo3yPGHAlFNAAlDtIzIdIHAeYwVZhy/C6Dv8nSYu1mz/5sbwp5OGztf0?=
 =?us-ascii?Q?Uw7v42SawJ4xgvvF0UjLPwQzf6i8Ih03M3m5rJL4qHJf6sw7YOVMZtbP3qFK?=
 =?us-ascii?Q?2+lTH2XK3T/aooVq7QPqkztxtC3nuFtMQLhrOKFdryW4bxJR6ltr72qFIs3m?=
 =?us-ascii?Q?ElblCuPJRqYo6HjR6PQkc5TMEubVvfZUvf5p7+rop9Zb2XojB2NL8DKdUfYD?=
 =?us-ascii?Q?4qn1nujavbEx7O72/6loVAdQdUCaTPAzvdc6rN3LC1iPg1KhvyHI7oCBUmKW?=
 =?us-ascii?Q?8Qw9x+vOczlNJQuOF+o4bNzGaGiAW2CvhB21ejpOK+aYrgW/FzYljodIluiH?=
 =?us-ascii?Q?r3yyg3RntHeCP1jh46ai7It/r0Ow5T2arIgcp6Bz6cxI7V0xy6MbaAgGxlpz?=
 =?us-ascii?Q?XEcxGIQZP3gT001vFSIn855THFVRmp3ieQGFgsaZTEH+OpxVtlW0X8JXELJg?=
 =?us-ascii?Q?C8nHR9wzDLVQV6pxQEz6aQ2IYEaJ7lOaSxqcrNkJmfm/jU+Ls87hMbkPxPQV?=
 =?us-ascii?Q?8b/GBlXFJM0YKn6G+mNhn8F4e87YPNY=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6123f9cd-6887-44ad-1116-08def7c228a5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:01.3192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVLMai7S87lVeH3adUfesKvWYNMDX3O2OvukG86Kl9XGu9On08zKFicvZH/FQeqcOS4BB4hLaIphAGWU21PIVNXgD+Furw6LIzS1G+P7OZk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

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
index e851d2a6be66..c8bf2e69675d 100644
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
index b8bb1f88a620..5bf63943828b 100644
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
2.43.0

