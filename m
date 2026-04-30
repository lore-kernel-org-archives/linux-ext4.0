Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033D723BD17;
	Thu, 30 Apr 2026 05:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777527532; cv=fail; b=YT4qZ6S/6+OgI3dQKEkr0BEUuEpYqG8gXyZvVGTw0m/e/nUs8dHabkcFkkGIflSKibKcgE4splu8uSLxqxnxE1PbsfM6k36wXJMdns1brVb/pHsTicw2FJwEtaOeWT69Y+B0I+OCZk+wTxyV+lNZ9ZD9iPZO1eLdwx/sy5JQR5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777527532; c=relaxed/simple;
	bh=XcaF82MbZzsWMSeLLANDRFWmLft6dhplf2H2S2wIzNk=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=b2jkodg/77q9AUtJbICirof5ALc2+5uLr0h7zDkBTmC6dwv5paanPIQp3JDQct21PCCIl/20aZQPIscaED6DZ/CeoW5Y/aqzy/UPzKrXcN7DiPNO1DMFeCNnjLsd9DQiky+GFtYY1eLARSntPUjufxdj6E5/Qq8M1RPiyJAV7MM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P0UnbVGf; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P0UnbVGf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777527529; x=1809063529;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=XcaF82MbZzsWMSeLLANDRFWmLft6dhplf2H2S2wIzNk=;
  b=P0UnbVGfH/8OYDVe4UpfUkYsr5ww9/m4ekmzwbj8tg9hDf7ezSnU7Zlp
   5IiRxi41Poj9Vd6aCyaomuhd9NRJrUo4FWIWt/BuUM1WFU72YQ51vWXMd
   SskkDT7S6baJGCdRSf9loQKmvn1fZsI7wnYGOu2JKLSoPzrE2waEzLbWj
   8cko3qoIVl+aY3BCcxuARB/PagqaMDI6mwH3FjKy9kL2KS1ddWaPWfM7D
   3frw420RcXI1/+xrVfEUp7OVh6y1St/UcZo7CK5fFwxGppACftDlhwLc+
   41+XolHiCSZysu9OMbv4xRpERHMtagXtCGIQzT07DoKK414dcsAAi0Nkn
   w==;
