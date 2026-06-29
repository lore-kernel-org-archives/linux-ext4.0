Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A81A3172;
	Mon, 29 Jun 2026 03:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782703091; cv=fail; b=vBBgTLXwMCQ1O9wfikzZN5Hr5Qd+YlrS2Brgd8fMWLJuMRwRCsHeVluWPzEF1exSTiWD1FcSF5vkd6yWfGX15qAWHMehcR6/Js48IceiO3/GH0epApiBteJ4+OKgtOtKXla0mvNWgwt3LiCBZ0v/+hinSbgIUG5JsWuAnSI3+XU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782703091; c=relaxed/simple;
	bh=NT4yRsGc67O0nHMuYxkzdELSTCr3+4GBQ7KtQsqbeIM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ooPjnaolEtMd8zfgFKkUwCL9XI5MgrgWwp7HzOhdiU5FlWFDYt8Njuuw+3tNNwZ/6z3x5Yk+xLq4JyZf3BzcRr+Y0lNJkU4BackvUooDDHc/TD3chhmdykCGBJpli4rYmcJTE+OtvdAG7c02gppc4a1pFRgRQl++2E4BZ7an9PM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=d9viA7DT; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="d9viA7DT"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T3BkDI1730419;
	Mon, 29 Jun 2026 03:17:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=YOZd4NSFzXeAoFOQ0wXt2tAN1MIWHr4/WIg1YplLB9Y=; b=
	d9viA7DT0nMksLJIJAOCe3Q9VWWAQjxb6oYNioYJWIMfDVo5Jb4ylu70WAUYiDp+
	v6yPa0GUwkjb26GlmRHe80u/hXVZhypD5rx5EKGwq2QDZU0xkDFsztsURNtdIMIq
	JJTvDFxtP4RD8KzHcGyWvqssrcq5OIbQ6H5iU6G7pCR5/fvdiH2eYl0dL0Yt6f8Q
	J1fqpCLdhLgAgBkJtToJQUTYwAGjo18KEzHFIBPK0eljNQpZP6w5yT+43m/QHZFD
	5mV9IWixkx+l8Oj3aQk0NEw508TelKuMhlEL2EIfBgUBn3YozjOSmdqYs9hlPCuN
	b4+eGto2+DbIF8vvpGGWNA==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5hmf7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Jun 2026 03:17:36 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=istyOm7zYjgKNC4Fef8e4OjmjpWCPF/utD/6z5V4PkzdVaiYyfqhwaLIWF4LSc7VqJymn89T5x5D7UAYEYNSVvQnbv5pn+VuoesjLIsT3bgF/+p0f7W1frVGosj21E1V2g3GaCG/QPpLZ47eUDhPZ4w+2cdpTc4jfVGDArd6t7e0qbvPuG5KGbtGENbNsOIc3b2iG0ALvRgSdWzlrQu5xwX7E4gH2EGz2nwsYk9k4wULhFCb7N8mNrchvuFlc0p8+J2Nk7uMT6y9X62wGcDtMH1whY+ng6z/TK5zjEJz+7WEmdsNG5mUBEpbrQOXbvEXEAJHkUGz7ERiZ5ZfoipWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOZd4NSFzXeAoFOQ0wXt2tAN1MIWHr4/WIg1YplLB9Y=;
 b=s3LON3F5Zlj1E2uKMkndR4jjESkML1j+HnSjg44mS7xaWPtaZ+aQK4FNzPwxMn5DgZf6eEjQzVkN19N5ZR4LNV4UpdpUaDqdKN+/NvaEN4XrYYBKXJ+ZacFnDPlAiJ2k/PTjP+76dF1LjlDO2VgGKoT2Q31Kk94zc6eSDQxMT71Tbu6Kq1rLncK73sb+mJAhSfRah2L2PPOsi5nnOxcCyDuJ7wUdJUbszOb5SL+UWcBz7UGfqbIm5eGErhZbbz7q/FrOV6bdDfzIWIXdqV5N5SiWg1tvCBpUYTw+BhOlZCdG1Gs/GfqDcQ/kKHmeota1u55nz8xuvpSQvCuYZpjzbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH7PR11MB6029.namprd11.prod.outlook.com (2603:10b6:510:1d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 03:17:33 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 03:17:33 +0000
Message-ID: <93a088e3-f5bd-4d64-8a0a-f5aad14ac3c9@windriver.com>
Date: Mon, 29 Jun 2026 11:17:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 5/5] ext4: prevent deadlock from duplicate EA inode
 references on corrupted fs
