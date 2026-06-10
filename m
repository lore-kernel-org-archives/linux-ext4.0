Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E500384235;
	Wed, 10 Jun 2026 07:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075118; cv=fail; b=SZyXq6L429mJEsXsLQIWXmvdsCJdzXjgweev+y0+MP92BfOFRnt3QGD4JpzJXX1Gg35Xh186BdxuwPGq1zAEGrOPu4BzAp74prZMSjaAz8YxpZOEer6K/RvrA+JXDPLmzJ+f+dMxOgYoLK6t+O4qJWbcaeE3fHSoucsCAeDVKN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075118; c=relaxed/simple;
	bh=ZH8vc1z68C1rGzukfBd7iVL1CQFTVZMMT/2JMMGSQIk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pjEdUDOzNTbg0DE7WQw5XNDDoHG4C5AMhBMeD7HFVF40LzNK7G5O0i9dCOz2ZxKorpT4vSeO2gMZUuJ0TRVe2JJC3+W/hS0Rp8CCVnkrw2vfZW1JaxmWCnLcaInk2XMVexyxb7zpcjv1ON+qbRYoO5Ozmz3GceMPFH02+tR4pGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=sZcIa/el; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="sZcIa/el"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A4d21N232765;
	Wed, 10 Jun 2026 07:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=ZajGHKEiP6M68WXGRP5z1vVboUXuKDgq+aB7Q7eG9eE=; b=
	sZcIa/elK7kIr+0ld6k/w1f5LCuqV7MnJBKWo/BwhbBzYjNS2gwBrB+I7VX4Ti4r
	acuwrpRSodHNdYkpstzZ42+oz8nkVDrg9obeWll6mtAj90JNty3BIWwcxn8xcbJS
	5NzpKyUykVJVWUGJECm/6EIdUsHA9d/f09e2RPgXhvaXT2A6Bz6JRn8apMtNRusE
	oDQNpZjJBMqTLe8ghEXjU6aI4RV04m/4bgBryG3m0yeMEWoHqkKVRUpBNTEi/Cer
	yKRoQ4zM9XPN02WL+49hmWj78K8gNZKLwAsVnFvk6MLIhgTMKHkQPoOI6NqozJl0
	WKxY+6dZ91DS7gkzS+nvpg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4epwkq89ed-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:04:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjInay2yofOQynMGp16alReqsjt0SPGDB+Jih3HubCkMAd9D6sVA/NP6T6Yc6sIoyeLRJ/01RMR9LWu+hzKcm9eiSIJQJE3ONThFDXPWElyiRDoocb94CWuVBGNL+T7zYA1KLw0/GMC+LsinAbUzgvP7CeFalD0b7fP41s5qMRbEym7HiE/MUGc7cYtbPv4C71WXqphHFN7FofwOcoyLwrRSrygRdk/5LDnEapHWUPFV7pP/ZpXsgfrLSJduVIajsdLsiu9mI8DEgdI5KQ7xQo6JunovBEI0KFnNsjzM2XnR97vKgzUAee0bY/iNtZ+TCVTB0pMvK2x3PRU6/TXN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZajGHKEiP6M68WXGRP5z1vVboUXuKDgq+aB7Q7eG9eE=;
 b=Nrmgbu4ziRZnDVB2+vlO/Y5zOSh1Vh5BAByHRtaWfvyxvNNnA0FBHHlHVuGS+7jJjqVyCMGT8Itkurs05CSVorSW2KjvBaQI7C+4/EWWbd9EbwSQfNQ3vV+5hous45NwczKfB+AuHA8DL26cukl8lcEOeRHFvppeX90Xrfhq1azi1aYa6H4DWbHDiC8Bq7F/QvV6D4u6atND+qX/73pPM81z7q/urMuws1SeTpHB+5rg6Jmea+1k4vVjGMdF0hQtIAJQe8qVISm4ZOzzVERXq8H5nK8BxIS0T73MBOtsz6sDXiMAJQQFdfwqg3PvKZmUpjguacLVNfgVvVYraY0RqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH0PR11MB5808.namprd11.prod.outlook.com (2603:10b6:510:129::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 07:04:41 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 07:04:41 +0000
Message-ID: <7fe6eec7-acd1-4511-beb7-bac9bbdb9cb2@windriver.com>
Date: Wed, 10 Jun 2026 15:04:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: fix circular lock dependency in ext4_ext_migrate
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ebiggers@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <lr2gyeoay4eai2nujk3siaq7wnqwg3t46an6sipqkmhxarvcrb@tqxhmnstmwnv>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <lr2gyeoay4eai2nujk3siaq7wnqwg3t46an6sipqkmhxarvcrb@tqxhmnstmwnv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0119.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::11) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH0PR11MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 62bb3b7a-cd75-4d5e-706f-08dec6be8ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	NirbbgaAqxJb29A8saDGNGFXZj6vHcrPtCIh0Rb1Z5NVmaPluvVtQkajIqqdhjGg58OocVpxgt4QDhjz4bTEFUy5XazVgaHXSZG0QK2KMqzG4gY0yjeKlU9OUZzDNnTp7Y/ytNVPPD11QAjZwfefWBUa+yZdWJcMRxplznb/kOgCLRQmKbNjBkUW9ke4lsu6lVss42uL8ex8mogVdwDQpGgppXiNA1M6l37AfdS4y7E1kBBkz0GT7t1UmVyfPKoay6SSgryN521LhfitjmGn8ICW2UyxW8XG/6ppEs323KVqGN53lyiPGSudedDi3v1kogDXwS9W38Bg1onOx4+kjv4d+PlM/piRC08STnYRrgxr6VXcvWK9CemuI7zLS4JhJEj8p6+j7qAPf2JqIcddxVcCbEX1bb9/q3Ai10ighe2O8wDryXwrp8L6BOBHuuGTxmYccdW1mJBgaupgdObcY6SOODdVeDbzT/i7FORBQOWcMOj1pG17eNCY5jKTVfuzHBeYRv5TDuMrA+ntPWw2FVQHVsFhRRWrufWg5qus4ns3ttEp+eyqEn5d4smuerjXeCYnlNwixbEz2WZHMeWTMPnga1UwNEjh+jncV9f0bnAv+1hzFpQ+YUNzUvJxAwXFe0+botrgx/pq8WnR9IjuVEBCBe2neIjwqq8d0j1Geu/1KQ0i5YHLl44lxYlu2e1n
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTRlMkpXRVA4TWdEZ2s5cFZuaGFVTkxKYytwSjNyL1U5ZGNrWHNrWXZCS3N2?=
 =?utf-8?B?eDV4eit3MzVtaGFQVnFWNDlFa2E0bmFWOU9ESitaKzducmNOcWNJZ0JpVmJm?=
 =?utf-8?B?aDYvWVVoc3JoME9EMGZnMFFhWFdzTmY4cGZoNnd1TFVZeElTNE9vOUFvV2Nv?=
 =?utf-8?B?SVBPTDE4djdqN1R5a05oTHRhQjVNWDdZcGFhek94K29JYVJtd2V3OGlwMHlu?=
 =?utf-8?B?NjBYMGRsY1hNUkJPUkZHK1N6a1d3UTM2cFNmQW1nOWdkMXkrNTl2ZUIyQW01?=
 =?utf-8?B?Tm9QOGtoVlRWQmpWMjF6UlJOQXFyY3gxQmdWc1RISEZLMXhFUE1lM3RwM3I5?=
 =?utf-8?B?ajRsRzlkYzFveDBMV2pWcC83MkpPL2pwMURwaDVYYjFJYzlWS1VreWZ0SjQ1?=
 =?utf-8?B?Mk9DUExob2YrN25RTzIzdDJad0ZDd3NnT0hhN2c2QSs2Z3B0M1JNWDUvc0R1?=
 =?utf-8?B?V3ZmSXFKcHlmaGNydENQcFF6UERhb3hyVkdiSXY4bTQzYW9haWlBWjgzUGpQ?=
 =?utf-8?B?aUtQTGF1OTduUlVuTXZvU2w2Uzl3dWlnYXVMdDhqU3hiZGtYNm5QK2VBQVl2?=
 =?utf-8?B?NnBSN3grK3BuL3NlS1hucUYzSVJQZHhqOUZMcFdJajkvbncxR3ZBWDV6d2sw?=
 =?utf-8?B?SWtwdHNpL0tqTGc1bXB2QjZTaGhpZythdjYzeDdOWEZoOTRRTGVXTWk5ZTBZ?=
 =?utf-8?B?M0dCb1hiNGJRby80R0x2NkcwV0FxUW4wTVZORjdqZk5vYkkwazBsMTJCaUMv?=
 =?utf-8?B?TXNmcmhIWnJtRlNvci9ZbWxpcVF5Y2FtV25JbGpsZVJ4WU9hRytCVmhVUW42?=
 =?utf-8?B?WExzUkVDNkFIUHVReVJZSWljRG1pR2QzTERnZWdnN0pnVk8rWXEreUFML294?=
 =?utf-8?B?cnJ3dHQ4SkVBVXpQTDBYNkYzQ0ttYldjbklXUzVyTE1xSXNpZU1lZjNLQWJC?=
 =?utf-8?B?c1g2Ti9IbkFkV0JGMittZXZ1VkI1WGJ4NkRxK2cwaFk5MjVkb3R6WEhsUUxa?=
 =?utf-8?B?QU1PdDhpZ0dvNU9qbWdNblZvMFkyZE1SK3FDVm1mMmtJT3I4Umc2RDRxem02?=
 =?utf-8?B?TkE5Sm5keGdoNGZDR0lJRHJtaEpyVEJ1NjRwd2tLNDh3WUY5ektBVnVhcUlW?=
 =?utf-8?B?b1BSY1lNY3Bhbm54VHRWV0FHNGZLRUdwQUY4UU9vUDg5MHJXQmFIa3pyYTRj?=
 =?utf-8?B?Wjcyc3lXM01GM0ZUUDRwUmJxQkdrK05qcUVDYkFaUU5GVGRzYkgxUnE1bEVF?=
 =?utf-8?B?Q3hFU0pLZ2NOQTZMZGZxMXRZSkNnOEFiVlN2b1c4ejcxNU9LSlRoYmdUQnRU?=
 =?utf-8?B?ajZiYUdRSG5DbWFwSDlxZURtL3RweVBZckRMeDFzQ3pzbHJqWmxuSitCY0F6?=
 =?utf-8?B?K0FabjUrRFRXS3BreHBtMHdLYTUwWkp5eWVoV28rNTc5cXdMRXZLVkFuRWE5?=
 =?utf-8?B?cGYvdjF0VTBBYlNHNVJPeU1LM0ZlSW9NUGlDYmtwSlEvZ0g5V0NWeWF1allm?=
 =?utf-8?B?Y01kd3FHL2pxcHJRREx0WE45WjIrVm14RGtSeDF6dCtjLzhSdm14c2IzRnE4?=
 =?utf-8?B?Zkx1SExVWUVGR29BZnVCb3JoVmtxWjZZVCtZWHpmUldKUGFRcFZWai9XMS9a?=
 =?utf-8?B?YndZVUNyQkdhdTR2MUdVZ09hZ2pYRGtTNUhaVTA5WUFublpmYkp4Z1UyUTNG?=
 =?utf-8?B?ZUJZUXdYK1p4MWo2ZWJ2UTZONUcxdGJiVUEzVDVYS0EzclNJdmxnS2dzN1pw?=
 =?utf-8?B?YWN2QzdESlZUWVo3dVlRejBNVlBORjUra2twNi9yeE9HKzRiYjZzRGVlaS8y?=
 =?utf-8?B?cW9pMi9qTGE3aXg0UHVURmRaWUZmVmI4dDMyWG9tL1gzWnRQRkhvUERWcXVq?=
 =?utf-8?B?MmZyc0hrMVUwaFh3L2tsTTUwMHUrZjB0QU82Wmtwd2VOS05abzh1anFab3FE?=
 =?utf-8?B?QVlvWVZ1eGtJUDlkMFc4SVVreFZSNXJpb3pTT3pKSjdFNkx5Y01Hd2J6dlM1?=
 =?utf-8?B?LzJhbDlOUm0wRDA4dDVUejNiZm5ZTjhJdytwb3Q1SzN0QmFBVm1naUpIN2kv?=
 =?utf-8?B?SEtOVGhVSVlGdENqeDF5MnR0N3ZXTGNSS2JhZU5Ec1phaGtZUVZWTU45Z3Bi?=
 =?utf-8?B?cEtYTFNiTFA5Y1VyL0R3VU03UWFkUkU5S1JRSHdMTFNGUm1yejkrTDRpNEtz?=
 =?utf-8?B?MmgyTk02MkQ0a1FkOUlFVWxMbks2OHNqaXBCSGVRRlV3UnYxYVlQQkRTQUgv?=
 =?utf-8?B?b2tEeFBkcGpNejFGUjQxSnlFd3RkblhhekdxTHBRYWNXenlLUnZZTmZKSklI?=
 =?utf-8?B?TXdpT2prMXIydTVFZm1qb2tScEJ5eXpyTU05SnVZZmRUOWFWZzBJZz09?=
