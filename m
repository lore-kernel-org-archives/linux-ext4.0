Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6703E3DB9;
	Tue, 31 Mar 2026 13:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774964545; cv=fail; b=FS912NIqJjrMMxU5lfawjNKzJZjHcn5NeXuYcHwxiOLC+S1I1MxqI5I07H2Qyh3IEAuaYPkP/eyE4UF9x4HvBf/4DZAz3tiHVZ8L/7g3HcNidgc5SXjLgAg8QppJWzXjpLXf4OPQaS2iFzIDTCqYjBmyGj438ugp++WZmu+rLMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774964545; c=relaxed/simple;
	bh=7q5eZ3LcQKCC5ORG/NQXsCy38ANZ3Gmdc66FZeVQSgI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CB/NissOla45ZB4Vo2t7YghEMhEnhVmeZOlP4oLrwHEdPuZ/E5o7Y8Tdx+3p6wUK2zJMLkultOGXez2U4LX9gON6GAUuNCIfcFiJn/P6ER2m6jYSuvK2M27TMJjTha8qK62oxstEdQhBFuXxNIQf9+4A4r42N/hcNrDyeAKkk8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f74Z1gRC; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f74Z1gRC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774964544; x=1806500544;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=7q5eZ3LcQKCC5ORG/NQXsCy38ANZ3Gmdc66FZeVQSgI=;
  b=f74Z1gRCrQDd9fnY1Ecbe9hFBQdqhkXgOUBhyEY4ZFe75wfQzOI37jKi
   CpJ2f20oQQq5kek5I0dlLPGp0b2P1uQK5lTTnB7IuGjSrAObsqxnKxp4n
   X3BRUcLqF87TDaKKhKvnWynZr8QH+tqy5j1WLTxn64z+FtoM77CO0GIls
   358Hr9nSeMlO4mhjnxLuMMe6n+u/qmo6aZVj/UV2CoRLb09C3TuGoicPF
   PkxO3TqBR5zrnHzHkrSjP6esFqCusKlxZ2uQbJ7z+UBiMO3jTrbxyyKsv
   VVJMNepLBlFpAo4APRStv/kEhucd5YnM77M+OnBil+BUrg2IdFW23K0/F
   w==;
X-CSE-ConnectionGUID: TTiHXO8dQ2WwNhvN0eZPVw==
X-CSE-MsgGUID: WHi44/PVTSe8ueUPiYIUGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="75940986"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="75940986"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 06:42:23 -0700
X-CSE-ConnectionGUID: UWwEglTCSzCJyk/hNeeM9A==
X-CSE-MsgGUID: r47JkPsmTqSaJmKO9x6PvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="226239388"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 06:42:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 06:42:22 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 06:42:22 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 06:42:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrAmiXBew+t/44HXy0DopbQ1BA2vsZzjBVSZGlFSc3Y7gq2YkVmr6i3/RtusEcSLl2Y34/DjkLofUO2uGwKPdIvZBAowvxmJL/WxlzdV/nTIReuEaXuaRQAtgadZed2hWbha3TbIbZudmjDzR6HP4G0xDQhuGsYGwN9Y/WJ7B20H5MUPEVVkR4ypscJRMl1QJlUHHpB7byd8zNveOEH1aFrmCGN276hPBFNoQleXuqHaagAyqhyPFpkSKhIa+3AG6VoY4uOFu0YeQSWJplu5Fby6D+CQRBW+S8fYT9QkuEyb+iChardmcE8VvNd27GKV7rw4MHJ0n95ImMoWkvSyNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXT1LOOfoElsiphqTG8SXWv/NCPJec+acgPYl8DEzaM=;
 b=AHQP6LBQeg0012WYzLr0HulQuaJ+LR6k1uBsSNFfTcKeFoleCbaFrlNiVinn3ZykJxVijd1vqkx9M9TX+AxLKgqGErQtFak89pElQ7EBtAqcaLDFYxLUT5y4rqzynv1/fJDEkCqpI5egOsENAT5/Vt6jjQz6/Gkk1tWi/c5coMeTJZIITkbVWlDyDz1Nw0bVGEnjfVuCZEhFvhAQrpDcjUTzoAsNSYR8CGdPI6AFFJk+x5dgEB3qqpPQ8UwzepCPsNPIKzqbljIDwbZa6EmfpfuKb/F+XfI92+eDO2TA+EvvIghp1UTXZn3Q65RvdsQhGGbKkXYeej39h0Wr49T2kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Tue, 31 Mar
 2026 13:42:19 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9769.006; Tue, 31 Mar 2026
 13:42:19 +0000
