Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F2C2F8EAF;
	Fri, 19 Jun 2026 06:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781850349; cv=fail; b=CalYXu0mlmfU0C+3zrgXrChdahdD4HLuyxiiP6gXVWWYrhkofPfQW8/zUSeuoJ7RPcCyHAsmVxhNNsCgOM1JzcSj9BqDnSDqkK2LO0NpNmea1VZHjijJ8yTBynv8F2OvEoiOWCQlsl6YXLCdaIuzNy6DIEDdGhjKTaZSNnC+h3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781850349; c=relaxed/simple;
	bh=FQ/dF2bFCWqepYfeBxcZwrzzz9rCkpMKJS0Rdiwu+AY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gh056H3QUUoBuYpo+vOCzGoIhNiI+FcqePK/kJW28qseaxUNRVOIkpoJdV7vswnlLdF+Sj0Nue3Hy3YkHv6mqHrDTikfOulW6FS0BitlsfUGWuP0MuHHYUcctpBiWl8QvBp5wSuIqTwHzycc5v9QfdoVRuS32SeewxeTtYPCGnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=dcauKigq; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="dcauKigq"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65J5o5s01783571;
	Fri, 19 Jun 2026 06:25:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=zPYJ2CxhaVCNQCxdweTSDMadsbBJmZ7b5s44ZUdoRE4=; b=
	dcauKigqtAqLddkC6ck6Oc9+TJ7ruUgOkk2hpdWO6LEk+91HEXsEXqu02jnamFTG
	sld/MIeub4RzeZNFS56VuO/AtZWr5wpqluoBHswKxq4iG5T5rQ5DffTs0DLDYfYn
	gpUuv31JwcPVjdBrolOY24mQuGZ8KzGrrqUQIdo/+wuTokG69d8AtlmBXM1/RY8t
	aDSw//zfjCARkQMq7wHHh3Q1YycMIFgfbbQzSlEhDww2uaImBRiu+/JzMxYafx6D
	OIWyrQxfvxk2OuOluGG0lTiFcqV/UxX2Huozig6ONqvKFwEqI5S+L9vAYget/zli
	/yuw+6NH6ho48S9XGqpjzw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012050.outbound.protection.outlook.com [40.107.200.50])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euefc3vhp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 19 Jun 2026 06:25:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GiSSWCRYx6y5q/nE503nI+eQH7l/FzyttSiFlnvsnnnP+UELlq76DC1SiTUGOtyu+smVFFOFnMW3pWvtfg7YI6IyAjf+HPNwbou/t8/v78477TcRiHlile5QkPPLKFqaBD201oq++XZHZcI688dmzSF1Xv8dA0CZoi2z1K+/QnY8QCDmh6nOZcaNkK3IYXB54arNQk5ccpROQYuYGZBSryWlGaY1oIk8cxVPkBSVyYYCJPwcabaeAdqy4o2Pwye0UY5YIPLtu4NGSi9o348jBHnt4BpnxLdW56qso/MYowSMfilJW46NXCwtOVsaUD6ZshYb1xqZYLSyu63ivDlyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zPYJ2CxhaVCNQCxdweTSDMadsbBJmZ7b5s44ZUdoRE4=;
 b=rvAGQ2xQ34joEgTrqnA1DW24zY8mUviv2oqqiEc2hVGKtXsGClo7gUHmamSh/7GLVPudQ1eOdoF9TbxmG0Xx9P/sJUUUB8EzEXaxs7eq/nBh9RCHjxFZC4RHVDKD2BQol0BH67jrkBms9p18rGBBRIEgawE/4tCNyauZx5D+WJu/mLSwz25yJAtCZiO2k61NjaN+iCN1GheTl6VYLGb0SieMOMcBjuIfBOkbJ7Rblml1T3Sif1771VVN4zVYI0n7IAYW3ZY1xUcfdILh3khdGMaQTghJdiZ5GVkVRmHCt2+hYoyzzQ2Vj6QCf1RoxVrBihGJme6mFHcO/Xx3v7RH4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by CYYPR11MB8430.namprd11.prod.outlook.com (2603:10b6:930:c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Fri, 19 Jun
 2026 06:25:03 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Fri, 19 Jun 2026
 06:25:02 +0000
Message-ID: <dd9e35e6-306b-4e49-9802-487ce7abd63c@windriver.com>
Date: Fri, 19 Jun 2026 14:24:51 +0800
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
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0318.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::6) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|CYYPR11MB8430:EE_
X-MS-Office365-Filtering-Correlation-Id: 3377185a-9e22-43eb-ef29-08decdcb7ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YUrot7/f2I5XwjOMSY7z/hIEAwxemk1qf1QS9FlElqi4OddCWc0v8l6rpcBAiXVANvyN9tpMmA6K5GAJfPMblZWjJzFcLLKOLubX+faGSfj7PGd3MDOUrlw4nyp6ZVwupu7VZStucq9Urnam7ziOap98vykW1bz+I7ZIB8Xjvy091jLc2wbBWl8QmcraGycVKJeT19UhiGex1yselpGY9kYdXs8BsSbCJXbugw+7huCqKOeV7PQXVQ0bpBWGIg2DXF3G69gsrvxpjaCgOzo2bfZWAcjw1/zfSkgMHBechxbvgaqPW1K31+hRl7RWZhLY8xjl/Bdd/3vZdV/+Rrv1hBBpQUPt9ybG5EHxiYlQlGGMEZKXlcrB/ObAptQ5lDrpZ7Bo9iLlgWZZe3YMwxs2CP0i+QsNjXExjIjJxslVuLhGHoJ3/dip5SfF7bKkQceE05NmDyWRZaPtj9QcgQi9VXyCm01gxEzsWiOR6B5mzI7ixwVVFxWK424oS5TLdJjb+tJ5fFgF8B83r4vg+fP+VufW19WCQjbZ/aOBQ3XiiCbgrp0adbEKDP/M084LQhRzvcdol1HzDKtUpUwNmj+WuL5r3ZDyEpcInTu7QD8VRvHfgXKKa2Y5jbtS0kCHlsLn6KD7SEFv3LOp7l4VCeMfSS0Exr+7gg8wsJjnwrHxjEo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akhiRm9EdGZtTy94S2NQZ1lHMm5oL2htV3R5R2hLemlxbnN1dXA1RnllZWNr?=
 =?utf-8?B?OEprUmtVMFBuZjdNbE84OFpyTkUrZmZ0bURiS1B1dVY4L1lBTERxWW1wZlE3?=
 =?utf-8?B?R09wUzRhc1BjWml0aFlUMHFvSXhvSU9zRFZ0eEhzRXU3UXF0Rk9jZExlOG1I?=
 =?utf-8?B?VHhEdUpkcVQyQ2VQU2M1eG9ZYlJST2VTNFc0UFJOK3FBeGJpWTdSV1NyQVBH?=
 =?utf-8?B?Z0JlNEsrWmZuV0ZUbnREUGJVOUdyVG1BZ21TNGc3VlFSS3BNSzNja3liMEwr?=
 =?utf-8?B?Njc1WEdOZ0dxN01uQ1hGYU1lL0M1dGdVa3c4OEVRTDB1WFZxK0k3RTQ2M2VH?=
 =?utf-8?B?VXY5Q2E4UGZWU3hyNmNTeHREMi85Sy9IQ1lRS2hMYSsyc09ZdTU5anFQampP?=
 =?utf-8?B?aU1taUpDTmFpY0VvV3MrRThDMlR6blU1QWg0S2RveVpWN1RRMUU3aTl0ZlZV?=
 =?utf-8?B?Umh2RE9mZ1pkZ2V0dWlZRksyazJXeFpkKytxNVJ2MVREdXp3TWZ6S3FLMEtm?=
 =?utf-8?B?VWlYR2NDbXY2bHV1VGtLZHl6djVxSWFpQUtWMTl1K0Zkb2FDL1NTaERDN1dt?=
 =?utf-8?B?RnJKOVlrWmpxdjNON2hKL2RHMnZDK05CU0ROUUNrOENRNEFMQmR2R25EYkdH?=
 =?utf-8?B?TkdZOXRmWElEK3RZRUFzNzY2MUdMMWdVVzRxbURLOGptQ3BYZVV4eFI0VTdi?=
 =?utf-8?B?eXJDY2w1WGJYaG00MWh4WURoQU42V2d3YkJxRHA3Mkd4cWhzVlVvQUdYampC?=
 =?utf-8?B?UWZEdCtKNmFWZ2Vtd0N1NWNydjZIc2NuaUVWZXVNSnU4MjE5ekl3ZlRzV0x0?=
 =?utf-8?B?L3N6UENTcjZBMFJudjFLUDlpb0pGTFY2S0pKciswSmI4Yk1pMXRadDQrbTNi?=
 =?utf-8?B?SllYUWNMcGswTWgzWVlzZ1hxTDdxZy8wS0VzdC85VnU0R0hiM3ZJYUxnMzla?=
 =?utf-8?B?enF5SVNSWmhHYkdnditKTG80TmJkZzJQK2FXMUx3Vnd5T2cyTnl6Yk5Pc0Zv?=
 =?utf-8?B?dUxXbUU5QkhPZFBwejA4QzEyTTM1Qno3M0NoM1QwR2swR2xocUpOeE1Yam1k?=
 =?utf-8?B?Q2ptdFdvVjlOUDJyZWVKa2ZaRVNzM1Rpck1CTzRYeXp1V2JIZVhJU2NCWWZK?=
 =?utf-8?B?YTYxY3JXMmJpYkl3M250eTNQNm9lcExSRGRVLytqamZFdlJJRzJvV0dac3Vz?=
 =?utf-8?B?ZmZITXdhSW8xUlZCd3d0Y0YwN1VpYUxiaGU3TGpDRi94Z3loME4rMGFCSVdu?=
 =?utf-8?B?Vk8ra3d1aExlVjBHSW9rUXU4NklaL1lPSm9lS2xqd0FJTWllMDFDSWxoY1gv?=
 =?utf-8?B?NFhtUndZR3JGWVlUZXY1QlB0NUR3ZjR5TVE5YmVxTnhTT3VlQk16aVJ4a3B5?=
 =?utf-8?B?VDMrWE5heVQ5aGd1SjJIY0FCYkJjUld0T2g4SDhLUjFnSHpkL0FoNERWblND?=
 =?utf-8?B?TW4zYlhDSkRycVJGUnNEZ2krcUV3dnNmeHQ0eno5Z2REN0ttYmZQNWUwZ3NE?=
 =?utf-8?B?bVQzSThtbUdKT1ZVUE9NWllLZ3A1N0RZLzE2NGU5b2VjdzcxR2xIMWJBcnFX?=
 =?utf-8?B?NmE2MCs4bkJjT240a0o3RGQ4akFtR2hBeEFDSEpGY0d1WExBYkdwR1c4MTZU?=
 =?utf-8?B?Q3N2SnF4ZGp4aEJqODRmQ3Z1WjlyRUdjWGhpYkVHR2dhcUNpS3lCVkloNnh2?=
 =?utf-8?B?SmUrQUt2bzllUHR5b2RmOG5hWlU1UWUrQlIrclNZVVJXMWsrSDlEVHBBSGls?=
 =?utf-8?B?Y1dsSWVELzlSWVBzRElIUW9JUGtuaEpzSExsKy95eUdURWFpQ1QyZFFGUUU2?=
 =?utf-8?B?MFlCRWhTQnlPTE5ILzE4aHdzenF1MXZVYzJkU0dwS3o0eHZya1p6N3N6d3dT?=
 =?utf-8?B?Q2w1Z1p1QnZlbFJLOGRnWGVENDRmWlZSeHNxSmRSUkRoZytCTjN1aVNyNTI2?=
 =?utf-8?B?eW5lTjBjdDlIajVJWlBnSGtqNE1rWDNCVjJZTWlUeGY3aDZ2WHJrUDlEYTN2?=
 =?utf-8?B?TGtSUm8yclgreEN6SERMc0tCL2cva1pKeFhlU1BwelovSUY3SkFvakJ4Y0Nn?=
 =?utf-8?B?V3NueXhSUlF1VnFScFZYQXBYYS9CU2svK1QrN1FGVEIycUIzVXc3eGVKdWdV?=
 =?utf-8?B?eXovdGhSMUF0WEtvZnZQTkVrejNwdEUwdEFxeGtLRCtVV0kxUGlpcytWOWEz?=
 =?utf-8?B?MzFqKzhsU1ZOZEJxZFdJS3h4NUZYcDFlRHhSakVVU1VaM2hJYWUrZlRpcll0?=
 =?utf-8?B?Y1REYmNET3FVYVFJZWQvZEJGekNxSEVTb1AyYnZTSjlmaEV5bXFKL3A5d2lu?=
 =?utf-8?B?TElTelhZcEttcTVKbmllRndoYjNYZDB5bjgyMVdtMkdLSXZTc0w0QT09?=
