Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C013E51E2;
	Tue, 13 Oct 2026 09:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885586; cv=fail; b=enxZPBVxQUJdtVHkUuovpdqfZTdQHqOPpH3tIdpE9DIt4eY2gu/yu2FzzojxAGR1Ll5ntyvNfzIKY9XbMGPKPEdCprAtItwpPC+9++B9C5L4COnxDpa+2s5gRms3aNCT+L9lz0CdjQYQj9bDyHYpG5gOMbAgBSzl85iUADKuwv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885586; c=relaxed/simple;
	bh=l5bSl4p4IPRADutAkvoTsSobBgELPl8d2fuX8USgj1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eM7TDkmAkX2zUr5m0aLM5VnIa5uKm+RlQf0UUY+PLY87FwgNFmKRbQRrJp/zQ3lOH8TcnB0mCZ84+Mqc1xYu1G0RDwzX6KPpRXG3KX+klYAOmsT98Z5GP8wzKOP6bzx3ww+ak6g+A+92wADnOiVTBcfgAtkaAPRK3hVxSCKbXJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=QRX/Mio/; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=J0q+YPeK; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="QRX/Mio/";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="J0q+YPeK"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D4tj3R3603603;
	Tue, 13 Oct 2026 04:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=wo/RArUMh+WMZY/dRnwJ5o4Ifo7Z4QCVIEpzk+OVQBI=; b=
	QRX/Mio/g+VY0m9aXiu4hsY0KcFeOe9BPhWk0LBOz70JBIF0IbJ9U63WVxh9r1aa
	/1FOVoutS67UhXFjn2UzpOdCQwi6GnexinXhLSTG6xVlixsxmHzcyhlUIgMRgmmp
	AiAPSVacRgX37M0estyA9EHBCL5MYyeRP3IFLJplyu5h116JQHpgn1j8s7sip4+c
	WhfVxTEFG3qNe+sSHLrFd29Bs98uQbx40xxfbwjhADWCLXpkgElert54HqERc54E
	pk9cpggN8ZVQqThzrqjYg19UxdKvs2d+1zInonCJ658q4yXciIAZCp/VpxLE1x9h
	IdNti6bCbRYNV7OVa/GJYg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020128.outbound.protection.outlook.com [52.101.193.128])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4h7hsg3j3v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:59:03 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ircL3P9FEjKBcd2pxmSknyvejtFyHRDVCn+D3TdgMvDXCPwOONxxaVdfXx27Ezn0wK34vGY5fmtOu5sjQ2/CBeX2yDyCQoskl7LyRB3TZN8A44/+yIKN8tflU90I+Pk5pENeg4SsOlP7AC3iT3SI9nnjBQVpHcYNmO+79vLNmnKC78BNaVBrFDG+jANUe1LrO6f1tfxYQ4zwMACOU2YoK2QvxJZis8g7vG5ZqRU1BqcTRtDsPq721rJMHN64KeUD8wKfDcM8w6iUCbg8Li3Ue8pH/17VW23rkzcvhMTexjy/ttNgpv36mrmonWxOc0yGPndzi0/wcuMXoRSBwiW0CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo/RArUMh+WMZY/dRnwJ5o4Ifo7Z4QCVIEpzk+OVQBI=;
 b=S7DDqcTJ2mmtM0xt37EVXr2vu2ZtBQVAtqeQZC+8iFj5yN4RNMQGrMvmS8kXDm0Ycvn9/MoDK769YP9OHDa8uLBAtw3/K7Y81apaw7XnSo/iL95QGbG84d+WVvVSOQ56RFyBdgDk41TDtI+0z8vqnqGdk2EFNXT21FjyB+nvuJZJPDWEzeapDVuOU9IUvm5K42dX9a7T+dQdK72PLWFp3/vGJgYkFRe6s3BpRrpzFyml2JNEReVYuOmykmLKdST6mgVdb3Kff+driSF/VwZgiVKr2OtZZ1HnhKODOkdBC7NhKjoBfK41zbFjrKU6Wh4NJSK9tMmz0Hw4JV9ts5rwUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo/RArUMh+WMZY/dRnwJ5o4Ifo7Z4QCVIEpzk+OVQBI=;
 b=J0q+YPeK4RZkVFTBSpK2wwy+mhbN6isoOVm7PsKPPkxm+J3NF1+Bo/Oo2sd36z7bBd1U2ZYOU6C/BgNBFh7kbTwxs1gQ/gfNPYJyECR4nQwR/v3yxkaD/suGQuauu5D/3rxNbd8ZfqMr/Qzso0cB9vv+Hc3lLQT4vJCGdMR3VZU=
