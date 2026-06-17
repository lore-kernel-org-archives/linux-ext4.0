Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9CF391E58;
	Wed, 17 Jun 2026 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781685515; cv=fail; b=rFKwHAXoJ1C4txC93G/K7JJK8zl8B5TMDFJYCVFFsHVEZu/3qzYNTLP/TEY8ef4w1Jq2xuwXxfiCZoULGbzBHrWrWGhwkTj4Ed1gEbDb7YSqWFoLgMS1kVLX1ErxP3VfaQE4bAq8CnFjvrt28fnVk3BT5fWrrZTDdksQLDHzBEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781685515; c=relaxed/simple;
	bh=q7nrfjuRjTwbpsBl08lZIW+vNzA6fdlTrbdlmMLI3aQ=;
	h=Message-ID:Date:Subject:To:References:From:Cc:In-Reply-To:
	 Content-Type:MIME-Version; b=dLTbEJNnYh53bi9tuQt/dAjdeaiuZbJK9RKDm7xr/bnaU1wb9pbW1RzD1+J7EX1FHPAlEDc0s5nihLqlZA2Rvj/0K9PvH/exf+RM2FY6G0ZWxhsqTJfFbiNyYluQRxuOeqBUEt4Y3X/IaijeQlyCQnK6xmZpvQ9NtJSL2Kvl1+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=I0sW1cFa; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="I0sW1cFa"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65H8ZbQx1267715;
	Wed, 17 Jun 2026 08:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=4mFw8PZNTabWiUoiyCdA3ZRg+IkFd5n8kM/n567vaUg=; b=
	I0sW1cFao0qYQ1isoCikYEHgQ+43auYMf6VkdMtxNFVik8eyL0rH7uj2+oc5iH2r
	8eTNRAhh0RPsAQjiOEnQP1JlxpS1h89PEwRziLEot2VT0GVOSz0uIupxaIUuWwX+
	HuAO1s34DpvLS8KFBEj/Dbyd3Xx0QqRap33jmFVqrIXyZPntxweB3CWVZstc60Bl
	OPpWpUxMwHNfKtPeNfb3pM8+ump39COuenjNsfDblLobDH0O3TtVNx2xXO2gqoa7
	hbo9Y1Cf87+93gTP57uSa+e0o2in7+MQ1nlssQ3II56RtH2RQkMVzs7WnKnJwqc2
	cLSzyZ4lt73EpHNluVpB/g==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euefc0pra-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jun 2026 08:38:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KAUVVln4jJmbJEsG4Z1fBgtbx4pXSa+ARKi7Ydsb0IPHz/NLweZ2e4mmb9+A/BZDnQgeNkCrXsg/6hggYfnfCzYuELQeFIMA0fe49t+tOzEvDlQs2zisXl4ojUFeXvBKFpeDVg9HPHX1nbVJDVnIYCE68DkgOOIVHMrF1KK5Yh1j/UewfpDXurHd6AUh0bU2RiWYSX7G9SCSjYbeCbmrdObe9wMFUjlp5FUYVHgxHH2n8E0RYJL8U/0kwo0zLvc/Wok58TdaJlV+jQ2twn1Lud6f/OqahXwqN2jqmfcY7/UdQ9hoEUkHmo2gNBGdqxxItOJBn0WSC1kw6mXcWKLBOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4mFw8PZNTabWiUoiyCdA3ZRg+IkFd5n8kM/n567vaUg=;
 b=FHiX5325c+P0U+Hv/Q33pz1y23yx9f/vAWUuQ4eNnH6LlliqVQ1s79CIXSgBvHOUBlh4QzPiDIock7zdx9KUxeDTZFzlfp081ezDSTq0fo5mHnD8yCzCMlA0/xiZdfQEwil4R4SM9i+j4WfF70WHGq7i8CyQ9IRKhL2NJyaBxTQyFDWkv+/QGeAZjIUdmOsRHLFhObN+HDJyBQCXOMjuhudcon/Bvpin8LrTcEUoUcGTWRZ0wHcYDXc3QcavzjyJp7DkgMDebXZd50KAvgRWJves/FHfKIw4NDZcfyINW6ns/QOcDJqEdMP+3WjF3ZVZmhbKkDFQfJjlI8F05bof0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DM4PR11MB6551.namprd11.prod.outlook.com (2603:10b6:8:b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 08:38:21 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Wed, 17 Jun 2026
 08:38:21 +0000
Message-ID: <4ced5da7-2290-4f80-8937-4c477183c2fb@windriver.com>
Date: Wed, 17 Jun 2026 16:38:14 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
To: Jan Kara <jack@suse.cz>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <20260616151558.1728881-4-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260616151558.1728881-4-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4P301CA0126.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:37e::7) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DM4PR11MB6551:EE_
X-MS-Office365-Filtering-Correlation-Id: b3a7ea6e-fb47-4c8b-0986-08decc4bc94a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	MKrUpPLr1ShripXsP+VvcG/Buo0VCAUDxoFVsPouj0qZlWyLPvg393TGa3TtTnf8WcNLcZUJy6Zx9Dv8MOQG0ve2h2ua6gNGvTW/3azg1uGJWUd86M8RmuLm3nmALZh/K9triVi+wGYRWLJfN3/QfOHNYcZj6keuYRcJC3jA+zQ5WrN5m6rzqKavPwm4fSddj8u0bK+eL/LRh48dEflZyH1UNXz5umhAsF44cxkAStFLHMvVjpyPoO9KK4z5OoO8sBzJaBAhEXf9LW6hMR/hYI1VKghmBDuahZs1mR4tpH2BBHtz8g2P6K3GF4kwVGVDshIkoYyABmS49wQUh6sAn2TJqsRY/SaVUc8tllD0rX9ZKY3K2jogvqtPGo506qYe9b4h6wfnssyie2r4zjbYKnbko9WwoY288wa3lsBs2KbAEMe9Rbla9ajmRVljyuyEXFUtRuIbK01ZyY6lM2A7JXvZnEN5dbt3cVPEB+HNg6tIZbeA6rtJCR4cDLjYDt4RrVFnPer2d5RVruYUm0fI05OGv3nvwhgkrOg/MzPBnpIlYUApIPyq8SVaYdU8A4A5yHe6isMCnATNLCD9j7qtFnPOcsoTu+MRj1rp5CJt7lFe0NqU3/bhq8nchA2Xc2u46ieY2M5OOOzK8AnqIKXTE49atQisuhuQ828FJMuyMmmlKdeZhPLQdx9wXn7GX3Au
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHh1dk4rNUVpL0FBWGJDVmZiNHlUVkxDOGtyTXJHUzYvbEZTUVpPSGNzaHRh?=
 =?utf-8?B?ZW5ad25jai9Sc3NEbVorR0VHWUlXNXl6UlNsam5nbDJod00vWmpLOXNUaXM4?=
 =?utf-8?B?NVBQWnpUcEpDM01ZbGNUelFWVDYwWUo3c1IycFJsRnQ0WWtZdHNsWVlvSTNk?=
 =?utf-8?B?dE9XZWlrRlo1Z3lkaEJxdUtLV2xla1U4bmJ2ZW5mcmVKRmRIcGE5SFdLQ01F?=
 =?utf-8?B?TGcvTWVYQ084VlpSVzhTUlUxV2VENEZvelB4dUI2dmtBRXJNaXJCQnFqNkho?=
 =?utf-8?B?R2ZwUGZ6TFE5MFFDT0xKQno3ckQ4VUh4MmRiNHJOT2VaeUpJUnp3aDRqR0h0?=
 =?utf-8?B?R3dxQU5DN1kwZmhUeFd4MzNBRGVSc2YwVCtjNEVNY1BOMnIxQk1SRVg2MjZw?=
 =?utf-8?B?R29jN2J3Z2RhczVJOU5BdHg4T3NibEJ5YkNKbkwzZ1NRN2pkaE9VMDc2UndF?=
 =?utf-8?B?VFp0WlVwWkwzZmRDQW4wdmNzQnZsb3dhTWFXc0NyQml6SXVqYUVaTVo4M2ZT?=
 =?utf-8?B?SEw1R3Bvd2Fmbmppc3ExNENIRkZyMjlsZkUvcHNTTXQxQWhJOHY0OEl3ejVE?=
 =?utf-8?B?Q3hvcGxJOHZVakh5S1o2ZDY4VEF6VHlDWWtxQVQ5WjJEVklMVm1oYW9KdDZo?=
 =?utf-8?B?OVZ6VXc4K2VPTjRSZXprZ3ZPR0V0R3JDMlFKbzd3T3ViYmZMVjlTL3p6L2k5?=
 =?utf-8?B?MVhvcU1oTUNlZ3pIRmw3SlpZcVdEakJJeDhhakx6WlZiMFA0aTJJaVlXYTZa?=
 =?utf-8?B?ZTJhRlkwbi9TMWRrRWhLQU9qMTJwaXV6NUtmMFlCMUkzZm8raEVQRW9GVDU5?=
 =?utf-8?B?cHlsakpHbUFtZUxiaVJZeWVDYW41VnN5czJydlp0M3R3NmxKZDU0R01SR2hh?=
 =?utf-8?B?MEpxbmFxbCt5dXBvVUYrd2lsV1dkQjBnbXBIM0E5bjExYmFKYzZXbFMvNlRR?=
 =?utf-8?B?UGNjNU9pb3RwNklUNllYcG9LQ0cwRDQyaG1kWjZDNkRIT2VOM1JvM3E5YllD?=
 =?utf-8?B?cnpQTnBSMVB2TTkwSGJhVVlwck03TWhldWtIcWVDenI0Rnp5dmxDY252bENx?=
 =?utf-8?B?eDdpMVNWeVh2WGZKQ0N0NW8rZnVrSDVuQTRJTmNwOXVzemkzMklJd3VqWGU1?=
 =?utf-8?B?QTlxa2ZYZURoTXBjMzZ2K2hIVUJEWE4wRVA3cE9LYVhmYTg4YWpyZFUwZktS?=
 =?utf-8?B?UGh5M0ViQUFkc3RHSVVObWNMdTNNRnY5Nks4ZFY3N1dJdVI4V2VkWUx2clFD?=
 =?utf-8?B?ZCs2d250VGN0YkNaTUZFUGRURWJoNksrKzE1U0hpczl0cmNTQ1RCTVR5ZmZF?=
 =?utf-8?B?UVJFQThuN2owYkJKMjZWWHFKeTNCak1rUENnaC9WZjhzMTZHMnc2R2RGZnYr?=
 =?utf-8?B?dElmR24vVUd6YlJKQjQ4bDZNWklsQU05UElXVTQ2S0JGUTdQY2M4VjhHTldD?=
 =?utf-8?B?c29KYU5PMDJzc1F3WDlIN240YmpTOVJkVjZhbCtJNmdIUzEybm4wUDZPcUtx?=
 =?utf-8?B?QkRpQ0VSNzJFWDBNOFRxTXlYc1o1SVl1MDlPWi9qWlFNeG5RelRCV2Q5MzhU?=
 =?utf-8?B?Q1VJYzdKWFFaRkNYbUJDSFM1Yit1M09MOXZ3K3NVRERiVVpKb1RMMjRPM0x1?=
 =?utf-8?B?ZUljVlVEc2VSMzFIeFQ3WkplUUkrTkN1OU5MT0R4NjNqcDB2ZXVYYTFLMkxM?=
 =?utf-8?B?dUQvVzNFREQ3WVFOUTN5YXpVaFRUQnp4czVKeDIxaE1xaVdKU04xL283MnpR?=
 =?utf-8?B?aDFWb255Y3JiQ0RJQTFlVFpWdDR6ZjQ3WElxT05vQVRHQ0gwTkhiQ3V1aThi?=
 =?utf-8?B?Z0cwbkhka1RYeEdKc3RoUXVIT2JBU0dmYnhjU2lNWklLcVR0TVkrbldaeFFZ?=
 =?utf-8?B?bi9rQ3VBa2tjVjE1dXBmWElKNnRYRWRMbnpWYXZsMjEwZHlmUmR2ZURwZzJm?=
 =?utf-8?B?STFwT3g5WXk2RjZHS2ZiMHlnL1lvQTRzR25mMSsxQnpsRXhCNi9oWXErWExm?=
 =?utf-8?B?Q2JCYWJGUG0xUWJxdjBCRlNCU2llaVJNd2R1cjdvMTBYSUkyUWFTZHhTZ2hr?=
 =?utf-8?B?UWVYeDAwZDdRVmpER214c284S3FPM2VmbXhsRlArVklyeEZjekVEUVBjOFh2?=
 =?utf-8?B?dDFpNzJIOXVZMUFxM3FZWm93MTdNSys5aFZPS3JRUGxtZEdxRmF1aFFWK21s?=
 =?utf-8?B?SmZmWkNtMWs3eGRkTkpIcHk3TGo0TmlaQjFkTE94NVg3WHVBSXpaZVRyd1Uz?=
 =?utf-8?B?VkpudytUY1RBMHJHaVNiYmRFVVVrbmpIUlVFV09XUTl3RkVEazVxOE9YbUp5?=
 =?utf-8?B?aTkyRDNJRkFxSUQvcTA4bDkxaUdvc2pZZHFvdDRHcG8rVEtEZXFIUT09?=
