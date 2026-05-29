Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AD43EA955
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780065103; cv=fail; b=S/9k8eYaM7NlBQycn3CBkxGtPRkcHq/1ZwGRRP6io4EweEXURzoldnxPYZGVVyUWdWmm5HDukc52MHFoBKWM/GIA44v6Aati5Ln4bTn6uqjmWlxLIsXl/mm+G74zoVQCciIJYuWnvHo/uSAk3gvxLHVqIqbjaXWlQmp5jx3glpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780065103; c=relaxed/simple;
	bh=yfZMvPapUhfbL+pDBZEHjeDvT2yy22WZOGcnMrF81mc=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=OypuL6MvkxMQTXFrYr7guACLxUDdoxYOZa9jheyW7v5w+ZWSwoFymHSXQCpYKFg3fikyAqdIKU4/wspCCgHhB0M0aNMrNFkpN4wEWMd7OIGee2lvmOP85n/gVoIVWQ0CItVMdLcoeDl8OGhBeNm1ZqFQcP00SaFhXPEOTq6Ixkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=BQu7EKRK; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="BQu7EKRK"
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021077.outbound.protection.outlook.com [52.101.57.77]) by mx-outbound14-58.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 29 May 2026 14:31:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B0jZRui+MH2KCmMvKNSsnDB6c+2BdWqLKLsvI1mZnZPh46woLL2In3Ubfdzo9oqwnW1Rpo8bGFQCR1IX+ovPATq02FYDgHf3AgPOLED85dB0secQETC04qGN72QRfBadnFPLuX8XP7geRMe5uqsZ82vPqmMx9urIp9I/HU8HcJRqnimpltaDNzytRIYpemhMU/E2Li09rNX3FHooQt7VftZBOq5sCtokFRBEWGU80GnbV3pEJXQAchC8oLMoe/kQafR48dDDr5O/IftldVYJq0dZLAs6ts9JnTDhcjfzOjToJ/gIHWDM8wlZWTBqapWhxfOY/cjpi6kJ8+lR4etZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tuYgOVWNFrss6V+jXZBjuAWCEEOM77LrOGkZcg/Zs0=;
 b=RKoQF6zFonasaBSo1b+/VK9LOlnpV3l1qm9xo52KI63vbdIYnShQb5agbgK9AvyNpxRDIxbeLzs1sEaBHTsJcPzkvnksU2iC4W7CIU0lIwkY/PoN7chdC1a/mqNXSbxO+o17cAfLeKh+xEWVJS7wg2NtvrNdL5Q49n/5QLD6hMwNaYVKQwewMxCMBfj+0dWeShdCcGSQdizi+9erV76O5piHtulzO8QN+HuKSomfYpIm1BS7exZrFYnjFZ30VzwkLhZX2dTL7ulCkTAaxIXsv6o897zPLNd9/zhyNu1slkUXuqM5hmrnD6w83bXcJVJcF59FtI6NL1YjhjD5NFWVhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tuYgOVWNFrss6V+jXZBjuAWCEEOM77LrOGkZcg/Zs0=;
 b=BQu7EKRKGoj6FA+BlyNsZWrCs/iN5yQIYq0q2a/k6GfbF0a7Oh92v/vLQsvn1h8Rrf5TAot5B5F5/CR4RRHknZZfw/qMfrpsOPXe+G7XlPLMgTzMd5I48NEOaxzia6teSpOc+TR5/F0FyQzzwFqplc9yP3+51x8rg9qcZjqqjrc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by PH8PR19MB6860.namprd19.prod.outlook.com (2603:10b6:510:1c0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 11:58:06 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 11:58:06 +0000
Date: Fri, 29 May 2026 13:58:01 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com, dongyangli@ddn.com
Subject: [PATCH 3/4] libext2fs: update iblock when using ea_inode feature
Message-ID: <ahl_SeMuzeD2VxrO@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PR1P264CA0023.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::10) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|PH8PR19MB6860:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e82fdee-33c6-4a6e-67f4-08debd798b36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|10070799003|376014|1800799024|19092799006|18002099003|56012099006|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
 2/qWt/7enoWuLXtS2+4y2Nx2apFrI7yWu+hf8CaMr010jeuJeUgZi8Z9SdV3d3KNkYb5S486Th2DjZv7wtWPAg64ZaLx0UlEkv1wkWC78JWm5F8lnSbIqZPrnG1TIuzeW9M/1MPWjw+zI4ML5XMPkCWGFE9xPoLNIkTvQGUE7K8TLZQ3qqrsYhU/uy5e5XroGX20di3ZXVE/Vmxhxo7Ag8MKzZ7gIPlQD9Aqe2c/WIRC9gAeISiy33++3NtbtG1d1/PVnegZwXbO2kqJhEKGMeURVQ6Bg8WQDzegC03raQkM6sbX9DuZFiVDfkXcmzAhCzZ+rBJW+/Ao0E9pSyYtsiL1NpJLTUS7AT1odUvoLmaLcNqloVMFXag6AabgMTIDuxbpHGpNNAhNDFMSzscI8yW0Fk+Bq0R5bZkqvSkW4KYeft+mjYob2EtmVj1t3k2u5CBVVMYaF2OlaqrmmbrK4JhfzJA31mCHEUU3Xxoe1ySZZYT/0tX7mRw46pFomQnX8qzONz3h8TMCfHIf1OFyL7qw2ubEw2pPvRz9I2nUjbNxmt2IBW4NapoH4shfC0ahwxSWMP9pyIwYSEx+8QvJgpeIZf4BlKybHENRTK8DW548hVqPuuEKRHgN+X5sOmdmKnlM5tfsAFk4eGmiaYwab5oEPwBxuTUfkISGBYdz5mzb6PjVja7chMr41Ckb0jgd
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(1800799024)(19092799006)(18002099003)(56012099006)(6133799003)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?efQY0UThXmChlk4LIIihfkcAx1h1EG0Q9S/syDY7MQxduv/rQd3SlFhEGIL0?=
 =?us-ascii?Q?z9UzuD3RhTh3d3fuf+u8ae+DrWWmnQqPpFQYBDXT+jArmTCOC0mBRc537sPg?=
 =?us-ascii?Q?xZ+wBi81A/Z5ho9h7pxtbT67nzNGPAy+gG1THmJ8U7KPDNdpbm67LSvP+x05?=
 =?us-ascii?Q?qd1TKvRUTqqMG5H3kIypOV1N/bP96Qt/FkywP6mU4IhHDehjaJ1KkcTG7f9t?=
 =?us-ascii?Q?R6sVUROnoSxeX6Ci6PhnTIVwj27V/3r2r9DE8VpLkDlBIrM0vUtST73EcG5B?=
 =?us-ascii?Q?4uSl43fs4N2CHSQcfKMXd3SuSkCDi/9Fvvh5jiW/zTS5opfTmXRllj1cWYtb?=
 =?us-ascii?Q?3iQfYG4qY1+YyhijOglEzuMdfUO4ZTc8vKOi933mCqGCAinRNx6fLsEi6AMX?=
 =?us-ascii?Q?6d83yYas+TlPhLJxo1EVCUJF2KEIxROSuLjmp06AwsoZOdf1Na+Lno7cW7Gy?=
 =?us-ascii?Q?OpUyjB4CrooapYYwKQ1ZRwLXuANzyKZj4pYQaxJmhLI2DGrtF16TPsJrs79n?=
 =?us-ascii?Q?2uMsUy2njh81LvyfFn+6qzuBBU6CbuYNB1Wd6J+6ZWlMWlHFsO38Eo+P0Ve0?=
 =?us-ascii?Q?cKIUOkSBxwSXvTLHK54lHehcLqojt1joKOtaeaLgKP5G9r+jB0KQAOM9U6oN?=
 =?us-ascii?Q?JTJV3xpbMP6W+vbfLFMisINpde4kHM3VxiwBdlhpSAijZQuzWZ2cSZ7DP01V?=
 =?us-ascii?Q?ZsEdEOXWcCBUcVQEkTKz904YHmnmXaDoct+Wfmg7VTqKpq3t3VatV7c+SJCN?=
 =?us-ascii?Q?eTiGYqTmiCT+nc+d2DEf/o8pnGSR3LvLFEyP2f1qw7D9X8gSYaN6o9gQQdde?=
 =?us-ascii?Q?MCv8KgKYyM3eqCw72B6zllah7XuLW1UPZhKSIfe0lGSS6Y6scsbGsjMDefNI?=
 =?us-ascii?Q?jEIBFFIYh9PWnfVmRVJFa5KGbYNpAQj+rGEeRsYvolRGMsyC1H/xG0bAgTfy?=
 =?us-ascii?Q?d1s7DK/fJQvl3xR5Qto8uiSUg5pOx9TvSliGhyV/lnlDLbGrWlbuOCYK7F3j?=
 =?us-ascii?Q?b2c4MxdniOb1f1oHf1LLgyx0qldkK98Cy2f5xtpzobix1Ltfp490YuhJh6Tc?=
 =?us-ascii?Q?ouGlRIfTPW6xKnJ03+ERk6q0IqfBwZudHWmZIHjmfbMERYlt0S8HBc5PEJ9Z?=
 =?us-ascii?Q?z4LHt4wEYboRa6NgO0X/k9e5zPtn5LokYMROG7rXcfZVNLl6mblvivG6qDrW?=
 =?us-ascii?Q?N0o2bQYQg9vksYwH3G5uoZb8WYEOus5+hLVL9hyeU3SakVYvzKFxZAl1BW0Z?=
 =?us-ascii?Q?fRPZsiPbUhM/POjbwxtRctIyO4L04hSBedjbn3qIJUqb7OAthg9g98ERf/15?=
 =?us-ascii?Q?PQzDJw3fe7qI2ZR25TITCkXvDSo0Sn+T62zLZ3P2hM8yTm9jbxNK2wxm3cW9?=
 =?us-ascii?Q?bQf74VVs7pz/lSX1uzxq+eHSDMLgXX/G7HE9qJGilAuuRVxGycQc45kArQIL?=
 =?us-ascii?Q?UA+lYBZ+fmVZ1tlT5MKFA2FdYCc1oAKJdPm6XD4J871VXjy6DXXMXVwGE6Xz?=
 =?us-ascii?Q?yN5jJ8bIV7fGKXLOMH1hZx/oWV53+YjimfR9UZ3NBUGeAZJ3CNwSm23wn3Yi?=
 =?us-ascii?Q?rxUWLwDBnyVpvTjP7GaxySdSUEvHdJHdLBnu3YxE6o0UNPz0/wut2UDGHdwK?=
 =?us-ascii?Q?nVj/TWbHvk2IDQAJsybf0tBwQsVwn5ja95zvj6T4MNz+TqyQHeHioCubTVxD?=
 =?us-ascii?Q?e7xGC1tHeqLNP1QatHnnV1QBN94Oq0N+01VT5jB5XNdwGMB2PSgbu8Fe2glk?=
 =?us-ascii?Q?DuSSYjUbmCwasT3MFACHlG4ZcbGOOalZnhhV1YNiZpba4T+dvn7X?=
