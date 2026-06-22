Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A479939B481;
	Mon, 22 Jun 2026 10:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782122830; cv=fail; b=QUksA1jXXQhow1F5+B8MDC9E9Ww6/gJLz27TNoyF3sk0dHDTx2NMreOIoeKTNbV/VGR2asBJLHPien8pC2HQ926epQfaJpTmAQY9sOImzRYiQXQ3pvYL68jnIurFgwjLh0N9zHPgc/GXditp0PyEB0BN3zhJ+JEHDYyQrhDhBj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782122830; c=relaxed/simple;
	bh=uM6ix2PkBMe9Frqipx1zMnBsGoM75t1KJ1pq4CA57Us=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D6Rurt5oE5PrF9ivh/C72tjMfoZkDJSdkh3QfnTRzM+59H9bWXzRatip8r6pBNw48r+mjXaStWmqB7MMjtqN1465jcgRS6x2+/DPBFTbpsY8Bx9BO0q6rnd6/p291C+wiFQlPPa02luOhHVxAswEIGyLE88vV0fK99Dxx1oB2Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ZVYD8IMZ; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ZVYD8IMZ"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65M8kLOK547811;
	Mon, 22 Jun 2026 10:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=6HRIV7t0z77dPY+QvZYtG7zo+3440Psq4+6KCPW/jIY=; b=
	ZVYD8IMZnFT5p0yOiaNHQjlrqUu8nmlGkAd89sk4CZ10QLaHPZx/8IiFBRAKJS9Y
	iOVxEsh/Y1zHJJE5NzH4Ljrh1D0Z30mo3B4nzlyvKj2QwfeyoMWYEUeBhsNM1TuK
	bQDR7wU6JETViGfLIjaH5ZRUIbXovGx/DkGQSexTzlNBARPUVY9dXivk5tMQYLvM
	7pPqKEh0dbuErVBSyPKht51xp4TQcZu6V5+my7zkR7/l1xvn8RCt8VbiSlVjx5WX
	s4JCen4GKreQxYb9zhUQldomZk6fdHxPTxSt0H20ARHnGvcERn9R7pvDR5buQSJE
	xa0KvUSYD8kp9O0TKIJT7A==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010005.outbound.protection.outlook.com [52.101.85.5])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4ewhu59syk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Jun 2026 10:06:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4WLon9XtSBTENRBO82x3EMaK6NJAJ5qoG7IBokNnIgBaLWEkm/M0/48Ib/vw2MW50RcktTepYwrNaECREWLWNXOpmoiipQRd6QIU+OBImXI5H2NI+Vbg/vdwFlX5TraxnhUaptIIil0NbJa20pe+86kn9I7UIjwqHQt8oKvM7gBIbdo+O4zamoChFm4d4hEfJBPy0bdDM4uEDYQV6xlmpxrTRS43TfhuU++lT5k+lGxtLiwIQvViA6ENgAO0dyzUgZ/uhzyXqwFJ7A4fuqcSsslJcsySRPx0gSkiasKX0gpzCk4Jccnk1dDR677OG1pB5pDUAsR2zkm3aFB3wpanA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HRIV7t0z77dPY+QvZYtG7zo+3440Psq4+6KCPW/jIY=;
 b=tBaDJUcB387d7FpeOk+QT8H6iedcFXE9Zs3ePJj7Bo8ipbTKxKAnmIBSmgNM/eGirPYA/oE5ojvMxtMK5FB0yYAw1GuOGhKsSAspYAnIDcX/x1/xZ+fb+kt++DT+39zmh6oyaTIaF+KppaBCl0rWFro1XL2tnYDg+pbQ2iRjiQRpMHUcNmAQBnCr4ksCrjf9gb9IoSwIAQqiM7uTJJlHJJrwmAgsoCX456Ptp50wgCu88VYNdzRv32Pa6Y2yDvR3HS9IXPoYBzWNlSj43otJUPgWuCdzlLeFlU9SkQ7UDnWcNXpf+VDD20lwiEh/lg/s/eNbRA+6958eyctlNW2vvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DM6PR11MB4547.namprd11.prod.outlook.com (2603:10b6:5:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 10:06:31 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Mon, 22 Jun 2026
 10:06:30 +0000
Message-ID: <f9c2c9a3-c68d-4c1c-b399-656068ef472e@windriver.com>
Date: Mon, 22 Jun 2026 18:06:23 +0800
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
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <jxcbsd2ot63wy3dcoximemkuitwoqn2a7jgxcsfdwaf5q3ecdu@sahahqqopo6y>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP301CA0069.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:7d::9) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DM6PR11MB4547:EE_
X-MS-Office365-Filtering-Correlation-Id: 7adbf38c-9bf5-487b-6614-08ded045ee8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jvIBEjQxiiSv2NIEXAzGSm5jMdJk0Wdk+x5Pm4gec/+p/D5Oe32BNP136P2gNsGrF4q7Y3wdkSg5JsGLuBZooOEJ5N/J0s83TU5Ah+vydhSsMeEnVyJDmM0sQCphsdvBLejvtld374GboEwGPr/X5/6PJQYvu1ynZJNSPOFbXhT41V6webUAZLbKsQibYj89MzdAjkaQRLiJZfA80Hveb82+Dj6GP0SLCcPkhv9EZs29ZOmZfdIW45miMGT2hmMRnkaFgPeWfUmyLYlaD1QJ7FA42cHgCl9pSn2Q+W9+Dz1yuwoXJPLy3eHw7cusQfvf3mg5xne/w1olI7Qa3fyIZub771hlAO2dE95rjpL1RtRmJzDDbI1dWFnn0vdzRlWTtKUYr3ZWDHwrOE3RBLsGAHLVkk1hIIMoYYPSPOT7tB8FFEiQ6/gZleco3AxG7d5XATgSjPQaiFhk/jYEKKwZOrTPE42oEUqWCY6u29slxYz4sl3iU5ZDivHVKr3x2hpUv6SCLIbUCBoLYJEBOhCUoJi8csYs+W4ND16RLg+Ik7HV13O+iqpKMdUi53k7PjoH3TBT/5aCT6FDLK6SrygTLL700Zh7XXA+9aUA0X5qOQwLxfw8JTFc8GSuYxtT3MEy+UOSwjQCbAnyQgaNxZSGG/aoWsZov65t28FIDpRo/O4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjZubmVWWUtVTmJ2ejVxOW1lczBvU0RkOWwzOTJhaUhTOUIvRW04Y3VOSEh5?=
 =?utf-8?B?R1R6NTkwR3JEZzNreE1BRTN0M0k0eDljeDRXSXMzTS8zbDhNZFRhNnBhUFgx?=
 =?utf-8?B?eEdDNnVURzRod2FqVjNBTlRDM2JyU2dBQnM2NE1hTGp0TUk0cEpXUUlxSisx?=
 =?utf-8?B?dTVFZFMwOWpVOCsvY1BFSVord2JxVUhHVTdudXU4ZUwzbWVaMjlYWnNWMEVE?=
 =?utf-8?B?OXFWbzl6Z1hucDJ5alZabzNuZms4Y1RhUFo1NEpIODg0V3VoT0dqS3UyRmxN?=
 =?utf-8?B?T1dlUkdrRmt1YUw3Tm5GVVBLWndyREFEd3hIZWNMWGdHR3RkVloyQmtXNW1R?=
 =?utf-8?B?RWIrSHA0djJBNnhBQVUwNnU4STB0anNlcThnazNHSDY1bWtZWCsxUWVaZVNQ?=
 =?utf-8?B?bU1nVk9qRWt4QlV2TDRDOHRUamtSRXlya1F5eEt0M1lqUVpGbStaWGxkNFpT?=
 =?utf-8?B?TUU2ckZBbVpZd1pTTFY0cXN2UXBYR2NiMERFUHlON2pDQWp2cU8zYlhLcVdW?=
 =?utf-8?B?bzVUbWh6Z2ZKUHBtUlhSRjhFZ01KNlduckFZK2RTT0VnMnZYbG9HeWFSMjBU?=
 =?utf-8?B?MnNMRWhjVnZNczdiTC9mc0wrSk1nTWd2Y0k1eDZYbmdSUUNuSHQxUU5Rai9z?=
 =?utf-8?B?bHIremprUlNCQkQ2dWxGeEQyaDlyNThPdVdJZmthQ1k2MmQ5SXpWTEVwWG93?=
 =?utf-8?B?akRXMzlwamJpamw0TWFhNWhPTFRLYVJialArczZtVnZPUXNaM1dXajhEcVpk?=
 =?utf-8?B?Qmh3dmFSaFl5N1NZOWMwYVRuUXJsN0Q1Q0J2UGZCRmxBSldaWWFvbHFMT2gy?=
 =?utf-8?B?NHRwOHNDbkNiTzJRZk1TUkI0SldIOHB5a2NJckZCUnRHYXJSM1hWTHFXK1NV?=
 =?utf-8?B?L0VkaS9hTjN5cFU5UXhLN0J1WW5rQ3ZZRThsUDBlSHg2V0cvbDFwUy9YRHdu?=
 =?utf-8?B?WUZ0eCsyTklmSnBzRENIUEVsakhZRDV5ZGZSRHlOVElsY2I0Q21hOVRXQWNS?=
 =?utf-8?B?bXBzN1poZ0RBNEJOc084bXkrU01oSWJsTm5VQVh4eFREb21DTUpoYVd4c3N6?=
 =?utf-8?B?RUV6REcvbW5wQ29qVkxuMUJleFRzYUxoRXcyNXVBd2V5UG95RVFuNU00WWh5?=
 =?utf-8?B?QjJ5MEFCWW1hdmtQVDQ2dXJRM3p3OUovK2dxSEI0VEV0VE1lQ0Z4VWV1OElh?=
 =?utf-8?B?UGRGKy81SVpxZFUvVEJDdDVhS0M3Yld2b0JTTGN2UVZCVU1sdStJYjcwUHJq?=
 =?utf-8?B?elJSbXBPYjExRHhYOWZGOFRWVXhLZldsOGdmWHpEWUdCbk9HdDhOQUhkZFVD?=
 =?utf-8?B?emQ1Z3VtQUl1T1ptTU1Lb1dwaDdYUmRHaWVKdnZGb21ZQ3pnVzI0VzhOczVO?=
 =?utf-8?B?R25HcmlkazZ0di9uTUFqai9ZZG1pMi9tcjgvNzBLcUNIYTY5VzNmbm52dUdi?=
 =?utf-8?B?bTBwQ3M2Z2F6ak5lTFNKUTUrSlNsa296eGRIOUhOcDg5RjVXRWpRdThGUXp1?=
 =?utf-8?B?MjcwblI1TllPR0pUa2k0N3lTRk9UZjFjbHZiaGZrVytzbHhTQ0Y0THYwL3NN?=
 =?utf-8?B?NU1SRDM4SS9KRWtoYTY1K3JXMEhRbFFZU2dlVm1IY2xrdjVZZjZOS2RIRFV3?=
 =?utf-8?B?dXVTdTFwQmNlZTFCZ3VvM3pIeXl4UDFEUUZpdzAzSlF2VjA3QUxFYWxGUlZT?=
 =?utf-8?B?NTllTE5wMWFZdmludjdGU21jVVFFY3lTNHFBQkwreklXaTZFZFU5QXhDVWlp?=
 =?utf-8?B?bExvUmpOWjJOdWU5NDZ4a2JOZG1VVVU5ZzJNYzcvOEFKR3FHdlJrZXFkMHFP?=
 =?utf-8?B?VmtaS2lCT3c1WmtIZ0tEeXJsMUhMOE9Td1JaQlVSZ2VTL3dtUnMwTUQrb0xO?=
 =?utf-8?B?amg0Z0ZmTms2K2d3VXN0eU00ZUFPa3JCZnNVRjN5L0M0ZytCRlhPaVZjczNh?=
 =?utf-8?B?bzlkODdONC9wZEx6ejRWQUpUdVV3cFF0RjlFS214K3pMVG41c3VEK0dEOHBp?=
 =?utf-8?B?alg4bCtmMGUrSWRMS01RQ1Nzc2thL21BdFo2N1hJM3p6YmMwZk9xbkl4TnF3?=
 =?utf-8?B?bUFTenhYc0o3b0dIeWduOUJ3NXZSWTlNRGJYSE5ub3FVaGlEODdXc1hRaTJX?=
 =?utf-8?B?Z3hDVDRJOENXUCtMb3N6M0VOSlpEVXhPN1NCY0haekpXKzBicFRpWUp5Tmpl?=
 =?utf-8?B?bmFONENRNFJ5MnMvaC93OXBuWXV1cFdpY3RGZ29FVmNvSFR5RkdRU2JYUzFQ?=
 =?utf-8?B?NWhnUW1EWk0zTGtvNDRianA2S1AwVjVmNVJpc1N1cWtIT3BTdy9VY0htSGxq?=
 =?utf-8?B?TnFKdG1yd2NyNkUyQlViai9VVDhwaTJhZWtQczI2aVZEWEFWaThwUT09?=