X-Exchange-RoutingPolicyChecked:
	NQlSkr5VEmctTlgLAUv75HLQoaPMqcvr/DykJ3qn9dtQhbRhdNKqzplNm8OgP3UbjJOyvr8XJUgFFAMrGQYMfpuBOfQiTdIDr5cntH2JInZ/yDi2qbsDLxBI+dwSBFmYFe7OVijNsQC0ST3k3FADC7912y1xXxozovemrhQ9EkBa0dE96/UGK8GitXhsD+8dAgsuR1+aK4C/5YsSxPb12OD4IB5IR1vVuZjnc1fJAnCjshfXRvFYySYoo+QEW0XGivXl2J5Rk0pyONM+b9uzyN/Qmnfj/PB8BWbhfXgkvpLcyF8wAOGS5cS8hcu2GuPb0gbyzyhEmtKAzq+EOusmBA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a7ea6e-fb47-4c8b-0986-08decc4bc94a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 08:38:21.1228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lhdJbqKWXFj8HRCnmEly0BkW5NpUCc0LOnS7Kjvee0CN/QpZyPVWgjIejCvdI3sgH683oCKYi77KyRbU113I8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6551
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDA3OSBTYWx0ZWRfXwXZ1u4OUuRWZ
 fKPm6irU/ZJogZvxA3uTpQ8A6bNQeypzE/zXNkPQeTeGoPkdgU4ZTfmi+s3tzUshz2XoC7j+D1C
 Z2vOL8mXSiYSsjeVWs5HwdocgJnL3v6iNGbQa1KVqPzQQ1gPNNud
