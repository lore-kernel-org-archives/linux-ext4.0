Received: from outbound-ip191a.ess.barracuda.com (outbound-ip191a.ess.barracuda.com [209.222.82.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2203C3B2FDF
	for <linux-ext4@vger.kernel.org>; Fri, 19 Jun 2026 15:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781883672; cv=fail; b=PpJUKZwQO83nHc7zj8aeOcAwivGbSsUfdQc70JPypEjJ+hBCEQH6TtBg4LyLwvWaj8QPGrdmeKKZBwu4DUxmatPhTpjuFEENa52olAVkfwzz7d/qavMdnWRAjwzfsMd+kNK35uE9TPxUlW0wbvHHy8Els+oNFUZZnRa96enVX9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781883672; c=relaxed/simple;
	bh=WPRjYC07mL1w53wW34Cv4QxoDONydCO2uKT1yX90cJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IqY4eoLfmSGMohPDhzLXhqbxuGPPfWphNhdkIE626Z4MAfYujLv+nOGYlFEhW6utFbhc1JDywppb2Zz/HZw4cYZxW+ymqOqAVAGiPJA87u0/vOrP0/wgR5t9llcWcyCcxYlySRTxTGR6IApLDfOx0ipOXG7LiXE+lvPubUJNZ78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=S11o/WjJ; arc=fail smtp.client-ip=209.222.82.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="S11o/WjJ"
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020133.outbound.protection.outlook.com [52.101.61.133]) by mx-outbound11-245.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 19 Jun 2026 15:41:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQMi8mI3vFlrAUlqWfLGMrRUZ/qmTlRUC8iz0Gc+xuhLDHc3Lac2Cd1Mm47rf37VvsKOiFqbOvKRBG9KH1GqGpmv5sNxfGjinS8t8xRUjBwD0cjLNrDEX52j0OvfFJ+WhwdPGbbNgqL8revkXfiRPAXJkCM0frCnqxqKwRwMeoyLGxohsMgM0ge+ZVsVQQyOyET0dSsmRW3omKQmewvwO2+nIudlaA1bNZpPhZ0FfUqkzwyfZNmuBEs31ApAyZ1QmND2ZflZcDYRCw6LyPuS0uvaDsU68ONcrNjBJLeLFMUeK0RtyzMm9xEv1xRQNM7hXfm6NMNKf6DMbL6A/sLqlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kS+kQOiBdB6M0wK9I2dnwxhE9JGLbkbrr+8UYq3oko0=;
 b=syRi5JRHPd1TrhOmEGHNxyJ+HWzDyuMRE9UUVIY/Y1ShiJMDQNq2rAhmI3IbU1X+pLNT4gkgIhzb3XecEOwQoBNxFgo31wEp2OduDxyrrOAD5bW9k9rbjigU34qH997RGM7pzmAfvVjZMemOIn9z/IqZSgTUo4aZPqXExMpNN9on+hGSRQHPIh17dcr/gvHGa+3+dlQIJBJIVmtyegJKsp9vbrc8IBfBNtEnr4aQUEmOMpAWQ1f+npGeKzX2phblkJX4mEGqHBL2t4UwtfAJDvgsuQmmjWq1f85qG5o1Gkud8z81OyUaXhA9vyRvcuunUaqErwjlAn0yWfuJRn86iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kS+kQOiBdB6M0wK9I2dnwxhE9JGLbkbrr+8UYq3oko0=;
 b=S11o/WjJjY5wDcbFcxW8Kr6XwzBEAP5xYIQQZKkQuB3IRsWPi0XzkUIp5CKWVTwsZGAwqsXS0cB2xuUz9ZfOf8h1V746bCwscDo4mpW4nCprj3g5p3xegHGyZUTMgyXlX+WSiVuHBYY9lW36tAWAkkly9ENyNKoUpqwSjyAkro8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from SA1PR19MB5570.namprd19.prod.outlook.com (2603:10b6:806:236::11)
 by MW4PR19MB6984.namprd19.prod.outlook.com (2603:10b6:303:22d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Fri, 19 Jun
 2026 15:24:57 +0000
Received: from SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0]) by SA1PR19MB5570.namprd19.prod.outlook.com
 ([fe80::6167:d6e1:2c7b:a9d0%5]) with mapi id 15.21.0113.015; Fri, 19 Jun 2026
 15:24:57 +0000
