Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012019.outbound.protection.outlook.com [52.101.53.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6000E3D9522;
	Wed, 16 Sep 2026 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789581842; cv=fail; b=JyR2rn9K2QqDndg8uUthHKJFrNMpFEFPrbYWRnYE0tCAY8Ls7GvIWtIucCGpNbgwRsB0fT1bQIikm93AFSKfb4KlsAV4x43iBMjymfl6yyIq65oyI2JWXQYYnCySzUJWe4fip9bITwYMYXZ6+lceZ6Ol3DjFhKvlKJZd6Nd9TB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789581842; c=relaxed/simple;
	bh=nE3zI2IP0+ajUZC7MqMfjxKhhIe33rg6J7TypDS5gRo=;
	h=Content-Type:Date:Message-Id:Cc:To:From:Subject:References:
	 In-Reply-To:MIME-Version; b=RG4hdeeuDFLcbp8nVemTVtNrRq4jnVKZofWGQiuUKrlOwdW+6dfFZnM/eHo6MVx28JbN5v9zdsUel0XM87rCpDQkwnMoYrT2qBoC7AjY2pXCLOvzGAMZtcaTJpsiwGdoF7h/ow8vIaKQEs+gX6jbfOu+3c7IOsASudshl7/acMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XC5yBv8Y; arc=fail smtp.client-ip=52.101.53.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XC5yBv8Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eejKA9zwZ/cfat6jhHTQ5/wRlbtsIOblZt67jMbntNkPrtG1imr+diB4UO1ZbzCVBB28AU2oDXwTatRqOOEymnB1oOfkewXoKqylA3qX4iDAogy7Yvmt9G3TEkTOkkNO/xRSiG6X18ZhUucS7WmvUxz/AqsX9JtBYetqhWvUIIQCILVALJNj420tNFGJfnm+t0VU55snNDckYygMeAsSnL//JcJqA6UW1GtsHWzH7BZuM3tLwoDW0GFXAXv872cKKgwjcrRmbeR8v4RIMyYWOVz9e3ibQLK++tPNkN8yJ1tPbgDVXNHVSAJBE34v/CZtdmsDOdsFbsOomK6ATQ7N6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhqjECNnIKQ3HxZfI2X4MMoijUlUGWqWsh+UQjuFs1Y=;
 b=cZQIpcrae3OCxubnSNDaBFRFaMLpy4OYHpC6iGCNAlFZb0sX9LEcrsefH4z2+kwLU6rPPVr/ITUN69EmGSM2ifgj1TtTk8VFfKXKGY2hLfF2tb12evpzTBgm0mWUb4FUNUaIbhL91SB+bxfBNgBOgLr0hKpN7QYnPWR0CO6m31GuT6guGbar06Sx+JKGJl/QfIf9VL7512pXITAB9L0Oc6OhOaO845FFrM/9mT+sOXNm+lnTn85mF8ZfSVG2/mGHJV6kFybUnRyhxXaifx56M7rpZDUyVIZpoLEJK19q+jbxRtEjy7oEStr4noN3pkvfTP1C8hDKXq6IRgQUoPiU6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhqjECNnIKQ3HxZfI2X4MMoijUlUGWqWsh+UQjuFs1Y=;
 b=XC5yBv8YZieHGkuGHwW9ojGJLNG5FVlAHpQb87cih3K9mEOeabtposINoKbdqk9VdG72vfJvLEYP9AQVJOxMJvlVFvja2IOalFvRmdTqhfBYAqEVgLShYQVhrVrAwwwc2eB6ix/jAsPWL6sD0X//AcIQlg+USbumZCt6p3rf5GXqJlbscgajwkK2ral5GZoIYgC2R1F7z45j5Q58NiW8iqFaLYJmZPkWSqFwnGNeyWTFCxsvqG7dMDAf1cLzlBeLvopFVJDlIz5d8iWAwfAQUpWF1TH3JGWFYBGpzzGKXXcJ9g6J5ye0Whzib8F25cfbwAlNkGj55x6UuOGesNzFbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB8818.namprd12.prod.outlook.com (2603:10b6:806:34b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 18:03:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 18:03:28 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 14:03:26 -0400
Message-Id: <DLGXT0ERY79Z.3C5DYVJVX6S9Z@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <hughd@google.com>,
 <baolin.wang@linux.alibaba.com>, <willy@infradead.org>,
 <bfoster@redhat.com>, <joannelkoong@gmail.com>, <djwong@kernel.org>,
 <yi.zhang@huawei.com>, <yizhang089@gmail.com>, <yangerkun@huawei.com>,
 <chengzhihao1@huawei.com>, <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Jan Kara" <jack@suse.cz>, "Zhang Yi" <yi.zhang@huaweicloud.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 1/3] mm/truncate: fix data loss when splitting
 straddling large folios fails
X-Mailer: aerc 0.22.0
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-2-yi.zhang@huaweicloud.com>
 <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
In-Reply-To: <xl2rtnntlxoxoozkddgrlkcsgukcngvvcwazm7gb7q5g32yxir@ef5ltcwueboh>
X-ClientProxiedBy: BN0PR04CA0057.namprd04.prod.outlook.com
 (2603:10b6:408:e8::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: e2e232e5-2150-454f-1c48-08df141ccf51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|18002099003|22082099003|3023799007|10067099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	5mz8pk5bXR6xYx5j1pAn8sMWOGHfH00fskhSL7i3ZZl6teVsXXzAN43Fk93ODH535GNvUEwSBXE2QgHVIKce8AMaSebsAnHA9z9zsGMphXmH4MLsLZTBVR1h6/ngXOMoHwAsfGVjFOEiIQeeKJHDpqImJhZvTyOiszlW96DpvJ9eHpBJSdYtfWtmUd3k/dzaKaL3EXqdfl4fdS2kBrrDGOB7lDP4FPx1E1/o/vJrKJ/HrGQ92EMqMTlIwen+3ykx0hqoAMGMABmYi3h35/nsag9+B/sfcviEzp9QJyit4Mt6Nv+oTkA281rE84VH23XchITsWf0OKR6AxTtL29CBrmoAwzytJ4W2XwknYvMgKCooEYOT8R4dObQlEMTH4KIXpniPFsjOdSbpISbyF8PHbGnKSTEfHSa/j728QB1R+wffY72TiWkVHB4y3JgvPwJHXzsnUNgS4fy9U0sJi4VhfVmC6Vqy5+A/L8HVe3mZfR3axgZgnkubcnTSjPc6Zyjhevls8Mksf64wZC5lvLKZpD+4QzSmGtYpJAbpRieYYs4Ss6zBoN0oVa/88sMo7JBic7RTbC2iJECyxdhxFwdrVXVR8ir+pPPoJWlQjqf6Vn/WP6YLVekk7RatjBt8jED8DhtmVIZz2Bjbgr+JJuhI82oTt83y1EfJpQpSYy/LGyw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(3023799007)(10067099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkUwWWpzT3dCalAwLzVjbG1LcDdOdll1Q25hakdTTXlvc1ljVXFYc3RzN3Qr?=
 =?utf-8?B?VVcrNUUxaGV0UXdoWnZ1MzBseGxmZFNZbElSL2sxYkthVnN6ZWxQWXZLOTlV?=
 =?utf-8?B?cmtTa01tN0RUN3ErVWlHejNZMjJjanBhak03bWQyU1hhL1lvVCsxTXBocHhX?=
 =?utf-8?B?TjlVK2xqZGJBT1pTdXBNcG1FZ1U1RVV2TGFMYmpWUFpjVzBaVUtzRERxeDhk?=
 =?utf-8?B?VzVUZ0pjWitqZFE5VHJES3pKazRKUTh4TTlQdTNGaWJzQ09QaGVCVDllRGY0?=
 =?utf-8?B?SFMwalRlTkh4ZU1RRlpPUDNIWEhHWXBrMHpsT3pqdnQ5UDBTb0RZOGQwRmZv?=
 =?utf-8?B?QVIwWmF1R002QkNHQUlmRHdJRkg0eW1nNVBTMUpFaWlyMmVnSm0ybmdkQU81?=
 =?utf-8?B?ZjhuWVlaM3hvUzYxdUxoVU10ODY1UDc3Q2VPNks1cXdFMVhBQmpBL3VYeUFM?=
 =?utf-8?B?SFRkaTE1QjlpS01UbnJjSWFZbGZjWEhGV0lDSmxJRUF4WmFzTmNzeHh0RXgx?=
 =?utf-8?B?ank5MDU5bzlPWHVhdGlCZVFES1pOelZVV241aTl4UmgySjZ2ZFhWbGdvRUw2?=
 =?utf-8?B?dUFSbkJyeUxlZXRlb1ZMVzF2LzlrUzJCbkRyTXNDelg0d3Z3V2UzOVlBOC9R?=
 =?utf-8?B?THlBRXBvdzcvRmJuOWtGVTl0SWxjSU16SkkxY1IzeDRUQ1RZcFYvT2ZaTTJY?=
 =?utf-8?B?NXdnZTZORDB3QVJTQTFFYXdwaWlyelNrcXNvS1h6cjA4M3VLMmEzdC9DcDQv?=
 =?utf-8?B?VFRVQndzeHFVODJPdVlteWdtaERVK0JRcnZZc3orUXJLaTBCMmJObXdvMWxJ?=
 =?utf-8?B?RWswbjNsNHQxSWFRcGJ4Z1dDTmZ5R0h4WnVzdUJJSjVPSWFEQVA0Ump3RkR2?=
 =?utf-8?B?SmxpcHMwNFVnSS8zZmhDWVgydTlsNHJwSjZtUFcreTZSSEhkVThZdTZrenFa?=
 =?utf-8?B?c29NMXlKdS9QRUI2MGJWWDhiWFRUaEl6SUU5TS8yd3BCaW1VczBHeS9qbGM3?=
 =?utf-8?B?WnVEZ0FTUVhoaHdneE0zZ2xPZHIra2ZEejVvVTBtaE5URExQOU9iTnYxM3l3?=
 =?utf-8?B?S3ltdnI2cTRsWE0wMzVucE9FUko0L1RpcDduUnc4bDBDMDBkemRIekZRQURM?=
 =?utf-8?B?V1YyYnVGZXdTRlBPOGtGS2gwY0NhcTZkYS9vcWptV2VxMXFXSlRiaU92Z3Ex?=
 =?utf-8?B?Rm9ESXA3bTN1UDRGZmVxN2lBMkVieWFNdmhQKzNUUlUvKytTZDlBYnhMZmNK?=
 =?utf-8?B?VG1FanNDTHVMSUNIb1JSUXU4K3VoWUtSeHFYRUh1bjJMRk1ZNXEvYzQrdWdv?=
 =?utf-8?B?SGl2OUtWNGdhR0E0dnpkWFZYZEJ2UjZpdTlYNm9vdHhrSzFwamRvSWFSMm4y?=
 =?utf-8?B?R3g4emhHTlRKajFoV0V2amxZUE1iTjNET2FqUk5GMThhMnNqOHFERmhGRGFO?=
 =?utf-8?B?QU9EVmJNSDVBNlNHMmJiV1Z4Wk5TdFRnNWlvbUhHUmhXZk9QdUdYaXJPcHha?=
 =?utf-8?B?RHpMNEM5cG5Yd3hhYnY0Y0dleGVnUEdsTkxBNGlKcGxxZzh0NkpPT0hhbGNw?=
 =?utf-8?B?WnhNS21ZaEY5QXhhQjJhTllNMEhmdDdpK3BOaHhXSXlIb00ya3BkdWR2Nmds?=
 =?utf-8?B?TEM4TUFFb2JQb0ZwOHlLcWEwcFh3RTRiQlBmdzN6YVc2L1g2RWVsdlRTY0Q2?=
 =?utf-8?B?OTFvS3dnYStpc1VOODY0RkZHZXpSK1pMVXBoWnRLTXdrdkFIREg0eUtOME9W?=
 =?utf-8?B?a0M2bjU0UDcvWHc0T2YvZGJTbk1qN1lUbW00N2F4MkNITDlTODYzSms4czZt?=
 =?utf-8?B?TjEvRDJDQ3RqUzlQcHNFUUpGUjRoMGVFYVE2K3FBL2dVYXdHenlndHRDdDFq?=
 =?utf-8?B?eDA3Tkh4NXE5UnlVNjZaWWJBZStmb0Zhd2pHNmkxWEdRRnVrNWM0bW9lNU5O?=
 =?utf-8?B?czVzMkp6THQ2cGk1dWIwL2E3d3ErcVlMbGlLcWFvSFp5a3NGeG1kMlFrOUtO?=
 =?utf-8?B?OGR5Z2ZXZ3pNcy85Z0R1bWxIZWIxS1VLbThoR0VwT1hYb0sxTTMzU2RlVEo0?=
 =?utf-8?B?VnV1eXV6dGRjS2lQR2tXQmpKRC83RHp3akkxYnJaUUk3Zko0b0RPM1IzV3Ir?=
 =?utf-8?B?ZExqTWxSUzRRZFA0TVcrRnJaVmNUUmh1TXJrQllCcis2RE5iNTNGcUI3cVhI?=
 =?utf-8?B?eVh5M214YXBWTDZTMTNHbFUzQUptYldzbUFRVEMrVFQwZXh6bUxnMU9tYTVN?=
 =?utf-8?B?OGZFOE95T2hrTXMxSDlJMnlXcTZicHA4YmNNRDUrNDdmeUxMT3E4M1p6U1FE?=
 =?utf-8?Q?mehb4ScisI2OBPo/p5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e232e5-2150-454f-1c48-08df141ccf51
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 18:03:28.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnDZNoMGYTXpFczhU8cWhh+xGpMGkK8zrwmxXZmGC29lGop3JaJppc3P3PER5cmZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8818

On Wed Sep 16, 2026 at 8:02 AM EDT, Jan Kara wrote:
> On Wed 16-09-26 17:24:48, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>=20
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>=20
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>=20
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>=20
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end =3D 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>=20
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>=20
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
>>=20
>> Rework the contract so the caller is told the page range to discard:
>>=20
>>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>     range fully covered by [lstart, lend] after any split (or none),
>>     i.e. the pages wholly within the range and safe to discard.
>>=20
>>   - Adjust the ordering of the validate check when splitting folio2.
>>     folio2->index is only reliable after the reference count and lock
>>     have been successfully acquired, since it may have been split
>>     concurrently, or freed and recycled to an unrelated mapping. On any
>>     failure to obtain a reliable end position, fall back to
>>     folio->index, which is safe but leaves the sub-folios split off at
>>     the offset edge in the page cache.
>>=20
>>   - Rename the byte-range parameters start/end to lstart/lend to better
>>     express their semantics.
>>=20
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>> &pstart for the folio at the start edge and &pend for the folio at the
>> end edge, so the truncate loop drops exactly the fully covered pages and
>> never touches a straddling folio that still holds valid out-of-range
>> data.
>>=20
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operati=
on")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>
> The changes mostly look good to me but I have some confusion around the
> folio2 splitting below.
>
>> @@ -259,32 +271,62 @@ bool truncate_inode_partial_folio(struct folio *fo=
lio, loff_t start, loff_t end)
>>  		 * for shmem truncate
>>  		 */
>>  		struct folio *folio2;
>> +		pgoff_t end, aligned_end =3D (pos + offset + length) >>
>> +					   PAGE_SHIFT;
>> =20
>> -		if (offset + length =3D=3D size)
>> -			goto no_split;
>> +		if (pstart)
>> +			*pstart =3D round_up(pos + offset, PAGE_SIZE) >>
>> +				  PAGE_SHIFT;
>> +
>> +		if (offset + length =3D=3D size) {
>> +			end =3D aligned_end;
>> +			goto out;
>> +		}
>> =20
>>  		split_at2 =3D folio_page(folio,
>>  				PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
>>  		folio2 =3D page_folio(split_at2);
>> =20
>> +		/*
>> +		 * folio2 may become stale due to a concurrent split or
>> +		 * freeing, so validate it before and after taking its lock.
>> +		 * If it fails, we can't get an accurate end position and fall
>> +		 * back to folio->index, which may leave sub-folios split off
>> +		 * at the offset edge in the page cache this round.
>> +		 */
>> +		end =3D folio->index;
>>  		if (!folio_try_get(folio2))
>> -			goto no_split;
>> -
>> -		if (!folio_test_large(folio2))
>>  			goto out;
>> =20
>> +		if (folio2->mapping !=3D folio->mapping ||
>> +		    !folio_test_large(folio2))
>> +			goto out_put;
>> +
>>  		if (!folio_trylock(folio2))
>> -			goto out;
>> +			goto out_put;
>> =20
>> -		/* make sure folio2 is large and does not change its mapping */
>> -		if (folio_test_large(folio2) &&
>> -		    folio2->mapping =3D=3D folio->mapping)
>> -			folio_split_or_unmap(folio2, split_at2, min_order);
>> +		if (page_folio(split_at2) !=3D folio2) {
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>> +		if (!folio_test_large(folio2)) {
>> +			end =3D aligned_end;
>> +			folio_unlock(folio2);
>> +			goto out_put;
>> +		}
>
> So I always found this folio2 lookup and revalidation somewhat suspicious
> and now that we're digging into it I'll ask: As you note in the changelog=
,
> by the time we compute split_at2 the page can be already freed and reused
> because it was split off from the original 'folio'. It can be for example=
 a
> slab page or anything else. So is it guaranteed that page_folio() actuall=
y

For a slab or unrelated page, folio->mapping check rejects them.

> returns something sensible? What guarantees we properly detect the "reuse

No, but folio_try_get() prevents non ref'd folios.

> for something else" case in all possible cases for which the page can be
> reused? I understand this is mostly a preexisting issue so maybe these
> questions are more for MM guys than you...

I agree with you that trying to split a unlocked and not ref'd folio2 is
flaky. And it almost does a __filemap_get_folio() like you proposed
below.

>
> So for me as an filesystem guy I'd appreciate some comment in this code
> explaining why grabbing folio2 this way is actually safe. The really safe
> way of getting to folio2 would be to use
>   __filemap_get_folio(mapping, (offset+length) >> PAGE_SHIFT, FGP_LOCK, 0=
)
> but I suppose we don't use the mapping lookup as it is more expensive?

__filemap_get_folio() is a better version of the existing folio2 finding
code. When I wrote the code, I never thought about using
__filemap_get_folio(), but I probably should have done it.

BTW,
__filemap_get_folio(mapping, folio->index + (offset+length) >> PAGE_SHIFT,
		FGP_LOCK | FGP_NOWAIT, 0)
might be better:
1. folio->index is needed to get the right folio2,
2. nowait can us nonblocking.


>> +
>> +		/* Split failed: back off to the head of the straddler */
>> +		if (folio_split_or_unmap(folio2, split_at2, min_order))
>> +			end =3D folio2->index;
>> +		else
>> +			end =3D aligned_end;
>> =20
>>  		folio_unlock(folio2);
>> -out:
>> +out_put:
>>  		folio_put(folio2);
>> -no_split:
>> +out:
>> +		if (pend)
>> +			*pend =3D end;
>>  		return true;
>>  	}
>>  	if (folio_test_dirty(folio))
>> @@ -413,11 +455,8 @@ void truncate_inode_pages_range(struct address_spac=
e *mapping,
>>  	folio =3D __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK,=
 0);
>>  	if (!IS_ERR(folio)) {
>>  		same_folio =3D lend < folio_next_pos(folio);
>> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>> -			start =3D folio_next_index(folio);
>> -			if (same_folio)
>> -				end =3D folio->index;
>> -		}
>> +		truncate_inode_partial_folio(folio, lstart, lend, &start,
>> +					     same_folio ? &end : NULL);
>>  		folio_unlock(folio);
>>  		folio_put(folio);
>>  		folio =3D NULL;
>> @@ -427,8 +466,8 @@ void truncate_inode_pages_range(struct address_space=
 *mapping,
>>  		folio =3D __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>>  						FGP_LOCK, 0);
>>  		if (!IS_ERR(folio)) {
>> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
>> -				end =3D folio->index;
>> +			truncate_inode_partial_folio(folio, lstart, lend,
>> +						     NULL, &end);
>>  			folio_unlock(folio);
>>  			folio_put(folio);
>>  		}
>> --=20
>> 2.52.0
>>=20




--=20
Best Regards,
Yan, Zi

