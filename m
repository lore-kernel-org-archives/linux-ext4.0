Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021103.outbound.protection.outlook.com [40.107.208.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C136A02F;
	Sun, 12 Jul 2026 16:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783875459; cv=fail; b=ujMs0qx7wxEEP/k8/wK9saWt6F0RkSQFjt2beEpid5FnuHI3HE/XvCL8839VfjPSvvUGMVVgzhm/5gcAup85uS36YZxma7Y+PUsXFtalQN20RkWtztAQWPpIab7cmu+DZEjcE84TjU4EfKm1cCR5o55S+qIuZLnd+NBR2DN0+1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783875459; c=relaxed/simple;
	bh=C77XNFfUnUGQ6o33GSWNXHmqUyBJgRzqrewnUR4Sn9M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i5E5/RmX2UrN2L1lTg+GSNS+QejL1ktCQm/0wUincN0AAW9mpUWI7Lf/px55By6e21piiHufUamVlgTH4WFrNjmvy2ZF/+HyiPr9Xp3VWHUQIrm1VN7RgVik90VFlYRT3KLuCYbN1lOu9xkx1FKifM7PMm0F24okV64gAQ64zSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=1wQVOzl9; arc=fail smtp.client-ip=40.107.208.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="1wQVOzl9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYjrzEo2gdH575JSyB9mdO+Im/bIk+73dAgVpdIApSwAkHJ/FK47yEBOd1fJrxtFqfoSqzxRAJvRbkcpKy9hY8UagxjFpNb4+sfYWfhqt/3gjg3j7YAJWWIyAJB5TDfLEzpox/1q/NmrRMLnHI9atcZKi2Tw+mRE7xmwwFxQlaTiUcAqwaNV1ZuT8Uk3iK9u4RroxWO5xVIFG4w4Z4ZzYD2Kvs4HC5diwslbFd+Ke1gVz69eygi1kbEIS0FfGLVTnUzYhORAPA5X2bVeojnob+25Np07O1jJhPqCVrSLtY/yrT1jgDXSIYDbpNzJIN4c2/+gFPqE9Ts1j0Js7txo4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmvyXashSI8+0X3tFAibzw8cLjTlIaHc9bJgC0f92GI=;
 b=xsv7TQavS2Zz+QRaQUFxvccZmWkOgQXfJzsLtD6bEFKBA2lQyLqry35ZbR/LXsH4XdjVmk6QByl2JEoZp8BixY1G9asESed3zxQrc4W1f3vs4fup7EtpCO55PrcZ3f1hZGWHiG6o4yAGE3U0Up5jP96AP7ml1nQ1wMrizHOO50PbbhROmAQu5252abfqZJPxVUGKfwDb1I8nt4lKbbBUjgOCp5pAbNMoYnKn+3NYaPAdo23IB1LdbEWgOjhNejYK9Ld8nii2vqA4gab6NtadyEN9xlu0z6VWW1pve63MKX46IGJ5r2EznYN9E50WbHRjh7h9rGuH3GgpwYImcWqQCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmvyXashSI8+0X3tFAibzw8cLjTlIaHc9bJgC0f92GI=;
 b=1wQVOzl9rkBLXUIPdF+GMpKUjnISEv1QbydMScUyi761AUVFAurtwttuBah4eOg/Yna3gp1pDom8pWVpBV0UHqHieWx2lmdQZOfygbdyq4I6OSCqBmIvotkNiXA0weHWWOr/nGPW/DZ3PLew3hiKQs4OQgJCdWnCzR9Lj5C2/RX/g/XydQyThA8H9e+MmqAh/GkJ4lqk9OYM9QKwoHVI8ARceaREb19ACAs3nzonyeYt/Ci3V9FcnX+DDOQXnXgEPxmGLGFRDbHn2Kr0O6icb5OuvDI2H/YpBVDEpAnDSptY/v6MZbkonCMPq7MKrrQpGuhh2SG0yHcpEEqtAumAqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB7488.namprd04.prod.outlook.com (2603:10b6:a03:329::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Sun, 12 Jul
 2026 16:57:25 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%3]) with mapi id 15.21.0181.019; Sun, 12 Jul 2026
 16:57:25 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v1 9/9] ext2: enabled context analysis support for ext2 filesystem
