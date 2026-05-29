Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12663A6F10
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780056515; cv=fail; b=ksCIA18QyhPexsTP5hcrSvnNxnwwMGp1OUDSVKBDdSYKxrPf41E0b3RJEip26Xhd7cREApGurfwqy2WtCoGeZ4b4IgtN8t8dhj1MhEGE9jTIlud/mINdh5uKO5sVN/MjzUT3045zDErugV3vz5cLCZZDHOXjbqfujAhCOKByyf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780056515; c=relaxed/simple;
	bh=WPRjYC07mL1w53wW34Cv4QxoDONydCO2uKT1yX90cJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OUeOxoIVav7RiOT1AtAYUmszCOblwPq835lMBjeN8MXQqonmbk/C3wskg2Q9EpEBFOti8hJYmWFfoYiaTWDwik3xn0GBGrKQrShL9aI7Sr5qBd7HRQQtXZ9FqILCjbOAxQUU8V2KJZz32qe7oW3xlgli0Qn9lXnJWQ/N6qq6LMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ExRSAcYA; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ExRSAcYA"
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020116.outbound.protection.outlook.com [52.101.56.116]) by mx-outbound18-242.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 29 May 2026 12:08:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBSNz6IsarNbW+Ab1n/h9NRi89qX1lOyZ2hBow1w1uOVV6wg8WiNZyP5XjxP4+EqMUI9lWlw0NqAihjd2dhVgMq1q8zFjIH8ogA+tXGhQsDnv1/IswG5IVnG3D5dLIGkHsB1szEK4mc2vB9nnKhvGZKQ/jvFjH8igsTPJb2G44iWzYLvZg+0fSVDXH+u1u9CwXxY5iGtSVLTf7O0BKE47QAqoDmNUOrGDp7wjtg5Hl7ZKiFBBMWtmx1iVnQVozPummOVTh9n3CsmzQzEC/oaW1YVn5J8PCJFzntnwE1rk6g2U4Mtos3xOKbaEjwF9aGH6kEF3Yemz2e/Smr9ixgkEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kS+kQOiBdB6M0wK9I2dnwxhE9JGLbkbrr+8UYq3oko0=;
 b=RpPFnKLf8fEaDCnPCYBBByeuV4lkUkoc3oP40AT9FKisNONbu3bRQ1dELzl9gvztQ74Jvr4+fiNi3ysrkZ6O+BvgBwb7sfpX3HcDQ9MhCOmx3HLK5C1/ClCipcWpwUBpnF3rJF7FcCGP4wTTB1CgYWDqsaQns60O1rEFHes+l6dT/JYlWxdUGetIOue4EIQ+P1m656wVGtjHo3GPZlXFogUUGzHaiI/uLUPgcSEY9wWkmLbcPBgz1pB4rLfHSUktCk1T34kXqe62EJdr67u4nm85QJ/jEYzGgLg8fepdgchid5dhJ/LNQ5yeM1zFCL3d9k36TBPvuPzXxXCS03r5gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kS+kQOiBdB6M0wK9I2dnwxhE9JGLbkbrr+8UYq3oko0=;
 b=ExRSAcYAL/Qlq+7MZMPBMbzVFqFeEw6Hr+IdrZZrRUdGtxg9mQZUXMKRIfygewNoJ3cH0YOwvwE6fy7KphruRx3zoSn7gN0LHNMOgDRLqVGqEE2XEA40RUrou1kX4+vcUYlKhAvqb4WMJSdDR5bgH2pG9XarEb+OSJn82sCmKaU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by PH8PR19MB6860.namprd19.prod.outlook.com (2603:10b6:510:1c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 11:54:12 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 11:54:12 +0000
Date: Fri, 29 May 2026 13:54:07 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com, dongyangli@ddn.com
Subject: [PATCH 1/4] e2fsck: fix orphaned extent files handling
Message-ID: <ahl-X8rCc0DGt7y3@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PR3P189CA0072.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::17) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|PH8PR19MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: cb8dee15-0716-4f60-7ed5-08debd78ffe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|19092799006|18002099003|56012099006|11063799006|4133799003;
X-Microsoft-Antispam-Message-Info:
 2xffPhngkII9Kp/ntzdCNtUlCAprV9wdcAXX1mu23ba68tiQ0CuwUthXY2DWLopZIOiVIwBtGo3VJDqJDmxBgIRRPXolOheJ0AyA13wNCg4T1knj+FjNACP4sf/sayecwaxNuaabDt5VFDkzr5W1IeJ/UMggtyWixc3TDn3VS1yYd3nXD7zyomxg1GeNz7TFiQ77l7QjvWSatWOfcD9OpEB0CcyQkgIPHiSVf5Sbv1VyrGFZSHdvczhiBOZjl3i8qdTJeDThYYZeyKt5h6nZJ8oB/duiJyD78SoHVHUoa2t4BXR6aDf0ZE5q1gJ6uYj0hDGKuHUQVRLdP0qRkvq4IUKVuwf7qC1E+XBuA3P2zwRhQWAk4b7NI9Bb6amkM8mPzwUftrBrXJ5rnmZ9Ye6OWHnzsCSf3Fu3aopdiOhgly4gyougez3GvU0OwV2iV0s07OgHZZeqltT++eTTogO8Rv5Ws6ZiXqd6soGNNpG54Y6/kpB3qDlTUxXignN5tSlK/NbfvDNWIs4/oBIb9ofxsPYB0w/UvbhmuCWJKjqUmiAzy0jOeLKhLiMHHaIm8jtIDth2FKmBl0H7Ryz3bWnp4o/ffmVwhohkIRyzprfSTeCHZPjEpYBHTXk3IFHIpJ9VuTedbe+U5HZZh4U892xf3zFVWkrSU5DDhl7go+ZTI6cfUjaQxhVxmNXSGtbCn9vu
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(19092799006)(18002099003)(56012099006)(11063799006)(4133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?oXEJWIK1kIt2owBDxNWqI29bYGJHmQOhPQtAg//EiFMzmhWWgjaFKy880K+P?=
 =?us-ascii?Q?q5TwxmdhpIlhQFikpueLeZyI5kztQ1ZDbBB9eS5ALZx17TnN9qlPEiZYc8Ag?=
 =?us-ascii?Q?vFGcwcJxTu5jGlNETC5q9pjbp1L+rxd8LcPu+UM/zjyQbTlj7h2Ew4Sfmqmb?=
 =?us-ascii?Q?t7ggqNypBQtbDrP77f6wIRlfci2bu5LeLhLlYhPreU+N3adEyQS0MfoNjtAv?=
 =?us-ascii?Q?3arzZFmMFDpO4+Y8jMkvS2qByvzEpx/CaXqiX7V+Tq5CYd00IARTHR263WaU?=
 =?us-ascii?Q?QKK5vtqdgcLsP9QR4flZ4PTJEZNF1FFMz7kodmZb82epwJYg5+dAgjkHVo4c?=
 =?us-ascii?Q?PEwhCrOBhnZ9aAkg1ldAYloFrI8Uf6vrTF6BC1GdLaFvb0/emmpRF4PKDYvs?=
 =?us-ascii?Q?IKCwdpgQ09bGHqv9qbJ3pLseKbAyCdMFGDq7sYJJhrJ1Hcx7YDHdQwAITdQS?=
 =?us-ascii?Q?Hp0/Sy43E7j9cN/KASO03LqANRe2p+fV+WVi2WRYawLLcBiVHpInQc02oAPi?=
 =?us-ascii?Q?8LWiRQhRZ43d/QgIv2OpeAfFPvkX8vIFwOG6RhcxnJqmsMZCaDrDILF2JKSg?=
 =?us-ascii?Q?/lquUsUKv3RWI6yXix24ynLe3dT4GemkavrxUXr7wVsE3fuF6kJpWpaRj4e8?=
 =?us-ascii?Q?K2V/Uv4TZA013bo1uVE3n9t1Kul1l4/b+Ni8/1L10ibGPwJLrybsg30k/c4T?=
 =?us-ascii?Q?oWsRFG8ou8z2FN7XnLvNf7K6ahYn8FTN1s6o1/8LthlGpS97VHMKDuq0JXCF?=
 =?us-ascii?Q?XQgta9lnoOAyerhSFWJj2jQBotWy5MVUDKBXLPDgMh1Dgd84eavBdX8ne/nO?=
 =?us-ascii?Q?HrN23BpBBuEHARzwDGnNsCacW1e+5qEzc9DHAD0nJzqF3RzPwN0BarUgVZz4?=
 =?us-ascii?Q?OZ0FwJiM7FrjWDAAYA7DDE4o1X/96Z0PJDelXuVoLwGaXqHzVXUN7iqrMmoQ?=
 =?us-ascii?Q?+AF6IsNGtMlPsGGCzN/1lzoA5gKm2h7fLsbuIFoclU0u7Tlzz0XQDhrl4OEe?=
 =?us-ascii?Q?vCC8xCPw8W1sudyeUjAem8GyXKQ3iSaJNAo+4XVR+QfWnVc43faCcDUdgmnI?=
 =?us-ascii?Q?DIacrbSGokgJrsLMiQk8s6K7GzhB42rElxVQLDtjbj5qURkY+HPi/fWktXqG?=
 =?us-ascii?Q?8ultOSOPff3twQXADGlZnyIqvNFTqQoDmTK7dBcs7v+pf8D3eOePg9Fiiqk3?=
 =?us-ascii?Q?17NKCq1HmeJAeT8oBE0blYUx1fxd+eKd2okNRzsRrbVXdQNOkk5WkY8iHfjB?=
 =?us-ascii?Q?ndculWuR3gS6WY8iKscQYGdMLLzbM4hGETFL3wB8NS+0qydwPQpb015awkQQ?=
 =?us-ascii?Q?dD0SXe1e4G3U9EdpFFjlHeN7gnE22Kifme5dW6JwxaqTp6Ai4/ijdfmXf9BD?=
 =?us-ascii?Q?pmO6rJWJ6bvllwU02WHRGnBMeLRNImjE/9e/jnl/tyyYM3/BVWWP+rQ+Qoix?=
 =?us-ascii?Q?EuULz1J722W4FbqZLs6PrXQMtAPQvO5NYa1Bnx5paHoIzJ7RtKoSUM8O1GQt?=
 =?us-ascii?Q?ZByi4gyQW9LfVloV8Qq6FmUG3Ibq3Q0o+h6Po1zNEtlMNDmRkm/cfjKo/fKe?=
 =?us-ascii?Q?+yhFe23rXfEWbCV4RdEcnEKxw4IcClf/ookfmjCfLgVPHIbwc48ScJVeFWKN?=
 =?us-ascii?Q?sNms1d5FTJC//VaFv9zbfwzejT2A+aD2aEClYtQucGwiSTM3C4oD9vHii//O?=
 =?us-ascii?Q?xLjZv111TlGZ4TsGnJE3ooA4/ZUPZ/9jbFInwhoJ7DU7cMJ7k9Nc80D/SSPC?=
 =?us-ascii?Q?qv4Q7Jpw5b0dWNrsx+S96h9y5NkOomQ27U/olOgJ/zvDDcf/2ChQ?=
X-Exchange-RoutingPolicyChecked:
 r3qYUJzv+6IrbeENM4C6V1ZYTpA9nItSf+PFewyQXkITE6xa9bi+LFPTJIOGFxNcbgEwGz1Gw3wh9EUiNO/9PacZy46j/pIj/MH3SouaxapojMRoPpNssJacof7LLQTB3MX2cFUs0q34qZGtT/Zc3xZqTwTp9ifxcYxwYr8cE08Tv7bz8H+MqpoxzaEGqLV6fMw64cA1gZxh7pWy7KpHjGSTLXrH9hsxGrhH9MsbFEtK0PCN3V6a/VWARx739lUiPp32cGHqQcqJ0KHXWZhYaMcFBTqMZU4zrbxvKSvcd94qEPCKLnrDADeVvfspUEEqRd2saIN2QRKF9q8OhF4PCg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 WFbBUCwSExUZMr3nsqbqoGFRGe+iCmG2l9ZVSJGauFjuL+6CIYvLC5JcdR8BP2OHFhJxNKTQrYOdp5TMtGaXb+Ne29c+4SP70A0VvWqe+xN5Mc2oSv2g6xjKM3VjVAzIuEf6tUwVbVaYPjb3Hnl4wNU50S8HxF23VzoHRqcxgRClJ1jDfb387kiSpsogUbIXXpHw9eVKApY25k455xetOR9kpUkNiQMK36nSkqCGviVhOUpnRmsRM5sq8SKpXxoPia2SjzGqqjq77rO0Vaxu32EwWrPCOYz53TpMIM1K3bC5Px1ZE2UReXZ/B3MDKUcWBDYZKHeGZ4kEm/VTB+64oA0dCByUd8YH30Jy5E1Pix2D/cgT3ay4FdWcCwit5iCiYH633TiqXZGIB4vBF9QYFOcaGv9UupisGAJfUxf1CBh7v6O4NjhsTgThdF3bEDxDTih/jFZCddIJcaW0n3UuhvZ1RTaOXo/RsbP65iOwyrR9xMgfxjVshQKdyEQXf/cjYME7Edu9aSpvf0Y0svSMqIUyRoZHW8nc6XMpPw6hRLdeCSvc/kR5mdIlRKQ8Js5ohavp0u33u6nU+uutlXmP3jniulYKfuN03SGFNi1RGRQh+L+hgjJN9mb9a0pD/fDR9FFR1ON6WJHHos9iWw4MWg==
X-MS-Exchange-CrossTenant-Network-Message-Id: cb8dee15-0716-4f60-7ed5-08debd78ffe6
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 11:54:12.1539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0XZMOLyBY+Ks+2HWN6hByoxYFGNWKvHD0nAN/ypro97hqcECd6GeFOuhQBxqeyFWeeq8Vr664VTN2gi64VQNxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6860
X-OriginatorOrg: ddn.com
X-BESS-ID: 1780056510-104850-7742-6090-1
X-BESS-VER: 2019.1_20260519.1529
X-BESS-Apparent-Source-IP: 52.101.56.116
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGFmamQGYGUDQx2Twx1czAxM
	DY3DjNwjDFzNTC0MDC0Mg8MdEgKcXcUKk2FgBwsD/kQgAAAA==
X-BESS-Outbound-Spam-Score: 1.43
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273537 [from 
	cloudscan15-166.us-east-2a.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 OBSCURED_EMAIL         BODY: Message seems to contain rot13ed address 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.68 OBSCURED_EMAIL_2       META: BODY: Message seems to contain rot13ed address 
	0.75 BSF_RULE_7580F         META: Custom Rule 7580F 
X-BESS-Outbound-Spam-Status: SCORE=1.43 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=OBSCURED_EMAIL, BSF_BESS_OUTBOUND, OBSCURED_EMAIL_2, BSF_RULE_7580F
X-BESS-BRTS-Status:1

release_inode_blocks() does not handle corectly multi-levels extent
files: it does not count the non-leaf blocks directly released by
ext2fs_block_iterate3().

This patch relies on ext2fs_get_stat_i_blocks() count for quota update
and ext2fs_free_blocks_count() to count number of blocks released by
release_inode_blocks().

Add regression test: f_orphan_truncate_extents_inode

Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Change-Id: Ib0c3aaaa685e7bcfae896617cda03005d19539ff
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-20049
---
 e2fsck/super.c                                | 244 +++++++++---------
 .../f_orphan_truncate_extents_inode/expect.1  |   3 +
 .../f_orphan_truncate_extents_inode/expect.2  |   7 +
 .../f_orphan_truncate_extents_inode/image.gz  | Bin 0 -> 2854 bytes
 tests/f_orphan_truncate_extents_inode/name    |   1 +
 tests/f_orphan_truncate_extents_inode/script  |   3 +
 6 files changed, 133 insertions(+), 125 deletions(-)
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.1
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.2
 create mode 100644 tests/f_orphan_truncate_extents_inode/image.gz
 create mode 100644 tests/f_orphan_truncate_extents_inode/name
 create mode 100644 tests/f_orphan_truncate_extents_inode/script

diff --git a/e2fsck/super.c b/e2fsck/super.c
index cfc0919a2..c2ccefd54 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -62,21 +62,14 @@ static int check_super_value64(e2fsck_t ctx, const char *descr,
 	return 1;
 }
 
-/*
- * helper function to release an inode
- */
 struct process_block_struct {
-	e2fsck_t 	ctx;
-	char 		*buf;
+	e2fsck_t	ctx;
+	char		*buf;
 	struct problem_context *pctx;
-	int		truncating;
-	int		truncate_offset;
 	e2_blkcnt_t	truncate_block;
-	int		truncated_blocks;
-	int		abort;
+	e2_blkcnt_t	truncated_blocks;
 	errcode_t	errcode;
 	blk64_t last_cluster;
-	struct ext2_inode_large *inode;
 };
 
 static int release_inode_block(ext2_filsys fs,
@@ -91,7 +84,6 @@ static int release_inode_block(ext2_filsys fs,
 	struct problem_context	*pctx;
 	blk64_t			blk = *block_nr;
 	blk64_t			cluster = EXT2FS_B2C(fs, *block_nr);
-	int			retval = 0;
 
 	pb = (struct process_block_struct *) priv_data;
 	ctx = pb->ctx;
@@ -111,155 +103,157 @@ static int release_inode_block(ext2_filsys fs,
 	if ((blk < fs->super->s_first_data_block) ||
 	    (blk >= ext2fs_blocks_count(fs->super))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_BLOCK_NUM, pctx);
-	return_abort:
-		pb->abort = 1;
+		pb->errcode = EXT2_ET_BAD_BLOCK_NUM;
 		return BLOCK_ABORT;
 	}
 
 	if (!ext2fs_test_block_bitmap2(fs->block_map, blk)) {
 		fix_problem(ctx, PR_0_ORPHAN_ALREADY_CLEARED_BLOCK, pctx);
-		goto return_abort;
+		pb->errcode = EXT2_ET_BAD_BLOCK_NUM;
+		return BLOCK_ABORT;
 	}
 
 	/*
-	 * If we are deleting an orphan, then we leave the fields alone.
-	 * If we are truncating an orphan, then update the inode fields
-	 * and clean up any partial block data.
+	 * We don't remove direct blocks until we've reached
+	 * the truncation block.
 	 */
-	if (pb->truncating) {
-		/*
-		 * We only remove indirect blocks if they are
-		 * completely empty.
-		 */
-		if (blockcnt < 0) {
-			int	i, limit;
-			blk_t	*bp;
-
-			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
-							pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-
-			limit = fs->blocksize >> 2;
-			for (i = 0, bp = (blk_t *) pb->buf;
-			     i < limit;	 i++, bp++)
-				if (*bp)
-					return 0;
-		}
-		/*
-		 * We don't remove direct blocks until we've reached
-		 * the truncation block.
-		 */
-		if (blockcnt >= 0 && blockcnt < pb->truncate_block)
-			return 0;
-		/*
-		 * If part of the last block needs truncating, we do
-		 * it here.
-		 */
-		if ((blockcnt == pb->truncate_block) && pb->truncate_offset) {
-			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
-							pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-			memset(pb->buf + pb->truncate_offset, 0,
-			       fs->blocksize - pb->truncate_offset);
-			pb->errcode = io_channel_write_blk64(fs->io, blk, 1,
-							 pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-		}
-		pb->truncated_blocks++;
-		*block_nr = 0;
-		retval |= BLOCK_CHANGED;
+	if (blockcnt >= 0 && blockcnt < pb->truncate_block)
+		return 0;
+
+	/*
+	 * We only remove indirect blocks if they are
+	 * completely empty.
+	 */
+	if (blockcnt < 0) {
+		int	i, limit;
+		blk_t	*bp;
+
+		pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
+						    pb->buf);
+		if (pb->errcode)
+			return BLOCK_ABORT;
+
+		limit = fs->blocksize >> 2;
+		for (i = 0, bp = (blk_t *) pb->buf;
+		     i < limit;	 i++, bp++)
+			if (*bp)
+				return 0;
 	}
 
-	if (ctx->qctx)
-		quota_data_sub(ctx->qctx, pb->inode, 0, ctx->fs->blocksize);
 	ext2fs_block_alloc_stats2(fs, blk, -1);
-	ctx->free_blocks++;
-	return retval;
+	pb->truncated_blocks++;
+	*block_nr = 0;
+
+	return BLOCK_CHANGED;
 }
 
-/*
- * This function releases an inode.  Returns 1 if an inconsistency was
- * found.  If the inode has a link count, then it is being truncated and
- * not deleted.
- */
-static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
-				struct ext2_inode_large *inode, char *block_buf,
-				struct problem_context *pctx)
+static errcode_t truncate_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
+				       struct ext2_inode_large *inode,
+				       char *block_buf,
+				       struct problem_context *pctx)
 {
-	struct process_block_struct 	pb;
-	ext2_filsys			fs = ctx->fs;
-	blk64_t				blk;
-	errcode_t			retval;
-	__u32				count;
+	ext2_filsys fs = ctx->fs;
+	struct process_block_struct pb = { 0 };
+	e2_blkcnt_t truncate_block = 0;
+	__u32 truncate_offset = 0;
+	blk64_t blk;
+	int ret_flags;
+	errcode_t retval = 0;
 
 	if (!ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(inode)))
-		goto release_acl;
+		return 0;
 
-	pb.buf = block_buf + 3 * ctx->fs->blocksize;
-	pb.ctx = ctx;
-	pb.abort = 0;
-	pb.errcode = 0;
-	pb.pctx = pctx;
-	pb.last_cluster = 0;
-	pb.inode = inode;
 	if (inode->i_links_count) {
-		pb.truncating = 1;
-		pb.truncate_block = (e2_blkcnt_t)
+		truncate_offset = inode->i_size % fs->blocksize;
+		truncate_block = (e2_blkcnt_t)
 			((EXT2_I_SIZE(inode) + fs->blocksize - 1) /
 			 fs->blocksize);
-		pb.truncate_offset = inode->i_size % fs->blocksize;
-	} else {
-		pb.truncating = 0;
-		pb.truncate_block = 0;
-		pb.truncate_offset = 0;
 	}
-	pb.truncated_blocks = 0;
+
+	pb.buf = block_buf;
+	pb.ctx = ctx;
+	pb.pctx = pctx;
+	pb.truncate_block = truncate_block;
 	retval = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_DEPTH_TRAVERSE,
 				      block_buf, release_inode_block, &pb);
 	if (retval) {
 		com_err("release_inode_blocks", retval,
 			_("while calling ext2fs_block_iterate for inode %u"),
 			ino);
-		return 1;
+		return retval;
 	}
-	if (pb.abort)
-		return 1;
+	if (pb.errcode)
+		return pb.errcode;
 
 	/* Refresh the inode since ext2fs_block_iterate may have changed it */
 	e2fsck_read_inode_full(ctx, ino, EXT2_INODE(inode), sizeof(*inode),
 			"release_inode_blocks");
 
-	if (pb.truncated_blocks)
-		ext2fs_iblk_sub_blocks(fs, EXT2_INODE(inode),
-				pb.truncated_blocks);
-release_acl:
-	blk = ext2fs_file_acl_block(fs, EXT2_INODE(inode));
-	if (blk) {
-		retval = ext2fs_adjust_ea_refcount3(fs, blk, block_buf, -1,
-				&count, ino);
-		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
-			retval = 0;
-			count = 1;
-		}
-		if (retval) {
-			com_err("release_inode_blocks", retval,
-		_("while calling ext2fs_adjust_ea_refcount2 for inode %u"),
-				ino);
-			return 1;
-		}
-		if (count == 0) {
-			if (ctx->qctx)
-				quota_data_sub(ctx->qctx, inode, 0,
-						ctx->fs->blocksize);
-			ext2fs_block_alloc_stats2(fs, blk, -1);
-			ctx->free_blocks++;
-		}
-		ext2fs_file_acl_block_set(fs, EXT2_INODE(inode), 0);
+	ext2fs_iblk_sub_blocks(fs, EXT2_INODE(inode), pb.truncated_blocks);
+	if (!truncate_offset)
+		return 0;
+
+	/* Is there an initialized block at the end? */
+	retval = ext2fs_bmap2(fs, ino, NULL, NULL, 0,
+			   truncate_block, &ret_flags, &blk);
+	if (retval)
+		return retval;
+	if ((blk == 0) || (ret_flags & BMAP_RET_UNINIT))
+		return 0;
+
+	retval = io_channel_read_blk64(fs->io, blk, 1, block_buf);
+	if (retval)
+		return retval;
+
+	memset(block_buf + truncate_offset, 0, fs->blocksize - truncate_offset);
+	retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
+
+	return retval;
+}
+
+/*
+ * This function releases an inode.  Returns 1 if an inconsistency was
+ * found.  If the inode has a link count, then it is being truncated and
+ * not deleted.
+ */
+static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
+				struct ext2_inode_large *inode, char *block_buf,
+				struct problem_context *pctx)
+{
+	ext2_filsys			fs = ctx->fs;
+	blk64_t				free_blks, ino_blks;
+	char				*buf;
+	errcode_t			err;
+	int				rc = 0;
+
+	free_blks = ext2fs_free_blocks_count(fs->super);
+	ino_blks = ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
+	buf = block_buf + 3 * ctx->fs->blocksize;
+	if (truncate_inode_blocks(ctx, ino, inode, buf, pctx)) {
+		rc = 1;
+		goto update_counts;
 	}
-	return 0;
+	if (inode->i_links_count)
+		goto update_counts;
+
+	err = ext2fs_free_ext_attr(fs, ino, inode);
+	if (err) {
+		com_err(__func__, err,
+			_("while calling ext2fs_free_ext_attr for inode %u"),
+			ino);
+		rc = 1;
+		goto update_counts;
+	}
+
+	rc = 0;
+
+update_counts:
+	ctx->free_blocks += ext2fs_free_blocks_count(fs->super) - free_blks;
+	ino_blks -= ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
+	if (ctx->qctx)
+		quota_data_sub(ctx->qctx, inode, 0, ino_blks << 9);
+
+	return rc;
 }
 
 /* Load all quota data in preparation for orphan clearing. */
