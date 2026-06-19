Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D813242B8
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 18:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781892257; cv=fail; b=LEO4+2NOmYlaC5hym5ckOtydHdKplhVYNxlPonts+DsGZn1lvQK2Dj72HyJ36WJe8+DYdLikjykhlq8XfgH0nWVQWW6vBSyqUQrCq60LWLy/BHLqqLzuPsHnGCJa9LHXYqIjQixflOsreuFTFnleq89tdPjcSpqoSTO2TI4ryLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781892257; c=relaxed/simple;
	bh=MRFkQgzdq8kLuMCXtjZXh2YzYKi0vwMMoiYVELHdDgI=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hcZ3dylMnkJ1QeyYXtw0LEbqofiTrG54lTuDpMGbeyOnLcQ2iltxIE+Rpp0M5f32txdXbUi16G6l2q9phDsjMAUcUz4Xe5STs/YzaBeystQj8pSJC8fh2YKrLir5wXUcgDkPLTbu0wbRvYO301Lh/pPdwACS1PitPCBfVUA/akY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=MGEizZNy; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="MGEizZNy"
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021125.outbound.protection.outlook.com [40.107.208.125]) by mx-outbound13-189.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 19 Jun 2026 18:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcR+G29jlCereFfn2wS2YVkPaCbAh5tqwWh1cuuVMeAVRbAMcWLSRbDX0DB4jLWW5dzMONpux/O+BpyCflwOobrIs5PXY5AoEVdcU+0y2e1/Ka0t137+wW92GruFqdZNw6D9LTv5NWNc6Q+qJ/J/1K91VOHkrgscImeiGZvVfI/S/VkYVR4+Jwt/NgMBvLscX6bvoKXzEgp6UVn8azKZKniCaycMQz8l7UY953LmZ2Ts9oKIqEGjHrRRyewCpgNtz/Uyn8rF7sN/yhVlpwztQOTa48yPntrMmox0o1fWTXXUwdM48i+n4LNTUjsM8ih/x3ljnE2HUSqx73cz8uBuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IElCHKMbDvra/NzZAu95eFBHNvdrJeNEVnj5Afo+wmw=;
 b=SC3Sx9LjP9KeBUU4senhi8prtJzkGK155VZE9ayGxLa7kyrzU68Ij8YUry7y4GG16mImsvBAslHCEHIumt2BOvP1vxkrbgENoXZWsekljl/aLf+wRCNpazQnZ08XGNCtlzu9q9fxvYWWM6u5+m0OU7ozghMr4jyRkI8crQkD0N1GcUaQLTOXY0pFu2vFMmA9XMvrLewZ26ovHVmoHYnJd3id+77nQnIJ4erv9ca+ETf00OAXccMJ9JsUYAz5kpwc3ylsgNgdH9SWb2Gx2i59pLQ9xGGvHSTaNeFi5Z1Ji1aJICoH/NcpcqulHCyeWoTD15anYCavVhSLCdZtsRX+yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IElCHKMbDvra/NzZAu95eFBHNvdrJeNEVnj5Afo+wmw=;
 b=MGEizZNyRas34vGff/cx+qhtJNRACGBDtKdKYdW5n26KeLEJeeCyn2Ra+jnNM365F729btHfnKxjpQqh1fgvrOhLPwQswJyFVr8pUrI+Ein3uNbIMttUJhRIwW+Ibcxz0IrN3r4FdIvBVUw8JMoE4UZPGeCVy8S0HxKSPekM+Q4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by SA3PR19MB7816.namprd19.prod.outlook.com (2603:10b6:806:300::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 15:32:24 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0113.015; Fri, 19 Jun 2026
 15:32:24 +0000
Date: Fri, 19 Jun 2026 17:32:19 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@thelustrecollective.com>,
	Li Dongyang <dongyangli@ddn.com>
Subject: [PATCH RESEND 2/4] libext2fs: add quota to libext2fs
Message-ID: <ajVhAyowIuufXwNh@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVdnQUu9tSrKldW@eaujamesFR0130>
X-ClientProxiedBy: PA7P264CA0355.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::24) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|SA3PR19MB7816:EE_
X-MS-Office365-Filtering-Correlation-Id: b938d598-ff6a-4031-a71a-08dece17f5fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|19092799006|23010399003|1800799024|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
 6s3/wTPZZRNPcL7Gc0I4Z6PvSUOfcVJKxq3mYEerLtgajubxNJgpO1Ln/9gxg4pzA5C7YfeDuin6TniEnpr47INhPXkjGwStg+wpqstVEREiPi3uvntyxb0kBzLv53P8fCzIM6CdDGauzTLNBeqipMp9uZCClLj2CyquuRFihvmdUsKbUCx9ogFcSTmKwLdX1We2/YyZPxuHEO9KfAWFs/D96I+GAOlNa3QYJwq3rJGYbJ0LsKcWbhsgMTs3aXch6nGQr/5T3Uipa2C69vs7creTAt05VV5aJbhVr/nMY3DzegTYA7H888JO0V7jTetjnTASDdv9we6AKp6oaodGAYPF58QGRNwJDNDNwlDL6VltBwNapfqYQK8p3mtit4DjT6VJUAUkIUCL24ucTcjAppkk4v0WpgS0wLNyoIPXM2OdIUs0cBIYxUXqec3iRH63gZz00ZMBLWfBkOXrhYWdiKpuzJ3BSIVY41GLnro6ZuS3GJtYP1X0Ktz9LIkMD9h7CY9iN3YXDWgahT4Px4ltj7hClgo3el43n1OaBKZ24HZc9sGX8dZ+K2J8jWAmsY0coJje9iW5A4GzA+KZVuXKNJlEKFa+oh6rnp6AQCTy4hY7sZWuxECpZANWwz5l8Zinn2rj2l4xhPxDFrYK9RCtxFLsXcWjQfs5s+xboODRqOQ=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(19092799006)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?uNSU6Rop57ZOMtrg0jFdqZeSLzmw9mVCZ97W1jiXtosQn4AlkkY/YXcxeO9K?=
 =?us-ascii?Q?9gEwjVCLwx8om15jrNL/WmuPyt2X5dG/b8TDg/rYpkH2w/sDwPN49FZMJpFv?=
 =?us-ascii?Q?sNeq1OI/sWsxYWKMLxjBIBJU5caX2ph1p39/kLtJC7lMgJVREoryw/Syy8jK?=
 =?us-ascii?Q?sB/+55H9md5WLXyqG2ldy2i8e5X/RYCpxSUX58hvQxFCRo/OZCcA4R4AEv8p?=
 =?us-ascii?Q?EN2saJgvhIcBOjyHiugvyIn/ydd3SpS3cJeXdOITvv6N12ybLC2FgvrRqefb?=
 =?us-ascii?Q?xOnG9tWp07risKjAhGFgTJyx/rebPCPdI4WGVr22GNSfc3XLCs8mQtWxxhLV?=
 =?us-ascii?Q?ahvY+WRjOi18qcNyCFT5JXNp3eI8JL3QqAA25kUg+MZhvWO20OFEyTgJxAWJ?=
 =?us-ascii?Q?wQtWDXqqWIMnuVyzWf5q+3GjjgykA/Xw7rU8K+1Q/RwXUaOBxMZDzVdv4wvp?=
 =?us-ascii?Q?rw1XL2GGmj8kYvWnB1vyztZidWWAqFYCBUPdRNMxNI9Rk1OfKwJlVFV59VOp?=
 =?us-ascii?Q?YuJviUYiF6xo1EOTVfKL3tADsR4Pddzpy2k43bgiXug/YuQE2YRHcMgScrtJ?=
 =?us-ascii?Q?/aM8t5ZcB+hFuErW13xW7ZncTPwSD2DVbyFh5sYaX7x851yuF21Z2LBn9twn?=
 =?us-ascii?Q?BjxqZkMYEY4oxwrGqz7X3430svU9xfXlUDtiLy7HK7jU6exlTB4Fh9xqit47?=
 =?us-ascii?Q?muyH+aXXceO3DjtjlMXcuIUDMctvc9ntC+4tXw/6uuqLSX1fq3sIu02rY1tK?=
 =?us-ascii?Q?C4jJg4X6lZutRaHMOVYgIbMmTwHdWxeVI8ZQU+rcGDeCIVlpA3YMJSxaRk4+?=
 =?us-ascii?Q?M/bTpNVtqVqnAlJSyq/k6oz3/6nwlpiCSoswaEOEuEjPTTaTe7XkO8+Sa4X5?=
 =?us-ascii?Q?AJ3A71fUfYa+8alKVz1K9zG8cp/lig7aLFTE5Vu68DHxqhBeqEXxR4JCbsW0?=
 =?us-ascii?Q?gDnq6fLeS570Cdk/U2fTEwCFYfBUN+IkcZpx56quslK2EBaY4U+CAt7iurxY?=
 =?us-ascii?Q?ZQoBoss2OtXnyuVAprtBYDMd+d/w9BD4duo5j6u3MoLTRmzzpg7le6netd2U?=
 =?us-ascii?Q?1ngIVnljZcH8wyWgL9tQLpeNly7qNt+FnDqjvhqZ3VrdCpFN8yNLjFU89u5q?=
 =?us-ascii?Q?Xd+C2zDz8oSX5dkK8EFuiE+7oGy+0JLG4MwJXnpeEARgvyq0lPhD/YRFPEvZ?=
 =?us-ascii?Q?k4lHYaAs0EGEbO7srF0Ln5XAK4KD4pXpxuul6u5tyTLwPhA0s+Fl7wMTxe9o?=
 =?us-ascii?Q?9hK+hIOUHNbCfTHAKwVjcMle7E4mL5UiVKnzy/VNLqZ+KkVNNPvpjXCQPgay?=
 =?us-ascii?Q?Rd9MHndY8XFb0jOLmr4M/M7CwCXXsApbjvIjMin8G396GfTuOXLOH+phnZsH?=
 =?us-ascii?Q?LUeLHakTimkESE2uEUodVcfdscSZ2m1B5v/4XoZ073Rll13sFoy6jQ5TgC1s?=
 =?us-ascii?Q?uUnaZgi+D5DkFZ/hApzzyjxJBFJz5yBve2ykFTcX0mHNUKsQn9qdL+LvpzHe?=
 =?us-ascii?Q?HP+WJ1yChSPCwxQUUoFsWragRGrgp0PXoLhLphxSActSE3i7u0jSN68KvX+j?=
 =?us-ascii?Q?52ZY2eNl5s2ux9h+7Bzh9nRer7yxmzwnbIgeWKORWDuWolk8pLcHrpiDvdQ0?=
 =?us-ascii?Q?HlQZYTTdNZS69yw26lADpbdHq3fwj6TQfXdySFL15jYyNGz1L/1i6ebwdJP+?=
 =?us-ascii?Q?d7zimWZVxclpOMTdnAx3/O9lOTcRUSwDvoXA+CMxmbI0BlqZaA8Xxyr/DNPC?=
 =?us-ascii?Q?gn+OiaslD+JUUZ2lh00QIhKctieuXz2mgliKwsGF/lfc/ln9om6Y?=