Received: from BN9PR03CA0352.namprd03.prod.outlook.com (2603:10b6:408:f6::27)
 by DS7PR19MB6047.namprd19.prod.outlook.com (2603:10b6:8:82::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.23; Tue, 13 Oct 2026 09:58:58 +0000
Received: from MN7PEPF0000014A.namprd04.prod.outlook.com
 (2603:10b6:408:f6:cafe::2) by BN9PR03CA0352.outlook.office365.com
 (2603:10b6:408:f6::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Tue, 13
 Oct 2026 09:58:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 MN7PEPF0000014A.mail.protection.outlook.com (10.167.254.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 09:58:57 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id B6DD340654E;
	Tue, 13 Oct 2026 09:58:56 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id A885982026C;
	Tue, 13 Oct 2026 09:58:56 +0000 (UTC)
Message-ID: <46546338-afe3-4ac7-a694-de320fb0d407@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:58:56 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/9] firmware: cs_dsp: Give the wmfw block error KUnit
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
 <20261013-kunit-param-names-v1-6-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-6-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014A:EE_|DS7PR19MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fc53421-5fb7-4bb8-ae4b-08df29109942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|61400799027|7416014|376014|82310400026|10067099003|261009223027099003|921020|11063799006|4143699003|22082099003|18002099003|56012099006|16102099003;
X-Microsoft-Antispam-Message-Info:
	1H4lFyZz3WrZC9eOb7boN6T7Xh360PNM+otDJgWheYExxOoCySeFKCWlDq+u/wPrfVIntWyZSJRUqkG2nhhelJEwvz5MB4mxYJqxqtrr7xguUnoKHkKDfWkMnpIsxR5II2zVmKTNvArQcw2PFnR2nZ7P+BgYYN1GLHY4wNdj5lKOVVzMQcHob4tcJBMdqYz7OGrkrSK3TU1fY4btOpFWGAl+4Nm3glzJmTUZUdrnFxaaDeTLIE/i9/XtlOZiwlMwSOdmRQlb/gCNR0oFqaCodTHnVfc2tRYz2ZEmJF5gguOZ+aNFuue3aqEXeEIVXDgxDSkYQeQVU4YBVUykOS22YjiGPnljPHSm5hnUwSagpoIxffQPESSJtxgoYwkDuIaC87Gsh5OsxhcgwDfDzD0lZzne7xAtOUiMm7ReZQFgJ5RJw8XCUR3kAb/4qxECkx2UflcOizX5lSL6/MhnKUaN7nWisDrCrnCwL03VSdIHP/hVMSDISt5XoU5KjpuykkeVP7h9gQPPoZizmrOImyPKp0WrYtMuSgQugQFYc4PFqBFYWvJYEIJlbN5HiK0hWbB4jU/czDrM53WMvdjxrGV1IcI2tS8qRo/XZujFfyFeDjab//OnrFnj7KnmKb4Cbzb+seo97IuwxNNHfYepnT+t7VgMuyPiySv6XNj0N1MZ4Nu8A6nTGcKjvFYGD+V6smy93iHBZCoYEKCMRbIN73U+kTJIMEOBn8GJc26CHIM8D3FDGvXwVv4xagZPsWzy6EXL
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(61400799027)(7416014)(376014)(82310400026)(10067099003)(261009223027099003)(921020)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006)(16102099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	yiRn9M9In+PcsY95ZSugnGeHT3G8RkuxWA14USE0MtipohcsLC22eqt5eWcs4taCimyhgWEsSn+jr619sec+/WXLzGcOKPyOgi3Tj07G/9Af+2dFalyNCwSdAB39uzPyGgE6MdlrUCLsheh4mlQPcF1U5eE/59Urr71/UUv4y+akHQ5PLABZd+u2Uaz+O2ryPANCe0aBPL8nXvy387uqyuLeJuUWbjqCLF46RClQFiwAcqS8TBqNe8anVHkFSa9rkbr4renNYh7K0Fwn0I/tejON8JBSqB+/dz1jQxt9h1wpuPrE/fyh6TIlvJEJhTbx7n2o3rTF1J7U+DXeroVCIpeuzUUcCoBGtDFdZmbwntPCxPhak5bAd3WLBKCKWmX7EVCeyOtY8qgQZGui6M0f7/FDwz+ElZPfqTy8iMWDGDp5mJpe0syy+nanFVVfJewh
X-Exchange-RoutingPolicyChecked:
	qbjsI6Lsj3P2IS4o8bjb/3LcvkPyKtT14MvWRj3xL1tjswi5B0p+qizRYKeMM6cKZ+H/P9Rv8GOuFTxqPqjc43bFWx+L627cAR2hhBwv2L0WiHbCzK8fEqLV9U476XoRlSncjGaifsAQpDLLMLC174etr9XC+RnE0ujiu8zWZQnklATim0goaC5Zf5YnqQ1zKypR++vjn+xMYFqu39mTRV13b9yTdXaQNecLXXVsFpap1UIk+8FMR38JhwCCEy4cnu/N/ozGeS/a9vm1saseq7QJlAXyE+71H31GaTl1iDPsSFW5yXV1IvVUjhz+/pc3HvbUdSN1QWcblQ/YcOfirw==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:58:57.5329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc53421-5fb7-4bb8-ae4b-08df29109942
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-MN7PEPF0000014A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB6047
X-Proofpoint-ORIG-GUID: cp-QCUohol0DmaD0uOBYLtMjfcPnzWnu
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX0GiLDi2aBT/o
 zoYqhRmm8YIQB7ixiAce6yXpI5a+chTLAP+7ahxmDTMfpDU82Gdby2pVGwvCzdC1fuFQhnSWLCl
 nuuHmMtolm9iSp6scAtXcauXtp8nnFw=
X-Proofpoint-GUID: cp-QCUohol0DmaD0uOBYLtMjfcPnzWnu
X-Authority-Analysis: v=2.4 cv=QufLTlyd c=1 sm=1 tr=0 ts=6ace00e7 cx=c_pps
 a=b6gE1lhLBDvdjrMy7UbAIQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=w1d2syhTAAAA:8 a=omrlzGe4tN78mTyd88QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzOSBTYWx0ZWRfX9JxRe4DksRWM
 6OUcB6b8nn9qS2RbOEUihPqaclqnobc/DD99fOzPRmiOWzQVZIAxEKxcmaBEujrr5+vHmSQDx1H
 2E81v785yNtkQ+/gTRUwEDsIWah5xoE9dP/BaAv1zfFx45o9kL+yhO2CTVW09j3ZRe3xYS2DIJQ
 Um5IVfCQDi5mwr6HxFeV/eT/YdHN/RUDU5976gwZN0OcUlKwqxdkXnHLykxN3HbEdtoM1IE05LC
 DqOumXkZvmDOnUfLc2+5BuvmqncGvvwOYSi/RPA52WoG4sknWdP5Bp5pN6hBaQqpTCx3zdbdCoc
 5lHC23jwZW9AqUKca4fnbq3UeWbGmCFCz7JB58emQX3PE3lbxxYviWiAPzKY7PsJiDkndiDTy6P
 QBbzntNGbfQVbhzBCl39g1F2wZkF8baxlQ3m53uukFBOg5M7OhBSr2k+U4yPHHtsjQUlJfRUJGr
 TeRxDKB3mPoS6Jt6ceg==
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> The wmfw error suites run wmfw_too_short_for_block_header(),
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> both with valid and with invalid block types by listing each twice with
> KUNIT_CASE_PARAM(), which names the case after the function. The two
> cases for each function share a name, so they cannot be told apart in
> the results.
> 
> Use KUNIT_CASE_PARAM_UNIQUE() for these entries so that each case is
> also named for the parameter generator it is run with, for example
> wmfw_too_short_for_block_header-wmfw_invalid_block_types_gen_params.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

