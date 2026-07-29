Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D92D0C9D;
	Wed, 29 Jul 2026 03:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785294803; cv=fail; b=qZwCrbtVCIKElAMcTIm9BBl6oQglWWw8xoe8ab8ZRRS921Qbd4l8qzxMYoCGgDqmR1v+W8NfVeLlap9fssQYdRtNaCndRr2V9ogzqgUUrlu4ovNcGej06+nwoR798rQkF5FrJZSAfOac+hWG9RLNwnrL1cIWPSbpCjwanTutenw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785294803; c=relaxed/simple;
	bh=eS3nOfxLNk9ZmW0ZIlYqZSAnyFIZTq8ar9ocfki5LFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qu0bZpBAvapwmo9nhyFUQ1nWbOZP5OrpHu/wSexUoVzc2og3fwl2YpoaLe6uvCBp1RGdhd5fpxX4PnP8obRia/jIQkOYuOkSBsfA+SyY8S+USiZG5Dl+zkp0UB255nzZpqkkH7shhak3PEBCanU4xy1wDCHUhyDyOV5F3/dJO9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=ABgXW3YK; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="ABgXW3YK"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66T2Aw3a280302;
	Wed, 29 Jul 2026 03:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=zV7tUlb6l18rSKR0yKkvDjf7yfabcdfhXRSF4+FryPg=; b=
	ABgXW3YKjelQA8WR7bC+ygBp5R1AKPZU+H2E5S/81zMIdCFHBoSvI55CWDzvgg0o
	xqjLlk0c/Rwi5HKUfiAGjA8yO29u/ZtUtRnMGNAEPUVSmDXX1NP1LAsnfXvlQY2O
	UAIHi5IydicmDHHAnvOrB9R0+89KoxZbol4k/PL8u6hH0cL1O2+2q2ZEtc4UWpcx
	H1DzMrHfjAZohZM/PnXd1bsBd++aLmtuomb/wK8ebGdx3ANentfwa5XA3ZjLYFEw
	DmD1MCgrbOmrSwEighNSsOB2eaaaXnxpKfQZVBy87HFcVEqrfwOrF/Q5212jfNiY
	UMeONcS4GIQ9Xwr0Bna6bw==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012016.outbound.protection.outlook.com [40.107.200.16])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fq877g358-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Jul 2026 03:12:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eh5JPyNgjTwrMgHekykZFVSERhp97hiPtMjnfSkQc7h/9TpblVLOo4hK6Q41cFydGrwoTModmBL7VPGQV6WJ07nQXcBgFMG8iN6YZyw+EK9btxqsumXr+ItMB43I9IRoGM+6Bzjw3mEQlvR9u3rtygab5DyeFGQtYCGwuEjcujz6ej6N676cJGYyrtpYOcr35uRZhW8YKksthUPhrg4cAe37oSS1DSvHYMbSfThe2ziLSkrwE+JNeyUQAiVusxHjOURPWea2ZlAx+ZbnIzXxSygG5+4y+P4zHJjt/a9ghE5ghBylKjLF25ezu4AR6xyOAx/JU730dhP0zQ2hMd9N1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zV7tUlb6l18rSKR0yKkvDjf7yfabcdfhXRSF4+FryPg=;
 b=cfpt5x/0iObr8yslk+ocBhi+DvCnkX9rVxEvYakZjLsV0mFwIB17j4CIlrLZ/ZJ9OzpqKIqOrv59IaBaJZOdpHLk5T2fwaE3+Fxn5jF/jgFZgxL+mymRjINVMqHgUjLuOjs8SWkU3I4jElEhWiQwHsGrSOAfPF5pe6xFw8ETt61r7yFLd0IHp/1fsZ2HP/WdY01V1fUSQjlp4p+sKLY/nm1lNy6MuEz1ts9TRb0ylb9cnjbyDsPFTKssLPCNmT1fyk5XoLEZ2KXrxMSR9QlLghi+L4zeXuyC1b2GezNP2PWcyRmYE4knhPY/GXoWM7oGPp/Lg/pMXxYqjg5cmejpsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ2PR11MB8423.namprd11.prod.outlook.com (2603:10b6:a03:53b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Wed, 29 Jul
 2026 03:12:25 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0245.012; Wed, 29 Jul 2026
 03:12:25 +0000
Message-ID: <2b7e4668-9679-42e5-b71d-14b49e702624@windriver.com>
Date: Wed, 29 Jul 2026 11:12:17 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] ext4: phase out inline data write paths for
 regular files
To: Theodore Tso <tytso@mit.edu>
Cc: adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260727105441.3213095-1-yun.zhou@windriver.com>
 <amdhvSR2YL-3AJKS@mit.edu>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <amdhvSR2YL-3AJKS@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SEWP216CA0095.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bf::15) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ2PR11MB8423:EE_