X-Exchange-RoutingPolicyChecked:
	HzgRoRnz2Cm3Mu/0YZwB8bBXF9CgPtjiQmFTE7JsvFPwdCxGvcSnYS5QuwP8Sj1PODeXSNTnkoW7bP3DKpabl0yCq3+CCXrkxF/ZO0sKNFpLFj1d6FQiSTSA2fyQbeM4OKInS9dWXIzoboqBEgIqPDkNPsvKLLggOCUoNkQzCtAfg2Q6xX3MpzEq7/56Svpe2fTSJ8uEOQHINo/FPjHvALpdD/Gts79PMdN61/coTsxZayvcEI0TUcgjpLoHRtxoztEPwgsdLNyMgijoZhMN9xbqA916tXNb/PtrAHL32hvsLxtjFwca/iZ4FYd202lUgmXZSORkn40INriccjhrwQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7adbf38c-9bf5-487b-6614-08ded045ee8c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 10:06:30.9252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+faB0oVzWx8Xs9X0jbP5ANQOzWUbk7M1XDqxfO6XO0qjrhPYC0MgXKC1rEIDV/bx5oegpVdkoHwBxFYUVbM6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4547
X-Proofpoint-ORIG-GUID: 2aoAyTEEt38OyaUbKiwmdFo41TIATNHi
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDA5OSBTYWx0ZWRfX5Ch4AB8lVFwS
 fnYnGKkA62YhiY3cPYtM/8v5VYX3jJmqTNlZmTRC/nDoULAWdEsvEC+DGJ9fpNTzhwOcdWTPTYY
 AsRJK7FK9t6pxmBnNKRSod0i1IWo2qBuFrNM3qouy1l/aZk/snHV
