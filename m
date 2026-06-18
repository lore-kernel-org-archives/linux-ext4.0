Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335FF40D56D;
	Thu, 18 Jun 2026 01:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781744607; cv=fail; b=c2bT1SZnNdACntWLvxQmqaFIWv48IvJEsQj3QkRrh6uIlTvCkDs/maZumLvwzjD8ldrKYNg3/FQ/FzltPD+wOSIacWBJ2atAPsA6UU06/XAaalb2xIdfcj1mKJyteWN12RLwN5RxLaE87YOLlgj4YAo8lPG2cetFo24+Odl7JTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781744607; c=relaxed/simple;
	bh=siISPltdbSwbuBAQhTUyjrAxfos6YFSu1ftbTcO4gow=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QHfqNF+/qtWg6qRRViQRozqhUvQ5YQNmlITrn0WPvfTpdmmP0uv4K9yuO9/LtMBAjbSAVPYb/e1M0pASczyZEvsh1cdhsHHZfwhNYy19TzmwOHR1ISjFAiQ1qfAIDbb6b28uZox/iO0muWXKwVyQ6lyy6XE4Mov6kCx9KkhFveA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=n6j2MTSg; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="n6j2MTSg"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65I0fk0n2944073;
	Thu, 18 Jun 2026 01:02:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=HBTKWm0fu1eo0lRn5jGvPOCJjK5AfFHJtd86oWiXQVc=; b=
	n6j2MTSg7btLihb3ppsBHdMfCE3z0cRFWLKGgyfBWxrXyHQcY1fURHl26NJmfQfa
	pjcOfGkr3+cYFFm0ZWRhw3b31b3QMxZSC2cAnkNcrBIDnT3uHuSB4jZopIH5uzUY
	LCJ5CT3OZTC/ozYDn4w6UEE8ycwqaXx3SCdW74V6iz4yBq8TCkDh3z0mofrDtsqK
	WO80MggY0m3iJvzTR++lwmk4c+V5EohEgq/EeNHmCCO0Gsel7bs8TKKNwxq2kn3S
	VSkdSPGIKJyyiqA4Jpb46JZwSDpuq1cGn51up/KwUaKY2Fn8kstOE4Pzh7k50/RK
	8dV4BBqsco7FWkiDoabGGw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013027.outbound.protection.outlook.com [40.107.201.27])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4euefc1y86-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 01:02:23 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=awoAkQRjjvNk+YgiO5InZxn5QQTFFLScmdVRwExmHZSkzExyX0DuZEVhpmgafwWrQR8LxV53sxYd1U69st651KwPRxxAwkhZ/GEB0RzGSlzz7gMqQ/YUwDs8E4omBvuDvtsBXqJ+g+jOGUuGBDDlHOHFSF6i6IJZjR9nWAoWb1EqeN/xO2pYEJyYg+Ftigq06zGh3Veh2BiZx3d9QfbJLTXgbR9v62CBID6dQiCvxk6M315807OgxUxSqK/WhGcg96Gd9K5CgsRcNP5HGtuuzd3CUSUiWoFwjGVR+FfwkICEVxQ4uaO734fe4fZq/F4RCSmssrqx33viX1xRtA6x6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBTKWm0fu1eo0lRn5jGvPOCJjK5AfFHJtd86oWiXQVc=;
 b=RA4DKz0gqrTQyHDGWkRiPtmxLz2qcVmAc6bNu2UN92mQCy1Yl6fH3vssAhdnQ5bBB4CtAogTWkK8N61abauX5xKNdLSn5EtcVg0u5pkqxG7MDXedzw46l05MGzEnGtVS6EVJn8BLLxQex9/ClhR/7iXAmu9zYfb7+NCl8tqt/bGa1hdy/JRV+3sHYN+WLGQn2IeSrMFy3c90A/5A8+qz4l+Sgj4fblaTkZcv9gP8gYVDqPScaowX+r9aYbNxUtA2NMsLq9tFEY9sJu4gSKOtbymJYpZfDJPb3tFYJ5VXmW89nQaQBnVBjVJofndxp3N3M5Td60t+KLiPOnZfIMswBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA4PR11MB9035.namprd11.prod.outlook.com (2603:10b6:208:55e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.12; Thu, 18 Jun
 2026 01:02:18 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 01:02:18 +0000
Message-ID: <ee05e46d-6ec8-4291-a61e-213812934da3@windriver.com>
Date: Thu, 18 Jun 2026 09:02:10 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] ext4: validate EA inode i_nlink in
 ext4_xattr_inode_iget