Date: Tue, 31 Mar 2026 21:42:11 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>,
	<libaokun@linux.alibaba.com>, <yi.zhang@huawei.com>,
	<yi.zhang@huaweicloud.com>, <yizhang089@gmail.com>, <yangerkun@huawei.com>,
	<yukuai@fnnas.com>, <oliver.sang@intel.com>
Subject: Re: [PATCH v4 12/13] ext4: move pagecache_isize_extended() out of
 active handle
Message-ID: <202603312104.b8cce0af-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260327102939.1095257-13-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: TP0P295CA0011.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:2::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|CO1PR11MB4948:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f83c29-9303-4214-91aa-08de8f2b5400
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: hTtHmOtOFgJrhYY1wWbuWDcfcvBnwhBChFI07+N46twwgZPKg6mKvZctGXMA7DQ27LI8QNUEyVweLEYqmhu8f8+dZBKAZwXad52+x6WoFSzWzqDAUx5zFlpYQ22wIpxQ+mbkuSXaKNHF12INJiJWDJL0rSGjOxD1x7kfEdrGTUFzIA8trAiKih7iVknlS8sBmt1+3BYYJnE20eB0gd+9Ty2TRTSDmMUEUVqGxAEKgo66892XhokMGyjzD8dx4fUe7jB+af4IHyk9HNQjBOsguq1VWe8w1IzKVjkezLMaW+aCo/QRMTZN1kpM0T+2NuuR9RVDxa0FpTtSFquE1E9S6wDx//3CEk5uJJaIoC9RiknGSqhXwkdcXOv6t1ACuVxaNjQniqGacYu0/bkuhSbk8pU/T6eCRLUuJcGDb3V7MwLzvTenBQ1fRsb+e0whobvwrUOIjAFsoTKrY8exrexJ/NFhSOTgebY/B3zQh1mdNeVktHSy/7DPUgW410HFNJdhFZeSN9QRa3Z5p4N4m9Kw35goEwqG/HGsvBKuEzGbUv5ASQR1LVL65cSTttBsPLYfA2lYXV6ptFhJc4ak1xLCk22SWQE7SCCzVEdaPmcewBo/tHVStkWcYDv5r1qfhAT/NIOE9BL0w4wZvUf8zIXnHfJFMzrstTvwMrDLTjuMv+0qkqnpuFj6/Pretrj9q5LOjpPzfr8SiwkORK5cthDa5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Bsk05EoAqFw8ElCZ7CUp61Hjn65RnRKOMNvIjdw1r+cmq9uQ02kan+0Zd9?=
 =?iso-8859-1?Q?mktXr83fQ3gruhc7sFNtCC3NlBclnKnJZws/ltE4aqT29UjshxQXgKaX0j?=
 =?iso-8859-1?Q?0pDqdtI+yIxTcTjP91rHuIXVZmrQUBioxMRg5DWW+FXFWcDOi24OaoCuhe?=
 =?iso-8859-1?Q?MXAwQv8Z70Ooafake7FGzDqc/IXqeLIuETpqMVbwHwtLSrqBfpqevwf0sD?=
 =?iso-8859-1?Q?b6HFXwLNV7pUDgLcfBjAgQ+aeQHp5s+/2YznPfAsxeKCtt11OC0l9qOhmS?=
 =?iso-8859-1?Q?PvY/YRE0xhUQs6y2xc8mPo7hWF7LhrHC/QOkGRPMAhB9vpnp+cyaDmbr2v?=
 =?iso-8859-1?Q?eitLiqACsc/K+KoFMDGHPEw3+y5XchZj1EVDNJkRljglpwa7h+ldinfvT+?=
 =?iso-8859-1?Q?j1lFMXfedig8dOuo/pzUQZROIFGrXrNhLef0E0ahi3lDV7kC9synba5oeq?=
 =?iso-8859-1?Q?VVdk/enUw9494GI/9Az6V9F5SzVVaiove67aHuBEoVKHuY/yZzVI+np90w?=
 =?iso-8859-1?Q?4bgIQmhNsPsi9wi7jdpQ6mXhsEn+7XqCtWjFCvtAPBvyj5QA7G66k5Ohs7?=
 =?iso-8859-1?Q?w1FWoFOc845SjLJ8kHcY/PFb44cIl8evLPVO/EnXcHbKHDsSXsZ1a0N5Fi?=
 =?iso-8859-1?Q?Z9o0GnMwb4ZTo/FOfq+1o9K5pWW8ehY9CiI1o8IfaPvvjungPJKLfwFtuL?=
 =?iso-8859-1?Q?6RaH7KVizrmMSpCR6LRjg2GHYK2C6r2cecbJ4lOMtJH9NWM4Q8kza/6exc?=
 =?iso-8859-1?Q?jfpdBCra8LuO5aAegwFuSYAlKNV6gKAGY9iM9sIWHGiwesTxC1Wlr7x8K9?=
 =?iso-8859-1?Q?Ul8SI+v4hdX4Lgkujtss0BVcB8ZUYYJ/jgGy0MHA8uRb/10hSQnTaSNDNG?=
 =?iso-8859-1?Q?uSOKLI/YV9wvGPed/8ZGGmxkCkUbCNmNMr4mTOER9eZ7CnppjJ/QkJkSuZ?=
 =?iso-8859-1?Q?66/xHRdCmW+lGP+eOC7Xub9LRermsvjmwYhOtsgiXDJVs7ML8ZYPT/I1QM?=
 =?iso-8859-1?Q?VjEq2buotLXeK6EgPjmE9qh74qPCMTdbl8e392d2pVLU4/VzwbsqLnxXp6?=
 =?iso-8859-1?Q?FhX2SxHpX2BTnhJ5tiXhKPNFq6MiOY1J0U7deM9PnANzfI4ohNjxfE/9JP?=
 =?iso-8859-1?Q?1FxcNMMYn6ZeYb4sWfDd9dYmF7CrIuN9H2PeS0JG/pwaqM2vLgFlTFfF7h?=
 =?iso-8859-1?Q?IymULcs843QusZ9dGVhfTerzYGx7StRvcexrVPt42EwWYtJ/vwT7/x23Ae?=
 =?iso-8859-1?Q?93NGs57oJ6hMlTc5qDgKGjg48yDngxvEva+u/UGzYQ7toRS3tOpMIYlD2B?=
 =?iso-8859-1?Q?CzxzojzY4XP0VfCQhNg5M+2x/8+7UEhIjBnzEm+AhT8u4ikvBbDZrvZjsg?=
 =?iso-8859-1?Q?8DBKYwGZYcz82hxTflYAB3IbtFdR9aeCWvBg1yFge3A3d88Mq5SpJib8Ra?=
 =?iso-8859-1?Q?K6eCkIu+iu/4GG12HYomV9I/BWHhOidqsp9OF5Ja+lGT8k04CfK7Y1KNUE?=
 =?iso-8859-1?Q?jkaT3TzsBIksGM1MFwv4Izjr15e30D35p30iKwno+6tLf3wI6k1Yu9cZCI?=
 =?iso-8859-1?Q?ByaaSPodDuleTRpbl1svGve7rVFnvNmSovrCeGpkk7kFPhyiwQnvZwB3Q0?=
 =?iso-8859-1?Q?4UQe/Zw1NlFf6nOBTQB3qW0Xx6unhw6bTN0Hf3hFwexQDwfM9XS8BDOPl2?=
 =?iso-8859-1?Q?vsHjCAchGMwSjGP0My97SlCkDNpMFmk0pPkhUBXkevRksmaXEQHm4bZH3u?=
 =?iso-8859-1?Q?6fVzDjKg2h2uS9TKmEKCI1tcnGMVDWS7QXGUla5p8Xv2Vjap5J3duWtOi2?=
 =?iso-8859-1?Q?1D9NL/Mzmw=3D=3D?=
