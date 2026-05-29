Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6CD3F0AB6
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065146; cv=fail; b=qE77U6W8t0YRPoUTwpP2p7wfg+vPbwa6hNbvVOgUc9Srbai+rWh1fWNpIHXHlKBATvwhuP2KViy9vxZOXxQ5OQRjnQiwW3eJ1j3XRSgobSU7bW1yArHn4W8Bcg8Dd1LahNwJIx3AVgpxkNKnyokex2CCiOltbsreiNeMkDq8KIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065146; c=relaxed/simple;
	bh=H8Zc0BMDKyYtLwOcI52vXB5IO2YRy0zBXfW/dkngE6c=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=JBVLBJLOtaA9A7bnM9kCJH3sXhbfO86K3gUgnd2R6cfZEAXFGIReC2hfWmF2Y/74nbwyjMq+pRJ39iARZHnn8TTbnqEaNgxhiTs1jtKiWxE0WBq10Tu60oPyBqKs4C5XikfLKOkrSp8+rJz58ChKGYoV7dGrHXXnvCqiTKRHMg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=ac/54Xf6; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="ac/54Xf6"
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020122.outbound.protection.outlook.com [52.101.46.122]) by mx-outbound45-218.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 29 May 2026 14:32:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTyCSrxIrdPIf3CM8Ntiw7QolI5PxrpLC+Nfgushm/OasiJ2UrCCqwlbje71ZQ06NEBiL5VDEAau4r/MiRNaJt2MYJ5XpbtyKpXETokj9GBAo7/iZJVC9vWmunedE6IjQtOJiTdYHiR+QS4sd9++lx/auA5bebDBTcK30nQ9/yo/Ckr+a5N4hT9gffqRij99U1JrWc7MXMhmrGdiLRCOCP2yqE3T39i0sj84H6BuflTXHHYZKL9hBCkyavCigI0nGaH85pE39BiFS/TISo16bGXhfq1R9Rm4xGOncVvp+xEurzl0QkPyFnXelap1WPxaJ0QYYiPp2TG+BmQCZ86Dew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxWTuvPCxliBxz8muIjX+86jVNEIYx5ZU6r85zvi5HQ=;
 b=mqDqhwcf7+iAx6hJ0z1LO/Ns6FVo6zzXWnDPIE4/tfFS9YeWGOs0x0uPqD53kckjWRFDDJ8QUk/cDQzTtqOhBAzTxwuNI3rZvo/CHjbL04LTNczFUTAGTvxgyAHkfteNkNFIGjgFWbLdmXtHFJePqpUcBYMHcvmdb7zYJIHxMy4Hvqy9yEkTWaD5OR1wr8iryBRzoMCXQiv85aaOnejEKIyWWOi5dnJg2DhF27wxizWKhOol+hy5w2Itxdk0hcfODg19Q3dJooTnYsvTWFeJ48Ohn95DIMv8bqC4PqLHLQMhU4ICVxghug8lR796yMTxK09UqfMVA+xYEZSGm0VLUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxWTuvPCxliBxz8muIjX+86jVNEIYx5ZU6r85zvi5HQ=;
 b=ac/54Xf6bMdXvYhZNcy+RLTk+ji8TFaTRNEgL10z6STPpyyoU53WbbDawm/ruU6IE5hDe7VHpdwHhcK/4IkfAnfNG9tmzcqOrKrOy5jRqOz+zWnjJs5j/+44qWbBODepbqWq8uEPZI2QdojS2TKzjSjWvEH7diDBR2TWU/7rPgY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by PH8PR19MB6860.namprd19.prod.outlook.com (2603:10b6:510:1c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 11:57:19 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 11:57:19 +0000
Date: Fri, 29 May 2026 13:57:14 +0200
From: eaujames@ddn.com
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com, dongyangli@ddn.com
Subject: [PATCH 2/4] libext2fs: add quota to libext2fs
Message-ID: <ahl_GhW8EhYTEun7@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PR3P195CA0020.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:102:b6::25) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|PH8PR19MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 92d48a76-c6aa-4480-b7c7-08debd796f61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|19092799006|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
 YISNfBLtT8r0PrM0quuOPGaGkVIifegVDpGg+O0HKysggHgAzqHHk2cGW76CmNZsCX/cDPunEIi8ejdOlby15lAOUQkwci2PfEmV+duSmda5Vg2JWYZtz8qqQWDpJQVrCt4MH55+LNGC4ALMyCqgmn9AhUOqOwk5EI9vAzDu2D95u/qKfUTf1sfppcmCB0i4VEMZ0Fn+a3stcFz87yPumOOb6Oc67MXaiMK8yanohEYdvxhVI56uTsGIzcAguDs6gfGBR+oxaDro+BEF4ezKDFEUMfB3FicYeY159xhGTS/EdIfYZdIjccp5ob5qmn4O2BVxUKCzOsjEigCFEF5ZmVcQBpuacolUSSxwG20EZh9Xqm5++aHZx0TGh8GY+UtGva2s0eUr/wrkljzM0JoXq0jv1gvIVYadcD39SJsnAYTV3KxvBwINR/JgvqczmifloqROg/0U4KtbOblw2Iop7WMM5VLH8R051HUwXuuu4doinB5qSx3Hy7U8dMweif1e3fhK/pDjwX8r4jU6pZavlE0D7xMN8O//GVKCToqtCxWsanCh5AMt9NpGXKhJ1dUpCF+URW2eBXIt8CUR5BwLHGU2mwQ0bvOuYpZJXE+5lLMUvqTpLJuDy8qE3wCO5OoP2mkaA7L2aEvwZytxS0Dz8w==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(19092799006)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?8clU0nyxsTHDTYaGGpo48GmWEcYlnBQBClNE21pT7FKvfLWai1UMq1N3SvE5?=
 =?us-ascii?Q?z4Vfu4TruivAQoBg6EKzd2uuTaUQYDnHMls65y/zNZ5f4KahnshX756y9lTy?=
 =?us-ascii?Q?woDDV2bZUhk65pSAJKAHkfp9h1foLVowfuwDEl95qBdkdZpKLif6sZUn8RNf?=
 =?us-ascii?Q?hZf9Y8bJQ1mI1LHhqUcQk0Pz9pxivtBpdGygzv2HURcD0iF8j1q+uHVUE+/y?=
 =?us-ascii?Q?uWN2jFe4omiRCmuvGJoDBZgnKmOnknHK2AyIsjso5ptkVBObIAIKogzDU+0Y?=
 =?us-ascii?Q?o6rhu8hxrRx3JfdjBOo3LnjWBSneL+bp5YrdODFpjjEjFZYhFJG4tkwLhNDI?=
 =?us-ascii?Q?Nzmx/eN8a7qIrUaCr0MQUIpqMSXr5mM2pOWf8jkGy2pIOBSTIpDwqwqvgBqD?=
 =?us-ascii?Q?FH1bn7Z4mab9JABsCAtQRJ3wmFL56xhoKAjhoociPS8uOAeGO/TTRqd/+yzJ?=
 =?us-ascii?Q?Q9FkfxYnZ8ItPi4TcX/jEvviwlYKxt+WuzB1JVMSifj2RYi+ZCu1U9AcoDvh?=
 =?us-ascii?Q?lWOvUdyZK5emM7RAmbIcFSlyUTH6prfKtsjRJP3LUTCK9OWEBNuHq9O5tjfq?=
 =?us-ascii?Q?o+4am5ZDXYm/cUs+BBQZ1P4YxgHDpEKMJfZIO5K9vfuatWqKICE7EqCLktQY?=
 =?us-ascii?Q?booOM8VU3iZySSUbACduSZnY3DJ/ykilJ/kk+xvTfNd1Dnaet7QlxAqnraNv?=
 =?us-ascii?Q?uaLTyuLCJD+rAQsHHPwn+4tpcvvCdV/n9EVwflY9kw5zF446uoCIuBl4mGyG?=
 =?us-ascii?Q?2WMe65jyqdX5DtcvBGco4+k4D8rEN9wxG41ZDA4KRY9WnpIZkNVyxfWWnsYU?=
 =?us-ascii?Q?E9y+8oODhaAZAp2aSkp+SFFKaJi1RTzl59sU2wfe0tx7I4RNKPv83kj72pXJ?=
 =?us-ascii?Q?/gZUDXpJUfWZQaiFrPs0dwmd94PXuK4s5nGIjc317f7Ij5FYiTrQ4B/AF8Tk?=
 =?us-ascii?Q?+RCwiCGBPK6DcFuIB2p+ih1cnTWLxo6oo8ZSgponwFSySvkmck/+Pci3i0vM?=
 =?us-ascii?Q?9zuC82ckjJI4vNbsr5qRc0EojtvWCmynP4s1WgVbZMxonW3N8Jjg+AcppAuJ?=
 =?us-ascii?Q?c1l3POKe4b+nwPcMDd1o2GV6VoiHisC2swFxY8sZ577WL98K1teYBgirzCwW?=
 =?us-ascii?Q?zLON5odh4VP1b6IK3uhtm4vyDITWwlJr6u+F1b1OuD33jIs+3BQEjoIIdTGf?=
 =?us-ascii?Q?JZzcWcqzs0gQA6z0ie0BUIr3Xg4leWKyccswAD8bLiHHgf7s04SiELXdcm7V?=
 =?us-ascii?Q?zQXA+mz0pT34C1nvHofQGO//VsBcqGw7TnrAunxnNmKrz7lw/7sUZP2E3CwY?=
 =?us-ascii?Q?lpKz12b0R2gmi28F3gYik4vT8/gFXebcbWPNYG9HjIHeSJNOG0kQ1q6SN+ti?=
 =?us-ascii?Q?VRzIkL0GMFUrx8SncXKE93uO9W0cEydth0dkHjONN0lrXTExFBZ3Dy0ogiRE?=
 =?us-ascii?Q?E6axkio6Yq4RRB81wny3mfRSURoGZTNWeVWdsfpYvY4WXcUYGSzMB9XyxwyZ?=
 =?us-ascii?Q?8pa/q1u200tf0tTzZEvZICGE+8NWyeZem0hdiSQmwcs+2SHt56oSqNzUdeZu?=
 =?us-ascii?Q?tsgNBtqpBzfXKwIqEVJp8Me30e+k94IKhHQ4DVeMHhb7PmahgFg700vgcqR+?=
 =?us-ascii?Q?xpRCjFj70CXG0grJ/Vkmn4memn+t8cyWp3+D/kL6jvxdpqsehnG8E9toQd+X?=
 =?us-ascii?Q?n5eXT34vEj1WCfzSsbQj5IzH0CN7mVO4DwlUbTmb9h/Cjp7y+IPjUJOK3q4z?=
 =?us-ascii?Q?v+na9xINdd35gASKn0dcQrIzANNailf37EcqdNzqhZjZVQv89zjt?=
