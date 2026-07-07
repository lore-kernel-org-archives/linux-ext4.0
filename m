Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012000.outbound.protection.outlook.com [40.107.75.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C82DCF57;
	Tue,  7 Jul 2026 07:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783410656; cv=fail; b=faXAYE175rErg7oJXybuq44xY+V7BxBUa8XWP/buUlDp/N9NWTt4qVl67YCA5Ng6EJDHXjUEtpWuorjhXwYXs30nsnM0AEbVkuirmGgC0ZdmpYvJjeF9A4G2mWLMl8Awi/42A7ZeXugM6MbufYj9tdR4eWUg1wmqn/M4dK9AeNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783410656; c=relaxed/simple;
	bh=YTOyBdr9Ey0QzrAhyGXqxxmBKQIFcFrXF1A2ltdEqjw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JNJD2xDDqCt0ckvANvLr+Z7l2ztOLrjGRdOUGzFS+Bx1Ai3h7OhDB92qur+wviqIQQgFx75KyMHTUzVYuVMgQde24uplLP1vBkmN044w69cL9W1HwIY2GI4dsJU0fInhMiTBLyt7nWQf0AZXYOkRjn60O1jdlkf9eHUxyjx8LaY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=dWkv7fQm; arc=fail smtp.client-ip=40.107.75.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="dWkv7fQm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AqRX9bw07ylRU5hJYNRNuSHyCQyYomaOAKzA1AGIQMmgw/4SOkr/AeHZUDg/jQNHVNSy30DMlb6R018cmuSUUXEUAI+BQ7Pz1Fcu6j5a0GnMNNpY1i3000CUEKe6NE1fcJNWjYdWLDfEQ7+KyKQfLTQnU5UHwR/Lewx4Lt8XkpQl5T0aHImE2Jj4VowNMfTD3N415Ki0MdeyUwOJzWBCHyWEPfCwAD5u8vjschiPjXyvNOVUxZHsLKMl7mtkKv8bsnRS0hxuo4Z6SC2HIBfUfQL9eCHJpUM8TkRA7GOe1BQV39Q56VZVm/JBcFs4U0TJiuWK5ykSlRTmrr/WYfJ8XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=90k7MUstpLROtKnBnl8Rwig9rTGPxOoiQs5uKHKAGZs=;
 b=hIgbN1ofG4ZAEoolomSZHebfemtPQESwVMmFPr77lONnMjErewu1qlZqLnDT6XZytjN9Axmlm78+pSwmACHc7xUu/JvizW96EDCPVcGPovVV6lQV6kRO/XYpsZuzhpkU4uC1+LzB9N00NF4qX73coG/sKSLF39Yu3kTilidobfjx/fLGuE8aBC4Vt3Bbuxp2mfBV3JNEYaTXlB6NsnJtpRMlbsQCM4sE2helYWxw8v8w0jy0dNRN82X1zea1CWS+QDa1SdyHwL8MpDB9LAMNM3Swnpnmkvpo9emhtZBIG4v3ciTfbtsKROfxmI3l5sk/5CIgJjXpfCIsYTRNXpTz+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90k7MUstpLROtKnBnl8Rwig9rTGPxOoiQs5uKHKAGZs=;
 b=dWkv7fQm8YEyyMf5g1kOImEwx4Lapts8ASGtsyikLRtSONeJQd4jXRzuAZbW3eycgR1p/UIE29VklTeqnlbFH6nVWZhadcA/dM33YFzo2xXAVt6PI2B/WkSvDXuW1R+tDtQVgf6c+QWWvCrD+c3ipvRJzhLpP4XvsxTSahch9urOomka488PRGZEdaTEIjYfyRR2yoyz/oX+LwDdqt7jG/+Sbpfk2Rg3HEHv5XP3uny+mQJp89L0UVMTJ8DRd+RDrgOXRxUvgHWJ8l77p9GCflN0Ha3Pu/XU+M3ig8ZU7exrGec+WEwCnZXi5TBIKcqKl/kOvSMbGjJliEItxV5AjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com (2603:1096:400:468::6)
 by SE3PR06MB8429.apcprd06.prod.outlook.com (2603:1096:101:329::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 07:50:50 +0000
Received: from TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e]) by TYSPR06MB6921.apcprd06.prod.outlook.com
 ([fe80::ee5b:12c7:2366:cd1e%6]) with mapi id 15.21.0181.010; Tue, 7 Jul 2026
 07:50:50 +0000