X-Exchange-RoutingPolicyChecked: S5BWp0Kn3rPxiTofKtpnAW84h3iq4wcE9dupQ93PUPZBpu2Qu+u4/KTjJTt1q2R8j07cJm6CX/yvS6nzljyQhVaHt3eexkSvWRqFV5J3UnrdDQV3ur6l/KJya2umcJvZa9ynf21ZbVrRZIpInb6Dsq5nDHWeSb+F2FnEEIHzpCSmQPU3vrPEV7IlI9BXXYomXpgR5TacEkyFxQjjLhSB3ay/7GUQEoide4LOrIQZl6zQjIYvIzbwLEfDNm7tnyYPQvvianWdI2CWsPU1liMcNKbtksA68lFaIB4l6bIFym4zmFJ5r9ivaIEqH7jLlzzvZjIuXuaLV2HeD0nLsyebow==
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f83c29-9303-4214-91aa-08de8f2b5400
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 13:42:19.1340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9SJtd6nLeM++FBVsK5YXWuuh2VureQs4vusd1mjOOWK7W86XpslaSJ0m0BgGghfk2ehZQ1mLysGJ06x+3/0lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 22.1% improvement of fio.write_iops on:


commit: 7cdd1682909c26fb8784755a37688215e8bfbc50 ("[PATCH v4 12/13] ext4: move pagecache_isize_extended() out of active handle")
url: https://github.com/intel-lab-lkp/linux/commits/Zhang-Yi/ext4-add-did_zero-output-parameter-to-ext4_block_zero_page_range/20260328-162522
base: https://git.kernel.org/cgit/linux/kernel/git/tytso/ext4.git dev
patch link: https://lore.kernel.org/all/20260327102939.1095257-13-yi.zhang@huaweicloud.com/
patch subject: [PATCH v4 12/13] ext4: move pagecache_isize_extended() out of active handle