X-Proofpoint-GUID: 7EfW1XTwfWdfCQlWBORfFatmXfrn8HSM
X-Proofpoint-ORIG-GUID: 7EfW1XTwfWdfCQlWBORfFatmXfrn8HSM
X-Authority-Analysis: v=2.4 cv=ObGoyBTY c=1 sm=1 tr=0 ts=6a325cff cx=c_pps
 a=U2ki1QFzN2iGT7kcnsve6g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=ucr4T7Wc81PFayxw2nQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDA3OSBTYWx0ZWRfX/dl3r4U+yHGS
 fzgK3zlEF1mgDrmS4Vx479jxRY+1ZqlQeQydNwyaDPnSjF03cODNkT1vDB05Mv5la2CUCJUIi5A
 unLTcNuO0rIesz38iMpxujf2lbTtLMqNKtVsH51L+EEkIu9qsSmTAQ0dvQUG+rY/gpjXMGquQPO
 YoXiyOy0IYUUhpe+7rFd/RkmW1RkEFoRxDEDAYNftXnWGH8VEuGo3BsB19tRW4wQjDd+OcWeD4I
 Dg3c3b5QPTJOxhBGYqnwQv1XbZGAByUI5+wJS8nE1v8ewJVAjqWC+1i18XT3umv7XkDzDOIyt37
 JBje/D83cTr6bfzuq+dzNcQ7WVOqz3hdTLeF38uRHbw07jU2l0SczJVWE8BMzVTaaq0oajHNm4/
 0NCEUaSF0ZV/EUCGEXujJL0+KeMyBTFShphWHAVzgBygyOcOVAAkzu86n8xy1O7+Dh9ranZv4QL
 +Thr1ovgpijxaBfKQug==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_01,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606170079

