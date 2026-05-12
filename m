Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010021.outbound.protection.outlook.com [52.103.72.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268633DED5;
	Tue, 12 May 2026 07:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.72.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778572296; cv=fail; b=RzcLc9gaKMPv2ru7QToQKZH4b8nafztdneX2uyvE5wJwynnWO1yo4GHLF6WRyehxEXKXGZCKwHEG4DvOsWWd1dfyDZEAaEBKhBnW0TlbhEvpI7J7j2CRdIDNUTF0+9/p5oFuFF98F3TEHRuRvoabctgVTv/pIj0OHnhKdwq1rno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778572296; c=relaxed/simple;
	bh=XdjZyd4lI6xgXBurWKdSZ4/i7fJv5BOAZrNnwuwAW7A=;
	h=From:Date:Subject:Content-Type:Message-ID:To:Cc:MIME-Version; b=YvPPrFIFN4DsL+tcBh2vKXqdf/MVfsKnvGuHSfSU7TOl1jmHoTvEWroBeu6RejXMySoDvOWUx6F2+xKhwmv6h/f6fD6XCzKrkeSaPfhbtDzqf/0hj5S+NENkdLgb76PmJ/JVk2641M9UCipCeTSMLjTX4ltcNtdo3P4Bo+euLcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Lii4kGvQ; arc=fail smtp.client-ip=52.103.72.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Lii4kGvQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CSmjb8F8EousX/rAp2E/94ifDJFERRheXeOhYc73KeZIr2Z2qf0PhOMIukxUK6fWBKAPs0cW8TmN7LELrAdVBDVvSPmgnLbUjWnjTRXkOzMmDNLnpVIDtY6ClZtCzowedKtduvKn1WoHfctrfk3hRPGkRLWPFc3jH3BSVDf+uDaObzC9vv2LJsi5OSWB3meLtHCUIIVr49vveLlp4ZMLjnsH0I6tzJkqRmo+Seg5heAJ6W8anNd7sJwpGyeu3zZRZTcuRUHpRkUsNQCKU0gPMU3GMbGqtZkQ8CoznsNWjzIB0h/p0VHeVRhacZdOKo2C4IYsSYoUK1mclAQNYOz0og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwsYc3NlMD9ReTFXWxHp9N8jQHnOZ7V+NnjSkmVc978=;
 b=Gxo5tJYf7pc5PbyHwr09O/upJ5MW7qYkn6osFK2Rrfn3UoJmRy2Wj+R4blPeION01gLyGHoh9XaJhlb2qfnAy6uns9E/Jkw3NmvRfcZ/So3IdGwVnZqrLzbKziZBcrpUx3J1AMwtqvIHChg43/n/9IeU8f3cXqDkmY2VYLh5dD3+5xKFnJVyi256sVxMFfIsK7rPYEN+Noh4vLEktbJgqyhClaXEcaapZf4eEJcjdfHn8a+AQNjtvfOnAIUrpnCFlHTU3v55xj3muPq0SB/0QZX2BqDPNj47D3RsxIWGNmv/S2wpYlf05r44+GqxT5POWPhYpx/JL3pKiGWKhoq//A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwsYc3NlMD9ReTFXWxHp9N8jQHnOZ7V+NnjSkmVc978=;
 b=Lii4kGvQEREcZbrKZW+970lZ7JX9BY+MeHtTM/JaTISJRmzBlPwsnYvh3bX/eCrPfGVLX2ncsrxgzdLnmGmcnyDNxt3uopZS2j7rIuSLijuO85PVHxRWxIBuezn7XQ4oGzqMM96A71ukaMMekbq79Qk+wFUlfISpZk6YXarQ+p2aPNSzLtE/8ECpRJMUPCFLxlebvhi9NBXKm+AUvmZr8NTpy8O1bOn2snlxy6epLI+Thn3Ubzk+EFxhI3alGFYtZxAZyuxKEkfgVqDLsT7JRaX6m8w2U4FmQTzcw+BY9Qk6CRNcmjeTlZcemWK9rk4u5sSwbqfpylzMgyY+9HndlA==
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com (2603:10c6:10:1b0::5)
 by ME5PR01MB10331.ausprd01.prod.outlook.com (2603:10c6:220:253::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 07:51:30 +0000
Received: from SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c]) by SYBPR01MB7881.ausprd01.prod.outlook.com
 ([fe80::7cd2:d6e8:3fa0:5f0c%3]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 07:51:30 +0000
From: Junrui Luo <moonafterrain@outlook.com>
Date: Tue, 12 May 2026 15:49:34 +0800
Subject: [PATCH] jbd2: fix integer underflow in
 jbd2_journal_initialize_fast_commit()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID:
 <SYBPR01MB78813DD23B28BD49B1AA1123AF392@SYBPR01MB7881.ausprd01.prod.outlook.com>
X-B4-Tracking: v=1; b=H4sIAI3bAmoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0Mj3bTMitRiXaO0NJM0yzTzFAMzEyWg2oKiVLAEUGl0bG0tAO0/9IR
 XAAAA
X-Change-ID: 20260512-fixes-2ff4f9f7d064
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
 Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yuhao Jiang <danisjiang@gmail.com>, stable@vger.kernel.org, 
 Junrui Luo <moonafterrain@outlook.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1474;
 i=moonafterrain@outlook.com; h=from:subject:message-id;
 bh=XdjZyd4lI6xgXBurWKdSZ4/i7fJv5BOAZrNnwuwAW7A=;
 b=owJ4nJvAy8zAJVb4wiKgu++DA+NptSSGLKbbvYyzaqWLqxfM9xPsTbdbql3cJle8Nmf2BoHLS
 Q9yNqsWne4oZWEQ42KQFVNkOV5w6ZuF7xbdLT5bkmHmsDKBDGHg4hSAiZQEMDKcuLDk/NE3D1of
 CH8PWf04/59V8gXD6Mp6U+9tNQXJVX7sjAwrXvBlPPvhe3bS9oMnStzKhE646Eft5xCV2PL66Q4
 r5pvsAD9VSwg=
X-Developer-Key: i=moonafterrain@outlook.com; a=openpgp;
 fpr=C770D2F6384DB42DB44CB46371E838508B8EF040
X-ClientProxiedBy: TY4P301CA0013.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:26f::19) To SYBPR01MB7881.ausprd01.prod.outlook.com
 (2603:10c6:10:1b0::5)
