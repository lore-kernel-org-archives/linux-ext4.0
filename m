Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6BE7083C;
	Thu, 18 Jun 2026 14:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781794409; cv=fail; b=l4cFDAjRiKjdugMHfKPrTl0cuzffMARuQeA7BdZXjjtLXhi+JfDhMw/hxxGuJixEhV427BCeyZ+V3OPRUOEE4IU/tW4ZQnotHHmXlv+717ubnyf1x2r+2qj7RXp9p6IfKzFTftuiu967HBCjqMPL/PqpDlosZq3kPeMa2gceV6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781794409; c=relaxed/simple;
	bh=3P+k/9VnC3+k0lbaFtG5fkMMae7N4jMb3vnmaZuRQWQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WJdBSwTyw11WZNf5OuzvHngiIct45AqBXpHwmus1dyrDbreNiWyoM4ekgAxAsCa7dbn4ozQ8aRJIbGUd0HclMtYX5MernX7gxyIrIBB5NM+POAEMR0gwxdogCAktTDVZuSmlPXlOwHUqFSVdOwWQfh+b/I4LSwooQLOhDCAgLnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=jkf2kUbS; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="jkf2kUbS"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IDvix5137819;
	Thu, 18 Jun 2026 14:52:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=vENOf5ogJVDHYxHlgD8EcqjJ8bj0RpmcJwYTh48DjLA=; b=
	jkf2kUbSRoWC4mlh5s8Y8OMaAZpJ7Fp/8B1wXV4wHZgw1JO6m02kcBf/P0Gdcy1S
	1zctE6ruEoFP5OOXNC0Qq4pYT/zPdAKSDPQPqZQdtnYWVtw5qncd2NhJ6DPO7oKR
	9+PdCWGlvWV5zKj1JbHZIorCb40pIIUDskIw4EhCT+q0m9hEYDp5gZUZiQYU0Lfa
	UrbmqlmJ0QAhE+ebI4bW1Prr3QEDgS9RZts3JG/juKLEA9I5TQx9icqPLPKHoBfi
	ebVTgqSk4MbJFvnskk435D4wlJCRQvPIaDEOTnC9bBJPYou2M0em80F8GfLEakZr
	fyfvTSQNXcJxkHNQv3yjOQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euefc2qsf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:52:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nfVkx2+eaBzTHdHtnqKIf4rV3UubC4z8NxfMKD32oQpxKwVAdU9d6woFBi0R/GYFx32K6LQWJuykfATwnSKoyJB5dzffUfIRU3nnkxSHybNqsP4kO6yLdtE21/A4Z4i+U5saIjFxc1y6pVR/QLVv8j3Mo8IKTMOtfp7JFFxTKm5e70FQuSz4DtMfOOUwMYYq6Cav+xAOoVSnxOOILAnvfUQQwOZEtNADHTj9fkbbOIhnXiRtmf/TgIluFLeaXK5s2WQUPMxxI+TvGk3hjbDKKB+cgxIgfZGpPYq6Mn2nZxduDELPFXyYe7ClCr1mPCh/XtLBF+N1SDwOA+uVo6aZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vENOf5ogJVDHYxHlgD8EcqjJ8bj0RpmcJwYTh48DjLA=;
 b=fLQsrD6Zb19q/w4p52HW0Jpc1rXBrO/Me1V3Q0aQqoKJlLqk/a6UQIIvNUHeHwbG6Q1WfqQaXqPGAIJ9B5FOVpuTbtRD+Ej/FYinNFcVsfKqJ1zv49IrE+mgVVSHvbor9XmpFynYB6N4nP4Zm4qNCaufl16v2oxTLxSZN8eOpyiGKD5bqkIy/lLagvoJqr0c5LnJlQ3zIRp/HWayB1Z43J0ep9Wos8nteeULSBkzXLHrO6ayV5/Dix40i/yBQGgRR7dRK58id/GY84RtuX6rmOQQzniz3EfDCy1etRuYfqKSzW4iahTr6GJFxQ5n+Xg52vQ3eDAMOugRbLezK2fD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Thu, 18 Jun
 2026 14:52:54 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 14:52:54 +0000
