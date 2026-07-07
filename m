Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA7C3F4DD1;
	Tue,  7 Jul 2026 11:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783422096; cv=fail; b=E/ujQYGCJxruTvgu/psAXyrNGlZ62KdZYlcFavD4Cyzl6P4DPGRpASCdQl5qWKLq7BOHGdR0e9MIGl1h4vE6gqjdeFH0PfIIbUZXPU4YgAvZtHQHxaNDcMoQ2FUKMM/xFmaz0JjJywLCEseqy5YXcpx849T6qN+GPXWCbPqCTNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783422096; c=relaxed/simple;
	bh=vOYFMYwVPCUiEj2jBs8zbeMeRF/mOkImjUfIfkG0Tl4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kgzsRkFixaM2wJGe2WnHrLO6PJ132r9H8om42T0i1ON0LDjvkvgSQGfhHGajDyrO8s7iBt2+OMuAZlLdtswfHRqoGeSw+YZcZgRiec22Z5O8WMfCQikRAMH6A8K/YgzkNx8hA+57DyirPQJjQ3zFP/eXvM3jyxnQARwcydzAsmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=WFY12eU1; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="WFY12eU1"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6678InFP1012280;
	Tue, 7 Jul 2026 11:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=YwkiN0/HyQpNU51O5mE53spcXMshSFVdp6rUDToL9j0=; b=
	WFY12eU1/WmYtu64SVzo/mTdCMi58bXG8RX71xtHNKZhPgpb2bv7q2+gFUFKJfzP
	MxhZySlt6O6mdvXqfIdkScnb4xqOETSTQ4HXakpvMmoHUzC2fiL2iGQdToOcCJOw
	43lHHMTNvys864lDiffylf7zEOiRanXj/IUolQSQnSU1XydvrzjlP7uMAV2GGB3I
	pB1FsdSGBxzvHse5c2zwR0Lj11SlMMOavRExqCzc58P24tAqnw4jEAa56vS4UP8l
	N15q9tz6uuxH8FiGynImhe56JT+dBhRLPKLzOaZhbLhHn3ZM4VMQnfv55YrL2Vdl
	XX+dpEgW/QdEttM9C8cqLg==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011063.outbound.protection.outlook.com [52.101.62.63])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f6s58c1kg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 07 Jul 2026 11:01:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXfPnDBUYxT9N8zyll/HqBhRdefl2qotY3kVy3RwFQvkklA/vzYhDamO2Rtv05Fd0MviMnNHmtQWw2+RsC+7yOU8InlBs+nUmL5gdh+ukeN2UO1dZ2Rzl0YRXFfIwOBugvJ9+RmQgfsNWCG+8mmMOUa0hvEi//UpqQFCtS7lR9op/qhVXCrkmxfAVKzIFs2q20seMg+ah+jsdOz20A6+CckVp5uUHvdv7quVWB/IHEM05V/ogGZgqvNjh2DLzJ+WeJtc8DcThUF+mmLS0ohSazlYUt7jfWhIJEd2fV7fVxVWWNaX18rwBZNurM0xSVO/bwU1i+Ou483qksrc+0C/BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwkiN0/HyQpNU51O5mE53spcXMshSFVdp6rUDToL9j0=;
 b=v+Zf6zIBY7QTqSidMsLFYKzs6SE9XA7xX66IdZE+YKc3Q2DjH0PUXTMGZT9WUOat8yOkQEB+uQlqUX1FcWUOsdUvG24/RrLWj0PUlfIxs5qVF3hZEsVOi0GggKZC6VNG3QJtitTGiCu1bPo3ee2k9Yb9xJg2U63+3GQVEBGoXHjhlTfszzvSd2GtWq0XjI1hjnluF7WX5LuOpXc67FRTiZiN3PaxPBxqPcjTrc/mvDvEAug8uxEZnux/o7OORWaoSXA32K3BUlm/PdxHpSoVVo+3y+MNd3aaPXA1/d+aOStsHrlf8/FuC4eoSrqxJBjz1Ngc3wUbVJnyJ80wKlrcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by SJ0PR11MB5054.namprd11.prod.outlook.com (2603:10b6:a03:2d3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Tue, 7 Jul
 2026 11:00:57 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 11:00:57 +0000
Message-ID: <9bb5dbfe-bb82-4ca6-8a14-5c434bd54051@windriver.com>
Date: Tue, 7 Jul 2026 19:00:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: ext4: deferred iput framework for EA inodes
To: Jan Kara <jack@suse.cz>
Cc: adilger.kernel@dilger.ca, brauner@kernel.org, libaokun@linux.alibaba.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
        ritesh.list@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        yi.zhang@huawei.com, syzbot@lists.linux.dev,
        syzkaller-bugs@googlegroups.com,
        syzbot ci <syzbot+ciadd810ddf4701c1b@syzkaller.appspotmail.com>
References: <20260702152225.4071746-1-yun.zhou@windriver.com>
 <6a46ecbd.52c20a74.1f8b39.000b.GAE@google.com>
 <j6ftvy7a3w7js4whqps3fipbah452xhro37kxvkruoeobtlonb@zrp2pwoif3pc>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <j6ftvy7a3w7js4whqps3fipbah452xhro37kxvkruoeobtlonb@zrp2pwoif3pc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SE2P216CA0084.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::8) To CH0PR11MB5332.namprd11.prod.outlook.com
 (2603:10b6:610:bf::17)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|SJ0PR11MB5054:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fb8a6a-9d45-4459-94da-08dedc17058e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	zfy+twmzH9feuQKoSxDa9u45U1eeEx5xIuYeXrpjSmOrsBQF4vFQrqa24GxsKTCz53FgUziFKxZsxuXlu/wTEec3I5YKdwjyxTWexxSHZ/DPirFp8TQhLWOOpcfIeUsISn13m81Ddntg2+16++1ZMRNVMcTRBuv3ZT1ZyPWlVOydTxITcDiVaXXX9qqI6KpqSDK3Tmc4PXg6Fgihn+71PdCEz/j/ig3K89Md5M3S6gjNJgvRNB98nDd99D/D1m/Tyf0+iyWpeCeZWKkg0q/7i2oD9qpump1XwFGYsvtl3yO0NH29H7W/ebcPAHO3LUyDlr4pTohsrmg5uWeoe8cAgfJtf1k7xgqhIBWox6AJSIgUTCTPPN9Yzx8VFuIW6mlooegJMF5ztZQQRX3YMvrpzhP5Ti3HjXT2Y08y1YyIYd6raTr8r+nZxlFhV6EIf133BJLgAi77GyjRNQq2+pDjR3CQHLKCISLH2eTiv6cCcSEGLckTULP0uAFFBCP+RFBgDwJ3O4VAyZb4P43p2WjhhLzVUItWoiw7WUJGteV3ADv7J6MkNUpQ7gTuDRw5fHeYMC3+xH+VyLO+BwzbDMOvNBVtdaT/vSa7jExVPXq8ZvfBRhLH3UtD1kZ9Sgw2WWbUQhAwAfOC6z7C7QdH3YGp4f4v5PLnFnE4YK7WZQzcbRw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0x6dkpYZVhGVTVQSnpmbnlTaG5yc3lwbUVLS2JsckJYV3MwM3UxWTFDckdF?=
 =?utf-8?B?UHBSZnJ3RS9HTHA1UGpCMWRPNXJYbElkZCtrUnhVMlRIZnhueEpldFRsMGh5?=
 =?utf-8?B?TVVtRmp4SkJsTDlUSFI0RWExU0xJTXNuUzVReGJZRThseSswbHR5ZGVEZjlP?=
 =?utf-8?B?OXlOcTYwVlhrWEhPY1BodGpjMFR3U2JVYkdDbVZQWEZMalhOUjJub1J5VUti?=
 =?utf-8?B?ZnhZWTJRdW9Na3dPZ0huVkkrNmFaamk5Mzg3MDEvRUtVOGtjOEpwUDZ1QnRV?=
 =?utf-8?B?NS83ZUhPZitVT3VYRUZudUlwSUVyQTljUGNOSnhRRThadjFERFBxTHNwd2Z2?=
 =?utf-8?B?SEZzeGlXQmh5OHNRbTRLMzRlV1VsakRvN0Faa0dEeG04djJPbDlKS0dPNUFm?=
 =?utf-8?B?VXgyQ25QdnJlL0l2VFV6bnFzRCtHQk1wSEJjVVowWmVrMHhZbzNUdWxlMVhM?=
 =?utf-8?B?Q2FKbUhhekFSYzJkSlJDelRMN3d0SUx2ZGpTWFUweEw0Njd2Sk8ySlE4Sm9u?=
 =?utf-8?B?SlNYZjFwQnBjYWJNUytPYk03dHhRQkVSYlhiQWh4dC9ZOHkzUitjK3hUcVBB?=
 =?utf-8?B?VnlrYllTQWdLb2d5emRZYUpXeHVrMDUrbHhZUVJOTGdQRmEzVDhxdVJGUTI2?=
 =?utf-8?B?dkFtTm5ZeVdUbzNnQTVia1ZGcXVBMVlldm9TMWlrQlI1VWNJdEFzMHRXaXNz?=
 =?utf-8?B?S0MwZmYyWGkyQmNBVVIyYlFjdWQ2SG1yM1orYWZXbWgva2FSeHlSYldTams0?=
 =?utf-8?B?U0Ywb0NuWUJxSnVNdWtrT2NKOUNxQzFNektjRVQxdis3dHZvOCthYU5BT3JO?=
 =?utf-8?B?LzIrK0xPa0RUbzVUYUc4c2wyWTNIemgxK01wUjB5VVQ0b2RqRmN5ckVRemFC?=
 =?utf-8?B?TjdjNWVSQUUxRVNSZUxNM1hPdUF0cnZHTVZlLzVaVitmb3NhdzhyUGJqbXRC?=
 =?utf-8?B?TU1HUTNIWlo0VEIyTHFpby9EajduVDNsZjVXWDAvcW5lM2FCb2VoaUV5K1JL?=
 =?utf-8?B?ZU9zaHkxQWNyTCtDSFV3ek5BdU9CSjRKRWp4dVJwS3ZtSVNKcVJQckZNSnJE?=
 =?utf-8?B?R1dnUDVKQWJRSHgreTFia3l4R3Nud2d1VnVBY3ViRWFobnd2dWhuajJINUJz?=
 =?utf-8?B?bHkza2lrRnJTZXRMSW9WbnBWTjhMSUhrT0NvVUlmTkxTWlhjV3NTZW1DeVNz?=
 =?utf-8?B?R0tYcGNwd0dlTzBJT2tFT0hXd2lwcHFMVWRQaXZFQTB3SnlEdWhRb3RFdCtI?=
 =?utf-8?B?dnV6V2ltRXJqNFNLZFJFcTRLTUQ3TmFWaVZ1MGI0WkxkWklJdUh6YWpKamJY?=
 =?utf-8?B?QWY0aHVCYU1wNEdRQURuK2NjRHFLMjZDR2d3RE9QVDZVQ3duUFVKaUREMnhT?=
 =?utf-8?B?QXplaks2aFpDcUYyQk5iR0t2aWI5SWtReUMxWGtXSXh1QytHZi9EbXZ6L0tK?=
 =?utf-8?B?VEYydkxhem1RVHRVMThTcWZIRGtYc1RYejZ0UzJzYmxhOG9IUXdQb3Q0WE81?=
 =?utf-8?B?UkU5Nk81R05WTkYxVXBQZEw2enVRQmFRWDFBb21lM1RmLzZOeVZLQ1ZUUkhG?=
 =?utf-8?B?cXdvNWdtQlJNclpkcUJUQ2pBaWN5MTUrcFpqanJoclJBUGtRSEJBZVRhSWRB?=
 =?utf-8?B?aGZVRXhmbEM5NVdtUlBGK0FOUHRXaFlsZG1tN0RJckhFY05oZEdtSWxvUkdn?=
 =?utf-8?B?bWEvb21IVWlwNlBZSTMvLzFzYmFNbzFaR2x0WjlDL2tMbE1DOUZVMmFsNWM5?=
 =?utf-8?B?YThZMTVkbFgwY2hSUko2c3hhTGdtZmRxdWFOZEFrQVZRNURpbHdaTWptb3N6?=
 =?utf-8?B?WktzamFWTVAwaGZkbXN1Q3lBZTU5OGQrRVZubmFHUzQ0M2RQUmhpeUV3Y0Q5?=
 =?utf-8?B?czgrM2U3cnRtZ0hmUjV2QnMyUE0zaHhkbzl0dVhGKzZxTjVVZ3BMUEpHTmVH?=
 =?utf-8?B?QmNTL3RPZUpVKzBhUXlhTWx2MEszTTJCWjNCeEdNMzB2bWVScEVtRmJFUDg1?=
 =?utf-8?B?SUpzUHJiemJOWXB0NUNMR2JuTlc2S0ZMQ0dIOENLSCt5ZGQrSmdIV1BlT1ly?=
 =?utf-8?B?TDhTSTZTT1BGWEhmZDEzWXgwWVh2TVBjNzNaOG82RHMrbjd2NGoyQ2lmSjkr?=
 =?utf-8?B?ZGtuUFZ5czZsQk1qUURnQmRKd0ljcG9aMXNBb1dtcElwdUxGSXdFcDhvYlZ0?=
 =?utf-8?B?NTU3RktVWmpkSWF2T0hYd1VyUjJ4VDNJUGcvVUlGR2RBUDQxeWN6SHpJUGp4?=
 =?utf-8?B?Q1hPb3FnY3R6aXN5RlRCVThYeGFTWkxlYUFVVzg2a0lUK0JKL3hreFVTdHF6?=
 =?utf-8?B?ZzhhZDBmNHhKZm5pcko5NmZ0TmpRWWFUZ2RMeTlrNFRDdkFMQWlSQT09?=