X-Exchange-RoutingPolicyChecked:
 KBaTI7EZ0pST6plMhKslqce+yV0i3/Ed21A6H2qruQ6XTNOfV/Zsm9VyLPCJtQk6nI405jTx06xhjlE52wqSmJc0kk4xvt3PSpHAq+27+rTZxBmEdaDdCIJfNK1MNi4E0DCaAfJzN1yTG5Z5iHeUi2vSlVgtyNS3JovYYaWe0hiJ3JhYuI18mxiYhRVKjSwhMojV8JU8nkmXWhr8WBsFhyhJkxJrz0VYJGZKsP+evDgitZYtp8p6IeifwSjohep+2G/WvZZqYOXtQdg7wk2NKStHM97dnum3a4NNCsrAIHf1M3i6if7cf2qLwTyk/3qFO+hzrV2Z8Oi44IWDHxH01w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 XGphwNjXFZYeqZCc6OvRVq1WbwuNx9FzooYLOQVtCysVSrxDRfyqX30ewjHzfJAMHYTcj0MvZuTYGOaY62CUXaOd3wI9dcNpg468pnMDpAnnCSczXhdmoeQDdNOsJjvn+aWA+XwUpswsFPRg1PPIVhSQ0NwgqOInWQXpA7Aub8qALu2bgm7nvyixrkYIattDNzfoVTiOTiZy8OTRkRf51hF9n7RDzxgASJTIPgUkk4aANGyhIYN9M1l8R7wZDT5zRRj5XoFJvIcqF6o6wOG7CFk9IpYmYcyB2v5lkiEbWFJFQ2+AHObWDq41UwOHbn6isfpw+P2bW2/mduYzxweUM1U15sk/JC/OQnBX5X6SA7attvw0uq8P3rdNr3WpVTRvNku9uOpfQgvPw8XBuFwQwXEuZrPcWI6+Y7Rt5BoSi/JuO1mHS1XDDrD2QEzyr6FhuEUM8vlo9JcXCF0+ENa3j6g+9eoTJkhX/Vh1HOhG5qT1uWyeQydL0839j9T6zU/9yj51vrG2xC8p8iAWU5mIP+QAQwIr9V/T65v32kb9C5JUnJQ0Ak80ZBCAUGdRmIbdawggTEJDLHxAJh6IUEZVYjumpc9PZBw+nrkk9MFJgqO0PwktHIYFBjONG860m16loIW6t0RRDz5xxW6phZAngA==
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e82fdee-33c6-4a6e-67f4-08debd798b36
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 11:58:05.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h3Mytl7FzBYArsofqRSK3yvIRQXt20CTNqkeMjAjTHsOAEAzJY9RWG8B39TJUOXcMUfcf022rg7908JWCXM38A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR19MB6860
X-BESS-ID: 1780065091-103642-7726-4407-1
X-BESS-VER: 2019.1_20260519.1529
X-BESS-Apparent-Source-IP: 52.101.57.77
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVkaWZpYmQGYGUDTJwiw1NSUtxS
	jZxDgxxSQl2djc1MQk0czEzNAkySjNSKk2FgBlOmOuQgAAAA==
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273539 [from 
	cloudscan23-40.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

When a xattr is stored in an ea_inode, ext2fs_xattrs_* functions do
not update the inode block count.

This patch uses a cached inode to update the block count and quota
when writing xattrs.
It also fix an xattr remove case: the current ACL block was not
release by ext2fs_xattrs_write().

Add a helper function ext2fs_iblk_get() to get the inode block count
in cluster count unit.

Add ext2fs_xattrs_open_inode() to specify an optional cached inode to
use or update.
The function handle an optional quota context argument to update quota
accounting. It is hard to predict inode quota usage with ea_inode
deduplication.

For testing purposes, modify the debugfs "ea_set" command to handle
input file larger than the FS block size.

Add a regression test: d_xattr_ea_inode

Fixes: 50d0998cfe ("libext2fs: add ea_inode support to set xattr")
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Change-Id: I34733255bb76ffe2386d8cd6c19ce4561be4da3a
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-20049
---
 debugfs/xattrs.c              |  19 ++-
 e2fsck/pass1.c                |  12 +-
 lib/ext2fs/ext2fs.h           |   7 ++
 lib/ext2fs/ext_attr.c         | 227 ++++++++++++++++++++++------------
 lib/ext2fs/i_block.c          |  14 +++
 lib/support/quotaio.h         |   1 -
 tests/d_xattr_ea_inode/expect | 137 ++++++++++++++++++++
 tests/d_xattr_ea_inode/name   |   1 +
 tests/d_xattr_ea_inode/script |  85 +++++++++++++
 9 files changed, 415 insertions(+), 88 deletions(-)
 create mode 100644 tests/d_xattr_ea_inode/expect
 create mode 100644 tests/d_xattr_ea_inode/name
 create mode 100644 tests/d_xattr_ea_inode/script

diff --git a/debugfs/xattrs.c b/debugfs/xattrs.c
index b518941c9..8364281f4 100644
--- a/debugfs/xattrs.c
+++ b/debugfs/xattrs.c
@@ -14,6 +14,7 @@ extern int optind;
 extern char *optarg;
 #endif
 #include <ctype.h>
+#include <unistd.h>
 #include "support/cstring.h"
 
 #include "debugfs.h"
@@ -299,10 +300,24 @@ void do_set_xattr(int argc, ss_argv_t argv, int sci_idx EXT2FS_ATTR((unused)),
 		goto out;
 
 	if (fp) {
-		err = ext2fs_get_mem(current_fs->blocksize, &buf);
+		struct stat st;
+
+		if (fstat(fileno(fp), &st)) {
+			err = errno;
+			goto out;
+		}
+		if (st.st_size > sysconf(_SC_ARG_MAX)) {
+			err = EFBIG;
+			goto out;
+		}
+		err = ext2fs_get_mem(st.st_size, &buf);
 		if (err)
 			goto out;
-		buflen = fread(buf, 1, current_fs->blocksize, fp);
+		buflen = fread(buf, 1, st.st_size, fp);
+		if (ferror(fp)) {
+			err = errno;
+			goto out;
+		}
 	} else {
 		buf = argv[optind + 2];
 		buflen = parse_c_string(buf);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index fdde76cc2..364128f4d 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -968,18 +968,18 @@ static void reserve_block_for_lnf_repair(e2fsck_t ctx)
 
 static errcode_t get_inline_data_ea_size(ext2_filsys fs, ext2_ino_t ino,
 					 struct ext2_inode *inode,
-					 size_t *sz)
+					 size_t inode_size, size_t *sz)
 {
 	void *p;
 	struct ext2_xattr_handle *handle;
 	errcode_t retval;
 
-	retval = ext2fs_xattrs_open(fs, ino, &handle);
+	retval = ext2fs_xattrs_open_inode(fs, ino, inode, inode_size, NULL,
+					  &handle);
 	if (retval)
 		return retval;
 
-	retval = ext2fs_xattrs_read_inode(handle,
-					  (struct ext2_inode_large *)inode);
+	retval = ext2fs_xattrs_read(handle);
 	if (retval)
 		goto err;
 
@@ -1580,6 +1580,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			size_t size = 0;
 
 			pctx.errcode = get_inline_data_ea_size(fs, ino, inode,
+							       inode_size,
 							       &size);
 			if (!pctx.errcode &&
 			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
@@ -1603,7 +1604,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			flags = fs->flags;
 			if (failed_csum)
 				fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
-			err = get_inline_data_ea_size(fs, ino, inode, &size);
+			err = get_inline_data_ea_size(fs, ino, inode,
+						      inode_size, &size);
 			fs->flags = (flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) |
 				    (fs->flags & ~EXT2_FLAG_IGNORE_CSUM_ERRORS);
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index c4fcb10be..56de5ea50 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -94,6 +94,8 @@ typedef __s64 __bitwise		ext2_off64_t;
 typedef __s64 __bitwise		e2_blkcnt_t;
 typedef __u32 __bitwise		ext2_dirhash_t;
 
+typedef struct quota_ctx *quota_ctx_t;
+
 #if EXT2_FLAT_INCLUDES
 #include "com_err.h"
 #include "ext2_io.h"
@@ -1408,6 +1410,10 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *handle,
 errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			      const char *key);
 errcode_t ext2fs_xattr_remove_all(struct ext2_xattr_handle *handle);
+errcode_t ext2fs_xattrs_open_inode(ext2_filsys fs, ext2_ino_t ino,
+				   struct ext2_inode *inode, size_t inode_size,
+				   quota_ctx_t qctx,
+				   struct ext2_xattr_handle **handle);
 errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 			     struct ext2_xattr_handle **handle);
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle);
@@ -1607,6 +1613,7 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 				 blk64_t num_blocks);
 errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b);
