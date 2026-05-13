Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012015.outbound.protection.outlook.com [52.103.72.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996E3EDE71;
	Wed, 13 May 2026 09:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778664621; cv=fail; b=KgPkuwM0K71mAMxYtRBbcx/yOYiAnN6SxmQie0M6d5+rfO1nBoCC1HGtmFlRTpfMPBHHCVVaZHse9P/8M4w7TX861IUdEHI5fCuXFwhBFAhgw+XfMNcMha8hOkgQKeDziBhqC/eenxHgVESnzIGsddDcdRUOdklzWPcrgl9FkBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778664621; c=relaxed/simple;
	bh=LW1rrdOh9KjYtmKcow2UFcHFw+OaIqOGifGVZfcmOag=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:In-Reply-To:
	 MIME-Version; b=emWLoklohXHgh09RWSfemHeIW8w25UQ8Y1I4O/7pXJmLoj56Z/YlYL01KYDS3jINHF4B5rv6vjYgV1+Chy/omJMUAb2UmHAH6dPE8UBC+RFaWkp5MSfNhspm4iSQ3Z8JrUlAnkJSKEpjzz7OzuLwvM7JptEZLJBPXd7tl5Jd7Lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=cMRgn8BM; arc=fail smtp.client-ip=52.103.72.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="cMRgn8BM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uaTLs1Tt8nT6rIY599rgKAsIAgOaTDDrwtxHecLjYmspiYF40BfZ1GIx2V8ctOInADf2tFr6b1HpBR4CsNpWzSFdyUv4wtRhG7FdKPxn3hYLRy5fG/MNvjpX8s3mH/HQP8zTBX8zQ1412zPxdEGAaIlT7Cj52JXNqTVVdUQV43KFjUIU9iMv7bYw6d+ASqUwH/VO3eaA4W5Z9KovfWL/DbEg+5UtMJFA1mrTxZlisqQlJi5Q/u5xf8/Q28DIzB1cBP40MByrmSaxVNpSVuwKqEU70o8rqstKf9e6X2Z12GF5eFAYSaBskA6M7HYALGuutWFCfvIx3qln9CoAI4uZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N27HIpZuE8+qg5fxTVBek/oYg9QUikHN4Tlat0JWxXU=;
 b=kkNka9KZkmb4UfCN5lxluIgAMRWd1QSugPioJNgQDFjuP4R3F88thOtecEStjozxobfOTTTbwhPOujW/FxOYx1+bbV/UkLemOmF0b5uopXG7l7HAs0iRwNL9hkGAE9McfeEa9nWhnNlOijouCb25SkDtTueoNwBDeja/zQcyfIDjXLUB//0E+tG3nrU1oXsgsf9iFjkhb2LJSURSqgCbBj2JFz5hDpHVZF1XlEap+/nmVwJ078M5jMcjKx1cyVNl2xlNV7VzAjKJ6Npu4KMo5pKfKhiD/ajZewimUQo7J8rQqSAYdywX6V0UGPdUsqujXvTwzbGD2DNe4uGEeGDekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N27HIpZuE8+qg5fxTVBek/oYg9QUikHN4Tlat0JWxXU=;
 b=cMRgn8BMRRsaTmFVjgRv6SOIbOaoOSWuWyZkuKL3n6djt/Z8VmyBKBmzEv8VQHPEuF0qUoDFW5i7DCxbzbskituLHLI/IJ2UOinslSjn7F8+aM4SNG8fLEtZ/yPxbs6JeNNfeKfI7dW+IU0Xr5fc63KU0ZyC0UT91baXuk69tpQuFzL5JMn0KOc5XjODxY3Hc/lmrg5D4p6VFqxd+c+bhOIxCLOzbt6kxQCRcchFobR7r4dn2nDjlzUp87qFenN4TwmgBiCMMvfYHlOd3D1Qbqur5KLZLOr2G4+bI8SKVHPCqS0DGr9cerv21Y+3C5gENCyR1zIm+MEiGuZW/aXG+g==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by SYBPR01MB6510.ausprd01.prod.outlook.com (2603:10c6:10:112::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Wed, 13 May
 2026 09:30:14 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%3]) with mapi id 15.21.0025.012; Wed, 13 May 2026
 09:30:14 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Wed, 13 May 2026 17:28:40 +0800