X-Proofpoint-GUID: 2aoAyTEEt38OyaUbKiwmdFo41TIATNHi
X-Authority-Analysis: v=2.4 cv=ILwyzAvG c=1 sm=1 tr=0 ts=6a390929 cx=c_pps
 a=AENbiTj01OTyMXuKFo/uig==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=pSzdMowNbwXWw5Hl9tQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDA5OSBTYWx0ZWRfXxpB2xf8AHBpx
 djbDhgzz63AcJxUID26HBDt2vj6palAUObWWeo5hjhGPsJE5NDRvSixHaKqbIAwnamP72ipVc4k
 rvmFkVYa8FDG4r8l/j6Y5Z8OIPUz08BXwDzZWhB3HYg3/bshnqCQMx5/wO+2ekuUnhgZeVXg4UB
 tKTHfxrnroAL1iluovniZ34ZhVcIvPqe7vrJcm9Fuk8yIQHU5aSdMIb+VyvmuxOViBcBRTISV/F
 4LoURYBZXpu7eZS9m/ga2pziEEGDeGD2h8D9SqqhtDIaUhJKhsJ/1v8dImLI0WPr9b1d6GG4Wom
 whthbS1U9TBvH+bN0jrAHcoJuWLN375yd6tWu67P11k3qR1IegYa1LJDmfobDB4/+c3k8Im6dCD
 HjmGmxJ35kGjW2fGAs83lGXwReU/EzVgXLS7au9N/dFNmVW/0RBI9d0YINEbYqqNORFQULyDwu6
 TTdiLiMcIujSClgqw3A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0
 adultscore=0 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606220099

