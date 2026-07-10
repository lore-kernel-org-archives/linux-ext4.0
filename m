Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABF123F40D
	for <linux-ext4@vger.kernel.org>; Fri, 10 Jul 2026 13:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783691183; cv=fail; b=rVU3DOJazWqU8xmatKp+trBF1/22Ag8lWyqXbYJRG9cqNyGPIQIMOU5PaM2Zia0lnPQQ2y3nOpikvVEHtRPx97JCEJAwoPzM31vDjZrVUGsAVZ5AKvwQLSW1hVLUPojFGuhLEW6ujYJx/WNDMZpgwAUhcctk2rpT/jutWSJGdVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783691183; c=relaxed/simple;
	bh=ILncTyQH1xwzgOqr3nriAGKVTOOtmORgeZTOiVJr+aU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z7f54vqtArOCFqaq9OF4VAad6wMSTDLZIybxKa79YbqOCvgpfE6YHvg4paRGFrdtNvcniaM61/uYYEUzuFdpD/y/jHxDwjzvnMg12AbtPl2kr+2R7XRu0Ysba6zkXeibXzI4/wB1/sJyXbNzafcWNmAMo3uoTxS+bzV18yeoQ7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=hlcnCfOs; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="hlcnCfOs"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66ADAICR724505;
	Fri, 10 Jul 2026 13:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=K2zXT+ApndSLDBFEenhm7ZyjwCIZB97Sw38bX0td7eg=; b=
	hlcnCfOsi1jbRw2cd8H0INFJfh/v3GNAdVlAU/Qx5C6IquBRjb59cA2RYHKUXtJ1
	ixP46RHkzLn74Tqqg6EgcgEcheMaQSUqxOV9xtrPbQzipJzpUXYvwbq/LnsMgilg
	eWOHhQno71U7BsUykzXFRknSVJRHewqXi535tUTXr5gwXU66dBp4eS5W4587Dxei
	kV6x961x7TezPVDxwKWRmvli8E3k5NFbe437y416rRY5DnAy85Pk9hgvYTEsaRYR
	rINmMIG1W6sC6bp3Ywx+TmkUnK2SHj6y1jF8d3EQ4U5YgX3G4+wxBp1tTqppfWrD
	zfOB0/m7MRgoo3U00Bv0Lw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010036.outbound.protection.outlook.com [52.101.201.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fa1aqappn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 10 Jul 2026 13:46:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NckrPBiF5eQnqMn2eX2Cw7+sjaNj7Mxtsvk8gv/zdL2bQkf3yRXFTlGl2qvxVuiYEqUIFnQL5gnjPpOfRpL800MRSaoIRjfVoXzR8ZJ638bU9shtwc85YlVCvInXfiTzoXICF2XUAzCTaGkiH8Uu+imSqFh3mqs41tqPf4DXy5ShL9DdFmsHZ198ib17nkLIX0hxF+Ayykcj0e1gKjE0l08103tc2qWPFkCOI/G8IkSIwGmCG2Cb1dNzZj0JVTQOiN+JS2jpsHorSRBpllLQeTFnbrOhk/DDjLaiJRsftI8pCJSEE0T5V95vQZzKc49r8ZoojVkYu9fNk8n60+yv1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2zXT+ApndSLDBFEenhm7ZyjwCIZB97Sw38bX0td7eg=;
 b=jS9rPW9h4h0/RYChoqrXeVJV3vTr8vQZRNb7vd3R8L39E+wOzMn6+xY5dX9YlMZg4sX3NQ/7FGa2OHfBSO0zBnVmNER8bWBIBaxMfnmDBwC0r+4h69sqkkp/NglJebmsZ6auikVyQAIlSeuiaIr7aTpZ4oQ18a9BPZ4xhbngk3eRtRYK1IvpQ3RMASj0NQJjGODp0SO2DKy6Ey2STk/4zuG7DJcsyB/HjOfyOqI2rT9GObqTtK1yeh046E3sWqPmlP7NvpQE8Xwx9+EVPFe4Y/R/dtEAkHSiPurqZz+poPeh3aCO9Ox3zg+e9+xplLsUUEduMKvzYykyV5EgbS1deg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by MN6PR11MB8146.namprd11.prod.outlook.com (2603:10b6:208:470::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Fri, 10 Jul
 2026 13:46:09 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.016; Fri, 10 Jul 2026
 13:46:09 +0000
Message-ID: <18064d94-1bbc-41f6-8693-2ff8a8615df6@windriver.com>
Date: Fri, 10 Jul 2026 21:46:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ext4: fix race in ext4_convert_inline_data() leading
 to BUG_ON in writepages
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
References: <20260703132517.3527261-1-yun.zhou@windriver.com>
 <20260703134724.828111F000E9@smtp.kernel.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260703134724.828111F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SE2P216CA0003.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::6) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|MN6PR11MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: d12ebd29-7700-41a7-60d2-08dede8998e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|4143699003|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TOknXud0S6T8OSwhYiT2ypmaNnxvgXijK0zGDxX2cUal9B9XWIj8fFeXDGW+QYmGwR8JTlih15fGSv2t/1UnSphQd99zzJBtrFEje/X5JzQegQUYubryIao4NntZfWygZTo/didFYxWzS2OxqiHRM+P2itUsqw1GK349fnRkypQF9M4a0HviCptZVjsxoll9epr0Vcb/LzGhZxXwps2tupwDf2DOiRkVPWREHnYYUjUYQBy2R/bFsQCpm2wLkH3c63ijrsQ78fdXrDJaHAtz8IUjcav8KXCHDMsDNRnQBQ+lZSuh8UU2WzbTvmKlM426to4AxaWN70z2VWgZcfHoKaoViufoDv6JUMN9kazL7gab8LlfqX5QxmGHTrpWzjnrdMmeRE+IXu83dNoGYQIxz9kNJGrR2o/KzphNOgSagmOr16x6klk9WoyPDY9rjZ2Mu0KxM1KghxRMStgohKgznGOSxHrgJ1vCRccEThtv1IC6hdEGFGAde5XEPd+RJJVxyRI2tbcnDE9UkB8CLU6wcfya3/kyPz73qRSvyMG2+X7ADc2dwyej/ErD4SdDjDz+52FgOlRtIuzVlUkRz+WgBE0bPLl7nckIR4f5aeJL+sY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(4143699003)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1lwTDZ0enplTGhTVHZMK3dWQVgweWpYaThaNWh5VnBRUTBENkw0SzBaYy9K?=
 =?utf-8?B?elQ4dEl1QnhDNjUrMjRrQTRPUXVqWHQ3V2NWeWJSZ0Rvdnk1Y1lzNzY4N3Rj?=
 =?utf-8?B?dm4rNnRXVWVFZFJRS1Q1SFVjMUYwZlRKTWgyQW1zVHNnNUpSR0ZvaTdkZW54?=
 =?utf-8?B?dVVITnk1OVdXd0VOcUdUbm0rbjBrSXIrRUt5SzBaQ2N1bkpPblJmbTlBMWxm?=
 =?utf-8?B?MHhmbk5RS1dHaUEzaTg3bmdTRWw2NWF1cStMSGRndWR2S1NSdktJNXdSMXpS?=
 =?utf-8?B?YkhiU3dzTlAvMWNxZmpya0tjME8wdW9rNGVkNGtTa2tuWVZRTzVhUkEycVp4?=
 =?utf-8?B?c0Y1bkNXSzlwM3B3NElZY04yU0lMWm04akNBdEVaR2t5L0FPclIyaUV2cUlG?=
 =?utf-8?B?N3hRMUgrMHNIQjgwUysvYW9zcUh4TEE5VVpiZWZnYUlpZFVVejVXN1hJeUp5?=
 =?utf-8?B?ZDJQd2h5Q2l4VXhnNEpDL3luSWg2SEZlbm1oV3I3eE9kYXlJVmNMRHMwVXpJ?=
 =?utf-8?B?TjdERG9CNXh3MGNaK01oVXZlekJ5Z1M3T2RXK1k3K0h1SUNLTnRXY3gyM3d3?=
 =?utf-8?B?RUEyNGZWdTZiRmYyQkJnUWJoN0NEMkJOWVpqeExRNlpCOCtvQW9EeEpmS2ts?=
 =?utf-8?B?M3NyMVl0Z2t3ZWk4U3l5QzZPNE1xbEhvUGF2NmsvaVAvMkxCSWY3a05uY2hR?=
 =?utf-8?B?ckgyb29id1NqZHYxNTY4Wk0wRmp1Z3psQm1LUW5iVGYwYU1MSmdNbWNWTDly?=
 =?utf-8?B?c1ZiOVdUMjRjMTNWcnZSV0xHNTJmN3VoRlh0UHVJeUdpSFlaZFI3WGRwK2Y4?=
 =?utf-8?B?RmZ6TXJiczJxMU1ubFZGWXdCeUVwb09EZi9YNUsyU2ZzUE4wOSt6YkwrS0s4?=
 =?utf-8?B?T1RLdkxMakNaUVk3dmN3eXpUTUNqRXFBd3o5WEV0OEZuU25KZVRsckptNjZX?=
 =?utf-8?B?VVEzdkZPQUgvcHQxWVltRnNMNE8vL0tqcWt3bk5FN2Y3ak1zdnBjM2FwL2dv?=
 =?utf-8?B?aU1BRWxQVFJZQ2xlcWNObHppQlFwT0ZPN0RSWGdCdXlYN3FLODAyOEU4MWRE?=
 =?utf-8?B?V1RYeFdSd2Q2WWt6ckJFa1BLUEpnYTRTZjR0OW5kZjY5WE9ZNGc4Y09scC9z?=
 =?utf-8?B?ZGdIMXBBRUlvam40VmZ6L1FvRURUd1JmWjJYYzZLcU5NMU1acStobW5IcTBN?=
 =?utf-8?B?RG5wUHZVczNITVpxQ1VWZU9SL1dFVWlGZFljcE9ROXZKZlVTcUc3eHpPSkRR?=
 =?utf-8?B?UVhQVWh4TnZ3dXlseFB3a3Y4MVdRL3dOVDQ1RDlKR1ovUENtOUVlSTg2cDhn?=
 =?utf-8?B?ZjlIR0ZabkEwM3JnLzVSTkpYejU3aTBiMFo5RkJiblFOWkJlQUtmYVBNNGMw?=
 =?utf-8?B?QXJHQTVvWUhpRGZjV1hMYW1JZ09EM1N1ZHlnTERoQ1NUQ2JWU3ozeDExWGVq?=
 =?utf-8?B?bWpFS2FUT3R3a1JaNjNpU1NCZlc2UWltWld0WUVCOXVubkNpNVg4TXFZOG8y?=
 =?utf-8?B?QzZ3bzAxRE0zZXMwTEtDWnJDOURwdnZ5dDN3U29ucWxseklTMVp4RXprWlMr?=
 =?utf-8?B?dWpUMFdrYkxlcllVKzZSYnpUR2hrNDlwcVZNL281OGtEYVBSTmhRRFdKQmlL?=
 =?utf-8?B?bG54eEdDd0QvN0x0dUxpYVFReG1KOFlJT3h2SnE4YmJIeGg0SlpwVWcwSjM3?=
 =?utf-8?B?cUIrTDJEZS9FcjE3dW1RVlZMWmlXcm9CVHRZaHBhTmxVZkNMTVpycnVIYURU?=
 =?utf-8?B?ckowNllkazhsaVhEU1RNK1pyb09CbTBNaEZWRHh5M0hIQjF4ajRkTVYrMEww?=
 =?utf-8?B?dHV4WEpVb29sL29aWmxISTVFbjdNV2ZQY0h3elUxeXc0dnV3UnhyVGJXWHJm?=
 =?utf-8?B?aVBjRnVqdDZ3YWFsbHlNQUZ6Mk5MVkwyZW5DcDAzSXVlQTU1aVU4QXozekx4?=
 =?utf-8?B?UThpNjdFQmMwVlE5MTZTSGhZbUFGYlFuOHJhdmdTNUt5ekMzUjc5dFNPTk92?=
 =?utf-8?B?RDN5VVNqZmdtRzJyWXdvZTA2OW1QejhzNlArSFozdHFSSjdJZ3QybW5CVkxp?=
 =?utf-8?B?dnlITFNBZ1dCSkdYdEphVDRjNEdOeGJNUjJwM1REcWlwWisrZEU3SEd0QWV6?=
 =?utf-8?B?K29aMllySURHb1UxbkpVZ1VjSW4xM29sQ3dxdVlZdGwvaS85cS8ySE9BeEFG?=
 =?utf-8?B?TTZZUkUxUTh0eXZRb1oyM3FSTWtzMHppTGhqVzBHZjE3RHo2UlNVbGdiZ3Nm?=
 =?utf-8?B?VHk3bm8yVWRNbXVZMEZRNzNWUDFSMGZsTDFLUm05Z0k1d2E0NVBENXJqVzQv?=
 =?utf-8?B?dG8zQnViVTJPWmIxV1FmS1hNOHVlT2hOU1RZVUFUZTdEVWwzaGlFdz09?=
X-Exchange-RoutingPolicyChecked:
	fjNFayZNPm4RmajAu46WVLBpP+PByHkkRhAjDlYfm9Yf0uorTMKiNeUi2MGc+0ZlPN3E3YeP3KX5FhieuqXFxPyPBSn15YncT13uHzghtJ2ilxiE5T42zD8OXc3SAfBVSrCa5g00IGHxe6EGOhnelidewJYzQgqvm+RPIGB/GpPggcGxQBw61ahJPoPna5gU7yGnHZrq0+kiYOmeQAiQvbg6KszpHmL77x8UfAC+6AtUWD3NlQCiQlsfF/EBzMOvhaWc/fS4OksEZ5AzmOsTtdS4BH5R24/Cgwldaj8V4vwyHgn9Q9G5vfVDXtklxrxur7WUhrtSz8+GbYuoncGOSg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d12ebd29-7700-41a7-60d2-08dede8998e9
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2026 13:46:09.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ey1QaembqozD0m+EzTJ8/W7St0chctvxKHboeYeCHy5QkdVveFDeJRy12Ovhddut40agHfylIU/0oC+FCiNY4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8146
X-Proofpoint-ORIG-GUID: 6cSxH_QZBZp50vfv9MBh6MlbefE05vnk
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEwMDEzNyBTYWx0ZWRfX1toxc//CEqfS
 SCYcX7ka94XAMRrRHiri1tGDPJotm10pDZ3J0ZpwtpBLcWDCL7qyOtBWHEKjw6BitK6pjzj6Efy
 pF35W0UaueDurdGdgwPqEYJT49zQZBmV18QY9I1smwRfplkfrrS9
X-Authority-Analysis: v=2.4 cv=XIkAjwhE c=1 sm=1 tr=0 ts=6a50f7a5 cx=c_pps
 a=0/XwxnXJ+7qPZvmcTWkk5A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=1zS8eJUWfWv3P7dpm1EA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: 6cSxH_QZBZp50vfv9MBh6MlbefE05vnk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEwMDEzNyBTYWx0ZWRfX+s1IuzZVdWFX
 5g/Em6xTzuHIalNN2rt9i6b0KDB7iZ0OItOwq9kuhjs2Yqv4NZ2rX+EgOPMnMbdxBqQu7VTBSBR
 GxMd4RUAfzpeJ4KAAfEBRXPGPSg4bjakBwX+xK91HsmqBqMAgyp4roEsxTqYZGkeSJ/zjeHW2ej
 bXLY7i3kO3p78wSKbCAhIyQ9O2496XwfXJqIns4RZ/mIs+gk4+fdaFVd+vMXxtWiNVeeckuvmnk
 2dK3NuOOF/TEj0aQNpe8RSe1RIMZ4mLfnbpt0yEKLRjRrXaTwm3K9Rj2OK57OrQdXyWZDUYR9Ol
 Ii8wKUOjpE8c+COJrmvIrET+F1gUnoRHDcmYti3bhEvlMwjnWnUFdKg98MChy4KlsXEaznaCVF7
 cgCl6lY1l6tst1XQxBw093Tdxi91bZqUaod/dj2lotzh922vIfQVfM5uA1zsNJbVK83FtP0T8wK
 QwIg+4vp0MnuWxADKAA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-10_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607100137

Hi Jan,

On 7/3/2026 9:47 PM, sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The newly introduced EXT4_STATE_INLINE_CONVERTED flag is never initialized for files that naturally have no inline data, forcing every regular file to incur an empty journal transaction on its first memory-mapped write.
> - [High] ext4_convert_inline_data() returns success (0) before inline data is physically destroyed during delayed allocation conversion, breaking callers that require block-mapped inodes.
> --
> 
> commit 39b605d5de2f62ec33531991bcda64fc6c6fb005
> Author: Yun Zhou <yun.zhou@windriver.com>
> 
> ext4: fix race in ext4_convert_inline_data() leading to BUG_ON in writepages
> 
> This patch introduces the EXT4_STATE_INLINE_CONVERTED state bit to prevent
> concurrent convert_inline_data_nolock() calls from restoring inline data
> while dirty pages exist. It adds a fast path to ext4_convert_inline_data()
> using this new bit.
> 
> Closes: https://syzkaller.appspot.com/bug?extid=d1da16f03614058fdc48
> 
>> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
>> index 0eff4a0c6a6c3..f599b84c41453 100644
>> --- a/fs/ext4/inline.c
>> +++ b/fs/ext4/inline.c
> 
> [ ... ]
> 
>> @@ -1960,21 +1969,27 @@ int ext4_convert_inline_data(struct inode *inode)
>>        handle_t *handle;
>>        struct ext4_iloc iloc;
>>
>> -     if (!ext4_has_inline_data(inode)) {
>> -             ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
>> +     if (!ext4_has_feature_inline_data(inode->i_sb))
>>                return 0;
> 
> [Severity: High]
> Are we missing an initialization of EXT4_STATE_INLINE_CONVERTED for normal
> files?
> 
> When an inode without inline data is read from disk via __ext4_iget(), the
> in-memory state bit remains uninitialized (0). Because this patch removes the
> !ext4_has_inline_data(inode) fast path check, a normal file's first
> memory-mapped write that triggers a page fault to ext4_page_mkwrite() will
> call ext4_convert_inline_data() and fall through to the slow path.
> 
> Does this mean every regular file will now unnecessarily start an empty
> journal transaction, take the xattr_sem write lock, and check
> ext4_has_inline_data() before returning?
> 

Sorry to bother you. The performance regression reported by the AI bot 
does exist, but it only occurs in filesystems with the inline_data 
feature enabled. Specifically, during the first ext4_page_mkwrite on an 
inode that has never had inline data, it triggers an extra 
ext4_journal_start() and an additional down_write(xattr_sem).

I'm not sure if this regression is acceptable when weighed against the 
BUG_ON triggered by two race conditions. Alternatively, this problem 
would naturally disappear once the inline_data feature is completely 
removed, but that seems to be a long way off. So I'd love to hear your 
thoughts on this.

BR,
Yun
