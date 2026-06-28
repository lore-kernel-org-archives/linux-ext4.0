Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AC81A6838;
	Sun, 28 Jun 2026 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782634467; cv=fail; b=lz6fklVtMNbk1YQDoxkfwA6iGX/YSd2Ugsg9kfsS2dCx8hXwJYLZ05bVtrFAHoLIeW2Le/oxkg6DMkAX8DKCX5k8hjJmxMZOge361CScK3L3vRkqYNBFsg+3uFAwLLodeETbV0+aMCbgmLhS5QAoAY1crOxZ7515DL0seK5f8fc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782634467; c=relaxed/simple;
	bh=rCEAlXUN+ghvTbOZ31Fs7M6woXgaEQS7OVtfEYUtCqw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ohaWQJWZcn8rNDfi8WK8/mIGdod0T4Fpmz3mCFT52KlnBYR/Qwz57mrn5OOvKlXDkOnu4mjSXIKnklAbpFI+28srYubfv+iYJJnkNn+WGaJc1IbiVfQrvmgKcMdRwLmJQ0xdW900HCXFEcJYFijNnM/YLsnHOmDJFVxZRJl9gdU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=X6jBFj5l; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="X6jBFj5l"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65S8A1Vv3993020;
	Sun, 28 Jun 2026 08:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Tk5y8o0rvjBMgqjpBuV6T43vpw0MK1xMNNxAVih6KvU=; b=
	X6jBFj5lyF/VR7a68Zqg9dmNy8voGgZW9f0Yc3KNNe4MY4nG+/+eVFCrZV0VKxy5
	XBT+NkJFwE6tYelaY/R1X9z7SbEP2JaKNHSJLwZJiGuLj84ANH0++oR+Jvx1PjiL
	cX8mX7kiXaCoqhdDmgkF4CKnEOenu6ri/uR7QEyZeu3NnBtDGjaQPA/Hi4QPAX5r
	DNmJGDQi1MscbV3wwFDR/TRgOyYd0BOi9ZWUryjPdskZ0xQGte1iCfu12sFahnFm
	fIJKhS24sa/Bf34serYyrMgTNSiCDQARLmzUphZDSrKz4cCwFNnDDLw9vr+cRn3y
	sc0CtCcJ/KwOsPcNn9hjow==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5gy6j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 28 Jun 2026 08:13:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O64c9xga9SS9SVqc/93eP5NC1a0VFMLdhmrCRdftqz5iit/2ihdXLShT2ZBab6wYT0mK5IB7wOFuA+EftAtaVJtrp6SsvshSlvnwYYKXum0MKqHvTId62ja0U2Lv6u1zOWj6m5Kg6Qjktrqf6vveEe5g/TU1sx7KK6e/KseovBqueAXYTXdMruEwkhbzSb+V6P5wqqzTw1iys9wXjvaeCK71YCp9pu8tShwr2gRhIQaCECdOhYWj4aUtbNUpN4F9hSkNPfBilU4brrJ8s3SvKUpru6pvmugnslIynO1zktHYvNCH1zv2muZHfFou29pELXAeJtIDLApVzR8mcdkrVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tk5y8o0rvjBMgqjpBuV6T43vpw0MK1xMNNxAVih6KvU=;
 b=pWVfFV1uR8wMEYOSfFDARXdztVnjBsWvcifBjmKNpQYqKgDgMO7ae6zOOQTx6poANaGr2qB3lVhOBF3xZQQtxjcs0KIwwZGt7nDTKqg2KBbblO6j7FLxgi7DRK3Ew7S/nQPMzfKovx74p0veQRExqdwA3FbYSQYsaZK+KzH0Q8lI1Z49+0sxi5NIXjZnAHMEXxgma0ARiAzcPGvQDAO4VrfEZFSs6CayWSvTX+jO3Cdgni2qDrvQLfnuqFWsFYQqtTTI3nvcZ5e7e8elUtqjTxEPcyqSVNWUs2t++ACKCmvI/G9BXMhyt3LtaVVZiDHS9eQFzGC+ItXq4GGKmRoJJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23)
 by SJ5PPF8AFAE74CF.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::841) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Sun, 28 Jun
 2026 08:13:37 +0000
Received: from BL1PR11MB5333.namprd11.prod.outlook.com
 ([fe80::f5ec:bde8:d36f:ff]) by BL1PR11MB5333.namprd11.prod.outlook.com
 ([fe80::f5ec:bde8:d36f:ff%3]) with mapi id 15.21.0159.018; Sun, 28 Jun 2026
 08:13:36 +0000
