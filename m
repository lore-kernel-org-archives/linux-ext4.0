Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D003261B8A;
	Thu,  2 Jul 2026 13:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782999391; cv=fail; b=WZm4v6AnmZ8raTdVQpbJBxTaQu621dcDYJa4HYmjgCdzbHeLkVxMCLtPn8AlH5RhhSrYaCLxkK83bRvsGmL9UsmuLj9GDd1SDMps1vthNoiGAadvac9w+k8uzyrv7jZs7OUthaZ3zL71vQkri3Z2d+11UK4D9qW0xNNXlLqE7QQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782999391; c=relaxed/simple;
	bh=QMY+o51koJw86yKH2K/bYi5Ezs0Cbp+1DePRJgRp2Mw=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uQZHT0EaoZn3zP9gevAT4GpLI2eBDVd5juk033hnUOC4riTd4K8L2ZFA7SbZccauxjqpkj2xcNsRDBSWmAP4qeKgb2GzBZ5zehWZfJQjuObtWexOLwbdRWGYtnjQ14mT5oqB4Bg4O8l3QNbGn2WsjzbFmWDFKT651pB6OSaHr58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Ry6lSNhX; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Ry6lSNhX"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6625Sunt1110759;
	Thu, 2 Jul 2026 06:35:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=VucdmKaHILn6orLRb3OpSoLFpXOKH3WNlp7wQQB/uAc=; b=
	Ry6lSNhXCTH/c2e7Sq13XgndjqXnoRfVpHnruZYKiuxDdJSPDMr2oyetzXON9zmo
	5WoHPU+AXRGGgj8ZTaPcT6MZFWdLLau7Fi+2IJ+Ctalnj2hGP8BubMBuUwrYGNM/
	Ss9eHSMRgkf4m/gpq8FKql6izMQPSNCwp0ptryJcHjCBYTcrzeU22mMR54PVLRN1
	VbZ8ATcWnn/9NOWzfyOq6yPnMR6XqAjBOKxYU39j1ZDx73Y3agMYnF3WkA/o/T/q
	A092b6NzUdMcysDE7sGRWAZvI9ORfAWKyYa+mIhiIrgi5C+9d+8JbCHZFPUk8tZ1
	FlWC6AOmL//9/Wolr4fsIg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012029.outbound.protection.outlook.com [52.101.48.29])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f2e1gyf90-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 06:35:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHaRaOpfg6ioJ3ov92CuBO5KGU6ESVDO4ymkSFavOhQ8MOgFdt+o7YiCl/WezNdhQ+ZwgMwwtDQS5BbcPk6NN75k6lV55nPrHqMdYm//761HtXzAsu2VUbqpWPAx0QqtKDbcFguZp6UpZ6JnyZjqJI8rT/mJpsnX/8CL0JrckGAMrYFecJGDCRFZRfjKYMVBVxZ3Nt2b/z55dkOtcpL1m4QOT0CtAwiBmimvtzXHZII8OkRzMeIA/MWatn4XuqFGIl94kZlwfpzrTjHgXvEIRkLCdyHXJW31KNlyTuOxE1tq5SE6a5Lyg43er/jQICuw7bqhvkGU3zDp/9m5+pLHZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VucdmKaHILn6orLRb3OpSoLFpXOKH3WNlp7wQQB/uAc=;
 b=Nt/giNT7EkQgk5b208yFFdCDnnA0QrufYrlc+hyZfh5SueNvkvA3QXgKl+KkdRZPQtSV303NuilXbLna1t+OESEF3Pz1WiXfM1W5S0BZgt5ZkfVXSBlrTZvGe7cYUQSSx72YLJKLvKKcuCfWBZeySKkzAkvPbnVWHA5dif9xA8c9kPo7Ra9D685fyQBieYIXBb6C5mC0M+uhn9RQGE1Y7AAq7OGkP3VVqGhe7hue3hcvYsS7DntxRFrtqAxD5+T/nivNeGkzYWnTovvt1mQLzMK7JfGAo5rWxYdori0KqL9IlSHRUgEdi4btCCpo6cdoOzVSL10mdOh2hJE9p0lYjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MN2PR11MB4616.namprd11.prod.outlook.com (2603:10b6:208:26f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Thu, 2 Jul 2026
 13:35:55 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.008; Thu, 2 Jul 2026
 13:35:55 +0000
Message-ID: <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
Date: Thu, 2 Jul 2026 21:35:47 +0800
User-Agent: Mozilla Thunderbird
From: "Zhou, Yun" <yun.zhou@windriver.com>
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
To: Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xiaowu.417@qq.com
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
 <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
Content-Language: en-US
In-Reply-To: <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::27) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MN2PR11MB4616:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e5e6b01-bc86-49c9-7eee-08ded83ed79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	RySMObg7mXg+aa6XxMtBVOW1L8k2HelBAkd51ZmPZgIQ7kr026LoSh05mSC9xUU2wRo6tbWsaR266NQJc1mdlQB7OR0O94BQNDtq7P9WScJ+mVdUkZ2wnoZRdgexcrWkx3v+9tUr4gG967u4lhqRP3FRQMFkjaEE6Eu6JvwJG/lPEHQKzFzPkCdgH2jKMAwFO7DwYg6lCAXFHup+sRRgihwlfcJvFl9NiD7yI33twb1FeAwl1gmM9XlQZdXfhgpnmlYZPvDkfJ+YJm0liWp8Oe6nqomwHwPSlmWQUF7ya2Z8rzPCGjYeJ8OCKqW4zWf0MigNVjqyezApv1QGvoQBldir8KrmiZMPD8EC7ThAx45atEvik2HRivuUvuV1gwApbekfCBC0L10wOScjzl1LkZLpBNhErLJgK9Ru+iTX2mwJoVUoFe7LeSbNLPSRa59URKbr0GlPqZIgaQI430Or/l9C0KhegLKTl0oABA9Alx8WN6nydY2t0Fv8vlTY8JjMctFZyE5QovMcQ+t3dx3++3APybi1oDlTNN12fuxgj0GzV+jcbKmulfbRNzqm0fY5kUuxLQd/etiq56aP+op3iB/ERRAmurekHkfe0ytY1sucORTGWd1Oq0iP7ujegc6G
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2x2WVZETVhTcEVSZCtUWWs5d2lkN3daU2c3ZkVZZndNeVBvY3pHeHdHcU01?=
 =?utf-8?B?S25NZzJNMGRzWk1ZTUwxNkpId3pvYm5lL0hJU29heGJJK2tFc01zNW9ncENE?=
 =?utf-8?B?SUtWL2FNQ0gwd0ZBdVBFYmRQYUNqUEFrMGcrRnV5WVNJVjRmUmdjNi9pazJI?=
 =?utf-8?B?VUNqODlpcGpFTUU5Nm5KTHErV2N2TEJ5dlFTdGptaG94Yjg1VVJTODA5VVpq?=
 =?utf-8?B?cXExdlNsSkJTTXhVUVNHQUJGNGgrRkpqWDJnL1pCeWYvbnJNV0o5ZEI5OGc3?=
 =?utf-8?B?VmpaSXlKcDlyNlhKenNvSWJEQWFNcEd5aXNhWVFpSjZQL2k4UENuQ3N6a3Y2?=
 =?utf-8?B?ZXZIRm9oejB3QzZibkhnNFAxUXNXZTMxeTZlUlJWOUU1cStNV2ZxbDdhV1Qz?=
 =?utf-8?B?V2JjWWY1Ulp2KzZJcXpXcXVTYjJUNGhQMTdaKzUzMFZ0MkNGTG9jRG1vRm1K?=
 =?utf-8?B?SDVSZ3U4dUxsODlSMVBGM0UvSmsydzdlVm95eGZESHpaOEVQR0tmK3Vpcmdr?=
 =?utf-8?B?djJWZkhzWWN0VU1ZSGdxdjBLWjZmMnlLNkhhOUpESTJPQ1ZiNUF0Y2F5NTZS?=
 =?utf-8?B?WWZ2YWNSeERpeGJzaEhiS0JoTlgwUkEvcXZuQWVxaW43YllJcFVqQUQ0dkpw?=
 =?utf-8?B?aE9mTTBPUG5zeHVLMzZPMXFqa1N0U0dtQ1pkcHBaMXh0bDhMS1NjSnBGOVZI?=
 =?utf-8?B?UE1JU1RIKzZFZ3dYL0JJdm41b2x3emY1bnltU0tObklBeHk3Yk5FUzVUSG1k?=
 =?utf-8?B?bHE5R25rNnhVTzAwQWM1SnNKM1pQUGdxcjY1MFpZTnZBY0VQYUtIcG12T2NE?=
 =?utf-8?B?TFdCZFV3NlBra1pzTFloejN1MmZ6ci9QWHA2ak11QXRQTkd2ci9oNld1a2Iy?=
 =?utf-8?B?QkZ5dlhGWmZJRGJCTzZEZ05vSTdrMFNMb2hYejBRNEh2VTFGNW9RQWtVZzFx?=
 =?utf-8?B?aUwxQ2JSQlh6RkNCUE9PRXRQSTJub1lOTEJTaGNTYkluTXZTVEJjOGZFdnlU?=
 =?utf-8?B?NU5mWjBUbkQxS2NKMUduVjlCOFZmTkNnNHBmS3RqMnN1VDREaGpZUUh5VWFm?=
 =?utf-8?B?cDE1Wkx6a3FYNE50Z3lXUk5MTUVxb1FvdFkxNmxaQlBKVFpWM0dwOVZOU1g1?=
 =?utf-8?B?NjUvbXdkZzBiVWlxMVFzVDNjdDdMQXZ4WHdwZWlUcjdmVVlhOGI1UGxpQith?=
 =?utf-8?B?L2cyb1BCVnQwM1VjQjRrY2lkNndtbEpWME03UjQ4Q2w0NEVvZHRJMlV5WU5R?=
 =?utf-8?B?aVBxMEpRZHdPOHJ1MEJpMEZOYmZkT0VCTkdvT2pqUkJMRHZ2azF4MURkU2Vr?=
 =?utf-8?B?VU9HaHlkTjdYS01tQTN2R1Bmc2pLY2FLWldhNDRaTXNrOWtFRU1YS2ZjTjQx?=
 =?utf-8?B?WmN6RnpwQlJ5cUJYWTU4WjBMNk5reWw1UmdHRUkzMDMyTzRsVVNSbjJxc05s?=
 =?utf-8?B?RTRvSDNJNkNxUWdFSEVUb2QranZkcW1lNWwyWGs1RnVBQ2pmM0xaQkFCdXdZ?=
 =?utf-8?B?dnMxZGg0Q2FvWSswK2NJTDFBQ0kvUUxhZGN6WUZQUnJRaDBCNGtpZWw4cTJF?=
 =?utf-8?B?akV3MVp5WjFYNVovS0lrT2xqSkZDcG0xUWFZWjBIaDd0cFgzVHlEZmloZm9N?=
 =?utf-8?B?azJjV1BSUGVVcmwydWZBUVg0RkN2RDd3Mmg0K3JySENueGlyQms4N3lHNm1J?=
 =?utf-8?B?Rk9sR0JZTjlCYjNGMXNKVExxT2RVNC9qSTFRa25oVHZIbDhtcnZ3OTU5WVdG?=
 =?utf-8?B?cktQNWh6NkFlRm5IcUhDNTlSdVNYQlBVdTNDQndXcEVOeWJEMDQ4TmxnMmUz?=
 =?utf-8?B?TjY2TXZhbHV6UW52bUp1a2lKa1lKb3dtYXBxZWxXU2VidG5FTC95aDM4VjBm?=
 =?utf-8?B?Wm93MGpOQ25mSzV4K2xzOVl1a3VQKzdwZVVDdTh2VFloQk0wenpUY3FubjRz?=
 =?utf-8?B?QUtXMGZaV1dIUnU3NjJNL2RrZ0EvOGZYUHlJYXZXb3J6bjdxS1lSanlQeldT?=
 =?utf-8?B?U1RsSjBhZ0RYMU1pejFaN201a3B1ci9qN2pCeFpjaUtuK050b3JyT1FGVTVF?=
 =?utf-8?B?TVZIa2QrVmNjNHZIa0Z2cXJZSUd6S0NmN3F1eVd3ZlVlbnRLZU5WVEh6Vlkr?=
 =?utf-8?B?Qnc2eDEvQVpRdG9nUmNqMWNGTWF0SHZLY2RMTm1kRVZlM0U0QWszenc3U2Fr?=
 =?utf-8?B?UW4wOFlnR0NicVZVL3NDUlJ5WXlqdnphMkw0SE5VMXdHdDVFYUZTYWVzVVVs?=
 =?utf-8?B?cWpHeGoyKzErZWRvV2I4dWxVS0VRakJ2TWxROU1HTlZtaHFYV0JTSXZaWHI1?=
 =?utf-8?B?cUc4VVRjYi9zc0lwTnEyVXQyK093MEhCamIyaENBeE5LMk5jUExxQT09?=