To: XIAO WU <xiaowu.417@qq.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
        libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, yi.zhang@huawei.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-6-yun.zhou@windriver.com>
 <tencent_B515F296245B20D721AEC2C9367AA188940A@qq.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <tencent_B515F296245B20D721AEC2C9367AA188940A@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0327.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3b7::20) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH7PR11MB6029:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e3ad73-8914-4b09-cabf-08ded58cf5c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|921020|18002099003|22082099003|4143699003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	nvRw/FD7zsxpaVE7IxwLCGZ5d4gvo9coIJ3Blz0ZrrEA6aEY+i63OC7NBRSmjclIVAGEHNtylS/d8bU6QecBPc6tw21x4qh+jvF/97ZuiiPSkOU+qkheBaYaG7fbbtlJpR523j8H4l8Luja4wNqyTuNdXdQs4Qc3zzZaVNKqsvcPixhu4+j9AZ0J77Tqto75XbQu1KBnDSxKhsz9ovzeX4QCQ8krZWOFSj/SYmWyphjLIjlttKMjK+7xzzNRSlPxxJMpo4bXw0IdRDSsNYqsucOcMx6yF8sOmkWfZIPHpzL3kL40g/i1WShYywS1gK1NxO9+2WvPrP/++dfxc5tOfSK4o4kqkVhUA826MXQCH2V03IviLRo+kkerp6DMIn/Sm72aN7AaKy1AZ8YUKIFOfZi9aRHqFs71vlkMFl7mVf3HdbXUK31zmy/wyaEBASb/j5iw0GpFELATU30VqUaDjsNLQpdTFZfiUU1ul55XVx0pxWSl5bnWSB2mW2ZbOf7q4q3JiV58Iap4r7oajzgQtCpAozyoQfYsCJR6qvtQ3L15zX+ocTLO8+eyLCaHF2gEE31JMtpQxY3MD40ArJCjxQII6eUz5Hq4QJnJaUalN/Fg0GS8mPyB/phyoBBaMHLOPRzkLvw+akRYYU2paxgNhA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2pBWW1zMGw1NzNiUjZTQi9URVdpZ3kvaHVVbEc3eDRJR2o2VVQ1SXRwYzlt?=
 =?utf-8?B?MFQvS04vU3FqUUdZcFNYSUdCV3ZIbjduSlNoUEpNTkt6THNBRi9aRzFzM2Jw?=
 =?utf-8?B?bGM0d0tpWHlEUHFnNlgxRDlsRHptRmZqNkVzTy9aT3FNRFQ3OWt5WGlEMEda?=
 =?utf-8?B?ZndmTDVPYk1TSmhFeVZkS2Y1Slo2TVQxVVIvUmdCVU9KemtZOTVON1pURFdv?=
 =?utf-8?B?REo2cXlQWW9vTHlESmpQSkhVQmJpZjVLQ0VDdnB4ekpENldoVHNuTGVxT2RW?=
 =?utf-8?B?OERBYnhDVFRWcWxxcExoeGdvWCtoSWpFUVBibWpMNHYzYkxhVzFMcERwV2t6?=
 =?utf-8?B?SVJ5WlQ3eUNQK2J1MXA0bDh5MXE3U1B4WmptWVlLbndCOGdXVkk1SWorak1Z?=
 =?utf-8?B?Q3JiV3NVeTR0WTJOMEM1MWFabHEvRE1qbXFvM2hWR2RSaXBMNUloaVYwS0N1?=
 =?utf-8?B?Z3pDVi9lMUFLODBNc1hlNnd3anNDYzV1UnZJOVlOSU9VaU5lT1Z0dXVCaGNI?=
 =?utf-8?B?TVlienQwRi9sSzJwRmdKdnk0MFNNTU5Odm54emhIc2RmTk1ycGdod3ZpaDBV?=
 =?utf-8?B?SG9yQWNnZDJnOVFhYmt0bmcvbVVDRXJUSitiMEZHYWovcDR6R0pja21UbzQ2?=
 =?utf-8?B?UDQ4QWVnS2Y5MHJFbFBFcjZBVDY4N3h4Njg0VzhrUDFGdmlZVzR3d2NjSnFE?=
 =?utf-8?B?T2xVMUVCdEdGTEt3WngvYUNFV1o5RUZpcDFoN3JLTS9yMlMvaHZIZlZkQTJB?=
 =?utf-8?B?aUpIV0w3U3ByVzBzUlJxcmNZVjA1a0ZBQitCcVc3MEx6eHQ0UEx1eXVvVTJ3?=
 =?utf-8?B?blZvU3NxSTY5UGQxT0pYc2FjNzBoY09YWW1CdDVmbWM4VmRGN1U5SSs2aXl4?=
 =?utf-8?B?WWVyMWRBaGorMWxTWS9ZUGpkV01wdXpKak1tWjlQcWpvUFVpTHZXZ2xCMkRJ?=
 =?utf-8?B?b1BwbC9sSFRNa2JDdHR5L0FKRzF4YS9CUEhjVEV5dTcra0FGQ3R1aGR2NC9t?=
 =?utf-8?B?ZEM5ZlowOEx1T3p0V29VSjN1NDV4ODJJY1pPODVGcHlOSW93clNiODBnTmVI?=
 =?utf-8?B?dFFKbTlVSTRJOE14bWgwRHV4aU5EWWtIK2dvYzFTUEtlOE5wc2ZGZy8zcllD?=
 =?utf-8?B?am80Y244cjFQSW5TRmxnNEFpdDJCUzVCL0JSUVVmQ0NsKzhpL0t5YmVlY3Vx?=
 =?utf-8?B?TGZIMk9PWkhaekxqV01pSG02cnNwN3dzK1Z5T0ZnWXNveDRBcXZhNmdhVnR4?=
 =?utf-8?B?YTFqTmZ0Z1E0TzkxdGRHSm9LSnZpR1QzN1pZTWIxRVlOZmdpMDJNa3FyL0ZM?=
 =?utf-8?B?Q2s4Q2hYQUlwdjkwS1A4b0VOY01sT3NaamlsWlYrb2Fvb2Jmb3BsTnNxUHBw?=
 =?utf-8?B?TVpTRHlKSGc5czVJMml1Rk9WeEVVd1cxZjlFRlVUZi83b3BXVVVlWjlRK09X?=
 =?utf-8?B?eWJ4N29DZzRGTWhsbWxNTVEyUDNLSTFHTnNWaTd3dm16RUxxR2FhVXdPMGlX?=
 =?utf-8?B?M3ZBN0U5SnAwdEJvTGdnU0VjaGx4RTBzRkxTWmhyRXErV1FNdDRVbkNPOVBv?=
 =?utf-8?B?OE1ONmVZeThIdzh5UnA5ZWc1Q0pxSUxVcmZsWGNuam92dGJ1VERHKzNKU2hJ?=
 =?utf-8?B?bWYwWFJMb3czN3hRM1g4Q2trVFFpR1RuYjVpOGRkZ1RnR2xBb212ZG9SWWRk?=
 =?utf-8?B?TnZqTDVUSEE3TXRGemZ1YkZqUTJCd3hXRGUvYjFGSHM0SkFUVmRMTnA2QW82?=
 =?utf-8?B?T3hyTStBRE9QeFJ5Ylo2T0FOdWFSSk5xSjNWTGJ1SStuK0dWQnZLOHJKRkNZ?=
 =?utf-8?B?emJ2TFF2SFJlSi9KbUF6dHd2eGQyUVNEeTlxZWtwNW82VEwwU29GNkVBTmRt?=
 =?utf-8?B?WTVOMzZSaFNXenR0dzZ2Z21XYjJHeUNPd05ZSzNISmUrYytLOHFoTGJrVjBq?=
 =?utf-8?B?TEczOEFGVU1JRHlCMDN2OVYxMWJkTm1mS2VhbWsydEUraC9BU3J5b1VIaFRS?=
 =?utf-8?B?aFI0NUFUYWhaVHlVSWVFZE9sSTRKMzlJa3FvcUxBN1gwMmJFZmxZc2RCT3l2?=
 =?utf-8?B?RWhOKzNuYUlXdlYrTkV5K1VvQXRqRmZ5VEdJMGpUaGVQQW9QUmRRUUxqWno0?=
 =?utf-8?B?d0ZtcWZYY3Awa1lFaFhFY0pQYkF2anFZb1Q1bXFUQzljRUFPQ1I4TTZQVnJX?=
 =?utf-8?B?ZVdSSjhIcHJPRGFrc2tGZ0U0RGM3cEh0VTRmR3Q3Z2RweGhhN29ibnFlZDND?=
 =?utf-8?B?akpzY2tOOXppY2ZRTVk5K1BvU2p2TWtGZVF4VGpqUHAvb2xnTTVDL1ZBWTRv?=
 =?utf-8?B?V3BheStib2dyWkd1cXZlZlZlQVJpTnpUeDVsdU5BNE52MVlMcitSZz09?=
