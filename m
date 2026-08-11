Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC733B5302;
	Tue, 11 Aug 2026 16:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464251; cv=fail; b=hFh69sqCtbZyk5D3rudoaFXip63SQXMImPLAJ7tgqoFt7FXY/q9IXFSLBf5Vv7Yd3hC+3wAvrbt5s/wjuU9Wkiq7LeCErb5zCiMMs0v4aidW85WPqWv6rMhATLYslVGE35HfjOMExRCndH3AmnOQkgDqU/FHW0skj/Tw5bkM7eI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464251; c=relaxed/simple;
	bh=fKTqgOipO5UKOrHhg9yr+oA8lkz8G96s735Uc34P+H8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gsuCU22r5QpVewIWjvr/jZtf5TxVi0MLCvSkGf0Hw+RMToGvYJAD79RivIPbCrABukHW1MAz09ZAjlGizCETxqMSUEqybB7Rz1/0Lk9gq9cXEnrKstSKO8izNuyWXwRVI469OLrhvQOO+QsrS2OQ+ARbaxn9b5U6rL2nlqublGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=cD9m6i2n; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="cD9m6i2n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knvbcMkEbfbB1kHKvmU6xO3tUHUuGPKXCulC6oUttURdb0fCPR1sCIBfRDwXXpSzs8paeGCwtqeq+HIP0ybO9BmY1xjCdZw2o0hLDvKfoS8gsHlSBuW9POkyeDSU78m7RQj0hVucdTA+5vBBgaNGsH01j2M6yVYoblglFRoryBI8x7d1LRK17slcVgCHgiuTP5YhAVqA2+qpS/idZkUWl8UvhMxdcC3Sc7w0nf7gnm+ll1rteebVrptndMtrHMF/NErf2uPTPdYtDmh56VmNWI1xdTCtHxIsLlBctEDGT26NgLIvsr0Ov3bQ540c02pwBKrjt9LjgqewS4zun6tw6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F675jzwBz420qsGJFGR/6jH0PWhHGmM7J7LN9vpMZVY=;
 b=NeSgvFgsKlXXZXdZJmuKj/auIc7HSWeDAV2ck2vsnOJTp8HH2e10zuuE4zcGglLtyYA12puAVxJrJVNxNPg28euOGqCfDEXRQhAjOqAOyDFZ+KJMHWqhbqDF/9iSvkbrZ6t8eDClYQ2uvokHwao7B0gOU6XZZsQ7ff9f77CsFmy5MCmhI6DOF3WT5NLRQI/7u+cWkGQlNwqmnqMVuyWQN7aKG5lVOKnHN/U/Ma9+SPQBBpOzeejp5uEUXs8Gc7+Jd6gcfwZlJ9SD7Ez/L/GnQXgOeLhWqZV+MG/rWgrLdFoMjm8l9+CenXvfSAd7ROgFAmp8tsrjL9YvHrSDrTV5fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F675jzwBz420qsGJFGR/6jH0PWhHGmM7J7LN9vpMZVY=;
 b=cD9m6i2n30Oc/u1CbpzR4oi5ErpOBuR2v6gCfLBYfxkCST1fIELZiUKwb/n7lPzeQ2Jw6QViZhi6rUuyTiPBi4doob/fy2fAZzDNESgTc/XZGzbeFOm9wLScYapExA4hv5za0KIimEg29bO7ZoaG1CrDszms18cgNjA6Pkb1iU+1V66np38NpDCb8t492BeFJat1uQn32dFbMVGB2k6FGyHorkQL4rgDXKiD5lAGczaCYioa63qiUUhIjLX7B0ks/dZDbWiYqQRv35NmjLRfv15YQehSMk0jVd3D/QTWEu8LGHVn5gIqYai+vxuxEz+cqI/VjMj9Bwlp3XUn7Va5Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:03:59 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:03:59 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 0/8] Support Clang context analysis for ext2
