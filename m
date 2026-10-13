Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC5A30569F;
	Tue, 13 Oct 2026 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883232; cv=fail; b=MsG1mxKqR6zQZnpekGXmCncyHUnd0R6XCGB53SonpTB2Xy1Z1xKSZljhDuGX33Zpee4Ig0i33YUuxfOUHPdZ2NG9BwMti/8fhzYQXaWkpbFEhhW48Bg3m0xsES+ejzKwxwpBNGFrrbEeEMh0fpqwKm6rZhLNFSl0dSOF6Hcfk9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883232; c=relaxed/simple;
	bh=QH9t29UMmTA9hp91OdTjaWnutiYH8eT3wFL7lTZ9McY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAr2oHHYxGpWGBAbAZv80XtaOEp3HNFIVoyKxJ1TQSEkxTm7LB4GMLqucgNmmJWL5LzmO018Uyf8pM729Fx3/LNhRoaUTNl4wFbq4dDATS4nNsj2NZLpaJhb7GXRAPxhUn0XmEg7S0+6fvDTNn6QInppo5uj/1pQyppcP+Ofh+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=GVQdmgdj; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=jT9hJ9EJ; arc=fail smtp.client-ip=67.231.149.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="GVQdmgdj";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="jT9hJ9EJ"
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D8PgGa2100188;
	Tue, 13 Oct 2026 04:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=Umj8pyXSU7vmzUdA7V4bgMz2R6N3mzwMianEbaofrP0=; b=
	GVQdmgdjO+0WaGV7W5XUSuQexeDit+pOTVBZRpsYcQHiRKww9KSMrGJkryVGO1Mi
	vK1V62r4FeowczOJdDaWLH7k11bEKuOL+kUoF4XTwntrngcRpCvVh6RUVt9POjI5
	rWRvJ7Ll0n+uLklBGpSQpU9xQqbP4NkfsO4V5R1uoUMsqj1W1RCds5WA6dQ6BKmS
	SRR6eJvsh0xYzOshozJuqUhu7eczSZHzJx73AGna0Oa1xAUFNyj06Y5RCRnHG+8C
	uyDD/cszi5OlERoNEOANXs4LYT89jA6QJGtYvSvrEm5eiuovxgKaZN3cK442rRh4
	UZlFFgZO/0ua14rjxhmLiA==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022122.outbound.protection.outlook.com [40.93.195.122])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 4h7jrxbeb6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:19:52 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Svs+eYk/vMhp5y3ZJVxZxyd+9nyQVOJJa8XvUe5wuyhH3nS1Fa0UoIgDclIm0NATpih+FuxEcO+XQpVUeRUQL4hJN5GcTk0gC6E1GTjKjW199+tlWuH/tTE8TYxzmX0u4M2t5Zp7TdLH3gqrzvPwOYIoC+grGoE9p83xULt1DQxwLWviInN1VA94BW9pXdVD+Ga99x/2Oj53EPRT0QRhvKMBFwTT2yJZKbiYZqtbGHWRjrxZIYlaxm2I4/c4E1auGH5dKScVAhejPu5i9mDkyuX/e9fWtti8hlXMiLZ1Ph5Be7Vgqn5xMKVgv9Ro1IyMokjezj0/JiYIvrFxZO/fKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Umj8pyXSU7vmzUdA7V4bgMz2R6N3mzwMianEbaofrP0=;
 b=lSqsUeh7V+O7j8L6MO5skt461+vNFC7ryIuB/8PIMbZYl/KTDwbpR3okEBYbtOvhRndYm/Eyq6BbRe/rU98rfvo7nYlrQCaGGSg/mDJksT8DKs9MkjemMSHgK9dT3PGG8ciTOoNnRBowZxF94SuY5KV1VWA2yrtHvOcdsKVeMzrrT185sLHGKgj2zto/ATv/k4ITGqE0e+fVPvAtOx4l6F4NchnkQye+3YTOMUUF8tqihhYYl6MaSqi6dsRiwMF0anpTaV+xbFq+LYg63OCk+0QtAJOb1yYgKNEUAaAF2ff881lL3D+9YH7hH31EMqPbMqDlAO7z/33m5aOqnCfk/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Umj8pyXSU7vmzUdA7V4bgMz2R6N3mzwMianEbaofrP0=;
 b=jT9hJ9EJKlel8FOtjchfrAR2Kqnx6O9lygVt83WJChyhJR4uEGkFhJfn58RkHqFcnjNH01bakYZcMPk3K19KNZelorYKUBM6ZS9sIUXT8AMhurLxPYz6TRgNwg4LDbwbLRQWJ7OFID2tIxXVU9CvvtzguQLUgS3fKrtoUv22xtc=
