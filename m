Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0473FE350;
	Mon, 29 Jun 2026 10:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782727597; cv=fail; b=jB+1yrnVG1W+b3nD1L8ipk2SLeCeUA5gOwi6epe3iipqjlO+qELvwimky8qcf/xofYu18wDUb8+c2rUKgn6YRPF0ZG8vZ7iLJL1EWnFncZH7ogtiH+V+bu58p2JxB0NhJK+V8sZOPl015etOPs/S0FR8bg0jsH6jluHAiBdyrCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782727597; c=relaxed/simple;
	bh=QEwj7I81lwfyjcLkZpxOm9zZ4/CyQANxJThYEDtlPN0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DrpoW1NagvpCwkbIrTBpwEsfAn3xL+tiODPFGU0IRoATSLVO30marT8/G3Ewb6Donmox7HYE9W+cJuuVxx/4ptKAmbLS7rfZes7+LTchE7HsRJYJnyneThoKWIl1lapgZj+Z0ywpSA6KbmlAek6QplvuoRJ6tXtVPMUvTU3CsPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GWaGMXxY; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GWaGMXxY"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T6kACd2095578;
	Mon, 29 Jun 2026 10:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=r2oF2va9rAJanXHrP19l1YxbMyQmBzcbEadDOLx6L8E=; b=
	GWaGMXxYQXBVFS6dJbqu51lcyRZlzbiqADpsHMd0zkXa0goZNkPScgQkRvPjsIuS
	1T9SE2Gea9eymFusSZImiD4hbu8ruKWS+xk4gYcszb7JBBsSr0P/MH6TOnNLhS8z
	dpqHmJTCpSyYorSxWrceyO4ryLUiJc3rIh8hdcxGmg1i0+YNDD5YswpnFqFzma/w
	V6oHSpY/SKXAnrbuHint0e49dBcqQb0zrEiwP8E6fQUhiUQPneHPIY0Sx8PWy5r/
	ju8UEHOz1YyfY415Fq5/q3aLITwrzfTxpduSQchgmdzCxUQ4JOUR2H6R+4IpuMDv
	fLahTk9RxGtbKbvbESr8NQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013063.outbound.protection.outlook.com [40.107.201.63])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5hybq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Jun 2026 10:05:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3RZwzpc78S1UGY1A2cX8I0elUOTfKpRIcKEk5ZT4pgp4K2/BbFTSfq2bp6uaoGC7LAT7WEbicdi9Ucdt9bFSnWol6uZ7GShNQsN+5YGkxD2yGl1jL+kPS0I6oNYBNzKrsnZgEeLZDYcTELwTe+yASYiGhmiVx5aHGlSFZ+xiqKdZoWgxdyD/VPwlUagStNFyPHdnGtLG5VtTwolpMre3AdJ8ocpR2IJHQZ9Wg1anJo7bOAkrys46EbC6drICITs+j1TVjuMip+j64R/eYlrbqf5T0wYUABDebge+W6gLRc9fIF7i6zgBVoRX3p5rgU13yUUhuYPvGgXDXXEbppVwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2oF2va9rAJanXHrP19l1YxbMyQmBzcbEadDOLx6L8E=;
 b=De2vPNJdjO3d+X51mzKsf6a653YYOnfPIU1jQJrBvEKy8aD4rrUb9JFNS7Za7Qa9qAvG+VkpL7fR3FrjvXEmFypR61ak7OarxfmC3naSwOwA+SySYnutTXWmiBOC2X66puaVvwKhT1BnpdlFMy/nk9lP1FBhs4g7iCSQ2fgCsvEQsckupVDMz8vednrAxakK/b2QVRVJqBvJmudkXk0qmQ4Z6vKt18TdjDH5aaPJH9c2JUg6ICcdw6WbhxcuUzBmx2Zb34/Q7yGZQpAKNCNuEtYvWQOV1FH5YVkyWCVDeJpNQOLxkaI/NAESSXnmWLTHQtmlSMTkKnCYTtYW4m+IFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH0PR11MB7469.namprd11.prod.outlook.com (2603:10b6:510:286::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 10:05:31 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 10:05:31 +0000
Message-ID: <5f2f758e-3ada-432d-b391-129f5ac39528@windriver.com>
Date: Mon, 29 Jun 2026 18:05:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/5] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-3-yun.zhou@windriver.com>
 <t7ewb5or7ybrt3mwbnjxjddo7ok75dopf5czoib7nyou4zwdmd@plj4clfhoybl>
 <b7f1b4ea-6594-4dd4-a035-f555a822d48a@windriver.com>
 <hxkq54njehj4sin7ymm7kbpqy2hs2x7w7evi6qurxsyjsa3xvx@pzindvdeaii5>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <hxkq54njehj4sin7ymm7kbpqy2hs2x7w7evi6qurxsyjsa3xvx@pzindvdeaii5>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0069.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::8) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH0PR11MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4541e0-c167-411e-fcbe-08ded5c5f3af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|4143699003|6133799003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gaCoB9iv9b3vBSN3sV1vzBsj0qE0eNaW4Z4HHuIB4mJLgTFxA9XqnQUenlVMV7yk9lRr0mYXQ8WRti51/3kxllj7Vl76AyMv/FAj/h4hiRixuMkjwvT9y7FqMaHV/V32eqz81U87598RI3GiIaia7zMHXqUCWshmrqLDOwhZ3w0EMUCt9whtMvYOm4+S57Fh2Z5b1+ufN9XyLa/TqjHU7uBfcEc41Dcbuo/YQpE8bkYewF+zBmFoXSPnbPWLuzIWlNmW6+L/4zi5VffJO+kkeBT/JyMwkheyBSoqhwWrJ1+zhh64JtLaIrA27MMtavJ63McM0GnbKtwMkmozNJYZ23QJOrPmym6q8AGR33QjX9Orek5f52GfSQhXYVgOf2RnrEskq1CGCbAL6kxcfyfpNfIykwMrsvR2R6grS95nrnrVlwEvTfHgOz95C0XziF/jpnUN/0qC5KXcD421h0fLEBsXgPLq6GMONjIjVRdchJ/reBd6CZb4doSby/EC8P6VG69S9pSpXzv0bIH7PUl9l5UDjEyAK32Ysm+F0fZ/k99qvN9ognajFhCPAdA55IvKW+pGL3cG3efwhwJhFdXNyIJdIWnCZlJVumkoQH1fz1QM7aaRSR+Lidv9GW/zcInZT09YInFDQUnuXFF9s+Y2epPQM8dSjeyP/xsb6uQFHWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(4143699003)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTZoU3RiUzhWZnhyTzQ3N2tUZ0dLOENLSzM4VjhQa1M1djI5am5POG5DNzJu?=
 =?utf-8?B?NmZrcHBOSkJ1SmRYU3huOUh2RFg5dXI3YkZHemt0cHE0MTRlcmV5azRZVGly?=
 =?utf-8?B?UjgyTG1mR2pFeU1obzR2US9sMmFJRU9tdTZGNE9CMUYyVHZZNFlPWTZyQU5R?=
 =?utf-8?B?R1hUTXllRFo4MVNMWU8zT2ZpcW16ZnY3ajg3UENyc3B3NGQ0Z05WaGo4Y0Rz?=
 =?utf-8?B?enpiNk5JN3pSQ3l6T1BtRHdTa2o4TEE3SnNuQXFBTDhkOUx3VDZLdkhtMEJm?=
 =?utf-8?B?RmQ5U01XLzhTS2dQN2NxRTcwc1VHQnljNDJaSFE5aG9RWUcyMWkxbjFaQ2Qz?=
 =?utf-8?B?TXB0c2o1cU8zVU1RdVhqdmM0NXQrQzNrWWNBdWpxeHZ4K0dPOVVxTERxVm1P?=
 =?utf-8?B?TW5MdXZzZi9mZXVTd3gydWZHMm9FeE9sRmgydmxwUnBKb1RPbE1KcXNUaDV5?=
 =?utf-8?B?WVAvUWZrdGhUc2VnVVlDSzBUTlMvdFVzSXpDTkhaYjZzQUx5NFl6enFvVk5Y?=
 =?utf-8?B?dGc1MlcrSGRiSEkzbU1DUDh2QUhEL1RLa1JNSjF5REZKUmtWQUJaSUFLdGJy?=
 =?utf-8?B?aTlDQUdIWTF3NFFIbHhlODBTdEh6aUVpS08rSWJDZmtwUzVWbVEwS0FXUlZq?=
 =?utf-8?B?aHZWeUVacjUzUExVV1FLU2E5TEprS0Q5dkZXT2UvcjdNejRzb0w5SW4zNHJY?=
 =?utf-8?B?MlNzVEFITG9ndElnclh3THdRelZKNTVwOWJLcC94VjFOWW12R0NMZEFoNTUx?=
 =?utf-8?B?Z0R5TkJ1SWhZMklFQUJCMHlMKzJlRkdudDdsSXllOXRWUzlReDZmMkVncm1x?=
 =?utf-8?B?a2EvNS9FdWQ2aS9LNGRybXF4NTgveDV0dDg0SHN5a25YWHNxSEdTaHdmcXNR?=
 =?utf-8?B?SHFYOU5qeXRHUjVuZW5SY0pHaXMvK1l5RVNpVUQrV3UyS2l5UHhwZy9SY3Uv?=
 =?utf-8?B?RXlGMVd2bVJzTE1tWFhxUGk4VGhhMmdDYlhDNjRhb3dlMmdaRFJraXhYRC9q?=
 =?utf-8?B?Zm1iazhzSFpUc2tVbXY4RDZvY1NCOTI1cDRKSjNBT2VxWVBjVnhvMDhLNS84?=
 =?utf-8?B?aTRkVEFFVnh0QkE1dE42VzdsajNnZTVLRTRWZVJISGhFbmpzdjhWVThNNVp4?=
 =?utf-8?B?UHRrNTRtRzdjaXRjQ2JMZ3MvRkxudm5yeUhaaW9LWVF6QnAwemtJcHJFVFQx?=
 =?utf-8?B?NmNjamRqWWltZFZoT01FVUppV3dVcmptT1lESTF5Y3RVQ2pyeVd5S3ZXMHNQ?=
 =?utf-8?B?RE93U2s1T3c2QTlma1V0SExJMEZIektON2k3SkdEcThOZmZWMUdMWllJV3VC?=
 =?utf-8?B?NlBsam9oRE1kVHlyZmQrejJxLzYxMzJrbDFaZG43dVV6RG85blhKOHBpNmVS?=
 =?utf-8?B?cVcrMUNYZ3gzZlBNTGpFMldscDQ1NmtPQnRmL3k1NHNjWFNTTml0cDk1N09S?=
 =?utf-8?B?WU1lQjVnZHFmZks1WW8xM1dFNDQ1eUR3aTRUTVZIcVJVdWRNVTRjVTNJSVNl?=
 =?utf-8?B?OE03RW8rZlRIcGkrcUxTUmdHbHp5WXVjRGg3TEZnRmlsUzJOMG84YlJ1RlNk?=
 =?utf-8?B?S3M5NGFzQWVSanZXbzI2L3hydUtJUE8wNHpJd01hWWxQeWpkUmJ5dDdiM3kx?=
 =?utf-8?B?TWpoeXVtMFJSa0xtRFFZd08wNEN2N090WnE2Q1JuaDQxaUZqcnBjaWdvbG1N?=
 =?utf-8?B?RE1JNklxeFliM29vRUtQMkwvOXJ5N0I3NkE3YkN1Q0ZIeU5FcjRIL2xRaXRs?=
 =?utf-8?B?RXhISG1Edno0NFFJdHpOWDdoNWsvRUpsVGQ3U0ZiTzJZbFlKVWM5WWZCUlRO?=
 =?utf-8?B?TVRUR2J6eFVYRFlQSkoyTTVaN29UQlhpNVJiengzU0ljQTVZd1p0RmZVa1Np?=
 =?utf-8?B?SWV0dDA3dURMcHlUWjN4ZlJjUFlMNlBkS2VrZGdwbWJyUlFkdExzTXpMOWRq?=
 =?utf-8?B?dWo3V1dDYjE5NUw5eHpYY3dQV2MzUGxldzM0aGRvNkUxdnB2aVJaSVBKbkc5?=
 =?utf-8?B?ajVVUGZuSkI1QjJCQ1BzMjRKM0NGNy9jNndCS29xM2hycVpjY21jcHJrVkVl?=
 =?utf-8?B?eVBEOEVnSmlFSWVGbHI1V29qN0FtTmplTXFJMEVWMGd6NWxTbmhGNk1QLytM?=
 =?utf-8?B?Mk1CZS9ZSUJjMnVBRmt1S1EwWmVMQ0h1ZUFtNXhaMmFnb1cwYUtmNUZ4enNX?=
 =?utf-8?B?bWxTZFRJS3Y4ME9pb0Z6L1d5aGV6N3kzZWNsT2FEK3E5cDNVektObFVjZGha?=
 =?utf-8?B?RTQraE5TajFwVk1mUTRXYXMyTndWazlDek9weFRKeXc4S0R2K2tCUGIzWHBW?=
 =?utf-8?B?SDJwMHhPc0NMNUJEeEx5bFNMaHJaWFN4Q2pTTXFUVkZNdjhsV0c0UT09?=
