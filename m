Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C77D2D3ED2;
	Sun, 28 Jun 2026 08:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782635751; cv=fail; b=gMUTHCQ6/xqucEfGr2G5imzQ5VEmrWj3sTL0nRrUX2VhfU8rN+TJh+yb4jmpcbfqUYO37xt4w4tLCsd50pKlrYr8eUwx4E38o8cACG57KaheIsgV07zDiKyBeY8BjjvPl5Lc5cKxKP5iDONDlA5NCNMv7tLeSDOwN1CoPksaAMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782635751; c=relaxed/simple;
	bh=HYFXlxlvUfdmo70mVUqhGKg7iB4HVZ3ON3pP/1H9BK0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kNCHcqnuKBGeNNx38KRPu0fe/roFs0W8zXjF41xn5KpcsbZ6tgCVVJ2exIVmn+4aNxGaQE5ufQ1Ri8dmmou0LM8c41Bw8E1mcgoQvKQ7x5wSfyUGS+veTXSQLJDj1DK9DqzuYO05nsWFpcqSuLu7HbzHXg2SQaHjJUoqJEUHmvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=GqFTukUf; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="GqFTukUf"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65S8A1FJ3993030;
	Sun, 28 Jun 2026 08:35:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=gTzw4yVMZ+NJBVygxwBG80t51DQlL0WhAP5jykBOcqE=; b=
	GqFTukUfy3X2s3ySohFr2ni8Drs32zxc359oqsIpx6/3MCvOeOZfA5nobDFZMtIQ
	9Tn+h5tetdWIRT2HrvGJ7a2eSI6VjlBBQ7uzxoQA5HiD+wgAGNQw1Klaz+XOqKAk
	4i6A+NRGox3+dj6cbxHcuQjrapKXt8/68uw4lcbv3NSOaZv7sktPueIr8zUqs6Dc
	fpJzPrZ0XpnRXVfLhT7EzzYorC+Rmtr/zjPUTSLK5GIff2Zj/Y6MCSjDejcRkAVm
	jHbNW/vNCxmEuaaG6lui37E66tFfNyJq3P9BOtf1oLDURgYhxjRy02YjIgArMQLM
	pXjb7kD3t3O53oFB8EM89g==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010009.outbound.protection.outlook.com [52.101.201.9])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5gyyx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 28 Jun 2026 08:35:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wm8xwLS19A3D413X31GOok4p53LGgOROA65Bz/c8nfEsHTgODIAFn++7acaZR0zbQJvE7gAmhOaqeXvzfWdUeVTk2uDW3EDC5SGL4XC6jwqwTFTO1r69jf/PHJIg+flGWdHJ8fSp9FUzjUuSHwG0sHLtdlFVXsY2bF1nvdCjVDuChhmRiVrZLtVBuO7/Uvb0G3Mf9MDiBk+i5GPpCSNfPe2bfMA9ZFdlWd2qexBBdLCF0+TQRl4FmXWwzqBBuVsu9EcxWyXvOEaWwbSWxiAOK3RsCBU9V++vsuRo3Fh3CmuGb38NHJ8tOS2Lqye89Qvgrsn4n6jFFTfiO5ULOmyRMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTzw4yVMZ+NJBVygxwBG80t51DQlL0WhAP5jykBOcqE=;
 b=SSh9ux0TpmJ1IyGEC1gWsR2180b47CIS2+qvIUN9O++frxcsitLGp8ncXyA2nknGDN0T8FIkiC3KewoVwB62VA4e36549elD+/Pnc7+ZEffnlsZCM//dZhY4tTNpz4nba3MHU2Xpa/DwF9xxAot/hUa4PmrDk76kuItsnETmRGfQ9yfjRH3hJbwJthudWUncFOjmdCtpGQf4SF5jqSqfluzBMULeh+rXrJ/k4ofYSG8NhQyIcNZNTrwXmIOgLib1vV/bQXAvuhIQQEYsv59igmcRewTpEKazDUDK1iINwkgKS3HhJ0r0+wyvhNAENfc+pTCDjLPHjjbuzphMrfqT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23)
 by MW4PR11MB7102.namprd11.prod.outlook.com (2603:10b6:303:22b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Sun, 28 Jun
 2026 08:35:20 +0000
Received: from BL1PR11MB5333.namprd11.prod.outlook.com
 ([fe80::f5ec:bde8:d36f:ff]) by BL1PR11MB5333.namprd11.prod.outlook.com
 ([fe80::f5ec:bde8:d36f:ff%3]) with mapi id 15.21.0159.018; Sun, 28 Jun 2026
 08:35:20 +0000
Message-ID: <c66cf839-ce82-483c-a463-31204cd2cb5b@windriver.com>
Date: Sun, 28 Jun 2026 16:35:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-6-yun.zhou@windriver.com>
 <ipqfj2abofanrrcapw2qp4wx6x6m647nqjrhqpuynpxxlh5ugr@utgka6gkeufw>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <ipqfj2abofanrrcapw2qp4wx6x6m647nqjrhqpuynpxxlh5ugr@utgka6gkeufw>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY6P301CA0013.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:3be::11) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5333:EE_|MW4PR11MB7102:EE_