X-Microsoft-Original-Message-ID:
 <20260512-fixes-v1-1-22146bdb46d2@outlook.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYBPR01MB7881:EE_|ME5PR01MB10331:EE_
X-MS-Office365-Filtering-Correlation-Id: 13274087-0658-4afe-aff9-08deaffb471d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|22091999003|6090799003|24121999003|24021099003|55001999006|23021999003|12121999013|41001999006|15080799012|8060799015|19110799012|5072599009|40105399003|52005399003|3412199025|440099028|12091999003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVJXdXYyUE5lcEZVUWliUHdDQk5Gb0xNbDZSTUJPNHhYS0FaMzk0VE1SUGlC?=
 =?utf-8?B?VFl6SDc1U2laZjVNRy9SWlZIM0RZenBJS0QxbmlqblZXSm8xSkt4M2NLemN4?=
 =?utf-8?B?WUw5K3RzaWFwTnpPYWJvZUoxVlhRSEppT045YjlRWkZlRHRPZnpaSUw1OEVo?=
 =?utf-8?B?aEhQVWFxZUxwdityMTR5NTI5RE5uK2NFYTlyczkyYmkvWXFKZ0FyOXNNVHFy?=
 =?utf-8?B?REU1bnBKR0lrKzNNQkNGQ2RPUGNWcXR0RkNUTHlxK1FONm95RHRhU0JIb0pa?=
 =?utf-8?B?ZS9MMi83R252YTRDY1JXeFp6bTJxVEJTdWQyVjZqWG9FcXlRTmM1Y29PTEpP?=
 =?utf-8?B?bW5sWmIyai90bkgrZXZJVkk5Y3NuLy85ck1hTFRic21lZlJNZ2ZHRUphK3dS?=
 =?utf-8?B?dGFERnVqS3F5NllabnYxT2owWitBdlBlR2U0MjIrMk5rVDJxNWhTcXlSZTNJ?=
 =?utf-8?B?aWlMekphVm9ibXo0U3JxTXFkTkVrS3Q3eTdVZHVVRmppOWhzRVpvdzhZaVV2?=
 =?utf-8?B?cEZsaEMwcTFKdk1xOGhzWWhibWxmaDU0eTIvRFRxMU1meVV5SGRibVBIOGgy?=
 =?utf-8?B?cVhNOHcxZFZYQlBYdFp5TVJpVlBGdlUrMzRDZENhcHZlMkhhZHovMC9KSmlR?=
 =?utf-8?B?LzIxRmlSK2o1Wk1LNXdoa2xTeDdna3picHpvRSsvUW90bjI2SytnN2FBVm1T?=
 =?utf-8?B?SFRMaXl5dkM1N2t4SHh1VzJWS1lDV0xIb0hCSlpWcVlRcmVwMERzTTBsZ2g2?=
 =?utf-8?B?akRRNHh2cTAwQkVmcU5DRVUwa016YXIrYjU0TFhDZ1lmclNPb1ptQTlRbTJj?=
 =?utf-8?B?T0F4VUhIajJ4UndMTG4yTlE2Qk5JVTIvWkp6RnRUSzZVbnkvcUdERlRNbzVs?=
 =?utf-8?B?dHZmNmdWd0g4S05nWHNQZW5xNXZ6VDhBblE1NFpONkcwQmtGM3Bhc0lTck5O?=
 =?utf-8?B?YjNFN2NvWmZaT2t6V1VIYW9lRDA1RmlKbExXUzFWYjhWdHRzLzlHT25yRTE1?=
 =?utf-8?B?b2x4allLSTZjeEpQakxiZjhPckhMck1KbVZSaG1IWmNnU2g1dDBTek5jaWZZ?=
 =?utf-8?B?eklCOC93NkhsUm4wKzBrZngxd0pHKy9WVFd2QU1JemVuZHAzQlg3NlVMR2J5?=
 =?utf-8?B?Yk1zYjhRSlNVOElUZnBKT1R1cityc0hoUWFBYXYzeWdjR3doaTFzMUZpQy9W?=
 =?utf-8?B?UFdrMVZvQm54UDBvTGpYVm5ZcVpGRVphZFFtQ2tWYVQzMzNycWE5dWU1aGI0?=
 =?utf-8?B?TEtYVThkem9iODlRa2x5UmxLMkZWS0thbm1lTkNEb2FxU3ZZTm9rd0w1eXZJ?=
 =?utf-8?B?b0o1THZXNDB2RjNmUlJzYisxMGgwRDNJNFJCY3dwR0lDVHpFOFVkaVNPc24y?=
 =?utf-8?B?R3kwSXlDMjZIeUJFNS9GeXkrWC9IWTkzdVlCS1FZL0VsOU0yV2w2Tm9YL3Fx?=
 =?utf-8?B?UFFFRTFsWEc2bVRvbUtQUWM4dGxtbmdVT28xam54WjJnOFhMNVJFem5kZFpp?=
 =?utf-8?B?VlY0dVBxRGhtMlZoY0FsTzZnVnFvd09xaStURkY3T3JQNUNaN3BBWkNiYTJ3?=
 =?utf-8?B?Vkhzc2Fub3pYaEo4VHRFZWJReHVyQm1WN21uOTJZWU1hcXlBMlo0anhacENh?=
 =?utf-8?B?S1lPazdKR1ZmckVyZG81WnRaWG5hN0E9PQ==?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWVKQTBHeGVHVTM2M3RlOVFQZDdOTTN6a3U2ejFzRHg4U2tiOC9DK29jSldr?=
 =?utf-8?B?K3V4NWVaMTNIL0JlZVJKQ25EMDdkMlFPcC92ZW1YZlgvbW1JODltd1F5WTRP?=
 =?utf-8?B?SExuMjFQOVgxSXFzSkdMcGFzUWw3TzAzMWo0VDI0bVdyaDZ0aEhlUHhuMjhH?=
 =?utf-8?B?NGtMUE51d3hTQjM3aS9GZ2tlbWtnQlZyeEowMi9FWk03cEtlSHFaWlYrR1Jx?=
 =?utf-8?B?bWtDZ3l5V3c4bXlqekV2bkE1NHZBRHZnQ3dyK2dFV1NqbmY3aUFYTm9XWHlW?=
 =?utf-8?B?V2QwM2w2RDF0VWFmWUFCVEh1NE5BZXR3U0VBeTROMzl4ZmxkR3lGaDlKb0JU?=
 =?utf-8?B?R3FDTnVrZVM3bitpalJrenQxazhZbFR0eHJ3TkYrSXozQjVNNVA4UXM5Q2xt?=
 =?utf-8?B?Rnl2OFlBQ3dBeUg1OVI1YldVRlk1VHQxTDZIOGRMNTlFZmROb3ZYblNYbTZI?=
 =?utf-8?B?WExHNzExWVNLcWU5eG8ybTBWelpMQzZUTzJnNVRZNGhEbG1rZWxla3BxbU55?=
 =?utf-8?B?TzNTMWlGTCt3d1VrOWRlcVBlWGFzQk1aQ2tFWm85QUxHTHZpOG42c1g4VW1x?=
 =?utf-8?B?OFRicUlSbytQMW4vT0IydmVKOFFYMERXNHZQZHpheVg4SmZOcDJEb09mQTRS?=
 =?utf-8?B?cWRYbW11bUFtdGtnbGxSbmNMa1BmZ3ZlQU9RMnFuUlI5UXpNWklOd011MVRN?=
 =?utf-8?B?NHFzYXF5MllpVk9Hc3hEMHd4T2JGTGZPZ3B2bGVKVTBCU0x2MWtCSmpuZlZD?=
 =?utf-8?B?Uy9mWlZNVWd1T0M0cENxOEtGTTNYOUF0M1hCOGx4bnNCTnlkV0orVmFVd0xy?=
 =?utf-8?B?ckVNdlV3eUkyVjFxNWQwR00rRzgrNWg4MnJXVXVTQUU4MGpVOWFrLzZGZ2hn?=
 =?utf-8?B?dzBTRzJmQnVKbENITTlyZEJVamxTOFdROXNzOHhOak1lQUIxSTJPbFZ0bVh2?=
 =?utf-8?B?ZEJKai9XOVJaSlppQlBKUmxBSDB3cEM3OVBkT3EwZDAyaFlXQ3B0SGkweFh0?=
 =?utf-8?B?VzFhQ3gvdlN4dkZXWVRMNmNjblM3TDJuK3ZiL0UzeU4zbHVpbklVcXlvV0JE?=
 =?utf-8?B?WkVzTTJFZm1NUFBPVXQ1UkU1YnFEYnh2LzlZUjNVUWxUbXQ5YUZEalhScFVG?=
 =?utf-8?B?Q0R6Y0daMkVHOWpHQncwUWJydXE1Qm02NXZndC9pS3BIV1lHTDgxQVJZN1Uv?=
 =?utf-8?B?OVJBaFVLWk1uS2wvN254VElaempZbngxNVI4djBZT05HdjV5SEVnTkt2QUdt?=
 =?utf-8?B?MWdVamRZeDIrMGdOZXlvbjkyTGVLZ2k4cjk1TWhLQllzeG9EVlNER3RTT2tq?=
 =?utf-8?B?NjZQM2M3Nm5GbG1FNzlMZ1Zpa0h3Y0JxYUQ4ZlRtL2xVMzBmeHF6MGhDaCtk?=
 =?utf-8?B?VWY3ZXpva0QyN2p5SjdzenIxVVp0cWNtT0lpNG94Vnp2V3B6MTIrK0xsN0kw?=
 =?utf-8?B?NEZLNEhIaEp4bFVwRkZWRjBZS0lQRTRIbzZYRGFjMGw0K2hyK3NQR3IvbUMw?=
 =?utf-8?B?STMvL3VXYzJxek91REx3RU9sK08zejN1K0JIYUFSQ2I5R0I4cFU3bzNNekRD?=
 =?utf-8?B?K3pONHRpeTdDaFR4WU10Zk1RWDhTMmNyNCtyT0pzK2xEWnlPM3dZNEVUeHk2?=
 =?utf-8?B?bWpHQnloNFZibU1lTXFKU0F5dUtDS3Y4V0R3K0tsNTlVZEpkQ3hNTkNkUklh?=
 =?utf-8?B?VmVVakF3bmRMRHJWWUUvTXZSL1E5NTJ1NTc5MS9TcEQ2MFUzeVBjTDVOOUJI?=
 =?utf-8?B?aVNPdkVQUnRRdVZadytuZFc1RE1veGdrK20rc1RPNXNVVzJ2NmtCcnJULzcx?=
 =?utf-8?B?UkdramY2ZmtoNVZ5bkk4NEErR2VySGg4MXFSVWZEU1Bnb3BMOWRFQ3lyeGto?=
 =?utf-8?B?SS83ZFBaMjh1MzJZRWlCMVA1V1JPOUoxb3JPcTBTalphZUE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13274087-0658-4afe-aff9-08deaffb471d