X-Exchange-RoutingPolicyChecked:
	q3iLNgBqU31PzX8WeJV2s2ENEMw3y6lkaPk4gI9SeYfnbBBPyVq1r+q9kTeHZzxVkoL1oimoIvWOKlcsP0A6Yqwo4OPZajwQ+KSzqh2Alb7SqOtM3rjmPYmGN1r5HJ4m+PRiLaOjrR4weidcxNYudX/fEpyk7JRpi9CccRe3AdWLKJzlyahoRgvtxZnNMTsG13xVj7VkHLqIWAR3e0Jfu44m79qSMvHcZFiPcnPbNvnLOlTH/Y22ittYRqsnXkVCS7Cy/sEkYg4etd2oHrik8B4vNoFSjHsiS/ERiG0FRnSmh35iedk42m0J2Ej/kPoRO6hEXCuftoA7Z6XXX3rY6A==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62bb3b7a-cd75-4d5e-706f-08dec6be8ad2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 07:04:41.5911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKN6GcA8yMdLgoRBbw18X4G8myZVdrF1e+4kpStnOBXNj1a8M0tcE3NVTNvu+9vwWBDjIj/KPLL5AGPOOW2Rog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5808
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA2NSBTYWx0ZWRfX6IzpIzlpxa6a
 iWouHlLBVZaqkKx5QXu1scqnXj8YNuhQ9Xc6vckyPDh+E/VjA0D1LrEeBu6QHRE0+HQslce7sQi
 KYyRjhaVWRafmhoaROMBUnxEqfTkINdZg5l/JQU89GO58SLfGIxgfCGOK3rGRmJWb8xGocafzAJ
 RJZtj7ckDmiH8aYtG2DB/DOZORXlP15yAy0yIR7wqe0fbT8Pw/54qqEnzoxPO9mW/Rm+TYFBIV6
 JJOFNcezbM5QyxiKgQ8Ltf2T6rRsxn9F3kuY8xAv5XIcxg9LvwYqFdBIq40BjpmdCs2h2McrP7K
 QiXspIsZKv8FLUTnsbniyrptaQs3mZxefNPA8nBSbqHQWn3XxWHsHYt4BVpjpAogOIQQ47mGk2o
 tLs8zUAP/ylnqY3omAjnQFzIxhJqPeqrhFgA5+ICDPL0jrCNPIrv7Q6uMO9rblYr71C8th4W+ff
 O9mPTd04yYzEe0M9/sw==