X-Exchange-RoutingPolicyChecked:
	aWsL1LogvzH16pcPj3XaTZsrlXb4CzrSetKEgcwcpVrISQZ7pHJAU0C89xrRC747mAl5oitlyEUlUpus7Xv8IM5tmfGMoHznL3Z21PtwL+Le5+drdK0vXlnxg2rirDsoBRqOPQnRWrkgDNVo8Z+ibzZXhnUgZF0pNto2EPagGyQ1/UU5uip+rc9b9WY+VmXBqZoMaSIqUuCF1AU56Dna3uBf357oU4OYX7pASoDy5zEPI7H66mW0l2n3w2r33VjsHb3FTiKDKFX/k5MQtZYd0P73Q2RzjIbBabFWFQdLE6QM2vQo7V0tI0/mNSHMRV8OoZrx3K9lhAEvTiblJDfklA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3377185a-9e22-43eb-ef29-08decdcb7ed1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2026 06:25:02.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hCxwha1JvAiXWBsoZx+/80dWQY2m2evprzk86H0hrUCRZwp4a35aXqpNAbKysPAqDLxrAQcQN8J2OwVtiUEKDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8430
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDA1NyBTYWx0ZWRfX+IKCQ9jzWuly
 biXNHpvtopDitAgllNVQtgRcA1ANb7q2jvtSyAOvb9Cv3F8hEMNOQNKE7w9Ja8rD58/aknK1TTL
 fVl+KDG3rnmJsXikjclTQxL3XVGMyHmDhvEjLoQbCTmWsTKn/0wf
