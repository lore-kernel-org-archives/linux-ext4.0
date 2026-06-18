Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00FD15E8B;
	Thu, 18 Jun 2026 00:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781742302; cv=fail; b=kqppDtYvY3eMEo4bY3X+LK15m30tddiB3I2hDqDhSoWcCx+EmF6BPzx7hxqFeM0T6WHj5PB6eSR1pOsbAbSTV/UhpTsglDEwcVsxG9GEecnHV3zeJzHe7nq1vA5NnzfLR8Ddr3bLgOPgAVT3zhXxc/dKBr6RcOH6XcWdaKoA5lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781742302; c=relaxed/simple;
	bh=tsZDx1jBZ0CWisqWTJ5ppaqHk8/6RL4UfEb9QTRxDLA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OrWV9Tv8gvpXZ3EVVJsYmFBaKHW+ic2lbwvhW4s6qXrCAbg9AVKO+qBEYU1tlwfdwVbxfV7BbGzQFqToSR7kHgy5QiD1rkqI4lrZXuh07RQQhQ0u/ms0H+tUVe6nXUsIiECVIjcZ4sZ9ZQ2cN0AX8pK4RZrxTLkYEjUPR3xwGu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=NC+hurL5; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="NC+hurL5"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I0JaXk2906469;
	Thu, 18 Jun 2026 00:24:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=JRSwsQeMkc8c5ifBD4KwG444OELQfXqfwgL0kMsIekM=; b=
	NC+hurL5hmlZuzbOOt0yB+7y12Uo56BALJDNbr2T4fDdpSyVMdDih3QHYjIhEe8/
	2uwYaEfa+QRoYNZEYKE1Yja7sqGv2AvN830xx5doE4KXIrTYFKbRBc2JR9wjAQQu
	Fnxy0n8/AHfJMEUAARBtu6cJ2Cyw2I1rgdxKmcoehLtX1UZuIMbUOb7rfdnXSpUh
	eEXmjGyx39/cWZDUpSA4lxCTsB19jJDqEpsJRKBJt1wsIueJ38CUkl6ymO+5FBrN
	qtHfDwZIuZ8EMcXWykz09EXK5lpccNyUEwpzP85mcD0LTmfz9uBeO4r0pOpIW1vt
	cfMq+wl+gVVnOeHsvROvmQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012052.outbound.protection.outlook.com [52.101.43.52])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euefc1xdd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 00:24:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hgv6H00f7Xfc8BElxepaXfUmzEw7043woT8nL700zW+NfirkDjhkf+c8+3O+72Bkk10DIj/ZTlqMHyKvBpxb8HDNff4OgwPYJRJxw19GtP0x2Q/e9eMQFv5sXZwFibdiGRaaZ7M1IJ6KT/vCo4VJYN4ri+/aNjTAyvLC2lmVFi6jMvtxAD6NY429fpxmqUpKV0VNK6wBgV9CpwzN047RCeckVcZ7BqhMGSyNoFW9im3zK7pP/wwnQSgkppsjRxlSsoXNdKEvPmXs1n7YoejgRc2CY1SDWqPY8jw6eWTJniRHmuQa+zVMngLVOZoMsRYARYrZxDo7nrbbMOLyRQXAAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRSwsQeMkc8c5ifBD4KwG444OELQfXqfwgL0kMsIekM=;
 b=LmTjTMq3H2R1P6VTbpf9OXRcEDIpJmtmFat1ycBboAkNn6RG6SaJsyUYOIzBuwKDvlnOgFsMSPfso4HRt8Luv4FZPdznEEr8So5/fbNSXQxSGSlKyLmdREmFO2NFmzwQCvTRfVPhjEWpcGvFARAbV5tfsiJ/bUvrDqw21imQCmOHc73NvDvQkF/9L+iHLryvJmaLzFddUcRtMMG7E4WE1epuuk8qZOVKKJwbxQ1uITFxCHhRo2bugeMwm4MUQtQd/OleWdkN4tIP0gqCrZvlHzk5L+YaxzQWltnakqFLG+xWwIJzqwmjweY4awHC2hn7jDGZT3tSoL+yrZLHc/vhKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ5PPFC362E0A4E.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::854) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 00:24:23 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 00:24:23 +0000