X-Exchange-RoutingPolicyChecked:
	QSkEUI0Z1A59lH/3A4ho9pecfncoD+MSRoWTqIVhUOTR2Zr56k8hCKfag4SlnnX/FjtvyijNvLFSLoSCW6cfgDlRV8XNGF7aIrbwkq/V9dGFJLl9gea189+UQGcUU0TONCjkjkMBeyU0zSrdxnb53QQSHdZXkwmNrVSggvrNHsO2f+BWLJuaISliinq8rzYFT2nKqNXdyz0y6baZu3KCb5vr3wYMC86i3waufgx+agPb5wQv4cOVvd/iN5P+CE5SXAbXRJLVW0R2dqXqe0hU8yFFYI+O5XBn7/zCvHgTe78d9863InFsGg8hH87YD0XOEO0g/CHxQ24+KDGUBi1vUA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fb8a6a-9d45-4459-94da-08dedc17058e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 11:00:57.2063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UD1JvolIhb8jjkvL7Mxk3X9JrjumyuNr1P9ARna8Pvqs/BZZ6rzLyg+BhPj6mDlen6OAb8m3YPCH97uc7UAzBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5054
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDEwNiBTYWx0ZWRfX6i/570nNLAik
 kdz+FuBpvyqNO1qFpcVf/sOJc2uSf0cEYYltojI4U3iCACi9ZEESCx8fpytJFzHU5mh7rHJN0HM
 kiwAI3atsH127fBboYp7JMCG7Nse59lppqH86gkERMt9N+6Stfyg