X-Exchange-RoutingPolicyChecked:
	bJJjH7UKMbd62mNPWbZLd1k+YiUYyz1dpsZK6nXUOgKqJh2fHvHeqRBuz5e1D0r9TS6eZpUKocXmoGWxXQHtakHluEvU8EmmLoEkv0xpUhTgGa1JuHWnzEBhAVagl2xCPIUU/1O2wLsDIppEq+tIfD7kKj6d5KY/ZvMw9q0Vx7uYAy7vcL8h9Z+CftWrrSm8FKalZm99LhCHI+voMwhCAABw4s9Mwmj+gh3TLR5Ks7R1XrlqpXLgVL/pB7CM9Z3lps9Xz1QaqCqMQH71/yDBwk/tmMpilF7uQjS1nXmOqB3rwMBAD4BXbrv70e+MzCbtMz9iQnuYqKx1xen+KqvCig==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e3ad73-8914-4b09-cabf-08ded58cf5c2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 03:17:33.1030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OmUqROeWBlCT88BSmMuNlnPTJvdqYX32s4Xz9UUyyAvKO0xMdFeMT4af445eaKT7ZuYOFjgv70b5TUNhrov6fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6029
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDAyNSBTYWx0ZWRfX/DEXqxWD5vbk
 RU/pt/ux1shhnRRuNTYnrlg2Spj5WK05dFKhemZ71aKzuR8KW3jFAqvGeb1mH/UCaxybJLwu8gA
 SG8SWhlMTOCQvn1z0xNnbEnoYI6sBH7FyDK+rGHQinis7b817QZv
