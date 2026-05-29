Received: from outbound-ip168a.ess.barracuda.com (outbound-ip168a.ess.barracuda.com [209.222.82.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F353C9890
	for <linux-ext4@vger.kernel.org>; Fri, 29 May 2026 14:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780064529; cv=fail; b=sitzVQad7O5czcoJlAB/587hIf9XDSLoV2aAg2XxkQy3BJfpBSyTDWKXF/W/q/4gE6DWTimzxZbfsOKIbdqOMcQJsAMX5QVFWGtnq6msWFbH87g7v8lbIciDDLzNjNQXKuip5e4BH7iNLlQfYlfOXUzQulYkiyhbcYW2Yj2huJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780064529; c=relaxed/simple;
	bh=jfqBxbrWMQ4t2mAdt0i++gU6J23Qbvk1hHJEgtLTx/o=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=QIrnNMnx1XEWSRzWjm8Y6yL6bGLEWBQI+LVyOlfGbMrqFwPhPv5pXoXBF7t4vAnFJg33OdcVOgUWW2+K3Cg/ftiJsIFUW2FcsqWXjz5gJDQpHfDjrmwXcmQarg6EnBBMOs6HRkxtJO6W7nkZdeg7gjFKd8PW1uBw+AOzLISJ0oM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=Vxieull2; arc=fail smtp.client-ip=209.222.82.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="Vxieull2"
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020082.outbound.protection.outlook.com [52.101.61.82]) by mx-outbound42-186.us-east-2c.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 29 May 2026 14:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EZVer9rfv7qzm653Nc3SNVCOWw5ripAbKG2+lqHEL7xVcGmxvZGjinrw58TKWzfJjfdBn7fRIshWIMFGoDbSZvL94ZNSMqyeaWPn9x/N65WIDgFqLi7vuZVHnTnGiD6hgmY0jpOdDi149juZfK4oEubgUUcSbboMjN1w/J3JOej4vWIuS8N+Qbhw6QGA/iIjj7nkU1oc9xQubsKKJlbrfck0O++1A0Rj4NmtE8H2woQN0yfBQpljgicNS1B9xLResCy07/TY9TQVbY9WvgaZdF61T014Nuzh61ndmLee67qmfMo7PVKxnMT40vKKMWRwxePwGW3dZYJoWvZilLYKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xw+Q9xYCu8SnYIUaf5fGGcoojOmNUBx/JW2Z+1p3Eys=;
 b=MWXj1mAzzjp4xJ4eDyoL4bW2KzICzppy2L/YE+ALM36Au67GWhK1BpX9APjQhIfGDuPfh3taQtEE3mT0t6l/JJZPrXo4DpZP0Lj3cSwyEy2HpKntYOcecPZII0noDTzUBLcjm4prQ91/0tum34kXVbEtrXLXNHvDwl3nJSX70qt8arp9nCrbNLT0LAUI/QhMJgcUaxDxvXZ1NphMUokuevyliYarsJ5GPJZP+HUP4ndlW4WFuy0eYhW/0dtBOlyd2DnxmJiGr5NJRRnnYRuVllgVXW+NE1Lw5jE/aG6uc9D0s4Q1tsEV5Oh9B+pkLE7RTNoMu9hpPJZoL2iwQZGikQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw+Q9xYCu8SnYIUaf5fGGcoojOmNUBx/JW2Z+1p3Eys=;
 b=Vxieull2qhdrKfrTi/UFnG7pJnrJL5uSH8y/KgP9eGQPanUVG/u37WKSuqYmsKaYkNk6424ok099eaq8NyaZaE4e/3tmXhunvJDWB1cLLhg4iQQNzLh1spgBRMkySe4nv7hJ9AlhpL7VHvlF2txAtOITkUtxVBnkevKFd/4tEHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by BL0PR1901MB4721.namprd19.prod.outlook.com (2603:10b6:208:1ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 11:47:48 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 11:47:48 +0000
Date: Fri, 29 May 2026 13:47:38 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org
Cc: adilger@thelustrecollective.com, dongyangli@ddn.com
Subject: [PATCH 0/4] e2fsck: Fix orphan inodes processing
Message-ID: <ahl82qlLIuodouNz@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PA7P264CA0351.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:37c::7) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|BL0PR1901MB4721:EE_
X-MS-Office365-Filtering-Correlation-Id: 45eef8c7-5fd7-4ad6-e05f-08debd781b6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|1800799024|376014|10070799003|366016|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	J6t43UfNHqAhJ5PvcUipaMAix9zJM0LF5PbkWuxav5t8ghchpbb70NfYjgJdVzFsTKyWPjaKBnF/46jPWbRIW1r3yFy3H5Kk+/g3l6x9lbqY6Cq3BXJN7dQmS09MD88HhDkdl6qvpxE+bvAsHRYXCwtanI2sjoT6NsfYLcvg3qZAygRbxx19KiQEsJ5w0ZtxVLQmb6R5LU6zqtAVt67sG9BJWJaXFcQUyCHXljcpE8DDjyAVXb49JKBGMezlDIRpYC13qCm3gxjD39kXJqugEjnibzGsPEq6KQArEFmbgaSY4XqY4W1NpZTb41Sgg5cyvu0iJg73lX+7Q8DF/cGkQ2NakD7/evVWkx4JasfAdZQBbYd0Lq75xSUEE9UwYUq9wmmBlc1U3dws6LnH+VawyH8370SSrTPOBF6H6RyyFcrC+Q/1wwQPpNiGvUfx+YdbAAVa2x7sZdKuqOcI1FJi2rrgmVSRHCEDaUIrnO/dpxFM9O56LlGgEBIzFPfJUQPj6CKPcUKZLyb3OmpXPXkW9lAdHh6Wp+eZSte4yMrIVT3VfUfrSfvh4miusEbvp+6gWYj7p/DMrr+d1ApTVqfO2v0xCRznL1T1QDO8XfCJA39gGg8Khq7yiC58os3ya2S+KoXpfCNZM3+RgLebFE3BMZKDpTUpv6M2tojgeI2uWyKiZ7KOSrsKQb7gcqmHbrT1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(1800799024)(376014)(10070799003)(366016)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QHD2gAZDMjhwHIsTq/RO31lq1JZU+tVLdBtl9s8Y/P0jUcqZq+l+9+GkOBEp?=
 =?us-ascii?Q?AcOTMPvB77gJm9Zgswoeg0BrCrsURXjjHRF4J3yxjwD9xjhr2mfArLW0EzrT?=
 =?us-ascii?Q?S7KpEkZogCqo6PWe+AW/N9SmnZBIhLR5VoBNF6kaHGPeVAxuh3B1a/Atzr80?=
 =?us-ascii?Q?I+PxK4kOtR8MWTMkxDhhxfIAz0zZ96rz37OmjgjjiAE8tZCk9lG/jAKndGsi?=
 =?us-ascii?Q?HJNafHqP4kjjfmkIZLUjMTApAx3F02A5n3T5wejoG3x0I6tyb9zCZcpNTJ5M?=
 =?us-ascii?Q?zKUY2OXrYdHLG+Hk05MH9YlxeO2Ec/UM3NT7WaQD0KMVxLVeuc09G/NoDt5m?=
 =?us-ascii?Q?N3yHghlGWtX/fUTGO6Y4VXrcnEvZeqHQKZvs4WlMz6SUvdLc1EM9GXv3GGj+?=
 =?us-ascii?Q?yJMMGu9XZQz8CefXP0izrXeY0g0mTHvJmGGXvXvJ3DHzp6BtHN2VSVDtViWS?=
 =?us-ascii?Q?FrMgElLwMaZcCrEPODVtrvi9ihDefFduHMW57FO66kEOqls0oYUcteK/iMIs?=
 =?us-ascii?Q?20BYsiaC0qQrgVuftFEr0npNQ2RxOJpBSYgNuowEEfHeRZ9IDS1F7xxqTUC6?=
 =?us-ascii?Q?KAiGYomJblhdbt13DiwneVVqm45BcKp2zTGiXviSYFUHuKBCISFh4ONwkhWq?=
 =?us-ascii?Q?SdEw+HVmktp6e5UFihjl7onTaI5mm+GdFn6VRMxtCZEVWkXDfvHzbTyOagpk?=
 =?us-ascii?Q?D2TQReHKdNn55PWRbNPxHZhjNFq56mjagi8n2WYDjn5LFuOJfCCf594mUPjg?=
 =?us-ascii?Q?s1F+SDbia/eR42zrvZK/Lj7b3R2q5odnPwGb/huzajcH/8pj4zs8gtg5os9K?=
 =?us-ascii?Q?mOM4DL4CTmwGrXh0NLiiKyvPE3aNkgRHe5NpPbj6f3F/FeQ0OchfyCljzkOv?=
 =?us-ascii?Q?E79koGhISi3R6Y4siOYI9TUun/ESN0PFRzaG+cbARpg+Ml3DRgq9NdYLjtFE?=
 =?us-ascii?Q?ZnkOhav/YbQEZx4CFRGSwmB5Qq5oayu70ZtZaGExoVHw/xny9u4aW6pktnw1?=
 =?us-ascii?Q?ZESqwjRjnwcQfFBT2XrvJheStlnewbAB1N9wO642EQfShY73kAp4pWE99jMF?=
 =?us-ascii?Q?6M1Uw4gcsP6r6m5iNANLGen912ugeSijqMUNx0koqJF9KxlM33epbyxPRBmo?=
 =?us-ascii?Q?rAcPiThRy5OFBvEmQdHOs0HwWf3vE76fu37n9fWlUOcfUuoWWf2C7c2kPhWH?=
 =?us-ascii?Q?nX/UMEZmHxkQbcoOJI8xOV66c0fch5UmiiWLFeibLxhzoT3NXO3g5HVw6j6A?=
 =?us-ascii?Q?fVwIOdiOR2hBm0O9xyy7/sD+t0BOF2THooa/6802XXVlpRdxF7QnoPuhexbV?=
 =?us-ascii?Q?uw+qJlpMlJtvtgfJ/zYuw6acTUKg8AI+lfQmlr++krRCrg/XA/gKD3skX+7W?=
 =?us-ascii?Q?l4qpDvWOcDFrIJD6EI+BAuhtqBt3RfoHN0Lj8qvuHXqDo2aAA6shpU78BxI/?=
 =?us-ascii?Q?Cg+skW77BHk89rVPp5TQjEN1Gev3xvkMVXD1m2DhgjW4oEU2ZHEEA1Ont2ga?=
 =?us-ascii?Q?/IZPnq2BmGUG91n5n7OpMmZ37wjk9m0SrPoVoq1cCl90dCxlp4b0987WeESd?=
 =?us-ascii?Q?dB0gUw4oKVdQQ288ak9Rg7dNy48MF+V2txmi5IOjNtBuilNWxXOMLIv8/uc9?=
 =?us-ascii?Q?4Pc2Djz7MJ/2CxyijtHcmVb0uaWwc/zrygNPL0T5gOH4GClhkP3VWv+NEoms?=
 =?us-ascii?Q?ykfPwGmg4P3fYVDd/InbKPRoCAZzOseoc2yOVdKRCNhEofuLXqiQzbqLqsYV?=
 =?us-ascii?Q?8tvVSwoi/HaadAWjrDtfsccJLQUGKHNQGNf4v8Q3tK3dLkpdyyTv?=
X-Exchange-RoutingPolicyChecked:
	Tqc2kZXG+qO1L0GFlx/eYkawUgTb0cOj9NYWOjnoOyb8REixX2gTOuwnxPXbJw7PxLy6/6jSNrT66iQJ1aTfoiKqW5hGY055lBbrwsz4ZLUs/ouMYoOcCZxhXsLcTH3RI7jdqHb38eVenO00hOi8Ttf3zaMPKmtYl5XzuqBkZAIizyQLb5vwlOuk3ywOCk42RdQl9X7cc8U8hiaBB1S9PPAEWcMQYblUirv1bOpoq9mtC9Z+EgsWwpKrxNbHAu/WRhJE/Q2fwitkm4Pynh6Roj1iZKfGkxdOCFs346LPdrV/il7jvIkNmWq1hryRZ2D6LS8dmO09iI0SzFvGUbSorA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8VDijarERH25pcIaqB9pLUtCkt4w23NmdhW2BY8CY/cWjVuYX61K76QCWJjNSIwFkz+AhAPfZ6NPWn3j0EaOl/BjfztLKSRmbvbmGpHlQUCtWKAbxl3cVBYvpprGJ0lQJT/vgWM0gdk7Jg6iGRzpVowjunnpWfN5xAOGpItjcteQJ1kktKqf+BtA9fWPDV/nB8YeuZxHsAcpvTUhkaIZlk7myCK+ZOLg2k07TZAQcOocnPWVFp7pnbWWg40YGjXsJ+sii1JwN588odIMjYtqlI15MbcWbZlwP24SkJJGhU0E7zFFkOkBCKC2A9G+W1dlMBOOgf4t+WdG96G2q+os0HQpkHxotslWlW4pGmW17ckRAfYK61NSpwIXG6VLsu5f4RN4NUlgMBAMtizd/VVIgLwHotTqgKiy+lMhEHBDxk1BluDhaZhVet8tfJuFfGVIpovNw3R8CGlE7L8w/TGUx3SZKAsAK6o23MI2d5+4BihVz7kSzN0KUiw5Nks+Qpqp9eEbF+vsSLNhkBgnW/QvWlmt7MyHj3m8WDR/t77YSNM71zTiVHU86/0VXn1uf11OUreGDorINk+d18PtthzAo0RNI3VYsQCi6/1zOaMyb5x6VLMdGo/b2drPq3/0Vsl80j20BGO2OANmdb60X/3h8w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 45eef8c7-5fd7-4ad6-e05f-08debd781b6c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 11:47:48.8541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTIKTlXD93QJxnkHXPuGvX4Lb3MrLsCRijH2QwhFw9vDHbZzZEv0TeGF8YheexnjaOIgEHLJUnXCT40h3fY2Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1901MB4721
X-OriginatorOrg: ddn.com
X-BESS-ID: 1780064524-110938-7720-7753-1
X-BESS-VER: 2019.1_20260519.1529
X-BESS-Apparent-Source-IP: 52.101.61.82
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaWpqZAVgZQMM3QLC0pLTnVyD
	LZwtzAOCU1ySQpxdzM1MjIJNk01cxCqTYWABmmi0dBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.273539 [from 
	cloudscan17-56.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status:1

e2fsck does not handle properly orphan inodes.

Case 1: bad free_blocks accounting with extent files

 # e2fsck -v /tmp/ext4
 e2fsck 1.47.3-wc2 (11-Nov-2025)
 Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=4096)
 Setting free blocks count to 2554682 (was 2554683)
 /tmp/ext4: clean, 13/655360 files, 66758/2621440 blocks

 # e2fsck -yf /tmp/ext4
 e2fsck 1.47.3-wc2 (11-Nov-2025)
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
 Free blocks count wrong (2554682, counted=2554683).
 Fix<y>? yes

Case 2: e2fsck does not support orphan inodes with ea_inode

 # e2fsck -yf /tmp/ext4                                
 e2fsck 1.47.3-wc2 (11-Nov-2025)
 Clearing orphaned inode 12 (uid=0, gid=0, mode=0100644, size=0)
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Regular filesystem inode 13 has EA_INODE flag set. Clear<y>? yes
 Unattached inode 13
 Connect to /lost+found<y>? yes
 Inode 13 ref count is 2, should be 1.  Fix<y>? yes
 Pass 5: Checking group summary information

Patch 1 fixes the first case.
Patch 2 includes quota function in libext2fs (required by patch 2).
Patch 3 fixes ext2fs_xattrs_* function to update inode iblk and quota.
Patch 4 fixes the second case.

Bugs tracked by: https://jira.whamcloud.com/browse/LU-20049

Etienne AUJAMES (3):
  e2fsck: fix orphaned extent files handling
  libext2fs: update iblock when using ea_inode feature
  libext2fs: add ext2fs_xattrs_release_all() helper

Li Dongyang (1):
  libext2fs: add quota to libext2fs

 debugfs/debugfs.c                             |  33 +-
 debugfs/xattrs.c                              |  19 +-
 e2fsck/pass1.c                                |  12 +-
 e2fsck/super.c                                | 295 +++++++++---------
 lib/ext2fs/Makefile.in                        |  43 +++
 lib/ext2fs/ext2fs.h                           |  10 +
 lib/ext2fs/ext_attr.c                         | 268 +++++++++++-----
 lib/ext2fs/i_block.c                          |  14 +
 lib/support/quotaio.h                         |   1 -
 misc/create_inode_libarchive.c                |  35 ++-
 misc/fuse2fs.c                                | 117 +++----
 tests/d_xattr_ea_inode/expect                 | 188 +++++++++++
 tests/d_xattr_ea_inode/name                   |   1 +
 tests/d_xattr_ea_inode/script                 | 104 ++++++
 tests/f_orphan_ea_inode/expect.1              |   6 +
 tests/f_orphan_ea_inode/expect.2              |   7 +
 tests/f_orphan_ea_inode/image.gz              | Bin 0 -> 2139 bytes
 tests/f_orphan_ea_inode/name                  |   1 +
 tests/f_orphan_ea_inode/script                |   3 +
 .../f_orphan_truncate_extents_inode/expect.1  |   3 +
 .../f_orphan_truncate_extents_inode/expect.2  |   7 +
 .../f_orphan_truncate_extents_inode/image.gz  | Bin 0 -> 2854 bytes
 tests/f_orphan_truncate_extents_inode/name    |   1 +
 tests/f_orphan_truncate_extents_inode/script  |   3 +
 24 files changed, 842 insertions(+), 329 deletions(-)
 create mode 100644 tests/d_xattr_ea_inode/expect
 create mode 100644 tests/d_xattr_ea_inode/name
 create mode 100644 tests/d_xattr_ea_inode/script
 create mode 100644 tests/f_orphan_ea_inode/expect.1
 create mode 100644 tests/f_orphan_ea_inode/expect.2
 create mode 100644 tests/f_orphan_ea_inode/image.gz
 create mode 100644 tests/f_orphan_ea_inode/name
 create mode 100644 tests/f_orphan_ea_inode/script
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.1
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.2
 create mode 100644 tests/f_orphan_truncate_extents_inode/image.gz
 create mode 100644 tests/f_orphan_truncate_extents_inode/name
 create mode 100644 tests/f_orphan_truncate_extents_inode/script

-- 
2.43.7