X-Proofpoint-ORIG-GUID: E1YCnlJFj5Jpf1l7eFHEs_G-FsLPPIHO
X-Proofpoint-GUID: E1YCnlJFj5Jpf1l7eFHEs_G-FsLPPIHO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDEwNiBTYWx0ZWRfX5xtKHhP+2z52
 +QVZVbeo2RZOEUgTOHyRZ1BvZDMkWzqk2CqF8H30XWJ+gTxRNAsiJmEF4H2lAdjHhOQ1IUm7jHp
 AQxL9bZE4cO1Pce4I67NnxFej5q6n8gIhq322XhM23KxgAUgECkeNvIn2vkKcnxL2Llcy+FQ/xF
 GCfn61Jfp58+Sp2JrgfiQRgTZPe6bh8lBWEocIDDHsaJUGgPZu0erxCV0tAMdXyl+1bGubT2FT0
 3o54fm2hDrBWXqPA7+eOaQ0Hbp7iYn5QXucfbZOcy6uVqf88XYs1YaUI6PBW5yflMCKIFFhV8S4
 zBoHuPWPes/4Gd+e1RBxQwTwFQJiq7vB+Jl+DZAktvtN/cHH+LCoYFqbWJzzDSgR34Uq9bXYaeE
 vaVCxKL5UyE0ZaazG+1Kvg48MFRIwMzaBujZHGUs6M7ue9yavCMFgE4sVgyyinXl1Zxoj+TuZBk
 VMAbk3qU9C70Y5Usevg==