Message-ID: <2cd89c14-555b-4d45-a5fe-5488d9f9626d@windriver.com>
Date: Thu, 18 Jun 2026 22:52:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ext4: drop s_writepages_rwsem around inline data
 handling in writepages
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ebiggers@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260615061015.1523668-1-yun.zhou@windriver.com>
 <rvwzagttciesrgonspk37dm4sxkxxgd7marnwtz5c6cpag747e@wvnqduid6hv7>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <rvwzagttciesrgonspk37dm4sxkxxgd7marnwtz5c6cpag747e@wvnqduid6hv7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0004.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::18) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH0PR11MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b79912b-7c0d-4e78-de02-08decd4946ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|7416014|23010399003|18002099003|22082099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	d1V4pRzBbmUTwKLNB6kvWwE9ocJOyjVwaru436JiV0uhz1hAkJaMdYSlIFWzf+4NvPofQDQJKKAB2KCCccniLbrd8JebQUYkBSE4ObM7ffjdcvW44C/su67ks2szSDS4NtmwpQXBiZMkkUO7MBhqahwl9JrIrnsmI+CW4yRN/oaiAGNozkftK0FrO9y+5LLsG8WwV92mbk2pI06ITnVvmylOAmjAUbiU5n+ilkWYmn+t0FA32jTXTiXFeJXs6kDIpWlKhhNuTFYSE/es5iLFZg7uJwS8xnzI+RX4xvLNC44gX/9JS0Q8yr3cXABeixiZpGgvCxjPhW9u6fOcIXDTFJqxvkLirdeWr3DE1x05Bv/snIGQhJx9cbkVFCnmIhedspMK9j5sYzSwH4mg3RCGYYC7zc+7oBsAupSWUNMiK2gTVQ8NjscNrN+VdnrhKfkZDIZNeGVsG6hqOwKjlbJgzWiwl9ERfNuTh5kTDgY6zEWnUjohKH6BKIPVPCCOVSCZ7xnmbQ+Gg6ehOF1WHkwupXvkDYfRBckCaqBdDze4VbzzRDUobYe5s5p0Ekug2zVwIAx/Cg9SAtSaV2VXld1Wt7uJVbsyVlu86HC/9wBQu4pG6bmZ8H+ILr/8XPHpQ6OwEbZdyiRtNbZb63dlV16PNp+bxDmziFvY6CVxEjTR7GV1HFXpFgzQWUr7sC+cGayR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(23010399003)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1RnaXlEd3VXS3hZNjQrTklzZi9IV0xxU0wvSmlhWlA1bGl2WHNTSS9JWTBD?=
 =?utf-8?B?S1RhNWVwZDBiVmMzOUp6NzRRWEp5Y2kxZTRiWVppcFVKMmhJQ3dwWkFEd25U?=
 =?utf-8?B?OVJhSnhaL2hFc1lZQ1huZ1k2SElMVDJoRGJtYmxPVEYxYXdncklXRVNxWHpW?=
 =?utf-8?B?ZWRZblBHdE93V0R3OGVMdDhCNnh4S2d3V1F6cVNrWmlNU3JqclpTYmM1N1dX?=
 =?utf-8?B?Rkg1M0g3amNBbXJWUm05QitOQ085SldQdnVFaFkrblNRaUgzT2gwS2Nzamlr?=
 =?utf-8?B?dDd6ZWRnTmN2blJXMHZvRGV3ZGlwSUZsM0lLQ0F3VE8xRGkxTGxiTXNwUkJW?=
 =?utf-8?B?SnFtRVQ0ZDB2cXdwOWRWV0lHQVdyaDdLc1llblVuQ010RHN1bzVENmZaQXY1?=
 =?utf-8?B?ckxqUkxqNDVkeitQRWp4d1lvdVNsYjltVExqMEQ5K0ExcU9BbHp5V1ZucnlS?=
 =?utf-8?B?S0g3V1ZnMVFjei8xOG0rQTJWL2NNT2pWNFhDSmhub3JPNHNnY0grQ0FzRVUz?=
 =?utf-8?B?REp5TVJYcU5ZZzUxbkZWbHQxckZhaVk5emF5T0YyZWE5QlpmMW9Tb1ZqbDFs?=
 =?utf-8?B?UzExbkg1R2lPdkJtYjBKYmUvc2cwalZzelphU3dWRmVFSXBSRXVlN2R0ZzMx?=
 =?utf-8?B?clB2YU1MTFA2SGpwUlBiQm82Z3hGR0N5eU5BV3JERkJxTEx2alJhVC9hQXND?=
 =?utf-8?B?VE9tNEdieW0zOURtRFRQMEYvcWFMaTFZWG1Rc1dxemlWWDRuK0lHZGFVbXdt?=
 =?utf-8?B?LytGam9pVFBXZzBqS1dRRkJMRUZ4dkZsWlMyYW5xbHVoWGNDWHlHTk5xL3BD?=
 =?utf-8?B?UmFCL3FMOTVRWk1jcjE4NHVJVFlDUFcyL1JCU1F3SnY0ZW05RlE1dW5VYnZK?=
 =?utf-8?B?MHBXYUlxamszUkhNbmpTekRhQVNXUW1UMmtOUjc5cWdJVnpjU293eng5NURr?=
 =?utf-8?B?L1ZKTUNRR2ZPTzZSK01uY2lrY0xUUTJpMkhHRDk1ZmM5Mi9wSzJRWHhuZXNv?=
 =?utf-8?B?ZmM4MCtlQ09xYVl3aXNaMjd5WDRQdVZVUXFheDZZYXBoWTFkWW03Y0N2TFdL?=
 =?utf-8?B?dm1iYm16VDE5YjVMQTBzVkJiRnhVOXNOTHhzQmViRjlNUXJhandnQnRqUGFF?=
 =?utf-8?B?V1RmbVIyZ1hlMEJQaXJ5VUp1TnYxb0dNZWJQV0haSzduR1FWdGF3WTBWREM0?=
 =?utf-8?B?OUtPVHVYc2MvRDdpMG9ZZ0YrQWF1cXUzdEMxTk1UcHlsQUV4ZFFCTXNlZW9F?=
 =?utf-8?B?MzArOG9Da0RSV2VhalB3TURHZlBqekhuZW1oMStwVHZWT2plbmNrbDBtckFl?=
 =?utf-8?B?c0lsMXNUOG0xWEVPYnlQTHdGd0t5U3RsR0Yvc1NoWUJQamlOWmxEOTZ3aHlw?=
 =?utf-8?B?VEZleloySDZNdGdvR1JGb1ZQUmtKKytvUXdQK3h6dE42T2NPdmFHWVdORFNL?=
 =?utf-8?B?YThSamlRYVl2TVpvSDk5STFuNUJyK2x4cndqRlRaNiszQklWeEFCMnIrMUI2?=
 =?utf-8?B?NGJLdXprb1NjL1FFTzdXWmdiaWlMUXg1V2dxcnA5Vmp1U0lBSlZYS0JKVCs0?=
 =?utf-8?B?S2djTHBua0RhTXNNRXp2NmdRd05GdDh4RGdNNzE0Q0Q3dFduQnFFRUdWdGFr?=
 =?utf-8?B?RW10TndPSHdDZzV5MDFibS9mUWV1V0oyTDN5SS9ZUldiM3o5VDNxcUtBRGVx?=
 =?utf-8?B?Q0N6K0hyR2t6cmJEWEYySm1LRjFXMjRaOGpBYjRvMzlKdE1QckY2WS9JMnlh?=
 =?utf-8?B?Sm43YzI1ME96ZG9BbUQwM1FsZGVXS3AybnptSDc4OUtBOWIxbjEya1ZVZERh?=
 =?utf-8?B?c0xGU21kZDFROHRld2NCS1E4eSt2MGlLb1JqOUNzVCtwN3BvNzJHR1dNajRv?=
 =?utf-8?B?UzlBang1TnMyUnJyTzlVVHc4NXRPaUlYOEJzbXBlQTNiM2s3WkpraWdCRDVM?=
 =?utf-8?B?cEJ0TXJrL1lYclJVSFZUNkVJYzRXV2kxVXN5Yk1LZkl1ekpYS3hCUmgwUkZP?=
 =?utf-8?B?REhZenFtdXRDRDg0L3RXMWM1djRqNWFEM0pyWXl5eUtCM3dWTUlyQ08xMDR3?=
 =?utf-8?B?MzFQNVBGWVE2aUZiY3ZZV2ozOWFOU1loZjAvdFVqNkk4TGl1alJqSmYwcytV?=
 =?utf-8?B?MjE4VXlWbHBzWWVQc0VtY2t5SFdVSXFZL0tvVGdOQXMxKzltZ0xDL2tkdFFG?=
 =?utf-8?B?S2NJeUNHbnFBWEU4ZFdCNERrYUVCUWNXYzBTT1hUMjIzdTZtZTk4a1NxOWNp?=
 =?utf-8?B?czNpUW1zWXJkMVUyVkMvcmtKbVdManJwVVFQMVZTRHFjTU92YTF1ekpFZS9y?=
 =?utf-8?B?SVpRbDdvd2huNHIrbmFtaEtzTE9sbDZvQmlqMHkwY1NMMXJTS25YQT09?=
