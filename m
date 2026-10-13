Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F77E383C83;
	Tue, 13 Oct 2026 09:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885385; cv=fail; b=Ey1cayvToRhhsdKKhbR+CS83Sfo++7esrW4Gz0anVuDNdCRqls0mA8nuixVHvBJwqNmqTvDbXUf+rSh4QbpQFJ9MykvwMhmlsdCUjjf8DKPmMtwDzGDYoFEnwGXIwJOjrsaC3t5kwPDKTRyWl2kAjM5BXznPWHjxZUzCZURwafc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885385; c=relaxed/simple;
	bh=gEFyM5FCgVOpRZcqQx8jSv0l3tXeOSM4ZhCvlLqxH2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZa/JQHkKeX4V3bTrWQmangqORMZZCpiEK1TWtHu7pOXq0d4AisuEMUT03T+L0H/7+diuFnwGyalWPYddb/QUOXItP1tam8FypfC/S6fUuGFo2QldxiWDGGBdxMi3TtXEGiXtq39m2+hOiT4MU4PCCYJ+LGyFmpMWyxhUrtVemE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=l+InptRW; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=ZFZJBKCZ; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="l+InptRW";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="ZFZJBKCZ"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D4m4pO3590564;
	Tue, 13 Oct 2026 04:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=bygHCLtXDI14WP2FnFyAoAOobR9PB0fEsb9yr9fNOfE=; b=
	l+InptRW2wTvPwJBTMq1mFmezGIcpAZO9lUM09Iom9sy4SD6vMVpf0ALkdZHIyq9
	zYaMhBwAvD3hsoRnnHKcTrLNtRGcVgymSMq3Dmpl4buMa1VuxegS9x5WiKm7N+nZ
	0g0D7Ei66D2yoS+a2tCOBHE6N5H0qC4skxAvh1KlbZy2LnPhCHGqF5i8qmxaUnF+
	r8dNmG1qC94fQPTZd8on8Lzm0odW0DzRkC+7VfQDWub5uzM0Y/tIHpZDghsC46NO
	Lol0nlXZ5ckwgvoaEJTnLNncRR4JTV/ZY9osHvTSijOOez9/Q4Mt1TvVG1u7QYJl
	VBmJb9oRXasbZ2ytZ7ksRw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020103.outbound.protection.outlook.com [52.101.46.103])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4h7hsg3hyd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:55:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=daK0RbWcqtlK/cIKN1Sg8LPNW0uGlgn9FhUs2unm4eJGPeHBAMRQtJRvma43xeUAGCaSeEAjfd9Cji4OUtrJaa+f+RELi/qv9hE+zdTfLLVULwCzCkS6T/GX+kFHq43GeRmvO8idcJZsS1/1brDZp19XRDSa4itnM4sCG2tlW/xzMLFpVfSZNd07s1URSv2/jwPd+q1hHn+/ur9HfQl/elT2C2rEM3mWF/suMJwk6wLme9iMiL5VX29/YgKAV/Xo1ZFXl+feRp4PBYMoK2Q89coO3DbF+/7kNplLf6dc8iBpLOngeH5GujM/kPFLfBOk+c1cs6I+anXVSgfHICo1Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bygHCLtXDI14WP2FnFyAoAOobR9PB0fEsb9yr9fNOfE=;
 b=HO7w+hR700u8g0IiFkYDh2TKX9wItCRo9oxtg93XHe6VxoISu1nJPD5d4zBZPPP1f8cxY3HxnGF1aNAE84F+yP5koyxv97h/e3FhLS4gdoUoDOeqZu4qQx+eyhfz2mziV88cYVwaH/JycEtarshRWLCJaq4hbHikCInVUFHbniBW+QfCSIrP+2TW9APskYw0k5BAkfXdJmaoH4NujreUr39yuZMP6X9WdLMVx8VimvyCOTTyDMxiBjwg/T5XZEuP7hITlo+oqi1Lt8kKkbueLr8PZok5WnEQFRvt/ncGUleho0zYXcLPCO/mVI1YXi6UAf/5n/XF+d2UbxI4E3CAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bygHCLtXDI14WP2FnFyAoAOobR9PB0fEsb9yr9fNOfE=;
 b=ZFZJBKCZzDwGcqpt8RmALl6V92NnXkxBFzmWz0wf7a01MS1BSgAtsr3hkoSDHjiw783iB6Eu8uJPCbUSWiE7fAadbykf+KWkA6wzxBnQzQ9F/XsFf9RhL9YNn8x09zCzih4TmBptjH1lX9oj5NMoNR2z043Muynvoc7oE5nvt44=