X-MS-Office365-Filtering-Correlation-Id: 920c5086-a692-4e6b-b31c-08ded4f02f9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|56012099006|11063799006|18002099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qORNzs2VYOamIn5pVbnEiRiIt3GUk+P1tBKbLGaBVYD8WRwABm7dtPSF9jse4dSnciQxFDuQE0NncuTeP0cKe2aUpUTFLEYVpb+sIgN9DPfOWV3nHR+QwrL/Vfq1RcspljYLYcse02B4bMtb19t19EKceRWRZBj/ByGejj6o9bV34GAzgfI6h98M3gnFr926tL2Zqf0YcYensFheUCineEE/m6QijZW7FQyUo73HWfZwTf2e3vBLQm5QRx4AQVZvy4Ggf7/x7tssft1Fi4B6cav8MzOlmkLK+hNMbBVJSNot53/bWRI8d26+j2z1tPNA6i/PThZ7mfcZjwJhiZp+jqidZs2RTMYTThRYEtFgG94bKeJCcto81D84QszihxFbud2sxF8kxw2xSQ6QYRzoeqLydcy9yqAUKuQusVPc6jhdgXNJa/YHy2CUwab1ydn1zuD1H/AaXbSnRkct1A3CBhar95bUSnqdCfdkzr3FFPjbtEi6+5HK+W3qaVP7OTzOAMbw9oelsDdwbHfhCqchF1qyGMdTG1f0o8A4mpIq8oaFV9rFXu7cA0rjkz8SOVAzfQkh4DMAhf8I6Ro3RoH9PT8o9a+Jy8/JDQUKTTdJ6Yq9L6crgE/SmypF0YMd/ldqwLS2aXvWIT0dvaM40RxlvxBDECPztuBZIcU0N8sPzoI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5333.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(56012099006)(11063799006)(18002099003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1M4WjBwSlUvV28rSmdXMml3MkFZcForV2xzMmpHNFlZNTB0azhvVjRBOXln?=
 =?utf-8?B?MDMzRW9OUUVOY1A2RGtSdklmS1F3enVZb1hGMEIvZUM3YzJhQWxyQUh0a1RT?=
 =?utf-8?B?dEFGZHBzR3B6eUY1WlJRSEdxZXhtaDVVbWo1TnhuR0R4dFNUSDNWeUZBWlBz?=
 =?utf-8?B?SGlrMXVQMDBqTVpqbHBWVEtBdTBSYlZHSldudG5nYzFJOFVBWnNwSEtHa1FG?=
 =?utf-8?B?TjFUdEhIRDlNbXFqdmwveFkwU09neDcwOU5OMzZwWmxTa0RzQjRieTEzYS91?=
 =?utf-8?B?V3U5Q1V5S04rVnhoVUYwUXdCWDdQOTlvN0JGc1d3eldOaHVXVThGTlFvVDBm?=
 =?utf-8?B?RHcyU08zQnVMTUdZZ2ZINldId29ORWZqMnhvNUFCdlU0V2NNMC83c3BSSmNE?=
 =?utf-8?B?TVdVVFpmb25mSEJFOGx1NFBYUWMxZ0ROdmhvT3psQ2l6YUl1cGxQR3VyYm1S?=
 =?utf-8?B?bTlZRDVUbEcwWGk0WkNOZks5ellGTUFaNkg5ZVYzdTBVRWJnOS94U2dYS0hU?=
 =?utf-8?B?VkxqQ3BCTnJtQ0pNRVpFeXJCek1wa2FuOCtPMVB3NG84Ykd2WGpqUFp3M0JC?=
 =?utf-8?B?T1lmTDBHSURhdUNqZ0xlV1FVSUZneng0UlhtS1BtMnl5OG5wb1JjU0EyOURV?=
 =?utf-8?B?UmFhTUJZdm5BZE1JdHlVY1VSRVFaOU1VU25WbkEzcExpN2RuQU0yanhWb1A0?=
 =?utf-8?B?MENmU2dyWUpMY0VaYlNOSGJVVlFjL1o1RGV0emRNOGtxVEI0RHdMM2hMYklP?=
 =?utf-8?B?RmUweTNqem5NSmk5WExtVmxzRFBPQ2RHcGtncUFOWWc0TjlDTmxJVFhrYTRl?=
 =?utf-8?B?TDRFSGg5Z2Job2tPaithbWFzRTB1cmUxT25Sc0lNM3p5eHBxd2JINEE0clZQ?=
 =?utf-8?B?YnZ3eVF0S2ZFS1B4NGN5VlVUbVdmSkg4WmlzZEdTVFdLZGE1d1Y2dGRYajJ4?=
 =?utf-8?B?MFZuaDRGaTc0WmN0Q0syV0daK21SZnJ5ZHNBMStETGE2U3VocE1FSkFTdHhP?=
 =?utf-8?B?Q1NsM24wYjIwa3dodFJPWTVocmY1RmdOWFQ4aG1zUjNVeEl2dmhBRS9ub0hq?=
 =?utf-8?B?WnJSQUtuWE4vU2hmT3BsYk4zdk5kNVZGNldSNG9kQVFiSUFWdTc3VHVTcmNv?=
 =?utf-8?B?LzVaWURHYTNOTmtwRmRLUTJjbVhkYWpCVklPY0ZINjhKRFYvUzM4cHFqV0gw?=
 =?utf-8?B?bm9rVFYwQ3BzTWJJSzFCQ0dZazFhR2E1amY2VWhMYUNLZlEvTHdmK1FieXhm?=
 =?utf-8?B?MXVoRkdPbzNtbFFzWVYwQnQ5eVFZVCs1cngrTEZDclRJR0dHZzhzVTVtVjBG?=
 =?utf-8?B?a2FnbDZXSWliTFVFWWVmaGM5NENlbWdIOGhFZGYzRVlYWForT2RMRkx3N2V3?=
 =?utf-8?B?V1RmdTBMcUNqK2hxb0pjdDJlVXFsWDFaUmdwL2I5V21qVnMyVy9raUVuLzRW?=
 =?utf-8?B?eVkycy9BZlgrNEJxMVcrbFBXWVQ5MzN3dVJBT0dFcWRxN0FZU09NWFNXS1R0?=
 =?utf-8?B?VmpFcEpIYXJCY25vcDFzQ3VuelI4dVVESmc1eUNZMDNxaUt2MW1tZno0N3Z5?=
 =?utf-8?B?VDY4cWJuWWhMOFJud3ZEdW1hL3RDbkQxeVpuOVhLbFJ5OTE5Q3NGYmNaV3oy?=
 =?utf-8?B?cXBoUkZNS3o1bGdVdm1DMFA3ejVGUVQ2bFZFRktKeFZjMllQbUgwQ1Z3WFp3?=
 =?utf-8?B?QjlyanF4WkxpRkozWUY2Ni9mUjByNE9KWGVvQzBTQ1BGbTFSWFhQYTdJWTht?=
 =?utf-8?B?MW5Lb21kVlV2WHlOWXRtUlgyM2N2TllBV1FlL0FnWllsUW9NRUdJWDZOSk8x?=
 =?utf-8?B?ODc4NjJFOXpsaEdFR1F3ZzhqZlYvdTNGdFVnblZCREE0ZFNORFkwWCtqYU1h?=
 =?utf-8?B?emE0ZTZxVHZLTWhzV0NXKzZGb3lLbXMwekQveW05Q0h0QnJPbTQvQU9PL3Zw?=
 =?utf-8?B?RWZZd3d6WWRNZW1MNC9mSnlMdUFlZ214K1h5ZldsaitDUEMwRmNuTmdPZGFU?=
 =?utf-8?B?cUlMakpOd3BrUktac24wUFNqUzdTSFVWTHlRNGNSbzA5L1pBL0NoTU5LaVcv?=
 =?utf-8?B?TFhUamMwcEZJWitxWkFJZ2FLblRmU3VQa1FIbjFWdlUvcGtMbnk3K0s1bFZ1?=
 =?utf-8?B?VW52cCtyamZudUd5MFJiSytFR1B3dHRraUxWOE1iOG05YW9UVmVkUWgwSFZm?=
 =?utf-8?B?RElYSDlaME53YUNqQmlBQlZjYjZPREI3VXBVeTRDYVlWcHR2YlJRcG9CaXBq?=
 =?utf-8?B?RXRxdlFtNHkzMlQ5cmJkRDUvYTJsaUpBU2lOZ2FXdURKdG04Q29Xbis1U3dM?=
 =?utf-8?B?SUFDUU01NzV1dkVhQWVxV0trMDhEQ1JYVzQ4UlpBKzZTZ2VmVzFvZz09?=
X-Exchange-RoutingPolicyChecked:
	EXnFFb4iylJLNlJnpEzegeCAlt4i8QoB542cO2OC2i6IgCQ/2NEJtGQMGXaRGYe1NicthUA4rVZ9wl+yy2A3/xtvsy2JI3MEgno9eHiMnPMPTGs0QYm3ADaIC+33/SeCENdTGgTwXvyPRTwu6J+WcvWwQxJfhYrl+aac+Nev0ruOxpYRLD7AViwSL52p7axszokfNIkZl4J6Kby98bWK3IcpTa0vDMsftHhwg/zBLXVmSIoQQz8OsR8Lvc7m5x0CNG56a/KM+ZOyhLHmLY+nO5HHrIfElpH69PoRLlDMUWsKVIa2C+1IlzgpDJVjrEGf1X1vMAXkwfC41wIaFKLX9g==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 920c5086-a692-4e6b-b31c-08ded4f02f9a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2026 08:35:20.2147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihiW520A5TPlRj3+9pFFNZhwk0Yv2ibZI2mp34nsUSlCQujPjgYZslcFd+Ye5fV+GdUEPClKCpZWjZ3PYn9QCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7102
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI4MDA3MyBTYWx0ZWRfX1U2kBIHAAaA0
 sKC2wCnLMF15n4LhoCNV4LJIb9gycIZ7zz3yYh1V1VvC6GfBsrN0/F6/Di6o/aBLMj88eS66rPr
 OZWZ19aDrio1KC8b9hMkJX8wNbn8kAszctRlZGNBgny/BPBOUcjm
X-Proofpoint-ORIG-GUID: f3fKnA_qTURp7b87vDxz2JrEDFGqHE5F
X-Proofpoint-GUID: f3fKnA_qTURp7b87vDxz2JrEDFGqHE5F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDA3MyBTYWx0ZWRfX9sKPSYbG84EK
 WDhk28/o2AWz+9evb3GeLqvI/wwuOQT8CZKof9NfI+sEcJtzuSiUX8JBMtp1jD6DeK+QgWnAlNj
 6dskVugTyvE7/0uUjdqqUgvp5Bsu6EYiZ4oy7fA5o8U5zQgQniwTbd7KGOq2cUcE+NfDhVLGXco
 8+hmQAYhZPMCbnxU+8uYtIhQRyOUvfinSi50Xho40ghNF3ucBbsVJ671HuMZDEh9gaEkon0sNQB
 DlrO4gj+IsW0o3goSEKV/zf1m1r7gzhwEgEOjsGvKHdeD5O/8CEB5SQLCEeeYQULu3IxsRCfe1q
 6YKD/pMgMEvEa4hf6jIMcG62tTf94YkAv6xGMNVGn6A2aN2xrtqfcejlcXUkSSZNI7lRu7JWKDF
 arax1OAp0P6tKeDo41WOlxFbXai53AsquszMxz6vWQifIvtRN7ZRej9PznaqKTfU53z7oYTvYoB
 wSOM0d4dT6A+3/tw8oQ==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a40dccc cx=c_pps
 a=AhJDvPO6yzy99x9PXTlr3w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=Ua6EApRU29KFdewkOcYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-28_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606280073



On 6/27/26 01:23, Jan Kara wrote:
> On Thu 25-06-26 23:29:41, Yun Zhou wrote:
>> On a corrupted filesystem, multiple xattr entries may reference the same
>> EA inode.  When ext4_xattr_inode_dec_ref_all() processes such entries, it
>> can dec_ref the EA inode (setting nlink=0) and queue it for deferred iput.
>> If the deferred worker runs before the loop processes the duplicate entry,
>> the second iget() may block on I_FREEING while the worker's eviction waits
>> for the caller's transaction to commit -- classic ABBA deadlock.
> 
> Hum, this looks possible but it isn't a new thing this patch set
> introduces. Even before if you had corrupted filesystem,
> ext4_xattr_inode_array_free() from ext4_evict_inode() could deadlock in a
> similar way against say ext4_xattr_inode_dec_ref_all() (but practially
> anything calling ext4_xattr_inode_iget() while holding a transaction
> handle). So please leave this alone for now. We can look into that once
> other EA inode settle.
> 

Mainly because sashiko-bot always flags this issue every time. I've further
improved the patch and believe I've thoroughly plugged this loophole. I will
include it in v11, and please take a look when you have a chance. If it 
still
has issues, or if you think it's redundant or inelegant, we can just 
drop it.

BR,
Yun