X-Exchange-RoutingPolicyChecked:
	I2r239bv4nHpu5CSb62kdCvzHoZL6DVyYxxGFjNBZrcaigiYFjhfHXSJ435fuSBKp6fYuVm3DC9dsX9AWKnR0V+2G0Okg/bXzaLig3lMMNpmHM33GKXbM4yqVtRSDD4FqQFD5/yVGssTkcbvOVrUEnf2e70NiF5lcAbDArgpEeIs/Ioqd79AtrIjEhs0Ea+/YLZ7E4Egzw2Sj/JWSfc0JyvuW5JB3rtQV12rGlrMVTl9n6fB/xB4Cs7kxgOMiktqxK6E+MYQhZJ6Q4gjr5ItMRADj4MAYPs06ZIU1R4g/39DB9Y9AJl1weiKWZCWmmWRwdkaJgAiUWEgJWgmYM/+xw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b79912b-7c0d-4e78-de02-08decd4946ff
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 14:52:54.2486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsiW7zDBAsq8uMPrdqnYNs11wmoe80JLCISNLlBrZl4CBSX3dqyl7ZGBDcz1WieUac4B1KDFBlSRn9K1cmO81A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEzNyBTYWx0ZWRfX6PdRl4wvq3Bh
 DUdg4W7Mt3/to4+1+mmkbtMi1Kw9XSa00zbByYX41EfGbTd4JIK6RPlj+fs5l0typAK85/4QYdP
 5ntppelhR4YD6KNWn6Gmu3WpXSRmiISE6xvCadq1Qbcxx5NXTfIB