Date: Fri, 19 Jun 2026 17:24:52 +0200
From: Etienne AUJAMES <eaujames@ddn.com>
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@thelustrecollective.com>,
	Li Dongyang <dongyangli@ddn.com>
Subject: [PATCH RESEND 1/4] e2fsck: fix orphaned extent files handling
Message-ID: <ajVfRKhUpao1_IUX@eaujamesFR0130>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVdnQUu9tSrKldW@eaujamesFR0130>
X-ClientProxiedBy: PA7P264CA0316.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:395::18) To SA1PR19MB5570.namprd19.prod.outlook.com
 (2603:10b6:806:236::11)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR19MB5570:EE_|MW4PR19MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b596dd-f9a5-4ea0-0243-08dece16eb79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|23010399003|1800799024|376014|366016|19092799006|11063799006|4133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 OMSctwGu9rEeiRH4IXz/1+4giGgxjXvySNJNUu65Jm0b7m383nHyVrOBfPC5VN6qo9zaujpE+WS001Y1/ICROAd2MKoQeO8SV4K3RqJaB+//4K4GotGFjrxmT69XrToGOCPX50EqGwdMKzYIfTYx+lCgf2StficO4qYooAx/6yOT/xhaO88JeCBwBb1K1nt7o+fOrO1dRldufzZWGa5JpIy7PewTT7xE3f2PBZpTCb+FsFQeiW95RxVLPQoyAKo/4u0vaYF1Y6XAWbc2IzZBI0McjqfaxWl/Dx+bFzneMm2IpZP3HinlU2HaOdP/WGBQPiv7AlmhW1KaIbMSabLpAEOg2yMNUrBi48lSqY6zcf0bY5/P9zngVpvWuXkBskX5u2knygcNXyGnba+h9RXn1XoDY1LlCV/E6c91B0l9SL9Hn1QDOGS2DDhI4OlSazKAAVfgLIG18vX15pW29nt2OLIZ/9GMe1IBFsUlqPtgtcRvHSZ0w3IRR9NtrTAJYf03yL8DOfKtagnqijfPNuQOpb66Ztc5F1qXYtJklZ5bnnlpf2afkFkvfs1AkfhCuUEYprm4UqgpSbaVLb2GlwJAcr3+P2C+y6cjYUtLFDZWfZ6k4QvXzxiH29wWm++Twny6chCvvcU/CurbRuX+/TTaMSV3uwftHkTkzDt9OXST5dM=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR19MB5570.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(23010399003)(1800799024)(376014)(366016)(19092799006)(11063799006)(4133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?BzLKqyB/8BxQELuEc/gweUrld+MF8bi+Nm5ClXQX0N/0Z9jh9lNh1XOEyqRz?=
 =?us-ascii?Q?uHSYaEM6f9FV4i/Q5lOBhVsarfrAZtAVNMt9xFKw77HYeHvXGK6uoXn6Gd4K?=
 =?us-ascii?Q?yFABkD4BTKTRG5PutdwAbewO4NtH7J/6ilyAZ3b7s4shllNfTo8c505Y+i9D?=
 =?us-ascii?Q?CqhOPKL4+f12/1Lu1m5A61JKsK29mO8juINEIyilh2WjyZ6VTrmXUQg7a54d?=
 =?us-ascii?Q?Qn6RbKHc0dhYzgCeNqvDi8xhodgH0obUXKp4OY6rVUeJlXssIHSmjfu8YcrE?=
 =?us-ascii?Q?N6pEJrDap47BfrU2dwfd5eqoQpIFoGpvI73Un11AXW4TNcxy0SkhR+BxUrtX?=
 =?us-ascii?Q?X85cjHMdj+9hEga1xHinu1EMrMGtB4mL5jM2PTqGVrAZaf9kfDopMHQ9nMeW?=
 =?us-ascii?Q?RRHm5H6mXDJtQFIkDScmS7bLH16lky6emeGLk0e8Mtv7FmuYrDY30m2wm+2a?=
 =?us-ascii?Q?9XaCuZdX4Dny/2iyd7WP/bdly7Vr2XPK5+3w9b2rhycREp4KKjpQKBx9CSqW?=
 =?us-ascii?Q?WVYqZyWhRbKJz07fb49BlzAMBnmC7hR20BupaiIceKUWmDhx6+8gkCr8zkJ9?=
 =?us-ascii?Q?1Y1NtfjL4sb+TlmALi6JzdrRUXe3D3P1PPosmRh8M6m4zqG6FAEMh9iNwzbz?=
 =?us-ascii?Q?D8qPQbep/zhvj2M+uqWbVJwc2y/uCyC22htG4Qg/XIn7QAUi/XSP2RdGgBRI?=
 =?us-ascii?Q?U2m1TwKLAOMGyCTddlHZ0o2YrApJYFyyWUXIU9yTvhVmV0CSjyu9aNmK3HlZ?=
 =?us-ascii?Q?ipMU2LJhJZtJUCxjf1aOPrQZsLWTt98HeXiVHL4vgkVcc79N95aZ3NP2V/6w?=
 =?us-ascii?Q?1dQnxkIHto3gLnjzbkQloeUE0OAHdFvmsdUjI3ucIS2tFN/WMcXT9tIJDvdo?=
 =?us-ascii?Q?S9fgb34+KlDrjjpz9QCC1G6P7AKcfQk+P5yZzqEtLqKUYDFNzOibjNm86+9b?=
 =?us-ascii?Q?ZdUMLpow0d5eMrtQSMC6ISpMcw0yFIkSCdLqjM8/z76fXpB62Yv2H9i9YpI0?=
 =?us-ascii?Q?1YW3naiPSxUN0vjqBDRN3S2Qu7lJfZS3xLzwE5PiC2r/bn7WPg/zAtNh9d7P?=
 =?us-ascii?Q?hZYa5FCw9NECQuLkqbDjojPSPAuyNpZXPj03P48uwQ1CfYXuDjtmFMY0wRYQ?=
 =?us-ascii?Q?dEiqyE30Ma/YvruYQX/7usXFYrE0Poy2ke9y9IvD8ME67nVrufz3eacIlo4b?=
 =?us-ascii?Q?neYdYOrzUYWet1sGfIbAl/Ho6KBF98tzQFi6xwM6Lv41Egv2jyNsPfSY/FbJ?=
 =?us-ascii?Q?+8DOfD42UOIYN7P7XKExLuJzRUl6HstycpsU7ZukA9pMtgyLPJuRXIsWWU1W?=
 =?us-ascii?Q?l6wzGyVPNwSgpk4XrKeJ3wc/tB09jWidoUesWk+p5l+2vvG49/gG4LXpviFB?=
 =?us-ascii?Q?KkSLwRJDcosWlJaalIAmhjjweYDpDslHvUpHe0lTYSGBxkK7VBvr5Z3uPMGW?=
 =?us-ascii?Q?CXAtLdxUN3oJKc5/DmUxdAXwYBUBbvribW5tTPqA9cxtex90+GQyNTmhp809?=
 =?us-ascii?Q?c1kITysa+Uba6AdTlHfbz4SSwEbyr21Gp8PzGf1QzfHhk9ln2fPRH+6+KnXm?=
 =?us-ascii?Q?ehoEMJUfq9HycLwMB/fCIsN+PdLf+hqxx7l4MbPk6992cP+UKkmZNhCTor8y?=
 =?us-ascii?Q?0mWqDfEcuLmIkM4fjr6051GCG4xCELD9GJpVQtHhFF5XLieKQUxY5W0R/qB9?=
 =?us-ascii?Q?42OFOA2BWGMZ4lj8O3AuzdNyEXaiY43qO8AjdVfE8GkZTo4J7n4/24nFlDoa?=
 =?us-ascii?Q?nvrYX5xjUaTEPm7JSMbTO8ptHif2QHLQJ9HtmH9q8I2Mjp5qezKV?=
