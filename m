Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812F535F610;
	Mon, 22 Jun 2026 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118123; cv=fail; b=UcZAjMCuW4D94VmZooPbUJkz1+ir3cAh/H5uK/6tOUQYFgups6ZXFAxdIcPjswWje7GsKT/aWEMBbKnjVLV+vBR16dzjN+DMgDPIJoEhdrl6t3FVSDEAgJOzamvLMt9tUlpW22otAe0wLO5JpXpCjuBjuvWE0p2tyKk4VfxWJBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118123; c=relaxed/simple;
	bh=O/4ZjBiWjwKf8CmH80caGEoDUVsk8No3gobVGgzW8Pg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RX/pBGiWyRxcujWjMJpkK76YJ7/912w6clADUMcdvbxsQO4NycHrrEceqNp7GtVK/TnE4QS51TS2htfqW7YHZQnqky2x074+fmKu2ywekw08prMjOO8eHkGjoi0VAWQdHpsLNuz6O8S6W32UTRKchfQ+lvGTHqp579/IwitgWEU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=lvh3SV5T; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="lvh3SV5T"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65M5BBrW681386;
	Mon, 22 Jun 2026 08:48:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=eDPRu6t72gUQ88ZmnDUy5gbweqHrjP1qrhH/8DXh1LM=; b=
	lvh3SV5TXvC05gK7iP+tp6LRr85bfxL+HD1Een6XYtLxAB10WD2yq7lqI91SnM/q
	3brME/pb1C9VREGsgOtymg8m2ZN++2ZUZn2mTDNxonNNE1zANwdYTk1SsEMQl0Iy
	OMKs3CgNFOOxmbPlutGdQI347/JzVWbDre28MdWl/pwjQQeYihcW5QpVFYuXwdr8
	K5aXesNc7iWvDlos3nDuGbeSI95lZ19SWvk1avkOVTp9eQ15o60/4bklR6OdBaxK
	NXrKtWre5tCBcvfH0UM0L+M6OQNTVrog2fyTy6OPAeHI7chATUWptE3oBuYkP/Yj
	iIgot81E4vnGcVyfRM6FIQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013002.outbound.protection.outlook.com [40.93.201.2])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewg2wssqc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Jun 2026 08:48:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yd6NdO4daF4zhaMVRMmALGCfgASCNbGqRhNfAyDT3vLG3P6wBV+/Eo8UijuRrPw3rB/nV9e0NQoFUgPy/iJSHY7CR6Tt3uKejh/7GTh3gLzJUyCZThxwymwSWJ3FTkZGevnDBTopLGksb/lj6UTesHToPTapFB7UPsd736EXxK5fAmUwZZ1ZNOF2+BVcRkiHVxdIIf7XqII2q/Rt96undeE4ZSOESA+ccpL+aHH44WSJrNCQSshXuWB+IkmWC40x6E7T6Ub7NX/OpeXs+0t2U/8xoH8TbKiTnTKE6zuYE9X2FUgo3P5Z0dmdKiiHJHN/hwwS93CUUg15dFZaL67Lgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDPRu6t72gUQ88ZmnDUy5gbweqHrjP1qrhH/8DXh1LM=;
 b=HwuS9hpg746r+M14lLuzLURDJhbYAU6XQ+QRXqAk5G/mO8Dtsov9bnZG3BdFohQMT1dgIRCbA4aoAxAFUYg0Q3+eqpVoeOl9xiDjJmfqiubJ44YEsTFj1vXdkzVM+YUWIuxolsXyFSA9i55y+x37vQuqbFmAICWKTjGBPLNUk6W4gzYITKkqc+AZJls4gTKBTmgi1w2rtWj3AyIdH482K2j+zxg+i4tM8tBhyvuTipn3prSLZXUtRISjxxukhiPmr8ANSiKCSd+Nb67Q1gJ9MS/UD5SktteRMrVu6u98/Y/AonU2heaFlAvz748Iq+FYR7D0uxQxdyoSKuqpD/yg+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by CH0PR11MB8214.namprd11.prod.outlook.com (2603:10b6:610:18e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 08:47:58 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 08:47:57 +0000
Message-ID: <71adc30d-ff3f-4603-bee9-6124a430b58b@windriver.com>
Date: Mon, 22 Jun 2026 16:47:49 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <20260616151558.1728881-4-yun.zhou@windriver.com>
 <jxcbsd2ot63wy3dcoximemkuitwoqn2a7jgxcsfdwaf5q3ecdu@sahahqqopo6y>
 <dd9e35e6-306b-4e49-9802-487ce7abd63c@windriver.com>
 <tss5x73b6cigpsmi4yvckahikktacmtsphsupa6kysr2i5bsst@laxukmhkmv22>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <tss5x73b6cigpsmi4yvckahikktacmtsphsupa6kysr2i5bsst@laxukmhkmv22>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0128.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::15) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|CH0PR11MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: 032e9fef-b90f-443b-cb96-08ded03af54e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	x5+fv3eIOwCYv9aaMkxNtYNuucUSi0JS8KozlH5OemvzPYnqrEhP6d6GbRqlBNd719Cjx/BRYrb9AE69pMBIIjX+C1pR4JDIjrJBP0Pj2Xv6bG/iu0+gIlZ38D4I2TVlQr7+vaztyLTrl6T0Bj00c6yLpol3GRWHIT4lbrGMPHSq0MpE1QDYX5QMwkNVmXNJ6Gkyknq7+UKhJHVOLj2A+QW0QSMAledOG1n4fDUsLJA2pkbMsePyzaK/kvQIoMPg9tj/hGNJKGJlVv9aXow9yBM6BgeM+IL+llvDsRwSuY5SRt+C+DykeenW80GE6PRV2TTxLpQVT8V+VfFaOhF2LehJkes4MEOmnXpFXICGI6hv/LHvt5eZpBcaFWUnbcEtkOs219QV9n3u/c50dbiCoO6D+0LHeSt7UdsO0mXApYU6cwXuBu3Z0B+muQiMeqrbzuXn1hdt5gb5rq2GDX7rujQVk/MlXP1AYxK2oU1YE7b5XXMui5ibb2skxBRa17UTu+lKRbhgWA0PFjpG9HCRCfgoU1btWJN0E1CKFMh+SJEia9pES5yIYL5Izj4mAbBv/zR7RWoMQeLQWhfew8qXm3Fm6urRI/7ZT0cWFCe0X8zhVassnNKe8nym1dGj11+pqEWVXODrhXP47vBDIFGaFoOUTkUQOnl4hTLqMpuf1EQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXVoUXAzc0cvVC8vdUNtTkdhNnJtOW9EaGZxczFDK1VoKzhraGhPQXNMd1dX?=
 =?utf-8?B?dlpMOG9qWFlHaGZJZ29IT1hyUXp6K3R3TjVhN2g1S0FRT1h3Q2RmTkliRUFQ?=
 =?utf-8?B?eFZkd1B1ZGhHSFFzSUlJSW9qRk5xZWdCQ3M5cHlKVFdQUGljMHJYTmRBV1Bp?=
 =?utf-8?B?MFR3aXRYQU1nUk9iVHJTRHRuRmdCRzMvbzRpYlJyT1J0NktPdHFZUVF6VnJD?=
 =?utf-8?B?bE90NW9PaWxiWU5NaVprWThVSjBOSy9hdGpKU1RtUDVndDRId0RBTGMrRUVw?=
 =?utf-8?B?RVNibStqTHkraDZQaDRlR1p0UjNuTnkrWGlNeDAxVFRKbkpKV1lKdGpJeEZE?=
 =?utf-8?B?RkRQbk1GOWIwZ1MwWVFwcDViT3VyazN6WEZoMllVYzdocFN6bXZnZWR6WjBp?=
 =?utf-8?B?N3ROdWZ4NW5HOHJTRmk5aXZ3Ymx5YXE1WVBXZkZ6bU9UVmxKRWtaemNMUlBU?=
 =?utf-8?B?OEtSQ1B5TE1vOXByRndsVFZCcTFFTnJ3UHpjSisycGFLbHFqMGRtcGcxS3RK?=
 =?utf-8?B?cWFXWGtSVGxKVE5pZUVibmRIZm12aVllTG8wSzA3Tlk1R2JmSGhIQ0lTcTEz?=
 =?utf-8?B?VlJXVHdjdXVPOWxTSVp3NVFXMlpwYWRXQ3ZLTTJMUmw4cmxxTi9YR29UWGpO?=
 =?utf-8?B?Rm1GeVhRa1I1eFZHTFVPeGZ4ZE5EYVkwRUg4Ujl4SitqQVM1YUNMcy9QcG5u?=
 =?utf-8?B?SklwQkZnMnN4T2VZU1BGRGNWcDB0eDlpYmhLSTBBUU05eVdwOEJwR0E4Z1hM?=
 =?utf-8?B?MVpxWG1KNFpNRkhPY2l3ZFNBbEJtLzY4Z2pXSEYra1ZPQjd4ZlNhN0hpR2lG?=
 =?utf-8?B?T0M3MEU3UC9QbU8vNEdWZnYwMzBjVEYwMFpBUmVIYm1lNGhiUEtUajNrQmEx?=
 =?utf-8?B?aE5QOElmN1c1OUNjVHc4VENCL0FpZE9FVWp1T29kZ3U0TXF4eXJOdVJ4b2c2?=
 =?utf-8?B?enF5QlRnN3FmaFcxY2xYWHJJanpNYXpSUnRTSnZveUpObnlXOVplSFdKWERM?=
 =?utf-8?B?bnFFSnhTTk52SjA4UEZDTXY0ZTkwdVl5a0p5MFIvYnlqZERodDRmaXYzaWd3?=
 =?utf-8?B?dE4rUERheGVTeVZXSFlyUjI3ZkVNc29CRWxkeVl0Wk9HN2RuQVVnUWNoTURv?=
 =?utf-8?B?a1Z6aVFUZThWbVpaN3dDZTFNVkpsZkVzK2orTGJCV05jMENXdnF6Vi94aDV5?=
 =?utf-8?B?WVdaK2xRMVo1VnMrdVhXRi9aTmRFV1c3aHlDbGJmUWFBcHR1VUgwaTZPYXFL?=
 =?utf-8?B?cTMzejZNMW1lVldYNGZwRzVodlh5eDlVRnZLVG9ncWJ2Z21Eb0NiRldBc09C?=
 =?utf-8?B?T3ZKc1FJRXFVVWxFSXcrVWtIUzdsQlZaeERENVlFV3drcVBUUXdQZzY5SHU3?=
 =?utf-8?B?R0RZR3pRSDhYOVFBemJxZ0RQZjFhNHlmcVVjc0xURFAwSG4zbHFCQTFPMmh0?=
 =?utf-8?B?b0l5blhuNXNEcDUzUHBPdjBKOUdOa0orS3MwdjJXd2UyTjQwazRjcW5pZjBB?=
 =?utf-8?B?R0lXWU5MYTR1L05ZQTJYdmFIbVhJZ2hFVE94cGNFM0xwWWtaVFA0UmdjOE5E?=
 =?utf-8?B?TEtiVUpCQkFUOWFKTVo5R2Q2c3drelhsc0llWE9Xc2tlaWY3ckpqZzFJUXYz?=
 =?utf-8?B?WWFnZzlUeWNibVBWeUY0RXlFOXU4QldjOThoMjkzazVYaWlzSWRNc0w1d3hN?=
 =?utf-8?B?aTh1aU4vTktQVmdaRi9BN01WZFpQcFpkY3lZYlptenY0ajNkTG45SktyZFBT?=
 =?utf-8?B?TUNnb05CcXpaZzVVM0lEeVNxYkFEOUNDeGF2dlBpV3AzLzJPK1JBZ2tEdjc2?=
 =?utf-8?B?UndoTVRPc3YrNVNIaWNqT2psMUhlc29lenU4andoeGZucy82VSt0SnI3NVdH?=
 =?utf-8?B?UjBNdnBFTUlMLzhqM3lrQ0pFbE5INCtlaUw2UDcvTGI5empBL2tUZlExWFZL?=
 =?utf-8?B?bWRrYTZKSnBEWHVuc0d1amdDZnFhMXNZQlBvM21GUDhsOGdtZ2ZVSTYzcVdx?=
 =?utf-8?B?bHBiWExyVWRZeFlmY2RodEVmdjZSVmdMOUJXUW1QZklJSGxkSHR4MTk3VVIy?=
 =?utf-8?B?SWY1U3ZtMFZPeDM3dEt2bWNqME5WUW9YR09HZ0dia1QzME5sV1d3MDhGMjdR?=
 =?utf-8?B?WFl1aHFiN0dSa05kN1BjUkE5SE9ELzBSSjkrakRuR3o3ZzBVZHdiN3hzTlMr?=
 =?utf-8?B?N1pzVUMzUlRFZlR3b25mVjR2Y1NwZVEva09aaUdEYVh5L0FhWU9xdytuMUhw?=
 =?utf-8?B?eklVR1poMnE2L0czaTRCYUI3TktRd2pKaEszNUV4T2pGTGEwemdGL3BYR3k1?=
 =?utf-8?B?ZlhkVGRnR3NabGZucjE0RkZ5U1hPUktKWDRKWGZieVpaODU2VFdlQT09?=