X-Exchange-RoutingPolicyChecked:
	llS3M3smeVPxn9VdbzsmrpcukrvH4Mb+WH4X6oBuvR6yTRq4QfSSqiOc6bsnPOzsm8/n4jpZK3THMBUu6TRRW5Fuay3Sc2VYSxBrurrMJ05CBWJ2lhLIktU86nt0m4ks9gcCw26zft7yqUvjog3dCclW9dSa0WSzk754XaHvWAqCAZXqv05VVt1oVVOIN4tIs8a05jFhNIaZiX7EHV8Ih9HcoVc/r9N4eytGsr2y8oGdscLTQGtmCXhLNyMplBqSrJQDdszANmGC/Ho8RVjbrNRz/hZu5EW3F5rZLdHxwcX1b87ipq0FN4iaE40DnZbWKGtlMgZ8/3tmyu8SqQY6wg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4541e0-c167-411e-fcbe-08ded5c5f3af
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 10:05:30.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2cMD10Y3cW4+CzeEI1DTk5ibhpSA0dNJd37RdSDOHa2gTsMxFZKAFG/uiJTOWbPIEkT/X2Vag1Jenuvq3uNKgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7469
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA4MSBTYWx0ZWRfX/dyyACH3tf0M
 YN7yiqPT1pw1Rk9s4E2FqXkDyTkgG8hBuiaw9DYBvMtaCce5nijYJOqJgIiVMPwES0M4a3m2SIc
 37BK7YtZA3AjX7Dcg6Tk26SpV0DeW49Sh0x1dxcuh/M6+uLFncrq