X-Exchange-RoutingPolicyChecked:
 H1VSdjCS+FsnHIgtP4qsTMvwqj/WUnxtwRsNxm6PkjibH7hq2AAXyPz1NgdVacx1lPBDEzlcBdJnYtdBV2MHUnLTQdx1WfA9DJGd26SGhX266MIKaKGJ6srQfkItbQ3MisieMPi1XQhI8Gqd2D/PH3zzIOcx7YS4HyK0zXyhuAzbEnvz6JVkNqG8eRLGJ0NIOOLylhVZcdNTmoL/2PEncXJHFbZfliD6HzvTR6Vc21AutBrBIQ3p8JhxuT40Gj1YPmVHQsj2GOve56a5pNGPX7xH1U3Jyf0xwDdnMGt8oWM4zQxNVuYWUjfywbbJBvvjknbbkJojWzSzJzkOEO1bTQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 WTYjbprkwunsotDTb8xqQvbg57j7jwfnb441d48aglrtavClLseCGoVt9B4KwEZRouxARb679PlPujw0vCSkVlJhdC950fMdtnKpFm/vpinS/4OeU6pth9xDGqjl9Dtv7inN/mT3Cu+NeFWIUtgNjHVs9fdRJNrHWjK/0Gp5RbZ3IIUKhg50JQpx0yy4hnFjk9JWsUIdy8uxAjH0D4wJEQmRjhLZ3HP7wg14dnPfAgRTACHoW0rrl3Cr3k22Gq720FsUq/+U4HrAFjjnePvPQxTwnqm2HwdfXsEw+9RrOzsiTHmA0NEjLaxKKGd0vymEDO+vvqKId/54cG/LixWOUo9FopuKdxBiMoUtcwp9rXYVpC1ydilJtuvb5Xbd8jGqyOWN05VRUb5r+R0L2rxZE94kTjEGpAji2OAv1Q8nHLTT1mUYoMgnuN9adb/BPfedRh5YhPs2l7E7XBOddYerouKBuvZ0apMG8TDmcMshzmeVHZL/E6NJWx1955BtHdy1MiRO0jxLy+w3hG8B9fq/7F1yywzRrG23hV8fAoC0u2ix6ct73YOVgb0fz0XlVL794y/+eavtUS3N2IRtt/ejXpGBLt8oDlA+LEhGyexf+zvBMbwwT4/P+KzkrmmMoGOBGqGykisoa3llPCdykbn/bg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b596dd-f9a5-4ea0-0243-08dece16eb79
