Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011014.outbound.protection.outlook.com [40.107.208.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D1C4EC645;
	Wed, 16 Sep 2026 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789593367; cv=fail; b=IymgQz20o3iRbiI0e85OzGjA06Ntz5LTBE7eStqdtTvrBy/neiyJvJDvUPxWMKOvhgKwR3VxA05QrVJ6OEIz31eVcTe4vKMclBsSO45wgMVTKfKg8fpOi0hF3nyZVELJDwcLz8uCOU6B5IMDLe3EzQT29Dw/PlcvjkPSarK61LE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789593367; c=relaxed/simple;
	bh=ipr+5dAkwpDOuySBdKIzWyAMoffHdX9uv4YmZHS0R8A=;
	h=Content-Type:Date:Message-Id:Subject:Cc:To:From:References:
	 In-Reply-To:MIME-Version; b=lC7Qz1fVWZWw64b6+gdb9zjEK4Bb87S9L0ZTryyF++BP7qXSljED0evH28JXVRT/O+e+md9bxyVu4USuBBnevVCyE4A6fTSY/9a75C8fV7TW+bvsnFglq6ZVf9s70OTd7kAkUSgnrWq47QhrqxmT4WEMXgaHAHj80nprtRklQbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CngPKsfW; arc=fail smtp.client-ip=40.107.208.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CngPKsfW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6bI7fQzRXURdHlyVRJZV9VWRQWGNNV3ekqydqfg1s68O5FcKJeta2J6vSE+kQvsOyfy+1rhZr4oTnZHdh6Sz0Srp7dKUYjV9BQNSsROEMxVfw96+A3HB0PJyLX7TiQ+AHYUzMF55osundU3hT69d3FLIT1hjtTOxjzMTpxdbnKU6IxD/sfk+ZjfLQUT78RSRFDwvLDlUbbDsQQPyT4tfqGAWiUMZ1gCB+dh9D9bwKahG763o1m77pf+0lB3B8wnwLKd1BO28yBMRWGyhKdpAEgKMDFYTkVqLZxI+NTiOsbSaKxp233QBSilrLU/qII+Dax9YNDoHmwtgEm2XatkfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmNKUqrImNOx7S+0O8f+7HHoVEsQJA4YWIKBWt1K+D0=;
 b=vDIJZD7ew9/2P0JxiAGkEPBR3hhtR45Wvbdjj3qf0roNF62Iw5U/P9eCdUrwq9fT37+pNQ3E2zt7Z4YD81C1RtS9b+mSYVydYtcFiIxVwyH+uQFqzxvLIh/xTn1/HKdUkVgkJ0SAVL+s6u85N9UULlIq75MIpkDOlRBtLnS2vO5htsH6aXo5oExWmlp2+CZ2ejtwgB3jNBVEw0KSqZ5uzQZV2DLB640j6kR66Q5V0cyffVtzJl6Jr5PrVYOMrT7m5xmJCJbK3SuLAabMc2NKmHQWQvDKLVQCwBklXl8LX423sZ6H27C3Td/ZLNtA8tWetuqnz/tGJwgPcE4g5IRIsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmNKUqrImNOx7S+0O8f+7HHoVEsQJA4YWIKBWt1K+D0=;
 b=CngPKsfWe9LAhMUiM/IxwGu2QO71CsPzOGH8FbgpuQBnBPY0MKe++zevxx9ZEd9OMyq5WDxB6LuEGCeTaJwjPlt3a81SmYuQni2kRxa+M+urw8JFv0rilq/Mb5whceINJ8cB18/RyuxF503SVMsRdg4ER3dJlxUOVKywbsrdRRr+BjHSUZmq0S1DXydPZn9pNe+HxJwbgAKGXbwOMMxywXF464tdPnmC5Gxljc6uTJ28ZzqscECxRjhZa+2AC8vstgx47fqWBBQbLsbBsbG68bz7JV3hYKaSGcmbrfXr+e6zC83JSHh9pg8DNoToeeSoTC4Ip+dKrboY/TaIxcQQNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB8405.namprd12.prod.outlook.com (2603:10b6:208:3d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 21:14:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.009; Wed, 16 Sep 2026
 21:14:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 Sep 2026 17:14:23 -0400
Message-Id: <DLH1V7L6ECGU.3AIRGWUODR779@nvidia.com>
Subject: Re: [PATCH v3 2/3] mm/truncate: align truncation boundaries to
 mapping minimum folio order
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
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
 <20260916092450.654408-3-yi.zhang@huaweicloud.com>
In-Reply-To: <20260916092450.654408-3-yi.zhang@huaweicloud.com>
X-ClientProxiedBy: BN0PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:408:142::26) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB8405:EE_
X-MS-Office365-Filtering-Correlation-Id: 842a41dc-1456-4e6b-cb90-08df14377bf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|10067099003|4143699003|6133799003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Qwnq592xJzqRiGU8jj/xWhXu36gqShqQnny7euraM5QAj3DDVU/fCzQ4t70U4pks9x5p21ide4LKI909Jw0yzBEpvK4aQqRu1+jLNn+z93YfMB8vgsrUA853TSC3P1g3LPZ2OitxtA84c6IP8x7iXqbT6G8HP0xMy+1lubqs0AWRM5JL6M3vcNh4G+AjdsHaZL7cQ84iua5zfgqMeQBjnf3wVGoxnqrdAdGxw9hYdyPtSN6gBgMxQcyat+V10q0VgMY+y0kOUr/vBeyytHzWxpCVbbF6KkHOYb6+p8EojV7KPLmjh90bTXiqKo6kVswnyu3ZaZRGFiToiLpRi9Kx2vHnDMoZH6Kpjdao+u/KPSK5rXqE8UpE55IjoXyJGWGysnLnjifAhIDZIsxxaf6TFpMJ4tvGJP0CEjAD/3Gh26JvN2ALJyY1BVJAoOTKdW2bQet8Na8153BC/bWzHRwtMjxH3a2St/3ydygqKx6Td2lMIAN6EAtvs+EVF9YiTHmmpqFbc34q2gwwp2vxSm2v9AnCruynYB1RpmTeLfhhSBjmj/VbNLnZYK2CkYR4uFokkZq8O8XOIHCQTGBLcwcV/NqKmMwODcCnQD06Vj9+s9tHWkyChOdI4InL3Bi4u53qiBXJ0tZcfTu6r9go8FsFoAIVITZItXF31LM2P1BhBQI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(4143699003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emVDVmo2bHYrbzN5Sy9RdU1ZNHBtVld6MDlSTjYxTGtDU1NBUWRiRklJYXpH?=
 =?utf-8?B?TW5CMTUrUnNzNHNqK2xMOEJoZXY2bmIvb0ZMMCthb2p2ZWsrOVV1blZKTHhQ?=
 =?utf-8?B?RmowRUF3d2p6WVcxMGZhTnZYWnB4cUd0VkZObUpwcVVzSGRxKzJmWTQ0MEZM?=
 =?utf-8?B?VDdtcmxpY01rN0JsVkcyR3ZCb1BQeHZQcnFKQXUwd0RBamh5cHJlYXB1V3pt?=
 =?utf-8?B?anozRjgrR0toem0xMk4wNkh6Sm9WMHhEWDI0TDRwNXpjcVRiSHRNc1FYZ0h0?=
 =?utf-8?B?MkNPeVRQZ0FPMi9XOCtXVkZJREJjTUJ1RVJZVm1BRDVQUFNRWWNxd2VjNW00?=
 =?utf-8?B?N3BSZU9DaElCLzJrRllSODJLdGM4S1hLdHF2UndkSmZmWktPcHk4bjZ5eTFp?=
 =?utf-8?B?R1hBcE9lSWhyU0ZZTEw2OG5kbGI0djd6bFVoT2xVdU9UL0hFRlBJSDJHVVVw?=
 =?utf-8?B?RW5aQTRyYnhkVDBpRFlURE1BeWJDcjIrL2ZKdXYzRFR0Nlh6YXZLbjE5c2xJ?=
 =?utf-8?B?ZFo5bzBuTkdwVEJoR2xLakRDSXNaOEg0aEZDNEtTZmVZMHA0OW41cEgwTG1Z?=
 =?utf-8?B?dzBVZmRoUmZESEs2OTJjNUdHenhRNW5Pck80QjRDQ1hwVk9YUWhma1ZkVVUy?=
 =?utf-8?B?NWovc09rUW5BQ3RiUnRyTGhYbVBmWWdJUVVHL0ZEY1ZkcXlRNUNubCtUS2s5?=
 =?utf-8?B?aFNWL2p1S2o4K042TnJ6bzFDK0tNakhYMVM4L0xyY2l2Y2V3dDdjWXFIN3pU?=
 =?utf-8?B?dGw2YUVBZW55UXZaUW54L2IrWGdLNWgzWFkySU1wRTQzVFM1RUMrbjVQSTdM?=
 =?utf-8?B?Z1UzZFd5em93ZkNaaVFLSWpUNlR4TURsWndHeTFpeVQySFJzd2wvVEN6RXVk?=
 =?utf-8?B?c3E2QnU4Y3lqb05uOHh2elYwTFNnS0ZFZUx0SHlEVktLOGhKOHhJdU44enRu?=
 =?utf-8?B?dXprV25NVkRxVkliOUJkSjlWSXBURjFKYTNic2tCWnhRVkdNVTZOalFiRkdC?=
 =?utf-8?B?bGhDUXhPaDh4NHJCb2FuQUs3STFiQ0RQQU1RU1NuUUxFWkc2QzYweU9VRDly?=
 =?utf-8?B?bXdPeDNjUGZjalduSllYeUhvN2h6N2IzZ2pYNVo0dHRaYjBUR210Rlp5MVhU?=
 =?utf-8?B?ZjVjRW5BMk8wOWZ6WllLWldTYkxLbktZV1dSQms2eGVEQmRubkpuWkxMS2dL?=
 =?utf-8?B?VHdHSFJYUTVhZFVVUWk5SDREbDc5cTY5WjZ1NkdtTzNCVTErZEx4ck5ETDQy?=
 =?utf-8?B?RVM5ZzJMUk0yWTFnUGhnT1dnK1I4QXJJVk02bXl3eEVuRWZmSkUvbzV5WGlU?=
 =?utf-8?B?QWRrd25QK3c2cFFPODJVVFJjZkpFMlc2WXQrdzdzYTFRM2FXZkdyYUJZZjFv?=
 =?utf-8?B?aVRPelNYZkd5MDhSOTMxU1BoYWEvV0JLWmJzZW9FakdLTXNnMVZKbzZTUmo5?=
 =?utf-8?B?ZlJxbTR4ZG53WVZXdHBXbXNxYjFXaEJPVndMeWw0UVNKT1ZhOHkxSVB0RlRB?=
 =?utf-8?B?Q1Z4Z2ZOOUdVOFdJVk1sSWx0am5YOWY3UDRIMUJnNmxpVDJBNHZCVXMwRW13?=
 =?utf-8?B?VUxsZWUzUE9nekJoV1pDZXVkUUpHZkpmSFErSDlOWHpCdmVHUE9adk5FdzBq?=
 =?utf-8?B?dUtJNmxQbDhxQzlIK2gyK0lUMm5tcnYrZEFaeGJOSEJwaDZ6czF2NnUvTWxu?=
 =?utf-8?B?RlZ4QWVaVElPTElqRnRWdVhKT0kwSHYwRGdzL25KMC9MOFY3bEUwMjRyTXcx?=
 =?utf-8?B?eWs5WGZKMGQzdy9GcVlibEFoUkdZeEd2SnR2NXlVZlpIYlpHKzdMTzVXOGQz?=
 =?utf-8?B?UXdic2tUSGIrUFZZRjlrYm80LzVhbjlxYWREQVpvZ2RhMXp0MDA4UmU5ZWRO?=
 =?utf-8?B?Y3EzNXAwb2xvbU5qcitERWlpbnA3eDdLWU91Um9jUUtDTUoyMlBhdE82dzVK?=
 =?utf-8?B?OXpxb1RQNG94RDBtZWNsNkJtZENCYjY2d0k0Tk9FNUZodXIwTnJScmhLLzc4?=
 =?utf-8?B?Z1ZiVHBINDF3WGw3bjhRMmpWRUltQVdHTzNWMTRnZm5iL295ZVIyV3ZoaHVU?=
 =?utf-8?B?ZjlPWk1WRDVKam92UnFVSDNkYVJMYTBQVU9hV0tUMi93V2xQL1l0Vi82V0lM?=
 =?utf-8?B?alAwaUp3cFgxSUNCYWJQSUk3L3VGaXZUbUl2ekV2U2dxUG5kbWhPd2Y2TEVp?=
 =?utf-8?B?T0NtamxjV3dTMVJiVEp3K09tQnhBVllhNnVTZnNuUFpUUHFXMlFKTlhxQXRn?=
 =?utf-8?B?WFl5ZUcvRTh6VzdPeXZnUHhxWlVscTU4dkM0K0J6NDFNZHdVdUZCT2thYVMy?=
 =?utf-8?Q?kxjB1+NpMWEXHV6Eme?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 842a41dc-1456-4e6b-cb90-08df14377bf8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 21:14:24.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szZehZqEUp19xepDcNFLhcVqaSP6/ldXJqKmOAIBamuVoZd10+nQdoYyJ8mGFohV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8405

On Wed Sep 16, 2026 at 5:24 AM EDT, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
>
> When the mapping has a non-zero minimum folio order (min_order),
> folio_split() stops at min_order instead of order 0, so the sub-folio
> containing a split point stays aligned to 1 << min_order rather than to
> a single page. The original boundaries were based on page granularity,
> so either boundary could land inside the min_order chunk at its edge,
> and the truncation loop would drop that whole chunk, valid out-of-range
> tail included.
>
> For example, a 64K (order-4) folio with min_order =3D 2 (16K) punched fro=
m
> offset 0 to 36K:
>
>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>   folio2 =3D p8-p15           # straddles: p8 in range, p9-p15 tail valid
>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>   end(old) =3D p9                               # BUG: p9 inside [p8-p11]
>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
>
> It has gone unnoticed so far for two reasons. A non-zero min_order is
> only used by filesystems with a block or sector size larger than the
> page size, and those either always write back the affected range before
> punching a hole or truncating, or they carry filesystem private data on
> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
> fail and folio_split() abort with -EBUSY, so the folio is never split
> and the old start/end boundaries remain valid. The bug only becomes
> reachable on paths that truncate dirty large folios without prior
> writeback and without filesystem private data, such as the upcoming ext4
> iomap buffered I/O path.
>
> Align both start (rounded up) and end (rounded down) to the mapping
> minimum folio order so they always fall on a folio boundary.
>
> Reported-by: Joanne Koong <joannelkoong@gmail.com>
> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AY=
sy=3DOWzVRgD4202y1g@mail.gmail.com/
> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  mm/truncate.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>

This should be the first patch, since Fixes is older than the one in
patch 1.

It can adjust start and end in truncate_inode_pages_range() instead,
since shmem's min_order is always 0.

Something like below.

Am I missing anything? Thanks.

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be474..803ee61ebf624 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -374,6 +374,7 @@ void truncate_inode_pages_range(struct address_space *m=
apping,
 	int		i;
 	struct folio	*folio;
 	bool		same_folio;
+	pgoff_t		min_nrpages =3D mapping_min_folio_nrpages(mapping);
=20
 	if (mapping_empty(mapping))
 		return;
@@ -395,6 +396,10 @@ void truncate_inode_pages_range(struct address_space *=
mapping,
 	else
 		end =3D (lend + 1) >> PAGE_SHIFT;
=20
+	start =3D round_up(start, min_nrpages);
+	if (end !=3D (pgoff_t)-1)
+		end =3D round_down(end, min_nrpages);
+
 	folio_batch_init(&fbatch);
 	index =3D start;
 	while (index < end && find_lock_entries(mapping, &index, end - 1,

--=20
Best Regards,
Yan, Zi