X-MS-Exchange-CrossTenant-AuthSource: SYBPR01MB7881.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 07:51:30.4468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME5PR01MB10331

jbd2_journal_initialize_fast_commit() validates journal capacity by
checking (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS).
Both j_last and num_fc_blks are unsigned, so when num_fc_blks exceeds
j_last the subtraction wraps to a large value, bypassing the bounds
check.

The resulting underflow corrupts j_last, j_fc_first, and j_free,
leading to journal abort.

Fix by adding an overflow guard that checks num_fc_blks against j_last
before performing the subtraction.

Fixes: 6866d7b3f2bb ("ext4 / jbd2: add fast commit initialization")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
---
 fs/jbd2/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cb2c529a8f1b..a54146576c3f 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2263,7 +2263,8 @@ jbd2_journal_initialize_fast_commit(journal_t *journal)
 	unsigned long long num_fc_blks;
 
 	num_fc_blks = jbd2_journal_get_num_fc_blks(sb);
-	if (journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
+	if (num_fc_blks > journal->j_last ||
+	    journal->j_last - num_fc_blks < JBD2_MIN_JOURNAL_BLOCKS)
 		return -ENOSPC;
 
 	/* Are we called twice? */

---
base-commit: 7aaa8047eafd0bd628065b15757d9b48c5f9c07d
change-id: 20260512-fixes-2ff4f9f7d064

Best regards,
-- 
Junrui Luo <moonafterrain@outlook.com>