To: Jan Kara <jack@suse.cz>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
        ebiggers@google.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260615053512.1315992-1-yun.zhou@windriver.com>
 <xzd6pbxhxxwf3ngj5v5pz2ilhykh7vsegohe6iwfkfytfuuv4o@5obqeoc5wocr>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <xzd6pbxhxxwf3ngj5v5pz2ilhykh7vsegohe6iwfkfytfuuv4o@5obqeoc5wocr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0150.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::16) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA4PR11MB9035:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d8ccc4b-92e2-447c-b53c-08deccd53e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|56012099006|11063799006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	l7bKEuX7VJJpIa3lv8XMzZNLKdan3tVbUd0i+4KutMho0xzn/4cC7eNfdjL6TaZG9benbQM/BPm9CO/MtEOl0oU+L973W4YFUiMO+SIaj5ariO8ATGthhdwiVxy/k7mdW15FweJuGYqncwP80ZlP1LsvwswR1WD/A0LSGJ+z7ExFUA0vNG4ElO8KKeOBcP4+Q+wlO7oI7PXPtzlVnVU0XKqFiEamcoFKL72Vj8Tdu87m15+HwEMYsCUJhNvZVpkaicHuu2NBdk2v/RW7vgWqlZzhBpXjdHMYhC0bq5Qd+HZEr6i0aRoEAxtnxw54Q6wfSZibv9UH5WGGoqE0jno+7MASG1ry0C7STYBYWKOX6Q53KZS5FH23BL6Z8C+nqe+SShXksh+OXHh6ye9mLHpKeJMt05WFyaC9ZwNTLad98+4vdvGZJBJ0syHhhSo2PsSJSjfVtF+4MzZv9n0NofQK0NZ001fOqmgMVZczCJQY9GDwkSFQLvLZc+NT2tzPj1g8VxOfC6EewS08cqElbfK0+ZsIaWJNprEuUqOLgoK/Umm39rvOzDNIPC9S2IcaaSPzMP+rw0JyZ8Cl34FqhHP++c/cCU8ApndgHpLvyndy/6USqJAeRpGyO7uML44GWei4u6swptCsjJjdsdhabG2iUojdk1XQuSObREsx2/Y9UB2MS1IFzThBThUFsRp4uCPu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uzg3R1ZCTjYwaDhucmJhWHlrbXpzM1c5UjJmdGVxWEtGdkRtREp6eVFzZmJ5?=
 =?utf-8?B?cW50WHp6OXFtbGFFVDlXR0tLdjlyTlhiNmtPQkxyWEwrczZsYXkrN1IwazlK?=
 =?utf-8?B?ZFd0SGRSdW9BVzJwOEs0cjcwd0x1em5CMUxGRGYrQTRqY0xtamlQMTZjLzRn?=
 =?utf-8?B?TTdRTEJUVm5XRVNlSXUrUExDd0Y3OXgzaW04NitveTJ1SDdjaGpLUVlxNHpq?=
 =?utf-8?B?M1lVckRjYXVMbkFqMCtwS3dGY0FOQ29YWXljRkJQVS9BTEh0djR3MGwvc1RH?=
 =?utf-8?B?eUJkZE14R2traVlTbkxBY0lkY2RMSzdJM3lkelVMNmM0NlVlY1N0cllMWm94?=
 =?utf-8?B?Z2lkQ0w0NTZKVXRYa1hHaFZZVzdON0FVN09wdzBhRm16MlRRdTk4MHFIK25i?=
 =?utf-8?B?Myt5QWlxT3dMZWZTaTNsdXZ5elFWV0xwbnlNVm8xMXVYVndPakxBK1lESXp4?=
 =?utf-8?B?eUpjZDZtakFaOUthdXlFQUtWM0xkYWJUbVIvL2hVK3JiempKL0pzWnZJd041?=
 =?utf-8?B?K3RReC9UY0xhcGorUjhJOERFM1A4K2xwdS9vakdoeU91d0pVbS9XTWJtM3dY?=
 =?utf-8?B?NStEZzJRdlVVT20vRDBLRjNyT256VmlScm42VWdPaEtYYy94WWU3ZnoxejMw?=
 =?utf-8?B?Y3pYbitjY0ZpcmhveVplaDg0NjZMRTVjQUFLOHhJUHJQSEw2N3dmWmFkVFZL?=
 =?utf-8?B?TnZuZVk3Nk50RVdCaWg4Q3VYQVBDa1VDbTkvalV4WWdheC83Yk9lU0s4aXFU?=
 =?utf-8?B?dGwvQVJxS1Q3Vk5PRzZySDhtQkdrcFRDWFJKVkJYcmdTOVBoanFPZlFQVUx6?=
 =?utf-8?B?WHZzREQrNXdaMjdhZFB0SThsVHBUaFN2eUg0YndMd21vNU52U3lkQ29nZTdI?=
 =?utf-8?B?SFNjd3NTenh1L01jZEtrYU4zY1BoZUJCNS96bG9GdHRrajNhQVRKb2dIZCtB?=
 =?utf-8?B?azl5dzJzL3FUZzh2YmdYZ09VYkZvTXd6Q3ZkWkJES003dWZMSjJIM3Y1SzFY?=
 =?utf-8?B?OU1PRWV2YTkrK3VIR09vMGcvWUF5dTcvMmg4aFVyR2xKRUJySkhvWldtQjYx?=
 =?utf-8?B?WFRtMTc4a2tBUk1CcEtmNk85d3I3cFl3TVA5S0ZJbGx4UkdPeGcvemY0Ly9z?=
 =?utf-8?B?TDlGdVR5SEhJTDNyeU9OUDFjNWtXNlpKVUVwbTlmYUQ1VGt2RmZDNGo0dk9r?=
 =?utf-8?B?c0dvZmdrRmxpbWxyS3NvbW1lQ2hWZkhMaXNqcWd6UWhmbEFueDY4NFgwREtL?=
 =?utf-8?B?T2E5TVhycERnMzZxZ1VtNmp6Vjkvb2xvVHUyVVFKZzlrMW8vWFFKY1VOUUx3?=
 =?utf-8?B?bG9RSTk4S3hiWEZJSDA4cFZJMmFkZG4zckJ1UzZZTnA2TFlqVGJkQXYzTjBL?=
 =?utf-8?B?UWdZbitLbGNvVUlwaitjUFI5RTMyaWZMejg2TmFuNzAvUzg3N21RdnBYUERq?=
 =?utf-8?B?UlM1MTNvQUJ5b09QMEhzalhRc1hYZmVOTWZpUEVvUnUwZ1JDQkxEeWFxc0xl?=
 =?utf-8?B?UlJoTUVNa3oxK2ZVYVp0eWpNRlNZNTZPWVpRZSsybEZxVFVFWVZBUk9RUURH?=
 =?utf-8?B?ZnNPRE16bW1vOGJWdTVVNkZQMEdPK210U2h1YkJTYXVZNzVkcTJOTWNvVkYz?=
 =?utf-8?B?dmpPZjJRKzArQ2lZMzlqN1JPNFJrSHkyNU1XeSsxWHVNd1phbnVXOXFWMHNj?=
 =?utf-8?B?Zkc5VVVxV0pod3Z6UGk5OEhhQTl6WHA5ckZmdGplRzZwejRvUEdkTTF4MmRa?=
 =?utf-8?B?T2l4a1JYaEJWUDlySU5oMU92TWdxMW9td1RGYVc5bHJMdmFqeEFHaTNGdGdY?=
 =?utf-8?B?L3VrTlhOWkdjQTl4Uk5jTUo4L01pVHgraXJURzgza0RDZ29VenorVk0zV01S?=
 =?utf-8?B?TUdkQU95T2lKSWRvRGt0Rm1CUHVYcnczTlFVUC9CNGkzQVBDdG8zd09vVjlv?=
 =?utf-8?B?a0wydHpwVkxtU2xqYlIxbTNwaUtIeTM5bEdrVmd5Yitxd0hSWUlKMkk3MDcx?=
 =?utf-8?B?cWdhbGZCbWxMUVpNdldudE94SHhacmk2cWJIejBLY0ZCTjBreGhrYVl2b0Fu?=
 =?utf-8?B?eHVSMVBGUW83bnhXVnB0OGRhL253WHFNSzAwaEQybkdRbjJyS21DUnFqN2Rh?=
 =?utf-8?B?U2FqbklWQ2dqTXRwSExHY3g2TFhhaU8vZUZ2aDFla0FwSHFFTjlSNjdKaE5W?=
 =?utf-8?B?MksrRGJJYUhoQTd1L2lEMWd6ck5GS3BpTzU3eVpnS1RFN1pCWENua1VNYm9y?=
 =?utf-8?B?RzJxSHJKb2tib2RobEJrUTQvRkdtQVphdU5VeDNGQ3l4K29KZ2NlRkZrY3VW?=
 =?utf-8?B?WHA3bWplcDZjaG5TMmx4SHozaUFXU1ExK2JmNVJ1b0wxMnlRaVh2QT09?=
