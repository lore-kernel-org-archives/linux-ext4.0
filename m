Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012046.outbound.protection.outlook.com [40.107.209.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AACFF3909A9;
	Wed,  9 Sep 2026 19:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788981510; cv=fail; b=LV9cSX5vFzofNKAWskUvr+I2bbPowfpDuxwny5dwVacoaQs+feZMpIxg+8VdJJRgjz6mTQziSPMeSAAC54k1WcSenhe1sAhskCAAwHQai9/eBJNPgBGFU5Dj2CZxAhpm6Ea1jNz6NU2o0gxQynfkX/MxTkZ9z+TmS1nn96R3dUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788981510; c=relaxed/simple;
	bh=eqtTNBsuNz/AbIrxINTh3IkRXUwytwELxmsbXl2tZS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cOltp+ItKWB5z/JPSjFYYqlbCLdyT+jAXvdpcBpmutUXWiH7deujBn9KqxZYEn3m3h9/I+sHsZ9876m9SAii6P7npHpJyKYeTmO2jzQ6Sp1GgHTwW7vtQBWUJFlu49pZNv7UkgGIOWsjomqUuUcLvIlFaiK4E7gpK6g73tGkAts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aAX/Wmph; arc=fail smtp.client-ip=40.107.209.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aAX/Wmph"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukmCwRqK+r3YYsA6/gQw8Owcd5uNbVX8ealioevAcMq8Tja0KqRJl7i6Ha736Ntu8BjMXx/mCwx9xhmmxB8KEZT32IQhjnbsVFJkjb8TqXgBMv1Hl73D45mYEh9qUBNIB7EjqalbjPym4NPU7jktcemN3NCjPhUo3GyIqyC3tsSRolA0O+0WEvoPxreBaBLvvVosfYTILdOCW+v9B9kS8qG4/OilYDeU1joevW7/RTE8Cz+H7BU5+ehJiWh7eu2Z/EJUzwyA65yTyoQN5xo64DAw6MDqMxXhd4241V0wV6LY37nNe/2EuCz5OPCgrPqlzx4kXgGWCEVGosMc6LWr1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJEq536MlzWpFQuYNdRP2gLcQQ/2eCj7l818RizapKo=;
 b=xQrraDByiql3T5uW0efxXoEKp60z617B3N86ePrHOEzvrecYIQ+m5t8XMpT/sraTb2PrIyc3+RqXILuPG6SZVdC/HrRQWnHdAbQ55r0sFt/5TNbgCep1gfprQxrpgEMj8I2E77JTqKwjfemnf63nH2dy2n5iivcOolLqvIyl43WSgo64lmno1+/zG3qGgJYhtXNQxTzyrURqpCkf3b+L16uKS8VA3G99mL+Xybzv/X4Bt7rPL6Rlh99EowatpXu46BwqYYToeUszNDmQhHngdpZkmk9UfKasnKFAa6mwpKK2fqRsochWfzZVafUahaAPfDTCMcIS2YgGH0OTlvtwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJEq536MlzWpFQuYNdRP2gLcQQ/2eCj7l818RizapKo=;
 b=aAX/WmphqFw0d1v4NSXh0N66mJ0Mewz0zXesyejI7Pi4z9mZGr+b1/VQ6aDA+xlDDzbkyYQcscWGweDND92B6ln33LckEQvCzkaYpgOVpQDU8c8rxrCOOAin2WvcP8wVRLJ77M0XnRyrEnEwpmvrukabq9ItYaqdZKTYg8YoVpCbESB/TldE8dlfjPqGsK6o/iqvnO/uuC+lO040ywXYRG23K3B4i9W3bysoNl5dJ/mHeiCESlxR80G+wsyRKAV3JoBsMiAnEgPUgGFBDe5j5KBlpm0xdpW3BEwjDH4LDqGwjXghzxEuxSc9+fKEbib8lO+7nQOe/HOvU4xWiZUVhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BY5PR12MB4180.namprd12.prod.outlook.com (2603:10b6:a03:213::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 19:18:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 19:18:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
Date: Wed, 09 Sep 2026 15:18:21 -0400
X-Mailer: MailMate (3.0r7028)
Message-ID: <6F18C9FE-3599-4C6E-99F9-767BD7AC8E3B@nvidia.com>
In-Reply-To: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BY5PR12MB4180:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d6fb7b1-5fa9-4124-0f24-08df0ea71cff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|10067099003|6133799003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	I2rA4Ze3ZAqUL1WWmu1F1ArqgJeMAtqLB7EpyJHLHFbOArP3K/TTWhNm5v8oykMN+GqH0DCPeB8klXrs33aQGJequ3p2IwWrjOOmDKgooW3qMd80g3ge0SAAQ1rxx3aniY2dUPVL7CFjOaz3MCznHvnz700xgyQbSP3KIY4BnITN25B+SB9EeLndbgRX3cZOZW5Uk/x1SJs2CbhDmqLEh8TWdep9Ql+MMCC6v4pKezgAKK8vpH1eAx5GFibyJ81dJ7gtmIcU1c8NdZuaDzM77nj9EiJv4+GB/54woTz+Zzlz23746GNaHyW7fKh9XT6SdePy8WJv2/Xm/tn4vYAPlJalT9REHf3LUUJHEHcG6IuTNmQqqA+4UyUA34OzFVscNBSYyVD2FxKxEGYLeNcRO+kRgrMn1MWi8iucuoJQzjWjNnRIjzsu1WY2z+DFx7zehvxO7Kye4R5suQ172SE4QAB2wrb+BEyM7asGLuoyfRX9NFGCqgAucfoWbvYDsLGFDdi8zFxqgk/obGbxsLIWM1TGVJcOVulrZFnBQErfs+3AkN8Lv5MuN+aew8TSbapfxKQdhOyDOh4Uc5KTQQIMSfEcXTx+jVofi5bcrJ/EnfX2lYAGhXvVpqYpUoENqaIWOlAw1zIW/rrDjvTjKs8ZyzJxeD+va01AJzqUYB+N8Cw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(10067099003)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eUvi0nXnD1/Kikb5lrmWNT5sJFhA4ufI2mn+bxeaBn6vk6HSGHffbxC7U1IP?=
 =?us-ascii?Q?jQPJ/31Ujd/vBakq7GDAnXD4nPVC8vLwI2YUk0fTH6C6kkRv5ZA2CV3LY3iC?=
 =?us-ascii?Q?tzJOEIfLJzVeMsc/aj+Q83WeTJmg7w2VKL8Kq0fzYl7lEjxzHVKq2crDDy/w?=
 =?us-ascii?Q?OYZdGiWt56BSoHw6Epxa2JK8Xx8Dp/7619nL8toXZYGxYsVqsdJSROFV3W7S?=
 =?us-ascii?Q?tXzuELXu/AX3ighKkmHUWl2xYnUr7LPH9bK3ZAkf/84qo9+ImCaxs6RQYuL9?=
 =?us-ascii?Q?fz2UG02aOjEP74ziMYTJjwJbsyH09kOl3ZuAYylU5ishZaEIKGc3QWyg+HFQ?=
 =?us-ascii?Q?cTTSfAMY8UPkU6i2DEiKs7r6Ib+Oar2UX1VYjAmlI3b03a1Runo6ZhwBW3sk?=
 =?us-ascii?Q?iO97A5cvNfF0wCuGWX9eay1t9oJtBHdROnBH4T/QhpDpjrOIrOqCuo14DeMe?=
 =?us-ascii?Q?qeAo1P+xq/PP00Nx6kkJlNq6gKK9duzx3UmufhmWcgP+vS4+srpicX6YmS/n?=
 =?us-ascii?Q?E5IepBNPeVTKYDfGdKvlA9kNHRc+h11LcE5THi2IBGGoMJ6hY2Al3brf9A2I?=
 =?us-ascii?Q?ENGaW53hF45GzcAUCtAO/Kyvb/BAt3XY6uDS2KR75jeSd+rARQyVtBnnuyd0?=
 =?us-ascii?Q?s8RhgIqxm7qc7A9Yz6Echkck2GxNrI5pcmwkrHM9sDAJK7qnYXzXWXkYypam?=
 =?us-ascii?Q?kiEcOh0lxfRBpjVSaWUCDWZl6gP45NtimcVsDw1e+UzaKGA94X5d1oDsw/VW?=
 =?us-ascii?Q?Y7zwAclQ9bJ/KplpQ9XYNBqDTftjOQggEMyzBTQSvE9PBI8nHl4gqK8/y+Mq?=
 =?us-ascii?Q?FZnT7EdrPmFnWrpN7AFKlvQMUrIML3yk9kADukn9XCQ0gDQB5tj3poEm9661?=
 =?us-ascii?Q?HC5PdpGyea2KoPRNIwDinidD9GrfqDDSTIdre4ab1FxtNnG8M5OP0/rDzr+l?=
 =?us-ascii?Q?ulxUMX+7uR9TqlJiyZ9kNyxLKBtV39euCc8dXJs3QGfO79ihJOYnqykDSehJ?=
 =?us-ascii?Q?kD9WNPU5aB/RRBb9AGl3T+7q6ElyzByc34OAfBx/pImQlA/kqPo2rzuPfPsk?=
 =?us-ascii?Q?3lkYa4KRUjsC8YcNSnHg5bJ8RDMvL3FoxLjx4O2rmhk2ALvFgbRAOHkf2QYG?=
 =?us-ascii?Q?aRg91GJyyXsL8fFAeoLGJ73B1TYjXuMSnuZqF6+4PnylwmgwAnLdY40Jopqc?=
 =?us-ascii?Q?2hCyey0Gsm17hrlajqZQvUGe7pg2Tb6/h6PFzz0dfiisn7iYbBUZnxpNzM6E?=
 =?us-ascii?Q?edK/6JgjwaARvbmc1QCZ44fND/WFlQgqcaUXjFquKHcXf9NuvDzZOIEFriTq?=
 =?us-ascii?Q?D7XySq9u03atWfcEeZcqy9GlLFKAJPRxFvJenKiWUMRIPeZCBTeOrP2Z9u4N?=
 =?us-ascii?Q?5lteuDi/QFXPTacf5szyepqkAy+cTSuY5EMULNpGQaiSI8fcEarr2Q+NFU88?=
 =?us-ascii?Q?Wbi5YDXlj6HlOLOjfx/ceW+drYHcFZtSzW+wwUCcwM67LwFiiGroaSYBEI3Z?=
 =?us-ascii?Q?sqhlRepNk7jBxDAXgqp7U6lV8jH/RdVQ+/ZwkUQczXFwlPhQ+wUBRFU3w7zp?=
 =?us-ascii?Q?m62OaApPT1XLnQD6kqcRoM0z7T3AniqltyMpZBC058WnyXENW2YsyZQm84Sy?=
 =?us-ascii?Q?o3TouQ3A3DhwaG2OOmGHpgtlmIcJSdvBufpgrGx1tnELyRl+TqMyUARvqRS7?=
 =?us-ascii?Q?ZNRoSyRNWPq3WEYtBdyGkekI/HqacAhtYSFiZrKOTWNVi1j9XVp9FNWWiLeT?=
 =?us-ascii?Q?8nUCVP2c1Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6fb7b1-5fa9-4124-0f24-08df0ea71cff
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 19:18:22.0594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RRE1oDmMTG1YWqTA5GujCaKdgMguIx2IqXzIJEZte67vPgJRpAfvhTOyI/bSZY96
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4180

On 9 Sep 2026, at 2:23, Zhang Yi wrote:

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
>     truncate_inode_partial_folio()      # same_folio == true
>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>       2nd split of folio2 fails / cannot lock
>       return true                       # BUG: caller keeps default end
>     end = 3
>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
>
> This became reachable after commit 7460b470a131 ("mm/truncate: use
> folio_split() in truncate operation") replaced the atomic split_folio()
> with folio_split(), whose non-uniform split can partially split a folio
> and leave the end edge merged.
>
> It has gone unnoticed because a dirty large folio normally carries the
> filesystem's private data, for example buffer_head, so
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.

Thank you for fixing it.

>
> In addition, even when both splits succeed, data can still be lost when
> the mapping's minimum folio order (min_order) is non-zero. folio_split()
> stops at min_order instead of order 0, so the sub-folio containing a
> split point stays aligned to 1 << min_order rather than to a page. The
> original success path left start at the page-aligned head of the range
> and set end to the exact page index of the end edge, neither of which is
> a folio boundary in general. Either one could land inside the large
> folio at its edge, and the truncate loop would drop that straddling
> folio together with its valid out-of-range tail.
>
> For example, a 64K (order-4) folio with min_order = 2 punched from
> offset 0 to 36K:
>
>   truncate_inode_pages_range()
>     truncate_inode_partial_folio()        # same_folio == true
>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>       end = p9                           # BUG: p9 inside [p8-p11]
>     loop truncates ... p8-p11           # p9-p11's valid tail is lost

Should min_order > 0 fix come as a separate patch first? min_order>0
was introduced by commit e220917fa5077 ("mm: split a folio in minimum
folio order chunks") and it is before folio_split(). The old
split_huge_page_to_list_to_order() can cause a similar issue?


<snip>

>     i.e. the pages wholly within the range and safe to discard. They are
>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>     order so they always fall on a folio boundary.

Basically, to fix min_order issue alone, truncate_inode_partial_folio()
needs to align pstart and pend to 1UL << min_order?



Best Regards,
Yan, Zi
