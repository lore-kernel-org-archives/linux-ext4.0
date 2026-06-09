Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAD2360EE8;
	Tue,  9 Jun 2026 03:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780974797; cv=fail; b=nNUawUya7+et2lSQMN3pIQU7xG4gabL7I7XYnoQVho0PoRf1nfoK9ur449lyiKtpgh+1D7nTjCusSM6R6qO2WIL/+x3dNiyxmuNQrwjZNgr0ZzzOeMDZELW69ie6gOQggYOA+fXQDH9beVrTX9CU5yz2qrpUfSIEjWuYfXTglGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780974797; c=relaxed/simple;
	bh=3C/F48WIhsq8PuiqHJ3v6D1BbkxF2ZOvRQs1ohSPA/Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PejYuphkKulHmuc/E4rucKLvw7Mtde7/TbpRKuwX8Mni+QW+V0/8NNY40jVzTa5UDcwIOEu2S9dPo13FuucCnTWpqJlrX5ljZYCgsqxKO5b/gWpZbOCmmUest97gEdBqIxf0v+EMv+0Prz4L5d2ksWIkno+pHjRimvfgiLqxppg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=aZxIJPWd; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="aZxIJPWd"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6590vtYr1373872;
	Mon, 8 Jun 2026 20:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=4wys6dJjVlQg2Bga6c4WJgEaH7fVZy7Or8+JoDErcMQ=; b=
	aZxIJPWdqDXZjjwETbyVgTYhJD7gENMoP1cWngFPXiFysZOkIkd/DBq3DMYZM9XQ
	+q71wD4w0xcgpg1/F4zXH7rc8BOUyyuxpSKCPdmRWk8pOipCJ6eFZ/zZtMlsRNsc
	J1SbBK5plyJ/nVE/Y2/Ykyfqz7ZPn8pMxw4jUFSJ86eixBX0j9+d5CMhOFuyjIHi
	1I+ZpZbwFVvgGte6qhnRNrzgwPJtqxTKVIg+G2QKKyl9+iPevG5lxL+q0jRckedu
	V1Rqi3Ws2iNQ0m5HkCfKBD2g/jxLtPNdI62Z5RVSGTS/gY6hOceb1RA6W0TAFriZ
	bMvLQf1KhROM3cw0UYoc0Q==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011018.outbound.protection.outlook.com [52.101.52.18])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4emety3pv8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 20:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bL2Y/RkCghmme/9WfuQ5mrBZ+C78i3ul3ZpdGY6w9vHoRFfzJi70jJ9bqK2Xr+htSxs88JgHfjcmhhc0OuHbmGlWDEmlJpGcnuMqc5XPBr9KjcsXNuKW+u++g4rSRMpsyGP8vw53I39O4HvsLiHvGYpf9VZJHpD5XDNe1PXCmuIH6GWzpLklN/mYcxh/3qh9HFc2Awj8/BxL1jl+UgFSBPImc7qhQCEtZs1OCWD3TVYJLsRuR7+trONGOd328z7Tf95MZl8zz3wZn7sWIOct4czHamNHFXNNpDZpgjLQDtHY67Dr+t+TJaUf3/oeWcJvMoshLT8q/rwOht2x1ut+tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wys6dJjVlQg2Bga6c4WJgEaH7fVZy7Or8+JoDErcMQ=;
 b=SRum4CVPAqFV3VIfnj9jysRnVsavvw5QBIE0F/rnq11S//Tp8YYPfpJSoitT3aNQsMuQ9wAwwz7OnVW+HJsXbCzmW4dzb58jWSZnX4GyTsRVDpwwXexEGWJI4yW1RfCXdI0+3rDn/XMpO3N1ukixploUrRmOgixcQJK0dhwqdHku7EDqMnodo+rZh0ID+OwOvTtsTwaY5Xzmok8gc8FWNQd/pyihuyeNwZHIlTZMxRXWKpxobrQfwfM7IgcUU/4aXY9b5dYGRxXaaKN9vC+5qlUa0Zur3LsB7G4UJoqZzE4dwQvxIzLTCRY5IJGfXJl6RFH9RKh0yG+jnEnXzPDHUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH7PR11MB5766.namprd11.prod.outlook.com (2603:10b6:510:130::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 9 Jun 2026
 03:12:49 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 03:12:49 +0000
