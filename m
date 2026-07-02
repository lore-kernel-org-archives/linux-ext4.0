Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC461433E8B;
	Thu,  2 Jul 2026 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783004182; cv=fail; b=fcH64262zxkjPQp0pQnDppbgiiuPf6lmB0EgZwXhd8pU9W7qG4CMXBWKYIt+/5a3Q6UeNaPBxVt/L2rFbGE6bcZ1Ll21+wnLvg+30qRc1OH8c3iFznVR1s3/Mv6eh0GEBC/p6BawZNOZW9CYBcnQFK+7wimKVXv18smtiym16RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783004182; c=relaxed/simple;
	bh=w5qLc/SSvFXJk5pyB3roQHFeg2gAO8GesV6AR+4opUc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ix9JQct8hrQoa7EzOBUamb5yiCV5a2cK7yr1HLMJPkABVmrFKo1W3ddPsbq3CK2teJjW/lLqQrWnybXZNZuWWtwbIVEYVZkIEFtkahXw3ZCgx0EVC8dugP4vv8y/2SKgP7x3GmBPvXOuvoTrZYH1dBZe140/uh6Uiv0mtdsHrrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=aROfWCjp; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="aROfWCjp"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662E2MPH1933515;
	Thu, 2 Jul 2026 07:55:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=vTKb/wk+sosy6EuFr4VRMd6aLBGa1sPq3nYgnzfWC6I=; b=
	aROfWCjp3GN9r5qQoG6+b4D2liIxSVj4lb8eU43oqrR/xAuZO3pgnWNCyQRKXYYr
	gyUaaMfoBHqs5P1xy8Lz0lTremj6vBe+t/wG2Dm+hCsPSG9nIY2mgaBfhtovnEYz
	wut6fQ6MxDP3x7dYHLXnLwq4waa5Uc5giQf48+XMT8nlwEKQsrydM8rVc0g2Um0R
	XMvAh8tnFqrPM98FECsCYVCAuen/cK6J+oHX2C+YiAyClpgZJtCzzMWdujros449
	qYXXRLMENwdVMIqUT7HWEUZgN/VkzszSRC5N69d/Lmq37rx7PIYKDG2PyXio8gW3
	sqbHjZK6KjyluNQQOitehA==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f29syqqb0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 07:55:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXOySn/eIj88QPZ9mxB3rq1jgWWEugJ2S0EeVZ4VP7uxCeJ6dHTendAB+uVP9fCoH1lPII80+vXNHMlvPFSXaCdwcyqEUdSX2dzDqbuiVboWXlzxvJslcL1bnhmXK7knW8lE8wcUFPxEfcP7dsjG95EQKoDiPz68IPRBgBbVsJZV8OSWQnjEUSN8BVktN/eC50anrakvu4EQ0KarWuM0Hj7GGYG6LeWY35UqAA8FUF1fN7XtSGMG4rZF6w/drgONpFfO3sYV6u/3O6xJefcAEytM0XuC+k7x4O41A/K+wObvxNjyaBoKhqCitbRN01QoY44PsGUvIi+/wutevPljfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTKb/wk+sosy6EuFr4VRMd6aLBGa1sPq3nYgnzfWC6I=;
 b=G4r/p9t3C8wguEJWn/HPzgJr+Re0N87da8FWXXQPFSD5pMNp0QQxxg2UiCf/N96QP5mUBwIh321QQzmG5vDJpMI9CKwuhSOtsJjvPpAQBxFI3dy+MvdpbVyLnxhU+ypPJMZy09TVlSx71SdfTIrtOKwQCdFVuG5/+YneNua3hGHyRf/KbUKN21r9F78MTf/JXhoO86JP31gkjqG51z/1EGaLMTVHtrEQCnKCqPmNeEVXd35ytTWhn1bZqI1Qx4PSNydtLTIQHCj3qCs49+ahTh7GCLb1/Q2Fc9+/yx6DN63F0aezFYuth/nqlSWuvT+84IESr1lR12nUg3u7WeqMog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by LV3PR11MB8505.namprd11.prod.outlook.com (2603:10b6:408:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Thu, 2 Jul
 2026 14:55:40 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 14:55:40 +0000
Message-ID: <12a0d660-2794-4dc0-910a-3c63155624ba@windriver.com>
Date: Thu, 2 Jul 2026 22:55:31 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
To: Jan Kara <jack@suse.cz>
Cc: Mateusz Guzik <mjguzik@gmail.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        xiaowu.417@qq.com
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
 <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
 <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
 <mqchxi74vrsmsitr46gtnw5w7tooj7go2tm2jadg4mktppjafc@5uplsind6ooq>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <mqchxi74vrsmsitr46gtnw5w7tooj7go2tm2jadg4mktppjafc@5uplsind6ooq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0150.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c1::11) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|LV3PR11MB8505:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfe1ad7-5dad-4df3-3af1-08ded849fbbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|7416014|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	CrJe2OpVvzPX/wEdqdd6keRqREPm7RQUX8hPpI6dmGn5zhMhx6eAtfYVOGFYJVAWgM0OCEsqEDjndWVoAvk7CkfdtGZTtTHxsGbMSer9GH9o41nLPgBJk1pNxDbsKh4BEsn79hpKfb8vphJSpX+qrrl1W2mahDBrWPzmF1PX2LOwX8yNkYb+48D5IAzTyy7YR5WWXrppVZlkCA4uG2dq7OUhfWDg6NAtfWSFa2UKN4H1PYlRAmmC3/d4dHokAfLHv5w45nNjsQpUI8XzbzAG2vHhOpxCSDAE+ibtYv3jDB6mw3/NT/Rmma281QT4gAWpC08iXHCSSG5Ilx7bdEllqoozjwHJmb4xCUL8VqCA3Nwb7wULJxM3hxCoFfw9U8f6ZA9v9Lx5y6J9z10484ej5NFYrSplp98/chSt7DgcuajDNMWSMX9dR1UVOU4Yzaf5VZmul8qZXQMkaDhB3QaoOuM7aesaVXcCs1owIoRx5EBuoLctdJTL3lQ935k8lsRjwKFvgvFxszG/WRtQk5Pk8p08oR0cbBWRHTwmhp/j0bcAyq9ZIlzS5uxSxFqfQ4uXLwvWqb2GSl9GUzUw3p8DQuLyc6zF6VmYStRaXCBdLaOarIau70eaBKkahRD+9DyU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(7416014)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0NJakJETTg0M3RNQk1EbXJCOGFCQWl0cGxobjRkM3VtSmdqM2NPemRpVDBG?=
 =?utf-8?B?Q2FhZGx1QWpJVnJlSUwyMEN0bWpYSUFjcWt3Mno1anl3OVJxUHpJWUpDYnpH?=
 =?utf-8?B?VTBOYjhkdmtPbE5NaW1wV3JYVjJDbTFWZUJDYStJNi8ybVQ5WThJMzlOMmJo?=
 =?utf-8?B?YXQ1bUN0Z1ZGVzlrUy9KdGlscmx0K01TazNYeWFhZXpLUys3RDRmbjRqZHpE?=
 =?utf-8?B?Z3dyT2lIekg1c0tZL0twMU8vYTJ1cWlaOFZ6UkF2VHVab0dyUFhZTWhuMEJJ?=
 =?utf-8?B?clVuSkMvMm9jRFpEaUNMUzMxREpic2dmcDVZWml4T3dEbFo1SXdIajVEVjdp?=
 =?utf-8?B?VzVFd0xHMThrbkFBU0Rhalg1V1QrR3RBekIydHBQMTJtYVZxaThDbmNkeDdy?=
 =?utf-8?B?MXdNVExpSG9wU2VoOWpWMW5qUW9kT2kzZTEydFV5NFpndUhEdGMxMDZtKzgw?=
 =?utf-8?B?RElhZnpqNnYwWUl6NFNkOEcxSUdEVHZqa0wyZG55M0p2UGphbG9oU1A5Y3dy?=
 =?utf-8?B?NlpISGRBWXRXRFdORHU2V0JMNVdRWVhMOVVwUE5vakJMUlRTQ2FLRWVVWGlp?=
 =?utf-8?B?WlpQMXNGMjByZkdPdUJXRXBKeXAxZU1seUJLYWdmMkdzNVZDMHNqV3pIQ2xV?=
 =?utf-8?B?cTVTRElKcDB3TVh6eVk5T05FTVRJVDhFdWR3TVEwYjN5d3c3RzBCMGFwaW9u?=
 =?utf-8?B?dTZmN2ZvanZnT2dmckRrR3ZmNThWcHp0T0JEbFUzeDI0U3BjVU5LZWQ5SDFH?=
 =?utf-8?B?elVNaXlaWDRWclIvN3lsaWk1T1hiRGpqTW9ZRVNYT3lxWDU3QUVtOCt4TFBL?=
 =?utf-8?B?Y3lzeWY5eEdsRHA0REJxRE80Tlp2S1VnMkwxdnpyaHdobFFMY256Q0hQVVNW?=
 =?utf-8?B?WXVmVkZ4MTB0enJTdzdqRno2Wk9WYWVzRjAzbmE2YzltdlQvaWlvb0FSS0Q2?=
 =?utf-8?B?T21HeEN6VEpKZjhCV2xGMkJ4dTg0M0ZxSngvYmZDRXFhckQ2WWplcWFxMGRD?=
 =?utf-8?B?MkhzL0RkWU12ZGxsd1VWUWMvVDI1enZ0dkh5RkV6bGtZK2R3TE9pQkg3OVB3?=
 =?utf-8?B?aFVWMGc5eEYzcG1vcjRGVEJrUFRkWk52RlNDTGFUS1FPU3R0MjM0Q3hmY0lO?=
 =?utf-8?B?d0kwdDZybm5UdnI2Nlg5ZVdObDZQOWlIc0trdHgvNE5uN0krY2sxNVdVZ0c4?=
 =?utf-8?B?RUpNT25FVmFXZzZTc0VYWVNKcjRNaG9WelhiUjRUMzZpa1J1blhwQUczaC9W?=
 =?utf-8?B?S25oZ0dPVXBlNE5keE1SM3VoL3JUM3g3aVg0M2Rwa2Z4QXFHeGFIZmsvTmZR?=
 =?utf-8?B?enFXZkdweWdNRzlBM2ZxWUFvWm05cVEwZm91RW1uVjRuay90SkRjekhwYkk5?=
 =?utf-8?B?S0FKQU4xNGZoMzdYUnVZbVZNWlFaYlNuNG9wMW1RK3kreGFDcmhrKzNSZVc1?=
 =?utf-8?B?Qm81RlVGU3NEYnV5dVZMZmNDSHZDZlNRQnVhb055NDIxYWVqaGMrWGppMno4?=
 =?utf-8?B?bkN6VFovZzRjOEZvbHZ6VVZIVkM5MFJOYzlBWXQyWm1pRVZQY3FkaDlrZGNv?=
 =?utf-8?B?S1hnVDM4UVJLTGRFSE5xdk13dFBsc1JVMGhTeVpJVjA3bllOdFNVRDh0bjZ2?=
 =?utf-8?B?YmUyRDlyRWxiVmMxLzJydmRNdUYvZUlNTUxja3Nocm94R0VkWGlHNEZJNDJ4?=
 =?utf-8?B?RXhUMUIxdHRneWVCMHF0YitKYVFxa05sV0IxaGpKZStxWTFSSWRHbDZoN1VO?=
 =?utf-8?B?R0xKYy95Ynp0OTF4ZnFidUxnalJVbEhiY2V5Q0x6eFc0aHFmemJzaDd4Q3ZH?=
 =?utf-8?B?RkdNb1p0VGR6UHRBWHJqTVlvQ3A3VnhhaTQyb2R6TmxtZVNMT0NBSzJLMnJy?=
 =?utf-8?B?YSttQWViS2g2VTdYSnRySnVCK1kwNUd6K0JHRHR1OU9ScSsyallzWXRyNldN?=
 =?utf-8?B?WTI5NFluemk2c2hNSGRDZGllNTdtL0RyZUlvY3VOemwzaXc2V2p6aVJlNDcw?=
 =?utf-8?B?Qll2WnR6M1JoRVY3anQrWDhpc2dZZWFwWC8zZGxVN2ZBaTFXaXdib2g3V1FX?=
 =?utf-8?B?U2ZiL1hEcTdrWk1rOFZmeUgzODdLbkRjdU02OVpkRFYxcUliQWxRdmdtVGsw?=
 =?utf-8?B?RDY5dkpJdjdnaXlyaFRVckFTLzUrdDVta2pmQ1pZV3c3VENsdU43VklUSURK?=
 =?utf-8?B?eWtRUnlhb2t4Q0tZVmdraU16QWNyK3FkekxvU3N4WjJDalRnZUgxMnlJNEtO?=
 =?utf-8?B?STh5RFFwSy9Zbm11K0daaU1PbFJQU3JtSVBxY2l3TXhYQnd1Zks3clkvazJz?=
 =?utf-8?B?YU16akpjUVl0R3hxVDcweVMxcWh4QzAvaFVHNDZnR2poaTRXRXNWUT09?=
