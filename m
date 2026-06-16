Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A011832B9B6;
	Tue, 16 Jun 2026 07:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596314; cv=fail; b=Ko2bzWaIM23imCrnzpk39ZUDfAWEABA1GWWqDKaUDdP5hhpXl/sYgjtnMhwE4MTmDmufYGWh78PfmtNVhJ7H42WRkiOVV1C2R0TH1GuMptP4wUicz6CTg2z+mhdJsa5a2ysDqUsMuKnPUiip9uFlDjYIdOXn0I0mVxbtdmOG7Vw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596314; c=relaxed/simple;
	bh=8S5+9PPlZIZUdQVMmo994JsE8CtNGiGASr67WNEvFs0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sVP1zgUZHfxe7phTZ6Pu7viOnx5jsry8/HNbfEbKEfRac4olVt46t43VPbndGv2bV3w6Lgqo8mWpQxcOb/kFCkekODALjYxK2iqMGUvqelCyQFkQBJzLV0fhR5m+mkTQv7MB6No8hT2tLF54ALu8mkvk6JybXw6XF0k0gJNvCgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=d/IUB5Uw; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="d/IUB5Uw"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G65lri3061075;
	Tue, 16 Jun 2026 00:51:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=Sso4KZhqwI+2W1SWPB34B/zElr5mphGMl1urzR/TD3c=; b=
	d/IUB5UwprnPk3qi2hePhQYbZRuNX9i0M8Iy4gJ8s4iIDzWPp5KfQAcPBgbKK30b
	WYLBS6yRpXW1ERkZf2vRuQZjRLlV8whR2aqr0aKv4J+emgKTB9pz174MQOCgz7iy
	IF1aTHHpXm7dN3UH+ZA67maW7IgxuUOA0IsT5BOY7YC16a+47hQWD6N5vuKaRMB7
	h1ExnnSLEYhU2YGPtXDVONwDZS7qFdqdgKxwChDrZtmutBWzF4KS/WDDKe+TFveK
	RQ+jknoetqWEF59sNu5AMHdqbGWFgqsQj91shWpdTbHOrd3NJpMFDugFMQC7zv4v
	JdDn+zZrfwr5IkqsIr16bg==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4es6qduxcf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 00:51:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kQWYQ6H10GU9hszDbuv9NbpfPsAOJ+F02wCFWeKSIn5pdgWNmTmwak6mpz3fg4B4GiWAfOcjL7G6cY946LNjVkZv1r48LxGloRUaglNHMPkcFSgnFZsnJ3BiFdKXTxnDW5Gmo3Jl2fPJpj7oD2fsSk0+TpbMJq/kdYYXWH5hKoTFSsnxfdeQZFnpfa9nLco23JfpoS1WsfGyJjSpV1C6J//JIzYueKaHzk33T9fAyxlmgzws6Wrha9dNB4F19k5AdFnxnTXxzootYwOj7DE51qcoMryglfs6CznH2u8m0LdvQgT6JOsn91lZ9aWlL1n8r1m2InHFfZXlBdbsfu16zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sso4KZhqwI+2W1SWPB34B/zElr5mphGMl1urzR/TD3c=;
 b=IdkDRSXAJiVZC0L+BXGhPhM5hioQXDgSgmR6wvk67jvuLjPefe8YSeobLs5m1x7hG88tjxq9vPFLiZ5QBwIIM7NIzZCvAhnglpNEtpBgeMXDlWcQv2KXMrd6u+D8fhOSC4tFy77Y2hcqH1Fw4g7nSWo3nSlQ2kyLFxCha3l/O4+Rg5tqQKsEdTDk7Od3cS2S6JIrgUg+4DfTgo8GodyPKxgrzXSPrP6xOD6z5PojG+gGHzb7nhmrz6sMKjqqCccn49G5jKk8+JR+jw+TYyrPPj1mGwPnMNd8MZy0IBRv/Zsf+U6i+huXDLenFK0/GLOxoxbmi4j/H8LOy/8vemX7Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MN7PR11MB215295.namprd11.prod.outlook.com (2603:10b6:208:5ee::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 07:51:21 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 07:51:21 +0000
Message-ID: <00673f65-cfd4-4042-93cf-cb04ad1d92fb@windriver.com>
Date: Tue, 16 Jun 2026 15:51:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ebiggers@google.com
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0066.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::10) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MN7PR11MB215295:EE_
X-MS-Office365-Filtering-Correlation-Id: 22882b2b-e427-4bf3-6046-08decb7c0e59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	euUHlZROcN+3iaPLdQ5eO7gv+IvuCyXxBTfRGHojMH5OMN20Na2bx0+6/u+7mvXNW9nmeCxrboKn2rX6A2b8TCHj/z6ZsjaUi+kOSdyGvC7XFpZy5In9ebbzGgeeO9AIwyuQAwRf50vG+JBsa1cDUu6eh1dQ9LT6YjW1ebj2LdusILd9Xk2Sn13N0Q6GE6yryudXYqwdOI7wVyOcexGL5yECqxbQ/nI3cydG6+2U0BtzaF/ue6tT8v4Kmqb1eduTvKWzXNI43gaLmE8AMRndbvLOabP8Hf20Xv8aH7jWfy2GQ1O9bapN4QDNxpajfOdw+gltpPATYJ2X7Nmq5o5lyy9DxGqodVMEz8LtNUCmmusARzqQY4ftRXpCgsv56xbJIWvk67CrWLSyXibsqu1MnfAJayWqF96gBfMzc/C1JSludndX7tgNITHi7WNsZuk524i9G2gclhgNeVE0j6o8Y4awBSqcLH1zia+PsJHJ3y84R4vysK7EPR7OZOWyX7tQauJUjAL5QK98yeWVLRDLWQIAH0ORFr0b7H/Zzu2kZW2OJY/qMoAndLRrw/wtIyKCMku5xk0xJxEJSAGxFCjEA7QPGmX4X6bDZ3DE8NLSRLY59/zwwN/wY79rjXq3/DHDLFIuqDqxOUGAc3oJYxviRQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFBYWE8wK2NEd0pQMGNFSFBhcWljaUhTMEFTK2h3OTlYemVsWWhjVTZwZ2l1?=
 =?utf-8?B?MXRGNlMrMGY1WnBmT2R5YmkrKytDeVhnZTNoZXRid1VSQUdSNnZnanFSZVlO?=
 =?utf-8?B?S2YyYTJROVFNUWt3T25HNmZSTXcwcC9PVjFUU2xkM3hucXVUTmltUWVNOGo4?=
 =?utf-8?B?bE9rRXJHdmVZTy9oTTFXMTNuMTF5OVphbmtUMUMvWWRUMFBrRWZCVHhTb0or?=
 =?utf-8?B?TnVsSjlIZGdTanhJOGxoN0FEeGZRZWpLZEwzMDB6d2VVNGM4V21TUGxvVUdD?=
 =?utf-8?B?dnZRUmNhNTVrVmRPUjhUcloxSG02NTRWaUxQTTFKaXlmK29nRjBjMmNkS2VW?=
 =?utf-8?B?MVg3Yzg3dTVTTWZFUElxMnQ1d21BSkhmQ3Bza1VyektQQzlwWWdORkQ1blJY?=
 =?utf-8?B?dnJhNW83K3U2dFU5cnFCSVNNQzR3cmJjTERzVFRMM0dyWlNETlJ4RUtqTHZ6?=
 =?utf-8?B?aHdQV0svSU5OTTBnMURFVWhWaUN4WC9Ub2RxUTc4OStjdnZ2VTVkUlJHSUYr?=
 =?utf-8?B?L0ViZ04zNTBMc29BZGdPRUlkbFFRVk1KYU5jQzhtenlBbnRuamRVYy9GV05n?=
 =?utf-8?B?SnRnTTJIL2VmUEQ2NHA0R29FWkpVbmh2ZWVycjZTeG82TnRudXhwVzZYTGl3?=
 =?utf-8?B?NEdPc3B6ajNZcFBRR0VpNFRSckRLU0Z0M3VqbVVkczNBUy9zQ0t0SDBXemFO?=
 =?utf-8?B?VCtwZ3VQN1ozcTJpcm1FVkxPZ0o5VHFlNVVFWDR1dFVTNWpUanN1M0o5dzVW?=
 =?utf-8?B?a0Z2TklXVUx2bE5PY0F0ampZN1FycjNCNWdBVE1WbG5CZUI4cWtQTnFqTkh5?=
 =?utf-8?B?VlZ5Y0cwUmNRTEh6MFlpa3J1eDZQUi9DOHNNdEZtRzNiTFJ2WHFOSnZYa0t6?=
 =?utf-8?B?ZHV2Z2YycG5ka1MrTWxDRzBQeVhkUWcyMEVscFV0VFlIMHJrb1V4c2VEc2Vr?=
 =?utf-8?B?eUFlTVVJNk1nQWs2UkxUcFF3N2x5UEZqRi80VXlZZjkwSFdCYjlOR1UwUDFz?=
 =?utf-8?B?OEZ6NWNtei9WUDlxc3FUZDNndTVKSEdoaUtWb1FURzV2SndvcG1zdSt6REx0?=
 =?utf-8?B?YkRjWXR4VG9icjkxNmNuY0tPODZ1VEF4T1B4bStlVjloVVVuQmJyTTFuellK?=
 =?utf-8?B?YzIzTVhpTVlFRTM4Nm9OejhBTWlpRmV0WUd4RWJ5WGZjdDViZXNScDBjam1y?=
 =?utf-8?B?ZXRNSjEzMCtUR0VFNzlwaVRWU3NURmJRSDBnN2JQaFZ5OTVWQjBrQTJRa2tq?=
 =?utf-8?B?TWNVM0FhekliRlk1YzViL1pHMVhXbENEU1UwOVBHVDVvdlZFRXZCWHNKb3pF?=
 =?utf-8?B?cFgrRkhKSFZjTkdxb05IVkpPcytrc0xOWnNkbmJzU29sN280UzJINE1mMjNO?=
 =?utf-8?B?N0FVQkI5VUlISW9oa2p0ZjlTVmpwNUd3SHRhYnFNVUtoSDZScjBZNHVsYUkx?=
 =?utf-8?B?aHVpZ0JzdElMQ080K0VVY0grQURLMEdVRUpsajg0NHh3L1NKMDRSWWMrMnlQ?=
 =?utf-8?B?UlNFRXZydmxWajIrYXdZbVNGNFhzMXVQSlNQS3ZQOUM0Z1RoNnVrNVdicTF0?=
 =?utf-8?B?b24wL0ltU25QUktld29hWXlmeCs2ZnNOS1BtT0xrU2wwOXJyTGhwakt3UThh?=
 =?utf-8?B?ZC94b2dwNk5GSUZvZHJYTFgwa09kdXNWVUFpOUdrVVV1N3gvajIyYWZWSDND?=
 =?utf-8?B?b0ZPdTNBaE1OSTB0N2JNWVZnTXN3UDlraHc5bFoydURiMllyaW5WdUY2c0My?=
 =?utf-8?B?Wm1hNGt5Q1B0eDVvN0tlL3JDZE10a3BDdEQxT3dsSDZ5eUo1Mk9hTWpHSXpo?=
 =?utf-8?B?bHBNZ2ZzVkRyWXI3UXRtZThobkNEb1R5N21NMEF1VmRPR0VNL0tXd2c2VjVK?=
 =?utf-8?B?R1NhQnc0TTNVUkxGZVFFVDFOSm0wNkRSYUVsUU9xZzJIS0NEQVhYN1lEejlF?=
 =?utf-8?B?dlk5YWY1NnBFZVRNeFVxTEM1Z2JTcFRLRnhQQTMyOG5VRWxjZjk1b0tUb0Ni?=
 =?utf-8?B?cTd3eEVBeHU0MEd3cVhJR1VpTTcxVzh6Q0tqU0IwLzU5QzNjVFFxMzF3ODBi?=
 =?utf-8?B?UEQ2NXg5elF4OHp2Rnp5TkNrZ2ZGanppcllqTmE1cVpiU2d0ejZSRXkyRHJY?=
 =?utf-8?B?aFl0ZzdnTkQ3Qm9qZkNGZTh3cDMwM3oxT0pET0Nzc3oxUlVTOGFYMUdiTE53?=
 =?utf-8?B?S09xU2h3VGtObkwwcnNuOTlHVlJpMWIwWDNaZW9leUpxOFBZeVhEb0N3VzQy?=
 =?utf-8?B?Z2xDUldwNXNnelViSGhrN1kycVdSQ2hBY0JKYnJRN2lVUHMzaExINDB1ZE1R?=
 =?utf-8?B?QmJLSWlkM2JubXlWZytsN2ZTbHpHVWZQSU8xcVZQa0NDV2Z5RG1Ddz09?=