Message-ID: <79d08c87-7af2-4880-9a54-c12f4135d9ec@windriver.com>
Date: Thu, 18 Jun 2026 08:24:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] ext4: fix xattr iput deadlock with
 s_writepages_rwsem
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <o63nwdmeoqscllaitti32enjhet4fcvstv5eh4wooviwxmsosl@mooyvfa5dfqm>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <o63nwdmeoqscllaitti32enjhet4fcvstv5eh4wooviwxmsosl@mooyvfa5dfqm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:196::23) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ5PPFC362E0A4E:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ecf00b-b71a-45d0-4f19-08decccff281
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|20046099003|11063799006|56012099006|4143699003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2IrMz4qp3ea3kvN/VKvRUWVTwTWK/8nk2mp1QAbmKdaCVEmILcjtJQY6VoYxvWg21KsKZLt9oc7MyZV4e3nO1vR7L1SxCTenNzloAkvWnEGzWymExtCgNPjW1HkIuzUoBwZl3NdY0UAjWDrwgrPRGMWu62chgQMoOaBSX+7M8SxThbiTwIut82pbUNzujI+brN2aDwPh8mZBliOE0Oo28npYBX6yE/ye7yw/Bgezi1ynJ8J0AxSRX00UX/gAtJdVQu++wDiHDZ0rBANZU7qhvTEvf2UVpgwOYw6JA+3sVJ6/O/03kn1HU4pp1oQc7fblaEaH+8fucr32piXWI9rLCgw/k1CbcLIs2ATy61ptzDseGGNpfUZwoOTq+uO6d70r95c4aDykswiBi+jAH2VQKBLtkRB8BTOBHiEcUXbh8caI6J8ZQGFOIntyyRdXGS+FIQTmC28aPHrWRxOH76KzqGbrML1RVofvEb0lG/I/DYoLnJfzW0oGx4Cfy/YrV7SNMuG84FaGarHeWJHQuSD5igeua2Q4OToUvquoUEEWRCV/Mn1yfYrZZtzfIR86Q1PjKTyOb1ZSaJAk88+R5Kj7vA9pS1+MdWnPmGvAQjCKMroBerQmrCEOOcbDFpjHJ8gPOclpjXR/R8viFbTdxSqfiw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(20046099003)(11063799006)(56012099006)(4143699003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHNQSUZkQnBKN2EzcE16L0ppanREbXhVRDZUZWxMMjNBMnA2MG9sL1Jrbm83?=
 =?utf-8?B?cS9RVGdpSGtOa00vcmxQWkZjVWgrUEs2Q3p6VDVlTjZTWS9vZ21RMER5ajZQ?=
 =?utf-8?B?NUZFZVA4bHlTR0lGYk51ZUVkOHFDY2RCZEpZUk00ZkhWV0ZBN0Nma2FqUGs2?=
 =?utf-8?B?UHBYVHM4VW5wT2NhOGVqczFUdSsybkZVNmtqSzlPa3V5WWxaaFJjVVdnOExu?=
 =?utf-8?B?SVZZUUVPKzVFTzJTb0twV2l6VDNVYUhRSDhUM2Z0T2ZsQUtFN0RGREdHTGlt?=
 =?utf-8?B?MzhBalVLMVBDNGxhVTdHeXdGVVpLRlBHRFlQdVVwTUlaTkRCT2d3b0ZERjhY?=
 =?utf-8?B?Znl0akg0THMvaGRTUTRKa1ZHUkdYU3ZDdzU2bWZMUWdSYzlodVk0QkIyQzc1?=
 =?utf-8?B?ZzRDWlAwUEM1NDVmbTZnS3JkZWpNMVVGcFdkSVB2R2RnYVhRV3lhY05wQlpi?=
 =?utf-8?B?SnVKS3l2U0E5Z2dtUTJ6S05xVEltTit2MHpmZzJTNTlZWUpkSExvUGxyT09R?=
 =?utf-8?B?L1FYaHN4dUh2UjlVbDJrQjRSQmR4RUtYaEZ3cnZoVTMrRzlMSW85Z1gwYUgr?=
 =?utf-8?B?U1ZHYVJheDdPU1ZnRWs1d295c01sWUo5a0tDbGRRM1hpTDBnOUtCWDZGQ3dl?=
 =?utf-8?B?U0ZMdEhsTzJZcUtKU003YjVReFgxRVhqZzAycDRnb2x3b1A3anZWODJFRWxT?=
 =?utf-8?B?NlZhMVZoaU16TGpRZXRmWGpuOHlSZmk5SGFvdzcxRnpuaW5oQlRTdFRBQ0th?=
 =?utf-8?B?enV0cXlUY3NZbWJFYTZMSm1xdE1ENVJtYXJFQUhtc0FVY1ZaU2I5eXpaNVBv?=
 =?utf-8?B?SGxldUVpMHgyY2I4WjF2SDlwRkNCSEZCNlU0QURIZUFVaE1zbHp4MmVLSHln?=
 =?utf-8?B?ZWdCV1VLRFpBR3dRQW1FcFZaL1BFSWo5V2wzUWtVM3BRSHNpL2ZxWGtMdWdR?=
 =?utf-8?B?ZjlibkFQWVMzaVI5Y09hRUIwc3lOdDZmMkNNTmJmNjVTbDdTbWdwekUvWHor?=
 =?utf-8?B?THcrZkQyNFdzLzFVMi9Uei9sdGMvT3ExRFlKSWhVTGkrT2VPaUNTUlJGME8v?=
 =?utf-8?B?S2s4c3pwcUIyS0kxSTA2d2pkeUZqQTZDU0ZGa280ZHdLcTAzbFpJZ202WWFD?=
 =?utf-8?B?bzdkT2p2K21TL0lXb3Y5enpKYzNjdzdvSEFZQU9kdDk1eFdQcnlJVHhhZ25Z?=
 =?utf-8?B?amtOVjBwZnNGY0xUeEkvYWovQmJMM0tiSVNVR1Y2Qk83cGRaQ2YwdWVKMk1Q?=
 =?utf-8?B?WWl4dEx1MWJQcHd4R3ZocGIvaWgvY2x0Z2pMUmRVcTkvdm5hZUlhakltSHZl?=
 =?utf-8?B?b0J3bk00N0tBZVFCaldpcFdiaGRCVEI1MjkvaUdnSVVmWGRTN2dnZ0VMNG8r?=
 =?utf-8?B?cWdvcUZCZjA0YzNoUEI1UlhGK0xZUFJ5Yk1XWkwvR1B4bzZoYUtpRmVBRytZ?=
 =?utf-8?B?R1N5ck1JRDRldWVyWU9GdTg3T2NBejljTFFPVW0xWnhHRE4yYnI4SzFjbjd0?=
 =?utf-8?B?VHhMUExtS3JoUGw3K1JmZVhOTHJhM1h3cFh3MjJ6UWdvM0JlK3NNSFI4UDkx?=
 =?utf-8?B?Rkp4YlhLbmVTaEMrL0wvUFFPKzFkcCsva1Q4TklHcDJtZkJxSm5kUWpUQjVW?=
 =?utf-8?B?WUxYM09TeGUvNEJoNURmWnNmT1BocWs5K1FEYXVJeHVCNS9SL0ovbFpuV3pG?=
 =?utf-8?B?RVloQWdHMDlncWhQLzB4ZkROVkVad1JoaWVVN1JNV2R1T0dCZFRYeE1sVW5I?=
 =?utf-8?B?VU11OFhxK0tMdEdYTjlWNm9wWjFYQTZGaENDK01WUkttSE82YWZsSUxkdXRB?=
 =?utf-8?B?ZHdISWk3NDlaZFl3NHRUc3hyTGc3cVNmTlgxRXJYK01iN3VaMi9zeW52Rjcr?=
 =?utf-8?B?R0wrdU1LcHFkeEcrNHBOaDdFSWtGa0JoZWpQSnVoa0pMT1JReWZoVW5VRzZB?=
 =?utf-8?B?QjU2RW9yaExqMTNvN2cxUERocHJvZVdtRW1EckxSVGY3VmxkVHpkaU41TDFo?=
 =?utf-8?B?c2huL3Z1QkJhWE4yc0RRaHZ2TXlsQVV5SXFUK1dYeHlNNzVzdG5uRUc0RC9I?=
 =?utf-8?B?bEFKNFVtOWVqNG54RnBMTkRVQ1BXc3RwelZBNmRsNm9WRk40UW1sYXM3WDhV?=
 =?utf-8?B?djRFUk1xc3Q2UzZta0dSNVlPd0k1NUYvUTErdU8xMTN2WVJLbUNxTnQ3OFlr?=
 =?utf-8?B?RlVGWk9Cam9QajlLSGViODhtWDUxbE9LM08zRWh2dXlyZEVGYlkyL0FFR0xN?=
 =?utf-8?B?ME95c0VBSkIycWhJWWhBejk2NFpWQkx3U2VaSnBLMk8yWmJtNmRiNGt4Mkha?=
 =?utf-8?B?citzMGh5R05nbUdpcjNlbzdleWhPc1lVbzd6Nks1KzRqa2dORjNqZz09?=
X-Exchange-RoutingPolicyChecked:
	f9jgJimh3Kmrzjm0ExcxmgWqtKsL8hYCcxKYyzmAxuhkjbHfbbkdNFU6CRoO1XbzNHqWSmTOZcuaNUgRAEBaEBKKtAK0GbsYpUxcf4TWf2AbvuV8OTptXBVO+qGlPAF6/3epboC06wPC4a1UE3xWL9myMHDwioqSTrQmSlmOc7dunaoZizwQwf7gZKuUJtSp28kUTotR+BZVp+CASu3J4fq+02ZCWEr0x5MFrB8UvSqSaooTLVcJRjT1OxMoE4XjinwDpTnIaJ/8vD2z2+gsSr3pVRQZ2RfBP7VfmfKemok9XtxCQki1GXuCQIVL1qWCvZ1W26zfGajOWgLZvOfmGw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ecf00b-b71a-45d0-4f19-08decccff281
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 00:24:23.5301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRK1IZVBOrfHlrytcxGK5oidL5AKIv40njF3fKWSu4f771xi93SD7nTw2Gpcno1AqAH+FMv8zIRKBHklDTU+2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC362E0A4E
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDAwMiBTYWx0ZWRfX6WCi1Kp7kpwL
 VYrG97oDAR/5jpz4j2vJhqjjdxuriTnpVj9nd9ahZsrzVEK8ovc1ZFKwNax4RATsOOtyKiOgK6L
 Sbt+0LtkzMAUBvnqcgaf0QfWxifh55BhAOEHnY68ucTq+1ZGN796
X-Proofpoint-GUID: GzMfCSryeMEXUM4fNZ3AIau9O99LmWJ5
X-Proofpoint-ORIG-GUID: GzMfCSryeMEXUM4fNZ3AIau9O99LmWJ5
X-Authority-Analysis: v=2.4 cv=ObGoyBTY c=1 sm=1 tr=0 ts=6a333abc cx=c_pps
 a=PlHkPQd8QExaI989BnvVeQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=edf1wS77AAAA:8 a=XIeyWjIngEUMxNAZxA8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=DcSpbTIhAlouE1Uv7lRv:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDAwMiBTYWx0ZWRfX6tvaf38d6ias
 Px4ZRrXlwY+1jb5XfGBKJYTcD/eeiHJB7lHq51P3eb0L6IZLXuPr9x1+PX0zjBdha2y0pFE0mgU
 u+cTNhu7vKGmnoT3Qm7p2rEqUJcljRS1vVWCedJ9r12AC+owwCvn0MP9S4lPc6H06WQHK1wSLH7
 77sGI32gOnnZot6Bf+KtQtTqRpA6d9QOE6X00/PLOnTC1E707q3mFIMt5gmM5MovrQyoTFH5jEz
 76fepOA9jy89Ww+jXAXxne2fRAMCDFOL5+PIFezI4DR+FN8LRG59OITWDuNBc/ylxtb1rIXHrhd
 C1CZEy3cVDutFp74dXhZHxcpSIDHRsMLa2vBvRuW/r3HDnJojSZNh4wKY+1Uo7UKy2gfxOH699L
 u7Xz/ox9+6FfrZyC7rL390KnbHFIwXrDEtMJ3j4ipO0YvC4ZIj9z6l6Zo4CB+TEkK/1w0GRlg+J
 xJN4soOPlzLIXs7ho2Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180002



On 6/18/26 02:13, Jan Kara wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Tue 16-06-26 23:15:54, Yun Zhou wrote:
>> This series fixes a circular lock dependency reported by syzbot:
>>
>>    s_writepages_rwsem --> jbd2_handle --> xattr_sem --> s_writepages_rwsem
>>
>> The deadlock occurs when iput() on an EA inode triggers write_inode_now()
>> while xattr_sem and a jbd2 handle are held.  The triggering path is
>> during mount-time orphan cleanup (!SB_ACTIVE) where iput_final() calls
>> write_inode_now() synchronously.
>>
>> Patch 1 blocks the deadlock by skipping extra isize expansion when
>> !SB_ACTIVE -- this prevents the xattr manipulation path from being
>> entered during mount.
>>
>> Patch 2 is a belt-and-suspenders semantic improvement: an inode under
>> eviction never needs extra isize expansion.
>>
>> Patches 3-4 are a structural improvement using a per-sb workqueue:
>>
>>    Patch 3 introduces ext4_put_ea_inode(), which does direct iput() when
>>    SB_ACTIVE (zero overhead) and defers to a workqueue when !SB_ACTIVE.
>>    It also converts the first call site (ext4_xattr_block_set release
>>    path) which previously called iput under xattr_sem + jbd2 handle.
>>
>>    Patch 4 converts the remaining EA inode iput() calls that execute
>>    under locks.  Sites where direct iput() is provably safe (i_nlink=0
>>    after dec_ref, or lookup-only paths) are left unchanged with comments.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=5d19358d7eb30ffb0cc5
> Please don't send the series so quickly. I'd say twice per week is about
> maximum sensible cadence. It takes time (easily several days) for people to
> get to look at your patches and sending your patches sometimes even several
> times per day just creates a mess in the mailbox.

I admit I've been pushing patches too frequently, but I'll definitely tone
it down going forward. The reason is that I get feedback from the 'AI 
Review'
almost immediately after submitting. It flags a lot of edge cases—some I
introduced, others that were pre-existing, or even deadlock paths I missed
despite claiming they were fixed. Most of these are genuine issues. Even if
some are extremely strict, I just want to resolve them as quickly as 
possible.

I mistakenly thought that once the AI Reviewer raised concerns, human 
reviewers
wouldn't check it again. So I kept pushing new patches to fix those 
potential
issues, only for the bot to immediately flag new ones... It would be 
great if there
were a way to send patches directly to the AI bot for a separate review.
> Also in some previous version, I gave my Reviewed-by tag for patch 1 and
> some comment and Reviewed-by tag for patch 2. So please reflect that in the
> next posting.
Got it, I will add it in the next version.

Thanks,
Yun