X-Exchange-RoutingPolicyChecked:
	kQcZPDQJKR5kyfmzVAOEK4YNRiksS54V03UmEk95e7ZR4Z3YoMzJXT+6CrM+tiAdwkMaY11prjoEWF0zjYGAnTWZD+4RbQNA583L56ip+/qyNWcZGw420lpUs9NSJscR+WHjcC0QRfHR/WNZ4o2V6D5ciVmAcYCXftS7QKF1YlGZGwE/5uTeHM+/QCJptee4WIAx2pJdatgV6vLRJREXcM0UauPXcPmch8vyhyMqo5BMF8dWVmDN8K2+A0dugRY7CEP42iFz9ee5aAx74LhyO/HQ4D5CdOIFImG06bThIJUCMdZN9veN6u3nfU11fSFoYnYzk98dBYf/lh5/6oy5dw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5e6b01-bc86-49c9-7eee-08ded83ed79d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 13:35:55.2085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: da7zTpUEa6Ghrm9e6HB9+MTJHW4MjrH4wsni5ExUB8sPJCzkTiorgu4gXGHWpoCuauBJ2FZmGgTKw/KoDP56bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4616
X-Proofpoint-ORIG-GUID: FK3kcmKfmAwIGuG4cGkDPpTSxME-wD2S
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDE0MiBTYWx0ZWRfXzrJqVNMgTfKW
 mfNMi4d0tL2QuaKFGplbZOOc36w6QIxF2UTjUX+vGkLSXtAFfTxjntHxrIexp037b0rxhhQnwt9
 pndMDEERTflUPWHtHErtH37+OXl3Zb72RGEh0Nc8zaBAZ/5QdkFY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDE0MiBTYWx0ZWRfX+sKnWdT3C3Xe
 HAKUGSjI1JfPGW5nbwkWjReciN/A2N8oLhCWAAVEuVemJQwsDXnt50FSiNG3ZXYfpptUvB0AvZ0
 W7OdW679SKYb1IpgetFsOj9jJ9uYcyARpAa3EE3zV1PWrWZffmk5SCib3M4V3PRMETagJeTbnxT
 n7VhckbCjIOwncaRtspZBaxtjh+AFkIqI3bOUQX9uEq1QFUEfP1M6967UbiJ/o5TsE5GmONSDx8
 x7nme2Lks2nQZwfE25KJnMI+tTA3dlnQ4ota/kcTnixCb3ndU6jW5NfXov/izxTWTNKslBCo3dp
 2UW6XBPj7mhTfTpeMjiQwGU8ulOJc4zDJdmbYRjH7ZDkR0KMg3c/R6BL6HCQOrpkhOZ6ivrjcgs
 XwwDXqTcAE1OwYyGIZsR3lzuW8YA6JW4dnsT9uMflWWyIPMNwV1s0YzY1Kokf2hTVFk0HbT7zIC
 ciUyiwvzn0z4iYu0MHA==