X-Exchange-RoutingPolicyChecked:
	Pa8sEd04iBOg4UCuv7p4QUPvLMTl5qLVqmy0YTVcUETyEGpPhCgkDyyEfi8HZ51uiuDp4mFEqZ6wy7fDRb8DrSZc3Ard2TsOhsAYloC72wdS8Q1KKCvppRg18CaspcAUCWmBhtVH0VBjKqt5p1SpBF4E+4qZoPseJTnmdYMLxIMou5jhKQrMNfZkMw+zVdNDYDtlSsT2Low9YMoYQ2blxdALNEyU8YSYKbXdoPfdf1p278AN9Ny883fXXnTOJHP8mZ3ADwy3ZjuOf95PMsoThrE/KqKcifUCuEbctKbwqIXk5XKZai2uSJc/XdzvcEU3T83MrVMRuYZoJsM0sN1UVw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22882b2b-e427-4bf3-6046-08decb7c0e59
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 07:51:21.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRZMjFeX2cg9T1M6u2DAbcQ3ZnjtZZtURD2kSPtAJNPMaZthZnyjcgpUaIqd3szbHDRR4r/f5pPBQp2yE3veMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB215295
X-Authority-Analysis: v=2.4 cv=DLq/JSNb c=1 sm=1 tr=0 ts=6a31007c cx=c_pps
 a=KjzTqp3n3Gc09/MFY+gPWg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=iKiJcTA2PjBS6x5JeXcw:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=i6clp-5eYCLNC4ZwdUYA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: ZAGOHWh4GK1d24DXkW-sxZLABhPoz95P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA3NyBTYWx0ZWRfX8X8RwU/22OJb
 2Di5evl2X5vS47YeIDDb0RWIJrgDwXJNrKh2vBbOEu/ETIPD0vRgvQUSYTohN0eSvBMjGzOfcz4
 vWFrjAKkv0ASLf8qaVtNZA2RuG8KxGeJ18F/2O4yCSf8FiTqQkK5fd4bR3WHLKTE0IVjFrg9Tdn
 zMIV+GyncA+H8mICCnr8JpaG2C2YpeHQiDZQFdNVZtqTxujkGn0DdIWmy+qGlqfJ5m70dkpK+/t
 jn0hSsGvdeUP0TGNVih5Aj47VWjhLrxFHvm/IyYNmS8iHi+ht6IbZTvbFkK1bE6DYXic69R9Mxj
 DYZf0DYwRMCg07BWnVdk9z1EqA7tgzq7ftLf2ZDn9rxZ5a7jjLbyvNUgKPGiF6teHVca3aGX/3c
 9etHv4DYRmAaN3uANuS2SmicSBE/uv73ykGjwwdpHbZc3BohkRU+CMvv42v69ivXRi4KdkdqkI7
 OYXGNMn1RmD9BeCLrsg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA3NyBTYWx0ZWRfX67rkb0DkqGMz
 g1Ih+BA/jEvyyGW0smStwW+XcRQJ/Bgz/gBc00heiM2pQG5z3+uxBHO2h6Thk7OEcdv8aMfGrr3
 OFC17snRjguM0bLEKHW+EQZVRa6fjoj88ATxl4Nt+/LdQ51wqetV