diff --git a/tests/f_orphan_truncate_extents_inode/expect.1 b/tests/f_orphan_truncate_extents_inode/expect.1
new file mode 100644
index 000000000..b24aae7ad
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/expect.1
@@ -0,0 +1,3 @@
+test_filesys: Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=4096)
+test_filesys: clean, 12/128 files, 75/1024 blocks
+Exit status is 0
diff --git a/tests/f_orphan_truncate_extents_inode/expect.2 b/tests/f_orphan_truncate_extents_inode/expect.2
new file mode 100644
index 000000000..7edff9bce
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 75/1024 blocks
+Exit status is 0
diff --git a/tests/f_orphan_truncate_extents_inode/image.gz b/tests/f_orphan_truncate_extents_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..30681b879455b936e05d4dcbb4feaed6c4ff1eb9
GIT binary patch
literal 2854
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
Qs3(SfSGqhPU{%0>0O93B*Z=?k

literal 0
HcmV?d00001

diff --git a/tests/f_orphan_truncate_extents_inode/name b/tests/f_orphan_truncate_extents_inode/name
new file mode 100644
index 000000000..6f16502b3
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/name
@@ -0,0 +1 @@
+truncating an orphaned extent-mapped inode in preen mode
diff --git a/tests/f_orphan_truncate_extents_inode/script b/tests/f_orphan_truncate_extents_inode/script
new file mode 100644
index 000000000..fb895e9a4
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/script
@@ -0,0 +1,3 @@
+FSCK_OPT=-p
+SECOND_FSCK_OPT="-yf -E no_optimize_extents"
+. $cmd_dir/run_e2fsck
-- 
2.43.7