+blk64_t ext2fs_iblk_get(ext2_filsys fs, struct ext2_inode *inode);
 
 /* imager.c */
 extern errcode_t ext2fs_image_inode_write(ext2_filsys fs, int fd, int flags);
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 7723d0f91..3b90b70bb 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -22,6 +22,7 @@
 #include "ext2_fs.h"
 #include "ext2_ext_attr.h"
 #include "ext4_acl.h"
+#include "support/quotaio.h"
 
 #include "ext2fsP.h"
 
@@ -361,8 +362,14 @@ struct ext2_xattr_handle {
 	int capacity;
 	int count;
 	int ibody_count;
+	struct ext2_inode *in_inode;
+	size_t in_inode_size;
+	struct ext2_inode_large *alloc_inode;
+	struct ext2_inode_large *inode;
+	size_t inode_size;
 	ext2_ino_t ino;
 	unsigned int flags;
+	quota_ctx_t qctx;
 };
 
 static errcode_t ext2fs_xattrs_expand(struct ext2_xattr_handle *h,
@@ -499,9 +506,11 @@ out:
 	return err;
 }
 
-static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
-					 struct ext2_inode_large *inode)
+static errcode_t prep_ea_block_for_write(ext2_filsys fs,
+					 struct ext2_xattr_handle *handle)
 {
+	struct ext2_inode_large *inode = handle->inode;
+	ext2_ino_t ino = handle->ino;
 	struct ext2_ext_attr_header *header;
 	void *block_buf = NULL;
 	blk64_t blk, goal;
@@ -541,11 +550,15 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 		if (err)
 			goto out2;
 	} else {
-		/* No block, we must increment i_blocks */
+		/* No block, we must increment i_blocks and quota */
 		err = ext2fs_iblk_add_blocks(fs, (struct ext2_inode *)inode,
 					     1);
 		if (err)
 			goto out;
+
+		if (handle->qctx)
+			quota_data_add(handle->qctx, handle->inode, handle->ino,
+				       EXT2FS_C2B(fs, 1) * fs->blocksize);
 	}
 
 	/* Allocate a block */
