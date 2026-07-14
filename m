Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A695358367;
	Tue, 14 Jul 2026 05:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784008570; cv=fail; b=HQmVRCsyl30Ll/La7BOHw4jHf9T9egje2aDGQaAQU2aGw153hejc/t1s0TykfpG4IVxS1q/McVQd/n32hHJbYSkZ1/sM8RB4KuEtq9eXiJuH/qj1NNB50xmQBMPO2MXu3ShV3x/IN8OdXiCGv0ISmUfIIVEgD9eb1VCmhp0irk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784008570; c=relaxed/simple;
	bh=T2Zc6g/RS/nCGWc/kpVeI/iEL9M5taR3s+2ZPZaMtQ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DE9C1psj3hrkcDzUAqlths7xb8QN7+n782e6QPPMpRfPZSnfmresmtommSnh7vmhFhs9dwVB7O695erSkxthtayeAhXJiLkBohhc252s7u9XtmfJa5FN2MyrleqZ+mAFafj6XpVyRDP+VGrircSYip0bMG7xIKTR1xAkN/Rb9oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=Eju/+Wk3; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="Eju/+Wk3"
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E4ZH7k1319592;
	Tue, 14 Jul 2026 05:55:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=g3MZyShzpRmIs4Aono/UWjr8+Xe5sLWZ7V5GdyUMSOM=; b=
	Eju/+Wk3jnI7mZ70GNBrJrAOnRfXPDIRvfwdYUAltRh43eUkCSfvKT90UOK2wVdh
	llykp1DGPiPRFbRQ48HH/2+93INDfZGOdmsZYVJXl3nZsmqhdbLwxJRD9YoK1FIm
	bXOtpGJL775JJYnY1z4Aujc3pxsPN2VFc1HVz8TZEMB+lk0/FEJvT3RWJUNaeny9
	PgeK85MG4G2256n8+tUaMgI0wmyX23GG8jeuyZwGAp8ybDuzXY/bpuVMpPbhsbCD
	5eJOH0e82nI//Veli70UBXJKUfBIpQCwWQC7zHKqgOgZpLgh1S2+dWasMvkDfVc6
	JgOU5DPuqd7v+o/IU8Pa6w==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012044.outbound.protection.outlook.com [52.101.48.44])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4fbcpn3mem-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 05:55:28 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ytnekiuwyPC3lwrFb/7gEQovRgjWXfgODMMmJJwShsuzDBaOPswKwfuWPVmConsvn7mYr3PwGHMhFLEGCUkAoY20x+5GkNSJMm5rmNA5XonEdD+tpkpZBXQQHOb+EbcyEOk09unXpUIV8FXl0e0ZLTCnbTfD5QTzwbflzuEv29FFwkeu3at6cxoQVYXXGVHSEzRwCgFRM1z3z1h7xKn2dENbAkHV8zw1GX+l5tYyp0+2s4mpqJN5oq2Whk5n4I/bcs4VC5kn+M4onHvdtCofcgeDdp0mUCttrD7yAOEM1MqeNzCkFk7bE1sGsKqGq/tDSccysKMop9IhBN0Aqi8UnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g3MZyShzpRmIs4Aono/UWjr8+Xe5sLWZ7V5GdyUMSOM=;
 b=pl9KEcvJcvIRagKtNiGL665a0aKbdB3fNrAjP/PTNAli+2Lxhoaij6fuZDRjaKCIhsRoVXVKoQSzxZES8qk6IzcdheS6LvaClKEjMrZ15aeZyMW4quw+e7BhEEIry3Oi9UcS+sLeEYQFzoPXZz0Su5phiCdZxawVZBwP9CqKKzmwzxmcFCArLtHaYU6fFhGha+M2R72kTmmK1cC9A8ZCv3NyyYgGnaBRQ8K9yeB5m74Pih63IY+cknqoDsvw9X4nhuH9KJ4Z7itoI9CD0zrJ44Dw+16Bo2dazUBRxFm6Z2ZGJSCgYYtqSjGsNgH4cRgEj1nKMYm+ZvkLAv/DW1PIGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by PH3PPFE994B740C.namprd11.prod.outlook.com (2603:10b6:518:1::d5b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 05:55:24 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 05:55:24 +0000
Message-ID: <c4fbe1ad-0a8e-490a-824f-ca7ac8aa5fbf@windriver.com>
Date: Tue, 14 Jul 2026 13:55:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        yi.zhang@huawei.com, ebiggers@google.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4P286CA0106.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:380::10) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|PH3PPFE994B740C:EE_
X-MS-Office365-Filtering-Correlation-Id: d5704182-9129-4db7-673e-08dee16c7f4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Lh/fLMI6gew7Wmj7/tz/vrJYw5bZSW5Q8PxsepFGY1FsJeNqwGKacQxGfg2u8x2Us5B2f0INn9xQS3moXVejCuK6aSnNgga+XCY75t6bNt00huV+fzg9Pi4oF090uV4Q4uW9pau/fh9JgViTJK8gfxGWSTlQpSp1VOy9suGfMLu9Rxfj8mMDsJa8BCJuncrYenX1ziQ6sWv8gYnztFPR7mVkApkSCCMUv0Yw70rYuKQYHwH9fRbLjnTfLqaQuosrpwjzXT9f4aaCEC8TG08cl7YQgzLsZA/R7Q2cQC8R01C3VQskmj+MvngpXd8PGlb2hZ98y+Haa68G7JcB/OeIVzL5TP4toMg/pySlto+0nStlTy8Rp0hbPjnQbpnw+5mslou8WQv5/aRTsxEAJbB5Jsfn5eM4RuZi2zQSENDo632YRMG8L7wvFyEwH6jEpvfsnifqgPNkQ+bk5+tELdqdtdjmwfCWF1150FUOzqf+JM7Tnsq7tJeptbANURFCbAww2aRACd+rkM/3cCZPZv0k3qB9H6DvRgfPBo36iBJCbFu/9q/H9e6xqI/lP9jfRPRCA+4XW9NFFEtgcfHOjTjrhgc7DKq7kP+nXJ6aPigTHu3aINqkGC6EBv4xLQiyl/zc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU1leFhMaVI5ZmxyR29TRzRVWlNISkptcEJoMkQ5S3hFbUpBMEtQMkFqNElN?=
 =?utf-8?B?VlQvRkFTWE9iWm5zKzQ4UmphWGZoTnZ6Y21FU3B1OVpjSTdBdnNTbFFtMnIy?=
 =?utf-8?B?Rjc5cDd4S2hnUU9lZkhRVkVMRUpwWkVINDBaaDBFZkRxYU90QjJLbldGQ3ZK?=
 =?utf-8?B?endsYWVnTTF6dlQ2b1c0M0ZzU21BOHM4MEo1ZXpFdGZ4eVUvbnNLMmZBeHdU?=
 =?utf-8?B?T2ZEcmorN2h1NWJaTndJVWtCanBtYkw3V0ptdWd4dFJMN01RVGFKdXpRb3o3?=
 =?utf-8?B?V05UdmRRdFFhZDFlU1UxaWU5VFc5NUVLamNiV2QvV1RNc0s2T0xLci9CU0JT?=
 =?utf-8?B?NmVPZ1YxbU1tY3JmaDJ2eUgvZ3UwZG1JMThnSmc2Q3VqZG1BZ21NLzdKQ1dF?=
 =?utf-8?B?b2toM3ZaMkNMS0Nidks4WGczSTRIUVk0UExqTEVvVEF6aW9BL3p2MEx1Z2tC?=
 =?utf-8?B?N2JhU3NGcElyWmdHb2NMdS9ST2MvTGdMQ0lMZ3MvNGppQ2JuYmhaK05IRnox?=
 =?utf-8?B?elVXUDcrYmdoRS9SbGFjUFZ1dGdRSHlpRU5Rdit3bjlmTlF6WkhtT3ZYSUVx?=
 =?utf-8?B?Ni8yY0FKMVczbHZqUlZhOWJzYkJ0VjZNa1ZMSDZOMXptZElQQ0dQTTZHK0tM?=
 =?utf-8?B?YXpPVnY4eVZXckVPSGNOQytxSmJoc0VzZ29odjByOWJKRHhZYTRHN1F0Y3V3?=
 =?utf-8?B?M0IrR1FzbE1uQ2VpREhDSWVwYWFqbnBtQ09EbzlnMnlrWWpyYlgwYXhiYzdT?=
 =?utf-8?B?Y1RDTWdDODBKdjhsdE4raVZreFZpeDM3SmRZZEZEMXo3bWlkTDdkcnR6TUVP?=
 =?utf-8?B?WS80NW53VnJ5RnhuaXEwNEpYV2tzWU01SFhHb1NCSjZSbmpyVUlnNHUzQ2Jw?=
 =?utf-8?B?VWtmeGxNOW10R2NmZnhMTEFTaEY0Yzdpb3RxQlpCZHFibUZFU2hLRHJyelpy?=
 =?utf-8?B?bkFMYjA3c1FOb0RpU0Roa1A5bU5JdHhSdWRJdTNrRFBEVTRKREpWYXdGOGly?=
 =?utf-8?B?SmZtVzdyNlNydzQ5N1NtM1g3bFJ6UnE3SE1PNDczazBwNlIrajlnN0xiblpn?=
 =?utf-8?B?RmRHQjRFUFdGN2sydlQ1YTlCa3ZaZGZ0emlqTng1akljNTJVazN4Q0R5T00v?=
 =?utf-8?B?UUZ6V20rTmpwVjlhbzUwSTkvMDFPTG4zaU9jNmZqRHlrY2JybDZJV1RzRm1r?=
 =?utf-8?B?cFpZajMzMGdSTVUzbjJKMUo5OVhvaUtkMk9wbmRFcFp5ZUppM2xBeGJhVGdw?=
 =?utf-8?B?MEUzSVk2MEZpaGNIVmljYWg4OWZnM21seVFHQ1pwQ01xbUFBSGlJSzJoOTFw?=
 =?utf-8?B?cWJPczE3UFYrTlNnR2pBM0lpZCtDVTdnQ3kxTFVLWEoyZi9xOUNzWEhsNmZh?=
 =?utf-8?B?NXk2ZmFFQlRjMTViSnEzenNQMUxkVzFGL2ZRQTFFT1pldDl3d0tXcU80TUtw?=
 =?utf-8?B?dEJHc2JQZkFQWm9ITENwRmprSWhDRU9ZcDdIa3dYRG1aWVRDRjNWbWdMYzM4?=
 =?utf-8?B?N1ZOQ1Zqc3NqTWthTkFQWm9wUjRySXg3Z05WVmMyRzJ2RTN3ODNqaGJKK1BH?=
 =?utf-8?B?V2VxQTZUTkVFYjJxejFjOUthN1lTVllUZGpjcEZacnNZcE41REExNFhvUUZY?=
 =?utf-8?B?NkdZSWQxc09IRkY2YU5NcW9DRkdqRktaMVdzYm5RS0dLTFBJbGtxSmQwN0pT?=
 =?utf-8?B?YmlpOCtFdUlLUzB1MVFqVlBHeFhuNzlrbC8zeEI3L1ZSNXNoUVQyNE9ycnEy?=
 =?utf-8?B?ajUvQ2VPN1EzZWZSUjJsTjlTaXBKYWpHYmdUTVJzT1NHeFhvbWxzdjJ5eksv?=
 =?utf-8?B?VDgzYU14L3krZXc3UTJPVFRLaHRWZ2s1RXdoMUoxdmpQWGptSGtET2t4V3h1?=
 =?utf-8?B?RzJYTHg5L2dGQ1NUcExTRnFuSXRlbk5xbGNaa1Uwc3NtRnZGczlUdERWdXV1?=
 =?utf-8?B?MkhYVkZ0V2E0M3M1cWI1bXhScnBwNVp2RThRU2pJVVBFaG9NWExMOHdNNlFE?=
 =?utf-8?B?VmpFNnhqZVMvZEJ1cE9pdlVnaDEzSTZQU0YzS29FYzdqUHkralV2dEc1bDBi?=
 =?utf-8?B?bVkrRzhPQXRScHdsVnlsNjZlZm5pTURka0JlK0I3S2ZNN1VacVVQNVFEc1pp?=
 =?utf-8?B?dEVrQXNPVnJkcnZWaFo3eEJMSElQd2RPWm4zR0dzd1NIaHNGbncrWUNQVWZK?=
 =?utf-8?B?UWI0WHNyQ1pWcXRIUm5MaDZrQmNTdmNnTjBkdTB1SlltdTNqcnJ3Q3htLzJw?=
 =?utf-8?B?MVMvZEo5ZWFGVFZ5MEFRaW5adTYySlZseXVRVHkyVjluYnBnM2pnN1FGY3Zv?=
 =?utf-8?B?QmpoNUtndFdycnYxS2w1WjRJK3h6WVVFa0VpUUhPUE9xKzY3UlFrdz09?=
