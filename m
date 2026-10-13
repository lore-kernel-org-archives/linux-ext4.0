Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F93DDAFC;
	Tue, 13 Oct 2026 09:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885130; cv=fail; b=XG4FgGbTLIXf9ZdAX8962QVAecamvqLs9d6nYpHU/qBplku/RAq+YSeQaqmz1QeW2M1WtLREBebFLv4cUjLQu3eeELS1zevixwyzq7sqCHhTIMqOXXe9ddStyJnE4xpfL01HKm5oFTP61/6qoa00hHv1iMutu9c7YeHBiS+Y/U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885130; c=relaxed/simple;
	bh=s2NvVkAlU+ftdhQfqrGC01APvDwtq+WT+lXJA36ncfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KqDVHctGJ7fzBHSzEcJTZs+rlXD83eEoCAFt9xlL152KbbfNGPPcPpH9aHGudVhwZZq/18zKhyCveaKSQigbyosozsc0g5h7k4h+JxLNkyFLctcHgs0ocZDpBiB2CXM+QsMIbBVtpBvWVKETi+yz3Yb65j9fndvndBGnAvXSiLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=IHreM91Y; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=tgNC00O+; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="IHreM91Y";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="tgNC00O+"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D4Zf4q3569598;
	Tue, 13 Oct 2026 04:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=lkDgt7YMdw49acpwRQ4vtzshostP11fZmBfA4sLPhrY=; b=
	IHreM91YppWKaD1q44jmH2xFNwKue/BtAfI7205tN9K/hrlyArprelT/dJeFfsxj
	mvlL8qHS6wQcz+Ng1iJ6kpuVZx8+FPVw2oyPf4RZ2IYWYKof/1CqbsY0BvvqXgHd
	thxn4tj5di56L05kcLBHL5F0QL0q8FbaILdHPLQrDwYIT3SsNbdwC1bQnSzgojpA
	1bFy5vs4i530msjtWRL4Y7XTmw50GiE/sfYW4vlOeafCwQx4nogJSYuvxcANKuYZ
	dsp21/m/Lqq6DRxkXuMbxKH00BRRPytQny7igN7t76AGXaDUn8joZF6B/lBzXAsE
	0VKQNBRhK2+V0J8aF7AztA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023134.outbound.protection.outlook.com [40.93.201.134])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4h7hsg3htu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:51:23 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jKo9XxBeCtuP42onjlyNiXW8QY8UPYXc6YSIpVg1Hd3+lubk2ihV9YFy/l4a+CeCU20GpqTbR0oDYgSD7Wq1YgD79AziICsPSJdHIBep9L0eXxdAN7p99cViCwMJq/un/syzGpptw4gcQ3/QMmUhoZYpH8N15MbzsHJzbVrEbgSueIL6kASXjzjTd65wS9KQEIUjXc/N1QAyDcvzvqbfyb2wAh3Q4OrjsT7j2Y/E8INmp0hYbG6E/6ECAdUHg3TdsWhrVHOrgExQjmtTFYTYY2h96BsCqWGwhHsqsu9qRb58F3vwq4Ub1uzbaNeQE6gJyW+LzK5mTEvAOG6tBKCbQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkDgt7YMdw49acpwRQ4vtzshostP11fZmBfA4sLPhrY=;
 b=qw739X4we1K5GH+pyr5EKoX+UFmZQEEJ9XAbNBppNlOFgEAdkIudBAt5uqPrVyFjpQa+GN0ECBfpJzjcpMJGYKP2YqFwlDUG8xrm4olghcKSChYJhB68lGMDGC/baKoM9O0tPEapEx6WpVXtee1FsLczJs2BOi5LyfGCiXJXDCaykyfNLjtyyXzaCB4XjNAyLvX6lMGDZXqOO3IBveUFhyVIzAvKXvShRJNII2CX4axoDVMEgsMOZ06+tqpZIil9ye7AlDWjyhiam1AEN6ObptWRzQwfLJaTKgEAkfiSO8y89AZ9wrh+rHrH0+jfu0HKpEmt7PBfgikNqxSpp39fKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkDgt7YMdw49acpwRQ4vtzshostP11fZmBfA4sLPhrY=;
 b=tgNC00O+QtJ9KRVh/j6AZyNwEKbaE34lecEPsqeguW7bp43Clpcbl35KTAAVW62EmqNMC6MqofTrDTx8ZST0uyJko07XoZ5PIYQ8DWmjP/NPX9EXeuysS9BhJEdE//3AJI0J0id/Ltwi9dGPKI1tfCGj83Wq+G0z/iLK15EsC1A=