X-Proofpoint-GUID: eqElj_Ps2YH80NveyuvciG10DqeH44Gq
X-Proofpoint-ORIG-GUID: eqElj_Ps2YH80NveyuvciG10DqeH44Gq
X-Authority-Analysis: v=2.4 cv=ObGoyBTY c=1 sm=1 tr=0 ts=6a34e0c1 cx=c_pps
 a=ZVLNonFp53krOPJecICuKg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=Tb0wvaZHs8DKBINb-P0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDA1NyBTYWx0ZWRfXx3WELRvnSPlx
 6UlS9vhQbGmb4+9vvVXqkioLtCaJDdXm4JaHc8kT9r5pNLBZvY3idsUyZ10n9omfOK3CuUIqGQJ
 DsuxRgifGULJjw86PQGAtSUi0dB3SLF8Z456U+QZkW7213w/agkPgVxpFsXgDNRmmYK+BRTrS7Y
 K3SwE9vcsTqYh7Q4o9qlfcZfbiD0SP6JuCJBHr1HszkNxvsAjbwsIt7/8mp2XbxX8ef6sibabE0
 nf1Ie2nL26y+p2pb0NRn7t+xnmqJ6MYO+p8B6CFn5FTYOxLvMcTlNZDNgHHxQ6O7g83hIngijlZ
 X965tiuVK58VSMbQb4/+SsZno5DM8nryCn5+4iDws7Gl+4EltzHTuYgrLtstwx88S07ftxvWI1Q
 4Wc00UF38mTob0ja5DNFhNyeRypuu2kQMf9YbNSZT46/WKIw4Jjt3R/44meXv+RTUWI9qr7Ab7h
 RztEqvJbHfZoskGgHvg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-19_01,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606190057



