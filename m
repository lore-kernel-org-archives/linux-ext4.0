Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2B576EDF;
	Tue, 22 Sep 2026 17:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098069; cv=fail; b=twmKJyxklh+8vJ0HOpmPYH3reYy/8mM1d0Kpa3lBSkFpfW2al4V6U9rXvcON9ouFx7R40iv6eet+V7lX1zp/zRs4IotmbtqWcaAUKHj/memzT3wI6MY9x/PwaSXNrDuFMFNIgdy0rzzWgfPhrSpwijyqaSBQvia2yGs0G3RSbBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098069; c=relaxed/simple;
	bh=ZL2nF69xuHOsFsv5e1BWAoXhN5uaPrPim05k+d+sTRM=;
	h=Content-Type:Date:Message-Id:From:Subject:Cc:To:References:
	 In-Reply-To:MIME-Version; b=aryU5E6LXqEJC6/l2sGx1bAsoIAezZWqapIOnhCKfGnT53fExq+IC2ImBkAenNbGdfqS25UuYLckZxL/l+7BZjrkc5s+Pbgb1kPOoiZ7NwhzJ4pRyOQQvyJeyQmEbSecjXSS/qJAY7mxOEOPW2+0elRWYwGK6wPoAFmVIGRgIuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fnPII/u9; arc=fail smtp.client-ip=40.93.195.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fnPII/u9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwiuYs5pe8YiYgwMfAFel3DgOJj0/Br+X6XOlyPqKDEZVdn3CPIxDJQ/h2YDmFEDDDbg4JlZQ5+wbz73MqACPkV8IgiZgfa9uGwu1L14fJhsAf4yg+xtoKIS0W970MUD9zZ25rsxBOiEnDi9LV35gsKAvM+lktdGy1b9xyCaAqBODbumVwHPLSN3MdaAPYpRVVI2wgoYt/I0/hl2XEqkzHj8oeD2oUBN/SRaDU0H5YE57l+0Fv/jvfovXFeK77REZ3n1nVrJgHe1zy+T1aqshffNAsJwIVKIarhqstByz2LmypUeUEp/ZsUlmujttaPcCM1HZ9ZwXHJDBPCKXrPcwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yhkKQiwoFz+jV1o03qDsg74RQDfyIbvIuJeRJWRx6NA=;
 b=Uu1LM5c5c0bcHYqE8sWL5LQ7/8LYmv003Yw/N7nqC2wYRDwuDyLAbMGg32+nPma9b4tClSV1slnh05qa7CRCHasSK4yAVnYIq02RX3whKINSdkbvjBkkZn3znSSxvziH8WizZuBM5kJv4+2zxN4d84WHgZWDhr+FGCzw9yRYyUUQpCQrNgPPrtAQUUBlAImkrvhFTnrCYqXkc87usMvgrC+RWvwPo7oQNLSOwJuJUrngZQd9YgHF1nhf+Ji8MDOtvGEx4+/iXl5GRrY4rKo4lr8DGW2+/xcBxa3TZdaTlMZIkkA5NsZ9ZaLbN7sT63Zu3tGYum9jfglNT82DGKw/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yhkKQiwoFz+jV1o03qDsg74RQDfyIbvIuJeRJWRx6NA=;
 b=fnPII/u9xvBeXiGIrhf/6uekLjHkkIZVOpmTfUPR2o7yNdTfVCDE7m9yjMw1/aA8dOM1NOVaftR3tEdF2ca99O9w8nu5Hf9JtyH93nUxefnT89GpixSk5yx2J0DoM7zD4nkMIBbJNmUWC7CRMuMoQ6MzXt+W/F0f0lsVIRAvyGV/iYb+n9xVtmPmJm98GzvEt9tA+hsQFByMnzCxMkk1+Hu/eLZHowm+YzNE2a0ctaC6/QA7/MmtCQOk5P63YG4a+zx1OyADCdZt09jNveHZTmKGfMcQxJXkLK3xQDbckOTzg3riQXTzX/AEew9x2U9O8VLwS034bz4YEa478DyDzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6415.namprd12.prod.outlook.com (2603:10b6:8:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 17:27:33 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 17:27:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 13:27:30 -0400
Message-Id: <DLM0SRQ1LAMU.3Q4REHFJ7TETZ@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v4 3/4] mm/truncate: fix data loss when splitting
 straddling large folios fails
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <joannelkoong@gmail.com>, <djwong@kernel.org>, <yi.zhang@huawei.com>,
 <yizhang089@gmail.com>, <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-4-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-4-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: YQBPR0101CA0081.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: 910864c6-8c50-4bc3-5f4c-08df18cec92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|6133799003|18002099003|22082099003|5023799004|11063799006|56012099006|4143699003|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RFpGNJA6hI14zc4zDQQBw4xKTeHyCdjueDDNqpwi/OXKNSSRfLWAVl1Q8KM2jm1NxGs0kfq3hYMctYfvagvCwHxObh1nMLd57SJ9w4TXXKN9EM1Rli+Iv0Om/XFg4KcGRdW0f2WBfBlcGzMIGwIxphDXjEvahSXSRVDfn8IoPtQ5lLIL0VqeHi1iNeIw1p6SJ6mV+64IXfDmC1eM1RBz2CJMftMm+18tNrmj1lk4x0o+YLizQH5IHoorLaS+3WlsgLS3NwIrL4PXue2mNoib2J0BUqMVXI1dyEdO8Xiq+YCj3ZvPN9FK4Dy7IpqltE9VBbSQgiPaUuT2x9PiglTDkQ5XMfFM6Y7zxngZBTWMOCd8M8kgNzKJqx4Kvggq69Z7PMpLum/Jit+JVeKvXdlYHM3P/UoCjJXj+BtjQbOU6m9nfnhabGzCYT6xvx2L+//CykWV7lYHP6UE+0eLXwwa+AEkV2J+tWVP/W6gNXsqTjxY5Xb2CgaYJFi5Bzgu61jHJrtWc+1SFltl3VUIInH98Y1iS/vfnVxuYjNOoOPbFvWZAssQloSdR++1o6jCLhyNGD9V7LDq8QLF3hJaj2NhhrhmFN2SY4uUyGUWmhnnjPvk+eyXvidk4IJazCUvLvv57lG9QqTRxEW77JltKi2dDUQiOB9CI2pmEYvSkhFP5sc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(6133799003)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006)(4143699003)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTlJbWRoNGlWR0w5bzVQcnhrWGVoODQwZmF2dXdBRXhqd3FNRUdlRDR6UkJh?=
 =?utf-8?B?Z0VpcWpwOGVTVkdLZGxoUUFheUdCdkE1QXM0UGlKc3dEMHNZS09ucmo4R1JM?=
 =?utf-8?B?TTRsNmY0Z252ZVp1SjJoSG9CRzV5SGpVVFhlRkZpTHVnWkJLZHh3bllscVZP?=
 =?utf-8?B?OTR4RitMVWNiTDVTVThNL3hhT05EM3FaLzRzSUhKRVBXbGJaZmxXTmh5b0hZ?=
 =?utf-8?B?aTdHcGdWVmhYWm9WOGJqL1ZCQW92QmZMaWs3dnRWRkRrdnppRHUvT2JRQVZB?=
 =?utf-8?B?S2dlMHA2UHgzSVRSL2JWVmZYb2NGYkRxaCtLbmNXL2VvNk9sTGoxWWc1dWI4?=
 =?utf-8?B?RTFHenhDamRKTE9tMmFsOElqUEQzckVlZGp3U2xzNWdRb0M4bHdiV3pZK0th?=
 =?utf-8?B?bTFWbGZNajBTcWM1ODljSFBqZFZRWDRwUVpacWx4bEVuNVpFZWpHbFh6OFlj?=
 =?utf-8?B?bHp5N1ZFLzFoVmdFRyswQWJCYkE4M0tEdFMvcG1BZ2Y3WTBUaWtQNFFDQmto?=
 =?utf-8?B?T3dNTmg2Y2h1YlEvYlV0bG1wTVhvVTFGSjkvM2pZRmppUFFYWnNac25qU2k4?=
 =?utf-8?B?TGRDL1V1ZDJOWXlkNnc5ZXlZZGROd1ppZ29HM3E3NkdjdlZOcGhmS3owN0lI?=
 =?utf-8?B?SUR5c2JqZEsweSsxMHJVMjEwcWoyU0RSZk43d0EzSDFyRU9vL0hrOWVuWmZE?=
 =?utf-8?B?L1BOa09LeUVUaHNOYzhmdGo3VmUxcUhjY0lzWU15anBYTmtvN0Q2cUVPNlNl?=
 =?utf-8?B?REhJMzdycFdZMWRUZFlZTGo1QkgvL3Q1UXhJb2xzUDBydDRCMERYcmx4cHFE?=
 =?utf-8?B?N1Rib1Z1NU92Zm1sSEFYRm1SMXVvTjJDa0crVnBNWDZna2EySUZQUnR1ZkxF?=
 =?utf-8?B?SGo0QU0xZk4vUEEyS1FWWndjSUREWmxzVDlKcEdCbUYwUGs4MllzNnZjNkVQ?=
 =?utf-8?B?MHFLNjdBRXFYZ0ZCVDI0MjVHWVEvM1JLUFU5Qko1elQwUzViUi9hZEdMMmRM?=
 =?utf-8?B?L3M5bnZYMEhrSGJVMkVPS2JRUEtldWJDSHRqbjMxcFhheGlqYVVSMVpYL2d5?=
 =?utf-8?B?dUgwdExlRWtxQnJEUFBLc3Y0N3ZqZHR6T3ZyYXNuTkpNNWVhRFZEUWhIa3M3?=
 =?utf-8?B?WTNDcE81eTB6dTliTkU5L0FldEdPQzR1Z0NCMk1iU2w3V2FYSnNvUWxuK1J1?=
 =?utf-8?B?KzEvSDMxdU5wMzNCNFJMdXAvbEJLTVlONVNIUFM1TEFXUldBQmJiZVJ4Ulpx?=
 =?utf-8?B?UHNVR2o1RWtya3ZvRVFtWEViOXJ6VVZDOGFUaXNHbVhjS29TVTZhSm5jUWNv?=
 =?utf-8?B?a2phYUNMeXRITk85WTluYVFWalZ6QlVvQzFOZ09IWDQ5SU05Vk1hYzFEdVdT?=
 =?utf-8?B?V2ZvL3RKd3Rhclp2Tk94UmMxQWk5M3EydHFVOUpIRmVqWmNDbGwxMTVHS2U4?=
 =?utf-8?B?d3ZtalJSNG14ZlhMYWhuZmFCRTZiNUd0K2hEVkdpeDlTNlBkdi92TEgrS2hN?=
 =?utf-8?B?NWU1WEthcXlwWXdaZ3lYZFlTbDdhQ0pKRmxoaytkOEJyaDRQTmlqZ0hJMkFu?=
 =?utf-8?B?TC9kTzRHZUxwaFJMRFU3YWNuTXZodFZ0WnlLRkZieFlKdy84NHhwUGJJZ1Ux?=
 =?utf-8?B?U1dJT1RsMVVGNlpNOGVPa3VUd01ITXlBWDBHeXBjclk2YTV0M1diUytMcnpL?=
 =?utf-8?B?NU1FbW4wZWJ0d2gwOHZhbStUb1daYnc3Y1d6ZCtoaGNrVHZvUW1RRG1FMkwx?=
 =?utf-8?B?S29pVmdMZ0Ixa3hPemhtZFYydWl3Wk9pbTV2MStjQTRPakVhbnlVWDBSWkJD?=
 =?utf-8?B?b1kyR0tzYU5JamJlNXE5ZHE0TWpzY3BSZXV3c3hGTkZicndoVjZNbDA5YytE?=
 =?utf-8?B?bmdLS1FCdW1kTWJJemZ5NEVEalFXNUs1Q1hmRkNXZ1V4NElCTDMrM2hXUDdS?=
 =?utf-8?B?TmQ3OTUwTW5qNlpFN0JiOHBLQkxCbnVHSDZoNmxGcWp0b2xFTHJRK0xqTVVo?=
 =?utf-8?B?eG5ZMWQzRTEyZXVPUzRFZzRqZW55NmNQNlNnNDVlZWJSNE9jN1ZYL1ZFMytZ?=
 =?utf-8?B?eDBsL2ZSdEl6WUdTQytUN25NK3BsaFFOanJxS0lIZnBkM2JhY3hBRHpmZTlX?=
 =?utf-8?B?Z0E0cm1BUVRIYmJlNXNERDdSOWhKdWx1K0dDZjhnVW8wWHBwZDh2TjVJdloz?=
 =?utf-8?B?UmhDTWJOdTlBQ01zZTQ0RmpGYnRLbFBjWnljTTZ2WXh3WjM0WmtlMmx0QlRQ?=
 =?utf-8?B?L01RRFNKSW5QTDFNYTkwTGdsdGFUSFdXMHJNUFlveVpaaHBybUpMUTk2MTNL?=
 =?utf-8?Q?HR9e8ueGyugIoyl/A8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910864c6-8c50-4bc3-5f4c-08df18cec92d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 17:27:32.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpRZhJYFGJD5bETNnhdfxl7MIKXaxUjXkGhynLIgQYlc0Z+/SyCGufJHgcBVHcVk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6415