Received: from CH5P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::7)
 by DS4PPFD3DCE27BC.namprd19.prod.outlook.com (2603:10b6:f:fc00::a55) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 09:51:21 +0000
Received: from BL6PEPF00022570.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::2b) by CH5P222CA0012.outlook.office365.com
 (2603:10b6:610:1ee::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Tue,
 13 Oct 2026 09:51:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 BL6PEPF00022570.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 09:51:19 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 97EC840654B;
	Tue, 13 Oct 2026 09:51:18 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 8C5B982024B;
	Tue, 13 Oct 2026 09:51:18 +0000 (UTC)
Message-ID: <2435eb6a-d8ad-40b0-9b9b-73031f3d8e9b@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:51:18 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] ASoC: cs35l56: Give the speaker ID pad config KUnit
 cases distinct names
To: Mark Brown <broonie@kernel.org>,
        Simon Trimmer <simont@opensource.cirrus.com>,
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
 <20261013-kunit-param-names-v1-8-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-8-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022570:EE_|DS4PPFD3DCE27BC:EE_
X-MS-Office365-Filtering-Correlation-Id: ab833df7-0fd8-4c5c-9f0e-08df290f8871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700016|61400799027|23010399003|16102099003|18002099003|22082099003|10067099003|921020|4143699003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	TT45/RNVJm1WEjpKBwBn19slt68yqqFstMU4i/jw8duNsuN5eU+I+25oar12IRCeMH0vlXr46IZdf5MZa7IrJq8bgOmEvKbwU9dHEQ+vTjBs8g99QSa6tbOzZUuZUTe2kqlNqodS+kF6/L304bgWFj0GNjLWdg/MdX5SmIMjGDY5z2x+wTh5TMOD2TjXD0JUjJObRR0COBWj+yGDSI1gdM1HzShZH1ERTyjLggBSk4KAf0vwqL0/Dev1SjxWm7VAT3FT4vynv3AhyutH4BkiJGhfP1k59hzDV8CedqWucS+zmQGdvhJpjOgYGv7Em3/Uv0gNC9RyoKsVnCCbpxEBzjrWCPZTTzCzy+WnwO6ariW8Dcnor2jhl4oP+jF1BRhgRPJV8ZjcGQCr/i6pwEf6t2aLk4lm5CFpMsMU+BKQfUSH3qBNVlYWeLAfIjjxk7yhgGE1JYKSsyqorS/4neKkZ31yn/meNajxmyEvPiQ0o5b9xHovCn0l+oxSVBHIGJ2n1Q7u4nt+hbtiKqE34+wRvMcoKhjX5il1EORxrE71GoTitcPtYzeLMQxDmP/divWgvRh2WxSg0AhnB4aTissX4RXhtIqeVDEb3XF9CwcyhYErmG5GWGl0TJrCglQ/RIMYJf1Gyr5gRBnoz2PGbK/yNzrUbkFMWLzfLSG7bgatR0CdLKxMT9nXETHMuxBlJJqbBzueMS8f+uyWz2oweJCZx7h/JmL35ecxMdL7B5mhK1HR8vFv/EuXDrLmGVCR6TiI
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700016)(61400799027)(23010399003)(16102099003)(18002099003)(22082099003)(10067099003)(921020)(4143699003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2hfokiQj5FIcHqCx2tnjQiS0MDPtKVQIwq+/YNn3cJ29JFgKM3DZQjcqS3FOQFSHgKigEnfnFzgW/STuVbOeSbbHRGtoXyoVfyZRDWL1dbn67poYvn16MgSKYsQn3MV6VTo9D75T3rAlvV62u57M6Tqx28htwrZUmuZErq8J5qrYpO59P2WXIpfqCPoDm2I2tbihASJJAJpYXiExhQO7YZ6GLIqKr8fVgyQOoLMaCZmmPKv+J6gLr6RLqwmU0Rd3FP6ZJGrSZwcaywZhb/XVA1VfU6Ukh0RGw9ureQIeSxHKWCUsZJbZnPuu7aQKkZCfypWU8NjoR9VGRQrUX1+8dUTLCZEI3oqQ056Ns1mUUJb/socenqwR0cBiBXzzFjBxinV4ZIUTw5Z2eWOUIRHTEcnox4XzuzZ5aFX31rekGTcD0kc6Z7hbFsD3FNrS2fbn
X-Exchange-RoutingPolicyChecked:
	W+cD1EpFKPG4k6RQuwxdd29GNViYNaM3SOc3h5SDrwA5oCBGpPiofGl00EdaWkcjX9PN0bj58B+NQ/5APqLXlRjfF/Exfcpu7D1nz9bxvd2tzxxappploWo/QHLOpSXjccO4Afao+fkB2NexNnx7d/Y/Ji40L0DF5zjspQnQK3v5XvPI1+1/GiO0DQblOdn/j+b0zAswHzABsDwjNkeG7WK3tOJgJ8nodDLb4ajGGO1qqdtElw4ZSRQGrorAqODmhLG2ZEb1svH95AhjqERdAoGT6eDBSaoERUX3enBkocTXRwZi3xdlJ880LxR91HQuy5D9W9tkzZnKsFJKsZAGQg==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:51:19.8239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab833df7-0fd8-4c5c-9f0e-08df290f8871
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BL6PEPF00022570.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFD3DCE27BC
X-Proofpoint-ORIG-GUID: UDJ2TXmjkqNjf25kCW12CA8VAcHoltwo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX22noxbythUxt
 yC4o8TxTY2wCbLlYav0Ntn38yy6FF8lU7nBJ2bbGLi1w/TxqLoMGr2sRoX8gMogdsI5Bu5677qO
 zzmqq5XHTmUuerwGGgl28S73A2aDXwE=
X-Proofpoint-GUID: UDJ2TXmjkqNjf25kCW12CA8VAcHoltwo
X-Authority-Analysis: v=2.4 cv=QufLTlyd c=1 sm=1 tr=0 ts=6acdff1c cx=c_pps
 a=kguG1nR2ma0GTtLk2h9wKQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=w1d2syhTAAAA:8 a=au7EB9kSenf8LDJMA4QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOCBTYWx0ZWRfX5TA98idfXZzj
 5NfziwWkENN+qZ7I2ltdPNyfGzdqH/3qsrljw1BHvxG/VA/jckdSGHt0EWgywkvZn0y5c7ArI8a
 DvHDmZomrrXuQ7gqJJiwjercTJk5u9roGGa2Rk8Mr9YVKoxuPUzrmqunD0uxNEfNkHGxTH41I5f
 VC0dNeg9TnVp4lwu5Rt5uOsRGMzRLwSkd6DIb9luPsfSEp8s8KMc3rNU4MQVtw3aOphV3gxtOf8
 mhX51LRkD0ba4QueGVUjsgyJTa1p+gyf+QmQJ95nfysxSF7yioPJq+BiVAf4soAon2iDY8favAE
 ONGYFo9KlMs8koFN5KaiMiZ8IBYIFOg7Jx8kBv/D+WdQHUTyVwIpi6HSTq0fkPh4n1u8Fk2reiu
 z6CPgMKEGAkPCgV33G+MhNuDpyJuX408JpOjPihi+CL2OXn7U2UMjsk+FRl+4FLcDqS+lg7FVvH
 4aX7DQi3zHfQFneL4nA==
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark Brown wrote:
> The cs35l56 shared test suites run
> cs35l56_shared_test_onchip_speaker_id_pad_config() both with and
> without pulls configured on the speaker ID pins by listing it twice
> with KUNIT_CASE_PARAM(), which names the case after the function. Both
> cases share a name, so they cannot be told apart in the results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, giving
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_gen_params
> and
> cs35l56_shared_test_onchip_speaker_id_pad_config-cs35l56_shared_test_onchip_spkid_pull_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