Subject: [PATCH v2] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB7881663C927DE9D7BBF4D1DFAF062@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAEdEBGoC/x3KQQqAIBBA0avIrBN0LIOuEi3EmWo2FgoSSHdPW
 j7+b1A4CxdYVIPMVYpcqcMOCuIZ0sFaqBvQoDeTdXqXh4tmT5GCw9nRCP29M/+hrytUhO19P0H
 H6WFbAAAA
X-Change-ID: 20260513-fixes-e6dcda3273d4
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1561;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=LW1rrdOh9KjYtmKcow2UFcHFw+OaIqOGifGVZfcmOag=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGLBYXd+kj0mZdv775bJrx7tHziYGHCmVKp5l5HTZ7+
 C7tt8gGZomOUhYGMS4GWTFFluMFl75Z+G7R3eKzJRlmDisTyBAGLk4BmEjJMkaGEwsnHV25wMvX
 5Y6gVOChtQ3JhzPTuIMTw+If3GDye5HXzcjwKqNigcbHGY++bDt5u6VVd47P9NMRuVv6SpbrOb0
 9OIeVEQCAi0ul
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
In-Reply-To: <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-ClientProxiedBy: TYCP286CA0228.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::7) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260513-fixes-v1-1-22ad08b19665@outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|SYBPR01MB6510:EE_
X-MS-Office365-Filtering-Correlation-Id: e2da9ea5-53b5-4b17-2688-08deb0d23cc0
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|8060799015|19110799012|23021999003|41001999006|15080799012|6090799003|24021099003|55001999006|24121999003|22091999003|5072599009|51005399006|10035399007|440099028|3412199025|4302099013|12091999003|1602099012|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2dNZzZSRDZZdGx5UHFUT082a0hkZGJPUmFadXc2Zy93SlFpeEpIY2FBR0lm?=
 =?utf-8?B?cUFxN3F3Ty9DVjQzY2tybXNCWWpSVGdJZysxUmpIMHJpczlSTHRnOHpjMnp0?=
 =?utf-8?B?YXFXYU1vL3ArbnVlczJiWENhdFFhMXUrMmNhK3pGR3pqNm5ocTRRcENDNWV5?=
 =?utf-8?B?V01hYU9kREw2WGhET1JsV3cwYnpFMldiTVR6TytCN1E2OXdPcGFyaitBY2o1?=
 =?utf-8?B?MGd1eEJwMFFialZ4d3BGUW9ES3VtL1dmOXNhWU1vSHl1dkF4VHpYdC9wbkhL?=
 =?utf-8?B?M1gvY25vQjZFL0J1QjhTQWFZa3dINUFBSllqUjNSQkxobWRlRy8xb2lDSEYy?=
 =?utf-8?B?VlN3cnlGcWM1NEpKdXJiMVBlbWNOb0xXU1pSOEZtZUFsaDVhZDNHYm5ldlFC?=
 =?utf-8?B?QVFUZGxSRWZaWERFNDh2VXFhdGNDaVFxd01vclljYWtzbTdjSFNNUjIwT040?=
 =?utf-8?B?dzU3dHNJVnBRd3hTWTRQYk96N1UySmYwUkVCSG85VXU4eURHd3RBcDFiNVJS?=
 =?utf-8?B?V1o0NzFUd05YN0RBS3ZnemhwWDlDaURVOFdFWWJYTW1NaW1YV2E5UGtaUU1x?=
 =?utf-8?B?bWxsRXRkZ0hhY2pSMDloWUNBU1FzNk1TNERQR2JCMjNaclRQYWlrSC9TcDNK?=
 =?utf-8?B?Um9LT0pDY3RKQ2NyenRCaUl1UFF2ZVdXMDRPakp4OC90QmhnaDRDNFhQTjU1?=
 =?utf-8?B?Wm4waWJKWGhSYW5FUm4zSU5VWkRaYTNGZlpHbk13bllRc0xCRDJ1d0IyMU50?=
 =?utf-8?B?RU9jRUxhYTVIQWRVM29HSENBcStOdjhRWEFzVXN3VWJXN2lYSnpXenhwZDdX?=
 =?utf-8?B?Q3ZmU1Mra3czd2FTblh4VWNOMDcxcWQ1Z05iMVlRazdxRWdXZXQ5V1J6S2hZ?=
 =?utf-8?B?OXJEL1IxdDVGSFRyZ3lxSCtENmljRVNzNXZmeFBQY1lKa3dCR2xHVXZJR09l?=
 =?utf-8?B?OEFCZk4vWThyV0h4eWEyQ1dvZFVhVE9kY3NJZlBFcUkzVDRPdEhSak9vVkZ6?=
 =?utf-8?B?bWlCU2o5bk85ak5yUTBybUlxY2g4NXN1NHBOdTVDWFA4QytWS3VTRG5rSHdp?=
 =?utf-8?B?OVM5eGI5NTNzcTlVOHJDVWJUeHhzK2ZsVVN0aFNQOGJuVnFXb05DekhHQkpm?=
 =?utf-8?B?YXhRMXNSWXM4aGovdkxSTUlFQkhWOGYxR0xVVlZOc0RCME16SDJ1T1luV1BH?=
 =?utf-8?B?WlJydkVaSTZ0WDRXQ3pJdkowVmJWeTNyejlvaUh0eGk2R2ZLK0JpclBQMkNk?=
 =?utf-8?B?S2NuM3ZGczFjdCtjVjE4WVZ2cHJEOXFaakp5ZVovTW9vbEhNVXpVY1BIb291?=
 =?utf-8?B?UXU0Ylg5dSt6aUlkQ25GWVZCenpFZXNCRzRadEx6SUlhaVBhc1NVbWFEMlZZ?=
 =?utf-8?B?blFGVnpYQ245VWIyVVR4QXQ1c1IxTVd1T2pQbXo4dHgvRDhuMnNqQnNJaXpO?=
 =?utf-8?B?NGFyaWI1TXNWNTlvcmlQNnhCUW56dE5kOEJqb3V4dFB3aU1FK1VkcmhxanNo?=
 =?utf-8?B?d2plSytsRHJ5R283V0t2akpuTlN3ekxSZjZXVkdJRW9NY1E5WWVwQmkwUys3?=
 =?utf-8?B?K2N1Um82bTJTZ0hvcnZXMCt1bzlsbE5aWFhzMklrQWZMSFRLTFFhYzJzU015?=
 =?utf-8?Q?D5+v9SiFry/WOpezWE614maX2V5SGt+7gNjPp3e58C24=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEVWc0lVbVhuMitWcmNKY3ZYTEhvTjkwS0o2UkRLc2VvTVR4RFFEd0JzTnFI?=
 =?utf-8?B?MHI1elo0VVU3WTRlUzlld3hZVmU4RFRleGNRekFQT05tSmJQR0NRVjhUVjlL?=
 =?utf-8?B?QTFPMnZNcGxmSTBOM0c3dDlDUnBtaHpYT2NnOGZITmYxN1lrS2dwOTN0RTBq?=
 =?utf-8?B?QlVXUmlWeE01cEViNDBxb0g5WWc1Skw1d3VIZkZJWnowOGRFWUlzTldaZ0M1?=
 =?utf-8?B?cjJ6NTN5QmEwWFQzUjlpeFR2R3hac2V4Y0xINXdNNlRWendhbENCVGFsUHov?=
 =?utf-8?B?NFhQWUM3Qjg3Rno2RXVTVE8xRHM4bDZld2g3L3EzRzc0dUhoT2NDektndTRk?=
 =?utf-8?B?d2VqNTdZckU4bUtTMjNmWUczUGlLZEgwUWxXVE0reFdzcDVad2k2ei9RcTNv?=
 =?utf-8?B?TVlOV1JKZFViUW0rbzFiMWYwd2M3c3Bpdmx6cGM1L2lTQ1RZZ3ZSc2U3OUsx?=
 =?utf-8?B?bHJ6SzViYnJMM3YwR285S3JwWnFMc2U3YTF5VTVFQjlMdWlMWUxOTVArOGtr?=
 =?utf-8?B?WTBqVWgwVXdhYjl0dlUzb210K3FkTDNldlBtZkIyRXNDR3VXbW00L2wxUEdU?=
 =?utf-8?B?c0hzN2loTEFQS2FscGFJYWluSGFTblg3ZzQ5WjY2d0ZmUXNuWHhEYUgwUkw4?=
 =?utf-8?B?MFlmWXVRbkZpYUpKbElLKzlLbkRIaVJzamdQOHkxeTVEeEdUclJ2TjJxc3dz?=
 =?utf-8?B?KzRYRnRBK0VUMWpHSWNqaUhaYXBOZkw3N2pIQmpnRm55T3owbkpLbG1QR09D?=
 =?utf-8?B?a01uT3hLZVY1WUpBMG5jNzFyR2lPOU1DRVVJYTlvYmZjaEd4T1VlNUtKeTNw?=
 =?utf-8?B?b2hVam15T1BBeHVBTW8yUG9wOW1zVGl3bDJoRE9ORTIyeEc5UDFDOXJWbUQ1?=
 =?utf-8?B?MkNDT1BMOWxiYjJmRWZjT3BwaXZRUUxSdzFiYU9Kd1FWQ0J4eStRb2tIOHA0?=
 =?utf-8?B?Q0drcCtXaVdsS29nQzRJS3dreGJnYU5ldTBGV1BSU3FDSkZseE5iNzB2QmdB?=
 =?utf-8?B?eUQ2SnZzdHROcG8zSnRGaE1JNFA4OVVMTndPNXFQNlhyVE9DQlFsNWZVTDZt?=
 =?utf-8?B?SkphMnN2RyswTzcrdDViUWNVMHNVbFdFKzhMd2hOQlRlVTdDZmQ3cGVSQXVH?=
 =?utf-8?B?QkVqdHBybXhmR0lnYzhGV0p4Y3Jpc0pWMG00KzVtSkJFUVhYbU50V1BaVHgz?=
 =?utf-8?B?Q0lUcjZmSURkUk1TbGZndkh6WFdLb2htMWs4cDR1eTZpMEZCRVRnWXJnMUZV?=
 =?utf-8?B?ZlhNT0hWUmhDTHgvNzhYQXFBcW1xTXpVUlBYQzJZTURyTVYwSENXbEZTUjhu?=
 =?utf-8?B?b3dOMGdXUWlLejVZSzBJbFhHT1hYdGgzUDlUSFRrZGc5MDJWQ1F6ZHB5bXRu?=
 =?utf-8?B?U0gwd0VwcUNqQkQzUFg4b2NSMnBwb2xsSHE3RXh1N1ZER3YyZGVIUjlpNFMx?=
 =?utf-8?B?Unh1czJPOVFTV294UlVDbm1ZZzdRK2VucHhabVJXVEJGeThEMzAxMUxENHRh?=
 =?utf-8?B?MkNtcXB2OC81d3BFSEFzVjNIWG9oeGlWZEVFcHRoZFg5R21aa2Q0YW1HL2dz?=
 =?utf-8?B?UXEyTWNMbEhQamtrUGNsRHJmTllrSDVKQ2QyUjZDZEI2WEhpRlpjOXVsRXVK?=
 =?utf-8?B?M2NqLzJSSTh3V0p2c2FZaFN5RUxaS0Y2TmJYNmlhck55a3RUN0xlTVJCUkhi?=
 =?utf-8?B?cVNiQ0xPY0pOK2dvUnJPcThHWm5ZOFZNYVJkbGZDWjR0d1RtU1lGOERBOTlh?=
 =?utf-8?B?TEZ1OWtKM0haRUpWalZyVmVmTXBrYUpaWm5HTEF1emZZSWNtZCtkMEpUTGNu?=
 =?utf-8?B?TjdXMU1McHd2NGxOVTVvUFd6UWpFOWtvUCtIMTNSRE9HVUt6TS9Cb1lXSld6?=
 =?utf-8?Q?LipTgmhVOdscZ?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2da9ea5-53b5-4b17-2688-08deb0d23cc0
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 09:30:14.4898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYBPR01MB6510

jbd2_journal_initialize_fast_commit() validates journal capacity by
checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
j_last the subtraction wraps to a large value, bypassing the bounds
check.

The resulting underflow corrupts j_last, j_fc_first, and j_free,
leading to journal abort.

Fix by checking num_fc_blks against j_last before the subtraction,
returning -EFSCORRUPTED.

Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
Changes in v2:
- Return -EFSCORRUPTED instead of -ENOSPC
- Link to v1: https://lore.kernel.org/all/SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com/
---
 fs/jbd2/journal.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cb2c529a8f1b..0bb97459fbf0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2263,6 +2263,8 @@ jbd2_journal_initialize_fast_commit(journal_t *journal)
 	unsigned long long num_fc_blks;
 
 	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
+	if (num_fc_blks > journal->j_last)
+		return -EFSCORRUPTED;
 	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260513-fixes-e6dcda3273d4

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