Hi Honza,
> Add ext4_put_ea_inode() which safely releases EA inode references:
> when SB_ACTIVE, it calls iput() directly (write_inode_now cannot be
> triggered); during mount (!SB_ACTIVE), it queues the inode on a per-sb
> lock-free llist and schedules a worker to call iput() in a clean
> context without holding any ext4 locks.
>
> Convert the iput in ext4_xattr_block_set()'s "Drop the previous xattr
> block" path to use ext4_xattr_inode_array_free_deferred(), which
> releases EA inodes via ext4_put_ea_inode().  This path previously called
> ext4_xattr_inode_array_free() (synchronous iput) while holding xattr_sem
> and a jbd2 handle.
>
> The worker is flushed in ext4_put_super() before journal destruction to
> ensure all pending EA inode cleanup completes while the journal is still
> available.
>
>   
> +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
> +				struct ext4_xattr_inode_array *array)
> +{
> +	int idx;
> +
> +	if (array == NULL)
> +		return;
> +
> +	for (idx = 0; idx < array->count; ++idx)
> +		ext4_put_ea_inode(sb, array->inodes[idx]);
> +	kfree(array);
> +}
> +
> +struct ext4_ea_iput_entry {
> +	struct llist_node node;
> +	struct inode *inode;
> +};
> +
> +/*
> + * Worker function for deferred EA inode iput.  Processes all inodes queued
> + * on s_ea_inode_to_free in a context free of xattr_sem/jbd2 handle locks.
> + */
> +void ext4_ea_inode_work(struct work_struct *work)
> +{
> +	struct ext4_sb_info *sbi = container_of(work, struct ext4_sb_info,
> +						s_ea_inode_work);
> +	struct llist_node *node = llist_del_all(&sbi->s_ea_inode_to_free);
> +	struct llist_node *next;
> +
> +	while (node) {
> +		struct ext4_ea_iput_entry *entry = container_of(node,
> +				struct ext4_ea_iput_entry, node);
> +		next = node->next;
> +		iput(entry->inode);
> +		kfree(entry);
> +		node = next;
> +	}
> +}
> +
> +/*
> + * Release a VFS reference on an EA inode after ext4_xattr_inode_dec_ref()
> + * may have set i_nlink=0.  Must be used instead of iput() in any context
> + * where xattr_sem or a jbd2 handle is held, because eviction of a nlink=0
> + * inode can acquire those same locks.
> + *
> + * When SB_ACTIVE, eviction does not call write_inode_now() so direct
> + * iput() is safe.  During mount (!SB_ACTIVE), defer to a workqueue.
> + *
> + * For EA inode references dropped without a preceding dec_ref (e.g.,
> + * lookup-only paths where nlink remains >= 1), plain iput() is safe
> + * and preferred.
> + */
> +void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
> +{
> +	struct ext4_ea_iput_entry *entry;
> +
> +	if (!inode)
> +		return;
> +	if (sb->s_flags & SB_ACTIVE) {
> +		iput(inode);
> +		return;
> +	}
> +	entry = kmalloc(sizeof(*entry), GFP_NOFS | __GFP_NOFAIL);
> +	entry->inode = inode;
> +	llist_add(&entry->node, &EXT4_SB(sb)->s_ea_inode_to_free);
> +	schedule_work(&EXT4_SB(sb)->s_ea_inode_work);
> +}
> +
>
Could you help me check if this is the way you expected?

Thanks,
Yun