@@ -744,8 +757,7 @@ write_xattrs_to_buffer(ext2_filsys fs, struct ext2_xattr *attrs, int count,
 errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 {
 	ext2_filsys fs = handle->fs;
-	const unsigned int inode_size = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode_large *inode;
+	struct ext2_inode_large *inode = handle->inode;
 	char *start, *block_buf = NULL;
 	struct ext2_ext_attr_header *header;
 	__u32 ea_inode_magic;
@@ -755,21 +767,12 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	errcode_t err;
 
 	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
-	i = inode_size;
-	if (i < sizeof(*inode))
-		i = sizeof(*inode);
-	err = ext2fs_get_memzero(i, &inode);
-	if (err)
-		return err;
-
-	err = ext2fs_read_inode_full(fs, handle->ino, EXT2_INODE(inode),
-				     inode_size);
-	if (err)
-		goto out;
+	if (!inode)
+		return EINVAL;
 
 	/* If extra_isize isn't set, we need to set it now */
 	if (inode->i_extra_isize == 0 &&
-	    inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
+	    handle->inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
 		char *p = (char *)inode;
 		size_t extra = fs->super->s_want_extra_isize;
 
@@ -778,22 +781,20 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 		memset(p + EXT2_GOOD_OLD_INODE_SIZE, 0, extra);
 		inode->i_extra_isize = extra;
 	}
-	if (inode->i_extra_isize & 3) {
-		err = EXT2_ET_INODE_CORRUPTED;
-		goto out;
-	}
+	if (inode->i_extra_isize & 3)
+		return EXT2_ET_INODE_CORRUPTED;
 
 	/* Does the inode have space for EA? */
 	if (inode->i_extra_isize < sizeof(inode->i_extra_isize) ||
-	    inode_size <= EXT2_GOOD_OLD_INODE_SIZE + inode->i_extra_isize +
-								sizeof(__u32))
+	    handle->inode_size <= EXT2_GOOD_OLD_INODE_SIZE +
+	    inode->i_extra_isize + sizeof(__u32))
 		goto write_ea_block;
 
 	/* Write the inode EA */
 	ea_inode_magic = EXT2_EXT_ATTR_MAGIC;
 	memcpy(((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 	       inode->i_extra_isize, &ea_inode_magic, sizeof(__u32));
-	storage_size = inode_size - EXT2_GOOD_OLD_INODE_SIZE -
+	storage_size = handle->inode_size - EXT2_GOOD_OLD_INODE_SIZE -
 				inode->i_extra_isize - sizeof(__u32);
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 				inode->i_extra_isize + sizeof(__u32);
@@ -801,17 +802,16 @@ errcode_t ext2fs_xattrs_write(struct ext2_xattr_handle *handle)
 	err = write_xattrs_to_buffer(fs, handle->attrs, handle->ibody_count,
 				     start, storage_size, 0, 0);
 	if (err)
-		goto out;
+		return err;
 write_ea_block:
 	/* Are we done? */
-	if (handle->ibody_count == handle->count &&
-	    !ext2fs_file_acl_block(fs, EXT2_INODE(inode)))
+	if (handle->ibody_count == handle->count)
 		goto skip_ea_block;
 
 	/* Write the EA block */
 	err = ext2fs_get_memzero(fs->blocksize, &block_buf);
 	if (err)
-		goto out;
+		return err;
 
 	storage_size = fs->blocksize - sizeof(struct ext2_ext_attr_header);
 	start = block_buf + sizeof(struct ext2_ext_attr_header);
@@ -820,7 +820,7 @@ write_ea_block:
 				     handle->count - handle->ibody_count, start,
 				     storage_size, start - block_buf, 1);
 	if (err)
-		goto out2;
+		goto out;
 
 	/* Write a header on the EA block */
 	header = (struct ext2_ext_attr_header *) block_buf;
@@ -829,15 +829,15 @@ write_ea_block:
 	header->h_blocks = 1;
 
 	/* Get a new block for writing */
-	err = prep_ea_block_for_write(fs, handle->ino, inode);
+	err = prep_ea_block_for_write(fs, handle);
 	if (err)
-		goto out2;
+		goto out;
 
 	/* Finally, write the new EA block */
 	blk = ext2fs_file_acl_block(fs, EXT2_INODE(inode));
 	err = ext2fs_write_ext_attr3(fs, blk, block_buf, handle->ino);
 	if (err)
-		goto out2;
+		goto out;
 
 skip_ea_block:
 	blk = ext2fs_file_acl_block(fs, (struct ext2_inode *)inode);
@@ -845,19 +845,26 @@ skip_ea_block:
 		/* xattrs shrunk, free the block */
 		err = ext2fs_free_ext_attr(fs, handle->ino, inode);
 		if (err)
-			goto out;
+			return err;
+		if (handle->qctx)
+			quota_data_sub(handle->qctx, inode, handle->ino,
+				       EXT2FS_C2B(fs, 1) * fs->blocksize);
 	}
 
 	/* Write the inode */
 	err = ext2fs_write_inode_full(fs, handle->ino, EXT2_INODE(inode),
-				      inode_size);
+				      handle->inode_size);
 	if (err)