X-Exchange-RoutingPolicyChecked:
	NwuuzNxElrDocwY33cAopZWT8GqHoGtWZ+vLCmMgNTZCwqZlmcvLQehuJZ/6D3L4AJo2ALMkDAawk+W6a3BcHLqoKXNc9S5Fgj7tMxIsHcCSOFe+NOqzghOm3NUeQsCl8CRF4dxOjqeQu1zeZEzeFxLf4PfOFnLTXioNZkXyZcBqILDo9aKCL77RODZ7K8TvnNuO582NQvp/rAE+JeuRNvXcuQ3SMV2WMaWDcRWOuaO4eEHRQlw4Pohx1MvfOCK7x+MKVJiY0yfjkJWVXXto+Br0knNckZmQVXE01lCmU59u0R2i9B7TuIYlbfehtjlmI042RFdh4BY/xz9vf03dqg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8ccc4b-92e2-447c-b53c-08deccd53e52
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 01:02:18.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3j+QB8TnAAW967ZGPeLcvrel0IAEGZMQFDMRzhcU/6lQZyH7n3punTIhiZ38WAQRRxqxM7AIV02JlYJoP6ssrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9035
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDAwNyBTYWx0ZWRfX+pehPgQ+QxSs
 rWalh7losxZYDjhHzWmGHZEDxsGOudoqQ3LcnBl2u2PawKecTUcAvf3K1+XxqjhlHrB3fkDU0Cg
 9KOzkU9KColokbS0JACjYwZPuofSc7twaexQYnh6Rjchf/8jZAy/