X-Exchange-RoutingPolicyChecked:
	C8ytUglqs9VjD0jjLMeSdG6eS9Cz3efd9qglNbRP0bcHcC3n2IWv2voMH8wUNCrTWHo5UxVsHPBWm8PDdEoMhNFyXzdO8b1rMCd9jT+D9NZILVFQMjKtS1zbiVXL9q9vOEU5HGUP0DMgXJENoSACAIBbA4CAhnUiBok0uedtsxBF1dg41rWm6ngBIqpTOY+P/jc0/mjngz4udEkxLu2pR0R7jG6hh2p/7a1eNkjd7elFV4pAjNHvb9OTORhChWmq+Q/L7OGoLNJmeCgdoLhYIDydt+J9SHjxqxbQVHsUTPLEjUUbHLuLvatjjbmrCDn0VSD9Zi+fd6gxdUP/PTdMvA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5704182-9129-4db7-673e-08dee16c7f4d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 05:55:24.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRwcVVrnvELSZzk5PKlXKyBnjEBM5D1m/X2GIawuxH1lt71gnTjf6khMxfnlAcLn+SS5bRXE1v3dFj8kHBHx1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE994B740C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDA1OSBTYWx0ZWRfXyogx66oNCOf4
 ogKeddAC/flHAD6vOks1HWkQkNhene7o9ewEr8m7JyFWRWZ+aEAE4r64uHRyUypw0aDhjY/Dhuu
 3F/W3HwLm91zu8kCGVzaOe7cw2y9wcH8Vgqzlc4ON4YJHwdxHTJIAYhz4kVd9SSAC0kjWWZyZ7Q
 zrksu57+rRUb3NKlim7yBtMloht9bxtBKbIndLjmEoHL0p/znuX55WLpseU4tbqkE5cw3veAq/T
 3kvGtPMuPlWJnPD6yQ/c0t0gNUbLsI3qpNb76TmU2S+mnzRAwAdw3xIOk1H7XXekRT6eiIUjDyp
 ZN49/PGmI2l1Tv74uNzjVqyQZKD/YkuD2BY81g7vaOpJL/dQ30pwNrtTbF1v/XImlPXqitN9wva
 LmEuag/VsPZHOtwjZCyrCwUYucQid1FAGxHfLCbHh7DKOCCxRp7BzCHei6sKW2pQ7tB/MCN6hu6
 hOUXCnfgpkIU22WSivw==