-		goto out2;
+		goto out;
+
+	/* Update the caller cached inode if provided */
+	if (handle->in_inode && handle->in_inode != EXT2_INODE(handle->inode))
+		memcpy(handle->in_inode, EXT2_INODE(handle->inode),
+		       handle->in_inode_size);
 
-out2:
-	ext2fs_free_mem(&block_buf);
 out:
-	ext2fs_free_mem(&inode);
+	ext2fs_free_mem(&block_buf);
+
 	return err;
 }
 
@@ -1130,29 +1137,51 @@ out:
 	return err;
 }
 
-errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *handle)
+errcode_t ext2fs_xattrs_read(struct ext2_xattr_handle *h)
 {
-	struct ext2_inode_large *inode;
-	size_t inode_size = EXT2_INODE_SIZE(handle->fs->super);
 	errcode_t err;
 
-	EXT2_CHECK_MAGIC(handle, EXT2_ET_MAGIC_EA_HANDLE);
+	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
+
+	h->inode_size = EXT2_INODE_SIZE(h->fs->super);
+	if (h->inode_size < sizeof(*h->inode))
+		h->inode_size = sizeof(*h->inode);
+
+	/* Use the caller cached inode if possible */
+	if (h->in_inode &&  h->in_inode_size >= h->inode_size) {
+		h->inode = (struct ext2_inode_large *) h->in_inode;
+		goto xattrs_read;
+	}
+
+	/* Flush the caller cached inode if provided */
+	if (h->in_inode) {
+		err = ext2fs_write_inode_full(h->fs, h->ino, h->in_inode,
+					     h->in_inode_size);
+		if (err)
+			goto err;
+	}
 
-	if (inode_size < sizeof(*inode))
-		inode_size = sizeof(*inode);
-	err = ext2fs_get_memzero(inode_size, &inode);
+	err = ext2fs_get_memzero(h->inode_size, &h->alloc_inode);
 	if (err)
 		return err;
 
-	err = ext2fs_read_inode_full(handle->fs, handle->ino, EXT2_INODE(inode),
-				     EXT2_INODE_SIZE(handle->fs->super));
+	err = ext2fs_read_inode_full(h->fs, h->ino, EXT2_INODE(h->alloc_inode),
+				     h->inode_size);
 	if (err)
-		goto out;
+		goto err;
 
-	err = ext2fs_xattrs_read_inode(handle, inode);
+	h->inode = h->alloc_inode;
 
-out:
-	ext2fs_free_mem(&inode);
+xattrs_read:
+	err = ext2fs_xattrs_read_inode(h, h->inode);
+	if (err)
+		goto err;
+
+	return 0;
+
+err:
+	h->inode_size = 0;
+	ext2fs_free_mem(&h->alloc_inode);
 
 	return err;
 }
@@ -1272,12 +1301,15 @@ out:
 	return err;
 }
 
