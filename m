Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020104.outbound.protection.outlook.com [52.101.56.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F340F3C943F;
	Tue, 11 Aug 2026 16:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464256; cv=fail; b=E6C5C8jW+hl8R11IdC3kBy2dIVvo63cIDJgKbL3j8Colu+d1CBPUKooxfFMkhe3nBAvKrr20sqRC+3Moah0kdLERS/I94h2eS0fp4X92/DK7B9NvPMvDkfW3MM3ZD3xSHjy7dxESTeidh7Q41/XDvQJNj6K+4p68nbe9A8SDjoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464256; c=relaxed/simple;
	bh=rKESXWLOeUXvbVvH7rSwF6iRBLVZUMFMMP7UWeGUbD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TzHh/heXNmAs2iEjan4VFQrI4qQkR1OkoR+f09Ne5wjgE0PtneQFv6qsFY8ma3dKUpp3JEJLXMZc8WOD6IsbcMiA8I3EILoU1rI3EpdzPWw+H4yhibuXyPwfhskSVbNh+IU1ywn+jV/sIJpr+Vn6wAHYeOlMm0zeWrsmy9NJ9p8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=MiH8Qa1g; arc=fail smtp.client-ip=52.101.56.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="MiH8Qa1g"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m3lLaBtx6Kf9ugoQBD8gXxYlML4GLPrNNEBfL0AWEIr+syTtBnJ0YTygm+Uj9BP2yNmlvCTI6x6+bILTY3gXa8wCaN3a3DHdAasWfCUMCvGsIDiFfsCTsPcMpWEEUBjSfAikf5VDej7bf3d9/rc0WKrdHRgHHttdHDGo6oFylGlQSX96cB8N4VX2VaXi0O2/Xe1q/MC2DLicQeCezvHNDgQylc3FrsBWPv9sGJHePl/caSiNu4ZsAJFQivSNd7OPo2eWXd7XNL43MQWsUe1MbTu6sXBD+R9aBBUvWy4BtxbvkzHwmpkgfsGPDYAYUFr58T7ukr/d9EAOqFGD5a0xJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vMdLlNOemsmSG9AIt5ETOZS2sK+8WUkbLtEmitXVSmY=;
 b=JtbraFrKNutKrCXpLYkXOWCAF0qFCj1fk1JYV/kErdHxsWhfDeiVAtsNAV+dEK0iEVcTrcssVDL0Qsxl8P8O620TpiaPd8I8tHYTZUrvZbf0iD7OyrCNSnuT772Vfauln2FM3xMaMk4VbqLsCclTgvQemsKZWQx1HUMJfFzjfDJJHKy8KnynS6Tl7WM5NNELXhN7d/fcey0R25liux9h8tu3XPltaslDXoPxK1XeHlA1CszpRIa7wk062woT4Gq/JdIVKRhJQG4eP/GcYRa363p67CTfnSv7t0juO1hM83ZVFdF6XqH8xyRfJLbeWUgFzwkwBB6dsqrZdnBFn3UhqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vMdLlNOemsmSG9AIt5ETOZS2sK+8WUkbLtEmitXVSmY=;
 b=MiH8Qa1gHz1i6PAQyPlGNuuLbh7zj7QO6BEStdAcHqbGV4sbxDEve8AfBAHZ8U0wpIgkh45buN0xX/4bsNmYmizT0C44mAhVrbPsXcdFSy0F1Hx7IaKEHkHqAPzwn2wL4ha2+Frb7jn/pPGZJmx/vpCoBccZa6j9j9khOWTRQhT5r8Tr9TAT9FZbpoQ0mQg5WMu8BbbtE3XHRZF0xQfgHLVgXvUayz8MgWzonbpcX0maJaokW8jJ+NiNo50F+Ey6HkGi+TboLMZ/nIrq+QOHrLZuGBzqBrnWChYNQBRMlvCZsSEwn4cssVgenwTpP4jb2yMZtzvvA4W8N6eCqlOmOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 SJ0PR04MB8258.namprd04.prod.outlook.com (2603:10b6:a03:3e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Tue, 11 Aug
 2026 16:04:09 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:09 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 8/8] ext2: enable context analysis support for ext2 filesystem
Date: Tue, 11 Aug 2026 12:03:36 -0400
Message-ID: <20260811160336.782342-9-timday@thelustrecollective.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811160336.782342-1-timday@thelustrecollective.com>
References: <20260811160336.782342-1-timday@thelustrecollective.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|SJ0PR04MB8258:EE_
X-MS-Office365-Filtering-Correlation-Id: b7deefc9-8898-4a62-843c-08def7c22bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	VnY6MvJmP27eAuXefmhBvALoaC0+XNeHxVBzyWiX8GDcKvqyIPeICveT8GqgzVuK7C6HNhprqjlWwF5QqWlQ+hw1SVAnB0cLPisAuJEAWPlxgs/DU95dK45Xjl6HTmdPzfYZNrJBfNu86COjPJal+oi5/x9X9vBSnxr9xOiSfpym02oPZgWK9lJ/V06tLCE4+aDo9pytsf7n09Kq8lrcuA0pm+sOYojg9JmahbPLxIQY1oHC8O7jW/PKjACKpxR7fAbT8WavK/OlyReycaARoGHggxW7E6+ahIScPKRY/tTlx/opaL1XeE9BHWRfwD2EP6iKS08VPuqyPSe+n3d/gexSExFtEIYugQNB6CbLidcC83UHzy/eZA2B4baZdRSIH/RFSPhawGsoL65PM9RoSvtWpgy+eZmqZH7y426/cR4/qa+mgLOoZB9f8+Qs9WbMEfrMNn2rNGyCVUdyBIjerJ6ue8RYS76yNWJxN4YTYr4VE/Hgz9obFZeSQaxgnd4u4K3fatzk+Wfzap2JZSc9CbcC5Nt462iMJ1727bN1Z/67x2MKfJYgXjS8+JapMGBeMX++8hKXtwlSKAj27a+mLVLJrMeELHkzh5mdqdrKgfYSVsAv03IBJ7+CKJ9mwzxbmSwouwttXmQm7asl6Qe01e2wGQiOCAsS//ZrdRzGLOE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MP/NqMEcLXFcn+8LHflVCa5zaRqc0/41GqN6oHzZx6SBqKBNnEbZvehvPjMg?=
 =?us-ascii?Q?H2+XXLemd8lU56/hpFUAp4G/xoyY9tDT9K6erk0egkjbiy0Ot0jp1HEXm6jR?=
 =?us-ascii?Q?VTUI2WlH0hNp4gk3XiJsrzIfecKXCYpVwKJaXjxiJgrHzxaqHlkiWeKKudFw?=
 =?us-ascii?Q?XXWYt0112RWVZNuRvUkKw4XjXS8gQAhAgR5vXMSEePcfgakBjKIYn/Q0hFqm?=
 =?us-ascii?Q?0nja0blD8bjzXs74SH/BhAvYPemcB/LhpkjeI0HUq5G6GJcoCjc+HfN3P8Cf?=
 =?us-ascii?Q?+nsLxoKKnRuvi9zQwe8fsu/LjfQioLS2n+63GflRDERVtIHy9uCCUJrCHjY3?=
 =?us-ascii?Q?RkfvZoWEcJEcfZ5qENrD2I2RfO6+jBzACqgswfBxEQDi9rcWqhOa9tMNNrMJ?=
 =?us-ascii?Q?0gv7ccBh9ivoeH8gbkcfVf+HX5wNRCpit70WVVBmpIGbgFSB408psAoQOXep?=
 =?us-ascii?Q?uK9JIvGL7m2va7n2VTcs55zKY9qxyZSv2R5+g249Sv6KrV5nDAFm+yQlR/HM?=
 =?us-ascii?Q?weI22joiv1KlPIAOrsWi6UDtTsdzWySK4X2SLzf7HDWq9tkSWqwLsGFCNg4m?=
 =?us-ascii?Q?iedzeolaiEUN1jhzLu6I7vspGgCaImX2Wh63jupQkQzcS4m1Yby5kd2WR7Ta?=
 =?us-ascii?Q?/74cnXB8e0YMSRoZOnSPcF5afJZvoXFQhDXz/Bj4CGMvFTo0Jola42wcWDLI?=
 =?us-ascii?Q?+1cBC8LCMIIyn3y8wpXiXlEtVz38rrUvlxPDScpeNwYfM6fRoDp7fErKUMVy?=
 =?us-ascii?Q?bTx5L/+NXxqLPmagtltWE7dqs/l6LRQkWoGmY4TXvp81ugtLCto82rBXrTAv?=
 =?us-ascii?Q?hAHhHLji4BjnF3VbHNzCthA7MrTgbgvSXt32JDKezyYCMR4WlRO5seeaY6V6?=
 =?us-ascii?Q?YmpnJO6Tm6e9X7rscEWIh4aGvx8N+dJmscIoFgFVPgVl3AGKucaX0uOWn/Fn?=
 =?us-ascii?Q?abOaltUDT4YEg179ryzzaM9Fz2pJc13pv5NTpfkoraX6ocoKiSB1Kr++2l73?=
 =?us-ascii?Q?yQ7u/5LA9Kh7HNKnqLxM4kS1BekGuX0i1LUXJ7vlIQRx/8DvqKR+YHSR/BYX?=
 =?us-ascii?Q?wPmB2g4nHJyM7BETmtRH3y35AXwC/YjHScG02FgNpf+eJZ5yIuSz4ywfB9cM?=
 =?us-ascii?Q?6850dLAycAFjS7ZqCmu//iGuqrPS7g3foDdaRX2OpJm0+DloZhrhwkxj01bR?=
 =?us-ascii?Q?ibPkxzIrjPWgj+B78W/dRBk+LTQo6hAJIDhbPlAGxNVGotkCoSPUDcwHhMQE?=
 =?us-ascii?Q?pDV6wuLMekD1kb0jbyywYNhqnrrs4uGvzSwlRePh1LYQr7R58CyP5Bqjhkzk?=
 =?us-ascii?Q?n/1DrJYPHBP80v2M/8c9G6tcBQ+9nbOr2xVlj/66RVzL2eu+03krZfBCPfA5?=
 =?us-ascii?Q?4P/IYdLhfuQzeYE78pjnsKVxcOp0qXWvMA9Y7LgOlhoVSfmXfN7C9j1oEkjs?=
 =?us-ascii?Q?4julZlK/nPPdaIEVFrcZ+NZJiq5HzJi2dxEGcjRxOH9Ot3vP/sF/FgH4+Qmt?=
 =?us-ascii?Q?k6pi0DIk6WXOS8EDKQp21CMviziLB9vbXje3OE5Xm9auRxpV4+AGb68n+/Lr?=
 =?us-ascii?Q?PYtQozlivZlcs/Aps6BPKwtBkyEfgHm+YTSjaMjTaaiA+5pVyvPYIqtSrjam?=
 =?us-ascii?Q?rkp5HV+nzHOWdnAReMBQc/66PJivhZhBcydy3NVH3mlY4/OA5QNPtdhLQYtR?=
 =?us-ascii?Q?m0ALnWVYHgof16gKGmlqPcSBv6x4QQwXSaNMxSmeUhfhmW574Ql8FR8DhebM?=
 =?us-ascii?Q?3NCn0wO54flAjNZyhG7EK/EG2aKJP2o=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7deefc9-8898-4a62-843c-08def7c22bde
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:06.6824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcdDF3a8GAg6bZSdd67ezJ79EjYsh9q3zoSvhzDNwf1ANLRSWazdc5P4Jh4SkZPocccStKpk5K71eWfSIFgVxvCTLQHGN6EMH9m4mdG22H4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8258

Update ext2 Makefile to support context analysis [1].

[1] https://docs.kernel.org/dev-tools/context-analysis.html

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext2/Makefile b/fs/ext2/Makefile
index 8860948ef9ca..33db2e9dc908 100644
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
2.43.0