X-Proofpoint-GUID: 0WOzBsCDVhZe7xtHkSNzal9rEkYuUm21
X-Proofpoint-ORIG-GUID: 0WOzBsCDVhZe7xtHkSNzal9rEkYuUm21
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDA1OSBTYWx0ZWRfXzrDka0Pl9sWI
 lVZlAFqz05lEeuBUdsJqSJY0C5JiG41lUVGrUZRSR3jwRI+fSKmEc/QOoYIcmQZ2GVnpqIFq0Zb
 CBOrWBcqSE3BBl3ixvRNlyxYrzffanfqOKrN2hKUENIc6bcV4jMJ
X-Authority-Analysis: v=2.4 cv=JNsLdcKb c=1 sm=1 tr=0 ts=6a55cf50 cx=c_pps
 a=w14INr65hnrDDPfMN4rXVw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=qpSLnr5q3cntFrtAFGwA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_01,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 clxscore=1015 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607140059

Hi Ted,

Gentle ping on this patch. It has been reviewed and received
Reviewed-by tags from Jan Kara a few weeks ago. I haven't heard back 
since then, so I wanted to check if there's
anything else needed from my side.

BR,
Yun

On 6/12/26 08:53, Yun Zhou wrote:
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
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 477d43d7e294..5d60ef10fe11 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -464,6 +464,7 @@ int ext4_ext_migrate(struct inode *inode)
>   	if (IS_ERR(tmp_inode)) {
>   		retval = PTR_ERR(tmp_inode);
>   		ext4_journal_stop(handle);
> +		tmp_inode = NULL;
>   		goto out_unlock;
>   	}
>   	/*
> @@ -591,9 +592,9 @@ int ext4_ext_migrate(struct inode *inode)
>   	ext4_journal_stop(handle);
>   out_tmp_inode:
>   	unlock_new_inode(tmp_inode);
> -	iput(tmp_inode);
>   out_unlock:
>   	ext4_writepages_up_write(inode->i_sb, alloc_ctx);
> +	iput(tmp_inode);
>   	return retval;
>   }
>   