X-MS-Exchange-CrossTenant-AuthSource: SA1PR19MB5570.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 15:24:57.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PpDXrgdn3z2yTVm23KgV9r4A9v2/tQE/BfuoqYRzSe0gQ/0hCc3Zn/tuybqyLPXaiT3APgsz3UkGMePL8wQmoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR19MB6984
X-OriginatorOrg: ddn.com
X-BESS-ID: 1781883667-103061-7733-3597-1
X-BESS-VER: 2019.1_20260610.2305
X-BESS-Apparent-Source-IP: 52.101.61.133
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKVobGFmamQGYGUDQx2Twx1czAxM
	DY3DjNwjDFzNTC0MDC0Mg8MdEgKcXcUKk2FgBwsD/kQgAAAA==
X-BESS-Outbound-Spam-Score: 1.43
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.274042 [from 
	cloudscan21-56.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.68 OBSCURED_EMAIL_2       META: BODY: Message seems to contain rot13ed address 
	0.00 OBSCURED_EMAIL         BODY: Message seems to contain rot13ed address 
	0.75 BSF_RULE_7580F         META: Custom Rule 7580F 
X-BESS-Outbound-Spam-Status: SCORE=1.43 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=BSF_SC0_MISMATCH_TO, BSF_BESS_OUTBOUND, OBSCURED_EMAIL_2, OBSCURED_EMAIL, BSF_RULE_7580F
X-BESS-BRTS-Status:1

release_inode_blocks() does not handle corectly multi-levels extent
files: it does not count the non-leaf blocks directly released by
ext2fs_block_iterate3().

This patch relies on ext2fs_get_stat_i_blocks() count for quota update
and ext2fs_free_blocks_count() to count number of blocks released by
release_inode_blocks().

Add regression test: f_orphan_truncate_extents_inode

Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Change-Id: Ib0c3aaaa685e7bcfae896617cda03005d19539ff
Lustre-bug-id: https://jira.whamcloud.com/browse/LU-20049
---
 e2fsck/super.c                                | 244 +++++++++---------
 .../f_orphan_truncate_extents_inode/expect.1  |   3 +
 .../f_orphan_truncate_extents_inode/expect.2  |   7 +
 .../f_orphan_truncate_extents_inode/image.gz  | Bin 0 -> 2854 bytes
 tests/f_orphan_truncate_extents_inode/name    |   1 +
 tests/f_orphan_truncate_extents_inode/script  |   3 +
 6 files changed, 133 insertions(+), 125 deletions(-)
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.1
 create mode 100644 tests/f_orphan_truncate_extents_inode/expect.2
 create mode 100644 tests/f_orphan_truncate_extents_inode/image.gz
 create mode 100644 tests/f_orphan_truncate_extents_inode/name
 create mode 100644 tests/f_orphan_truncate_extents_inode/script

diff --git a/e2fsck/super.c b/e2fsck/super.c
index cfc0919a2..c2ccefd54 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -62,21 +62,14 @@ static int check_super_value64(e2fsck_t ctx, const char *descr,
 	return 1;
 }
 
-/*
- * helper function to release an inode
- */
 struct process_block_struct {
-	e2fsck_t 	ctx;
-	char 		*buf;
+	e2fsck_t	ctx;
+	char		*buf;
 	struct problem_context *pctx;
-	int		truncating;
-	int		truncate_offset;
 	e2_blkcnt_t	truncate_block;
-	int		truncated_blocks;
-	int		abort;
+	e2_blkcnt_t	truncated_blocks;
 	errcode_t	errcode;
 	blk64_t last_cluster;
-	struct ext2_inode_large *inode;
 };
 
 static int release_inode_block(ext2_filsys fs,
@@ -91,7 +84,6 @@ static int release_inode_block(ext2_filsys fs,
 	struct problem_context	*pctx;
 	blk64_t			blk = *block_nr;
 	blk64_t			cluster = EXT2FS_B2C(fs, *block_nr);
-	int			retval = 0;
 
 	pb = (struct process_block_struct *) priv_data;
 	ctx = pb->ctx;
@@ -111,155 +103,157 @@ static int release_inode_block(ext2_filsys fs,
 	if ((blk < fs->super->s_first_data_block) ||
 	    (blk >= ext2fs_blocks_count(fs->super))) {
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_BLOCK_NUM, pctx);
-	return_abort:
-		pb->abort = 1;
+		pb->errcode = EXT2_ET_BAD_BLOCK_NUM;
 		return BLOCK_ABORT;
 	}
 
 	if (!ext2fs_test_block_bitmap2(fs->block_map, blk)) {
 		fix_problem(ctx, PR_0_ORPHAN_ALREADY_CLEARED_BLOCK, pctx);
-		goto return_abort;
+		pb->errcode = EXT2_ET_BAD_BLOCK_NUM;
+		return BLOCK_ABORT;
 	}
 
 	/*
-	 * If we are deleting an orphan, then we leave the fields alone.
-	 * If we are truncating an orphan, then update the inode fields
-	 * and clean up any partial block data.
+	 * We don't remove direct blocks until we've reached
+	 * the truncation block.
 	 */
-	if (pb->truncating) {
-		/*
-		 * We only remove indirect blocks if they are
-		 * completely empty.
-		 */
-		if (blockcnt < 0) {
-			int	i, limit;
-			blk_t	*bp;
-
-			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
-							pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-
-			limit = fs->blocksize >> 2;
-			for (i = 0, bp = (blk_t *) pb->buf;
-			     i < limit;	 i++, bp++)
-				if (*bp)
-					return 0;
-		}
-		/*
-		 * We don't remove direct blocks until we've reached
-		 * the truncation block.
-		 */
-		if (blockcnt >= 0 && blockcnt < pb->truncate_block)
-			return 0;
-		/*
-		 * If part of the last block needs truncating, we do
-		 * it here.
-		 */
-		if ((blockcnt == pb->truncate_block) && pb->truncate_offset) {
-			pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
-							pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-			memset(pb->buf + pb->truncate_offset, 0,
-			       fs->blocksize - pb->truncate_offset);
-			pb->errcode = io_channel_write_blk64(fs->io, blk, 1,
-							 pb->buf);
-			if (pb->errcode)
-				goto return_abort;
-		}
-		pb->truncated_blocks++;
-		*block_nr = 0;
-		retval |= BLOCK_CHANGED;
+	if (blockcnt >= 0 && blockcnt < pb->truncate_block)
+		return 0;
+
+	/*
+	 * We only remove indirect blocks if they are
+	 * completely empty.
+	 */
+	if (blockcnt < 0) {
+		int	i, limit;
+		blk_t	*bp;
+
+		pb->errcode = io_channel_read_blk64(fs->io, blk, 1,
+						    pb->buf);
+		if (pb->errcode)
+			return BLOCK_ABORT;
+
+		limit = fs->blocksize >> 2;
+		for (i = 0, bp = (blk_t *) pb->buf;
+		     i < limit;	 i++, bp++)
+			if (*bp)
+				return 0;
 	}
 
-	if (ctx->qctx)
-		quota_data_sub(ctx->qctx, pb->inode, 0, ctx->fs->blocksize);
 	ext2fs_block_alloc_stats2(fs, blk, -1);
-	ctx->free_blocks++;
-	return retval;
+	pb->truncated_blocks++;
+	*block_nr = 0;
+
+	return BLOCK_CHANGED;
 }
 
-/*
- * This function releases an inode.  Returns 1 if an inconsistency was
- * found.  If the inode has a link count, then it is being truncated and
- * not deleted.
- */
-static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
-				struct ext2_inode_large *inode, char *block_buf,
-				struct problem_context *pctx)
+static errcode_t truncate_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
+				       struct ext2_inode_large *inode,
+				       char *block_buf,
+				       struct problem_context *pctx)
 {
-	struct process_block_struct 	pb;
-	ext2_filsys			fs = ctx->fs;
-	blk64_t				blk;
-	errcode_t			retval;
-	__u32				count;
+	ext2_filsys fs = ctx->fs;
+	struct process_block_struct pb = { 0 };
+	e2_blkcnt_t truncate_block = 0;
+	__u32 truncate_offset = 0;
+	blk64_t blk;
+	int ret_flags;
+	errcode_t retval = 0;
 
 	if (!ext2fs_inode_has_valid_blocks2(fs, EXT2_INODE(inode)))
-		goto release_acl;
+		return 0;
 
-	pb.buf = block_buf + 3 * ctx->fs->blocksize;
-	pb.ctx = ctx;
-	pb.abort = 0;
-	pb.errcode = 0;
-	pb.pctx = pctx;
-	pb.last_cluster = 0;
-	pb.inode = inode;
 	if (inode->i_links_count) {
-		pb.truncating = 1;
-		pb.truncate_block = (e2_blkcnt_t)
+		truncate_offset = inode->i_size % fs->blocksize;
+		truncate_block = (e2_blkcnt_t)
 			((EXT2_I_SIZE(inode) + fs->blocksize - 1) /
 			 fs->blocksize);
-		pb.truncate_offset = inode->i_size % fs->blocksize;
-	} else {
-		pb.truncating = 0;
-		pb.truncate_block = 0;
-		pb.truncate_offset = 0;
 	}
-	pb.truncated_blocks = 0;
+
+	pb.buf = block_buf;
+	pb.ctx = ctx;
+	pb.pctx = pctx;
+	pb.truncate_block = truncate_block;
 	retval = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_DEPTH_TRAVERSE,
 				      block_buf, release_inode_block, &pb);
 	if (retval) {
 		com_err("release_inode_blocks", retval,
 			_("while calling ext2fs_block_iterate for inode %u"),
 			ino);
-		return 1;
+		return retval;
 	}
-	if (pb.abort)
-		return 1;
+	if (pb.errcode)
+		return pb.errcode;
 
 	/* Refresh the inode since ext2fs_block_iterate may have changed it */
 	e2fsck_read_inode_full(ctx, ino, EXT2_INODE(inode), sizeof(*inode),
 			"release_inode_blocks");
 
-	if (pb.truncated_blocks)
-		ext2fs_iblk_sub_blocks(fs, EXT2_INODE(inode),
-				pb.truncated_blocks);
-release_acl:
-	blk = ext2fs_file_acl_block(fs, EXT2_INODE(inode));
-	if (blk) {
-		retval = ext2fs_adjust_ea_refcount3(fs, blk, block_buf, -1,
-				&count, ino);
-		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
-			retval = 0;
-			count = 1;
-		}
-		if (retval) {
-			com_err("release_inode_blocks", retval,
-		_("while calling ext2fs_adjust_ea_refcount2 for inode %u"),
-				ino);
-			return 1;
-		}
-		if (count == 0) {
-			if (ctx->qctx)
-				quota_data_sub(ctx->qctx, inode, 0,
-						ctx->fs->blocksize);
-			ext2fs_block_alloc_stats2(fs, blk, -1);
-			ctx->free_blocks++;
-		}
-		ext2fs_file_acl_block_set(fs, EXT2_INODE(inode), 0);
+	ext2fs_iblk_sub_blocks(fs, EXT2_INODE(inode), pb.truncated_blocks);
+	if (!truncate_offset)
+		return 0;
+
+	/* Is there an initialized block at the end? */
+	retval = ext2fs_bmap2(fs, ino, NULL, NULL, 0,
+			   truncate_block, &ret_flags, &blk);
+	if (retval)
+		return retval;
+	if ((blk == 0) || (ret_flags & BMAP_RET_UNINIT))
+		return 0;
+
+	retval = io_channel_read_blk64(fs->io, blk, 1, block_buf);
+	if (retval)
+		return retval;
+
+	memset(block_buf + truncate_offset, 0, fs->blocksize - truncate_offset);
+	retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
+
+	return retval;
+}
+
+/*
+ * This function releases an inode.  Returns 1 if an inconsistency was
+ * found.  If the inode has a link count, then it is being truncated and
+ * not deleted.
+ */
+static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
+				struct ext2_inode_large *inode, char *block_buf,
+				struct problem_context *pctx)
+{
+	ext2_filsys			fs = ctx->fs;
+	blk64_t				free_blks, ino_blks;
+	char				*buf;
+	errcode_t			err;
+	int				rc = 0;
+
+	free_blks = ext2fs_free_blocks_count(fs->super);
+	ino_blks = ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
+	buf = block_buf + 3 * ctx->fs->blocksize;
+	if (truncate_inode_blocks(ctx, ino, inode, buf, pctx)) {
+		rc = 1;
+		goto update_counts;
 	}
-	return 0;
+	if (inode->i_links_count)
+		goto update_counts;
+
+	err = ext2fs_free_ext_attr(fs, ino, inode);
+	if (err) {
+		com_err(__func__, err,
+			_("while calling ext2fs_free_ext_attr for inode %u"),
+			ino);
+		rc = 1;
+		goto update_counts;
+	}
+
+	rc = 0;
+
+update_counts:
+	ctx->free_blocks += ext2fs_free_blocks_count(fs->super) - free_blks;
+	ino_blks -= ext2fs_get_stat_i_blocks(fs, EXT2_INODE(inode));
+	if (ctx->qctx)
+		quota_data_sub(ctx->qctx, inode, 0, ino_blks << 9);
+
+	return rc;
 }
 
 /* Load all quota data in preparation for orphan clearing. */