X-Exchange-RoutingPolicyChecked:
	PiVIXQRNiX12bsY4h21QDv7X/M8T40N0oYXxJZxXDeruOzuxRWe3Hx2KD2VVVEH99itJO8GnWf3eFdTke4i/4QuyPTXaiC2E01rzTUz0P2pPqDcE2lv77Lv2s5f+45qkzvev+Osbo/qTK/feVdRiv3c2XIse5F9FxT2kmiW0Uf1UMmE6svHRmKw0628fnZ+lRmiRuJWmQ8H+GHqgD2s0/oJUypV2gMpyTUcxereorgS9MLehsIv6yeKUdwAkPhzyX6hRcZXfBSvuBru4dQ2GMrTHKybdYsVnUXHrX7Z8hVuHLjuY/IRhbNzJ27WdSWUc4wkFJTSSmbFen7vFBFGBXg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032e9fef-b90f-443b-cb96-08ded03af54e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 08:47:57.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5RQ6J6DLWDxNk8fwHQEolgavDAwnljGkNb1zZ+bqBJs7YvNUNoLkknnGmqyfB/g/C65qneDAs+SoomtsAurbIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8214
X-Proofpoint-ORIG-GUID: lO5Keq_bUb6GU3r85wi0sfulo7A0dTXJ
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDA4NCBTYWx0ZWRfX1Wa6ubH2lLYC
 rKX1HGx7+H27Gt2XRC1r0b+5fgoMqwjcFCEPs9NW14n/fjby46K/xrAvedS7iQ0o562ZDoKmos1
 CyZnQQcnnp8ZbiX3DHBhQ9xpFBcUeP6BS5vU6YlQhDtQszqwrzVJ
