Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D014A8B;
	Mon, 29 Jun 2026 07:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782717029; cv=fail; b=AURiNNHwJg2ADqSlrhu+SBxXEaQBWCzgsE4GHVJFaKWfJdyKaHKoV7a8HP2B12FBZXe9U7UtfEcTKpiSYBkQAqQJ7hM5adGjRkUy5gDApwI28+pdWZA9s2EN1HyJEXFWKtE8ef8fPZhXpho1zrPtiggH+/fePruRmQwWfWgTMH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782717029; c=relaxed/simple;
	bh=rpacWGirGNww6raz82VqyEnirK+RR0hkMgbOPdjFtTI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WPxO6mtJNoo8BMRJzLZnWvciFCa1eUK+hsa62t0RuHImdiBGcE0+jQ5udUYFR93E0f4OlAL2LulSQ03kYiUsXWTuR/JGbP5gOqtTMa/PKk+vrKK7USKK8c23KZKqaeCgHSF9r/nppualWGGtUlIH8Lm0rO5ifx/34wgmgDK4OCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=fail smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=WWtb9jPk; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="WWtb9jPk"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65T6juNJ2094304;
	Mon, 29 Jun 2026 07:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=JovdZCkQvxFL33lXH6G6aKELqIuyTlBMaJ7YBF0Bk3A=; b=
	WWtb9jPk88hLbTTDovVRPjd/7G7qpBiTgZrPWxAdatHZ/zXWRWi1kNdUHaSnhmOU
	NLFr7E6CkaCSg81mkUp+fBW1ogEgEp9vEfW5+T01uoBlKfrCh34dZsrvtGDstrKc
	X0H4zInXjskhJBYoGSMTRkTM6u2nwuapNPh0XWsB3WRltEMqUW9LwHchsQtmsxqD
	EDeHOb6s1OYviF9aC63T1rHAcNRGkbnJzI5JUmSis74C7eCbPE8W6Vyz41Ey8mGS
	dArx0D+lhaEDI4kt7OrAZzLogm06fYyZJ8XMwz8JGSFQmHtsdXpQx4OS1jGkUu7x
	d6teJ69zP+rZR/6Z+yqO2g==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013011.outbound.protection.outlook.com [40.93.201.11])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f25g5hspx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Jun 2026 07:10:18 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n6ABa79ieqMQVrH95mU8B6TbFxi1Y2EBvA++VD+zdLi7s5dgKGoF+D/PCk1aj6YvUIZFFvz5KnNX4c0jLoKDykYJ+jFfKcPtL+C1xH8+5EzCapdNVKxR3DlhNjm0Zuom+e9l0nwziIolEw7CntM/deSt78ghcbW63a+MtNmXH9nn+XsvYzgcqWBE/7d2JYqur3+Rj/kOzqZibmdRzG2JAN1gRptvJGBRtcFTyXxRITlFQJrSLBL3lcwRc/CxGbIX9bOZlvWpTFiBme1XHndKXe4Dendkldyqrk2BU1BPP2pKsZfoYVKlJrI/sX5y9legFpHVQM7AycDFSrECQl7cdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JovdZCkQvxFL33lXH6G6aKELqIuyTlBMaJ7YBF0Bk3A=;
 b=h/wdRjsP919KPkwIYQVpqcYwK0/zqnhEhQyS6fkDtcgxeQV1yUbSBRzCjXK4hEsIwRkgyIDzD/fLKbMIknGxIvIDk84BIQnPyMSTk8voIp+0HBqL2U9xzz1KN4j3B+VTZ+rfW5tA27Ry2Jq/AV6IRRq+prpIKrCvuCgGSQUYKRjHpggHGD8oYPkWPezJt7TCnAW9WGNfUhru6cvKwp2EvXZou3wYXMaQqelkAvewsXomsvt+9RycFpYbqzSVoQ4pqSn/lOEdHQQKhGmQDFIQO44hXp2xNhU9KcxEssh7ZpnulxrUiUC3NnPnjc3QAtKvmkZOfAzKDVXfdYxg71UfUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA0PR11MB7752.namprd11.prod.outlook.com (2603:10b6:208:442::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Mon, 29 Jun
 2026 07:10:15 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 07:10:15 +0000
Message-ID: <7b98658c-1806-4d45-8abf-f229ee7de095@windriver.com>
Date: Mon, 29 Jun 2026 15:10:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ext4: fix circular lock dependency in ext4_ext_migrate
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
References: <20260609084007.3432061-1-yun.zhou@windriver.com>
 <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260612005330.1930804-1-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0152.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::11) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA0PR11MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0194ef-1c28-4f2b-00f0-08ded5ad77ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	arLWLOoKSG7KoBOSQTgRMHWwBTXbv/qfr1ugBmRF15SWxYmWcZAai5rlV0EVzBui3LepZp1qZ8mcqLMUuui2o2cxuMgjuJdfQwvRuysLFatNOMcFKYOcSj+Q3YLB0bcOe9F6Rtu06TPfuvLOMViUxqXwLchI5fDW5jn/FruxKMIDiQQ7+QqcfV4Kkj14SRwWolYWSPBJ+i4ETc4sOlA3OgfuPrEFXDRTbUfzdhttvF6n2W4xiqez03eeeL+pMcFX8YzctWnXKl+oA0NrXHb0XqGiq79BwlIUy//xgI8sfn+eXcRtneLC4uFyCrWIT9fWBLDWbVdwSRMFAFxKOZVImyBcocqH3LLkvPXc5hw/bN6/3w6QLlOE1Nigh+oBIZj+NvwIIh9DCNMoi5n10hIfNs7mbYcdxHF/Je1L7t1CmUk4Q+DpqKdeVdnw7ag5GSXb1N+mnkT2UHAd0AoG1n9xtYTfvpeBLAIFhXmKoh2UCYnZJiKIwFrNHWV5P0Take092eHJLgx6srXlbZagNw3ZsyA43viKfg6OBsrEozssunlySE8na9OB0mO2eU+N4L2uw491gjtlUyI2Ao14VL7p7BnSl1CnFxnkqVFAEb9LJ7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnovWU51Z082N2Y5R2RHRGd5bitEUmlhcXJ2UG1seW1EcU11SjZJVkZqU3lk?=
 =?utf-8?B?Wmo3VXFlNjdCMkFHTUtmVjNGcnc0MUowVnEvb3FzYWdLRW9yckVOTkQ5UXdE?=
 =?utf-8?B?dk8rNU5pNGFxK0xTZ1I2U3BCOThKTUJZMTlCUm9FQWplYWYxbW0zVFhVaERX?=
 =?utf-8?B?YlNRdUxyUWgweWN6b3JuMHAxa2FsQ2xRZWdiYThqNFpXWGRxVXRDR2dFcDhM?=
 =?utf-8?B?Mnh6ZWtRcTBCVU42NXBOSWZ5U1dhaWpwMkFGVUJZQ1ZZUkZwdkM2UnkvUVlL?=
 =?utf-8?B?QVJNV1JHakZDcWY2VWd2eEZlVHJmV1E2bktiTFJPZXUxc2hxSmNBdHZUeVJQ?=
 =?utf-8?B?eE5vUE14aUx0K1M0L1RMTlV6b1M2MzJ0cUU1Z2VVbUYrcWwzdGlPM1g5SWl4?=
 =?utf-8?B?dDk1TWhROGw0T1BueEkrRExzdVlnZGxzbjJJUVQwbS9EcTlNR1ZZYko3VGpJ?=
 =?utf-8?B?Mm85d0lEaG5obFJ4RlJjUFRZek9kNlEvMXZFbmlWR2hLckFVWjJ6N0ZLSjEr?=
 =?utf-8?B?WHBlZTVEbjh4UVhEK0Zza2JDRGtaZzRLSkhUZlBreWZlUnVyaWlyekRwTFRs?=
 =?utf-8?B?ZDNqQlZVdDZzSGV3UW1VUE1LRUZKSE9xd3FKVitjTXk0bkJ2MVBLRmgzeUlD?=
 =?utf-8?B?WDFCdjJ2M2NjUUJ1Y2JzMWhUWVU1TFduVldxK2ptL3EvNmJvdjk4OWsraXl4?=
 =?utf-8?B?aHpNdWpLZEh5MzhjL25KZEFXSWJxUDRtWmtpWkl3TVdmSHhFSjdaWHoySXhN?=
 =?utf-8?B?YUE3aU9FM3NiMlJNdjdiZGNFbkZkVk1HeTNhMU9OMlduenBJRDVuTE5sd3Nv?=
 =?utf-8?B?b1poZGc3QmNaZUkzT3J1MHA4b01TeGt0TmMyU3RlZUtJdEk5a01ZZ0I5a1FR?=
 =?utf-8?B?SkQxQytpWEdhQVR0aUNuUUpGOFdiU280K1Vab211czBaUHBYZENUdis4U2d1?=
 =?utf-8?B?cVo4SjBkWC9PVGk2QWIxS1hXYUE1Z2IxSGkzdmV6ZWROYTFYV0JZQ29HNVM5?=
 =?utf-8?B?NEMwQVg0alpXdjFzVkhGTkdHTHpndUtGVDhqMkFCQ2xFTzNjZXFCYjJJRC96?=
 =?utf-8?B?SUVGVmt2Uk1odDhvSis3c0plVklMT3VSb0tJeGQ4bm9Zc0pJZjZHYk9SOUQv?=
 =?utf-8?B?VW12OUd5K1FKRGpwN0hFOHdCMjlVVDR6MWZhd0dqcjlIY3NRUHU3U25ZMUJG?=
 =?utf-8?B?QWZQdW8rMTJWcHZUQ0wrc2lNa3lDNjU5QkxzSzRiaXFWWjNMZUc1VVgvZEE3?=
 =?utf-8?B?dDltVnVaclNmQ2pBZHdhdmVTWUhpd01DOENoUy9qT1ZLSjE4T1hPTGZWM05C?=
 =?utf-8?B?bWxXSGpGQWZlVWZRdkRmQmE3KzRzb0JFb2drc3RER1VTeEpUOHZZNXZZUGQ5?=
 =?utf-8?B?M0hyb3A0eUlGbmowUjBibkxVZG93RjNJTW9ZTE83azd2Z2JEZWFxM3FrT0FH?=
 =?utf-8?B?Nkk4S1o0TkNwcFJCbmJpcFNlei9GVG5keENNdjU5NG8rUXVtdituZllSK1E3?=
 =?utf-8?B?ejQrWUVIZWd3MzM1em9kV3lmay9FTjVWMDBJZjBaTEdPVmlBZWlyL0graWpx?=
 =?utf-8?B?TTVaM2dwbmMvbXozVVg0Y3FpV1dtL2lxQmpBTG5IbWFqRjA5VEhLL0t0Tnlx?=
 =?utf-8?B?anM3NHdQeUwwMExpVmRhN1dWRk82R0JUb2pBbmd0VjFjTnpBM3Zlak1PQlJ0?=
 =?utf-8?B?dDVQc1hzbFY3b1hmcWt2SHJzMUUweWc4N2Z1bXA1N3h5RE95MUJET09ldFB5?=
 =?utf-8?B?L2UwQlVaQXJjcFV1bGsydnFWVjhaSEF1Y1JhVURWOGdrajdBYUtQUVR2QTY5?=
 =?utf-8?B?RG42RTdZc0liWGllNk0rTzFYa0RXVFNzNTh0OHREclpEbFgzYjQ1QTYxQy9U?=
 =?utf-8?B?UXZUNHI3OHFUdXdvb2xXdU5TU2swb0xncWpmOERWYzNmLzJ0YTVjKy9xVTY0?=
 =?utf-8?B?UjRJcU1CK2JpV1B2SXhBSnVXZG5IUVh3ZC9hbXhBN1dSRW9sbTNJOG1NdXdj?=
 =?utf-8?B?Z2FydG1pSlN3YURNY1k5MnhrVHdBWEZMTjRaRnJ2VHFkaGdHbEJXV0NRWDhs?=
 =?utf-8?B?RDBMRTVZcGlCaDF1L1lnSEdZUFhZcDNCL0MrYnFuWExpQXRZU1pySmRxN3J1?=
 =?utf-8?B?OUIyVWoyNlgxNWE0MVM0Rm5wVmh5dUsyMFFCdVY0aEtoVndQWTVnM1QyOFBw?=
 =?utf-8?B?cHF6S1dLcGNvU2JYUC9KSmxkZG16ek1nVjRqZnVFdEptbnduOVJLUUF6RlZK?=
 =?utf-8?B?R0YzRUovTlZCcno0a2p4Y1lKbktYRndZalVBWGorRGVNbmNCdElobFRDcjkz?=
 =?utf-8?B?VjFPVU5ra09vT0NUTEZtS053eWZHSTNQTmU2WjdYb2VPaXpCWEYzUT09?=
