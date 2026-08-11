Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11021078.outbound.protection.outlook.com [40.93.194.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031CB310784;
	Tue, 11 Aug 2026 16:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786464246; cv=fail; b=GA7YeS7kn2u4dPOngYf3x2cd7/6nMoMmF2Yvv2SmEKjAN1qDJOzSOcssYQaQJC7ygBAl0Cd9vQppXcKo5ALxOYxh26Bk/RN59xVjEzw0wajGZytseqojX6IME3r7fXA/U/sySixZEN8Fv9U1dklaSQ3DDiw2zJeCmI18cm/Gy4E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786464246; c=relaxed/simple;
	bh=wBZYP+H7qZkkIoKnqcQjAG05P3BGIJ+FTmNPt8s7boI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HkVeVEazkcfTXC7P99onA+gPAHarZgCYUcOOPY7V14RxqZNEFFHlZ6mnibWoN5I41lMyGV0ti+gAXKvFH8I4UbNEq8hAt4JpkMejSvAWdz0eaT39MKoYouTD71DcAjoitkaSudosH4m3wesNIRn0kRLStBB+W+N0tj0hw1Xhp48=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com; spf=pass smtp.mailfrom=thelustrecollective.com; dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b=RCqROpQP; arc=fail smtp.client-ip=40.93.194.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelustrecollective.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thelustrecollective.com header.i=@thelustrecollective.com header.b="RCqROpQP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OmAb0LLFakfT0kR203w0dHMj3Fsej9rzlIMbzs2PjS98uvx9MnU2vZYbVo9FJDi9wcmUq4svxU/MYQ/wglYBxyNC7VoSa8J1IFKpI71BaEGedrm+mxEECp24mliziFer3ZWPqZdiH/FOy9pvflCbkvCID4RCURergiYbhyA5mCg3GLaBZTJZr69WWA0KFb9r3moEMbaZhS9iRsKTE7+nrckPALVUbP9i86F3OFVUJpc5o6Ii2T3KFTaAt8Opj5gY10u/qfo/AdH69frREudEQPJHGNDPGFDq19x6lX9Ovb/krupd0fbCEMa+e4UCoy3dn6JuBLrX84dYovjBAxOW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bxG+EQVJN4tERNdgESHqi+V09hm/cF4MQzVIou1b60I=;
 b=FLHUo/fEMFLL1SNsJg5dbjyBuoyUld9XlGmcLI2bfxG/TY4kf5PDM7K3vr64zt7+ceI2fjrF84JEaxaZy0eEgxicplFpSb7/F+PRFhr91k8FLSt59XIdt3J92rCUsu80CVubGAmzqAXRN/MO5nASyPf0/znNVHDH7MFfRpj8pl/6gXoAL22Hk5Twt9hNcAPz3J0IutQG09IK3RMOBTs83f25cP8IBHMtYdCzzkrqOwx/DfFFkxHCqxGFGQ8xQ1WYA3ofIxxEPSEjA+xhS1PynSYYeJeNfL2uk2qsKwcIyJxKDx0ZrHu1aR6ooF/tavlpxMaM10OlfQ2e1nNOxjsRXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=thelustrecollective.com; dmarc=pass action=none
 header.from=thelustrecollective.com; dkim=pass
 header.d=thelustrecollective.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thelustrecollective.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bxG+EQVJN4tERNdgESHqi+V09hm/cF4MQzVIou1b60I=;
 b=RCqROpQPS7gWGGV29UlAQuiRxe4RtkNbDX+Iq1R3yNBby9cVhNuwZ9xIDKnCx/B0swQElfWd6uxnC80ouBCOwkSqO97cBqmAXqfkdOvZEDsbiWxx503fjY2+cx13Yz+PvrM0x/czeCfjTH5qJPv8fImr1Rx3ow9mbL252bHHMBV8rigzV/Q7hvTf0CxLKSawGwHksART+ALSoZx+fz9cUDRCdFPUQ2OsFjx4WVz+bNEmokNIT5iSEWbNJdQCIueey2BBr861O8Eg60ILRQNcoW1QSFgfw/wnDcR769A+ywJZgRigDnMcqC1y7E0oNmuXWbuptAM0bskokfV8UeF8xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=thelustrecollective.com;
Received: from DM6PR04MB4682.namprd04.prod.outlook.com (2603:10b6:5:24::20) by
 MN2PR04MB6336.namprd04.prod.outlook.com (2603:10b6:208:1a3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Tue, 11 Aug 2026 16:04:00 +0000
Received: from DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee]) by DM6PR04MB4682.namprd04.prod.outlook.com
 ([fe80::fa5e:6e7f:2655:bfee%5]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 16:04:00 +0000
From: Timothy Day <timday@thelustrecollective.com>
To: linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.com>,
	Marco Elver <elver@google.com>,
	Theodore Tso <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Timothy Day <timday@thelustrecollective.com>
Subject: [PATCH v2 1/8] ext2: mark s_next_generation as guarded by s_next_gen_lock
Date: Tue, 11 Aug 2026 12:03:29 -0400
Message-ID: <20260811160336.782342-2-timday@thelustrecollective.com>
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
X-MS-TrafficTypeDiagnostic: DM6PR04MB4682:EE_|MN2PR04MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: cb124ae1-208b-4dcc-7ddb-08def7c227ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R8bCxdw1qgx5PiYvAzaIRmfl0a8cf97RF76BSJqHxCrjBoU+3AAp8LyPjzIzVTGPfXp2oB4Za/30NDatHUPrGeYW9W/1dfx4FFffu4jHKbT8QaUzpG849bszKk0IeyIohgO9lR1XbAayAqSkWNWo7g8RESM/N7LJJBfQ8GrICylRDsoVtdvUNE2q6bPoLAl0u77gcNxsTjb7X1Ur7qzUahlxQjrdtNUqq4o5pU6bMjgkOuJMnMvElxrtNyShOqvw/DBRTCb3fGu7KVqWazP5UotQs9cTKlK4VvS5yiTBmQfhhgr3bqV79jf9Prtd72zkB0eSZXDnctgyccfk5bb7G5kvZiq9AM+Or5SoJYjxWfyykx+CKGVMYD774JZXZZ5t6C6QjNG5f78kNtmsfy+0eDCFHrA72NPvsxi6zAjexZfKzKU18iOKfY8kWz0N2nlYZT8r8HguEj8gJuFrOqg8pVY/RMBvoO6Q3uCJQg821632IGZNwxS3fI+7L5usqYcVMyLkwR0hxSbhVB03d3sLmILyShi7NSClWhze8l2box88V3CmNk2EFIZh5u79bV64A4cBwV53TCxljoyzYizvaiAnI2Wer1N97chfFXAV3ablRAlMPrCg+NMqOc+sAvNCLr0wmQjqnb/GQVWo5jjyd3WWW7fm55gJwhy96g2d0Mg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB4682.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nlm2gqN/tqhwGZtqnnEKMtjTeNno9O1xkXLG7HUXHi78VAXJJIeNpSFOb3gm?=
 =?us-ascii?Q?nLR480Oxd9vHWtUPamKF5U8tEEFRX8yrhqTR48+z7vr3HIH11dcRYosWx9Z6?=
 =?us-ascii?Q?17olfyf6EVf4C46j2BG5b85nTvHhkuTevWAKa+tTwObxGosUeZ6B72ZAqFT+?=
 =?us-ascii?Q?q1tx2lmHt1k+G2Fncd2WZGeTQIDQURC/p4vB7DkRoDrWSletnol9fTLLosI7?=
 =?us-ascii?Q?L1RT/XaBDbOQ3HvaStHH20fvCARewVfh9g6lfAZnUvGQhnlKtlBr3Io6fYSn?=
 =?us-ascii?Q?wQGwAZs3TDTPPJAv/LjzhRvyya28QM5XCB+FaG5rc6qFhFbki3i80bqeFC2L?=
 =?us-ascii?Q?wGvAa+rfpn8I8iOOQKQZm0zjR6q8QM8Xf1GFXAJ0MbsHjBQyeVTe4pfTbfMq?=
 =?us-ascii?Q?fSjPowIoU9e0BLUY80K0OC2cXt31RdgyYK78YfvxwPbCCkhjJPWeYBrfg0Ay?=
 =?us-ascii?Q?LNw0V5CO2b7jKgi8csUHILSgU5nXSZeBvmkYxS6PNtqGJZkFphiu6Yv9DWD/?=
 =?us-ascii?Q?Ic3nVwEzqA01fPT4QrQUxiYSCHqs1Z1+z7fYcY+RsARv/KTcAzR3bMU7qC6l?=
 =?us-ascii?Q?Eks4D0LnKfl74KTyXpjYQhS0XV7EBXOp6I2WkLX7su98oRGOrpmUuMr0uTyT?=
 =?us-ascii?Q?B/UOQpszdEauFlLO8JJBu1gr35lcWidES7sKPegWocwbF7Edu53cgTdJSwcm?=
 =?us-ascii?Q?EXqzm4SZYytswwviQv4peFlcz3r+sAHz4bznp6isGIivnPgl0aAFkYsYolw3?=
 =?us-ascii?Q?EQATS3879KFgEUa3vLRP2EBmNdTs3XmOisqcVKJRu6OexptXPJuUkdZias3m?=
 =?us-ascii?Q?SP/ywkqVdrYbDadPsQMi+/1XSo/r2AWNHtOsWBl7rqwekbIurTJzabAVuUX3?=
 =?us-ascii?Q?Ln8jzJQ885dRF7Hx6sUBIBsSvwJ1bjhzSy3jJXpTBCpDnAunYWv2hFHjMChX?=
 =?us-ascii?Q?DGI4Kv5svO5xDFzX9jm8OVnEzw3/TBoBmyfe5cwgkByFqoBT5/cyYEWBt9Rq?=
 =?us-ascii?Q?uRFGUNTNTQaizo/83wY5I3enmLIKSWLc04PqAe92ltsa+R8N90tyDx1xUCxn?=
 =?us-ascii?Q?OLUC2W7SSLUVoLUBMZDOepgqUnIZqwK2c7DQR3Jn/LcWSZSFkLqpEJBUqIpX?=
 =?us-ascii?Q?0o8yRUldzjEpY9Ppfm6k2a3/L5N/mUs7xkVfseQrK9pxPpbt6WQsuatchY5M?=
 =?us-ascii?Q?RIW3iQ9MnNtolmJgRGa3gkOVDAiK7diMOrr+DEbENlHCSn4+wm7jfO8COZC4?=
 =?us-ascii?Q?arEIWroOCDkbG61OkRIJpl5EkFyeYOvJd7tOPz+Kp4NToysvDrzNtqP9F4Qs?=
 =?us-ascii?Q?8YgOu1kIM9mFTRc/0VsQAtNigandMNwzJq9sN8tYQrs0UV9Zi3v+xSz+XtyX?=
 =?us-ascii?Q?4yJhSN4ktJTtH4XfyxUiLem/XDa11jFcnoMREaH34mGT1dwc6hnvMUCbhepr?=
 =?us-ascii?Q?E7/yg16Pylv68DqytY3gA1Iw7THZIJX52BZHXRlt5Cm7bUXNDTajbHb0ZCS8?=
 =?us-ascii?Q?YRuONVhAjY8hHlc81Uhy1zPKNfXYmbTnOocOaih15rPQrvypaBD/dlwhqsFm?=
 =?us-ascii?Q?tEb26FoSb0vcFdU5VlIycCJXmsfCnZ58GJ+rrcGew/jQyn8u/9b/3ViexnOr?=
 =?us-ascii?Q?Aj8nqRhuNFyx1hkKqsnZs13IQniXpKN6KgRsy9wJIgbkwyVBoOgYzpMIUkLA?=
 =?us-ascii?Q?8qnrOfIdNGk8xu8x0lmup7Z4q0yuDgRAeJla73G0S+N0zDa4OaTz3mxZ4LC4?=
 =?us-ascii?Q?Cbulw3sGcuUNBS5hV8f4hc9NLjlDCeU=3D?=
X-OriginatorOrg: thelustrecollective.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb124ae1-208b-4dcc-7ddb-08def7c227ed
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4682.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:04:00.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4c9dec06-8f2c-4233-98d5-ca3cb36218fc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ossA5rgH1YlMbAySZz188PeSYz23p7xANCtnp9adbafrCYK0lALZWndR5DrXMgmFXHUbpmyMCWRbHTTAly0kTzKP55mo1Qd2G986mMoM1WE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6336

s_next_generation is only ever modified while holding s_next_gen_lock
(in ext2_new_inode()), so annotate it with __guarded_by() for Clang's
context analysis.

The only other write is the initialisation in ext2_fill_super(), which
runs before the superblock is live. No concurrent access should be
possible. Convert the spinlock initialization to use
scoped_guard(spinlock_init, ...) and place the write under the guard
to prevent a warning.

Signed-off-by: Timothy Day <timday@thelustrecollective.com>
---
 fs/ext2/ext2.h  | 2 +-
 fs/ext2/super.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 79f7b395258c..e851d2a6be66 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -93,7 +93,7 @@ struct ext2_sb_info {
 	int s_inode_size;
 	int s_first_ino;
 	spinlock_t s_next_gen_lock;
-	u32 s_next_generation;
+	u32 s_next_generation __guarded_by(&s_next_gen_lock);
 	unsigned long s_dir_count;
 	u8 *s_debts;
 	struct percpu_counter s_freeblocks_counter;
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 3999f8f3b156..b8bb1f88a620 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1125,8 +1125,8 @@ static int ext2_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto failed_mount2;
 	}
 	sbi->s_gdb_count = db_count;
-	sbi->s_next_generation = get_random_u32();
-	spin_lock_init(&sbi->s_next_gen_lock);
+	scoped_guard(spinlock_init, &sbi->s_next_gen_lock)
+		sbi->s_next_generation = get_random_u32();
 
 	/* per filesystem reservation list head & lock */
 	spin_lock_init(&sbi->s_rsv_window_lock);
-- 
2.43.0