X-MS-Office365-Filtering-Correlation-Id: 31ff5a91-26c7-44db-2e3c-08deed1f3681
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	98HfzEhN2AGPXI1LpE4Ouz6ewjf+Btm9E58H9YzWqKYadRNsGwgi79H9XxwAgixcEnr7mtgsfywmwjFHaRBld8urHdS3ASuZ5vbPdHbNCYyIIbbubgQzZp8jnRYejgnezKeL5/5AxT7TORewCSjTDokiEUrsEHYa5VL8EL4x4AgtPFcF8N69dDNB0qTFg/SbX8eKNh/3HVzhqwTzVWB/10VlN3nP4jMiSnSC+OK/NPQCgGHF8jc8l3N2OMt/OY1AlbWxdOKcFLJ8YnhsGAQsMl5Df9rw2yQshgendHfCVB5jsuekrdm1xLmDr2ZfGYW1XS/I41rN76kBfd2Pu6dIiikf3GnjogDeCyveZQub9nEryhQa8T8FL0wtlZHY6W4djWR8u0o3DzF0PLUzuKE/8OIhQAYlajQoLXY3GiFL/ixXecdwuePr53ianNW88EzTDjQwGwmH6N0bs/5BCRuoNvJOhfkd63Moc8YVTp1o3uC5nVUVkg/QO7n6oI8m7wCTd9R9q2svUaqViuCq1nk26fQ7hT8aiBwJ4GYrQG82ayTZHt5ixuFL1uxCll88sq+C/fGPyG1Q1sFqUiZ0iQNB3DRtGGw5yNkhFrpepc3QlCcUqFGwKj1wQJM0qhPuF8jM5Pf1VaA83NNBnhXVk7Ck8Pkb1w6gKGKZllcPTUY4pqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGdXa2p6c2pQUVh4TTJnN2VYNHM4S0hNZkZxQWhUUyswTXJyQXlVMEN6dVhO?=
 =?utf-8?B?MEdDd1FmNnFkOUZWZDExdVV1ZUtnc2tmSm51MDNKUmN5RFNKUlBvbjZlQlpI?=
 =?utf-8?B?cEpyM1hRa2IxOE1ZUENpdXcxUkRiRzRRbEdvT3lBZTl2Zlc4SE5ncjdEY1pM?=
 =?utf-8?B?MlFOYncwRHZUU1NzQTdnQVpTdWQxZWZhbGRuVThTYndJRDBnQjVRRExncHp0?=
 =?utf-8?B?eFZOVlEvY3MySEtYM08yNHdERzNWNnpDVTZYV0JTcHMxbWdqYlo3aDZERVA0?=
 =?utf-8?B?WlU0cVlqWjRGVUhWalNEc0ZKTEVyVWs4SWg2SDNmaXRMSkFYaktLQ1dCVFVy?=
 =?utf-8?B?L0d0SDl1Z2hSczJZVUduQzMyWSsyWXdJR01uZnZrWEt0YVRPLytYL2hFUmJR?=
 =?utf-8?B?ZldvMEx1L2ZjcnorcVJuVXp3dG5jN0xLRmk3NC9Nd3pnZHhVcEZKVkhIVjg3?=
 =?utf-8?B?Rzk0a2ExY1NTUUdvaHZQN1YvbjlZTUU5ZzJWOUZiMVVXTTQ1UytiSWQ1SUdz?=
 =?utf-8?B?Y285d3A5WXBkSFJqL1ZucFhSdVJrNDVPajlYYTViN1BiUnFacWJjd3p6NUlV?=
 =?utf-8?B?aVBNaCtGS0gwUnRRQytmRUthRHJCTXBuZVhPTnd3Z2ZocWRjQ1RaNUpFSGZk?=
 =?utf-8?B?VHA2VmJMajFUZW4zTkFxb3crdDhjaFQzVmd2OWJxSFliQ1ZQOVkrRi9mclFV?=
 =?utf-8?B?aURtZlVvNzAwWU9aMHArMGEvRFNaeG9NWnIxRzc5V2p6SGdRSjhDTGhacUUx?=
 =?utf-8?B?YytvNUM1bFlQK3RwRlMxdmpwVzNWVzdlMDNCcEpJSUNaRFRiZVBsTm9xRDJk?=
 =?utf-8?B?SnZVREYzV1UxSmptYjBSU2F3UGhxSjhDN0FuNEhPcnIxcGQ2QjBRc1BOelRr?=
 =?utf-8?B?QzNpSU00elpXZjc1enRUNjUwcStGSU1xVEZscnVHNlMzNUlnTnRBTndRL1hm?=
 =?utf-8?B?K2ROcUd3S1gzK2tmSjE4dTZLQVJSaHJxRWY2Z3UzczhOTGNjS1p1a2w2Tk40?=
 =?utf-8?B?L1RrN0lJdXlxOXFqdy9oc0xhbmpUQ0syc1hER0ZuNHVRTTBxT1RJNjdnUXBE?=
 =?utf-8?B?czhpZ255OXV6a05KNittdnVPaExTOEc0UEFCam1iNnVXSXBuMWpSeU85amhy?=
 =?utf-8?B?WStHWUZDRFpOdHpsM25TYnhaVFBoYzArMzl5Zy9XY0tydXUzRVRaM01oRU9w?=
 =?utf-8?B?L2N6RXF4cjNwSEpNZHU0OXRlZERaRFFIOHZ3YVA4MVBwNVE3K0ZMZmVzZkw2?=
 =?utf-8?B?R1pocEI3MEF5ZXZ1MjRNbXZWdGlUUFlnc2tlZFNyd2ZLa2d1NThBUHI4SW1F?=
 =?utf-8?B?bEg0U1FtRTF0OGx2Q0QrR0hURG90MENVUTVzMGpoZlQ1RTRpUHpwMjhmU29W?=
 =?utf-8?B?NWZuYTdhaUJWK3JLVU9EUWVOeHh4WEIvUkQwZ2hxWkpXcGU3VFRrSmcydVYr?=
 =?utf-8?B?bzZwVHJXUGpKa0ZtMXU4Y1pvTFBycnEvQnFYWXovRllQU01BM2F0V2lHajEw?=
 =?utf-8?B?RGJ2VGtrQVMxYmVyUjBHem43QlhUS1djOFZVNVljVmhZKzlSOVRSM3UzYUZZ?=
 =?utf-8?B?NVB6aTk0c3A3Mzg1NUJ2ZGl1WVQrOEhEYTVGTHVDdmZKT0MvNnZiKzQ2TzIr?=
 =?utf-8?B?RGFXQmp4U1N4bGVsbkJKbldiTVpjR3h4S3poWmthNjkrY1ZjL3M5cm5oSUlM?=
 =?utf-8?B?aTMrM0JZN2JLVlhIUi90VlFvWGRuSHUra2pCYWJ0eEtlTW0vMzBHdStrUXpM?=
 =?utf-8?B?NWNIMEt4QUM2UitsZlA0c29YM0xTeE1IanFRYU5FRU1Dbkl5U3VhUmRpS0hi?=
 =?utf-8?B?YVJ1aXdWdVRBUEdaY3BraEt5cmg5YmdYL2c1b0ppNTNxZFV0aHkwQ1dLWWJL?=
 =?utf-8?B?TmUvRitwd2J5eE11MDVqVmdhRlhVRElndzE4QnA0Uk94dTRkSW5ZNlIrdDZz?=
 =?utf-8?B?S2I2ZDZHNEh4VmJiSVVZNkFjYStXY0J3Q1pWK3BnSisxUTVEQjVnNS95bFlW?=
 =?utf-8?B?aGQ5Mk8wQitXbUQ4NGJ5QkNMTWtGeitsU3NNTnZQREJxMy8zL2RrdXA0Qk95?=
 =?utf-8?B?d3Axa2hoM0psVkVWMXFjaWVqMUJiU1NzMVkwVnlBSUFqb2Yzd2o5MEtxY0l1?=
 =?utf-8?B?ZVgwMlNrVEt4MXdKSG8rajQyNUh6SnRNdDVLZEJLVCtTRUJuRGxkdkVUM0xu?=
 =?utf-8?B?SFZYRFI0SEcvdGRXY2ZaNUNCam14RitFNEg3WHFQVlhzTUV1UmhhUldWUytm?=
 =?utf-8?B?RUVxRXlVQVVJNzk2WVdoOW5tcm55dVJ5OFRtK0paZFhCQkdTRStmMjFaZWNP?=
 =?utf-8?B?V2pmaEdRR3F4UGlnVm8yTnQ0ZlJ3ckxvZHF2WHZFRCt2NllsZ3pGZz09?=