X-Exchange-RoutingPolicyChecked:
	oj8RQIROXaOxaBluWoAnsBzmQnxV8WJcLGVDs+S4pRVoUrH674ogm2LmYPXNb4bsYFDMTic0kgUKfzXGM7ZuRAv+rbSTJryVJcZl5J8M/qAAWMlnTuC7ANmA8Qbi04S2KFmAvmZJQHnHaReqI0azaS2EqWpzVHGjYlYwujbkJR5VNxO2DEVJqN9HxtkB/RUQw93kS4vklX2fTveZ6rWVAfShoUEYSreX9MwfN43Qfy+jHhx51niDqUwQ9VXbU2ot6lcruaXIs9cH/WxjWDhKRjhPFWd+hBTaiHzDOTLTyeQceWAADx8F8a0N6ECtb4KbF2Qd+NJ4J0qim8ToKBJJsA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0194ef-1c28-4f2b-00f0-08ded5ad77ed
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 07:10:15.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QnGgEHDFh4bMe8SCdDCPV7Whwc0kaz0uPo2nDpvOXf5e3yUzjLzM4bD5v4Lmq3TZUCsDUMaYsgDAvY5hscszA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7752
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjI5MDA1OSBTYWx0ZWRfX6Sa12cGvnqog
 Q1IZR238ryjeVEkCeyzjqjygN3k7/g6rDfap/g1NNM4dwafyMhpcpx3udoRVBSxyqA99gG26azu
 Hq9Xro8evseKivZ+nmGQHsweZSwSVUuAk2CuM88kI4T95z4MJyuK