X-Proofpoint-GUID: _QyTGBobj5f-Iq-LXMV6AeKBcPKD2EqU
X-Proofpoint-ORIG-GUID: _QyTGBobj5f-Iq-LXMV6AeKBcPKD2EqU
X-Authority-Analysis: v=2.4 cv=ObGoyBTY c=1 sm=1 tr=0 ts=6a33439f cx=c_pps
 a=KTU/bV3Cu5xqMUx6SKv27w==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=Q0pTk6tcEJjPcLLv9bQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDAwNyBTYWx0ZWRfX//UWV6xRfaKt
 8WhHY7YneWIROS6v7la3abFxpazjltvb/0h/vr7e3Ax0z73Oa61LWp9aJ+wXp0yoPuPThYl+a+T
 mTGVnSIlFDKN5z3P4Qt/PLfantW1KUSVOC3WWTR/DP040K1OhqkIgKUqnu+1Epe+U4UvDC/Srg1
 jxS5eKLLwQvEljrzFG4GVnalMvQthogmtMnDRsbcR2NHxsXDoR6RkzN4rsva1gPU8bKYQsFi1M/
 gBD17dCKndax1tyydwWBkQw+u2rvrgJV/RfnguaKZCvi5yCEgA+ZJfN4vMPxPXI/m0KU2adN5HK
 SG5hsETWXHbanOr4u0Ft+zd98hdw6DzNN5pRItESkVh/NP9G2utrzNfNUGvW42y1DC7fLNW2xRh
 w5rIxgHVon6qlKSC6Q0zj2ymhMHBZnX+tN6oAjVwUuzr/AcfezPtSIgboKzPuG61nr3pcrUg5lj
 s9xAO7sGfQBoVciYYAA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606180007



On 6/18/26 04:25, Jan Kara wrote:
> On Mon 15-06-26 13:35:12, Yun Zhou wrote:
>
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -464,6 +464,33 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
>                inode_unlock(inode);
>        }
>
> +     /*
> +      * Since this function resolves references from active xattr entries,
> +      * the EA inode must be in active state (i_nlink=1, ref_count>0).
> +      * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
> +      * (inconsistent with an active entry) all indicate corruption or
> +      * a concurrent last-reference drop.
> +      */
> +     if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
> +             ext4_error(parent->i_sb,
> +                        "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
> +                        ea_ino, inode->i_nlink,
> +                        ext4_xattr_inode_get_ref(inode));
> Hum, given motivation of this is syzbot corrupted fs image, I'd just put
> check in ext4_iget() verifying ext4_xattr_inode_get_ref() is > 0 and be
> done with it. Much simpler and catches at least the obvious cases. The
> consistency of xattr refcount and i_nlink is otherwise guarded by
> ext4_xattr_inode_update_ref() and it can never be perfect as in the kernel
> we don't have the full view of the filesystem and so cannot ascertain that
> xattr ref count matches reality...
>
Thanks very much for your review and suggestions, The issue should be easily
fixed after "introduce ext4_put_ea_inode() for safe deferred iput" 
merged. Just
need to defer iput() and no longer to make inode bad.
