Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A583CF67F;
	Tue,  7 Jul 2026 06:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407454; cv=fail; b=dAzJMET57gQe3SO7Bzfun2TEqHsZ2Lutx1IIkFIdxb5Gju9VberhRAPZzfxjC0H0vwmjuj7hpbf7DXA8gRyH9LXdBq033fN+43EBkEuCq6q6M1bgNWXP/jQibXL9VvIBlhHK3zqHvXljeSW55EeeA1qOj4XiiZgHZpgu2TzZBvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407454; c=relaxed/simple;
	bh=PN+ZddKXbd3ZP8gObhm2DFy8Urh/ByyNHyR/GcrVLus=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gfRbfR+0+VlrIcnKWAPmLyn0PumD+y/JoLUpglGKa0yPtG6vxg9LznUJ5I5Pfc9xi/VEmh10Xw5Bm4ilk91I8wC99ljFppVr4i95VzFFki+J8SbIG/UN0Qr9N/IKqnYKdnYxMpygPCUSF/WGOUeIRCm8dpKWP/VbEY5huZwaVtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=rwSBh2Gr; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="rwSBh2Gr"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6675Yrul730705;
	Tue, 7 Jul 2026 06:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=bKirZQ6AMGVOXzKv61ZfH/B6Wq19IyC5yiFAO5u2rKg=; b=
	rwSBh2Grw1h4MCDOhIdcia3ZBB8WJF+pNfTK09X9mvSE+diuDFMfi/wEgj5iq8RU
	jV4dWa3ZjkTzlLB9kl6MswadZzdfpPZOLbL5uyFBLfulsNr6zg99qPhhMj/5ht4Y
	XnLvP6QqYPBxVSX6ATPUrhACQ0sllylMWVzhO4NnimRE6hlkU6m6R8wcNXFc4LWD
	AkYBotNnEm5yKhULVg6hfwCaWPaIgILIDCBhKGeVCdQvPJmaJkMD+TyKdHwVq687
	MMca3Va81tYcZ8tG8y5V4D0om5OQb41xvliC8BV8Swm2CarZxgSIuFHUJemoxyOx
	slBB3lvZBjJZ+3wq5vhP1A==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012053.outbound.protection.outlook.com [40.107.209.53])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f6s58bqrq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 07 Jul 2026 06:57:13 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DBKVmltW6Fcsahv3MLrKhyFMGfZxId07fwC0sGSY67fEP8x0A0l1CRwKHqU3Ht9CaZLosIoJOkBB7IcfjmjEwe4ur9OEbegjsW6zpZFtGnNYMW6gD1I8ErVZMz4XIg6Hafv4ueYF/fnZfGpD2+AJcYxoMMl0f7iRliKdpkWC80ZNXo/CnPq6g2N17lSjkS9mX0G2C37rFzTINAr9D87M523XrFaY8Ek9HGZbjfzD8lJ3819gwx9wGXkeKUIcTAoMb27ckspErrtmoCuZkvAw5Kf+tcXGUwe0PVY9g8foaVTlIJk4Mhcx0HRAwNwk9pcHurNicWT3PtpsuIX2edQcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKirZQ6AMGVOXzKv61ZfH/B6Wq19IyC5yiFAO5u2rKg=;
 b=aLIWajR1mE50/XZXIjypi1hf4zwDO/EON0Ga2hZXIwd7CTOR16V9GjODhvZoSlqSdviGF4j8hMaFyf7/5R5Lw2xEzLHgv1uktBi5/8+VVqHeNkrcncPv+uUndFdu3ZoYMZ9t+g/wc7TPaMgHugcIat4utvpc+SfEZR1gRK2gDYBN8lnvIarVhNBEJgkAEVAQYK19VQV1BmZyMNCqNBOIuxU8k+GVzHkep1HBhtY+EPXDgJhDpCw8wei5MZJn/SqOVV2VSoUJFG753JHLjr7o53yGefnRkOeW7SpwkPCodENcck8rLTX+tCZH1lFHQ6XM/xIoIDGpQRXekjTSkxJDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by DS4PPF00BBED10C.namprd11.prod.outlook.com (2603:10b6:f:fc02::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 06:57:11 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 06:57:11 +0000
Message-ID: <cabf6e5e-557e-40dd-8ce2-6a80ebad38cb@windriver.com>
Date: Tue, 7 Jul 2026 14:57:00 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
To: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
        jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
        yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260623061903.2148767-1-yun.zhou@windriver.com>
 <20260623061903.2148767-2-yun.zhou@windriver.com>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <20260623061903.2148767-2-yun.zhou@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:194::13) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|DS4PPF00BBED10C:EE_