X-Proofpoint-ORIG-GUID: hBb64IuF-4Sn_mhUKNjOo0ysWj4J5f3E
X-Proofpoint-GUID: hBb64IuF-4Sn_mhUKNjOo0ysWj4J5f3E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA4MSBTYWx0ZWRfXxRdZkwAFllL6
 sgcTMD3DNK3FzVHgqxHwoj/sPH8FZqhEuyAZVMQsMMPjGDFoEciIZWjak4pj2DTW+KdmbVBhlFO
 rnnSNcPDfuO9YBDt2S/4MjrXna6aqj19AVoJ5YdQUy1ZmuGYYMhIZEtgffs/hJruoLzFVimgBNW
 ABVNt2tlzKB91NsQKcbKRxIEyi5WsgGcveq4chBINZ6XGfdFKN1CWGXikCY59+86MyOKUnZ17h2
 VwgY0vlX3hjt6zq3Pc+md2x/8fqykzmDqIe5I6qSAfz7uDBNr2sI3nFi7NOPD7++JQa8iBWkP0s
 JqU98OQpqxbkDUef+DA4WG52xTsj5mJHPD3fXoKmTxhaT+JsU7RspV1mVqxxunabiFFPeKqVyaB
 Ov+7+cRCViJMq/4YHtTg4O7jk52RH+O04IzPEsI/fEP4Ea6NwJPyzNBXP43QKVShjUIHtM0gjHZ
 uTpGrLRjj4Eot1TzUyA==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a42436d cx=c_pps
 a=42Ag0VRmng1YD8CjqzuPTQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=MP-ijHCG7dBoClclzUIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290081



