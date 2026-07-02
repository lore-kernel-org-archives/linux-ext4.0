Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4883A8FE1
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 07:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782978121; cv=fail; b=c/aJQz3MdSLhhgEeNgfgzQjDo1VkjmPmfjl22rHXQUY2IAEizUKEwlmRzDhUaAwW8So1EsJ+sA3sB5jXFudnnYHedBej6eCrrmEcwLbDob7XOIzbSm3MND2694X7WVaJVyphkWGGt9jmb2WLd46apNFOhwrP+13Ms0JwvPAXp7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782978121; c=relaxed/simple;
	bh=LSS2ZaZcS8vH9A0eslrBJXnCKu1XuKhjoptGfQZuJpg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Svw7lKY/RKNmKuQYGEIdzROsfBSc5kErstr2xTKRe4L2o7HjMJ4xx7xfWLstH6WlyxwgDU+CKl8LyKM+m5JGKZDWH7wvEVtaOTbIELWs4LCeTWxrI0b2+C22QxW7zyFvJNha0wzacht0/3Xn73t2JWo1TF1S0YIeMmlFSzwmNmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=gzTegtbA; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="gzTegtbA"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6625WC0T1097531;
	Thu, 2 Jul 2026 07:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=99b7weVmSH7NI4XE1U20nLW26v+XQ8BIm1OCZmdicaI=; b=
	gzTegtbAohDLGMqjH38MKFO5vxH+3EiLNCABrrQ6ywJ3HuNy9qyHOFpA3NuwqkZy
	wKehTShawBUCyE5kzKzmbIDvYpzvyqFlemgRiC04BfKTRY8az388ZRt9K1onzN+J
	Amra9muWEDVpHBD/hR3NvcQlbaVQJ2Z4mQXSF27J09hiIEFGNYv8GJB1huPbmHRb
	lxC/eqrgqs0GNhPJhGzbHQ4VBaGS79xdp1QU0WMqOdIX7OcXEQhQZ6ttnrUN9OIp
	R0MkjVeLYclOh+V5vSczyAdlC7v2l42Zddt4fu8EAX3matrLQmsKfZ8O/JeqJ5at
	JSjGWsG+dO/wqtVHo49OHA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011067.outbound.protection.outlook.com [52.101.57.67])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f23r0f4md-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 07:41:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDcLNthb5/JlEwjx+Rk3NaiIslrHb1+yxel7YAF5XUxcUBDeTzz8xgSKc2CZaWH1V7k5k1fNz0SGNmdGFPnGhEyyavIHNFzLJghPM3xFtBkzhKFe6jxZ6aYRxvmc/NEPLHCGtNEfz+L67qR17LOyIsqqy5xnNnQDw1DWoteLeo/+fEAMTl88cLup0qrGRtRN2O5BwsOdXploh1YizGiPNzxBQbtRZVw0WzgoNwo+odbasIE1+7+4H4e+jtBCZQRHNjsNcLrxa6IojRiaxm0cB4YpoRa1zGrujQ3WkMDiIiLOvnNwKnI+M/OCdFubhOAOEb5VRmWzpD7rnt/B0dTrRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99b7weVmSH7NI4XE1U20nLW26v+XQ8BIm1OCZmdicaI=;
 b=LW5habxbbl66FSk6awqNReGYsPB8AUnQtiyVyJEhAaA0gtee562rIc7KIE0lp2nDqFO5olNtuoij7IcoPPjC+N+m79O0XLIp+5JqSuJLvzVS9FwwVubVy+/z0hmk9oFLuLuZyfmzMphEgJQyZpjq4iqvc+jiGIQDaTctYoY41LB8IlS042p9XWe672zZH/AyCYD1grvAy1VSXKVsrRGHa4HAe8UOykFoFbSZ6R+/SGuOwZ2c4ow83Mx9ouh0JZSw6mA7/T/FZsi4PEo4Yd1qXlPDalEJfAMZqBbttTxjzw6R2QhBan0DgrFbu6V5UOWiGFqxdR5JY5Dz0NaOF759UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Thu, 2 Jul 2026
 07:41:38 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 07:41:38 +0000