-static errcode_t xattr_create_ea_inode(ext2_filsys fs, const void *value,
-				       size_t value_len, ext2_ino_t *ea_ino)
+static errcode_t xattr_create_ea_inode(struct ext2_xattr_handle *handle,
+				       const void *value, size_t value_len,
+				       ext2_ino_t *ea_ino)
 {
+	ext2_filsys fs = handle->fs;
 	struct ext2_inode inode;
 	ext2_ino_t ino;
 	ext2_file_t file;
+	blk64_t	iblk;
 	__u32 hash;
 	errcode_t ret;
 
@@ -1317,16 +1349,30 @@ static errcode_t xattr_create_ea_inode(ext2_filsys fs, const void *value,
 	if (ret)
 		return ret;
 
+	ret = ext2fs_read_inode(fs, ino, &inode);
+	if (ret)
+		return ret;
+
 	ext2fs_inode_alloc_stats2(fs, ino, 1 /* inuse */, 0 /* isdir */);
+	iblk = ext2fs_iblk_get(fs, &inode);
+	ext2fs_iblk_add_blocks(fs, EXT2_INODE(handle->inode), iblk);
+	if (handle->qctx) {
+		quota_data_add(handle->qctx, handle->inode, handle->ino,
+			       EXT2FS_C2B(fs, iblk) * fs->blocksize);
+		quota_data_inodes(handle->qctx, handle->inode, handle->ino, +1);
+	}
 
 	*ea_ino = ino;
 	return 0;
 }
 
-static errcode_t xattr_inode_dec_ref(ext2_filsys fs, ext2_ino_t ino)
+static errcode_t xattr_inode_dec_ref(struct ext2_xattr_handle *handle,
+				     ext2_ino_t ino)
 {
+	ext2_filsys fs = handle->fs;
 	struct ext2_inode_large inode;
 	__u64 ref_count;
+	blk64_t	iblk;
 	errcode_t ret;
 
 	ret = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
@@ -1338,6 +1384,14 @@ static errcode_t xattr_inode_dec_ref(ext2_filsys fs, ext2_ino_t ino)
 	ref_count--;
 	ext2fs_set_ea_inode_ref(EXT2_INODE(&inode), ref_count);
 
+	iblk = ext2fs_iblk_get(fs, EXT2_INODE(&inode));
+	ext2fs_iblk_sub_blocks(fs, EXT2_INODE(handle->inode), iblk);
+	if (handle->qctx) {
+		quota_data_sub(handle->qctx, handle->inode, handle->ino,
+			       EXT2FS_C2B(fs, iblk) * fs->blocksize);
+		quota_data_inodes(handle->qctx, handle->inode, handle->ino, -1);
+	}
+
 	if (ref_count)
 		goto write_out;
 
@@ -1365,7 +1419,8 @@ out:
 	return ret;
 }
 
-static errcode_t xattr_update_entry(ext2_filsys fs, struct ext2_xattr *x,
+static errcode_t xattr_update_entry(struct ext2_xattr_handle *handle,
+				    struct ext2_xattr *x,
 				    const char *name, const char *short_name,
 				    int index, const void *value,
 				    size_t value_len, int in_inode)
@@ -1390,13 +1445,13 @@ static errcode_t xattr_update_entry(ext2_filsys fs, struct ext2_xattr *x,
 	memcpy(new_value, value, value_len);
 
 	if (in_inode) {
-		ret = xattr_create_ea_inode(fs, value, value_len, &ea_ino);
+		ret = xattr_create_ea_inode(handle, value, value_len, &ea_ino);
 		if (ret)
 			goto fail;
 	}
 
 	if (x->ea_ino) {
-		ret = xattr_inode_dec_ref(fs, x->ea_ino);
+		ret = xattr_inode_dec_ref(handle, x->ea_ino);
 		if (ret)
 			goto fail;
 	}
@@ -1419,7 +1474,7 @@ fail:
 	if (new_value)
 		ext2fs_free_mem(&new_value);
 	if (ea_ino)
-		xattr_inode_dec_ref(fs, ea_ino);
+		xattr_inode_dec_ref(handle, ea_ino);
 	return ret;
 }
 
@@ -1486,7 +1541,7 @@ static errcode_t xattr_array_update(struct ext2_xattr_handle *h,
 		}
 
 		/* Update the existing entry. */
-		ret = xattr_update_entry(h->fs, &h->attrs[old_idx], name,
+		ret = xattr_update_entry(h, &h->attrs[old_idx], name,
 					 shortname, name_idx, value,
 					 value_len, in_inode);
 		if (ret)
@@ -1515,7 +1570,7 @@ static errcode_t xattr_array_update(struct ext2_xattr_handle *h,
 
 	if (old_idx >= 0) {
 		/* Update the existing entry. */
-		ret = xattr_update_entry(h->fs, &h->attrs[old_idx], name,
+		ret = xattr_update_entry(h, &h->attrs[old_idx], name,
 					 shortname, name_idx, value,
 					 value_len, in_inode);
 		if (ret)
@@ -1551,7 +1606,7 @@ add_new:
 			return ret;
 	}
 
-	ret = xattr_update_entry(h->fs, &h->attrs[h->count], name, shortname,
+	ret = xattr_update_entry(h, &h->attrs[h->count], name, shortname,
 				 name_idx, value, value_len, in_inode);
 	if (ret)
 		return ret;
@@ -1594,8 +1649,7 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
 			   size_t value_len)
 {
 	ext2_filsys fs = h->fs;
-	const int inode_size = EXT2_INODE_SIZE(fs->super);
-	struct ext2_inode_large *inode = NULL;
+	struct ext2_inode_large *inode = h->inode;
 	struct ext2_xattr *x;
 	char *new_value;
 	int ibody_free, block_free;
@@ -1605,6 +1659,8 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
 	errcode_t ret;
 
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
+	if (!inode || !h->inode_size)
+		return EINVAL;
 
 	ret = ext2fs_get_mem(value_len, &new_value);
 	if (ret)
@@ -1632,23 +1688,14 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
 			break;
 		}
 	}
-
-	ret = ext2fs_get_memzero(inode_size, &inode);
-	if (ret)
-		goto out;
-	ret = ext2fs_read_inode_full(fs, h->ino,
-				     (struct ext2_inode *)inode,
-				     inode_size);
-	if (ret)
-		goto out;
-	if (inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
+	if (h->inode_size > EXT2_GOOD_OLD_INODE_SIZE) {
 		extra_isize = inode->i_extra_isize;
 		if (extra_isize == 0) {
 			extra_isize = fs->super->s_want_extra_isize;
 			if (extra_isize == 0)
 				extra_isize = sizeof(__u32);
 		}
-		ibody_free = inode_size - EXT2_GOOD_OLD_INODE_SIZE;
+		ibody_free = h->inode_size - EXT2_GOOD_OLD_INODE_SIZE;
 		ibody_free -= extra_isize;
 		/* Extended attribute magic and final null entry. */
 		ibody_free -= sizeof(__u32) * 2;
@@ -1694,8 +1741,6 @@ errcode_t ext2fs_xattr_set(struct ext2_xattr_handle *h,
 write_out:
 	ret = ext2fs_xattrs_write(h);
 out:
-	if (inode)
-		ext2fs_free_mem(&inode);
 	ext2fs_free_mem(&new_value);
 	return ret;
 }
@@ -1712,7 +1757,7 @@ errcode_t ext2fs_xattr_remove(struct ext2_xattr_handle *handle,
 			ext2fs_free_mem(&x->name);
 			ext2fs_free_mem(&x->value);
 			if (x->ea_ino)
-				xattr_inode_dec_ref(handle->fs, x->ea_ino);
+				xattr_inode_dec_ref(handle, x->ea_ino);
 			memmove(x, x + 1, (end - x - 1)*sizeof(*x));
 			memset(end - 1, 0, sizeof(*end));
 			if (x < handle->attrs + handle->ibody_count)
@@ -1736,7 +1781,7 @@ errcode_t ext2fs_xattr_remove_all(struct ext2_xattr_handle *handle)
 		ext2fs_free_mem(&x->name);
 		ext2fs_free_mem(&x->value);
 		if (x->ea_ino)
-			xattr_inode_dec_ref(handle->fs, x->ea_ino);
+			xattr_inode_dec_ref(handle, x->ea_ino);
 	}
 
 	handle->ibody_count = 0;
@@ -1744,8 +1789,14 @@ errcode_t ext2fs_xattr_remove_all(struct ext2_xattr_handle *handle)
 	return ext2fs_xattrs_write(handle);
 }
 
-errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
-			     struct ext2_xattr_handle **handle)
+/* If the inode size is set to EXT2_INODE_SIZE(fs), the input inode is used
+ * directly. Otherwise, the ext2fs_xattrs_* functions operate on a separate copy
+ * (with inline xattrs) and update the caller's cached inode on write.
+ */
+errcode_t ext2fs_xattrs_open_inode(ext2_filsys fs, ext2_ino_t ino,
+				   struct ext2_inode *inode, size_t inode_size,
+				   quota_ctx_t qctx,
+				   struct ext2_xattr_handle **handle)
 {
 	struct ext2_xattr_handle *h;
 	errcode_t err;
@@ -1754,6 +1805,9 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 	    !ext2fs_has_feature_inline_data(fs->super))
 		return EXT2_ET_MISSING_EA_FEATURE;
 
+	if (inode && inode_size < sizeof(*inode))
+		return EINVAL;
+
 	err = ext2fs_get_memzero(sizeof(*h), &h);
 	if (err)
 		return err;
@@ -1768,11 +1822,23 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 	}
 	h->count = 0;
 	h->ino = ino;
+	h->in_inode = inode;
+	h->in_inode_size = inode_size;
+	h->alloc_inode = NULL;
+	h->inode = NULL;
+	h->inode_size = 0;
 	h->fs = fs;
+	h->qctx = qctx;
 	*handle = h;
 	return 0;
 }
 
+errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
+			     struct ext2_xattr_handle **handle)
+{
+	return ext2fs_xattrs_open_inode(fs, ino, NULL, 0, NULL, handle);
+}
+
 errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 {
 	struct ext2_xattr_handle *h = *handle;
@@ -1780,6 +1846,7 @@ errcode_t ext2fs_xattrs_close(struct ext2_xattr_handle **handle)
 	EXT2_CHECK_MAGIC(h, EXT2_ET_MAGIC_EA_HANDLE);
 	xattrs_free_keys(h);
 	ext2fs_free_mem(&h->attrs);
+	ext2fs_free_mem(&h->alloc_inode);
 	ext2fs_free_mem(handle);
 	return 0;
 }
diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
index 2eecf02fc..064a5c989 100644
--- a/lib/ext2fs/i_block.c
+++ b/lib/ext2fs/i_block.c
@@ -88,3 +88,17 @@ errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b)
 		return EOVERFLOW;
 	return 0;
 }