X-Proofpoint-ORIG-GUID: bVOxBxki7qk8JzeTfnGUDWwPccp8MIAI
X-Proofpoint-GUID: bVOxBxki7qk8JzeTfnGUDWwPccp8MIAI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDAyNSBTYWx0ZWRfX7e9g4CxXERIC
 7mbCvKl5zUQkmKvGy56anvu4j51cBq9wxjfKRjK6hdselQoBVXWvHBchihy8ydV2AgFpaA4T/lO
 R61DrYE5F1NoCpRMqz8Adug8nKjC6v7FUIZMvfxAyYVX05F1SbsJj0ZO3neNX3sT/9Sd/mBipGc
 hFPUk/Hf54k+HJnXHMZIZgq4BRUQG3rih2HuPYSeCETko2IwwwAh1nblMXRGl8OpRaikRGT9qLR
 N4wc0KnWF9Icx5oPHNJ9xzvAxbGI5WjM5Omv1pOWFGydlKTqSNlXUWGYVx0T4BJMKc00zIhAbIa
 sST+rALD7AlO8c06qpMyLiiup8i/o9fYw+AdCrhFMeP+xZ7QlnjFl4w7AW0o/JT66gSM/NT+H8K
 l1ZZP86nlFisJ6vMtuPkXLxO9pJU3zEC4ocFhcEutGRfiJZ32z3qz3+7XIgDByt2+zLLh/Ic8HI
 nMqsJmy8PPjlYGY6XGw==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a41e3d0 cx=c_pps
 a=MCVANC9+7Y5oazsiooDUXw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=c92rfblmAAAA:8 a=t7CeM3EgAAAA:8 a=OmZe0yJs8ERP5gnB7g8A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=GvGzcOZaWPEFPQC_NcjD:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1011
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290025