Received: from BL1P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::10)
 by PH7PR19MB7097.namprd19.prod.outlook.com (2603:10b6:510:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:19:46 +0000
Received: from BN2PEPF0000A993.namprd04.prod.outlook.com
 (2603:10b6:208:2c5:cafe::13) by BL1P221CA0023.outlook.office365.com
 (2603:10b6:208:2c5::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 09:19:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 BN2PEPF0000A993.mail.protection.outlook.com (10.167.248.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 09:19:44 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 8C43B406544;
	Tue, 13 Oct 2026 09:19:43 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 75C0F82024B;
	Tue, 13 Oct 2026 09:19:43 +0000 (UTC)
Message-ID: <226d0dc3-723d-4e2b-9ddd-1be75908c129@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:19:43 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] ASoC: wm_adsp: Give the firmware search order KUnit
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
 <20261013-kunit-param-names-v1-9-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-9-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A993:EE_|PH7PR19MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: cc48a525-a78d-43b6-f2a1-08df290b1efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|61400799027|36860700016|23010399003|4143699003|11063799006|921020|16102099003|56012099006|18002099003|22082099003|261009223027099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	1tyiZEuCMUTlMp+P3sjF3xqIvIq6sEJ8R1bJgWIBaBFrRTPk7r2Q5ixUpzWZvxsa/l19AafObn6BwQCElpBOYJ4m7u4X7K4j1fHdVKFS+Vqu795dTGIKg82EJaNjxgk79aceTbiZ18kD367FpvaBS48VscleXKyFjH592YacUjOJN+HbiA0w5nksz6VuFOFIHpMsFq6HZmKd9wmG+lvE7/PZPKsDPgagy7t7TKoKWJCYUEcukaJj4sDZHennxZA9GbhJYokjZTV5fApQ8OMtSXOA6ylIbpZRxBi8XQYzAiPGm8hTxoF9iFxKLgfdlCx/Q+/Do/QDjv6/tkfpwPOD9vFatnjKZ31T+ua+lc+jeuJxW1TzGUxlRRsTBAEp47MYEYdTCKi0ToWRIlzGv+VxUk/NQIBJnojEBTrZoQ5ewwH1nkoLUGTR2K1ETQexvvItaKH2lFbCYdson5pfsVnNNDGsK+sQBX1SWoqKd989AQME3eQdMu/GGQVgjs6sawqfTgmWgQ8If4wRC9CM9PigVmehzGzA5TbmFlrHoc1LnRbNRL8QFH+ZaNKxB8x76K+9xYEtB/o6NqQpj1xqGTc/kHNI5zL4wi4DrbJ4MSKysUeIfuKght2oDLs5Ukh6MLH98y97CIvuY1itRqqETvtmstSoLMa0osnxKNhMwOCnMgW/40g2vUDDja0NdEAIuMs7oe4FS3h+XFmruGIyx/WX0NE/STnUzxP+hjw9BiVtckith6J5UOK9O2hSZFNepBNq
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(61400799027)(36860700016)(23010399003)(4143699003)(11063799006)(921020)(16102099003)(56012099006)(18002099003)(22082099003)(261009223027099003)(3023799007)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nP9qz5PVUn+EHUiDHCHFBRzaKHwYcgT1DO9WNu8cjR5XUPASIyYlQT8qQuFDh72pqyV7iab8KMgW6V8ubjXCCToYdEL4vY33RhFpu1xvUEsm13yVeTbg1wxl9sALeHNEuqJV/z6bj+N9hdiL0L7T5ZeBvWXW2PpscKLxTtsgmgP4D9lue2sM1V1AUr0MaeaIupq4kqsRgpcxauO40O+yKZ7j0FIhrXATdz9CcCNo+ExVCFA7Zt2/RCnwr/bYDrEDNuv3WW4biqtLd8owCkZVeedKiGKLj4yNaqu9Qx7fYeUZvrml9cLdx074i0m2R2CShsMOJoMfbhoBJqbKCaaD6hDHCpvo4UkcqwvCEOtoSjDLCbj+vI1kEHnuErs1boew7NZkz+otOGV7O7O7bZFI9zarz9mqFUKKlyZR9A2+cih2jW5JV0ZmNqPhhqbKDVAy
X-Exchange-RoutingPolicyChecked:
	bENUIrKjDuFSkR8Ar1JG1mfHzgrCLWDIGTChUUZ+pg44Q/LYR4pzNEvwE+gZmIM9C75mpSlC56hDJJMc46GsDT6nTMIhqIgiFgVcfoxpt6RDnvcb0caWR5oAzKXxF0dLAo6JXP+B1wLmrLh4aMct7xMfCLenNp+NsYOoxNde8E5CrjBZ+KvPv6cIdyNPgrUobtfNF9EVk4EebeOtEEwj2bUzCg/Ew4I+Nekj/kp0VnHaKolDSliS6M1sVKm7GjE0nKy66cxu54sAKemBk35efvqqL+UMhP1jvmr6CUhlUmjEUuzsbdhn3HYKVvmuaW+PbCE1FnSyFCPXxGh8+VSFzw==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:19:44.9163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc48a525-a78d-43b6-f2a1-08df290b1efe
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN2PEPF0000A993.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR19MB7097
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6acdf7b8 cx=c_pps
 a=Gvitfrn81X/13pqoc+dbVQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=Dj2-6B8FqX4mGL0U3gbX:22
 a=w1d2syhTAAAA:8 a=Qfd6qFmGc774TwObTEkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DyI8Oi5GaSuaXRndVQY7GP2yKftGc2vP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfX0i0ogDqKpLfz
 J9zH9YFvK3+EIKfD3vgTbUO8+qoTFxZQ0tdsyRCyU1snXWVDiCZS/S9mE+g69vqIvWc0caKkCXK
 ZVOfScWcptLkpS7E7IVUh2CjG1BwKt8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfX6j4CLfaJda/e
 uA7ACjl1IsXcm1loc0TwMrdm77qoaEVadaMO2kGk65gF3XxUKylsQDEztLOdZ6Oa90jFrR8fYwv
 E+a48x4KJr7ZseHYnPvbY0SLAIS7j7fP3JMWjCe7E/lPBVrBVg5oZzzyUPGNFTRIelE7BK0fO4E
 fj01sTdJSVS1pmfciqA4n0kx2eVD22Et1uZkFD6H2js/qhvvsXE022+mJRvjzF/eEf+cc8RtD67
 AwK/JzEP5q7AlG60QqUj0T2OOmRbDSVfDiCpA48xBYvC5/w/gIinpndSRrzSRAQpntpAac4lKY6
 hun5xJPsTCXl6H5JxgX7AoOEfO/8IWJ+fQXEBGTy+DwE06PtTzULSNkuIouyHduBI+f85JX77IH
 gsxktB9FGD17Rft7FW+Tuc+vLs7xYMD097fQjxOdm601GalqrxvmaVfwv88tfcABuBwD8ecWjjo
 SuAXm34MbQ7TbotsEPw==
X-Proofpoint-ORIG-GUID: DyI8Oi5GaSuaXRndVQY7GP2yKftGc2vP
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> The wm-adsp-fw-find suite runs wm_adsp_fw_find_test_search_order()
> against six different sets of parameters by listing it six times with
> KUNIT_CASE_PARAM(), which names each case after the function. All six
> cases are therefore called wm_adsp_fw_find_test_search_order, which
> makes the results ambiguous.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> wm_adsp_fw_find_test_search_order-wm_adsp_fw_find_full_search_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