Date: Sun, 12 Jul 2026 12:56:10 -0400
Message-Id: <20260712165610.366474-10-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260712165610.366474-1-timday@thelustrecollective.com>
References: <20260712165610.366474-1-timday@thelustrecollective.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To DM6PR04MB4682.namprd04.prod.outlook.com
 (2603:10b6:5:24::20)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 37d372d5-94d9-4604-2a5f-08dee036a63a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MIp1lguHqkJA75zlTKgdfYSFwdPF41GU237AKpFnHRDvE3jyM8I1jJH4J/ZYyItYHjeCGpoGk/KdPnviC4bjhYf8U3ptvM3Xh0vsL78x4ZKi0qDhp3xLHoMUCtYleVS8Az2r8ZR4nr4YeivFEVqbfKrEDgUi0EN0V97nFdm9T+bsSMRJGxYY6uB41rFuoK8GPHb33aTBm6uDgvkofSrFJeG2ciHyTMW/ZNq8YElA+RZeOq0wYaXnQHKF5yhpUg3uwWsfGkM81rINLcutHpOVtyFcS1PJHuJIYaED5Z2HRzrZ8+7yrCUVuN4vMXsp50rr/7HROd0sOFBGUyn3u7raSRdHGZkrA90P2/aDkUdHAEqFqRwYsXhjA+6Rts3prAHKxWu/CUaaZj8DbpS2050Q2YXLf50/1HHznfeSHX2Dotd1w4F36rF7UzlqQGi5jK16PmQ6mTWAQ0oPfVKzIX5hZCQIbWfRJnu+2f4NdoO9CW4/qbPTuFpOvHufUMs8PKXUyd6oddgfHS0ed7/IhN9C0T932eedyEUqkTG+PeC4XhQzZkLC/Jg3k+T6+KBVkrlpihDogEe73HQbCpsiBn84OKJlW/c5SL8b76WI7KCmeellkI76Ikhjy69NAlvK3I0Z8yg/qgP94FHIjVbMgcXzGNKL5gJwLS3jHyZATkRqiEg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1U0494GT93BFv9mvUUnqm2RzVueKCr7m5v06MfMg1WBAJYIK1BbE6/DCOmdV?=
 =?us-ascii?Q?80M734Hr+1cMeqXruRwzkEMpWkcBt9PpvzMBPJaHgJbAOZHWf5XVopQVcSBp?=
 =?us-ascii?Q?+dL3nnMqTYZAnr/coqo2oaEOVoJK9/7VvXrgG+GUOe4wGf/aTzkWfegkbave?=
 =?us-ascii?Q?QTtk52uvkgFK1BwmLF9RcG4Ee0CflX/3dmvdAqtvoXJuoMQVbq9t6TMOeI/j?=
 =?us-ascii?Q?juXc3KZBgHOGLArjjTuIfdmIgq5FOHt2erzRHCARamP7l9nSMfHN7NNLI203?=
 =?us-ascii?Q?hIRmRCG/4eN5Lvav29zKUzblkv607EjviAn/lXcaQokR3YcRQlXwNZCwJGcL?=
 =?us-ascii?Q?1OrO8QBokuYHY4iHKUVZXdKtrMjc4o6Ng5ehJz2mbnJ3DnMCDolBW0gOrU3V?=
 =?us-ascii?Q?V0drfcyheyUfVFv2MKK7WV/dzQrs4YLd55dBgOJnizvUoYcVLA8CyaZ+FDZC?=
 =?us-ascii?Q?uz/ayfwIQoC1DQo064gnX46KauigR0sXf5kMN7630EACET6NAsYkBFRwuKEq?=
 =?us-ascii?Q?AktNY3M+JXpkiZpkk1hq5Q1LGaxDwJGFKigsrs/vtgbU7G4CKsEPZnz154BD?=
 =?us-ascii?Q?W7qXjV6nCFmOlbAfLUTmPwXBpP4m3zt1FNjnwhD0upRdNA0MFWrF0H/96icC?=
 =?us-ascii?Q?1z7Wlkvj2JpmBBjdr+HG4vC/7ErvM7PwXW6HYkIqbW/gvUh22RjHzs7wHjpG?=
 =?us-ascii?Q?X2d9QN3D3jT2EI6oynAx0IIGxKgEYpeg7tvaXLpn061z2xgREpSrnEe3/r6c?=
 =?us-ascii?Q?aZ4t5kXsYUnRpYQQmiLoprDSe92DkfXMa2Rb3BvvuaJh9dVOuzRIB3/2V/du?=
 =?us-ascii?Q?ptQAFDSQxZachYQxJzIKFli12rByhIpaP1zi1C4a5WlGlVQzdISFIx57P+WJ?=
 =?us-ascii?Q?NJs2mLqknBkwa5VswOAoqJ3Bsf14nGmVPfRmkNv51TcmCJDxINL6t7aAVUcc?=
 =?us-ascii?Q?vnF3P40MIMn09n0cwLnOlZLQEIrh8T0T3CPio5x9kcgp6byU2vK4OsCoLrb8?=
 =?us-ascii?Q?jHBzNtfBCPdTF4fKJyWI6hxvD03FohIHKqOc2eaZ7NARlFGxUoCdcD0DbdUJ?=
 =?us-ascii?Q?FgSvBvWF5XHSVPvCI/j+6Ri8DQOy6P/ejvUunkOsQbwGdZaRccgs2bbEXoG7?=
 =?us-ascii?Q?/qYIYTRUJvKvv78p6yiUzI9LAU+F3y6ld6Csk/k6bZ7IPWsow/UNGCZ1dE1n?=
 =?us-ascii?Q?3p5++qT+jk5/tYjH29Tb9uzQH6nXDuyLztycB6ptF+RCO+IvA2AiinMBuebk?=
 =?us-ascii?Q?QadT3b0xiNbwl4Z7r+lDH3trZhPaHT/pFbxamPu73dETPpvFtIY2AS4IB7jT?=
 =?us-ascii?Q?s198rCVM747a5xVf778SCI9r3Q/nl/GJIYORKocw3rClRydFk0Sy9Cw7fXxt?=
 =?us-ascii?Q?oXTkij3IFjB3IW2A0djaCfeJYk+1UhA8CtMIq57dXs3C32diE9QHP8CWUaq7?=
 =?us-ascii?Q?loi0ZI9BN0bzaB41XxBuUToMpa2mIfPPCv3xI0ielBUp4pBZQ6MciIPtuGmQ?=
 =?us-ascii?Q?5bclP9Dv3h9K192IXofxSf1Fh6v4txeGZcthuTExGoCVxgpNIMSBf912V0N4?=
 =?us-ascii?Q?Wf0JZBHjDk0pThwB+UUq7oaRbOIBfxvCCjzPAuyhumBWYbjrS+AHAwQIbVWg?=
 =?us-ascii?Q?gtLr0PynpIOpB5K+0FdWQ9IiKPdIsMfa0AveQFg4p32UXsMh5G96OYFbLtwm?=
 =?us-ascii?Q?GvWOI/DC08SinuX3RFnuHShmdcNRg2FtrTX8Lb14QomRAzLVnZ1bQEjooYOO?=
 =?us-ascii?Q?zu6Zb+fr0CqAuHRTq972qlxtt3A4wqE=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d372d5-94d9-4604-2a5f-08dee036a63a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 16:57:25.6327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvF9DYLp5xd1anjAteePzR+nddi8wP7vT+m1eIODNQ/ruj044iaGKdFksVhlJl77aLfTn6+7ZOH37lbZV2QJtInfPqSONou7OAo6HJKTMSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7488

Update ext2 Makefile to support context analysis [1].

[1] https://docs.kernel.org/dev-tools/context-analysis.html

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext2/Makefile b/fs/ext2/Makefile
index 8860948ef9ca4..33db2e9dc9082 100644
--- a/fs/ext2/Makefile
+++ b/fs/ext2/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the linux ext2-filesystem routines.
 #
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_EXT2_FS) += ext2.o
 
 ext2-y := balloc.o dir.o file.o ialloc.o inode.o \
-- 
2.39.5