+
+blk64_t ext2fs_iblk_get(ext2_filsys fs, struct ext2_inode *inode)
+{
+	blk64_t	blk = inode->i_blocks;
+
+	if (ext2fs_has_feature_huge_file(fs->super))
+		blk += ((blk64_t) inode->osd2.linux2.l_i_blocks_hi) << 32;
+
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
+	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
+		blk /= fs->blocksize / 512;
+
+	return EXT2FS_B2C(fs, blk);
+}
diff --git a/lib/support/quotaio.h b/lib/support/quotaio.h
index 6152416fb..c76486919 100644
--- a/lib/support/quotaio.h
+++ b/lib/support/quotaio.h
@@ -58,7 +58,6 @@ enum quota_type {
 #define QUOTA_PRJ_BIT (1 << PRJQUOTA)
 #define QUOTA_ALL_BIT (QUOTA_USR_BIT | QUOTA_GRP_BIT | QUOTA_PRJ_BIT)
 
-typedef struct quota_ctx *quota_ctx_t;
 struct dict_t;
 
 struct quota_ctx {
diff --git a/tests/d_xattr_ea_inode/expect b/tests/d_xattr_ea_inode/expect
new file mode 100644
index 000000000..aaad9c5b3
--- /dev/null
+++ b/tests/d_xattr_ea_inode/expect
@@ -0,0 +1,137 @@
+debugfs edit extended attributes with ea_inode feature
+mke2fs -Fq -b 4096 -O ea_inode test.img 1m
+Exit status is 0
+Generate xattr value (8292 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test1
+Exit status is 0
+Compare xattr values (8292 bytes)
+stat /
+Blockcount: 32
+Exit status is 0
+ea_rm / user.test1
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/256 blocks
+Exit status is 0
+
+Generate xattr value (4097 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test1
+Exit status is 0
+Compare xattr values (4097 bytes)
+stat /
+Blockcount: 24
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 20/256 blocks
+Exit status is 0
+
+Generate xattr value (102 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test2
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test2
+Exit status is 0
+Compare xattr values (102 bytes)
+stat /
+Blockcount: 32
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 21/256 blocks
+Exit status is 0
+
+Generate xattr value (5005 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test2
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test2
+Exit status is 0
+Compare xattr values (5005 bytes)
+stat /
+Blockcount: 40
+Exit status is 0
+ea_rm / user.test2
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (0.0% non-contiguous), 20/256 blocks
+Exit status is 0
+
+Generate xattr value (512 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test1
+Exit status is 0
+Compare xattr values (512 bytes)
+stat /
+Blockcount: 16
+Exit status is 0
+ea_rm / user.test1
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/256 blocks
+Exit status is 0
+
+Generate xattr value (1024 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test1
+Exit status is 0
+Compare xattr values (1024 bytes)
+stat /
+Blockcount: 16
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 19/256 blocks
+Exit status is 0
+
+Generate xattr value (5000 bytes)
+ea_set -f d_xattr_ea_inode.tmp / user.test1
+Exit status is 0
+ea_get -f d_xattr_ea_inode.ver.tmp / user.test1
+Exit status is 0
+Compare xattr values (5000 bytes)
+stat /
+Blockcount: 24
+Exit status is 0
+ea_rm / user.test1
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/128 files (0.0% non-contiguous), 18/256 blocks
+Exit status is 0
+
diff --git a/tests/d_xattr_ea_inode/name b/tests/d_xattr_ea_inode/name
new file mode 100644
index 000000000..9e36dc986
--- /dev/null
+++ b/tests/d_xattr_ea_inode/name
@@ -0,0 +1 @@
+edit extended attributes in debugfs with ea_inode feature
diff --git a/tests/d_xattr_ea_inode/script b/tests/d_xattr_ea_inode/script
new file mode 100644
index 000000000..84104549c
--- /dev/null
+++ b/tests/d_xattr_ea_inode/script
@@ -0,0 +1,85 @@
+#!/bin/bash
+
+if ! test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs)"
+	return 0
+fi
+
+OUT=$test_name.log
+EXP=$test_dir/expect
+VERIFY_FSCK_OPT=-yf
+
+TEST_DATA=$test_name.tmp
+VERIFY_DATA=$test_name.ver.tmp
+
+echo "debugfs edit extended attributes with ea_inode feature" > $OUT.new
+
+d_xattr_ea_inode_check() {
+	local xattr_size=$1
+	local xattr_name=$2
+	local ea_rm=$3
+
+	echo "Generate xattr value ($xattr_size bytes)" >> $OUT.new
+	echo $xattr_size |
+		awk '{srand();for(i=0;i<$1;i++) printf("%c",97+int(rand()*26));}' > $TEST_DATA
+
+	echo "ea_set -f $TEST_DATA / $xattr_name" >> $OUT.new
+	$DEBUGFS -w -R "ea_set -f $TEST_DATA / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+	echo Exit status is $? >> $OUT.new
+
+	echo "ea_get -f $VERIFY_DATA / $xattr_name" >> $OUT.new
+	$DEBUGFS -w -R "ea_get -f $VERIFY_DATA / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+	echo Exit status is $? >> $OUT.new
+
+	echo "Compare xattr values ($xattr_size bytes)" >> $OUT.new
+	diff -u $TEST_DATA $VERIFY_DATA >> $OUT.new
+
+	echo "stat /" >> $OUT.new
+	($DEBUGFS -c -R "stat /" $TMPFILE | grep -Eo "Blockcount: [0-9]+") >> $OUT.new 2>&1
+	echo Exit status is $? >> $OUT.new
+
+	if $ea_rm; then
+		echo "ea_rm / $xattr_name" >> $OUT.new
+		$DEBUGFS -w -R "ea_rm / $xattr_name" $TMPFILE >> $OUT.new 2>&1
+		echo Exit status is $? >> $OUT.new
+	fi
+
+	echo e2fsck $VERIFY_FSCK_OPT -N test_filesys >> $OUT.new
+	$FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+	echo Exit status is $? >> $OUT.new
+	echo >> $OUT.new
+}
+
+truncate -s1M $TMPFILE 2>&1
+
+echo "mke2fs -Fq -b 4096 -O ea_inode test.img 1m" >> $OUT.new
+$MKE2FS -Fq -b 4096 -O ea_inode $TMPFILE 1m > /dev/null 2>&1
+echo Exit status is $? >> $OUT.new
+
+d_xattr_ea_inode_check 8292 user.test1 true
+
+d_xattr_ea_inode_check 4097 user.test1 false
+d_xattr_ea_inode_check 102  user.test2 false
+d_xattr_ea_inode_check 5005 user.test2 true
+d_xattr_ea_inode_check 512  user.test1 true
+
+d_xattr_ea_inode_check 1024 user.test1 false
+d_xattr_ea_inode_check 5000 user.test1 true
+
+sed -f $cmd_dir/filter.sed $OUT.new > $OUT
+
+#
+# Do the verification
+#
+
+rm -f $TMPFILE $TEST_DATA $VERIFY_DATA $OUT.new
+
+if cmp -s $OUT $EXP; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset VERIFY_FSCK_OPT VERIFY_DATA TEST_DATA OUT EXP d_xattr_ea_inode_check
-- 
2.43.7