X-MS-Office365-Filtering-Correlation-Id: bd3c808c-7c40-425c-48d0-08dedbf4f802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	BRDydy16tG0ATd9yEwmjsZ9yEZmLoiH9VdYgJItp62EHGbeKd/XfmlGghd0iLI8jNlyTrDYO2DGPTvUMvgJa9cPOfUgWwqtwmT1TcWxRYFC/HQ568qk86ay56h9bG8b4qYkRvTn1RPuhd++yVHAS10XSU/cK7FTU0G6/FvlH4Isorp2/nMC9cebUtoyvGP9HZx2iJihkq1iw1uMv88yQihAmcLdOfdgUw62FutCxJZ/gbw20E26cW0CY9gjuwdejA8Chpa9xyNcu78g4XIwfn7TG4fm3pWlvsExEI5TpinKgTMSkE4qX/ckXQzZS6gXDvCnkW5Sw28DPd/sK46VIXWJ2MMYXRzd8dJKMKCK74E9U6Sl7ItBAYGEvMubqcurqovKgozwtiugq4olsBAxRZ9/0Bs0udJQEPeU2CVzKDEuP7ssFde0uUHc0YidQoHcu9MBmtOlH+fiBfn6k6vMkWyyyReMmF1DZKhtzvOWCnDEgNzmbSLxqD6aNtG4ILIoWgALh8kU2Ft7S7D6xwICkqNjuanlx2NihfPpjp/r0+0khqeBbTG00WOWrhr0JgUbcmQVHNB6HMTTtdb/zyTQs9Da8iTL0ftghNJ1vH4yb2xE6uj6VcYovE1W5FY3HaVUgWiItYx7OyaE4pVc4Nu0H4Gq2aQosED3VgIQC91z0tpg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGNDNTZQUGZJcHQ3dVZJSVE4M3IyZGdhLzl3b2xoWDBGTitKY2R5U0ozNXlm?=
 =?utf-8?B?anFGOGJJZ2JkRVpxUkJjdmNCa0xiMEExdjdFbU93dG9kbTZUdU9vcE1HbjBh?=
 =?utf-8?B?d3VkajFmSnRkcXNjL3R6SE1aa1c1elA3SCtGZVZCeDNUTEplTFY1TG5kaXBK?=
 =?utf-8?B?aXdTWWgwSkdOczQvZDAxU1Q2eHBkaE11UldQd2VNakM5aWtZWTl1RTBSdk9W?=
 =?utf-8?B?ZEt5bEdIbStsc0VZK2h5eDNiaTBFRWFIQVRxV2ZRTmFWWHNSQXB2ekZ1VFJy?=
 =?utf-8?B?TmUrYjJqMnZ4VVBpTEU0WFhNeHdLTUVROXdlMktlNVBMNWRkTUl6ZTdVclpX?=
 =?utf-8?B?Z29FaDJ3VUpWNU1XZWlOZjZ0MUwyYm9UTjVaTnNCdkJYZkJHZHVyOGZ6SURI?=
 =?utf-8?B?WkJUTnJzWE5BSkVGblpMVlJVcTVqeUc5OWZ5WTJKRWJaTGx2eUFBUmJUdzNH?=
 =?utf-8?B?S3JEVEM2YUpZZFVnb25YWFl3N0c1MU04YmVSRjFvNWRkZXY2aU5jSG5HaXBK?=
 =?utf-8?B?TDlNNVZwejVXY1dLSXRDWDFlUWdGQ3RvOTEwaXJQYThmVlZxODUxWEZPMmxy?=
 =?utf-8?B?NSsxZHptQlJJU0FDWkdrN01xcG92a0ZkS1hIK0c0Z0ptUXhJdWM3TFljTFVG?=
 =?utf-8?B?K2VsNlUxcGpzaXRFeTc2N3l2ZDNRTmRwWk0vZmZ4Rmc2VVpNR1ViYm1lZUMz?=
 =?utf-8?B?RUFWNWszMGdjZHBGeVlaa2JQRFo2QTdWc3ZpOWdXbW5NL1ZHaHJZTkFuTk5H?=
 =?utf-8?B?VE1tc2ZuSzVqZHVJVS9qM1BYdkFaSFhrVDZvQjVLdmoveWNWWndoTlZRSk1l?=
 =?utf-8?B?cDFrbzV0aW1DbCtBNVFSSk95bkxyUHArK2RtdEFGdTJ5SU5qNjBQcFE1dCsx?=
 =?utf-8?B?SmlycWJWek1ObWtVV3F5RVA0ZDdFaVMwU05CRWwyeDI2anNaeXcyZ1hiL0tX?=
 =?utf-8?B?cTlJazZTdGN2OVpPMEkraHhkRVVBay9OeXM1d0s5clNWd2tJT00yWko1dEgr?=
 =?utf-8?B?MDdSYnNSdGJ6d2JBNjVlZjVsSGhDVjFZNWxQS2lmNUVxU2ROeWM3Tm5CWDNW?=
 =?utf-8?B?cmRBSXY3L29WK3B6MjNGMzBSV01iN0hsbUV5ekhPbXdyeWxUajRSMVFnWGR2?=
 =?utf-8?B?dU1qL1ZmVklEQ0dGWGQ1T2VwdjNUZUdOYXo4WUhXS2x0d0R3YTIrWWoxc0ZU?=
 =?utf-8?B?bkpMNkVyek9wN3JoQWQ5c3RkelkrUTFPd3d3MW1nYW8wZDVWRzBXM0hmYjBQ?=
 =?utf-8?B?YitPT0h1RzFkOGxLaFBObjlQK3BGSGRiRTNQZFhJUlBiQ0d2T01lQXJ4SXNh?=
 =?utf-8?B?bzl5OHBGajNwYm1aS3EySk43ejNuWjlBVjQ3cC9pOFIycUhOMU91UTRYRmlE?=
 =?utf-8?B?d05ZaXBpZyt1V2tiMktTQ3k1bDJMTlh5Wk40WDcydW1RcDgza2sxMWZXZXhp?=
 =?utf-8?B?cy9kUVVlWWdXSDYrakJkVjFYUnpkSWtKMGZLd0lxTFpDY2N3c3VtOTNiTnRP?=
 =?utf-8?B?WFBKbE5HRFg5KzM3ckdSNmRudm5EMFNaK0h6MkJNNlNXdHR4T2tXR2JiSi9Z?=
 =?utf-8?B?bVNEUEpoekNITmJjNDlWVHRHNTVqdkpyTWJYaGgxVUY2ZGplTUJIamtzd25D?=
 =?utf-8?B?NnBzWDJGYXYra2Z6TmN0Q1Y4UWFiVlNOV2NhR1NWVEdXQTA5SUtucFdNRTV4?=
 =?utf-8?B?N2hJKzJzaGlqMkx1eG9LZzhjL2RGdDN0NklWdTV2REFTOC9Jd3hwVGkzeDJO?=
 =?utf-8?B?TXE0Z3ZabjNZRGZ0cGIvcm9zd2hWeHB0bkpzaVB4eStnUWNxcXNEUEtPNUg5?=
 =?utf-8?B?Y1FKUWFYTS9CYXU4SHJuR3V0YU0yV1pGT0dsQkFKa1lqQ1lCd3JOV3dCc0FI?=
 =?utf-8?B?NjYrRTBkMDhvYmNoa0ZXZEhIOVlqUUxrRHc5OVFCRlU3L0hRem0ydHczcWV3?=
 =?utf-8?B?bXNERlNQQkE5S2NYalgwMjhWZms3WUUxRktydjRJaGdtdUI4d3NqdTZlMGxw?=
 =?utf-8?B?L3M3TXFLV1l0V3dzU09lQktnMXV6SzhpdHFBVmIxTmtCRDM3Ti96bnQwc0Yr?=
 =?utf-8?B?U1ZzNmRRdmM5NXVRTlBrU05Ib2ZKYk5VZ25EMldPM3EzckxOeWxrMWFKNDMy?=
 =?utf-8?B?MjJNbFo2MkQzeVFLNUF3V3o4ekhQSzYyUGFiVy9vb040eVpvdCttMWEweFRp?=
 =?utf-8?B?SkVDY255aE5mY0xXSWxOZ2Zxb21seDJERnN1Rml4TlN3aHg2OTZFb1VkNnhP?=
 =?utf-8?B?RjdJWHVNSlNkWXpNdkFvLytseGlVS05NaDRMYllrclJhT3gyNS9NT0xKUzB2?=
 =?utf-8?B?akF4M2pHZXU3TFhQM0RiYkYrYUExREVSOTVOcmF2VUk1RXQyNVVMQT09?=