X-Proofpoint-GUID: y_qxIjFl3KDeKOC931nf7DiElz4R91_m
X-Proofpoint-ORIG-GUID: y_qxIjFl3KDeKOC931nf7DiElz4R91_m
X-Authority-Analysis: v=2.4 cv=ObGoyBTY c=1 sm=1 tr=0 ts=6a340648 cx=c_pps
 a=GsI8iPYaTsLAaW3Q0Q+aKg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=ajRZfMs8HzeKjUIDMhIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEzNyBTYWx0ZWRfX11UutzPh6qQh
 IYKMwxq6wcCg0TvMZgMP+izx4rZsea23YmMA6dnrmXFT0oy46NI1xG2cXoyE0KRXZAKrLPcox8z
 Cf87H5wReLX6LZjrQIVFC6S46yoPfTgSsxudSZX1bcWaIIWT6mQGajio4G2PYSRcCS9wEjXVkkj
 DGv6xJkOiB4/rgo+wYK66AlMyNxSuk0nQuxAtNLyjExsvtECs/9r1FP7ejUCt7oNIoED41VWkLe
 VWvBDXjPeoCH8oOES3GsM6dyWA9E0vuTleNMWiIDzKeq+GBKf5/cqigo6/zH7kuD37/XvvGtZrE
 N8u0yxpMeiaBg3VjBDuGBbxKxLHyQ3k4xJ+QP/jmF1JTg3+rw0Ed4FCsufhIdLMZttYkCTymrZR
 ngw4aLIwnUdF6sihkRW26FNXRJ1qHeTeqb0hmLVDwoxLrbwRbUGnID53lesBSbakFsApnbt86qG
 Rk2O+TBidd2Ih9hT8gQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180137



On 6/18/2026 10:23 PM, Jan Kara wrote:
> 
> On Mon 15-06-26 14:10:15, Yun Zhou wrote:
> 
> You have fixed this differently (not expanding extra isize from
> ext4_evict_inode()) and furthermore this scenario is really impossible
> because you cannot be inside ext4_writepages() on inode that's undergoing
> eviction. SO let's discard this patch.
> 
Yes, that patch series can resolves all the deadlock risks associated with
calling iput(ea_inode) while holding a jbd2 handle—something I hadn't 
even considered at first. I really owe this to your suggestions.

BR,
Yun