X-Exchange-RoutingPolicyChecked:
	Oo66KclvU60ECR7zPxFX7I+ImzrwfqmWy5neXOZTYBvdNnlp7mnmZYTZhcpdCw/kNeCj8KRuHBqczHK22x+JP+mhhxonX12H7w37D8HqU+JhUfi6dFqbyDaYJ68JUyEstulyoTkXjDtp3czZMDYvWiSRWqBycL9k88KvD5jHBuQLLveIhEBtHQ8IkQ6ylXRsqvHtCpyKqChubvZV/r/ohh58z3viWPHNEIaqd5oagLr9x2aYq8ZsFyxg0xCfqaz/xu5CCjgl+xDHK7ZPQyBMhqmHydhSY9WNZt13u6HEWz0B4gVVUielqbV2HorMXTyPnhbWxqts15PcvjwaX9QNkw==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ff5a91-26c7-44db-2e3c-08deed1f3681
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 03:12:25.2649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9mw5Po6Xk5xcluGiPjvrfizb9D8Gmoqeyh6Tw+n8IFzFxE8NInJpXbxjRVby9sjsDc0LVKMH+WpYibVC3biHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8423
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMiBTYWx0ZWRfX7dyqtKd8zMaL
 9NsoW7Fv3QkrsqC/WB/VQ4gvlI/JtYO3JOljRQFT58F59OhMF4ktQ97FEfcVg9DAspaXPVBLq15
 R2ZLXFGBcI7lP/BJlRd7mq+ogkw90/BQJKftIIGNwRWiHzYaVEnJIMZQzxOzK8NOBAt7AxlLZCv
 TrPLvkkcVSs4IE5rlpHOeFfbRJdyPGJjru4Lv36Wg15xHurCF6ee1L/JXE3kLldkeZDe1TDywDa
 7MwR3C86SNkXpoWJ0od5XMNFcPW+65f7eNA08DSDAJy/sm3ZdbEMJZZX5FaVfrZscOE4qXjBxrq
 DcPV8y8xllaG4CHIQAMOp6fVf8QxL2G2hXVTeAyxFaW5qgRsdhQ6mlKeH8I7zIo0DQsL8GK2Ppz
 kv8tHbckKLI649CBrKgWiMuG23aZ0mmTeCZWmAJgKb+oLADcRFiJGtwuxZdxjK4w8JqZhBrTHMq
 anoPYHZ3sAUMcilFxcQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMiBTYWx0ZWRfX5ZmQm6eNtaoQ
 QPgzI4OpNu2gCOy4fnUvg9+veSz3WQNhaHgmnWFs5o+4SeynBKArUly9gw6Wb7WxJO7Iso4mlxS
 en+Tk9mDmfMSqb975bBNpUEvtvy1+lVqAgNMCcZQS54i5uv/X4v1