X-Exchange-RoutingPolicyChecked:
	jPLr0uAKUt73QT3We7Qid6z4AaVnnhAxCYodfvC1zFTWjxYDLlTGFsrcHYgK9O3j9ZltB+wCP18rvJdseP5oCWWmWfvGaLkumuPxMM3ptRlIUm/SzCuOwhyJ7aFFq6AosY7wz7w9W9vR+4YiJQZoI0Zc784YCzynMCDp4RE5DeMZt2jd6jv18G4WWvAz+KvVdJArcX3JXYrA9SZFP8LYnr0B8PSb2p+d1rFHujcl1YZIDJAe4mVYgiIwRgXXgZjgyKEYMpoRGWzNAbavcZoFHc4V09CcuFY+riu8RLle0iSbcnE0+3mlltm6iI3GoTvq8DuwzPrsgh89hF9Av8wKuw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfe1ad7-5dad-4df3-3af1-08ded849fbbe
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 14:55:40.3735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: STkfdhQLrq0lf82CPv0if3suO+/QXiSNuNKLcZd2raFhSe+z9psrr5Me03lTtKSdJPPM3DKqBSE0+GB7M89Yqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8505
X-Proofpoint-GUID: 68VHV5zS8-pp2GL8e0Iqx27K_cH4FVeV
X-Authority-Analysis: v=2.4 cv=HsJG3UTS c=1 sm=1 tr=0 ts=6a467bee cx=c_pps
 a=Pnh5LeqhM4XIZ/aCP1A8uQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=iox4zFpeAAAA:8 a=xB2xsRF24TUkKACq4scA:9
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: 68VHV5zS8-pp2GL8e0Iqx27K_cH4FVeV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE1NiBTYWx0ZWRfX1eUIGWZ2d6e7
 AkuhQVRVGd0frOF3m9eM13xWJERFsDHTZFYQLYcCWSSaojXgECvACy6GWxkXnA73Q/Bc/HEQgnl
 SlXvmaixPpNPrb4g0i5zhlj4ldvANkBty+T+CcUqafYXAyeDsuLf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE1NiBTYWx0ZWRfX1LsfMJ+MqgEs
 4EJQi59wW92gjGn1O/fJUb6hHRujYcZzBKX7E0wC3GcvqAOM5Xyl8ES3fj5RAr3lU+TFmXzWMHZ
 CBM8+Tlrh1Tl+q5fPCtGAI42+qf90+orF9QhzUt29vz9iLjRlc3tId+0l2vWoQ7EmPeP189Lhg/
 Zc+q/SXJ6ZSo3DAHDPeDyqZv4Q7lhz9lqZZh8xvs7d+5ZkvxqJNNHwMrhjShryNzwKQ82gQtPbT
 QmMfnYIAc9+nIoF3hLbKNdK5cOUuT/r21fR6Fnk53sLlpNQS9Mt4ZekW1e9zxzsOSFE+LJ+AYav
 WFGycd6htSjJUzdvv5tdhvzKs11oN23gVUylrB9hxWN9kTbg3aEcCJQB7yZFzGD4ZhdvtMxJgcC
 tBD4NwSLyrhp0+zkLGqzh09i8k9W0CqBAzVbYTLu1lmWdQHu37coiEu0PsCVNLosFX/ZKsU2vMU
 67n4InKcqxkaAU2EY0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020156