Message-ID: <3aa6fe7b-7ca3-4b49-a8cd-a5876e4dc086@windriver.com>
Date: Tue, 9 Jun 2026 11:12:41 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
To: Hillf Danton <hdanton@sina.com>, Andreas Dilger <adilger@dilger.ca>
Cc: tytso@mit.edu, jack@suse.cz, Amir Goldstein <amir73il@gmail.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260609011522.1708-1-hdanton@sina.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260609011522.1708-1-hdanton@sina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0072.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::20) To BL1PR11MB5333.namprd11.prod.outlook.com
 (2603:10b6:208:309::23)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH7PR11MB5766:EE_
X-MS-Office365-Filtering-Correlation-Id: 567ee72c-0f51-47e8-17da-08dec5d4fbd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	bzDPyzhdY5QGELP8PgvVyVfyx3oh9/xQ8lVlOe/5fbTAjBmpJom6eCAUfREWqNi6N7/pyrO4lPwk2QDgzvV2/XB0Qh/fERzegoeAaBbmU++qFoup6P+CCQp2jGUkkILWSwaNxA94BUQv4kYfjYWVgn4bRr4yKu/M1d7GBKSfmBcffVPhYXKNL8aqfdeJFlxcf8fKvxhAOrazG8wmQTmYHYSTgOi2gNSrRWIRj4I0aiku6Mkvmks3KyqMSmR2S8DRoJTjBuFGddyLZyHnxUhyvacwiTH6La3ONvwg2AFM5Rk4YTWHQmE0vkpjIdLKOjBmP9Eqq+RDjnVUwgoag5HOEZgqf5GRD6GDmifL5o2EdZWH3UFVrbSp9zFVHHuxuok/ZHvhwgEO/WXrpmccYaYCGgVvSJA6OwqMZTbGur84/ZyGfAMrd4qUiaWAOkga+/xPK+4TDsXd3JV2j2NbsnLyMfi4YjwBkltcpqx/GGBGSDeyRrNFft6GOzGM3vQRR9NnACIwRTzlYzIcjPVc1Lt6/GfQsatQKOV2fTGTEvsaH7DJ2VKcGyx9s79BDs2mHecKzCxo6f8I+tHHPsOxyrrRO5TXGp8wPZV4gwD1PdHG1255pZTslV5f3AtJBP55ncXlCo36v+ctjezhDDhw8NCQUnU1qKnqNtoKW025/VzHuLXF4TuvSU3zl5eSQKBzC9CD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QjhXckR1VFp3N0Z3cWRuVHBnQ2JKN2JKY2doZUd6YW1CeGtjcUc0Wi84R3hn?=
 =?utf-8?B?Q09uTEJ1QkZRWkVFUWlwSFhZdTdBdUM3bXdNSkZOKzlKS2h2dUdOQit1TmFQ?=
 =?utf-8?B?emlWbmZVM0VJVWxGU1phR1hIUm5IaG90cjROTE8yRGZaWU50SkdDUTQrWTB5?=
 =?utf-8?B?UjVZQWxRK1RNeVlMQ1YxcmpmMHRYdlRwQkZaOVlCWm54SU4wNUp6VmlkWHkz?=
 =?utf-8?B?Q3c1VDl0cDdaVGJ6L2cxZis3SFhMNUtrWnVpVTB3YVQvSkpSWW9FU3Y4WGJl?=
 =?utf-8?B?b3pXR1J0bkZOZ3pyeHNES0J3R1NXbFQvYmhOSHdDWGVsd2xLNjhkQ28yTlh0?=
 =?utf-8?B?aklEK1RKLyt4ZjBoZGlHWHorZXlML25YVVZuem40UnNwSUF4czZaZ0VjMVJQ?=
 =?utf-8?B?MlptYmRrMmY1Q1lzSVZKakVPdmhsZVFQKy9IRll1WlRUeVZxaHhNQnR2VWxR?=
 =?utf-8?B?TnE4QmhIVEhIaDhFK1k5S0VOa3hhY0t1V2lBSXRBV21BdEpsUUhuQ3ZjL3Yz?=
 =?utf-8?B?UWIvUEh1czM1Q1crMktSTXZwd1BqNGk1WkYyajVuL0QzTkk4VEs2Q0FWR1JY?=
 =?utf-8?B?aWhoREJBS3YzSy9PL0t1QmV2STFwYTY2TVZNOGRuNEJia1pPQnlhYlB1bjl4?=
 =?utf-8?B?MmFCd0grNW9ZZ3RZY0xMNzF5Z0YrSzl1WkRkNHN1czY4eUZkdi9HR3dQTnZy?=
 =?utf-8?B?U3VIcXBPZDVNTCtUZG5aNWJOSkVSemp2d2hONnp1aThlbWQ0N2FSRGp5amhX?=
 =?utf-8?B?QVVUS3M5cnFMVVFaQWlWOHJIb2tNQVRONm5iMlJIdGNzRGJ4S3VrNFhiY3hQ?=
 =?utf-8?B?blY4K292YkNqUm9wRlNpUlpiSzRCcHlqT3FKanhFRWRCQmhSVHBLNytVMlo2?=
 =?utf-8?B?dWgvSkhNeWNOVlZBRlNjb2l2WkhXaFd2eWZiRXdxdEMxNkVpVFJoUHRpWVFr?=
 =?utf-8?B?SGQwMkVaNVpTeDVpaTlaekpmUEhqRjhZSnhmWFoyajhWZkthYnZCeUNabUds?=
 =?utf-8?B?bmo5bWlNOEF3Q01mSTRtOW0xeU8wM0QxSWxRczVyOUtvMTF2N0YzM0Vuc3g3?=
 =?utf-8?B?bXd2dkxtd3RoYW5aL0hMUUZLbldBRWY1ZWw4V3RsUFVDcmhFd0NJS2ZOZ0xP?=
 =?utf-8?B?dXJLQmRNRFduWjBRdmFHM04rN0p2NktqRi9pWkZqYTQzZlgvOFVCTExGU2px?=
 =?utf-8?B?U0ZOVTNYRFpVN295ZGNvdnZUVjNsMDliVURXMW4xZUQrSmk4RWtndDRmY2ZH?=
 =?utf-8?B?WWxQTWNxWHhJeDVOVTBQendjOWhONnpaUVNVcWJQMmd0L2g0cngxVkVxZE9q?=
 =?utf-8?B?U3YxNlBNQllUUUhMaUk3d3FVVm9WR1hSZ3lBUGUyV0l6WDIyWERMTmRoV0oz?=
 =?utf-8?B?MkY0b1FXc21Pcy9Jd1VEUTRjd3dBQnRIL3V5a2dRUkR6K0VrWnk1MEtLVDR6?=
 =?utf-8?B?Yy9QdDBkSUtQdUZ1c1pncm0zUzQvZnA0SWVrOWNTMk1CcmUzYUJCS1hBdkFs?=
 =?utf-8?B?V0NtRFVyc3pKcENJYWFvTytoY3hRSkdBS2VnOFI1UjRyM0p3UnNaUWJaREc3?=
 =?utf-8?B?V3E1aitoVWR5L0hSMUZzdyt4U0ZzNU4wTGJ6Y1NHSnRBZzloaTRGc1o5djN1?=
 =?utf-8?B?VDl6SU9wSGxQUjVCeVlxVzhqV3VEWHdTWGVkVktpQ2tKNVhieTljVlNGd1dy?=
 =?utf-8?B?aldlTE9XVGlZQStIWVNZSHNZY3FEaCtwMHA4RitlbjBIT3oxakxIRmZxVU1O?=
 =?utf-8?B?ZXd1UUlRaGhPdEdJZVhJTmRoQ0drSlNoczdOaUFOUDE0YjZwWk03OWdObjk3?=
 =?utf-8?B?eFZITUFCK0dBdDROMlRldTlEOG56eDd1NjllTXNzekRaL29mQndmNTJENE5u?=
 =?utf-8?B?dk4yUmxCQnczbTBPR1V6WkgxNk9uQWQvbWExcWhCRzdNVldORU42RHJOQ3ZK?=
 =?utf-8?B?QWx3V0N6UURCbEVqUDlNT01nVXlwekR3U2FjN1E0SWNjK3NqTUZzSko1bzVk?=
 =?utf-8?B?cDZOanZ6SHByYWljS1prWFdSSkNLMzR4U1crVkF4bVI2azhZdEplUDlsclJM?=
 =?utf-8?B?N0RrU28wUHRodXJWTEU2c2x3ZElLcjk5MjRFaHR6TkhVdTJ6K3JaZ2E0Wkx2?=
 =?utf-8?B?bW1oZ0NrWlZPWVMwRWhxbytCcWFQbFlZdGtaeUtRN05YbFpUcEtUMEsxSXdX?=
 =?utf-8?B?RklMQ0Z0a3VaQ214YkNlWTZkRUtJbjNtVkw4N3k5ZzFIM2RPdnlNUWhUSVoz?=
 =?utf-8?B?VWhBK0tXQkVJSXBNTDJCOU1vQzNwRTBiNTBMcHc2d1hrWXQ2ZTM2RXFRR1hQ?=
 =?utf-8?B?TDZNVVo4NlIzQTU3SFBjYWFFL21veGliVUx2TC95VWU3ZllwOXBLdz09?=