X-Proofpoint-ORIG-GUID: BVZ61kRkvWd5t26KKij93_KCQB9iAEAh
X-Authority-Analysis: v=2.4 cv=eOAjSnp1 c=1 sm=1 tr=0 ts=6a290c8d cx=c_pps
 a=LPqnct3xGwQwGN9n+XDEZg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=Li4Xu6E5mock3qN4Y6AA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: BVZ61kRkvWd5t26KKij93_KCQB9iAEAh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100065



On 6/9/26 20:05, Jan Kara wrote:
> Looks good. Feel free to add:
>
> Reviewed-by: Jan Kara <jack@suse.cz>
>
> Just one nit below:
>
>> @@ -591,9 +592,10 @@ int ext4_ext_migrate(struct inode *inode)
>>        ext4_journal_stop(handle);
>>   out_tmp_inode:
>>        unlock_new_inode(tmp_inode);
>> -     iput(tmp_inode);
>>   out_unlock:
>>        ext4_writepages_up_write(inode->i_sb, alloc_ctx);
>> +     if (tmp_inode)
>> +             iput(tmp_inode);
> iput(NULL) is properly handled so you don't need the if (tmp_inode) check
> here.
Hi Jan,

Thank you for your careful review. Should I remove this redundant check 
in v2?

BR,
Yun
