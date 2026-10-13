Received: from mx0b-001ae601.pphosted.com (mx0b-001ae601.pphosted.com [67.231.152.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EBE36E466;
	Tue, 13 Oct 2026 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.152.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886304; cv=fail; b=ShPnTGGSXaskIW8NmaWWI4UfXS5y4FKW0bzfREr/WOzpssTEnAYgkY4Epn+mAr6+SjFHJRuwh6EAliLZqEjxjYHb1UXzFR5oSJzrYu0efMj7Ut0NxKzgFEPAvBR+HygtgDWX7bnWtNk5BonMf31HSawvziiJk+NHkpbkQ+M/3v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886304; c=relaxed/simple;
	bh=7zRWJrCRF42qf8hGVJsHYaGXtl9pDqsx7rdcdwoTnOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEH6YVUNXK/hr+UGeu7FEc3Tgb6Tctkzb1N2oUOZdle4bvvvL3HFIxiGXF7JngfaAPeDpuwxQx1pg8CNwOy6ruIItNNEAqecHQrGaxW+SSj1cP6n/X+ZQ1zCKROZ9dG61gvthCFcVjXPFEJoh0evuskuVcU+/1fazCwv3PnW/hc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=GJA0Om6m; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=PxIhpsG3; arc=fail smtp.client-ip=67.231.152.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="GJA0Om6m";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="PxIhpsG3"
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
	by mx0b-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D4Zf6g3569598;
	Tue, 13 Oct 2026 05:11:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=hr4nmZSnweoxpPdVdy8uq1WcAQG0VQ+tpJsxGt163fA=; b=
	GJA0Om6mwV/rv3d0loy7KZk0vNedgz2VFaO7UzbrkLA2n8OZw+OrwPLtIE/oKp8U
	pKusEKpv0EWWvoRO+VJ97JbcrZHsuxOd2SZcCTLhLp2LY+cN71gcHXCMbMkwz4Ha
	Agc+4/DkK4vSFFUglmys06YXb+kf0JGuKfwoYULpvdUJs2RUXxw0aCox62mAM/TO
	+IdQ9tVtMFfnS2cTkhs1eZPKQ5l5i9ClJtE0iW+5n2AePDyB5h4SA12ZnN0l9snW
	HW4bkcL1VpJMzafF9Bv3UncObm38fwFjJYzSM5iirPTypS9bJlf1Q5klMeNodocf
	xkMY5Y+oPEhDZF+v62D9Jw==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021095.outbound.protection.outlook.com [52.101.62.95])
	by mx0b-001ae601.pphosted.com (PPS) with ESMTPS id 4h7hsg3jrr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 05:11:07 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5wP1IcVWgrOs6fx0dqRpd5WN5v5V8fpgRI4DD6gMuVp925sFgjYEW+4UYw5Sx1JXlAF688iy/G5CK7ZRtnC3yaqPjNNG7rV37ovgCBg1eMoxOAvtgba9HkBCc1S85xokx7ZsMJE2tkyiCLgzdegIdKSEE3B8l+YV/K8wgGobj1WZsCll5D7HfkBM6KTkhjEbkckPTF/nCZz/2MP61KDiEalQ9hgRTNK0ILsPDzRbRE9C2OFAGXDrv0xXKAVrDfqXVCzJnsmnBn1L3fjYj+j2YGGGX7NH0kec4siDhfQKyst1HQ21DZxQTezmqdlqYI1PDKeAP745WgL1oMPLhTBcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hr4nmZSnweoxpPdVdy8uq1WcAQG0VQ+tpJsxGt163fA=;
 b=xZCJQ+gJv6aZGbF+cw3wPdvrJ2mRG02rEokpCktovsamrkvi4jj0cBCgVlX8S9eAx2GGO146lD6RqEz5gSov35orTKxVwtXz+WcXoFmAFHYqgZvbx8fREyIui6NBAmbfTju9Zz24L2xRYv+KiidudNjdqVkhy4cztuAbXy7dqWqSot1EtWKaRmbaZcbguczfLCOt2tDag0kGLuPlax2A+cm+KZ7V68/J+BvJuch8ccERgUYbM2mS7DtEUuU8b3TvFcpWyTsKhpOrzwRjo3Ps8e4L6zkYGy5ZqEdpWhTAiFn+a2DDcxacQhcvaLz80FstES47EpTL+l9RMy6dEhBADg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hr4nmZSnweoxpPdVdy8uq1WcAQG0VQ+tpJsxGt163fA=;
 b=PxIhpsG3nbNF3WRZO3GSdY+FXWTKZHisc0JNfoVAUF5yaHptH79PQHUFI8vyFyCGIWoZa/ZC5R/gIUIwlbmC6PSYZzjXVsmPZzInj41Sqq5NPAiZnqgb+m9JoV2YhBCWiXzoMQWEyNvkcOfhr4xPO9b1KtIpvWPt51mDLsKnUrA=
Received: from CH2PR14CA0047.namprd14.prod.outlook.com (2603:10b6:610:56::27)
 by LV0PR19MB9613.namprd19.prod.outlook.com (2603:10b6:408:31f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Tue, 13 Oct
 2026 10:10:33 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::51) by CH2PR14CA0047.outlook.office365.com
 (2603:10b6:610:56::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 13
 Oct 2026 10:10:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 10:10:32 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 733E8406544;
	Tue, 13 Oct 2026 10:10:31 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 599BE82024B;
	Tue, 13 Oct 2026 10:10:31 +0000 (UTC)
Message-ID: <8c7ccf3e-9d0b-4e05-9aa2-1a14e0946226@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 11:10:31 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] firmware: cs_dsp: Give the bin file KUnit cases
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
 <20261013-kunit-param-names-v1-7-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-7-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|LV0PR19MB9613:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b22658a-8bf9-4b52-2f84-08df291237bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|61400799027|7416014|82310400026|23010399003|921020|11063799006|56012099006|4143699003|10067099003|16102099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	BjefqVozCpyHgBakfW4fpBZX36oggcy3l0K/hTkMY00PISzftUef/hn26SNI3wft4BQjPQ1oPwiE3SKqCxMtv3jj0FFBFSb0Yccb4vFPKCCPHAuHXNsln4QUqONSKZCEKVurcIi+vheuow7jVLFiCDvnZOeXBoVFJazRcyNMUTKZY4XHmaA72WHAiU0TrTg5LBqET+hMxjGHK4dNpvEjA47PF7ufXTBBfZEtKIm/JRbhhhD0/rndrg1/2qPMULgbiy0w1f0PdlqOxgKrH535dnDzS0dTc94UmQc3oZiX7yPLzcmVVLOyOuroca9nBo0FnphJ9kQEUaF9Je5oEDY1IUjlAQgsgTkEModScKb//YtZ55fCtEUcSzH8qeLxAq8TqWvQSCirxAUG1HDPipBczSS2qYw43nvG1Cs5ubm+sAjfI3zCs2LenWcEVezYuaOyDM2l+fquVmf8tOqXdOINVeHOvcLVZTTH9r+2Eg5sYaYu5g2l0KIWpqjtfG1Z8O+J9lCJGMUX2w/9Iaut91a6gVrCZPc5pMgM8XUEpM5i+fwRQP/tHWoydC/KWeDC8x2TfXtvoGDPIkPgmy1ApIn0GeE4WdYDwLMJCZccEvu6ZI2XZOpGF7OFhcDldkL9/bbLfvVNbeZghvmRAUKnuoFVCT5lze6PTVmMZYRc7uD0EuomdbXWknB/yroy3lA/gGKyA1jJdKBElw7ikPdPoTmKMNZFUl9vA22edZhJnL8GePFzzyFHvr56RzZJIKuYzSbv
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(61400799027)(7416014)(82310400026)(23010399003)(921020)(11063799006)(56012099006)(4143699003)(10067099003)(16102099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	b98JAwAze4YlK5DJL77pI/RwKaT+4pQ2xs3IgTZ5iKYQehrBRIb3XNVXy5b0rzvgFHGQws1GWr0csmaXUTvxeTToM3R0zwsIkUNoe6dii4hKqWREB19cZ8INMHmPWMibG7cZT/2Nu03N2FFvApyFlXc1gn/dvUxi/Nuv/cvdw4Tiy4+Qs9JnApKmSlSOoDhFBntdVQKUquISpv+lqz0k/WU+xK/jUVnXNLvS09PvNY5AbzncDg7ceSluFRIF6LlZ1jH3Wcqpm6HfG93kaNhlwqPJ+iPQAlF0bbLzbGgEGdfQ1LtuPSvswaiyD3+K2XasJy4sNaisBj1mw9aDknHUqrGox8MSaBlXVRSuXftkaRM7NJx78wGmJrPR/FSA4SgSUJPipPossni2gvHkzjspvcIxBTK8s9PwVJaYztV96TFMR7IohAJU6aMMZATL+Uy6
X-Exchange-RoutingPolicyChecked:
	5l8o6V6dhUdh1J+TTQ5INo1Cosg6c0ktkUjJ3ffD19p7sSRl/3iW3Wc6CXPsqoFimGXzZerRWQzgdbSJf7L//fSyGqqCvQto1rcnGqvcINohJ4EKuJ5kQ+GtZgxTlRX+77enTdfswUwSWlHPlkdnTiJmmdOzydXnechMv4l9la/Y5Odun/VBuukVSEIu2bYUDUTazjLZdqT8TvfAXQrIWmYqcK/+Hev+rov6ELNkG6nQJO5IBgIRNuhtCJqtzl+oiy3s8Tgz55Cd2yd8KkdQRWip+TY8rtE12/73Fx4vvLNg+hrTFohOVceDmvPFKRdLB6ATCzPZCHtt9mSS1od0fg==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 10:10:32.9040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b22658a-8bf9-4b52-2f84-08df291237bf
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR19MB9613
X-Proofpoint-ORIG-GUID: FFbGdePp6uCI6TjpIvn_BPf8khpv2IZ5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA0MCBTYWx0ZWRfX22Jj1KbxgTFi
 aWpO8l+uWi7uht9GnYATlKnyIr4kav/GaUe+J71PXwtruWmqPg8/3CohhDlKwsJ4xXyYZM+gR3U
 zRUEu7VYGH1uz6LnwA9rM5+zCRMDW9A=
X-Proofpoint-GUID: FFbGdePp6uCI6TjpIvn_BPf8khpv2IZ5
X-Authority-Analysis: v=2.4 cv=QufLTlyd c=1 sm=1 tr=0 ts=6ace03bb cx=c_pps
 a=XQ5R8ZYH27Ke1DXIRfoPQQ==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=KfkQE9S9VqCBgivYGm0O:22
 a=w1d2syhTAAAA:8 a=930lm7FSOLyZY908DsgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA0MCBTYWx0ZWRfX0J6IvGqfcPLK
 R7fVIHCM/ScndafZIsM8w4ZnoeCVZOs73vIs0vNI4fP3SmfZ+HIhnmgna4ikX172uKiUsFNJ/SI
 h0ad6Bs9ySPurQWS/D086325csQQSWS4FhB91b0SV2k3Vt3NYS/f34fTKDx3oZLb3JG0Qtb6ztg
 0ObW533krL5/RHS//7gRIhSEhl9zIeFetjpIZ/hpOfyv4DWEMTZNQXflo9K/0slZhzRuLgK40VH
 P1cHV0V9P8RVJfkq48YxW83QSR5wNi3mcARdlzaLrd2pNjLYmm4phuaQ8okW2EPaMwbST5ffv3K
 p8mPqYeKvDt7EMcxcjrdFCTlsisaS4/z+u3y7fkHhvYxoxZcealhjWy8p9O24p8h/9nO34IQOzF
 0QRatv9NszO74ecWf9wbKDfC2jCH0s2dSEm8u0WM6HNYSKquO0L3WTKuYNX4ddQxzp/ANHAZQ3R
 hLp3YE7QH7sorXaRSmQ==
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> The cs_dsp_bin suites run many of their test functions against more
> than one set of parameters, listing the function once per set with
> KUNIT_CASE_PARAM(), which names the case after the function:
> 
>   - the ADSP2 suites run the XM/YM tests again for ZM,
>   - the WMDR v3 suite runs the whole set again with long offset blocks,
>   - the multiple memory tests are run varying the offset and the
>     algorithm.
> 
> The resulting cases share a name, so they cannot be told apart in the
> results.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

