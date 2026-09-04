Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753DE4A0F17;
	Fri,  4 Sep 2026 19:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788550286; cv=fail; b=t69iuEedl61AK1d08i+Wxa6MJQJtQNIotuxBKPDzQih4eFCbW3Uaj3WeRQriERR7hfZImeMrFtMVQ20NcTaGVgnjBUarhpFoBhuRZjrmMItG69ejEkrP/HbHX4TdBdYZdoS/nxaTq/y21Z8TQtkzeqp/MIl7Y0NW4/faQ+D+lVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788550286; c=relaxed/simple;
	bh=7o59YP7x1vDWrdI1c2KIwuhHV+TKcrrB3hvFAQZHN64=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=pGoLuZ/UDoDAb+6SlhSWSxMU7iVlR03+EtMd6XfTruAkE2UrX8X5fm31wNki0MaBsCLBaKnMGxuRjwvqKHb2oI77zMr9o9Vidlnco6LWFBlq04SqLarsp1HAZnZN5se4+qaDCWAYaFV+NSN+Fc2mqBquxKz/bUux4LU9ibwkyOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BURWUD7e; arc=fail smtp.client-ip=52.101.56.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BURWUD7e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojx3efZwh9PubgWnz0/+dD1RHvpugiTBZZ6mEvm0V3Vz4AbFoO9/mAUEKHLbsc1ixulzlyykLGHPo3bdEHzSWJYsaGKIiI2dkpFuzNT9zvc25nT7Rq8eJbs/Wg9MpiS7kBmkxS7zK6rEB38NbQYJq2gvOr8kLK7qW3/IwsM1L+Miy45Jx4KXl+rV53l59MYErk/ck/49xmMu41+rhlqjQoLfL0xXvxmaUZkO7w0FzLNbrJ2l76BDv29LF/bKFXBYwVwEW2xPdfbLtATSS3/y1hy28JvMBjBPjEotx3w9oDF9CyZrq0dZC+ADb/NAF9dOkOT715/KAp0ujNHiknacLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQfK1t3ARS5yaVkHM6he29FqcbJMCK4QOYVuKC9lxac=;
 b=s+TD0E5UfugiFs7IAsyxIIup7Gab0b8GLX9yLGF2EU575mKJKMhKwYbZwwLPm9OF7LCneGjjtkvBSZ/97wA5tJyAqMm+t/rxj9pASTbb70Szq2ZkJLJ/f+NYhELhuPrTYE3H+0AfcbfsTNbJzrQhSbkjXw3m6iu7xOSr1Eu4Iscqj6KyyZ9XCv3C5toBCnhINph4vpkozcKxPw20ozFgjmcqezKPgZN3TO1YNf0LkTjEdNz8Szk727KJ7qm9GgciZMMMxL2ypldihibQzJYj/gwT2eLuaT5DSU6HMGmwBJp6LadnIaeiYdDyiT1tTCBxMV/a/s+T+0nM3+KtKzXk4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQfK1t3ARS5yaVkHM6he29FqcbJMCK4QOYVuKC9lxac=;
 b=BURWUD7eR4uvPA/v9h841CS41Y/4CF6eZzUD+WUcIMwPPx2QnK/yLl6drNF5SU+/dYNHH6+rrmp4q5l1M8zYAhjpfbwOV/rxkQYGnfLddNfyftusKMzY+d8tTINY1sUwAR59werToL0uNMu/ZhdxC4CiC7uOk4a7smffRc3JTssNwuYyvLA3CJ6xvXWc4RCAzmevDTwwrY3zMvokOWyOL8JEbqfxWfY6J+XbNtBDTm1/QfkryoRK/3Y0ayPLQQnmU2lMjCFQuVqY1w/zmWhgWDBac10AVAvEBg3MHog5amobHR/ON9gAKzlSORw85MFNI7SC8OhJlwOEdAd9d52WzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7545.namprd12.prod.outlook.com (2603:10b6:610:146::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Fri, 4 Sep
 2026 19:31:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 19:31:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 15:31:02 -0400
Message-Id: <DL6S5JLBHSAB.1RL17ESZ1EK10@nvidia.com>
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-ext4@vger.kernel.org>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <hughd@google.com>, <baolin.wang@linux.alibaba.com>,
 <willy@infradead.org>, <jack@suse.cz>, <bfoster@redhat.com>,
 <djwong@kernel.org>, <yi.zhang@huawei.com>, <yizhang089@gmail.com>,
 <yangerkun@huawei.com>, <chengzhihao1@huawei.com>,
 <wangkefeng.wang@huawei.com>, <yukuai@fnnas.com>, "Joanne Koong"
 <joannelkoong@gmail.com>
To: "Zhang Yi" <yi.zhang@huaweicloud.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
In-Reply-To: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: BL1PR13CA0353.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7545:EE_
X-MS-Office365-Filtering-Correlation-Id: 59af2a5b-3404-4096-c47c-08df0abb0eb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|3023799007|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	+bsJZ4wUvkbyV9vcij+UKqa7RWskR6ScWEoKrXqmXUzNsQVuHcCKp9tjhCghBIYQet7Y6tzNWLwFwKwC68deY7XLb6nrZKj1Q2WGW2Z8sOFrj7UR2gKQSVhmATVwVFbt8lqH7I+zmTMw8H++A8evkpClbQeAMNba56jr8QK4xbvTL/VrGio5ZZhf51NaclXTsUghmlJgGGymVX3TFgDAbtoxz5f6UEAmoydMAhc/ElKAxPnqiFMPKYV+Z1QMsEfQnkGRTGAK1hqkxkEBQIjII1P3dYZt7bY8NSOavtLRTIGZzQzuiOwx2w7VaS1nbBuETej0uRo6/5nxuqxXcUvjDJxbGsGce1vxH3oP3VEgAvF5ivRC7dp3b1ZVt6VFRRYq8e/YVoPogmI9wrgbCShdegfKt1e5C2tZbrEDpipp8Oxws0CAXb2TT2LrJwaysqv89vCidbKCbUcs2458ENtKvLo9bHbOn0F16VT4PmyH7E/DlldqRDzjbBKGfZo709mR14aGh4wfkERasNsCHgMjetnqx9nsgZ7TodTQrBPgqp8fK6U8HNl0Tf5siMNnjcKgcQqY60R2DGnRS7rv0xmdrS6XwgBxqJbJeJh62AmiUssnLmveP8WKLtit3WlVqR/yXny40/Dzvih+PhzP1aAtThjNUujJgCNdK9KM3m+C1o0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(3023799007)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVVUQUFDcGxyU2JsWjZKMGdTSVl5RVkzNkFBY1E2YkFBMzZPL3lScS9vZjVq?=
 =?utf-8?B?dlY0Tm1wRWJZdHlKVDNRZjFHNHlNaVNkdDJ2UTNnRGNhN2diZFRBaGlubHR1?=
 =?utf-8?B?SkZNSjhUYTdvLzZHRU1ta1RHTmVSZzBRcCtncWFUQjZVVldsVWRtTTNxbEQ2?=
 =?utf-8?B?V3JxbUFPbVpOdXphdU1WeVJ6SnBoWG1RdGZhQ0todUo4Z25tZEZua0hKaTA0?=
 =?utf-8?B?d3NIM3NQejBXZ2NQTlJCcDVoU1hhTWM4U2FTdEVVcjFQNGRoQ1k3YjRWUi9I?=
 =?utf-8?B?REJmOU9qb3RkWDF1Qko2MkJRN1hGMlRrNkNVTFFOaGlSL2JhQmljazlXMXlE?=
 =?utf-8?B?eFgyUGZKeExHTzRpL1RyanpSdU8yTEZzQ00xT0dRQnArUUpYRTJzVlBPVVQ1?=
 =?utf-8?B?ZjZrejhKQWZPamRmRVlkWmRNcVJlSnR1Zlc5QjdRUXBLUUlSNkJWcWpEUHJS?=
 =?utf-8?B?SXdZTkRVaDQzTUdPaC9RL1ZsUWwrWHRqcWJ3UUY0S1BvZ2M3SkxEbXBCZDFM?=
 =?utf-8?B?LzhzNVRaYy9XWFV2L2tIZWV2OVNJclZvRVk3ZGlkSE9kdnVsV3htODVIM1lC?=
 =?utf-8?B?aHlWZFAxdTh6a1dtcGZ6VHVsL2dxM2J0SGx3bDJzcERVV1pacXpKN3YzTERm?=
 =?utf-8?B?TWl3WE1ZVXZNZTZQYkE3NkV1bi9RUkdWSGUxa2ZRZ29BYmNnUlhsYlA3eVJh?=
 =?utf-8?B?ZTNoV3Y2VStQQ2E5VjYwZExreHZJMVkwMDQvampSMDdGMHZ3MTFvYXdTejNJ?=
 =?utf-8?B?TFh3ZDREck9ON1hDQWdiQVZXeXVLbDI5VXhmZUs4azNmRWRpNTVIaXFxZ2x4?=
 =?utf-8?B?alM0WmdnblY4SSsvd0lDaXEyUVp3c2kwa3paQStXRHJFRGs5eVEvMjhMaW91?=
 =?utf-8?B?UEdHOTAvSWxqQVNuQWZ5Q0djT21sS1VXR0dKR2wwaytLOU5NYTRTUllUQzRB?=
 =?utf-8?B?V0NMWXJQTk02U05OOUNXUGZvQURzaExlRFZ1dUE4eEx2b2VhZ0xZN1FaSkky?=
 =?utf-8?B?Y2ZjUWxyL2hrOEZXL2w2MzdaclBXSUl2dTk2L1E2TU15S1M5SVB0SVpobitZ?=
 =?utf-8?B?WEd3MktaUWZtZnJSOXZNQ3JzTWtTbzJtSUp6ZUtyR0owbWx2b0dYVWV0OTdr?=
 =?utf-8?B?OEN1THpUaXBFWWU2QmtQd3ZDMUhuNlhXdmJBWmpJdm1jZC9pU0xwK0c0TDRD?=
 =?utf-8?B?V1BKcGxRaVFoa1FaN0tFNGhtWEJVN2xscjlYcGRucXoyT0pMemJJRTFUY0pQ?=
 =?utf-8?B?WEFlWTczR2ZuNEFKN2xLWmFmSFlZSkxoci84UnhyRU5wVmFmRTg2QWhoWFcx?=
 =?utf-8?B?dHpacWhabWZ0VFFIL1dHa043ZklwQzVrbVppdU1HcURDUE5HampCS3p2aE9P?=
 =?utf-8?B?VGdEejdnMC9CZXJmWFBOTWRoTGFTNU15SmoxM1NUQjZOUFp1VTdsb2s0aml5?=
 =?utf-8?B?WnRQOVNwMThlZUx1a1Z4ZWcvaUQ0ZTlvei91d1NaMTVMdXhxcDBZRis1Ukk5?=
 =?utf-8?B?U1h3SUd6SDRDS1hhY3ZlYldZUUQ3SkFuMjRhSWdrZjFTc0EvZXJ3OWNKbHlp?=
 =?utf-8?B?L2pGeWJ3bHQ5OG41NE10bzZmNXZvRXlaaWV6blNzZjRDNGVWRXplazVhTnYy?=
 =?utf-8?B?azI1bXgySUo0RllZU2wwQlFHSEY4aTJjYWhHTVQvcWxUNzZNc05HcWE3YU8w?=
 =?utf-8?B?b1ZCN3BsclpKdk5CLzRCOVpDOFZPc3lsZll5a2JNNGFIckg1NnNmOXVCQUdu?=
 =?utf-8?B?UXJaK0NZRkpPR3pqUVBadk5NMEVUWWlibjExQXp3anpIdEozZ2F6Q3JTNHV4?=
 =?utf-8?B?SXErS2orSUNyaWhMclV5OWNjWGtmVHo5bmFpREpXK3E3ZkgrSlZQNUd5VWxi?=
 =?utf-8?B?L25FbVV4R2g0NU43ZVIrQjFhYlk4a1ZKNmxVS0IxRFFDS0VIc1MwM2MyRS96?=
 =?utf-8?B?VkFDQ2M1TSt2cTFGdU02WlU1RFBhd1VNSXZMckljUS9LZ3FVSjZDZUN4QXpk?=
 =?utf-8?B?VGRPRkd1cEFPM1ROV0pLV3FGTE14a3NhbUJUNDZ6WGFEdXVuVm8zdUcwTXJw?=
 =?utf-8?B?ci83Wm9SMHN0dlFwZDMxWGxvWVFsY2lxZkhLSWJOVlUrWlJHZm4zYlRCaTA5?=
 =?utf-8?B?TWhEVjRrdGFjTnVqQklqZVVkL21pRFViRDQ1Qi9UejJKNnNNOWtqejRXcGRm?=
 =?utf-8?B?OFQrd1o1ZWhMSFF3TnpmeFk3dFlGdEpFbjQwVEZEMUFTWU5SVHRUU1RUNlVF?=
 =?utf-8?B?L24zNnFIY2JyVmVHVW1LNGwwSWlTZ3dFL1ROS2VHSS9Dc1RyR0MwZTM1VXY0?=
 =?utf-8?Q?1pc/zkDLbbKSUhRbH+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59af2a5b-3404-4096-c47c-08df0abb0eb5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 19:31:03.3338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoZPOtgJQvvJJx8R0oezm5NgHU3EkQMMNq0DmiVGXsFcVFCz/0cxFOngT4VOo11q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7545

On Thu Sep 3, 2026 at 7:50 AM EDT, Zhang Yi wrote:
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
> filemap_release_folio() -> iomap_release_folio() returns false on a
> dirty folio and folio_split() aborts with -EBUSY before any split,
> leaving the straddler safely unsplit. The bug is only reachable on paths
> that produce dirty large folios without filesystem private data, and it
> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
> attached.

Thank you for the analysis.

>
> Rework the contract so the caller is told where to stop instead of
> silently truncating the straddler:
>
>   - Return true only when a split occurred, false otherwise. This
>     clarifies the existing confusing return value semantics.

Should we do "return false" for not split case as a minmal fix first?

Something like below. A second patch can optimize on top of it. Let me
know if I miss anything.

BTW, Claude also mentioned that if min_order > 0 and end is not aligned
to 1UL << min_order, there could be some issue. So

ret =3D !folio_split_or_unmap(folio2, split_at2, min_order);

should be

unsigned long idx2 =3D PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE;

ret =3D !folio_split_or_unmap(folio2, split_at2, min_order) &&
IS_ALIGNED(idx2, 1UL << min_order);

?

From 564fd753071be9d59d9e45e4609a812bb81f778a Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 4 Sep 2026 15:25:06 -0400
Subject: [PATCH] fix unsuccessful folio2 split

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/truncate.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be474..2c575f5e61889 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -259,6 +259,7 @@ bool truncate_inode_partial_folio(struct folio *folio, =
loff_t start, loff_t end)
 		 * for shmem truncate
 		 */
 		struct folio *folio2;
+		bool ret =3D true;
=20
 		if (offset + length =3D=3D size)
 			goto no_split;
@@ -273,19 +274,23 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
 		if (!folio_test_large(folio2))
 			goto out;
=20
-		if (!folio_trylock(folio2))
+		if (!folio_trylock(folio2)) {
+			ret =3D false;
 			goto out;
+		}
=20
 		/* make sure folio2 is large and does not change its mapping */
 		if (folio_test_large(folio2) &&
 		    folio2->mapping =3D=3D folio->mapping)
-			folio_split_or_unmap(folio2, split_at2, min_order);
+			ret =3D !folio_split_or_unmap(folio2, split_at2, min_order);
+		else
+			ret =3D false;
=20
 		folio_unlock(folio2);
 out:
 		folio_put(folio2);
 no_split:
-		return true;
+		return ret;
 	}
 	if (folio_test_dirty(folio))
 		return false;
--=20
2.53.0


>
>   - Add an optional out-parameter pgoff_t *end, set to the index of the
>     folio that contains @lend and must be kept by the caller's loop. It
>     is only written when the folio actually straddles @lend. On the
>     success path it defaults to the page index of the end edge and is
>     refined to folio2->index when the second split fails to isolate the
>     tail.
>
>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>     clashing with the new @end output and to separate byte offsets from
>     folio indices.
>
> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
> only when the folio straddles lend. After all, no caller discards a
> straddling folio anymore, the in-range cleanly-split sub-folios below it
> are still dropped.
>
> Suggested-by: Brian Foster <bfoster@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operatio=
n")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/internal.h |  4 ++--
>  mm/shmem.c    | 12 +++++------
>  mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>  3 files changed, 41 insertions(+), 32 deletions(-)
>


--=20
Best Regards,
Yan, Zi