Hi Honza,

On 6/18/26 02:42, Jan Kara wrote:
> 
> Allocating ext4_ea_iput_entry for dropping each inode is somewhat wasteful.
> I want to suggest another scheme (somewhat more involved but more efficient
> scheme):
> 
> 1) Create a VFS helper bool iput_if_not_last(struct inode *inode) which
> drops inode reference if it is not the last one (and returns true in that
> case). Basically:
> 
> bool iput_if_not_last(struct inode *inode)
> {
>          return atomic_add_unless(&inode->i_count, -1, 1);
> }
> 
> This needs to be a separate patch as it should get vetting from VFS
> maintainers.
After taking a closer look, it seems that this function doesn't need to 
be added to the VFS layer — at least not for now. For example, we could 
directly inline atomic_add_unless() into ext4_put_ea_inode():

void ext4_put_ea_inode(struct super_block *sb, struct inode *inode)
{
     if (!inode)
         return;
     if (atomic_add_unless(&inode->i_count, -1, 1))
         return;
     llist_add(&EXT4_I(inode)->i_ea_iput_node,
         &EXT4_SB(sb)->s_ea_inode_to_free);
     schedule_delayed_work(&EXT4_SB(sb)->s_ea_inode_work, 1);
}

This way, we avoid submitting an isolated patch to the VFS layer that 
currently has only one user (ext4). If there is indeed a real need for 
it in the future, we can always submit a follow-up patch to refactor it.

What do you think?

BR,
Yun