Date: Tue, 11 Aug 2026 12:03:28 -0400
Message-ID: <20260811160336.782342-1-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-Office365-Filtering-Correlation-Id: 2e2235f7-4db0-41ef-34f6-08def7c22755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kyTRkl4oNXbq/TwTD91Mo5fP87W241/+GIKvk9C8MqJ4v/HtsKKhNIQQEAgH5CJo+ntaDzFNM0z9Ig+ye6rjAoUGdGkz60slKosb43XHRbmGtVNzlt13adtqcjLFgioWaK2OSgAjUv1aZD79vF5E6eire/MGCoQapuSyW08fcInfpExZmhKhtZZA7GXKqJdgt7Du+Y2ot5YrjrJX6Ugn7hMkrndEyfjv4tep4nFm8f1ptoFY09BU5Q8B+L+jbd5WO47/uqBWyD9OWMwoYLFM/lcpP7YW5Q+9zyf48p1R3CA/B6KcyLVx8JAPJGJuxxNPEH3wn+8wo/J8jzBzASOL06yq3vu/FCcmKXL1VeAltgvjpbn1zY6FsMvCRsFpif6nKiZVVojFwidTYaqv44tWfKL3DQj1z+Ist+eWetksvVgiOnWVkvE5ZoKb/evSFBSY98ccPEjsVHM2fRaXBJRIok3PACIpVvO8aNAmfCCSPvlYDwxnfsPLfIDS4hIm4Qey5DPmCvf88b/ikMkU9qK/9B8GHz8kuYrGTfpH3me2SLakIrSgQpLlb5YbHxAc0wvYnkrOLn8MIEI4lPi4C/kZAzV9x0SOcyM1Idz/qWje3KAeAcmHBwPrdo7Z/hjCfyrPUFfzXUASfuaTlJr2pzgM8+MDuKIcFU82LMayUEo0Ijk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IFjuB+L7CAURFGV6CzMhrxnVdz1n8MI32VdeGHTdtFJUWuMYb9Zah8BjkYZF?=
 =?us-ascii?Q?pCd7A3eHMJz+fhPKKvOnmx3PZE26D7Kpc/9i6o+mfvWf+OvzxhgmA7F8X8kX?=
 =?us-ascii?Q?TZfYf8BdcRVVOD9AyZxz+GoI5DYZ/i261hugtPhYiE5a8XtPHVyPLvoABo7i?=
 =?us-ascii?Q?R0wX0hgnGn6L/YRf3gbRarH8nVST7JZSYllvzWF6iS8K22MR7uH3AQct/B0A?=
 =?us-ascii?Q?1ZTzRfNVTf/BVRrm2fHji9+F3d2ZhwipvysO1USjipN9pxjLxGg24iu/2GH1?=
 =?us-ascii?Q?sMe5oQCHAMuLn9OQNO+3tl+ZFJwi07NBACJH4Y/ppMGDQbwmn32cAidvnM41?=
 =?us-ascii?Q?VmPr9zEM8en9BptATfdBG3pN8WxkMoqlLDSyuygvgOJxfabf6CRMbOnUh6D8?=
 =?us-ascii?Q?bpskeTeeYTX7RWfQf12mjXOlQOZQLLhIfhfNW6fPVvzNn6QThCjJ5S+zvkLQ?=
 =?us-ascii?Q?NkpUVNmE4wpR4mC1BaXIRDwVPdgvPVwvKtSmgPSZ9BuNbW1SgtssXJ6l5UBZ?=
 =?us-ascii?Q?VmCsjLOkiDcGBCcjbzf6gkgF3zh/wguvtA/jlbWdIzDesPs4t5rgBXeRHFzN?=
 =?us-ascii?Q?xezf/q5gby0t8LniChPsdmFx94fr2t68EPzWt8Z0xx/9LhuN3EWUmPHe5j22?=
 =?us-ascii?Q?JImj+yb4E1T5+QpPWwnXHqOgG+5qaOtlSzexgWsZmLJjmJGtFgJ0IHw50Jfk?=
 =?us-ascii?Q?muDC7kyNi0dlMsyGqC+FExuIc7RvHjGd+zmFyF9Y3VZWRvjqiyLTZnbZvBhG?=
 =?us-ascii?Q?x73yVrx2q6YBV1BZenkbf802uBB5AbCx4XLeOZNVTAgBrkIUwbFnwkhTBDO9?=
 =?us-ascii?Q?9cO+NKYr+r7ksp97N3DQ+zOpTfHwMrNuyiteTX7tponW/0kZQXbtuPzx0NcJ?=
 =?us-ascii?Q?tugucDMth9Ca3qh7PyHq8LVlAq6NbncZwQha7wMMDWsavc6Sb9d7Lv/F9hUK?=
 =?us-ascii?Q?4HUIos4q7Mq7TBQAwysccTWsADBKRozKjAkBveGKTpBO8B2Dkm5bGjjjHgdp?=
 =?us-ascii?Q?75T13ixC69VTa1kWAAGBUHLVHmoM11Jx8CWW7X348VR3Jj3MtVL7lxwHCY8K?=
 =?us-ascii?Q?KMxzKvlq2/+RTvijyHL/Iu063/V6eam/QAZqikuw/gIKIlj9ua6MnnN9IyZf?=
 =?us-ascii?Q?UVsJxRCCOw/NKNOpc9SAxI6Ah+++RPA9m8dKeZBEbPA0zRBcH9ttMqKJBg2J?=
 =?us-ascii?Q?h++E6rY+BBwezXiUU5TZ/RIBzqEC0DfF2d92WndKZky3PIE9wpmtkBECq0k5?=
 =?us-ascii?Q?VF9h4A2rOG+v2+NKNxNVR+vt07LdrG2WJ7W5GGjizqMN3c6vrc5/wIBo+7tu?=
 =?us-ascii?Q?68GrAyJdQlmBEA7mRS0/KiVAqlfvHNqy6JNk3wy6vfAmBJ08AZfJ7S3FRBh6?=
 =?us-ascii?Q?UPDtfiu0fA8FQRwuaY5J9Oy6T3dpAmg2ubaXD/ZcwzLM9OUndofyXm0FnY9t?=
 =?us-ascii?Q?X5LT4Y3VO5YT9GY2i5tgRUVCp5Y+FLx7JVJyPwyU7HppATlbm9+P/L69tOn5?=
 =?us-ascii?Q?SI/JLzHPgrSxFULSLepi8tDlnyEif+d5nX64L155yIJZSKzhprY67o+Pgzy5?=
 =?us-ascii?Q?2G2W9uOYwVzpT5IF7JA6g2IbLRitttuKR//I/Tyrw/ZvGX3lKalS/WgMMfHv?=
 =?us-ascii?Q?vEztFGGI4m0qr7Gb05d5hk50nqhJH2c3V64dyjJb7HahEefixNi9VjIxVgtd?=
 =?us-ascii?Q?CbeK8M2EaNc8Y41OoyHKpuSiKAPMyHzdEjUkaEUx2ENhlgRuZwOccvLK4pnM?=
 =?us-ascii?Q?NS0Ibjz5wmUTFBTxA4cUurk5P3YQB0U=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2235f7-4db0-41ef-34f6-08def7c22755
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:03:59.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xsjq8XzREeWnK/jeob/nvbRxz8qrbYuBl2Npz3sK2DTOB5jrCRFZ05SYqOlpFrlNSswI1Q1HDzU21/IuVYD+p+YUTCD9W7eQHvhGcBGAHwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