On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> truncate_inode_partial_folio() splits a large folio so that the caller's
> truncate loop can drop the in-range sub-folios while keeping the
> out-of-range tail. The first split at the punch start edge is
> non-uniform, which leaves the sub-folio at the truncation end edge as
> large as possible, this means it may still straddle the range, holding
> both zeroed in-range and valid out-of-range data. The function then
> attempts a second split at offset + length to isolate that tail.
>
> If the second split fails the straddling sub-folio stays merged. The
> function returned true unconditionally on all exit paths of the success
> block, telling the caller it was fully handled. The caller kept its
> default end and the truncate loop truncated every sub-folio below it,
> including the merged straddler, discarding the valid out-of-range tail.
>
> For example, a 4-page order-2 folio punched from offset 0 to the middle
> of the last page:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()      # same_folio =3D=3D true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 =3D p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end =3D 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() fails on a dirty folio and folio_split() aborts
> with -EBUSY before any split, leaving the straddler safely unsplit. The
> bug is only reachable on paths that produce dirty large folios without
> filesystem private data, and it was caught on the upcoming ext4 iomap
> buffered I/O path when no ifs is attached.
>
> Rework the contract so the caller is told the folio range to discard:
>
>   - Add pgoff_t *pstart and *pend out-parameters that receive the folio
>     range fully covered by [lstart, lend] after any split (or none),
>     aligned inwards to min_order, i.e. the folios wholly within the
>     range and safe to discard.
>
>   - Report a reliable end position to the caller. The straddler is
>     looked up at an index aligned inwards to the mapping minimum folio
>     order, and *pend is set to that boundary on success. If nothing
>     covers the boundary, discarding up to it stays safe. If the
>     straddler is locked by someone else, fall back to folio->index.
>     This best-effort fallback may leave the in-range sub-folios to a
>     later pass but never discards the out-of-range tail. If the
>     straddler cannot be split, fall back to folio2->index so the caller
>     keeps the out-of-range tail.
>
>   - Rename the byte-range parameters start/end to lstart/lend to better
>     express their semantics.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
> &pstart for the folio at the start edge and &pend for the folio at the
> end edge, so the truncate loop drops exactly the fully covered pages and
> never touches a straddling folio that still holds valid out-of-range
> data.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 +--
>  mm/shmem.c    | 13 +++-----
>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>  3 files changed, 68 insertions(+), 37 deletions(-)

<snip>
>
> @@ -251,6 +264,7 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)

Add more context:

	if (!folio_test_large(folio))
>  		return true;
> =20
>  	min_order =3D mapping_min_folio_order(folio->mapping);
> +	min_nrbytes =3D mapping_min_folio_nrbytes(folio->mapping);
>  	split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>  	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
> @@ -259,34 +273,57 @@ bool truncate_inode_partial_folio(struct folio *fol=
io, loff_t start, loff_t end)
>  		 * for shmem truncate
>  		 */
>  		struct folio *folio2;
> -		pgoff_t end_idx;
> +		pgoff_t end, aligned_end =3D round_down(pos + offset + length,
> +						min_nrbytes) >> PAGE_SHIFT;

<snip>

> +		/* Already at the minimum order, nothing to split */
> +		if (folio_order(folio2) =3D=3D min_order)
> +			goto out_put;

In the above, folio_test_large() is used to determine whether folio
needs to be split or not, but here folio_order() =3D=3D min_order is used.
Should the above "if (!folio_test_large(folio))" be changed to use
min_order check to match the check here?

--=20
Best Regards,
Yan, Zi