Message-ID: <b0ad6ac3-2c97-4b8c-8dfe-365cff9b0645@windriver.com>
Date: Thu, 2 Jul 2026 15:41:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: prevent inline data creation on extent-based inodes
To: sashiko-reviews@lists.linux.dev, Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260702010906.3213788-1-yun.zhou@windriver.com>
 <20260702013848.129961F000E9@smtp.kernel.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260702013848.129961F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0102.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::17) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: b3cfdde6-9548-4387-2d14-08ded80d5998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	73JAISpA+H0VXYG/whyTp+j3NPWFwfWJCFTT6t4dyb5I16eXSVbkyuLKLQqGv2kRuJcuWHQxzJain2O2oyLraFCTls3iziyzxtzVTb0uzbyJQ9c2YMm8996H5VbFh0wD9VDRb0qd+jhFwP6y/s+6uzArPtIm6sq/QjjeoVOuwKRvkOWnVjUbhYGWjjeN9JSu+LpiAv9e2Pxbj+ap2wFx6XPOUCI2zcJFOIO/yubuvS/qmCHlrvngRQ0C5f9k1w7qp7aA3rbjzI0NoLHrzE1WBJzcyGLSP0bDbMHjTtBqdNkeOAw5GLuS0GPTdmploTzTJmGMVabZxKloUJ0qfS3Z4dNt4haeGL4dhRuuCQTexhTufaX9Wd0DzU4XkUSIDcP2Igvtz844JOMEdSggeE/F55r8DnXRhCe/w6LEtdhIyk4qjmnpAWTW+SzaOS4Sq4KJoFTfqeA3JFwTVmWsNOc2EVNJETfJd930YGmRktfWSgSx36Or8JFwRC7NyjLPDuoHB5YyzKpThU177B1CUCAOVmQiMNTJwRVhLSopTzhKKa7u9rJmJUzOhmW4i3+0rC1cARWMkrdrH1PYzGnHi3hvmqtZaldG7tsbFiHruY4VAp+A/NeEAs15UmP3z7S004YnyzV66mNGN77n3NLp9lCT4POPDoZOgYvmPUp7eyLjj4o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dE1UTGZTQTNzMjhNK1ZTL0dNMm5IVFhGWmVlMnovRFpkMGFmS0t4YTJjcE1z?=
 =?utf-8?B?QWdjdnh6czh1c1FWeURGMmExUElYYUxZV1hqYnVWYW90M0lZRWp0Wm4ybnNx?=
 =?utf-8?B?dmN1dE9INzQvTFNyQkw0bk5FQ2o3SWpPVGsvQ0dNM1FTWEhrelRDdkhVaU02?=
 =?utf-8?B?MTZoL2xwT29aNjlYck5TYkJaOG1LRW54WERVOEdpTUNHS2lRcWlyeFJkd1Zt?=
 =?utf-8?B?aldIMnVsUTZIZ0tIcUJLSkt2Tlp1c3o4YjYzdW1VWVNNQTI1Tlcra3R2UWN0?=
 =?utf-8?B?dFVOU0tVODJ3WTJVV3RUWk94L1Z4T1RyMkhPQnJJQjE1R2dpbkFFQmFEQU9r?=
 =?utf-8?B?VWEwZTU1Y2dlQmx3dXJmUnJZYTJFaDhYK1ZncU1kK2lPSGFZYytURStJekdU?=
 =?utf-8?B?cHZMcDk3Q20wZXV1V0RsYUw5TDBtSEJ6T3NEdjcxRnVkc2JrQUJmRk9RQ0x2?=
 =?utf-8?B?UU12WU13Y2kvZkpydHVUbjYrZE1UbkhIdDA2NFl5VTQyN3kvYzh5dnFaeDE3?=
 =?utf-8?B?VTRsSVg4SENUWnN4RytUTFBpOW1NbG9Cd2t3bmpiVThteEU5eDBranovdGh0?=
 =?utf-8?B?OUpIcWM4UnpwZFdhVnk3Si9OaXNsUXNtSHptYytodEJBdU1OeE9kc0VsOGVx?=
 =?utf-8?B?RVJ5UkZKRXJlVzRRZ3FUd1o4U3VjZHBXa21oRFFUWFE5dmNGY1d2K3gzVXgy?=
 =?utf-8?B?NlNwT1BneVdtQkRlOFJPU0tadEtqM3RtSWtVejhOTm1QNVFSY2U3UXFqMkYr?=
 =?utf-8?B?Wi9QT2VmUHJRR2VzaVhPMVZYejV4RXNOU055aVRiVEFtc3B6K1FSeEozRnJJ?=
 =?utf-8?B?UTIxZzBnVGd4SW95eEwrVTZoU0VRb3o0MjJVYzZtc0xUYnVXTWN4UnZLTE5y?=
 =?utf-8?B?WXhCcEw5aFFLUjV4ZFNVK3hJNyt5cDBvbU5mMTdPQXNZRGV5ZSsrMzBzcjhI?=
 =?utf-8?B?T3lTN2diZm1OOWZZY3BOR09xMjQyWnIycWRnckVScVJ3UlppSWZyK1RKUE41?=
 =?utf-8?B?VmVKVG1HNmNhNmZUcE5PTFBIUzhYaFpDZlZVZ3JtZGsvQ1VLeU8yVWZ6WW5F?=
 =?utf-8?B?UElZY3ZQaTJsSi9HQVFackp5NlhEYWh6QnhZZWNVN2poMjF0MjJIUlZTSVJ2?=
 =?utf-8?B?azVFYnlmVXRtSllqazdlcmVCVWdPWGNTblVxV0RlTVU2bzA2NTNWa3FwWXZC?=
 =?utf-8?B?NnNZRTJ1WHF3UjFyNWQ4UnFSL05vS1ZXUzEySWRHZUhDV0NHSUY3YVVldEpG?=
 =?utf-8?B?R0REdGVVTzVDeVUrdG1nNTkvZ1ZsYjMwUWhrRHFMbnZjeDYxUU14SkxvdGZj?=
 =?utf-8?B?b2NYc3d1OFVqMEJuc0NOY3VobXhGdk0rcVV1dGZxclZyMjI1Z0ZyQk5lUXF3?=
 =?utf-8?B?bDVUeGtqVUVseU13TzZteS9iV0FtT1JaUGlHZHlPeVQ3TytPa3FqVVBrY0N4?=
 =?utf-8?B?d0pYOTZpSEZ5Nk4vR2hPNFd2OEJhT1l6RGNNbitseCtkTm9Ddy8wZFlpTW9U?=
 =?utf-8?B?UXhKa1QzdzFTY3kydTVQTmRtMHFQbUh6TWpHK3BpL1lsRjdvaW9nUm1SNWc1?=
 =?utf-8?B?U1ZzK1kyOU53eFc3RSt6OGN0bmlFb2c4SzB2Njd2eE1vWUNIbmRVbzRrcjhB?=
 =?utf-8?B?UXY0Zi9pOGw2bjIvNlArNUJIeTdteFVlOWxOWVE3SDNuc3B5RFBtS2RDbUJt?=
 =?utf-8?B?RGlGbnJseittNTNCYTZSU3krczU0bERxL0FiNzkrbmF2QXR4d2M0UkRUUzMr?=
 =?utf-8?B?Sm91V3VTaFV4M1NjWVpSSUlveXo5OWUzbGducmxtZWlHSkFvYThLWGhzdm1F?=
 =?utf-8?B?WlZVWENodFBnZU9md1puOFlEOVNDWkcrTE9MWHNKd2JVVmh3SExNbkwxL0NW?=
 =?utf-8?B?SGp1U3NXaS9HNjdiWCtVNkFNai9ZeHhuNm9wQkpId2VJQ2FwRmc1L0YrWUpX?=
 =?utf-8?B?Z2s4ZzJraVpiaWw0RzREVnh6WGEvTWxPY3BqNERGMSs2RjFpTzA4bjVLSUxn?=
 =?utf-8?B?WFh4TXN2MDdpVTRJM3p3ZTBXRnAzTU5ZYVVzQjhCVlBLczFXU09jakJseUw2?=
 =?utf-8?B?WE1PRit5NmthZDFwZGlNeklLNm5rRFJyRlhPbWU1dVZoZ01HL1VNL2ZTRHlm?=
 =?utf-8?B?UlZYWGdYalJTKzlxNG1KRmhIK29HQTJ2YlJZSnMxTi96MUoxbUdnR0JFYkd6?=
 =?utf-8?B?dEdoY1RrWlpPanpOK2N4YUpzU1IxNzRxTDF6WTRyTit2Vi9XZmp2eThBeTIy?=
 =?utf-8?B?ZVJtcUZ2QSszS1N0ZEljeFQrREF5bnNERTZZM2R6NnBvWTM2NitYaW41bHFl?=
 =?utf-8?B?M1hNMkd2SjFNeWpwMHZwNWREdEM0UGRVTU9WSnNETWZTMGdoVEpvZz09?=