X-Exchange-RoutingPolicyChecked:
	ByWlJWaFuKt0kOXbjPkNIWtVx1A6B18YHJVnnsuKEf/szcCHushT18f8AAcSCsKLvLJXEvEF0pz5vCKAyNvhGBbtN9zPS+nFeKseJxvKydaHt5B6Nh+JNmeuvAiZKgDBqOR7oCCU/OkKWI2KmkE8cLx9n+2BfrTHOuyLXMCl48vT9oomAMDlv0WwgC9wpppdawImOl/x2lID5YNpQkVKA+rzM46KSoaWWXBOEo9vmGGCnfma9yR7geLVe9JiF6SO/uHCqvbA7+kC1itmjds1vOrl0DfDDtKEzrJsFfAR9wq1aDSYwkc8++EznFszpbxjNjYvkFu6gRrOFZBUOnYIRw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567ee72c-0f51-47e8-17da-08dec5d4fbd2
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5333.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 03:12:49.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hPtNZ1NQ8P3BVHuam10rZp/D+DpavpJMv6teIoljZha1s48NUvYxgo51wEyoXCNx1AoMlGFEdoSV3KfdQDAm/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5766
X-Proofpoint-ORIG-GUID: 7eqnrDD0b0K2U3uG_FoyVbFcTnyJunBj
X-Authority-Analysis: v=2.4 cv=VKjtWdPX c=1 sm=1 tr=0 ts=6a2784b5 cx=c_pps
 a=gE6CMw9pMCRGQsgsFAL45Q==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=HK-ge7EqtdluswH-FwHe:22
 a=t7CeM3EgAAAA:8 a=DK8KrHvn_W8knu7hfzYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAyNiBTYWx0ZWRfX5prdx3b4uXcR
 EFMiKIeaBBR7iHTeBpzDuDv9V40jq2vaKR8BIzoTwBwsTgbTmdy4Tdx5IohbuwwN/Dhs08bts3R
 aTyepSx2i2wUvRRAKIfdcMbkrU5Q79HaMBiZxb9jX/eCq8pfoP/uYC7Drj8kDyhZOY+YlsXtRtO
 jO0yZZDSPSCCHDHlFhrJX3nf1FCbsyIMov/oa7BDG9CNVwxRWWp/n8ow0J3UWZJrnioHVwGqQKu
 PVTF+77/golLkuE106t/re501mQA0xwaFqwVaF2+VWUzLpOEJ+QxHVfup9tdNmdFKvglnId2pkx
 ylljQW+DHMmKKf/vhlZI+Lt10QqWF+qT339G6kFi5ZIc+FZ1LlXFWsrNReiywMmQx1Vri0KqUgy
 vVl7Ogj5ioa2O6ZZm4yU+Rf9VDZM7PR02f8gNhgrDrr+fWjuofWyYJQiRBMmfwvF8Hef/zNGEf1
 7fernO8G7XGVeqRkSEg==