Hi Honza,

On 7/2/2026 10:29 PM, Jan Kara wrote:
> 
> Hi!
> 
> On Thu 02-07-26 21:35:47, Zhou, Yun wrote:
>> On 6/30/2026 7:34 PM, Jan Kara wrote:
>>> On Tue 30-06-26 11:05:50, Mateusz Guzik wrote:
>>>> On Mon, Jun 29, 2026 at 07:08:44PM +0800, Yun Zhou wrote:
>>>>> Unlike iput_not_last() which BUG_ON's if called with the last ref,
>>>>> this variant is designed to be called speculatively.
>>>>>
>>>>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
>>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>>>> ---
>>>>>    include/linux/fs.h | 13 +++++++++++++
>>>>>    1 file changed, 13 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>>>> index d10897b3a1e3..04f0de78fa7a 100644
>>>>> --- a/include/linux/fs.h
>>>>> +++ b/include/linux/fs.h
>>>>> @@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
>>>>>    extern void ihold(struct inode * inode);
>>>>>    extern void iput(struct inode *);
>>>>>    void iput_not_last(struct inode *);
>>>>> +
>>>>> +/**
>>>>> + * iput_if_not_last - drop an inode reference only if it is not the last one
>>>>> + * @inode: inode to put
>>>>> + *
>>>>> + * Returns true if the reference was dropped, false if this was the last
>>>>> + * reference and the caller must arrange for final iput() in a safe context.
>>>>> + */
>>>>> +static inline bool __must_check iput_if_not_last(struct inode *inode)
>>>>> +{
>>>>> +   return atomic_add_unless(&inode->i_count, -1, 1);
>>>>> +}
>>>>> +
>>>>
>>>> This still could assert on the count, for example:
>>>>         VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
>>>>         VFS_BUG_ON_INODE(atomic_read(&inode->i_count) < 1, inode);
>>>
>>> Yes, it makes sense to be consistent with other helpers. Thanks for the
>>> idea.
>>
>> Should I wait for now, or go ahead and include the two macros mentioned
>> above in v13 as Mateusz suggested? As you know, the v12 series has been
>> fully reviewed [1] , and I'm wondering if making this change now might cause
>> any inconvenience to everyone.
>>
>> [1] https://lore.kernel.org/linux-ext4/20260630100829.1257618-1-yun.zhou@windriver.com/T/#t
> 
> I think there will be no more feedback to this series. So just include this
> suggested change (keeping current Reviewed-by tags - the change is minimal)
> and submit one more version. Mention in the cover letter that there's only
> minor adjustment to this one patch, everything is reviewed and ready to be
> merged so that Ted knows.
> 
>                                                                  Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

Okay, I'll get right on it. Thank you very much for your reply and your 
strong support on this patch series.

BR,
Yun