diff --git a/tests/f_orphan_truncate_extents_inode/expect.1 b/tests/f_orphan_truncate_extents_inode/expect.1
new file mode 100644
index 000000000..b24aae7ad
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/expect.1
@@ -0,0 +1,3 @@
+test_filesys: Truncating orphaned inode 12 (uid=0, gid=0, mode=0100644, size=4096)
+test_filesys: clean, 12/128 files, 75/1024 blocks
+Exit status is 0
diff --git a/tests/f_orphan_truncate_extents_inode/expect.2 b/tests/f_orphan_truncate_extents_inode/expect.2
new file mode 100644
index 000000000..7edff9bce
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 12/128 files (16.7% non-contiguous), 75/1024 blocks
+Exit status is 0
diff --git a/tests/f_orphan_truncate_extents_inode/image.gz b/tests/f_orphan_truncate_extents_inode/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..30681b879455b936e05d4dcbb4feaed6c4ff1eb9
GIT binary patch
literal 2854
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
Qs3(SfSGqhPU{%0>0O93B*Z=?k

literal 0
HcmV?d00001

diff --git a/tests/f_orphan_truncate_extents_inode/name b/tests/f_orphan_truncate_extents_inode/name
new file mode 100644
index 000000000..6f16502b3
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/name
@@ -0,0 +1 @@
+truncating an orphaned extent-mapped inode in preen mode
diff --git a/tests/f_orphan_truncate_extents_inode/script b/tests/f_orphan_truncate_extents_inode/script
new file mode 100644
index 000000000..fb895e9a4
--- /dev/null
+++ b/tests/f_orphan_truncate_extents_inode/script
@@ -0,0 +1,3 @@
+FSCK_OPT=-p
+SECOND_FSCK_OPT="-yf -E no_optimize_extents"
+. $cmd_dir/run_e2fsck
-- 
2.43.7