X-CSE-ConnectionGUID: bUEf7j6LQluZumexZtb0qQ==
X-CSE-MsgGUID: Uh+n1NAdRm+sL1Q1vaVZWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="81042788"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="81042788"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 22:38:48 -0700
X-CSE-ConnectionGUID: hmMFlE0lRKemvGpxny8g+g==
X-CSE-MsgGUID: MOpM96MhT6mFMvodLazjGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="234367071"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 22:38:48 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 22:38:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 29 Apr 2026 22:38:47 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 22:38:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NbRFAGL2U0pQOl6ji7+icEO61HiMQBGPjj2C+rGrb/DztroP99j9FdDycaLAfaq1mcpmkfhnBagPY+lNniu//PjVn7eUqo+uftyRvGVgmTm9ttpGahqphatcx+bPoDIOsg3B5V3RduaHYrX0WG04TSn/s+m3eJnPi85rME4RXCGx4KCKeCxd3KiN0tmuajN0B0nsrL3bPxke4iMztH6xTUylV8M/6JLpqB1VxfeA6cfunn6BQykt2dORBx7/aKWYkau/nxSL/4ibk+u93dh9bMD1Mu4/EnvPbZYhEzRpblaxBOgHjJx2wKLK7MU+RDx2yTeO984Wn/dmcTbLWOYZOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kONYo65t9q22LArswjrrxLvcbgeiN3Ax+H8XGEvbPgw=;
 b=N2xnG7VWFAFhfkJkMxnL8CrVAjp0KzHLfllCORkWkeaPUThkd2nHUFJFeedGZlejsCS6u4LQt/e77P7iZygMRJ1JanbF4bftyRzZOmJEGuUdSQJnL9R1XRMtz8gr6jRHyiFtcxk8eoeErNK3/M7AyYZz7Uz8pAyj12PBiJa2ltiHR5TeMD952criNxA+Z3aVwSgXFMGPaWtNdmWV8Movg8kKcsudPHvyQnzIZLp0VwS/6N73VUtZqZFvCmc4jyfxHtRkZ7LTDNeJEVd59PuEAKdu0ve/vKFa8Ajo+q6Mz5N98ceDvJwst0lIXBgRoiv8ku5J70WB4tnWV0Wjvd8KOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DM6PR11MB4609.namprd11.prod.outlook.com (2603:10b6:5:28f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.21; Thu, 30 Apr
 2026 05:38:44 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 05:38:42 +0000
Date: Thu, 30 Apr 2026 13:38:34 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Zhang Yi <yi.zhang@huawei.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	<linux-ext4@vger.kernel.org>, <oliver.sang@intel.com>
Subject: [linus:master] [ext4]  1ad0f42823:  fio.write_iops 23.8% improvement
Message-ID: <202604301021.faab1f8a-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SG2P153CA0013.APCP153.PROD.OUTLOOK.COM (2603:1096::23) To
 PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DM6PR11MB4609:EE_
X-MS-Office365-Filtering-Correlation-Id: fb776e85-2829-4094-bb4e-08dea67abd23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 0lsu6VwqEtr8IwhqmT+pi8UBTrUMBd7vqGBEJMQCN4X/b1ef4BT3GoC0XdsIRU9x8O3pRYxSJ7KfvkTG02Rz6Zj29UUT4CBqBVlrNadcvvIftTh/jSBQqxzV1cGf5QggHQ2Odml1/2EBJr9q+ZhfZE/jvlPG2TyhCO22zppqu2O0+mI6NUWI+KfRS2B1TnWyAIBzzkhw13zVRlHImB56KtAvjz9YN5/hu7jADpsFryHVc7xNPk/MFf/19xN8QER6idGvDv6C6ERNfeUwVzXFZ/o8+d4SHi8C7HCk3Dy9GRwgALlAg+42nFhbkmtxi0JwOK5qerYmHowcgkTUdifBDPX9t6bMnAAuB5ecY2pFi2KUYIJQl3u5/Ssnx5fftKgkLj0Spxutp/QCFMPoxL92C1uRINiqbFER/B/yITW3kdK7q7KXOqFmg7oKe+RtaPegEQIFO6nrZ6f3wYZIWp3Cx0CHsJERBRbQ+QFDDc5WlthZVPOtLao4qGGSpACbslwoKuweYA4c+sXuEg1uLErjuISUHiUvomom9ci+IcdsLr538dolSiVwTX5TDFSlvr4m2/NrKnSsJC+mfqEVhKiAtKinOkkGmiOESsgwHBznyi/LbA9lskqibMGJ62qDrQvkloFpel4DqRZ6dzXqHaY1GjjVvjucqn6BQHb0VreIGSIn3uqeIuX4LdNz1P4cOGq8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Zsfc+D09Ppwh/3ol7MUBKqN2cKrmNyC6l45I5RNFsaUwA3b4K4vu/YaaJz?=
 =?iso-8859-1?Q?iIlR9Cjq06a1+dtgdcl6CGem/+7W9Jslz6YALbFCuQIKBhTV47ts7M+z8W?=
 =?iso-8859-1?Q?ybpa4LR68L/yyKk66im9CxMh+P0r3bu/CnN+8u3i3MZTV2E/yBX5AFTnmg?=
 =?iso-8859-1?Q?0xaVvQUkBfcJPU1SRcclomOxEdrEyZajVgcEsoxfdBUwCFESiPFIfCTW2b?=
 =?iso-8859-1?Q?yBLT26zuoNwStjFePTQDg55hOBb6eq9WX+GfSpHvTdBgXkbUB7UsNbWl61?=
 =?iso-8859-1?Q?FnqQ3uGEJ7yW8yFfSjH3sgJTr8H7rLgromR8MR0+J/7N0ylB+kpSlVlLaM?=
 =?iso-8859-1?Q?0qmQyPNC6qgb8tCeIcn7lWhlQTUgHKaJDCUyx5RDUDFD3b5Xlf2mhR/Y8V?=
 =?iso-8859-1?Q?vJvvenZR3/VMYCRtq8HGemASrSX200TXQgUfc7tM2KSj+99hmJ2Jg0KpcZ?=
 =?iso-8859-1?Q?qsSfwiKUQWwd0TUssF5mWrq18aqBk3h2knnCYjZvA2YBgo7CkCqieLp7Fz?=
 =?iso-8859-1?Q?rAd862DxOjDfuXYYI3UpIX0lVjLPPfQ5pDgrFjWpOWhd4yTA7pVO3bwXn5?=
 =?iso-8859-1?Q?wGC8eOKzTjkhRXMQXpEvFwr3ASn8rhwiYHSPKBugmBBODTMhNh9dDFq333?=
 =?iso-8859-1?Q?nB2HNxS1UkHRz9lb+U33fmIGcfCjHviTtKqjrEDfDVQ2QOSSs5lZMRquwQ?=
 =?iso-8859-1?Q?6E7wciEW9I93qtn9NKQd0IcWundGQyHVT3BPPhEpLBBmJ1T7SVEZ6/TAoK?=
 =?iso-8859-1?Q?Kx+RUJWrvma0L+Xokaado2hUSLJToz3bh9R5Zt160v7HbG2FGXV0BY2ReR?=
 =?iso-8859-1?Q?hrJR3Hiw2jxyUVWtvBdNVxwzfAr5As9Hg9aL9xi5aq8SRkkTCscT2TCg/B?=
 =?iso-8859-1?Q?o1b9CggRF1wprMNO8ziLSkz7mGIhkvcA/YfnBepWQ5N0IDbFwra/KoeiKF?=
 =?iso-8859-1?Q?QxGq//5gXNo7d6P9cP9vHNCPYmx6N160aq3eq4KgfyOxXBCZdZ/B2nyW/D?=
 =?iso-8859-1?Q?ECyo5Sl8c9Zyr9S4biWOlN3tZaEnLoMETMV+cJc7RsmFYe6ZCizJWQI742?=
 =?iso-8859-1?Q?wuYAuOu+1oq2ILrPbKsTgAAPDxxOuj6khmX5Q1JSQGOc9UOnH3G0EsSuJ2?=
 =?iso-8859-1?Q?A+RjcFAlc+3ZXRaDmGJuOmvxvNUftEeAt0buOvGFpY9Mhp2ulvpWIRTr0B?=
 =?iso-8859-1?Q?tzuAqUzIS3403YOSprL9dQl7uXLfMnoy//aUhygC03fwfwvm3Y8Nu+mYst?=
 =?iso-8859-1?Q?9z+EHDkKi5XtefLGuKjvH1suk5jgHxsG5TOx/VZSt/zr+dsylxiS/Fc6g8?=
 =?iso-8859-1?Q?RvVfRTR0GcFrQLya5+tnCu0/xMGl7nn7vtheOmbbEhvIDzpMQMkJTeh++G?=
 =?iso-8859-1?Q?4EHlL2BQE/vChEyLU1tszfSR4QBeiA49INurUfNIRe2oqHusGWPh2J6OBE?=
 =?iso-8859-1?Q?YoSX7yP6cz6hs3Vp1Dddn2qC2ZQRcubPmDpcNfD/T6GsSdxac8h4NiVY8X?=
 =?iso-8859-1?Q?VWQ8faNq9bdbhN0mQq5opOhg1jy3t4FBj7t9LgE7CxANBFGDoHEEudbukH?=
 =?iso-8859-1?Q?5sbPizzvW5o6EDlUji6+ns3bZtrJKqyM08RBwVUTBozS7lD+5m4LaUNgU1?=
 =?iso-8859-1?Q?ST4K04i8URT1H8uRS5/TWCCS0wQ0ogO0M3PyxG6GGZ9kqymvyq/GgrQAGt?=
 =?iso-8859-1?Q?PfxWIvgvvpY6bkEDrrVcFfahklz66smYjW+QPIdmKdY5WfjWqw35Rw8Hem?=
 =?iso-8859-1?Q?ZRlrKOS4GLHw9L9Izu4FDMVW7XvZcMX5XYDKLckPkhvtkgFSeceh0JnvCq?=
 =?iso-8859-1?Q?8gATYdLiQA=3D=3D?=
X-Exchange-RoutingPolicyChecked: jgRPmnvfvHGpSJ1yfCDMPtR8jn5MaKOF+3rYQJfjvGXXXweu9JxBPFM9yBD5UuYb9CRiA1xBoIgpdAm6Ejlwmlufxo4hBZq4It2tFdx945NebuEJdZC1VnAPgKsEVIdDvI0Efsg4wowX0nX+hmBAUwONlm5HoRXSuBJi+4jdh4m6wizMywEvaGq3MTPktmBt+iC/S+L7RMYXqJM+MrTZYJ0ZOBltHh70tvry9NqRgYvg4XyoEuliKHtoDjpFhUmYxQu2zbBBCcZnzXB4zS3ug5AS60a69+MQKCf4wTb4h3c4m4NOtkE4+9qRpU0+gtbF+XUJIuolAkBBy9jRKScvyQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fb776e85-2829-4094-bb4e-08dea67abd23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 05:38:42.3939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aFSeZcHHeK+5c7qt8dhIWmXT2SjyvCrPMrf2Bo9fGtiMvX7AIY/8Sz3AGEl2Naht4+SfO1IhIRUh/iYEfiHnNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4609
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 23.8% improvement of fio.write_iops on:


commit: 1ad0f42823291bcac371dafd37533f5e8d92acc3 ("ext4: move pagecache_isize_extended() out of active handle")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


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
https://download.01.org/0day-ci/archive/20260430/202604301021.faab1f8a-lkp@intel.com

=========================================================================================
bs/compiler/cpufreq_governor/disk/fs/ioengine/kconfig/nr_task/rootfs/runtime/rw/tbox_group/test_size/testcase:
  4k/gcc-14/performance/1HDD/ext4/falloc/x86_64-rhel-9.4/1/debian-13-x86_64-20250902.cgz/300s/write/lkp-icl-2sp9/128G/fio-basic

commit: 
  116c0bdac2 ("ext4: remove ctime/mtime update from ext4_alloc_file_blocks()")
  1ad0f42823 ("ext4: move pagecache_isize_extended() out of active handle")

116c0bdac2ec059d 1ad0f42823291bcac371dafd375 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.11 ±  5%      -0.0        0.08 ±  7%  fio.latency_2us%
      0.07 ±  3%      -0.0        0.05 ±  6%  fio.latency_4us%
     34.79           -19.1%      28.14        fio.time.elapsed_time
     34.79           -19.1%      28.14        fio.time.elapsed_time.max
     24.17           -26.0%      17.90        fio.time.system_time
      3736           -18.7%       3037        fio.time.voluntary_context_switches
      3812           +23.8%       4720        fio.write_bw_MBps
    850.67           -22.7%     657.33        fio.write_clat_90%_ns
    857.33           -22.4%     665.33        fio.write_clat_95%_ns
    872.00           -22.5%     676.00        fio.write_clat_99%_ns
    835.45           -22.7%     645.60        fio.write_clat_mean_ns
    192.67 ± 28%    +122.3%     428.28 ± 20%  fio.write_clat_stddev
    975889           +23.8%    1208502        fio.write_iops
      1.13            -7.7%       1.05        iostat.cpu.system
    146867           -17.0%     121930        turbostat.IRQ
 2.317e+09           -17.6%  1.908e+09        cpuidle..time
    121665 ±  9%     -11.5%     107660 ±  5%  cpuidle..usage
      1.13            -0.1        1.04        mpstat.cpu.all.sys%
      0.54 ±  2%      +0.1        0.62 ±  2%  mpstat.cpu.all.usr%
    124.09 ±  2%      -6.1%     116.50        uptime.boot
      7577 ±  2%      -6.3%       7099        uptime.idle
      1507 ±  4%     +13.8%       1714        vmstat.io.bo
      1.58 ±  3%      +9.7%       1.73 ±  2%  vmstat.procs.r
    256506            -3.5%     247467        proc-vmstat.numa_hit
    281823            -4.4%     269466        proc-vmstat.pgalloc_normal
    166349            -7.9%     153190        proc-vmstat.pgfault
    159495            -7.7%     147154        proc-vmstat.pgfree
      7811 ± 20%     -45.1%       4288        proc-vmstat.pgpgout
      7649            -8.2%       7019 ±  2%  proc-vmstat.pgreuse
      4.74 ± 63%      -4.7        0.00        perf-profile.calltrace.cycles-pp.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64.entry_SYSCALL_64_after_hwframe
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state.cpuidle_enter
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
      4.95 ± 81%      -3.4        1.54 ±149%  perf-profile.children.cycles-pp.__split_vma
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.acpi_idle_do_entry
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.acpi_idle_enter
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.acpi_safe_halt
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.cpuidle_enter
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.cpuidle_enter_state
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.cpuidle_idle_call
      3.64 ±104%      -3.1        0.56 ±223%  perf-profile.children.cycles-pp.pv_native_safe_halt
      1.82 ±148%      +5.8        7.59 ± 39%  perf-profile.children.cycles-pp.__mmap_region
      1.82 ±148%      +6.5        8.34 ± 44%  perf-profile.children.cycles-pp.do_mmap
      1.82 ±148%      +6.5        8.34 ± 44%  perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.03 ±  7%     +21.8%       0.04 ±  4%  perf-stat.i.MPKI
      0.26            +0.1        0.32        perf-stat.i.branch-miss-rate%
   4548711           +21.7%    5537175        perf-stat.i.branch-misses
    274432 ±  6%     +20.4%     330549 ±  4%  perf-stat.i.cache-misses
   1860596            +8.1%    2011597        perf-stat.i.cache-references
      0.47            +2.1%       0.48        perf-stat.i.cpi
      2398            +3.0%       2470        perf-stat.i.minor-faults
      2398            +3.0%       2470        perf-stat.i.page-faults
      0.03 ±  6%     +22.3%       0.04 ±  4%  perf-stat.overall.MPKI
      0.26            +0.1        0.32        perf-stat.overall.branch-miss-rate%
     14.77 ±  6%      +1.7       16.46 ±  4%  perf-stat.overall.cache-miss-rate%
      0.47            +1.8%       0.48        perf-stat.overall.cpi
     14177 ±  6%     -16.9%      11783 ±  5%  perf-stat.overall.cycles-between-cache-misses
      2.12            -1.8%       2.08        perf-stat.overall.ipc
      8603           -19.7%       6911        perf-stat.overall.path-length
  1.69e+09            -1.7%  1.662e+09        perf-stat.ps.branch-instructions
   4424559           +21.0%    5353882        perf-stat.ps.branch-misses
    267376 ±  6%     +19.9%     320480 ±  4%  perf-stat.ps.cache-misses
   1810896            +7.5%    1947007        perf-stat.ps.cache-references
 7.998e+09            -2.0%  7.838e+09        perf-stat.ps.instructions
      2334            +2.5%       2393        perf-stat.ps.minor-faults
      2334            +2.5%       2393        perf-stat.ps.page-faults
 2.887e+11           -19.7%  2.319e+11        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

