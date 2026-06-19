Received: from outbound-ip168b.ess.barracuda.com (outbound-ip168b.ess.barracuda.com [209.222.82.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83050382381
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 16:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.102
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781887856; cv=fail; b=ba7YRM2/TfQdF+9UT0PROSYxJtcXa1gKk4lXoe+tAOqlLbW93+n3MkhgWS8xYlecSL8OYjN7mmGAL+V+tB9NIhFKIosyRq49ZHpFqTPwTS3qGHemqaqI2BSGy6uABYLc2K7sCe76SB4n0SdAmz3HMd1YV87WHhq7CdY8fS89cHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781887856; c=relaxed/simple;
	bh=jfqBxbrWMQ4t2mAdt0i++gU6J23Qbvk1hHJEgtLTx/o=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=DcLtzRCvVQrlXZ/OfI1FMgA+V2kHMoQiDZmmva9Ql/m569zbOx9X1GE58STTHE1cA24fTN2rsYk7zAMcZNHUoeee4B5hWY4YFAWnBvJWi1/KM8VTcPRCSDfv1646dhWy1ccOnfP3Nxs6osoFCC6cxnj3wjuk1YYkYYaAAdIBEa4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=bBwt7cWz; arc=fail smtp.client-ip=209.222.82.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="bBwt7cWz"
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022130.outbound.protection.outlook.com [40.93.195.130]) by mx-outbound21-181.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 19 Jun 2026 16:50:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKhnSCXzPrVPp+Af1KeoPcKEZiUzp51k3lCkFeZ+/eg5KngpENoR3AEVkzjXJ1Gxo8Eo4fS3Ha7vQBPrMzgpMYytLI/8KQFqcAYPDB0Nn05u0ecIBAiSM5WtVfn+kpruVmTGjlILFWhtbsModuyzILN93F49Uv5F5o6l2q5gizCOSe5JiFOEQX7V0rFCQoILR0dSbhhLTuZxAhjnLBBKDZ4b+mXd/cfJQnlcnUdWbT1pevKi7rZkSbCQ7CJ6l6hjFYH8gJkM13PMuYCGeffeNsIwQgLjKPpBSfoFljIS2OfcMYg7oXqDHusuJzRJJ6mphGeMdcJR53ow3LI70sCtMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xw+Q9xYCu8SnYIUaf5fGGcoojOmNUBx/JW2Z+1p3Eys=;
 b=CAAP3Cku/9KRX5swZEamF4eG7v817NPf9Z5ntjVb40j3TQo9zv1KurzDsbsmoo6SO5I7hOhZTmtbSUe5KYAlqpa0spLtwLZWqEon40uw1dhGGJY/VWkRCNQ0uQKUSTfv4Kovfzt3L1haDqqWuNmkYZ55nChxzTQfDLEINpLxGqaANHm56mCWo9KHvP3sY6SFUYWZyh+aV/X/kcc4NhORlg7QDoS/hMlp0o7FIHMlceSQ0z4tCmezVsXlwBmnv5Af2OHTP0unRiZsx4lraPDTrTgK9gKi9AVPHSfIRgaFUBDZCSBeFGfJnJULy4MHJH4eXGi2Rzt88HtowpsQH5sISA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xw+Q9xYCu8SnYIUaf5fGGcoojOmNUBx/JW2Z+1p3Eys=;
 b=bBwt7cWzmvzgt1CzF1U6PnuGG9uUaoqrT9B6JF5VGxg4JJstLMD3TXULHYcptMnW+1wW227IxaZWzuUpzxr0EWCLPOi7c2NRKjAd84C5g0afHvPqjC5qsbZeM8d++DJBsegRaY2qdZQP+lg6Yn2sdEgUrzelkxpm089Hk2k27C8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by IA3PR19MB8787.namprd19.prod.outlook.com (2603:10b6:208:51b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 15:17:54 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0113.015; Fri, 19 Jun 2026
 15:17:53 +0000
Date: Fri, 19 Jun 2026 17:17:49 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@whamcloud.com>,
	Li Dongyang <dongyangli@ddn.com>
Subject: [PATCH RESEND 0/4] e2fsck: Fix orphan inodes processing
Message-ID: <ajVdnQUu9tSrKldW@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: PA7P264CA0105.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:348::19) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|IA3PR19MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: ecf02b2b-097f-48c1-76b9-08dece15ef30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|19092799006|366016|376014|23010399003|11063799006|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	HMBRt6kjBmdkPWFHm2P2uE3Ce494Tkd6EoBeQcRUF14D23DBueSi4Euy0MNf99YdW+jWt/cG9M0eDm2wrG+nsyc66frc7bQCDDk64J4OcBEf6lMf1f1KIULTwV+nSFR7OCLU+dnj2WNDHWLZWqlT4gdzXoz5M41YsteN/9yzq9jZA87kU9tOENDXYIaceb9iCy5WkqF88guJ7/JCWBOQx3jEzHPvPMQWc2FVlcUTU8VDoZGoSHFyKDI5QmDBfBeywMjWIb9XPma5J9wt5PLyTeBwJKyBe4IaV6WheteaD+v8BD0E0Nt08t6MPnLTmjC23MS/lznWHqQtVDOh3fWzhp1hXJhAkrEuxsJAOiWT6hBvvNEZexQ4B4Ci3byO32ZVdlRWP4FnP8sk74mkLjjYaY9ZUalxAwDbBkhNj6fW+l+/eFxa53m5YMt+18J59Kfq1N6WOdaQb20nAow18uI+WzB1L+Jio9XAw+uXqFHgdJzJRatH5hAN/A/cd4PaKO2IcLzrssej29ZFJctvdqdiMEg2YVn+K7rYVrAiLclKzUc3OiWPW+UzIBr2Pq5FulbADpscXGkriei7Fa64ca70VvHa/i5uGl1R7GER9IHpiuMLOrW3uhm9b8yNhzRpeTbium+wmFOOgGiNax4O2laF70z0x8qRz1N7X1XDs616nx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(19092799006)(366016)(376014)(23010399003)(11063799006)(18002099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I88Zgf3dhvTGn6ADzJKptIBGzIbfy7oYkdsl7wPfAbo2R+RrxlC5MJwuDVVB?=
 =?us-ascii?Q?2vSFt297oDBayHIo9u+uFKW5M9+07WxzDeRa0CtsdzNvXC16jTEZjojUI8pD?=
 =?us-ascii?Q?0no3JOTcmQrx39PhOhja8vPOPC6/BFiv8VyjrM7OqBkr/VUnAt1eQllvVLHr?=
 =?us-ascii?Q?6e2K/Jl89E3WwQk1hQCanitCauwIrI0CubBRzW0y5E7wAQkcmxgPNBLZ5LJm?=
 =?us-ascii?Q?lgFA+Bf+POxNnPgkaZtB8aoUwed5UQHWP0CQDdFh95LARKdDUgWHv/Te1Hbv?=
 =?us-ascii?Q?41jf9xTES4JnZs0hHt5y0wjkCwTIqpQVP+YNHhEoIT+w2UevnYtQAWJd+2Gj?=
 =?us-ascii?Q?8kccZsSNCT6AMajjV0I0iL7oSJdPgehjWXM/XDz53GhJ/N9Mv9SolCqqAP+/?=
 =?us-ascii?Q?eriVNHGYTOH1ph4Bk1fMtXDnKwkIB57MNh3yUdkoNgK4uSuXhV3Uc5Ku5TJr?=
 =?us-ascii?Q?YNOROV0cIY3eFRFoEgE32N19SuY8HOjyaZo9aP1jq+Pl3Vm7FOkOeIARE7gw?=
 =?us-ascii?Q?BD1dqyB2iWoFv3bEfz7mVYhPkVt7pHbRVZxGFy+VvTJkLXWZIbNgUf1ZFi99?=
 =?us-ascii?Q?nRM2ky3KIAKZ+UvVtC8qHOtod96pCNIGP11dlbqYh9Z5feiflW9ewzR4lOIa?=
 =?us-ascii?Q?nax8/xIRJeFnEOeGwOFc13t9n5ZwPJD7sAlKqHL/NGfuu1FB6LsgA9ti185r?=
 =?us-ascii?Q?JX6QbvbcsRgn0+bjs5RMJJIIk0BTCsHAHq7JXJ0MCpkVBDim+kyabfUQK50c?=
 =?us-ascii?Q?FAjh/VOHz/1w/61LVxtP1z+vb5ySvQy7hs4AXPSJpCxVm785UARdJdoID5kg?=
 =?us-ascii?Q?ulYr4Xjt/q8+KadDM47HmuxPXU9FrfrNtLYbPKW4YchK+W5sNgU4lsr/cQz0?=
 =?us-ascii?Q?Hvj429HwzCJvKP9xOO0c1CUH2/4839LqgfsIS6sai/7Ssih9ZGHqMz+00NDs?=
 =?us-ascii?Q?sVze/Y7WHh2H0lyI3wF0NCZrdKOEOc3wISRXCkLDozeLd173eKoBT3hpU/UD?=
 =?us-ascii?Q?nRH87/dlGKEr7rRAFOd7j1AyzPirUN3a+paHYBG7s+5XJ5X5J8wSYN3ienAr?=
 =?us-ascii?Q?H64XQ2iaFWMxd457yUkvowJL3NeJb5PUEhAAP6Wio/v+1h1ZtoOUdiidPG82?=
 =?us-ascii?Q?cT1YCYa8cBLie4bDC6ojUon+8imRSeyP/AaYYqsOLdgLKratJoCTZGaGHQid?=
 =?us-ascii?Q?Kg+v+dmpBwAgqF7bd0i/N+fo/CRml8btocPxtWFy1iByBuon7Z0DkoaYx90V?=
 =?us-ascii?Q?6fkZhIRvq3Wr90PTli+/KPPSb4smoQmvTfn1B1EiIhSewG+RoAenxNqfC7D8?=
 =?us-ascii?Q?G8dk7ejIkfrq1BeUs9kCLaTDAJl42oatY2cTBMkvCLRNLTD642dm4Q5yg+cJ?=
 =?us-ascii?Q?jvdcu6j3e66dAAPO46d7BD3QBU/XeT7Yzlg8Kt7coWSPpPpSZQ6438s6nwIG?=
 =?us-ascii?Q?Hch4I03BzH+tgotoaJHMtTbLhQU/qjc79ciZxXFM9zpuzWLgj+Kk9V0Z9M96?=
 =?us-ascii?Q?fRl/1cGVCDkf1w/i0VBbKRgJQgVUepzi56FYBQiLsR56grVcn+ZAHNimKNmK?=
 =?us-ascii?Q?px7JaDCIZOF5IyMtIwB5rKDT9UuIZ70H5Z5AGtD78Hzi+SKnnHvhggXnBL2a?=
 =?us-ascii?Q?4RuHN5/WprgMAzzSTwcnRelBfpBK+MoQmSpCGLc/zfp9JODi7QYChF9lciYb?=
 =?us-ascii?Q?nRdAehq7f0mXNOKVgb/J96v8DSsoFQ7IFIYmtkkuadNNs7k6Xlm1nJ5XLViP?=
 =?us-ascii?Q?IwefSidGNcMqoYmd9bTxuSgkrNL3tynhD7NdF3cKiq7uBF5Mms9o?=
X-Exchange-RoutingPolicyChecked:
	f5aIi49+p397X3JpYTeLN5iL3SePi6dx26FzDX9p/7RoJwoEiJa3SHVA3ALtssaHV2afrlQ02cEeLwiU1vAxbnUojcr86gCyYVOBCPDXJqn5rVdMmAqJtTTEtFRpY2k5xEG6XBqsjFqTJIYRhZgBUuIPBEPSUf+RtOyoT3Xd869gyON33aQ1r1DzAfOOzTDbH5yX37AmDqPCfrHyN6P26xtcLMtLh5Y5lgJw0e+80ahm4HF8eHDU7XrnIs7tajI8NzqN2k9yOMx8ee41WL/JgYP/cRffYvFeYSyWm0Hk4Yec+SJXbWYUQsIRhuWZpQS1YKAtySaVUyL9veeHhVIzKw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MC2uDGuQNpIhtgQNseLWY+zijT2sVoqQRU0n6qLfzgGPjJtCuK0JMtvX5U3pT01BVWyqXL9EmbPFE4Floqpq/QFjv4NeiWULD4o3I++BpK7SHl9gVTZGVe87BQ+EscuNZMq2GvQoqUwdE2juRZb7TljGoOnihuW23uizKj3TvlnRW6++mNcCK2tejJM3roROhM6SH3kNHuu0gNpLwM+BeB1MRNX/sMjydCeK5B9NJLY7qnwhBLqGPbLUlgy6GqG2xOxvp9icVMRK8fDUr2TnPCA9qma7aCrGY+nbXYXUYZqeffXK3Agl2kUTBekXuhGAtw2rJd6rMeGDLw0jk9kb944c7gUyLit/pAtMOmRqJ0Cr6YsEHgPwZxFmtEoG8/1urNYZnwZpLaCv2EUUy0pTBxlispVArUPUgYmqkb3dekD1SBoWod/pSSXx8b7nXhGVQaa71S+OppD1fV/yV5yON6iDq7DVA0B0a2fNjZBBtNf7s+lJr7Gg3KEYLyq40I3nkVpdJdCiy05gxGwTBCMgUqfo39a5NskFtoNrqcr4jkIi6IHGAA0VraBtK4vYlhVB67l2bOIbmy6R54KrfNQHp4lzvGVfNKrLJnfizG7jK+Lt57whndtV9cwpuHhTPUQHSpqFbfR56WP0vQwMQQmQVA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ecf02b2b-097f-48c1-76b9-08dece15ef30
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 15:17:53.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1FoVxu+zpyZndVjl8BcGVc+qUcGCtQakelGWXBe9+nOeOMmXsmpKMXsdWEGSRgKiPex5jz3KcbLfsiSPFvzYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR19MB8787
X-OriginatorOrg: ddn.com
X-BESS-ID: 1781887852-105557-7687-5012-1
X-BESS-VER: 2019.1_20260610.2305
X-BESS-Apparent-Source-IP: 40.93.195.130
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVsaWpqZAVgZQMM3QLC0pLTnVyD
	LZwtzAOCU1ySQpxdzM1MjIJNk01cxCqTYWABmmi0dBAAAA
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.274043 [from 
	cloudscan19-88.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND
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