X-Exchange-RoutingPolicyChecked:
	K4dP//BlyjWXqchEgDoKHsB+7powJjVIKTJ53C1rS/WCXEnE/5+F+P6n44BBdTAqk8fc08wDbADspck9ZsGWPNsiQHGu4EtxaIZXQydkbrqqriXhauyuws2b9Tz+Lg4kHjToIRUk2BrFNswAO0wTlXK8/uVsmJmoANdY7ZtPKrlphtqf5NSCaXDVcoOmyZTYzo7T06ZznuMkkl9w31o2jyJOxDvHKFUM5z2ckM4ZTd5XiuyANuQeH8kCvq9B2SguLrxibjHOp0FXMo0YcNBaomIz/H7oZehxaoo3aXZKb92v8yeWa4PA1KrvCEJ88nKbyzSHJ050n4RqybgK6thHwA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3cfdde6-9548-4387-2d14-08ded80d5998
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 07:41:38.3888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OvHFgMCxsQSmcPL647GGGtArfZKej5QAaOoltr1lmlR1iRAfktvtgr1WDJ2gt+HKz2p6FTZKH99aXQ96gVemLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-Authority-Analysis: v=2.4 cv=DNC/JSNb c=1 sm=1 tr=0 ts=6a461636 cx=c_pps
 a=mt+QW+PagoHSMqpqf5GGBw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=VwQbUJbxAAAA:8 a=05CdqBOup3ntw2Flk0cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: PFD5husPIqGunLKX4hFlDkQYiyBQp3r5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDA3OCBTYWx0ZWRfX5h+lAyM3b3Px
 zsmXvqSFtWcU7ACK/SrEBUctmAw/WfU42E6+y4EeKhRA8qhhWzjMaTXc7wiiOBJW0ML6Tj1O6Mh
 DGz5FgbtFT1FrjuvwOpvx9D46OhoiHniphAvGYErY2Hz2ne+FDmIFWsnsxIQw8M6BUXtit4z3Sm
 dv9Mg2GA4M8yKb3sRzL7uyX6RSx9G+rBiS7zrQ7dbhXGi5HpDBA2f3cYyH+fO3LICGHsan500MM
 zYBbYMLw5O8pAjfRUd+uVpmFPXb/AmpR5FSXTrUg5WHNeMvyUHAR843kNvOXVN1VN0qvPUAxb9I
 LoML0s1pW7msiOFQ3vsb5K4ijgijz/CBGsl0wIsY0x6V7zquRs1SlkrD9ttXlGDk7dIhCoQnlHp
 TXinCOIrizvbCHs7OhzixgSm5VVS0+cEMMtR2Jv7ZgZ2Rk9p3i5oXhpsqnwbyWQifxSheHIoFGN
 MLZ+D4BWBCcmTWoYC4g==