Message-ID: <1951feef-5e78-4658-a336-dd2e0372ef49@vivo.com>
Date: Tue, 7 Jul 2026 15:50:43 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] fs: mark selected blocking waits as freezable
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, tytso@mit.edu, jack@suse.com,
 linux-ext4@vger.kernel.org
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
References: <20260527064912.1038-1-daijunbing@vivo.com>
 <177997267385.1024700.10028396434477082299.b4-ty@b4>
From: daijunbing <daijunbing@vivo.com>
In-Reply-To: <177997267385.1024700.10028396434477082299.b4-ty@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To TYSPR06MB6921.apcprd06.prod.outlook.com
 (2603:1096:400:468::6)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYSPR06MB6921:EE_|SE3PR06MB8429:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ee5c2d-4919-4a1a-10ce-08dedbfc74fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|18002099003|22082099003|4133799003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	263V2lGWE27Qkd5QYsjZwOwa7lT/rDiiIAJGg/FWV0vE3TtkPXv5JSnYntjnIIC3aB8xzudGk+O82ozGjNifMkWuSQnw3ZRJsnM1iSyS1Jv7O10P0s8WibgdLWEQLouZEIImqO72ANDuFHKAKaxvYPXSH68dguICOCAY1orxG5CTeCabdXknV5zEvL1niuBsotPj/xXzDAyFs5dm+nI5zEP11cMMjEtnqE5DJW9VfHFQOfZeZRymmRteWthgATWokPvqzHungWA/he0HknAFGgrQNCfw6PWwYlKMamXqOXmluzhQEvGHreXa/K5KFE1K7ck9Vk4JGH8Oj2SSjKcnXy7/cnPf7KKr3npUQ87YodRjCIZ+HSMYgJXj/wulOHME33VuKOsDu12oh0+guYEQ4W8hvAIYX3exRn/Ru/bLVCd4FZrydEY0ZHe4a64zio+eF40yeM7VhEszJZM9O9zhdJaNTNb0cknWaexdocTwfgiXqqXbg6n2G0roit0HKfuo6orIlikoClBw5bBnp+MLeLcd6tLk7kzbzDDvCTh2WE847p0lWhF2jOr7sx7ZQ6T02ews2mmvFqyLBmZQcyJUxoILM/398AukKFt1mKGx6SAsgH705auLWWEsKMSFA4vRs1Yrn3Mla6oends+XcC+Sv0s/V0DHUHqb/khcJjpwFU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR06MB6921.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(18002099003)(22082099003)(4133799003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjFUcGYxcmRQczk5em9PWkdhbXA5VnU4dWdnRnFSNVpZSE1ZV0tIa1p4eFdz?=
 =?utf-8?B?Y2hYVnFHTWI3QWJjM0hXWnZJSUVaMnljbVhpZkl5TWtrNWZIKys4T3R1Y2NK?=
 =?utf-8?B?aXNTTWR5QU4zOEVjRGFlcnVoSEsySzcrM1ZvSGlsWjNVODZkTjkzVWZEQXE4?=
 =?utf-8?B?d2hRdThHd2h3ditqZS81YmVmdmorT054SXlORkFJUEFLQTArWXB3MG5DSVgz?=
 =?utf-8?B?YXRPVkUxWjU3dEF2NHkwVkRuMko0R0JJQk14YUk5cjg3Wit4MHNIQmRBVFc2?=
 =?utf-8?B?Z3JsN2ZQQ0E2WWFqZ0JFdi8rT01wVTU3bVAvN3RESUEyMUJLYUNvaldsZnpy?=
 =?utf-8?B?VHNwR1U0dGZ1SFc0MWhkOC9nQ1dwTmxXb2ZpcXl1YmZha29zWUFZMmxJbHMy?=
 =?utf-8?B?Q3M1N2xKOHRaaFRLUmRaOHlkQ2pWb3U2Y1RITEUrdmlTOTQ3SHN1Ymo1QW50?=
 =?utf-8?B?RkRPemJpdy9LcUtDZng5R2J5cUF5U29adUViWDJGcHp1Qm5GOU9NOHhWcHFr?=
 =?utf-8?B?WGZpWWxpSE5kOExaUHdzSWRYcEdrS244TDRBbm1FbDA5NFpzbm55aTFoL25D?=
 =?utf-8?B?eGNLQm1iWS85RFBtMGZGbVRubFh3bnBpYXFzUzI4YkN0WEZ5TG5QWmdKcnVO?=
 =?utf-8?B?QVdwNDBVbi9vQlB0RkFjVDBWL0ZCVjBXOVI4eVN1MkU2VC94ZU9TSHJFdFdq?=
 =?utf-8?B?cXlETWJ4TTZIM21uMStENmtLdXRySzk0anA1bVZyQUR5Yy81c3EyZ3B3Ly8y?=
 =?utf-8?B?Lzd3aTdQUlZNOVd3dGgrQjZUQ29jbXdZZ0c3di9OTkVDS0tnUkVGdDI4QzM3?=
 =?utf-8?B?amVyMEU1YlhCKytSMEl4SEhSUTJWSzJCcnNJcVBFY05vTnNORk50SjhRb3dN?=
 =?utf-8?B?ZmQxeEUvVUp4alB0ZmVVV2JIdEo2di9BZXlIMkQxRGxISFJBR0VEd1VFWFRx?=
 =?utf-8?B?cDMzWGVqcXdKYnAxUTFVUzA1dUJYMHB1TGxyUFFFSGNvYkdHRk12VkNXeUpr?=
 =?utf-8?B?TXZHZnlnbDk0WjhqZ3Z5RTNzMHlPUzFQb1lXa2lZOHVVQnRaV05zZU5MbVc1?=
 =?utf-8?B?NkQxZmNiSFU0cVVHeWN0YUp6R0NiYW1RVlAzYkVTcVVrUDV1TzBVNXQ1WENY?=
 =?utf-8?B?VUFYM3phdllDSDBvc003Q25tZGMzWmRjSDlpY2RwTWxRMzBqeTNjWFhyUGN6?=
 =?utf-8?B?Ti9acExYTk1RamxKaG52elM2NUI0eG5sQ3JGcUlVeUg1emJsZENjbXlvSHFW?=
 =?utf-8?B?bE5oeXJhMnBkRTJrNTBMdk9Kb24rRmlXU3F5Qk56cXZrYzhGMHpYZ2YzOWJQ?=
 =?utf-8?B?SWdrU3VIVVc1UUdXZ3I2aExNQXN3TlUrZFdQREdmdEN2TnZGWVlMTU5IYXdH?=
 =?utf-8?B?SzdyU3Y1VnpEckY2YXhCVTU3Wi95YzZJdFgvUElUWnhhb3hTMzhDTU5MZnhJ?=
 =?utf-8?B?WHNBcFU1dnhlSnlLL0s0cE1pUVR6REU2d0huaXZKc3FyTHh3U3JzYThUc3l2?=
 =?utf-8?B?bzFJOHZBV3U0MSs2VktMY2Y0YlZ2cXJuVG40T1llUzFWSGxjc3JUOVd0Y05S?=
 =?utf-8?B?Sm1rVER5MlFPa0RCVTBJVFN5MFJWSTFNbCs1dm5vck5TbUEwQVpCNUZqbWln?=
 =?utf-8?B?QXhqTUNlOEZJa1VBbVVkWncrVTlFRXJGYXBqMkRoTHpPYlpxeFUzaWw0WnMw?=
 =?utf-8?B?NjVKK0JxS0dxYWhtUUdLbGZTS1d3ZzVzNlB3Mjdibkp3RDgxVnB4YzhoTTdZ?=
 =?utf-8?B?Z1B5d0Ryc1g0aUIxOVJVNWp2UTg3QXRya25xMXpKYzhBLy9GMDVtc1pzK3Bm?=
 =?utf-8?B?UStMWHB2VUV4TTF6TFBYUndWYU9oenpJc1lkMitvYTZ0aTBTUjAxMDIybk5Y?=
 =?utf-8?B?eEIxWkZEVGpBWkJWSlFsNVNFQWl3OW14WjVhMnJXbDRhSG03MEdSaWFzV2lS?=
 =?utf-8?B?MkVCQ042OUYreHhEOVVSd3JCeVlHWmxING1IeFpJcUM1a091YnlGWFdOTXcv?=
 =?utf-8?B?Y3RDaTVmWi9IS3B5MW1GZ0VwMXFvcGQ4TllKRlhkSTFSU3hQQ0pXRG41dUFp?=
 =?utf-8?B?SEE4b1pPSmV2emQ0RE1OWDdaRHRJajVpOXNVcHZ6UjMzZnNiM3hmbkY1K3Jo?=
 =?utf-8?B?OU1Qc3BLcXVyMUhZNGtMUjkyb09CR3ZQNnRJU2dFTk1Cd0pLeXdGK1hhOGx6?=
 =?utf-8?B?Z3NPZld4N0xsVjFjaW5UcndDaUozRUk0MDE2ajdzV3RPWGhCRXF3QXYvT2hw?=
 =?utf-8?B?dHdHaDdDRTFEV0VBdWsrdWRCWTBBNHQxbXMyNVVNVmtlTGlUb1Evbnk0QkUx?=
 =?utf-8?B?YW5JREsxWW9MWHh0WTNESm1US0l6cnVsalFEWUV5cmRaWVhva3J2UT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ee5c2d-4919-4a1a-10ce-08dedbfc74fa
X-MS-Exchange-CrossTenant-AuthSource: TYSPR06MB6921.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 07:50:49.9595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwsxxitiafUMOPsHohYl+7xHp2Dc7AeG5s5DjHJunkK4QWsPvaM1ETYT7oWMls19owLA2p7VNc5DE8WXc0K/cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR06MB8429

Hi:

I noticed this series had previously been applied to vfs-7.2.misc, but I 
can no longer find it in the current vfs tree or in linux-next.

Could you please let me know whether the series was dropped, rebased 
into different commits, or moved to another branch? If a respin is 
needed, please let me know.

Thanks.


在 2026/5/28 20:51, Christian Brauner 写道:
> On Wed, 27 May 2026 14:49:08 +0800, Dai Junbing wrote:
>> fs: mark selected blocking waits as freezable
>>
>> Hi,
>>
>> During suspend and resume, tasks blocked in some interruptible wait
>> paths may be unnecessarily woken due to freezer state transitions. This
>> can introduce avoidable activity in the suspend/resume path.
>>
>> [...]
> 
> Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
> Patches in the vfs-7.2.misc branch should appear in linux-next soon.
> 
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
> 
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
> 
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-7.2.misc
> 
> [1/4] eventpoll: mark ep_poll() sleep as freezable
>        https://git.kernel.org/vfs/vfs/c/f5437433c37d
> [2/4] jbd2: make kjournald2 commit wait freezable
>        https://git.kernel.org/vfs/vfs/c/10c6b259fb56
> [3/4] pipe: mark blocking pipe read and FIFO open sleeps as freezable
>        https://git.kernel.org/vfs/vfs/c/6e5e03a76bee
> [4/4] select: make select() and poll() waits freezable
>        https://git.kernel.org/vfs/vfs/c/f837c1dbd121
> 