X-Proofpoint-GUID: FK3kcmKfmAwIGuG4cGkDPpTSxME-wD2S
X-Authority-Analysis: v=2.4 cv=GsByPE1C c=1 sm=1 tr=0 ts=6a46693d cx=c_pps
 a=lBl9kuBVfjPHxW47UHPt6w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=731rElumEKktTXMZ0NoA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1011 bulkscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020142

Hi Honza,

On 6/30/2026 7:34 PM, Jan Kara wrote:
> On Tue 30-06-26 11:05:50, Mateusz Guzik wrote:
>> On Mon, Jun 29, 2026 at 07:08:44PM +0800, Yun Zhou wrote:
>>> Unlike iput_not_last() which BUG_ON's if called with the last ref,
>>> this variant is designed to be called speculatively.
>>>
>>> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
>>> Suggested-by: Jan Kara <jack@suse.cz>
>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>> ---
>>>   include/linux/fs.h | 13 +++++++++++++
>>>   1 file changed, 13 insertions(+)
>>>
>>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>>> index d10897b3a1e3..04f0de78fa7a 100644
>>> --- a/include/linux/fs.h
>>> +++ b/include/linux/fs.h
>>> @@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
>>>   extern void ihold(struct inode * inode);
>>>   extern void iput(struct inode *);
>>>   void iput_not_last(struct inode *);
>>> +
>>> +/**
>>> + * iput_if_not_last - drop an inode reference only if it is not the last one
>>> + * @inode: inode to put
>>> + *
>>> + * Returns true if the reference was dropped, false if this was the last
>>> + * reference and the caller must arrange for final iput() in a safe context.
>>> + */
>>> +static inline bool __must_check iput_if_not_last(struct inode *inode)
>>> +{
>>> +   return atomic_add_unless(&inode->i_count, -1, 1);
>>> +}
>>> +
>>
>> This still could assert on the count, for example:
>>        VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
>>        VFS_BUG_ON_INODE(atomic_read(&inode->i_count) < 1, inode);
> 
> Yes, it makes sense to be consistent with other helpers. Thanks for the
> idea.

Should I wait for now, or go ahead and include the two macros mentioned
above in v13 as Mateusz suggested? As you know, the v12 series has been 
fully reviewed [1] , and I'm wondering if making this change now might 
cause any inconvenience to everyone.

[1] 
https://lore.kernel.org/linux-ext4/20260630100829.1257618-1-yun.zhou@windriver.com/T/#t