X-Proofpoint-ORIG-GUID: iA5CFCAQtSOtb45YzmZ7Xric8fdRi0x5
X-Proofpoint-GUID: iA5CFCAQtSOtb45YzmZ7Xric8fdRi0x5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjI5MDA1OSBTYWx0ZWRfX0GOgPrkUP6pk
 95raM3GoUufE3mKo+VK7gSD01KRTkT2gYmPpOMfLcQ07mA5L270c+76fLpgSF9xFLkBq2zN3Gf9
 SgU//qw6/E7OAjZbhWNprAXRajIuVAKf3WLKRrNvXMRbkqy87s6N9/JlcF9L7UnjlKc90lYuc8y
 j+NLMHdIyd1mYGuSK9GQILfIwp/CrBkx2hMcKlvWr+A3pT8DGX+gE7IrV3uXrqRL2L8XCF0aLaW
 yzkzUkbAf/HgrcGYwZ0DWulNUVIY0LecXDFtWxFlz3K3+w+7bk5YlXtc1r+OfpQZggotbS8XcHE
 wexEMech9bxQ5ZZQS0Jac64YUVQJG1QDaeXmNBjNk3x9a+jtF3XiIJo1GkF0auK9eDUtsg6GNSk
 Y6Ic3/LYxRCBK9yvThuzcVrkyodAEwZRw7jIFRICj6fJtxonYEuuSquUlQ4ng9bOe3hDMlWtsvh
 gpc/Z6ar5wpXk3xCdlg==
X-Authority-Analysis: v=2.4 cv=TvLWQjXh c=1 sm=1 tr=0 ts=6a421a5a cx=c_pps
 a=NzAOMTrFL2nmaFUJOsdohw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=edf1wS77AAAA:8 a=hSkVLCK3AAAA:8 a=t7CeM3EgAAAA:8 a=qpSLnr5q3cntFrtAFGwA:9
 a=QEXdDO2ut3YA:10 a=DcSpbTIhAlouE1Uv7lRv:22 a=cQPPKAXgyycSBL8etih5:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-29_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606290059

Friendly ping.

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