Message-ID: <b7f1b4ea-6594-4dd4-a035-f555a822d48a@windriver.com>
Date: Sun, 28 Jun 2026 16:13:18 +0800
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
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <t7ewb5or7ybrt3mwbnjxjddo7ok75dopf5czoib7nyou4zwdmd@plj4clfhoybl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::10)
 To BL1PR11MB5333.namprd11.prod.outlook.com (2603:10b6:208:309::23)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5333:EE_|SJ5PPF8AFAE74CF:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1da196-1e12-43de-f1d8-08ded4ed26bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	oeKMs6HB3q/zcOHN01wzOI//QfD4cKqlxKbFwdhS9CY0rBUkrnTCQqSPm+Phl5xijfLJ9QYET+4HDFoEa9+UeHUgAxXggxMr/cLJvVH4XLEXOhlZoVWubUxwt5NNmFo4esfDk5UDHIwd2WbsmRd6BaR3T3Jc85Cqwvbfa1uJNh2Bxlvfo9AhMC1Aba0jHmIwxjomWLu5Wiyb6IPDocuG7wqbU2CYpSN+ZhYI5H4fWmkZ6nUaXTylux+GLK53voJteCrYSrzDpv1ymNDtj3SrMDDC59BilvDaq986V9cnFn0DsksvWMMvtayVKviTcGbvwHtXuvYL2vsfLDLKgvsQ9IFlk2jkt6tcLRVLQYi7cahQSoDmamIfByIiHdyFLadVHg7RYzypQGOD1Py5Kd6aZkmHX44LGaRAE/8YklZl7dWj3MTT1dDpgbCHkPzZhC1+93hPuO9+9pFli2U4d3OUUloPzj6KefVrbYKuwWtM1CBZwe6gLBUSRCX1nNJTkRTv9CObC/6zFrmVUlHV2BcrHvKUxtS8eVZ/qfCH7CxEoxYsvAktsXYL62GaatTFzZyxaB3xjjmNtrwDxUyiPQ6+lpiT62VmP9PqFLi5TUcfXXYuv5cit40u+i9w34yetA+29NhXYIQm26Ic04WSovjenEXNR6Z3RlMIxc2HVtbzYvY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5333.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzM1eEdWci9rTkYxUlNoVWdLWVJaczFRRnlWcGNXd3h5bFVMLzVrWGhqSUxp?=
 =?utf-8?B?aEs3VVlOcjA2SnV5Yi81R0c4MVJaUFpoS0cxOGNmaCtHL2NnUzFPSDBTVUcr?=
 =?utf-8?B?L0FXRUQ5U2Yxc0FjSENWMVFrSHV4S3pHSUdXVDdmNFpZdzFHNkxLRjBjUFVW?=
 =?utf-8?B?ZU5rSkdnNm51ay8yQ3lLeURBL1VoOTFlMm1SbDRRajBiYXA1UStsZGlza3Bo?=
 =?utf-8?B?bEMwdzgrcU1FSVJkS2R6b3FmcVJEbjduVFZHZFRWMlROS2t4ZlN4SWZWSkdn?=
 =?utf-8?B?c2h2SUh2ZVRrZHI0Y0JnelFaOEp5N1BZa3VXV2ZjRmFBS0R3WExmdkdqcVM4?=
 =?utf-8?B?d0pyMGlERU9RNUlkUCt2cFVZc3pkNkNYMnA1REdLMy9vZTZYUGlWak4rd3JQ?=
 =?utf-8?B?RXpLQklOOURDZVIvMDk3THQydHFWQ0hPY3NQWkhYUG9Ma2JVNG11KzQ3T21y?=
 =?utf-8?B?WmMyK2NybUtsQjhmZjNBTmtvNm1nVWhkT0NqK3k3ekFJMGhmRmR2bmpzRTNj?=
 =?utf-8?B?cmN0WDArSE9GL0g3dkJuL1Rmb0JoRUdybkJla05jOWhVbEpVVk5CZUVoYlMx?=
 =?utf-8?B?YnRxdmI1TnRqUjY5WlozSkFkQUV2KzZBOVVQQ3VLRUM3NktNcnB5SmhQYnlK?=
 =?utf-8?B?MnU5MlBvNnoyVmEvNmYxdXpJbXNYNFRvT05od0pHNmpJTkhHbTFKTGNWQjQz?=
 =?utf-8?B?RE1mN1VETGRMclFnbC9CeDZHRVJTMkJteEZCM1QwbnVVR0ZiV2x3YnlBTkht?=
 =?utf-8?B?SGEwOG50aVpjbEsrcm95Ylk0OHVkbzVtcWlxTjVMQzRKdW11MTFxWTV1dy9l?=
 =?utf-8?B?ajVPcll0VkV5RG84S1E1VnVhM3hnejdNNWhiM0IveFJLUExtM1Zkd1QwRW1n?=
 =?utf-8?B?MkswbHEzMWRxQjFwSjk0RnB1dTk2eEl3L3FEZnlnWlFjWmZWZmxPc0FqRHRk?=
 =?utf-8?B?UmNTTjRlKzR5RVFBRGZha0I4dURiQ3dTd1lDZS9leHFuMkhxdmFxUDFuV3dY?=
 =?utf-8?B?VmdQRVRJc2hrWk1Cb2tzdXF6Sno4ZUQ2WlhDdVhoZHlOS3M0bXlnMHVGeDNJ?=
 =?utf-8?B?Nm1NdlI1UWlVc1hpNTdYUEhMcWh6blAyWHlEcHhKYWZlY1hoK1I0OGZCZW1z?=
 =?utf-8?B?dW1GUzk4MFBnUWFRWUtyZFlvVTlwNFdEdS90ZE1nbHBYWGF5Z0hUMjBFamlT?=
 =?utf-8?B?c3BuT2pCOHhNRGQra3JULzZrSmVWMmNBRndlb3BBZjUyTE9WOGxHNlFPaW5P?=
 =?utf-8?B?WjRIaTBSZUg5dkRPZFhRMnU2TlNWMjJsd09xeWdIbXRzcExQRjVWQ1pHVHVh?=
 =?utf-8?B?SG16a3duV1ZsRHNEUXZ1YWZrZ1ZyclZrZmVPMUFjQVRYajJNMEdyNXdTQWl1?=
 =?utf-8?B?cjBQMDF2RkVaNW5lc0VyWUlsRDlham1ZSFFXMEhmUVcyeHBFV2xtL0NwRWMy?=
 =?utf-8?B?TWI5aEs5ZXJmUFR4OGNnRmdkNkg5bVZFKzBOSlZBeElvMnVieFhoSy9nWllK?=
 =?utf-8?B?VFdpUStEVURROXFNTTRvTXc0dGNteUdmS084T1gxR0R5c2ZHWjRYSVZHenVh?=
 =?utf-8?B?QWV3NnRFblNDWStNMVBiazRaYmxUTzR0WlNRU0pPaklEalV5N0tBT0JiRlVT?=
 =?utf-8?B?U3BUV0hNREJOUDl0azFrNEpiemhRd09Od21XMXdnSGk1aWttNUsxN3V5NTlJ?=
 =?utf-8?B?SVlEdTRWeTdUK244Qm0wQklUMGFPQzlsVGJKWU0xOFMxbW1XRUFCc2VJSWda?=
 =?utf-8?B?MDBxRDkrNkRoS2FCR0Y0VE1sTlBEM0pXRzhIdUtERTZ1ZEV2d05qNGI5ellC?=
 =?utf-8?B?WHdsUVZLLzlQME56T21ReTN0WWxvUSt3NHhvZ0RTZ0JaRjZvbkdxVzQ3cVYy?=
 =?utf-8?B?bFpab28ySnJXZVMxWkRPekFXSXBhSFJSdVliVEJEUHl3bUZxM1pNYitpd1Qz?=
 =?utf-8?B?ZmF0eEpkSkpLV2s1YjltVEJDRnUwWjlsL2pNRDZZVTN5MHp6M2pYTURkRVl0?=
 =?utf-8?B?TDFiaHRrak8yS2cyOUJ4N3dJUUl2aENOYk11bDhrZWJKcWJBOTFpaXFmWkcv?=
 =?utf-8?B?ekJ6TXIzdElTOHBsUmlBaitEam45Z2VTK2MreU9lZWVQTGN3TVU2NE9UVlFH?=
 =?utf-8?B?V0ViRTFUVmw4bnY1RGFGWDNidjdEVWEyR01mdzk4dDEwSWthN2lCOE1mekpr?=
 =?utf-8?B?MzdkS1VZVUtOZmgxSHl0NEpncG41Z1NkRW9FTC8zQWhPM2JYUXJDc2tJNzN5?=
 =?utf-8?B?VXQ5dXU1cDhzaHVTWDI1OWVONkdaR25paG8rUnIrcVU1R2lib2k5YUVzM0t0?=
 =?utf-8?B?dHNEZVFocXFkc0FGV0NTeDZTN083MXJpSVdSbzE2MXRzMDJKMXFIQT09?=