X-Proofpoint-GUID: 7eqnrDD0b0K2U3uG_FoyVbFcTnyJunBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606090026



On 6/9/26 09:15, Hillf Danton wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Mon, 8 Jun 2026 12:20:07 -0600 Andreas Dilger wrote:
>> On Jun 8, 2026, at 09:25, Yun Zhou <yun.zhou@windriver.com> wrote:
>>> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
>>> belong to the same superblock as the original file.  Currently, this
>>> validation is performed inside ext4_move_extents() by
>>> mext_check_validity(), but only after lock_two_nondirectories() has
>>> already acquired the inode locks.  When the donor fd refers to a file
>>> on a different filesystem (e.g., overlayfs), this late validation
>>> creates a circular lock dependency:
>>>
>>>   CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
>>>   ----                              ----
>>>   inode_lock(ovl_inode)
>>>                                     mnt_want_write_file(filp)
>>>                                       sb_start_write(ext4_sb)   [sb_writers]
>>>     backing_file_write_iter()
>>>       vfs_iter_write(real_file)
>>>         file_start_write(real_file)
>>>           sb_start_write(ext4_sb)   [blocked by freeze]
>>>                                     lock_two_nondirectories()
>>>                                       inode_lock(ovl_inode)     [blocked]
> Why does it exist if the locking order on CPU0 is incorrect?
The locking order on CPU0 (overlayfs write path: inode_lock → sb_writers)
is correct and inherent to stacked filesystems.The actual bug is that CPU1's
execution path should never exist — ext4 ioctl should not be locking an
overlayfs inode in the first place.This happens because the donor fd passed
from userspace is not validated before being used in 
lock_two_nondirectories().