X-Exchange-RoutingPolicyChecked:
 pBaeP/JklMCpOTge0hk8jf2+x8XFgEivvi0pDUoPdI0iJanORAeIZuuqas9q6g6evQQFHr8ZrkgddoJWcVNrH4sCNPZO5XEBC4OqIXrEgaUGtBiqJhxNmybCM7KkdCqoSUtvOkHZRDa3ga8Oy8OIPHY/iEooirIelO2JD7rgEbILc2GT7S16dOLz3BXu1TE9UMB4s+K8qyR9Kahq3kyV90BWHhwsQQXo/GKs9iISwxVQbDTEKhw+iekBHQW0ytiRd41j4cHwA99LrDEL89izQAnVCDOQMKSrirAM6onDeTDmOlClRsNUZMsQOmYmQAA/apSY3TB9k9TbiFcqGjrpBw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 FVUKc3d2C59HPbDYiM64xFE64kPgRauH9fzjOFNM2W4GUB+YqnhmctgKRH2pWUTbhrJFiDsYVijm6qwV/aeJSoCNX3W11l+JoMATtkHVsw6n9caOigVUAbnfiRVv4v6IY6ETebFdBao01SmY73NuyXpJ4F1+bDBfGrLn5lcWjliH5OrZMxC+0mBVPCsus1U8V4gJbYMLeSkbPlSc6njdxVLeMZgDelh6hUSqEkUxzH077m3wJTdNyJKPJ80yv2NXUtIcq3I8X9ZnlUQDmS9DwBAYXLpRe/OtCYkGvCxEeHGjJT5IhrA9bElSuJQmGAyBZ9ubRBK0tqyL3pASJIz3Cst4HICdPBhwcdHBdQUoC1WZy6/vlJr2/FdsVXHLOKdUbo2JstFmxBlggviVmPKOGR9RBlhzkj7XxFmTN+zLdraewAq89y/N2PThOccJhj1KfgP7waus0f8WUbqDsDpg4lDlBknaXS4VJXGLHtTVVQSbkJhKZo8FxKbGMHamUsQ/jr3q0sIOLhEH8RrefxWyoQTIvPvxKLVcOr5hTweaVf2/7SjniYD019eaQ6DtHSCTcOTgyUHxk96yebsKEXlvP17xhz5TIFlRdNhnB2xit3qNWaXshfX46hbYf3fsK3qCovyJ+rL46Iy1+LDkxT0/OA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92d48a76-c6aa-4480-b7c7-08debd796f61
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 11:57:19.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cD6V2lz1Pswe/fn7DlqOJLpq3WubrmsIDvEyv/ddyBToqMMDwVxwGo2L9PqHfD9lQIlpyxrw3ITc0eppwFc7iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6860
X-BESS-ID: 1780065134-111738-7692-9984-1
X-BESS-VER: 2019.1_20260519.1529
X-BESS-Apparent-Source-IP: 52.101.46.122
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViZmRkZAVgZQ0DwxNTUt2cDE1N
	Q8ySTJzNzcwtDYwDAlOSnNPDUtxchYqTYWAAKmXf1BAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273539 [from 
	cloudscan23-83.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 NO_REAL_NAME           HEADER: From: does not include a real name 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, NO_REAL_NAME
X-BESS-BRTS-Status:1

add quota related interface to libext2fs and install the
relevant headers.

Change-Id: I17e6b5aa74e0f1bb1465168a1cf4e03184e003b0
Signed-off-by: Li Dongyang <dongyangli@ddn.com>
Reviewed-on: https://review.whamcloud.com/38027
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13241
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
---
 lib/ext2fs/Makefile.in | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index e9a6ced24..0656c4c5c 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -28,6 +28,8 @@ DEBUG_OBJS= debug_cmds.o extent_cmds.o tst_cmds.o debugfs.o util.o \
 	create_inode_libarchive.o journal.o revoke.o recovery.o \
 	do_journal.o do_orphan.o
 
+QUOTA_LIB_OBJS= mkquota.o quotaio.o quotaio_v2.o quotaio_tree.o dict.o
+
 DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
 	$(top_srcdir)/debugfs/debugfs.c \
 	$(top_srcdir)/debugfs/util.c \
@@ -57,6 +59,7 @@ DEBUG_SRCS= debug_cmds.c extent_cmds.c tst_cmds.c \
 @TDB_CMT@TDB_OBJ= tdb.o
 
 OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
+	$(QUOTA_LIB_OBJS) \
 	$(TEST_IO_LIB_OBJS) \
 	ext2_err.o \
 	alloc.o \
@@ -236,6 +239,7 @@ SRCS= ext2_err.c \
 
 HFILES= bitops.h ext2fs.h ext2_io.h ext2_fs.h ext2_ext_attr.h ext3_extents.h \
 	tdb.h qcow2.h hashmap.h
+QUOTA_HFILES= quotaio.h dqblk_v2.h quotaio_tree.h dict.h
 HFILES_IN=  ext2_err.h ext2_types.h
 
 LIBRARY= libext2fs
@@ -459,6 +463,41 @@ do_orphan.o: $(top_srcdir)/debugfs/do_orphan.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
 
+mkquota.o: $(top_srcdir)/lib/support/mkquota.c
+	$(E) "	CC $<"
+	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -g -pg -o profiled/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) -fPIC -shared -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
+quotaio.o: $(top_srcdir)/lib/support/quotaio.c
+	$(E) "	CC $<"
+	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -g -pg -o profiled/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) -fPIC -shared -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
+quotaio_v2.o: $(top_srcdir)/lib/support/quotaio_v2.c
+	$(E) "	CC $<"
+	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -g -pg -o profiled/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) -fPIC -shared -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
+quotaio_tree.o: $(top_srcdir)/lib/support/quotaio_tree.c
+	$(E) "	CC $<"
+	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -g -pg -o profiled/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) -fPIC -shared -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
+dict.o: $(top_srcdir)/lib/support/dict.c
+	$(E) "	CC $<"
+	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -c $< -o $@
+@PROFILE_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_STLIB) -g -pg -o profiled/$*.o -c $<
+@ELF_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) -fPIC -shared -o elfshared/$*.o -c $<
+@BSDLIB_CMT@	$(Q) $(CC) -I$(top_srcdir)/lib/support $(ALL_CFLAGS_SHLIB) $(BSDLIB_PIC_FLAG) -o pic/$*.o -c $<
+
 xattrs.o: $(top_srcdir)/debugfs/xattrs.c
 	$(E) "	CC $<"
 	$(Q) $(CC) $(DEBUGFS_CFLAGS) -c $< -o $@
@@ -586,6 +625,10 @@ install:: all $(HFILES) $(HFILES_IN) installdirs ext2fs.pc
 		echo "	INSTALL_DATA $(includedir)/ext2fs/$$i"; \
 		$(INSTALL_DATA) $(srcdir)/$$i $(DESTDIR)$(includedir)/ext2fs/$$i; \
 	done
+	$(Q) for i in $(QUOTA_HFILES); do \
+		echo "	INSTALL_DATA $(includedir)/ext2fs/$$i"; \
+		$(INSTALL_DATA) $(top_srcdir)/lib/support/$$i $(DESTDIR)$(includedir)/ext2fs/$$i; \
+	done
 	$(Q) for i in $(HFILES_IN); do \
 		echo "	INSTALL_DATA $(includedir)/ext2fs/$$i"; \
 		$(INSTALL_DATA) $$i $(DESTDIR)$(includedir)/ext2fs/$$i; \
-- 
2.43.7