This description is mostly copied from v1:

This series adds annotations for Clang's context analysis to ext2.
Clang context analysis was recently added in a series by Marco
Elver [1]. This allows the compiler to validate different
locking patterns at compile time.

This series enables context analysis, fixes pre-existing warnings,
and adds new annotations. It is inspired by similar series in the
block layer (NVMe host driver, for example [2]).

I'm starting with ext2 since it's smaller and simpler compared to
ext4/btrfs/etc. After ext2, I'd be interested in converting the
other filesystems and infrastructure code in fs/. I think the ultimate
goal would be to enable this by default across all of fs/.

The series was built and tested with Clang 23 with
CONFIG_WARN_CONTEXT_ANALYSIS enabled. I based on 7.2-rc7.

Thanks!

Changes from v1:

* A false positive has been fixed in Clang [3] and ported to Clang 23.
  Hence, the first patch (silencing that false positive) has been dropped.
* Use guard() and scoped_guard() instead of context_unsafe(), when
  possible, to express that certain fields are being protected by a newly
  initialized lock during init.

Link to v1: https://lore.kernel.org/linux-fsdevel/20260712165610.366474-1-timday@thelustrecollective.com/

[1] https://lore.kernel.org/lkml/20251219154418.3592607-1-elver@google.com/
[2] https://lore.kernel.org/all/20260706141452.3008233-1-nilay@linux.ibm.com/
[3] https://github.com/llvm/llvm-project/pull/209796

Timothy Day (8):
  ext2: mark s_next_generation as guarded by s_next_gen_lock
  ext2: annotate ext2_update_dynamic_rev() as requiring s_lock
  ext2: mark statfs overhead cache as guarded by s_lock
  ext2: mark s_mount_state as guarded by s_lock
  ext2: annotate ext2_init_block_alloc_info() as requiring
    truncate_mutex
  ext2: annotate block-mapping helpers as requiring truncate_mutex
  ext2: annotate s_rsv_window_root as requiring s_rsv_window_lock
  ext2: enable context analysis support for ext2 filesystem

 fs/ext2/Makefile |  2 ++
 fs/ext2/balloc.c |  4 ++++
 fs/ext2/ext2.h   | 19 +++++++++++--------
 fs/ext2/inode.c  |  7 +++++++
 fs/ext2/super.c  | 35 +++++++++++++++++++----------------
 5 files changed, 43 insertions(+), 24 deletions(-)

-- 
2.43.0