X-Exchange-RoutingPolicyChecked:
	Z4MSSETZM+WKS535YR45rZQU282kdIGe3EQe1UnXQdp4ls35Z/4kQHFzBb2wC4XEhY6Mhv9oARakW6nQ79oNWawmAZ7vBGfKjDD7ahTmezTznHfZCyHkz2wHpwuCRhoWqgYW4zpzuE4A4Fw0ZLfQ3EUTpCArG0CVNQP5NiQ0d9P65PQAC623ZCch/qDcX7XLnbxf/7xm2uNsU4b+dsAA8f6aa2NnJ0NS+V7JguQR5E3RYWJEmiKvRyNV1hG1dORJ8xdmCf6YniK7VQbOz/LqA7xjh0mdKRwD8lFq3mNFh5W3b4ul6U5UwJaWV+e+yfhk4xEsa7y+VRMzz3z67WVOcg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3c808c-7c40-425c-48d0-08dedbf4f802
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 06:57:11.3522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cbmP3c9HbsUKh5VZafFTE7Kn70m19Ridy5nFo3ZgQCq5iwD2Ve3m2bEDGbbN5eGRrZcXUO71JLLeQ3UyUyDEgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF00BBED10C
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA2NSBTYWx0ZWRfXzLFjTJh/7Gnv
 FQZrNbfjs9k4a7UJsXlbguX9JbiP80LNF2sTvfeLi/rU765uRJT6GDfYt/0KXRfypGK8rluJmNn
 QbUqeRsJqWmMDhvZix4rvUftjJuYdPOTJfl5BO5nG/a3mEYoHZGZ