X-Exchange-RoutingPolicyChecked:
	A3kFGInZCrMwNBLfKjeSIQVXaoP6Ag/fOZYCfHhmhdkZwMkeDjwfzuPA4hVcHGohNPVDk0OUo++FhgpRc5dn8aC2etuMvaKxAxTFhL6kcxxyUQnGFlneKnCA/0Z3H7BJUj4AiOoDIk9/7DWmA5S4+kxfgmU1AqUaBOYkldRSaHrzO+GCkWP2dYnLhSydkGDln21t8rCiyhr9hEBxFRFYCiAObiN80rg/NkpbQMIyzqjSSseSU+n1sdv3DL1T5meCJkpMmf/ZY4WQBa0eHuzLftGJktoZJSaAiJ2YGGMWaqpTPGmoF0vpwmvPDY6qWI00OsAW5g4MDP0VAvzFR/aKKw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1da196-1e12-43de-f1d8-08ded4ed26bf
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5333.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2026 08:13:36.6531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBC7rMvQi2PRxycltSWxWbSyVQp8izJ3Kf4CH2fEEnxl0kcOE/01G255/IXLPe75FGk/tG1JLyJOH9p4vgQYbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8AFAE74CF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI4MDA3MCBTYWx0ZWRfX/dugfXAAMqY2
 QUvva0UyaYC6Aaqgm9i4ttRohpKKGTDKSSJDxzjDWuCN1duqIZHPjhOinbSGaL2ZeW/2dRbLHHh
 iOmwhyDdhAdyM99utivnD/BSZWmFJr6oDMbBhQY71Bjpj1oL0L4G