X-Exchange-RoutingPolicyChecked:
 soN/ZQ8OzdcrastmLF+gcTHawO+8zegzzLVqFkFMHWdPhsm57D8MBkddEOwDPOSA3PBXHtQEPLKpoCsuJN3ZPZsgUWY/imub0XqlMFN1ls6lxzAi9HzSbND3eHOJyCXI/qb4K5zV9mDX5jjda8o6SC/RjDMF30H/JhIJrf7dNUAP85T02xSweXRMvipLDELIqvO7IQYnj9s/l0fM98dTz5k3NXbF7xMOuvh9OFLXhebAx3kCo/5JP/EVu4IYDMywdQXhtAq7aSEHK3+mfBhVYDW/lxi0Do8FOcEwaPgcJGfcgi0F7ROZ7cEyaBus83KnykY4WeVG3O9rgCI+qDU6tQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 WW97jwmNDdOTTEyWDfZPPQFksiK6lNXo45/Hksxalg3To1KJnBYkuS1KW1tMh/92hhaR6jqeqqtKmnsf84J9dR1OxzTIKs5AhcGarTEuZ4i431r8E/Xj5xSklwhIuZWuJhkpApHDQjZLH+aRwGeDmWZJkHtmeJ5f5NH7CrncGE01BDXngLlsq2qEXCKIZmx/oFCGJnBzycENa4Kjhf0PYbc8J150xPFiWB58Dt8K9fJf0SFliSxtuhRalYI8mH+xD8Gq9EVL3hOBeg3voTlrLWR/8YZk7Vwj+kXtR/FVecFjT+Bk3sOXYa3RR5xafHEXiLmg5IdX05c5vfhtA0zhXljfoDjAKKUF2mUG1QqkL3YUnX4Wdcfh2bQ0zUhRKYeK8Id4b8yLORapnVgDlbwu0zWWi8XFSn2j0gCUReoz90MDv6Xz4lYwSow8oABc4kBlXURvjTYnIvvQbaSAKLJNMU9rIgh6zie6vFG3iAsJu0HDsdNxiKkMcf5+ILsgIj/dUpaXwPd4YGqzXpFYgOnOyT6qwdwErE0DMiK+i/dTdHzI6waH7w51uscH+cojpqX9ipsad3FWsY2ve8Siud1fvzb9l/F2rPrvqljFQLgrMAPd/diKpShR8RoTfOWkG1xLYL+k6sLL5qmAY5QrizYtmw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b938d598-ff6a-4031-a71a-08dece17f5fb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 15:32:24.1853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GacxNYHrQt4na42f0FtSQfN53QVI44GtWTTYkaIatAHsXf5KOCwdA9TvwL1qpRL99IPtIiyiIiqSllOZfBAhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR19MB7816
X-OriginatorOrg: ddn.com
X-BESS-ID: 1781892253-103517-7719-6421-1
X-BESS-VER: 2019.1_20260610.2305
X-BESS-Apparent-Source-IP: 40.107.208.125
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViamRkZAVgZQ0MzQ0MwgycDS0M
	TExNDS3MjYyDTZxMgkNdU42cDA3DxVqTYWADCFJlNBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.274043 [from 
	cloudscan18-34.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

add quota related interface to libext2fs and install the
relevant headers.

Change-Id: I17e6b5aa74e0f1bb1465168a1cf4e03184e003b0
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-13241
Signed-off-by: Li Dongyang <dongyangli@ddn.com>
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