Received: from CH5P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::15)
 by EAYPR19MB614695.namprd19.prod.outlook.com (2603:10b6:303:2dc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:55:41 +0000
Received: from BN2PEPF0000A803.namprd02.prod.outlook.com
 (2603:10b6:610:1ef:cafe::41) by CH5P220CA0014.outlook.office365.com
 (2603:10b6:610:1ef::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue,
 13 Oct 2026 09:55:41 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 BN2PEPF0000A803.mail.protection.outlook.com (10.167.245.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 09:55:40 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id A7850406544;
	Tue, 13 Oct 2026 09:55:39 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 885F382024B;
	Tue, 13 Oct 2026 09:55:39 +0000 (UTC)
Message-ID: <b2bdcc88-5689-470a-ae71-7907a3d6a750@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:55:39 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] firmware: cs_dsp: Give the control cache KUnit cases
 distinct names
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
 <20261013-kunit-param-names-v1-5-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-5-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A803:EE_|EAYPR19MB614695:EE_
X-MS-Office365-Filtering-Correlation-Id: d688b169-8975-4bc9-7907-08df291023df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|61400799027|82310400026|376014|7416014|10067099003|3023799007|261009223027099003|921020|11063799006|4143699003|22082099003|18002099003|56012099006|16102099003;
X-Microsoft-Antispam-Message-Info:
	bEa5wKBnkXQ4ah+Tqk56XpL18ObBTIsvgoo0zpi3S3LGC4bDXcxEg4lUq7NvQ2BylxPRA5WzCWiHiz+M/Z9X/dUO/xXjOG0a6w86t1HMwByl2JJ+0o5pQtpyZtyPr1O3bMMGGWQbwdXEtQUPeMG9pXV+MtRS2VrBzvS30FlzeAZQ3d4GPaGAo3+FLQ8D2N9Bhv9klK1LyH1pI8Tb+in26Q6UAH5DXVYaJTHQiRBfW4KOZDeLuO/a3F5zdTYi37WspgHH6+RHwdyNjzUx/zImf5Vj09/+6S8CI0HEqdA+Yo6ARtVkEEddoSge5zxw+BkE+UbfITprLgTQNy35n9lNoDcOjOeu2NjtK41230/Lxuv7ZX1J9z3QihE+55US0R+TZRCBKvIFRQcU1yGPbQBcM6Ym0Wo/l15ELAKEFaXW3217ARYubp/cOlgVI0xzlBKvq2HaD1qRWFQ9iQKIRVrpS+WdoVWjN66bUJzN1/s/S1tX9r3c5rZyi6E4zwMrVLDvovtkFD2fJU9d2wDhFEG2eayVbc7QdmFO6gtwPtR9tKk2xxhSg+Fqd1n/bkXedM79r7guWmAP9ZuP5RC4acZ8rOtHQyu3PIJs0kIBEhA9edJHy2SgX08zIajBE1j19yztxYvDohuLAye3EPCBIQ8LIiM7ehtqQ603nDOHZvNEeh+gyM7XTGPweTmJLcOE4ZjoBwjwGqQleGqq7+gd6hefz7LuHYjG0OK034jA12spxptwN/cUZ+IQ8Ci2cOx0qIDO
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(61400799027)(82310400026)(376014)(7416014)(10067099003)(3023799007)(261009223027099003)(921020)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006)(16102099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9H76IMLdI1+9kA5HUez44+rg3GFCBiT3K0Ag8l90R4g46mqiNBqMflMwsm8waIworT52niKDFgOyMOVXqdHJsqYi2huVqicjNzCvTQaynktB2y2pPWZWism6yfJYE+XxULyg3zM7o8NSy5Yp/a5WRXYbyAL7DCgjBqkYsK/bPEzAB6YmUa6baAsOgUwOK8a8+LC8TALvaF8lYNkmhn9qqKZYmzXzsPXTZhPcsmdbVhBhllcxDA+tWP/OjxuXgikRFZakDD3XaXRLUBgjuwDBHhms80hgWJbpHutPw0utTS/PR4wB2MQ8IrB/PA6CyySXC7fyinU7MLyvoT8/TBYX1w6qUAuaN/0nH5/sEeXG1rIyGA43wm5naAPUOHRPumVwPG+C4pQPEsHOgtWvLFR9TFOmGJ+5Bw6Hi+GIswIFz6Neth6N0gSMbG2dRo4C6epZ
X-Exchange-RoutingPolicyChecked:
	4+UdzpezdK6jIQII+d+MC5ejWC7k+z7htyWKR/et1fXjnNtAKapDqwAaHaLolTJmXUY+Nu/BBxwivVXo4jBhd6ZjsnAatW4hnhg+LRaNUTp7vrOgQCj8jG/8R/jbiNGM8D4+36fg6dZlT0/U7grFxYeTF1EM7dlpqreHonq55q6a8sunofWULQBOmKr2Ttr6ogQ+9LAQdqnp7Q+G9tDFP3SYMC900sLARV3KanIDwL8RZuTROjq7eG57DRfHXgEhyeB/5aGtivKcUrHj7lEJYS4jQQdPQXXslDBsVizhI7MsAh2w6wDAwMA/D9oHMDYhSs6W76CsdHko22pZv/dwVQ==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:55:40.5826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d688b169-8975-4bc9-7907-08df291023df
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN2PEPF0000A803.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EAYPR19MB614695
X-Proofpoint-ORIG-GUID: vYxmn76MBQ06_3J_WsEymzqaQkKTtCPt
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX9wjRA4kKeqKo
 zZaSLK4lXdcZc/rIgLQXNA8rrODLYKfvD1Z+4IJfgWPIJXS7uoWEeNWDyRTA2h9p6iGWvkrM3zI
 KiHbFE2+ohPdGuaVKhIbZ+Y89iL8NY4=
X-Proofpoint-GUID: vYxmn76MBQ06_3J_WsEymzqaQkKTtCPt
X-Authority-Analysis: v=2.4 cv=QufLTlyd c=1 sm=1 tr=0 ts=6ace0021 cx=c_pps
 a=85R27yqqIDOPhBwKPsrjTg==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=w1d2syhTAAAA:8 a=Hlguj6pl-HWLELH-vwcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX4v5qs9/hIgJx
 n5oDLR7OEDoFA7YI8lYtnebZ/bFwnTxd7EanewojvxZqHfZl8CLeu9NhzZPksuZ0Rg5Ftzlhnb/
 KDfIU0+fVWKMe5FpQ8oLMtdNWZbp+rOtM3xhcUsXaW/TaEo5apv0bl80jNn+0/4m3uCkOtiCzXI
 i/lp06zHA45I8xw1YjVSzM33hFAPuH3YNgE3rMPzUDLRVx2Bspted1AJ3BXCv0DEGxP15ATPXaa
 lL2k3T3+qHfizpm+1DA6ONscQEcu94VrFR2+BqvvCHZkwefSAiNYWO7OE0MRIsUtrJNxAfyy66T
 loNfjhhiQh4sOYa85OYjEaFhfVdnGVZiB6sQQ1zOXRRnjQITRd6BT3+O0MVHybDcE9LF+SRjr11
 m+yfJvGqzFkXwuWvPgyfU0RE4Vk3j+8u5Zvzrlzufb6gBFqmVaE3Xq93+54swxKXz6YQMjjcIgn
 hWZM1VXAAbiyypC1wkw==
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> The cs_dsp_ctl_cache suites run cs_dsp_ctl_cache_init(),
> cs_dsp_ctl_cache_writethrough() and
> cs_dsp_ctl_cache_writethrough_unchanged() against several sets of
> parameters by listing each function several times with
> KUNIT_CASE_PARAM(), which names the case after the function. The
> resulting cases all share a name, so they cannot be told apart in the
> results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> cs_dsp_ctl_cache_init-all_pop_varying_len_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