X-Proofpoint-ORIG-GUID: 0gtfmEsPbaoUdEbjq1wPP852_sSrobPO
X-Proofpoint-GUID: 0gtfmEsPbaoUdEbjq1wPP852_sSrobPO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI4MDA3MCBTYWx0ZWRfXwWk6agFto5OX
 CRcMBnwPqDWI1wP3+MiiR8AfD8c7iKZp/2wkKOJleFUDhJnTC8sTEXvPXC6Nwy6yXKMqbXDOfFB
 RBmhP3JqN1N85vOFo9nDgub6VHHeROVUKSRed9hA9zUgeQCuZ4ELBgF+NUbTaV5PhzZunJBLqp2
 Z9D9tYsaCcDezHwRj+mGGC24yyqxVcxWI59Z0RsSV3EJ8gBwqCPJ+tauVhxNLBZWe2kLxNAQSbK
 NV5MKao3XCfN5IUGAY6FkAQM2BPbxehDI9DhoCzAtqOAL4lVUar1N7bouYyrV8/pIYiL0JjiOv0
 zOlsd0Gw9+G9ekSO5xOLsw1tcdjGFY6MB+aBcQDgSovA1XYPW03LzP1zbKFRIXqGxHns3TsuzPa
 UFoQx5ck4vdkkCD5kPAaRNTnnqR3LGufeTjnKDSq89fbaFV+hMtnstXLiOGeuXr2PaervegxH42
 4d2d0Wbe+pMYgr215UA==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a40d7b5 cx=c_pps
 a=68eZn42HhoOzQwLNwT8gAw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=169C9JSx44FnDXieCBEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-28_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606280070



On 6/27/26 00:53, Jan Kara wrote:
> On Thu 25-06-26 23:29:38, Yun Zhou wrote:
>> +
>> +/*
>> + * Drain all pending deferred EA inode iputs.  Must be called before
>> + * freeing resources that eviction depends on (quota, block allocator).
>> + * Loops because worker iput may trigger eviction that re-queues.
>> + */
> 
> Can you please explain how iput of EA inode can trigger iput of another EA
> inode? So far I don't think that's possible but perhaps I'm missing
> something.
> 
>> +static inline void ext4_drain_ea_inode_work(struct ext4_sb_info *sbi)
>> +{
>> +     while (flush_delayed_work(&sbi->s_ea_inode_work) ||
>> +            !llist_empty(&sbi->s_ea_inode_to_free))
>> +             ;
>> +}
>>

On a corrupted fs, an evicted ea_inode might still have xattrs and point 
to another ea inode, which creates a potential "re-arm" scenario. Of 
course, this situation is extremely rare. Therefore, I plan to remove 
this redundant loop logic for flush_delayed_work. Instead, I will add a 
simple EXT4_EA_INODE_FL flag check right before calling 
ext4_xattr_delete_inode(), as shown below:

+       if (!(EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)) {
+               err = ext4_xattr_delete_inode(handle, inode, extra_credits);
+               if (err) {

This will be submitted as a separate, optional enhancement patch. What 
do you think?

BR,
Yun