X-Proofpoint-ORIG-GUID: ZAGOHWh4GK1d24DXkW-sxZLABhPoz95P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_02,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160077

> Move iput(tmp_inode) after ext4_writepages_up_write() to avoid a
> circular lock dependency between s_writepages_rwsem and sb_internal
> (freeze protection).
>
> The deadlock scenario:
>
>    CPU0 (EXT4_IOC_MIGRATE)        CPU1 (orphan cleanup during mount)
>    ----                           ----
>    ext4_ext_migrate()
>      ext4_writepages_down_write()
>        s_writepages_rwsem (write)
>                                   ext4_evict_inode()
>                                     sb_start_intwrite()   [sb_internal]
>                                     ...
>                                       ext4_writepages()
>                                         s_writepages_rwsem (read) [BLOCKED]
>      iput(tmp_inode)
>        ext4_evict_inode()
>          sb_start_intwrite()         [BLOCKED]
>
> The tmp_inode is a temporary inode with nlink=0 created solely for
> building the extent tree.  Its eviction does not require
> s_writepages_rwsem protection, so deferring iput() until after
> releasing the rwsem is safe.
>
> Reported-by: syzbot+212e8f62790f8e0bc63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=212e8f62790f8e0bc63b
> Fixes: cb85f4d23f79 ("ext4: fix race between writepages and enabling EXT4_EXTENTS_FL")
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
> v3: fixes Reported-by tag and Closes tag.
>
> v2: remove redundant null pointer check for iput(tmp_inode).
>
>   fs/ext4/migrate.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
Hi Honza,

Thank you very much for taking the time to review these patches and 
providing your valuable suggestions. I am eager to solve these 
long-standing deadlock issues on Syzkaller, but I do not have much 
community experience. I'd like to know, regarding this patch, should I 
launch a new RR thread or continue waiting? BR, Yun