On 6/29/26 02:57, XIAO WU wrote:
> 
> Hi,
> 
> I've been following the sashiko-bot reviews on this series and was able
> to reproduce the llist corruption issue that the bot has flagged — it
> triggers a kernel BUG at ext4_put_super() when an EA inode is leaked
> onto the orphan list at unmount.
> 
> The sashiko review is at:
> https://sashiko.dev/#/patchset/20260625152941.24788-1- 
> yun.zhou@windriver.com
> 
>  > +/* Put all EA inodes on a processed llist via ext4_put_ea_inode. */
>  > +static void ext4_put_ea_inode_llist(struct super_block *sb,
>  > +                                    struct llist_head *processed)
>  > +{
>  > +    struct llist_node *node = llist_del_all(processed);
>  > +    struct llist_node *next;
>  > +
>  > +    while (node) {
>  > +        struct ext4_inode_info *ei = container_of(node,
>  > +                        struct ext4_inode_info, i_ea_iput_node);
>  > +        next = node->next;
>  > +        ext4_put_ea_inode(sb, &ei->vfs_inode);
>  > +        node = next;
>  > +    }
>  > +}
> 
> The per-call `processed` llist is declared on the stack of
> ext4_xattr_delete_inode().  If two threads concurrently evict files
> that share the same EA inode (same large xattr value), both threads
> call llist_add() on the SAME embedded i_ea_iput_node, each trying to
> add it to their own stack-local llist head.
> 
> Since llist_add() unconditionally writes `node->next = head->first`
> (which is a stack address from the caller's frame), the two threads
> corrupt each other's `node->next` pointer.  When
> ext4_put_ea_inode_llist() later traverses the list, it follows a
> dangling next pointer into freed/concurrent stack memory, causing the
> EA inode to be silently skipped during deferred iput processing.
> 
> === Reproduction ===
> 
> Kernel: 7.1.0-next-20260624-gb27bd6a65c17 #1 SMP PREEMPT_RT
> Config: CONFIG_EXT4_FS=y, CONFIG_EXT4_FS_POSIX_ACL=y, CONFIG_KASAN=y
> QEMU:   QEMU Standard PC (Q35 + ICH9, 2009)
> 
> The PoC creates two files sharing the same large xattr value (thus
> sharing the same EA inode), then concurrently unlinks them from two
> pthreads synchronized by a barrier on the same CPU.  This triggers the
> llist_add() race on the shared i_ea_iput_node, leaving the EA inode
> unprocessed.  The EA inode (nlink=0) sits on the orphan list, and
> umount hits the BUG() assertion.
> 

Thank you very much for testing and sharing the PoC. I used it to verify 
the issue and found a pre-existing bug (fixed by a new patch), but the 
issue reported by sashiko-ai could not be reproduced.

# ./repro-xiaowu
=== ext4 EA inode llist Race PoC ===
Iterations: 2000
Discarding device blocks: done
Creating filesystem with 16384 4k blocks and 16384 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

Filesystem ready at /mnt/ea_race
Starting race threads...
[   44.741752][ T3761] EXT4-fs error (device loop0): 
ext4_xattr_inode_cache_find:1616: inode #14: comm repro-xiaowu: missing 
EA_INODE flag
[   44.743426][ T3762] EXT4-fs error (device loop0): 
ext4_xattr_inode_cache_find:1616: inode #14: comm repro-xiaowu: missing 
EA_INODE flag
[   44.923046][ T3762] EXT4-fs error (device loop0): 
ext4_xattr_inode_cache_find:1616: inode #14: comm repro-xiaowu: missing 
EA_INODE flag
[   44.924562][ T3761] EXT4-fs error (device loop0): 
ext4_xattr_inode_cache_find:1616: inode #14: comm repro-xiaowu: missing 
EA_INODE flag

Race loop complete.
Check dmesg for crash evidence.
(none)
Done.

Thanks again,
Yun