X-Proofpoint-GUID: lO5Keq_bUb6GU3r85wi0sfulo7A0dTXJ
X-Authority-Analysis: v=2.4 cv=Xdm5Co55 c=1 sm=1 tr=0 ts=6a38f6c2 cx=c_pps
 a=IyT5loBvHZYA5YPQi3EYsQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=F_vWR1Ze_3-BYS7qgtgA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDA4NCBTYWx0ZWRfX3JdzgPG3y3Rl
 jSJPka+ofEZpPnai2pKEkus+kWrqjM9lVHwjAS9O7y4kwKw3grnAMHaBDPvtm//aDx9T6ZwTzOD
 2buZvs0w2femoi9TFeAfdLBYcbIXljnpJHOmGwW7N7P7z7pzf1wrupsROxEwzGK8O1E/njWhtmM
 One3ik//oHMe7RtdOap2P+L7YqwPpH8UDfXnhWLzN3+WZEXFfrsb8BqRAQyHgwcDwJ7xCmtHH1v
 1Tm141dm72SgrZX7DDghb4LcWJflqryyGtjN8mAYd+1EI6GiFLXGoqNqyijxZR76SuM7tkP9fsH
 I79qOdZW7ufuu7iP9eEGi4BFG4n7+GvUTolGa5NKcuxUKyGKgEQZbrZ9QP8HC2JgLZH6Nx7bR7P
 RUouYbo2U4qXgTTpFhn5H50drK6+KI4jgroz8Ds7yYfbdBWVs/P9a7k4EOg7UQ6axhVa8s3qOxq
 +jQOa3/sQ8xYNW80Kgw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606220084

On 6/22/26 16:32, Jan Kara wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Fri 19-06-26 14:24:51, Zhou, Yun wrote:
>> Your idea makes a lot of sense. It greatly simplifies the current deferred
>> iput logic and eliminates the risk of failing to allocate an entry during
>> an OOM. However, as you mentioned, getting the VFS maintainers to agree
>> might be quite challenging.
> VFS maintainers don't bite, in the worst case they'd disagree :) For a fact
> I'm one of VFS reviewers and I think iput_if_not_last() idea is an
> acceptable one. So I think it's worth trying.
Thanks a lot for the strong support, I'd be happy to give it a try. For 
now, please
just ignore the v8 patch series, as the AI reviewer actually found some 
issues with
it as well.

BR,
Yun