testcase: fio-basic
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	runtime: 300s
	disk: 1HDD
	fs: ext4
	nr_task: 1
	test_size: 128G
	rw: write
	bs: 4k
	ioengine: falloc
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260331/202603312104.b8cce0af-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/ext4/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  ac5088c694 ("ext4: remove ctime/mtime update from ext4_alloc_file_blocks()")
  7cdd168290 ("[PATCH v4 12/13] ext4: move pagecache_isize_extended() out of active handle")

ac5088c694659c49 7cdd1682909c26fb8784755a376 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.01            -0.0        0.00        fio.latency_250us%
      0.11 ±  3%      -0.0        0.08 ±  7%  fio.latency_2us%
      0.07 ±  2%      -0.0        0.05 ±  3%  fio.latency_4us%
     34.85 ±  2%     -18.0%      28.58        fio.time.elapsed_time
     34.85 ±  2%     -18.0%      28.58        fio.time.elapsed_time.max
     24.00           -24.1%      18.22        fio.time.system_time
      3744 ±  2%     -17.8%       3078        fio.time.voluntary_context_switches
      3807 ±  2%     +22.1%       4649        fio.write_bw_MBps
    846.67           -20.9%     669.33        fio.write_clat_90%_ns
    854.67           -21.1%     674.67        fio.write_clat_95%_ns
    870.67           -21.0%     688.00        fio.write_clat_99%_ns
    834.60           -21.3%     656.75        fio.write_clat_mean_ns
    974606 ±  2%     +22.1%    1190280        fio.write_iops
 2.331e+09 ±  2%     -17.4%  1.926e+09        cpuidle..time
      1.10            -5.8%       1.03        iostat.cpu.system
    112890 ±  2%     -14.9%      96120        turbostat.IRQ
      1472 ±  4%     +15.6%       1702        vmstat.io.bo
      1.10            -0.1        1.04        mpstat.cpu.all.sys%
      0.54 ±  2%      +0.1        0.64 ±  3%  mpstat.cpu.all.usr%
     49.52 ± 21%     -31.3%      34.03 ± 33%  perf-sched.total_wait_time.max.ms
     49.52 ± 21%     -31.3%      34.03 ± 33%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    123.26            -5.1%     116.96        uptime.boot
      7526            -5.3%       7128        uptime.idle
      0.03 ±  7%     +17.9%       0.03 ±  5%  perf-stat.i.MPKI
      0.29 ±  8%      +0.1        0.38        perf-stat.i.branch-miss-rate%
   4759878 ±  7%     +33.3%    6346860        perf-stat.i.branch-misses
    201390 ±  4%     +19.8%     241185 ±  6%  perf-stat.i.cache-misses
    891976           +14.7%    1023336        perf-stat.i.cache-references
      0.48 ±  2%      +3.1%       0.49        perf-stat.i.cpi
 3.807e+09            +1.5%  3.866e+09        perf-stat.i.cpu-cycles
     70.29            +2.0%      71.71        perf-stat.i.cpu-migrations
    382.22 ±  3%     +19.4%     456.21 ±  4%  perf-stat.i.minor-faults
    382.22 ±  3%     +19.4%     456.20 ±  4%  perf-stat.i.page-faults
      0.03 ±  6%     +21.4%       0.03 ±  6%  perf-stat.overall.MPKI
      0.28 ±  9%      +0.1        0.38        perf-stat.overall.branch-miss-rate%
     18830 ±  5%     -15.0%      16001 ±  5%  perf-stat.overall.cycles-between-cache-misses
      8436           -19.3%       6810        perf-stat.overall.path-length
   4633589 ±  7%     +32.5%    6139073        perf-stat.ps.branch-misses
    197159 ±  5%     +18.9%     234444 ±  6%  perf-stat.ps.cache-misses
    871990           +13.9%     993519        perf-stat.ps.cache-references
     68.47            +1.4%      69.43        perf-stat.ps.cpu-migrations
    379.37 ±  3%     +18.3%     448.62 ±  3%  perf-stat.ps.minor-faults
    379.37 ±  3%     +18.3%     448.62 ±  3%  perf-stat.ps.page-faults
 2.831e+11           -19.3%  2.285e+11        perf-stat.total.instructions
      8.95 ± 91%      -6.7        2.23 ±141%  perf-profile.calltrace.cycles-pp.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.95 ± 91%      -6.7        2.23 ±141%  perf-profile.calltrace.cycles-pp.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
      6.48 ± 86%      -5.4        1.04 ±223%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      6.48 ± 86%      -5.4        1.04 ±223%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.42 ±109%      -4.6        0.79 ±223%  perf-profile.calltrace.cycles-pp.lruvec_stat_mod_folio.folio_remove_rmap_ptes.zap_present_ptes.zap_pte_range.zap_pmd_range
      5.46 ± 47%      -3.6        1.84 ±143%  perf-profile.calltrace.cycles-pp.tlb_finish_mmu.exit_mmap.__mmput.exit_mm.do_exit
      4.28 ± 73%      -3.2        1.04 ±223%  perf-profile.calltrace.cycles-pp.open_last_lookups.path_openat.do_file_open.do_sys_openat2.__x64_sys_openat
      4.28 ± 73%      -2.4        1.84 ±143%  perf-profile.calltrace.cycles-pp.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput.exit_mm
      4.28 ± 73%      -2.4        1.84 ±143%  perf-profile.calltrace.cycles-pp.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap.__mmput
      3.40 ±101%      -2.4        1.04 ±223%  perf-profile.calltrace.cycles-pp.lookup_open.open_last_lookups.path_openat.do_file_open.do_sys_openat2
      2.99 ±101%      -1.2        1.84 ±143%  perf-profile.calltrace.cycles-pp.folios_put_refs.free_pages_and_swap_cache.__tlb_batch_free_encoded_pages.tlb_finish_mmu.exit_mmap
      2.99 ±101%      -0.6        2.43 ±143%  perf-profile.calltrace.cycles-pp.vfs_statx.vfs_fstatat.__do_sys_newfstatat.do_syscall_64.entry_SYSCALL_64_after_hwframe
      8.96 ± 91%      -6.7        2.23 ±141%  perf-profile.children.cycles-pp.do_file_open
      8.96 ± 91%      -6.7        2.23 ±141%  perf-profile.children.cycles-pp.path_openat
      5.46 ± 47%      -3.6        1.84 ±143%  perf-profile.children.cycles-pp.tlb_finish_mmu
      4.28 ± 73%      -3.2        1.04 ±223%  perf-profile.children.cycles-pp.open_last_lookups
      3.40 ±101%      -2.4        1.04 ±223%  perf-profile.children.cycles-pp.lookup_open
      3.40 ±101%      -2.2        1.19 ±223%  perf-profile.children.cycles-pp.link_path_walk
      4.14 ±102%      -2.0        2.18 ±149%  perf-profile.children.cycles-pp.lruvec_stat_mod_folio
      3.88 ±105%      -1.7        2.18 ±149%  perf-profile.children.cycles-pp.kernfs_fop_readdir
      3.92 ±109%      -1.5        2.43 ±143%  perf-profile.children.cycles-pp.__do_sys_newfstatat
      3.92 ±109%      -1.5        2.43 ±143%  perf-profile.children.cycles-pp.vfs_fstatat
      2.99 ±101%      -0.6        2.43 ±143%  perf-profile.children.cycles-pp.vfs_statx
      5.80 ± 74%      +6.5       12.30 ± 22%  perf-profile.children.cycles-pp.exc_page_fault
      3.88 ±105%      -3.9        0.00        perf-profile.self.cycles-pp.kernfs_fop_readdir




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

