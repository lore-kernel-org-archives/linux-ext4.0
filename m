Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011048.outbound.protection.outlook.com [40.93.194.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C863562606;
	Tue, 22 Sep 2026 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790096326; cv=fail; b=VRxPNxWm9J1GCTOnIeDMA9fNDC43wRGuwE85FQOX1hX2YvaffYc37LfNUK8s7eLn8hYErxRpKm4Q02pnuQm4IzNAgVfQVxNdPowZJs0qqCxHau1OXiOncd0WRw2syiGABfaYugON4DDGOCwqmS01MvtOkWt9N5BL30ditX1atTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790096326; c=relaxed/simple;
	bh=KIDbvlppxQTgvBuG+xhtoNmGQ8NCHZk7dlDOCelIfGw=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=Cbn+jPI1Dncm4F+aZbIceIGbj3DBkryJl3kW2pCiJzS2eiE1y7fQJsPG8G254SusnxtcBrdDnktyQ+SVn5ofxs5yNB7mi4Lh7ozT/9v4DRwiN16Mr7Rya3LowwW+bs3RBZtphuh7/BVQY30+eiystclOpWmKfIHdMHbteCGNQCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J2YuFYmE; arc=fail smtp.client-ip=40.93.194.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J2YuFYmE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOiCmvDVn8Q6UyexiclxRqLCoRSQqVytBt1YCkdUFjCp7v8/gD27l9vOzExlTv0/7kueoPjE11LSARkaaGQcwHN6f8s5TXnP7F1Tmh8xsc74svdnSzgAgQLm76Zrq6Q5Rkg/SAyytgISWo3i48GkK6UxeM2VJYmXZoSydnwBfuH4jK/uiQyFPg3uVNF/P6dq/qffpr9fewPGbPNjUqQvdE2+Ok5fdFbnhY2ZnSyLHcTlruQC04+hCI+UhsHVtkFL6ABU7FOrze0CuDBs23ZtsjIg97Xs46khfElWlLUjh9Zd1HA7YFbugrfUL9VMbyNfv0b5rhWJgP4UPV20lK4JJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DnU7I/ZUKYFWaGFYYUyebjWdfO995zsXMDFv6RFKMrs=;
 b=XvCAPeEKqtRTCCArtI9hKgVUwljiOcpYlMRcydvXtPBc3wcn3BfypzHShNH2yUmDLOtL6bbFb7pABQ4GQ9CF7fh9HiTys1jchUcGjLg+hH9txE4h94I+lUi/eLzBsojIN1SSxZthh9sHekRhfqC+hBZSbPi2AT3nIA6MxZRIQh1zD+Ss+PKpSkYnmdrerXKJvAfa+4iP1LGEc1ql0BB6e7v5hClafRneXkloB760HZGpRe/OMbE3/IeDwr8RkMrX66M41zNBsFcQpIGfcNhtIP8laUkSZl+XHe/4CTdPVPgkeCU0bTuviVMLwo9nL7lntWDc4Qu4rDFq77YZSZg4zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DnU7I/ZUKYFWaGFYYUyebjWdfO995zsXMDFv6RFKMrs=;
 b=J2YuFYmE33zCeZa6xUmwB3zuwghIy063NPHZbJtFTbzlzKtXoclLrMWQ04GYKxyqwUNOshnC5uWNWKTRJ9GuluajGby7tixl+vE3b/tcLaZxovQc8V9XABm7iTzotYCeoFoxSQH7exmSSVH7cgEyCi4cP+PfX09hwFsRW3Iy+lTQwla4rov5am/lYG6wztaFB7b2CMoRYo3UnAMmcBbvM/hMkuG6TuqcmpoNQGuZF1XDFSrmMniouh2h+WpS3FFZzLjoQRwKrPwFNcPSwh47Lpt40slIXtujXhemgf0xKcGbt5ujZFqY+oQTEcrObVf8nwNcQKzJaztiGW3bLaC+7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB9191.namprd12.prod.outlook.com (2603:10b6:a03:55a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Tue, 22 Sep
 2026 16:58:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 16:58:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Sep 2026 12:58:33 -0400
Message-Id: <DLM06LTFH1EF.VDF3RXLK57EX@nvidia.com>
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
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-4-yi.zhang@huaweicloud.com>
In-Reply-To: <20260922110703.468389-4-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: YQBP288CA0006.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB9191:EE_
X-MS-Office365-Filtering-Correlation-Id: 02bf677e-a970-4e49-de42-08df18cabe1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|6133799003|18002099003|22082099003|3023799007|5023799004|11063799006|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xp9Vj+HQF3V9oAm5MFsgCHQyl74/gPBI/ZArtf5LwTnZu+QFcvmWrLMiE3c4Jivf27LDeTe9J/JX5477xejiZvg9uYukADSBVGXYOd1/7WNnzX/Vt3T2Tu3iiiFGdkymSgHh6NqVh4BLiAzX9/jQvWpZa+gAXqi8Q6thq4PRx1Ywu1M16wKPTaXlcmpo1HW8NvlZRpig0R/fpbtYB1WuuwVX9KyUSiajtZloVOybDS81ZypX6mqOVWT0kT+5fzPV/gzBnp30zH4Nwdzu24rtisnVqxqkv4pkihNAYwA3f52NiMxUY/GbIJNj2WH6g9jmCIkgsSbWRMDSUm/eoC6C3ASV0gKzN7SoSGA1r3dMQEc7WQ6BC6hXYpWJPBqVTbMzSwQhQyqlC5t/9nSKFJFe1z2gVKmek0SVr4x4Wpn/ABB6i9S0/LQKcqaoY9VpypUFlGo0pMrWBjroW8g6UBBUkH/4Qew4XxHtH8po7FE1C9M5OUKjQbd/AcEs+OfEw7jjUPsQO+9UdhV3MjC+C/dcyP0WeygKbI+DdM5MV1uZrl//EK5vr+wY/TTn3tKMSNQyq+T4XFz+K/Zwu2arrYB/s3XHB446ZXp5KxdCS4OZ4vulCY7Q1KEmHlToHC39FlReWDEvG2kaD2M0muX5Rd+VyRWKqAYgChmoPPv2M8fp1MA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(3023799007)(5023799004)(11063799006)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WjRtM3NsSWJraWc0TjJsRHJMc0xmazFEc0dhaUZBYTRwenBBNGZOa1lvbnJE?=
 =?utf-8?B?c2QzWlNKdVZzQTdUcnFnWm91K1RMM3FMdWlGQjJyUjVPd29YeVBOS3plcHRJ?=
 =?utf-8?B?MzVVNzczUkxxZWdPd0NpSjNwM2lZWVl6ak1tTzU2aHl4ODgyS2hXQk0xV3M2?=
 =?utf-8?B?Z1E2Um5MR3llWmhlRTFSUzA3NmlBdUlhR2tOb3hDZ2JoVFRsUU1qbEtwQ1ln?=
 =?utf-8?B?aHY0NnhFNHZCT1FOTldWaC9qM3JSMXdGcmR6a0o2c0dEbVF2VHZsdm1LQ1px?=
 =?utf-8?B?a2krR1B0b2YxRXBrQWVGVWdCWlkxZDNONDdBSFlhTEQ0K3BaenMwb1hxMUMr?=
 =?utf-8?B?NERTeGpHMnNmUm9kZDJTRlg0cnVoVytaaHJlYkpRbkRYRVpaUTczdTR4cFRI?=
 =?utf-8?B?cDVWMC8ydUM2SWVDU2l4czVhd3V2bldYNlpTZU5UNkJ4N3V0YlM4bmQ3RWZK?=
 =?utf-8?B?U2xCdEpOeHA3UUlSTEEvRmtHOW1yNG9FZGZFZDVzZG1EanJyZnI5bW1pSVVV?=
 =?utf-8?B?RW0yYVB2ZUJoSGRmdEJXRUdrdi9QOXhnRkJuNWhZSXlrTlBaQnI4RmI2ZnE3?=
 =?utf-8?B?bXJab0RvTGo1c0tUUG1yWnhRUGF0Rjl4TWVhQ3I5bXZ1cDl6MjU2YkZoRzJF?=
 =?utf-8?B?RHNlRDI2VUpzdEJISlBMcHdWakVMWE9Qa2ZGbjNCNkxPaE42SXdZUDFNR20v?=
 =?utf-8?B?ejJvdUVGVjJWMVFIK29XOG1wd00zYTBMZmFJTGpVMjZIZ2N3UWhJK3N6c3Nx?=
 =?utf-8?B?S05UZ1VkMTFsQUhCelI0bm1jNnA4bmJ6VWFqSk9FcDBGaE52U0dmZG1WeURI?=
 =?utf-8?B?THZkUG9oMTJDRnJHaytxdmdqV3JJbEF2STMrNmJmaTM5Y3J5OVpaRWhSSmV1?=
 =?utf-8?B?MkJEMlFqSVB6a1R2L05YL29CNHFzWjhVQzZsS1FwU0xOTjMwaFh6cXBCV0V6?=
 =?utf-8?B?Y1pmWjVMalBPTHE2cThpUk1TT3BTT2h2QWtyL0xXTDllWWFmK3FMTW5IN1kv?=
 =?utf-8?B?b3FzSzRvQWJ1M1pVTTlQNUlUeHRodkNsdXBxZUdzbHVsUHFadklZUHRSaVE1?=
 =?utf-8?B?YTBBMmY3c2dYRFFQcmZuOEZxQU1zaXc2cDIyK1BwOWVOMXNQRVNjSnFpeUl4?=
 =?utf-8?B?UWdxWkhySmowQ3NtQlRUZ0FmRW1JdGRhMDFkVFYrTFQ1OGQrM3ZJQ0VsVnpF?=
 =?utf-8?B?cnpweENlVnlWQTJlVnAvZnRNM2pjQTQ1SUdBbjJuSVBMczBKZzdNekoycUQv?=
 =?utf-8?B?UzF4VnRwZzZ0Y2l0QjBWS2pFV0J0VzNFaXRHT2hHRHd2SG1tMjBMQnRuWHJX?=
 =?utf-8?B?Vm5wTERVRTVnRXFQM2lwbUFxdWswOC9Sdk1kczg4RlhqaTNBNWtpY01qMFZB?=
 =?utf-8?B?NFhZVkdFbXRGZ1pveFRBSGZNckZXbDJkTy91dUpmY3ZFRmx6Y1N2TGxlUHRa?=
 =?utf-8?B?SEdiaDRIL2NjUmhad0ZENURDbG9NbENSSnp6OTJhSFJEdWUycWY4VGREUG5U?=
 =?utf-8?B?c0xSaHpsWlJldDRVVjFYZGpHdTYxL3Q3bW9xNXc3OUhlbmxjWnRuTzB5MkVy?=
 =?utf-8?B?KzV0c0xnMERxTkt1ZUZCTnZXL1NacnFpeHlhNnhzYlQrY1JzYWN1TEcrbk5G?=
 =?utf-8?B?NHpvd0toTWhGYzJxOFh3dFlEeUt3VUh1Uk42YnA5Z05ZdE8rVUJiN2hLMkxU?=
 =?utf-8?B?UGRBeWVIK20rR3NYRWhuK0xxTUk0cFN4TEZmekhWTWRtTnpWd2pQRjM0ek94?=
 =?utf-8?B?VExUWTFKRG5QbWk3eVpicE10NkhxeHBlUEVmcjhrOXA1N29ibFd3VEJqSnF6?=
 =?utf-8?B?TG0rTUFvTzZzdXBRamMrdG81Qi9TWTJjak9HLzZkR0RvcGhjZ3hUR3duZ0hK?=
 =?utf-8?B?a0h1M3dsNDhpK21JYXpOM1JLQ25aMXNwN3V6OVp2dTlJWUcyc2N3TThUMWFz?=
 =?utf-8?B?bFBPWkR1TXF2bEdNNkplMllPL09veW5zT1ZNdSt4ckpjTnZ2V2drcnpMcFVj?=
 =?utf-8?B?OWdYNDRDc0NNcCt0eld6NVFSVUltMWY2WHRZQkNYb1UwY3NLYWhsYlN6L0pv?=
 =?utf-8?B?RFBGY1J0akRKbDBvVUJrMmJzcm1VSWFabnV2akZmZG1mbGozMEdwNThZRWhh?=
 =?utf-8?B?ZEEvUVJ1aVhMQlRQOFJtMVRKVmtMWndtakxaYzVxY3llVkV6RVF6UnpEQzJS?=
 =?utf-8?B?bmhVRWZVQ25ITEZHZUxidzZYenVMSEw5SGM1NndrWXRBUVBVUkg5bmRjR0Fi?=
 =?utf-8?B?SzIyYUdVMUNoVUFJUWZWOThFcDYzazNwTlBvUlhYSGw4dk5uZnlISHVxSDI0?=
 =?utf-8?Q?bD57acIzSGnCd0EOUP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02bf677e-a970-4e49-de42-08df18cabe1a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 16:58:36.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uCfmlRnnhWmDiAlU+nK2qcDzkkrTtfJy4gbe627VnsUJgScPXaDvqvTigm6gb9t7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9191

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
>
Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi

