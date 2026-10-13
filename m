Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288C33DE425;
	Tue, 13 Oct 2026 09:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885043; cv=fail; b=nAFQvcWeN1nqwW9AMKsES1XGj1BXqHN+pvMXTnTtrE5Jn/sCrG/+mW/fLEJgUWOWMxejKV5Y8ByYAOaq1wvWzCFLjULLadCryydPTsBnNQjn3lw/3kjcOVaylNME9o/Z+F09ooDl+IS6ee2EQOEYUo1Xs6/Dgqz4toAKByL2OTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885043; c=relaxed/simple;
	bh=tVTMlgvgK1mlghYafVJFUlASq84M5QV/ZE1fMdEd+JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZcbxjGYgodEA7rtX6rBcZ50PthaNAaeEuFFXvRWfzWZCVdXBUwYGVQNw8i78rBx1iZoypS3/5AWcubEP+55McrtGZY9IaZHqzIubgP6pR5GwA8jlky1g1HuASIyf/IZEB8v4CDAt7f+ZrvRO3xHKwlI4YlqJjvFI87qjY5OjF1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=FyKJ4ZpM; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=pWXC4ceP; arc=fail smtp.client-ip=67.231.149.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="FyKJ4ZpM";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="pWXC4ceP"
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D7sIRo2049197;
	Tue, 13 Oct 2026 04:50:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=tVXe0LqpeZyuTSmMokwxS3/dfLYrgTPdKsPhAxnRs7E=; b=
	FyKJ4ZpM1mZgLcYmuzdfx20EkXG0mKDUQK+jOsEmlNuI3PWMM4l0tqDYF4i8Gm2W
	QIgiOCTAxHcPkJK0iI4fPBaNcJ9Ie4aqysov7IaiYmeK9EZXnXoBymeR7X++jsNV
	Hx+6cBb07x1ds6PXFPjMvWw6dGqTJi8G5TSUF+2Sy4A1aKGGoDe/Dotr89XjjMHL
	gXwi/fESEDfHvu1TtzH5Ehr+i/d+S1FLoo+Y1fX+LHRsU8/jAaGAxk6DU8iwKDJc
	kyHQqVz0ZEOLrCZLbnRiJT0uY85X38+d3MfbIcuYabJ/H4ulR6zrpV1D0jjwj+hh
	EWCPcuM40u/3J30fTifsBw==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020115.outbound.protection.outlook.com [52.101.193.115])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 4h7jrxbfp7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:50:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+VlS2roBbBlXvuqGvQuOWTZMptOoFRijZHquhMQJj0Or8iuBZ5nqApvc46oEDcTdHhu934zeyob7+WmlaLdNhvlXc55vQDvhxp2kOKULXGE44TSQVP3LLJ0YfjBDpE7RjQK/J7zCdXz8tessUXefFvXaRjxAOFlLuqksZYLCUBJPBebL4BqJCsHFkkrZBhNH9uW2mHrCBAUfdTOI2PVwctD4LaNXD2nXDwsww4YjszDGsfmXp86Kleyim06Kisf/uKoU7KFxHeWN5HTUsNfzvHH8soAFmSuFlryjfsVbX6VHcaSxCSK7MsnzIj+bpYnGtzQUnDiAdtSkoe045uT4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVXe0LqpeZyuTSmMokwxS3/dfLYrgTPdKsPhAxnRs7E=;
 b=NHQ1mxvTmmFJi3tvAObEz4ID7fZyXbm8sUb6sR9zLdbUXNV35PZMWbOrDzBR1wuNQiJGdWQMTPbvC/3z2yL63n2xFKMYwATZoCJpXdVIZsyAHNRtWSkGeX6e9SzauWUCvsh4w7YJfItT42qF8f2OJcWJg3/cDzvbVqg6mDeQO4cBdkxrnJzPO8/tlx3Yz/dBlbawAFKO0eVgamZYC9yfyiMiKPsAecvayqiwD/riJNt7DQqeXtbAUcEvl2rDPG/Hd5TYgR266TjbHH02nl7+Vzo/T8gp5kkR0+cJLcejdsKl1Gffk+yv3rdIhunnrWbUVyB6PDhNuAqsP5GwYAfA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVXe0LqpeZyuTSmMokwxS3/dfLYrgTPdKsPhAxnRs7E=;
 b=pWXC4cePw0sxraYcRSxB2vk2jdVnH5Tg4SYEX4ZbTBIIKb3eO05zlyKmzH0dT7M0Uq4CuzNG6R+W2PVfzA+iCGD7IapAzWwI7EUd2frjrpV/TBsMdAiBdqt9FwgYqXih+z9Fjuiw3LhduMSEWuZo3pDAPBMMkRypYf05hVtMI5M=
Received: from DS7P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:8:25c::7) by
 DS2PR19MB9175.namprd19.prod.outlook.com (2603:10b6:8:2b1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.12; Tue, 13 Oct 2026 09:49:55 +0000
Received: from CY8PEPF00000059.namprd21.prod.outlook.com
 (2603:10b6:8:25c:cafe::a6) by DS7P221CA0017.outlook.office365.com
 (2603:10b6:8:25c::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 09:49:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 CY8PEPF00000059.mail.protection.outlook.com (10.167.247.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.0
 via Frontend Transport; Tue, 13 Oct 2026 09:49:54 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id EE54440654A;
	Tue, 13 Oct 2026 09:49:52 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id C9EEF82026C;
	Tue, 13 Oct 2026 09:49:52 +0000 (UTC)
Message-ID: <f4f633d8-cbd2-477c-8afe-9d00611a255c@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:49:52 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] firmware: cs_dsp: Give the control read/write KUnit
 cases distinct names
To: Mark <broonie@kernel.org>, Simon Trimmer <simont@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Brendan Higgins <brendan.higgins@linux.dev>,
        David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Randy Dunlap
 <rdunlap@infradead.org>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Zhang Yi <yi.zhang@huawei.com>, David Rhodes <david.rhodes@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>
Cc: patches@opensource.cirrus.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
        linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-sound@vger.kernel.org
References: <20261013-kunit-param-names-v1-0-4b22ec5b85b9@kernel.org>
 <20261013-kunit-param-names-v1-4-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-4-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PEPF00000059:EE_|DS2PR19MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 208d9808-a9c0-4632-6a82-08df290f5578
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|61400799027|23010399003|18002099003|16102099003|22082099003|10067099003|3023799007|921020|11063799006|261009223027099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Hmc6epQRPsJ+y7VPenjIDBxRKBBZ1W+CaI5QF+oHAoYiDCygiJmU6Zi4rJY3Yf64NUErofDKElM2r+BGFgC+9A6oyyxdXBq41nCzKyLBJIM655Js+yq+xmvjlAHj3u/LVqPKWR2XAlEfMdhLg8XWY4yzedQMAgZLn7XFLKGXKwJIx9PybunPn9Nv5LybZtbny7eY1BE4WXyVr0VtK2bN2N7dat7az10Y+Ej8XjKFAqC8D2uiCZ4KIZrPXyXnU5UR2exjb5kxP5tqP8IVED/abb+ljOD8UbGjqRP+ZtoFD5AYdq1TXNBTiKrQVrvUMZPXypINRw+TNzAxMd2I4fvU3EUV6AqW2A8vHnLBp67N2Nqp9AUqLOP3aWvR/y65tRgxcuaigGaZwIOS+/5vwKuPXWQFSJ40NxUlMsyIcZc85jBFeYyB0bdJ453I+pISzw8Yme7SHYQ7cQDVSd7LrpMGLqZMteWlW1dGaoKhhI0yS2wn6fWQzfEqlJZR6xaeKZqjDmIVr+9WtOk9Y2Xt661HvMxLDMKRx1wJX9qH2kNZk5Hj1DSxw90OLeNxqHbfFfRvdJ/OhZZIOuVzKIVnh9d1vsJg3LETQ01ixeqVaLYBPeh+PVSSh5gm3Rw5T5HjlYsCp3BCN89CVuK6tM3uk329tAXDUIqxf9Iw1p/v6qfHzX6UVfcCgymR00CgQMTFfiJ89/9b89PFm7fDsDKahZSFzYvkJdzCVFqIvfyVCkd0SPGE+rQax+QVobkRBeLGs/0u
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(61400799027)(23010399003)(18002099003)(16102099003)(22082099003)(10067099003)(3023799007)(921020)(11063799006)(261009223027099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gLYorMp4Qw8rWFayIN6wKHZLqJfHq94R/Owz7tyEN529pIWd+76GQR/70qFiJHRchEMCJwy/+jA2cUV7FiLC79oZclksv7njA8gAV/N3zKhLltuHJECl/uRCGlt5Z4q9N9PsmwA3dl76GnCzEj3gPjRI+AfuKbfGi8ZL2SGYvKbOV46rbwwzNTdT1zJRYromHiSBmMdZghax8ibWvqF49X+MWGSTmIJNkaQ6TLCeYgu3OISrEudrQ8uyFdiMUbZKMDGjLe5lyBul0kuIOKzxDusi4Ef1L/pKH+p0rJ+JugPiu3r9ZKQnj7oDSqF/SUarbfbPDozW6s4UDEexlSoTMhUFZ/7qSCpr0ucDmoJdfa6YYcM2HkrR/Z9dwljd95BYspMmlvIQGAE6S9eeBqs0sH6t+dVueta4xuh/mtzpJ9lDnxrutw1FzQ86Ut/p4uJ9
X-Exchange-RoutingPolicyChecked:
	ufNzBEa3NE1H8MmO2XYDo2bUHlwQlRjKeXJOHdI8J3Vtzv2/NMIt2YH+GMBWHRQFuRA/hEQNqlhk7xhhEismH5qW3TpTXvfSzfFTx6smRsvJiIeY1lgebIovthuTKOrrFOszKr1DfQxzpYG2Rfdiwn2WyIQWj8Vhaa8ZlwMxc3LUnSL44OkF5xFWge4GV5zmKDQLL7khT4IgvW+KJlukWD0f53ArclxmhYif0mLsRionyKEZ0gnWo3Z7popJpFmiqZZS4i8ZKHitrRaGJ+aT/1KgI81UDLLoRfLC+h3/F4ea9DC+TTFWDKoFM64eqQujfF8neJ/JHpoe/GGNX9MMYg==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:49:54.2160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 208d9808-a9c0-4632-6a82-08df290f5578
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-CY8PEPF00000059.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR19MB9175
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6acdfeca cx=c_pps
 a=1UxUaKSOIsEpFYfBxZ3OzQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=Dj2-6B8FqX4mGL0U3gbX:22
 a=w1d2syhTAAAA:8 a=yyjdeEYMql9_-UDXHKQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: O7WibqsheYp4IoS2sCViD0MMogXk8pUW
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX/CATBu+uZvpV
 tZb2zo2WHODEJKMnyDHFeDlAZct29MK+prMO92VTsj6E8jjWzfxHwLaTk9zLbKQ/a/f+X9gug2A
 lNhJzEctu2pOb3MfwhIZtIz2h+sOUZY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX7kN1EGZ7pcsY
 4NTtLUBdX6cAYSvAmBD2UQYXUMpp0mJ0EoBpVoXbngjp2mQbW0/2TDypzteOTcw6vetyIB8h9Re
 AAABNioROKRZGEdqYLBu/eJpZfIxbAfUbg9d/YF4KaUDYhTJ8hA0IvbiTkwb4u4nd6zu1gRgbr/
 ggD/ROjTAzkhdr32ije4wgocbHxXeLlOioGhVxXXuj1IXYlnN4BKUGzWFxRrtaw/x+4ISxNo1V4
 fObcKi8CQ+LDkuNE8Vr7kANX5d3c1n/ZbPbzzZ2hB6YBSNkpB+xVbfXumzYsP+TbzGN02qkvxlf
 n8P+1n+XIhym1yReVjjLLT2+JV2ycqCo5A2zQOfsBQqDA1bzMW7if0Lf+p1wKAmFy68KY/uN+z7
 +3/zIT2yMKGENXF6EnvnNK9G5YiJtlxt1HVQqYbqwOn+DeMI+wnKSvV3wzbdXN1e/rdUSj+2aPG
 aUON4XLaveTYvuOfLSw==
X-Proofpoint-ORIG-GUID: O7WibqsheYp4IoS2sCViD0MMogXk8pUW
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> The cs_dsp_ctl_rw suites run cs_dsp_ctl_write_running() and
> cs_dsp_ctl_read_volatile_running() against several sets of parameters
> by listing each function several times with KUNIT_CASE_PARAM(), which
> names the case after the function. The resulting cases all share a
> name, so they cannot be told apart in the results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> cs_dsp_ctl_write_running-all_pop_varying_len_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

