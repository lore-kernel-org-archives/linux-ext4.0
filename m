Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D198E3E9580;
	Tue, 13 Oct 2026 09:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.149.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791883098; cv=fail; b=nSaaVjHO2vi0vAJ7NRtphbEFXBwGpj7wyRVThqldmyJaA00S3xP1oN4KayfIsh4o9Ob03dr8UVpaSCIzepRQLuJn3WDA7EbVR8a5f1Dfzw+8E50k97CS67JsJlJriIcG9qR2RWjzGFs4kdvXmyJRM2ZvLsOm5CpKx7rZmPQYXuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791883098; c=relaxed/simple;
	bh=9X8Tq3FFPOXQmNrAVRlBOl9oCQhChzVtC+iQOVV66I0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JN7PZwVv2O+zwoEhOJZmSHcZfzSzQVXfHbb4n9cn5SzZgjE3T6EjedSVwFZVAGIv2eCjijlvYbAaLcNo23feuNzy9ANVXLa465zT9RMLRrrDM+3key7ztDEYvnKj9H7tjWNPA1uTQ4oiDKDKtOjA4NtIiCYadH7y5FLEvfy3ras=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com; spf=pass smtp.mailfrom=opensource.cirrus.com; dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b=VwZMnoOo; dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b=FkKDJt7Y; arc=fail smtp.client-ip=67.231.149.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="VwZMnoOo";
	dkim=pass (1024-bit key) header.d=cirrus4.onmicrosoft.com header.i=@cirrus4.onmicrosoft.com header.b="FkKDJt7Y"
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D7sIO32049197;
	Tue, 13 Oct 2026 04:17:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	PODMain02222019; bh=bYybdxALArWsMznilok5p85HZqXcPsJGhbTg/oNSCvA=; b=
	VwZMnoOorAyDOMpGUIRyFSp4/Kc0dg61bV35YxsvogDDTkTlbhYvuIsLmcPvpCJO
	MDmVAhXZedxKt1DM/hMSFZg+kPhSkfTL40V+oxFMmXV0UzYgRbSwoHYnV5Hw3Y/C
	1KjjnmT5uy3CZMnymVmpSz3+WJdJRVZYk1ZU+QlKYF4cc+wQUxCjjJeG+SaGERYH
	x9BGPCnqgBStBtReIuKBBNnhQh5YQN3ySoqLGWdWBG29DdrziFWSDq2UTArI2tOZ
	qPzTvQuYNlCpI5gWCss4qMMxY+/Q2VYZcthqR4UxnKEyi90fzbniAqUygpGxbJaj
	i6+u0mWWv30sWTDFYvPrmQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021082.outbound.protection.outlook.com [40.107.208.82])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 4h7jrxbe6m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 13 Oct 2026 04:17:19 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s5hDGIMEYsWFiYaxSWjgm6DBAqGTuRN2fhoovCl5Qkfbqub0I7CZ1qNc08P2ihrvPZ6qWbtnHICh+TFZEN7fUfnMMQkuBKA45kE3OZawEJIVzp8NM/J7Nk3CTtCzd9ri6FxSNOtUGDF8MkjnPgidY/bWSu5LBoa3DYDnoIUEsOJskBeO6r9G26PYUk43SqL5aWhzBdITnr2beHOMcnT0adYHghymednQzgI/ke0xqicbOTfTDMVHfMnYaL7+cxo6XyWGtGMRnCu0lZgLwBjpB49bg6FRoOl7GkrwGgeCdn1dvHhP8TjdLGnlOYHyzyOrUYmorZRKK7eHwnwbffRJmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bYybdxALArWsMznilok5p85HZqXcPsJGhbTg/oNSCvA=;
 b=rn35WMyOrQszgHoyv8WImnRjizYuE+cg/Oi4ORH0EJNV821979r+uvQBuj4ljmcq4Tl/ITmiHEidONSVvegHDSHCuey4/KUfIefM7srdFOVHvs1Lg1T7IBsJ/P/ZuwhiKTHucGrWiNMdFAeLTX/4bdIOE6xH2GDrQLDNLfnP1bBdgB9dNdk//HoIP+EvTsOp6/6mSS5p8H+4b8uITluLobqX1xoyQs/ik8IcbfJVi6e8g42gaJFFdDvQOhlL0jUy8smPfPrHICSyWe2+YPlOcQfOwZDkvjRX/J+R0IyxAumxqb+m/V7QPwkCq/ynjyP3ASZYt9ROYRYUljo3x2mDIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 84.19.233.75) smtp.rcpttodomain=cirrus.com
 smtp.mailfrom=opensource.cirrus.com; dmarc=fail (p=reject sp=reject pct=100)
 action=oreject header.from=opensource.cirrus.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cirrus4.onmicrosoft.com; s=selector2-cirrus4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYybdxALArWsMznilok5p85HZqXcPsJGhbTg/oNSCvA=;
 b=FkKDJt7Y8gkn1cnTh0aQ7yqzaIjJ7J6iZy97KMz8gpfC6rD0eZj78IJU2/C2ZclFWwT65Q2hvxF5nJuU379HzWgbcVdwGqP8f8kvdZuSV/mp4U6rnlwpZqKhdzBYvyxQBLHK3np7/D/ERDqI/05CwDCPSsmuH46JnAFCF/OARMk=