X-Authority-Analysis: v=2.4 cv=YdyNIQRf c=1 sm=1 tr=0 ts=6a696fa0 cx=c_pps
 a=2LRq3VT+JIpsXvqoN2bfxg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=XjQXVs14yQyyhyaPRZoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: usEYjf8NxHOXF2xziAlIP-0ZVtct43ax
X-Proofpoint-GUID: usEYjf8NxHOXF2xziAlIP-0ZVtct43ax
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290022

Hi Ted, 
  

  
  

Thanks for the thoughtful suggestion.

On 7/27/26 23:03, Theodore Tso wrote:
> I agree that inline_data feature has been a persistent source of bugs,
> and is relatively minimal for data files.  Howvever, the regular files
> that are small enough to support inline data come really boring filess
> where we're not doing the really stressful things that fsx, fstress,
> syzbot, etc. do to punish the file system.
> 

The "boring file" argument assumes benign workloads. Under adversarial 
conditions (which CVE assignments reflect), any race window is 
exploitable regardless of how unlikely it is under normal use.

> I do think there will be some systems where there might be enough
> small files (especially when the blocksize is 64k, and the inode size
> is larger --- perhaps 4k) where it might be worthwhile to support the
> "boring" inline data files, e.g., small config files, header files
> etc., where the file is written once, and closed, and never modified
> again.
> 

With 64K blocks, the internal fragmentation alone wastes on average 32K 
per file (vs. 2K with 4K blocks).  For a filesystem with n files, the 
extra tail waste is n * 30K. Meanwhile, enlarging the inode (say to 4K) 
wastes m * 3840B for *all* pre-allocated inodes (m > n), used or not.

A system configured to accept this level of space waste for performance 
is unlikely to care about saving one 64K block per small file.  And if 
small files are rare enough to tolerate 64K blocks, inline data benefits 
even fewer files.

> So what if we had a mechanism where we're using delayed allocation, if
> the are no open file descriptor, so races and deadlocks can be
> avoided, and in that case, we can write it as an inline regular data
> file.  Otherwise, we back it using a regular block.  I think this
> would get us 95% of the benefits of inline data files, with much less
> of the complexity cost.
>

This is an interesting approach and could potentially work. That said, 
new mechanisms often introduce new race conditions. Do the minor gains 
truly justify the added complexity? No major distribution enables 
inline_data by default. The feature has been available for 14 years and 
remains opt-in, suggesting the benefit has never been compelling enough 
for general use.

It's not worth introducing new complexity for a feature that has no 
actual users and keeps introducing bugs. However, I am open to 
investigating this further in the hope of finding a good balance.

BR,
Yun