On 6/18/2026 2:42 AM, Jan Kara wrote:
> On Tue 16-06-26 23:15:57, Yun Zhou wrote:
>> +
>> +     /* Deferred iput for EA inodes to avoid lock ordering issues */
>> +     struct llist_head s_ea_inode_to_free;
>> +     struct work_struct s_ea_inode_work;
>> +
> 
> I'd probably use delayed work and schedule it with a delay of one jiffie so
> that some inodes can accumulate before we process them which should reduce
> the amount of task switching to workqueues.
> 
Good idea, I will use delayed_work in next version.

>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 6a77db4d3124..b777bb0a81ea 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -1308,6 +1308,9 @@ static void ext4_put_super(struct super_block *sb)
>>        destroy_workqueue(sbi->rsv_conversion_wq);
>>        ext4_release_orphan_info(sb);
>>
>> +     /* Flush deferred EA inode iputs before destroying journal */
>> +     flush_work(&sbi->s_ea_inode_work);
>> +
> 
> This should happen earlier in ext4_put_super(). At this place quotas were
> already turned off and so quota accounting would go wrong.
That makes sense. I'll move it up to right before ext4_quotas_off().

>> +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
>> +                             struct ext4_xattr_inode_array *array)
> 
> The array of EA inodes used in xattr handling is just another mechanism
> used for delaying iput() of EA inodes. It doesn't make sense to stack these
> to one on top of another. Just completely replace the array mechanism with
> always deferring iput of EA inode into the workqueue.
> 
I'm thinking that a complete replacement might be too large a change. 
Should we consider postponing this work, or perhaps appending a new 
patch to this series to handle it?

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
> 
> 2) Use iput_if_not_last() in ext4_put_ea_inode(). If it returns true, we
> are done. Otherwise we know we were at least for a moment holders of the
> last inode reference, so we link the inode to the list of inodes to drop
> through llist_node embedded in ext4_inode_info. We cannot race with anybody
> else trying to link the same inode into the list because we hold one inode
> ref and so nobody else can hit this "I was holding the last ref" path.
> I'd union this llist_node say with xattr_sem which is unused for EA inodes
> to avoid growing ext4_inode_info.
> 
> This way we avoid offloading unless really necessary and we don't have to
> do allocations just to drop EA inode ref.
> 
Your idea makes a lot of sense. It greatly simplifies the current deferred
iput logic and eliminates the risk of failing to allocate an entry during
an OOM. However, as you mentioned, getting the VFS maintainers to agree 
might be quite challenging.

BR,
Yun