Received: from SJ0PR13CA0202.namprd13.prod.outlook.com (2603:10b6:a03:2c3::27)
 by BL1PR19MB5698.namprd19.prod.outlook.com (2603:10b6:208:386::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.19; Tue, 13 Oct
 2026 09:17:16 +0000
Received: from MWH0EPF000C618F.namprd02.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::92) by SJ0PR13CA0202.outlook.office365.com
 (2603:10b6:a03:2c3::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Tue, 13
 Oct 2026 09:17:15 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=softfail (sender
 IP is 84.19.233.75) smtp.mailfrom=opensource.cirrus.com; dkim=none (message
 not signed) header.d=none;dmarc=fail action=oreject
 header.from=opensource.cirrus.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 opensource.cirrus.com discourages use of 84.19.233.75 as permitted sender)
Received: from edirelay1.ad.cirrus.com (84.19.233.75) by
 MWH0EPF000C618F.mail.protection.outlook.com (10.167.249.103) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.6
 via Frontend Transport; Tue, 13 Oct 2026 09:17:14 +0000
Received: from ediswmail9.ad.cirrus.com (ediswmail9.ad.cirrus.com [198.61.86.93])
	by edirelay1.ad.cirrus.com (Postfix) with ESMTPS id 9438A406544;
	Tue, 13 Oct 2026 09:17:13 +0000 (UTC)
Received: from [198.90.208.11] (ediswws06.ad.cirrus.com [198.90.208.11])
	by ediswmail9.ad.cirrus.com (Postfix) with ESMTPSA id 72A1882024B;
	Tue, 13 Oct 2026 09:17:13 +0000 (UTC)
Message-ID: <343061a0-3a3a-4b97-91be-43b1eb015c4d@opensource.cirrus.com>
Date: Tue, 13 Oct 2026 10:17:13 +0100
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] firmware: cs_dsp: Run the wmfw payload error tests
 with invalid block types
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
 <20261013-kunit-param-names-v1-1-4b22ec5b85b9@kernel.org>