X-Proofpoint-GUID: PFD5husPIqGunLKX4hFlDkQYiyBQp3r5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDA3OCBTYWx0ZWRfX2kgZp+QLhwrn
 BRmZnErRH5uZSzJzDMFeDYoS6jDedubNqRrDPkXP/jDyfHrGZV1nsmHiLZkAJl6ZokwWCMOKU52
 dAOL8xNnmEQn2g2vcZAhP/x7FHVtUSLbriFWCf9fnJua/ALYGnze
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020078



On 7/2/26 09:38, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> New issues:
> - [High] The patch completely breaks the inline data feature for all new files and directories on extents-enabled filesystems.
> 
> Pre-existing issues:
> - [High] The patch fails to resolve the data corruption race condition on filesystems where the `extents` feature is disabled, leaving indirect-mapped files vulnerable.
> --
> 
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index 0eff4a0c6a6c3..2fcafbdb7b15c 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
>> @@ -418,6 +418,13 @@ static int ext4_prepare_inline_data(handle_t *handle, struct inode *inode,
>>                return -ENOSPC;
>>
>>        ext4_write_lock_xattr(inode, &no_expand);
>> +
>> +     /* Once converted to extents, never go back to inline data. */
>> +     if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> 
> [Severity: High]
> Does this completely disable inline data for all newly created files and
> directories on extents-enabled filesystems?
> 
> Looking at __ext4_new_inode(), it appears newly created inodes inherently
> have the EXT4_INODE_EXTENTS flag set:
> 
> fs/ext4/ialloc.c:__ext4_new_inode() {
>      ...
>      ext4_set_inode_flag(inode, EXT4_INODE_EXTENTS);
>      ...
> }
> 
> If ext4_prepare_inline_data() is called during a write or directory creation
> for a new inode, wouldn't this new check evaluate to true and unconditionally
> abort the inline data creation by returning -ENOSPC?
> 
My apologies, my analysis was incorrect, and I am currently working on a 
new fix.

Please ignore this version.