On 6/29/26 16:23, Jan Kara wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> On Sun 28-06-26 16:13:18, Zhou, Yun wrote:
>>
>>
>> On 6/27/26 00:53, Jan Kara wrote:
>>> On Thu 25-06-26 23:29:38, Yun Zhou wrote:
>>>> +
>>>> +/*
>>>> + * Drain all pending deferred EA inode iputs.  Must be called before
>>>> + * freeing resources that eviction depends on (quota, block allocator).
>>>> + * Loops because worker iput may trigger eviction that re-queues.
>>>> + */
>>>
>>> Can you please explain how iput of EA inode can trigger iput of another EA
>>> inode? So far I don't think that's possible but perhaps I'm missing
>>> something.
>>>
>>>> +static inline void ext4_drain_ea_inode_work(struct ext4_sb_info *sbi)
>>>> +{
>>>> +     while (flush_delayed_work(&sbi->s_ea_inode_work) ||
>>>> +            !llist_empty(&sbi->s_ea_inode_to_free))
>>>> +             ;
>>>> +}
>>>>
>>
>> On a corrupted fs, an evicted ea_inode might still have xattrs and point to
>> another ea inode, which creates a potential "re-arm" scenario.
> 
> That should be caught when loading such EA inode into memory and result in
> EFSCORRUPTED at that point. So please add such check to __ext4_iget().
> 

My apologies, I overlooked this. There is actually already a relevant 
check in check_igot_inode(). So, the Sashiko AI report is sometimes 
inaccurate.

     if (flags & EXT4_IGET_EA_INODE) {
         if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
             err_str = "missing EA_INODE flag";
             goto error;
         }
         if (ext4_test_inode_state(inode, EXT4_STATE_XATTR) ||
             EXT4_I(inode)->i_file_acl) {
             err_str = "ea_inode with extended attributes";
             goto error;
         }