Content-Language: en-GB
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <20261013-kunit-param-names-v1-1-4b22ec5b85b9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618F:EE_|BL1PR19MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a55eb47-9a48-4ae2-74c3-08df290ac5a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700016|376014|61400799027|23010399003|16102099003|22082099003|18002099003|10067099003|921020|261009223027099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	yNKglfnyS8HpFA5DJfaEG01RBRXNlMSBPVbqsZks15hHg/OnQylzFbif9JV5PT0EAXnMHAxIR2oKFcsEwew0+DxSq/bI6tzua5csownSFdiCnj1F9v7n2R3QylyaIXgPLIZIFnl+oj3eC0OUlVcL9feboJk618IUf9n2USZUyjgcsNrnr+3iDkeV+ZH0MfMe6ZqZfik0P3zCQK4081M/TilHzy92JVvORmn7TrGrPpUddQwfIZKTSk8nYzL9A6Iv7tXrDBk8bwNxnEW2xjYPtEd7UbUzQ5959oY7cVtVdZr9uwEVWKbRB/WhCtgnGMrWRSMt6II4cc1KBppadCD9nUqsL9E/Wikx8Q3FPUz45BCaXZyvIl54KIaS4eBiDyzL0BdKTQHRqlKYa+PiaxSsdMPbWmwq9ALPBTr9IystLAYYOiBCoqbeY49RwI1bGancFVOxERqjBzf8YXvDLiY1YbFhPgj5k+P9fDg5d6i3nBBj+pby05pBRilRAfUdHyXQtWIJa9TuaEiy3oIcRE6YbF/4EOWTkGqnPxeYQpYZXopIuf09/dJ0mBizfxRFFCzn0i8LYF77r6Ej6034UXdFXQtUta7Qpu9ycwzW6iAGiZAHuVzw/VQxRaz/MTE//baa+us/LrZjbH4HWuUsQG6yyrNmONnqsCAeJ0jvbmPSQeGr+PqJCPwcH5A18q/2Xg++UccqTR7aEVObgWprXw7NgjVHnx0ZFUcW7Kk0UkdYWDYZ0Q9gEAGPBdPkKmxjuclv
X-Forefront-Antispam-Report:
	CIP:84.19.233.75;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:edirelay1.ad.cirrus.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700016)(376014)(61400799027)(23010399003)(16102099003)(22082099003)(18002099003)(10067099003)(921020)(261009223027099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6SJf8Y3bGWfg4Xj1xQgWXOa9qsxwi0JXAsZrsf/hS+zkueJ/DKvGodMW6dP//dCkcX2LOBICOZA3pia6nYRCUqsxfanH24SFnGEdLLku8o3sLvmnkc83+d6jZS9s8rjUk3De34p6KAsldQ2epb6E8g4aScWAWgcy2O4l7IkXHJj26dNuSnvUPW20/FEdLg1krxPqzzSUPJC85ylm1sb4Ff1b9DhSFRNRD6fDKKSsezoWM/aVE5qNZ//tMkZrE9ub89h6rSPfNFbOLybOBrjZzYtb/FXiwy3n6SsJWjd5V54keD/VsR4N/ZjpBOuO70B8f3KfootzJQ+Tk36iVueO15mN11gEXiX4rWFQBdGEPyCny9eKY4BgLgnQyZt7nCqYWgqa19URa9Rt3A7yvHE6/OaTgvqvuVKp6auGdB0L0cyLh4rzL+7Fs+A5njk4Sjyj
X-Exchange-RoutingPolicyChecked:
	reQXlN9Io43VXZ4lmiy50+nTZfoKMOa1DMJsDpxf5YN0YwEZpjKRBAsQOjZGhMOBqb3l5TuAtcrTE5d3pIJ+nxoK7Yj/JvzaCWfHduzsMunP3MGtDcfbPL4HHVh2pwyPy9M/ChwLHo4oG4X9TvDm+4WWBk5zwh2+Gi/yA7DiLyuE5tpKbCD788cqYmMgh08zAVWM+iENPMXtxiYp4FxFwYnnh7vwpYVXKyzJkN/INfBV9K6L7VtlJYRI35AIfra860hVcKdQk6gapYt08xXyYAdvTccfGXEiGvpHu+WaLcgryjJ0o1eITD7S1SwbVihK9OqCbpXNSBbtC5Ydv/ayvw==
X-OriginatorOrg: opensource.cirrus.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2026 09:17:14.8979
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a55eb47-9a48-4ae2-74c3-08df290ac5a5
X-MS-Exchange-CrossTenant-Id: bec09025-e5bc-40d1-a355-8e955c307de8
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bec09025-e5bc-40d1-a355-8e955c307de8;Ip=[84.19.233.75];Helo=[edirelay1.ad.cirrus.com]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-MWH0EPF000C618F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR19MB5698
X-Authority-Analysis: v=2.4 cv=A/n5rKWG c=1 sm=1 tr=0 ts=6acdf71f cx=c_pps
 a=Wfyg2MIdxp6jvjeZNnPfXA==:117 a=h1hSm8JtM9GN1ddwPAif2w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10 a=RWc_ulEos4gA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=iX4cTi3TZMoOKdANLEfx:22 a=Dj2-6B8FqX4mGL0U3gbX:22
 a=w1d2syhTAAAA:8 a=RUru0zP0KRiyErOxrb8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cZon7zOdkI-v7nzpvImZrIPS4XJvbjbM
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfXxEXKX/vj3zoJ
 ONbuwK8pdsOjoXXYud8ey+mcNusdUgj8mU9P/+/7lbwAo4apHQjOmSVcuixYstAETLlBwTJj+Ip
 gLkHaFU95mTwM3VkbFIR6VxrU3FG/JA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDAzNiBTYWx0ZWRfX2CJrX1wsCYXM
 1GdRb/6k0xDRLxN9IEGpRJ6f3Bp5PQgDj1c3K41SCPVvsHTj69wxm1RSdm8z5gAafqraMCsIPKa
 k4LjlB1+l0mcnMqMdVuCp8xji9WSETV69B3CmF/cP4yKEu9doMUnMHzZDqNI1TYPXOTv5YRtxpj
 19/2fwPUZUQ36uyYJtCOyKoT0zmEGQHloC7OMlnUE3PtQW+3VTkii2DrJiH1lx/qbkpt4KZ7vEH
 AYGBzeUV8IDXn3ltDIhBcdmnKFZdkIJ+SYPPvW2hNw/ITpFp+id12BkmGWQ7U24PpPjpkGKccS3
 CIitug467J9dY7rb1kIWq99BvxzMIyImcBLyN7xCY0fGh7vDViCCbmz3F8SA43d0LLrPYt82iVZ
 4dwlWastQsTpqO6yWK6/UcI+DGKfPkL5YNoq4M/E6DLTL5ucYmfmo1T9u2mEZYRfE21RAFJzLau
 adOM3yyifjBAJg6+IMg==
X-Proofpoint-ORIG-GUID: cZon7zOdkI-v7nzpvImZrIPS4XJvbjbM
X-Proofpoint-Spam-Reason: safe

On 13/10/2026 12:10 am, Mark wrote:
> Each of the wmfw error suites lists the truncated block header, truncated
> block payload and garbage payload length tests twice, once with valid
> block types and once with invalid block types. For the payload and
> garbage length tests the second entry names wmfw_too_short_for_block_header
> rather than the test on the preceding line, so the block header test is
> run four times with invalid block types while the other two are only ever
> run with valid ones.
> 
> Point the second entries at the intended tests so that
> wmfw_too_short_for_block_payload() and wmfw_block_payload_len_garbage()
> are also run with invalid block types, as the header test already is.

Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>