X-Authority-Analysis: v=2.4 cv=H5frBeYi c=1 sm=1 tr=0 ts=6a4cdc6c cx=c_pps
 a=1HqfSBmQQ8HGCHze6/9uFg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=fTW__CHxibyLmBMfj2wP:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=HDdffg7VFn7s3dtop9IA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607070106

Hi Jan,

On 7/3/26 22:02, Jan Kara wrote:
> 
> On Thu 02-07-26 15:57:01, syzbot ci wrote:
>> syzbot ci has tested the following series
>>
>> [v13] ext4: deferred iput framework for EA inodes
>> https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.com
>> * [PATCH v13 1/4] fs: add iput_if_not_last() helper
>> * [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
>> * [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
>> * [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()
>>
>> and found the following issue:
>> WARNING in ext4_journal_check_start
> 
> Good catch. We need to flush the pending work with iputs also in
> ext4_sync_fs() which should also take care of this race with remount
> read-only (and the same issue with filesystem freezing etc.).
> 

Sorry for the late reply—I missed it because I receive too many emails 
from syzbot. I've now reconfigured my filtering rules.

Regarding the issue reported by syzbot CI, would it be better to add 
flush_delayed_work in __ext4_remount before sb->s_flags |= SB_RDONLY? 
That would make the race window smaller.

Also, should I resend the v14 series, or submit a separate patch 
specifically for this fix?

BR,
Yun