X-Proofpoint-ORIG-GUID: 63bJX0xqc1FDItmMG1g9J0PEU9prxnDO
X-Proofpoint-GUID: 63bJX0xqc1FDItmMG1g9J0PEU9prxnDO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA2NSBTYWx0ZWRfXwieuqTK+kP88
 cGOHaP9QB7q89SSmJaF9W2YIOeUS1mzL5/RwoWhfyCoFtVf1a0U9OMW/bYRWo39NcechD4G8gbM
 undfHSUv/4HKn/9sb4kZZZSeRGiym7KaH1CV1TVmMfavMWxCjMPh+lGGAhtwRhoVf9wC/c1LiuO
 wOgaMgdvQ7AOZDjCtP2368iD0eVK6gagIzu0OrccPI3fBBW2jmoCMiUya5kIKxM4n2nffvaZC46
 atXN3VHW87WM32fr3PFiP59X/1Vz8r8J+z/gDxA89OH5SBwyWJA15Y3OxDBXNU1zA1VJnt/oZc9
 WAgVXJz+P2hGYGYlm1Rimj7eRQe1a+ZnisNTxCoPNApZ4QKLdGyAgmZAXuvn1mJjvKMvIPLz9cK
 1YzGZkUa1e5coYeePxEFhJFzOq4l2cwA4WUobVbV6xJKtJXSMic0D0Di3vQ1hZjZAGsLlZcRUxA
 muNx8/DnSQp/7vLoaBQ==
X-Authority-Analysis: v=2.4 cv=H5frBeYi c=1 sm=1 tr=0 ts=6a4ca349 cx=c_pps
 a=5XdDR3/zV2dQAmk0xmzXVw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=t7CeM3EgAAAA:8 a=NlJ5JxW10x6CvI6sr3EA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607070065

Friendly ping

On 6/23/26 14:19, Yun Zhou wrote:
> An inode being evicted will never need its extra isize expanded.  Set
> EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
> to make this explicit and prevent any unnecessary work in
> ext4_try_to_expand_extra_isize().
> 
> This also provides defense-in-depth for the s_writepages_rwsem deadlock
> during mount-time orphan cleanup, ensuring the expand path is blocked
> for inodes under eviction regardless of how they are reached.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>   fs/ext4/inode.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a5409324d965..0d131371ad3d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -264,6 +264,7 @@ void ext4_evict_inode(struct inode *inode)
>   	if (ext4_inode_is_fast_symlink(inode))
>   		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
>   	inode->i_size = 0;
> +	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
>   	err = ext4_mark_inode_dirty(handle, inode);
>   	if (err) {
>   		ext4_warning(inode->i_sb,

