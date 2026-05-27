Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012016.outbound.protection.outlook.com [52.101.126.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C499330569E;
	Wed, 27 May 2026 06:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864661; cv=fail; b=CDiKZpxknwwYXotcwcDS6HAJlmQA8pWnXLeiDQ/7Pla8Djw7oj6UWvbpdl6dshdhB1An6uHrH5dd2kwDYkD7AKKdVoDOKvjftGQB27sPvwfDgIxnC/r3bH84zrdM2VW9Gdi3X92K43uC8oB9F03JcL1jsuDmsgXKQZPy2fRZhlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864661; c=relaxed/simple;
	bh=EGSuxJZTNWNunTjMz/cfMcdiE9WPXxBY7eM+j2lwk6M=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=fyeZWqZIHEp+MtfiI9HHMmbFrUHpAjlHq5BnUble7oqE8jzuuLwAsmV4A4jVCocisbTBQlLBT5c4bNNeN+WwRzVxm21JB9Wc4uzs4ZF2V8q6SHD6GOVo/gI+RIgtB8c+rUfHoH+34wAGsAJ8aBwvgq7RasuoyCmFlBzPYqJws4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=R7vhn0sk; arc=fail smtp.client-ip=52.101.126.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="R7vhn0sk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ve2TzlTfTQ4h/GaeNY/YrII+Zyaryjt/fX59QZSyW65cVqP1NQMV+jKQkPjY2r5gBY58ObGsJGy/8neoAga4QC2AnWrs20mRQAPK+OE0vAgqiKD+nx/u171QXcGJCvSzx6W4wNnVCzOhBH+4w5QpDitrIt7W9jmwumNqqleenioS7T3rEZFrTQRP+Qsx9n0ADkTfQbxLcjCxER5NcfE1SIUyzR57B9p49Gd73QxPo00wnaxsoAtfAH2r7QVMUtlXQSNyxTPF6RvlELSfaPloLJoTn6krT21C60LznXZfoI90qA/Df7a//RzWtAdyMnAt7/hJgNWe7CMC9FHxHBstug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulLKGZEyzZeeF4JdvLaqwfc9ORLVfC+948v5v6Y+aEU=;
 b=lNsrBV1uXfwWSlfaYA4/uby4cDbYUsnesimtUyz4k10UQKeA5eNOcpiCzEQj8BWGQrvnm8Bd3eQo6jO1FYaPNIQjotnyF1Wocuoh8GAl0phdCLk/i6JQbdqm4NjM6dSk/DzqnnNv2EFYhrFa0v4F075w+iGFz5N1iRctPajPeD7TM8vt9ZbNwq9pBeP42vqhr0MtJYo64pwMlwDDk2PftwQXTCx7ZBX6QBoz++mZlaQaGx5PDkh7lUPIx0eVXISA44VMbA5thAwKkY1XkusMdN+XX/GO2BxcNiu3TPjDW4DXi8Dh2loZuLtIlvr3an+Hf1Gc3QhezaFYFXMJRhGYKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulLKGZEyzZeeF4JdvLaqwfc9ORLVfC+948v5v6Y+aEU=;
 b=R7vhn0sk8qiVxJVinq5mvRyDl9pDRkSM/ntHtcvjJNK31V1OEbIOKmPUysEHZ3UlYEnSKPKT6YDWPAC+OifP860mct+weK4h/ULndhBTos7kbOlhtdBLw6EkXzet6JimOh1EO0u7jgYgn7vpY4hOi9SDsvHWr7E3gDtuVxjDB88qc/TXdyuuaRT1LSYgFWlJao3G58iy+gFbcYD/OC3kKTVEXf+2T2Q788R9JyJn0bot6yJrPITTZxoRjw6JP1rHS88+2dN+NWr5wouKUl2N95LKwEZa/24hldoIV6pQDgoYNMCco3jeHmmHdlxtre0zjWd+ggRFKP5d7t7U2xVeLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by KUYPR06MB8674.apcprd06.prod.outlook.com (2603:1096:d10:8c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Wed, 27 May
 2026 06:50:55 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 06:50:55 +0000
From: Dai Junbing <daijunbing@vivo.com>
To: linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	tytso@mit.edu,
	jack@suse.com,
	linux-ext4@vger.kernel.org
Cc: jack@suse.cz,
	linux-kernel@vger.kernel.org,
	Dai Junbing <daijunbing@vivo.com>
Subject: [PATCH 0/4] fs: mark selected blocking waits as freezable
Date: Wed, 27 May 2026 14:49:08 +0800
Message-Id: <20260527064912.1038-1-daijunbing@vivo.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0014.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::17) To TYSPR06MB6921.apcprd06.prod.outlook.com
 (2603:1096:400:468::6)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6921:EE_|KUYPR06MB8674:EE_
X-MS-Office365-Filtering-Correlation-Id: f229b05f-1afa-41b0-ea4c-08debbbc4cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|1800799024|366016|18002099003|56012099006|38350700014|11063799006;
X-Microsoft-Antispam-Message-Info:
	LF6X3FInFbsU0GzElCb8DZ2JxqsfxFVKHBqCvRoUWKDIt5vJal6lIxeEj4/EvSd4HI95vtWQQCgYV8GGYxeA7W69OwnXYZBgdaFh2jfan6xQcFX1LrCh8EqF2hBo4sTVabQzTP1azm+5buUDe28HIZ/O+lwVKIFVs/5gf1rJAAZ4q+G8a85LGOUeqtccp8krrBhilEi5J+0AIdku6y3NVfvStu1KBcOSAWF1R1VnK1/h9uud5x+MOQwAyrvlu6lXlcNSvzTnhnRWbEGNYugstyV28G6ZUGQoMdXY9yBYQ5hd17WecYDti59upmR/+uM18Fu9ko3nbieEDGcpAgdF052OVnqPnB8OR8A5CQGmPXgoqXeoTD5soAAZ5zjh3Z9WxRB4SvH1lhg2V4Wt/CEH+uRml1oX9cDfGXK7ioAC4fa7C59OOYSSyGJQrnEuU3KMi89mu5ontYGd8XmPXK7HSy/XnR4RHxCpco1d00kncZqAH13Y1sLAxwODyhR2a0rHkhxL3CMVERl07EK8HkIku6K1yP4dN7SFCv8MmDaJJgkG6SXtaolWZGit7YDsq1evqg3hon0UHszgERNETZWN6FM5HJdG+xIUTh6C55OLxPi9qRWhuQv4I1zgZ+Rkx1lAVSe3ARRRF+FiAwr48slc/tz4zhv9CXMId1XyToaTYBWBQVKNmmd1pe9OL5IAHHVg2rKvyFSOS+gKatuIX65rc7+6WiuxEwkGKVOTWK2UyfDyY0NG2MLBQS8ZF2BMC7Pw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(1800799024)(366016)(18002099003)(56012099006)(38350700014)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zA4FdrCr3nZRCB2YfpBKgoV7WLXZrZWwDM3WlU1AI1oNVcEf3df8tgD1vKCl?=
 =?us-ascii?Q?oRvJmwhNsa0gljRSLzmYATwFLgzEdruP+5iGavELLnEtevkw1uH/GjeB9zPl?=
 =?us-ascii?Q?6uRb9IgJGO0wj3YOGkZoKMZVCHl2Q9CQiNv1N/uTl9EBTrniOyYZjqQMYYVU?=
 =?us-ascii?Q?vi9zh/HajzLssJ0o1jYJ5LU4X/APGB8vZOSDQ5P/TsZwC1FY+L/jPz332m6Q?=
 =?us-ascii?Q?6v7LwHPjcrCb1oGAAnVzXUeZbYioFlfWF98bNsBG0V91dkwqCGYsJcELsL1u?=
 =?us-ascii?Q?2bbVLVdbO2eM6MXuTExniwA/PiwTeVJtED/wyBoDmc05UAtdEnu5ovSoODdI?=
 =?us-ascii?Q?PfPQNeMX0LwCeNK3D4/hKxoKtSnjsbpKGhj7FyENNJwMnExfs+cucUBAJBUg?=
 =?us-ascii?Q?2Yju96LCUus9oW0l+p8FAFqvDvCFx3v+OA8qFR4Cmf4PgojmUP9hFn611QTS?=
 =?us-ascii?Q?LlN8xoCB6w2/s/IfaaJZh8T9arncIlHFZh1XlCfV7XgyS7/Fvs5j/aPz2j0/?=
 =?us-ascii?Q?sADJcRwmh/St67OSQej23BCIgXJ+NltaLp6Qv1QzKkepdwCqdvJ/RE2T5Dxh?=
 =?us-ascii?Q?Aw6oPTaDLYWyjZs2jzgph43jTfq1BNbkSJF5N4+GLTo246QVhk+/dXLfKAp6?=
 =?us-ascii?Q?1HBk/zTSPwPGKz0mbyx+AwjCVJBjjWwpI01jhYz7Hha1PNQdkAt5GSonmfsC?=
 =?us-ascii?Q?dwJ5jhqTDtYw4Tr/1CwR6jcWa7G0RhTCQ0sZg+pIUj/slppv1qqoq01bonng?=
 =?us-ascii?Q?Re3JpjQXMYi/Jc6mr/e3CZXmdDTfBZ0y4GfLTSNNkSbT6x8NoSjyy3SVKYiu?=
 =?us-ascii?Q?JGWtK4hGnDDxMMChW6Kco4Cc87bFt96CFh+d0gIuRrnl7tiFWkaULvBKNeX6?=
 =?us-ascii?Q?iu1ShW+Rn3ZBFBNs1du4UjaOJqB/E5QaqKtTK3GrGL4W/iwCCAxPW77b2acb?=
 =?us-ascii?Q?aPdyjdUmrNKua/mlkHhVS6xirBdG5wznIZLVg/ZDch/SYcJIAluazq9lTLM5?=
 =?us-ascii?Q?duzOTW/Pb7K1iU5Dfqzv96mcHHVJpVKaRUJSROpsXkFhC2uGWWu0nvMWqWas?=
 =?us-ascii?Q?+qUpMIShnOK6vmYlKfA/hIniafKkLue1cTVPQ0dMS+PgTkcSdFWD1LYH/3fa?=
 =?us-ascii?Q?pJiXWKCZ1m7rYJZ6FmkXfkK53QsY4XcrluHCn0nG993kA+wOaiX9j9wEPbGV?=
 =?us-ascii?Q?CHCekAeejFYZAU5KiIIp494fhBs/yO29uHx1qtWDzi0bH+UGmbFRKKElu6Qi?=
 =?us-ascii?Q?j92BGIAM6Fk4j9cSj2800uQTulnhrbrKG0IKD7hHpOtv/PSPDwBALMqcJTzz?=
 =?us-ascii?Q?gFAiXkKfE/TOjjkpKRxqqGPPkV/cBCb0s3JrOyLbtmQ5LkNcwNmOPToKbhuM?=
 =?us-ascii?Q?kC3RQVH+zcRYf+0v7jEYVMgOWm0oSW3tkRznM/w4EMGbZaGTPr9mAoVurxBS?=
 =?us-ascii?Q?1zjhsw792I4e4dxKIM+j8NKJ13vpGn2itgpZYrHzCjzu9AKYP2RD0fJKJRBy?=
 =?us-ascii?Q?M6L4dYeXdUvb4mVUpJQXnfx58+cTxjFvwD9RxNS2IsEJRZY2HYI00F2WypoK?=
 =?us-ascii?Q?gGK04d4Z4LZQGijhBATln1vJC0Tbld7yNVDnH/MJCuseRE5rDEqmYDcPzk52?=
 =?us-ascii?Q?wsX4TtUn1nGpbFNOLDv20TenmTmmK0nYUWPfXZ48QL/3KoXXfZqyllxtPgi9?=
 =?us-ascii?Q?/gvJMYrHTspIE6tb0h6DbPIYOROEllEOaXErKjmf4emEdfOqANtECYO8XlCU?=
 =?us-ascii?Q?u3TGLyv0Ow=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f229b05f-1afa-41b0-ea4c-08debbbc4cf9
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 06:50:55.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zSZJhgb80Gdo0vZNkjAEf0kg3frzQWB4cyKgK0TGaPEBDBGKt7G/u8+TPNRtq4OPok2pj+6LpCaZ3Pwfs9P2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUYPR06MB8674

Hi,
 
During suspend and resume, tasks blocked in some interruptible wait
paths may be unnecessarily woken due to freezer state transitions. This
can introduce avoidable activity in the suspend/resume path.
 
This series marks a small set of blocking waits as freezable in places
where the task sleeps without holding locks that would make freezing
unsafe. The goal is to avoid unnecessary wakeups during suspend/resume
while preserving the normal wakeup conditions of these paths.
 
The effect is more noticeable on systems with frequent suspend/resume
cycles, such as mobile devices.

This series currently covers:
  - epoll_wait()-related waits
  - select()/poll() waits
  - blocking pipe read and FIFO open waits
  - kjournald2 commit wait
 
Comments are welcome.

Dai Junbing (4):
  eventpoll: mark ep_poll() sleep as freezable
  jbd2: make kjournald2 commit wait freezable
  pipe: mark blocking pipe read and FIFO open sleeps as freezable
  select: make select() and poll() waits freezable

 fs/eventpoll.c    | 2 +-
 fs/jbd2/journal.c | 2 +-
 fs/pipe.c         | 4 ++--
 fs/select.c       | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.25.1

