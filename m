Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F903F6C4C
	for <linux-ext4@vger.kernel.org>; Tue, 19 May 2026 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779181403; cv=none; b=D7f3WQimWoNWmoI4qvIxNYcQQQXsTYY3eKtClbDLjOma8o4qjONFCh3Z87+P0Z8YarjopA+iSODSmm8v5q88f7mA/oRZGJwGRapk3RemFUkMEZnTpCyccsWaujpltAavhD5D7PDvWV9ngZz7WarmjloiZRKgtEtMjFir9l/xsXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779181403; c=relaxed/simple;
	bh=w4fG9dMjPPjIifqUT2Uw2T1K2p9ejh1dOf1Q/2ETxCA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=dh6+PjXTivQQP41QXAe4xzbxl6UvRrRC2E8AyxY7LBFDSVp9khH71019rkU52NSnzj2ixT6KRU7mUA8LRjr+31gzxMrWJ9pqBkeYnzr2K3O/7M0eeeTGs31xKT9Ex9dSyCAmYF/0ZgbwZM+EoP8gacSQ4cmD03QSsz0a2ESoCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k2MK6leB; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k2MK6leB"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779181394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hSOauER5MyHXpewQdXwKYI24deSOfI/F1xxDMDHNKVI=;
	b=k2MK6leBsGW1qoC6eU1zCnoqGY2YmHYRFkY3okuhRQDxBYT0wkz2qYLCOB0Yw6DijQlgXj
	w0yKtQFaSUsGru9C6ZugTi1cNOnUHEo7wfvVP/NCc3c4A7w2KG4Y+4j7gh7yauLBXCoZ/7
	0J8LLapTCDJP9y2SrbaCLE89k7V/1Fg=
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] mm: do not install PMD mappings when handling a COW
 fault
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: William Kucharski <william.kucharski@linux.dev>
In-Reply-To: <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
Date: Tue, 19 May 2026 03:02:54 -0600
Cc: linux-mm@kvack.org,
 linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 david@redhat.com,
 yi.zhang@huawei.com,
 karol.wachowski@linux.intel.com,
 wangkefeng.wang@huawei.com,
 yangerkun@huawei.com,
 liuyongqiang13@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2381B9B8-FD4D-48FE-BBF3-00D3455A8197@linux.dev>
References: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
 <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
To: Zhang Yi <yi.zhang@huaweicloud.com>
X-Migadu-Flow: FLOW_OUT



> On May 19, 2026, at 02:36, Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>=20
> Gentle ping =E2=80=93 could anyone take this patch?
>=20
> Thanks,
> Yi.

Could you update the comment to clarify why you shouldn't install PMD =
mappings
while doing CoW rather than just state it should never be done?

>=20
> On 10/24/2025 6:22 PM, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>=20
>> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
>> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
>> anonymous page, resulting in an infinite loop issue. The specific
>> triggering process is as follows:
>>=20
>> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>>   has a 2MB large folio installed in the page cache.
>>=20
>>   addr =3D mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, =
0);
>>=20
>> 2. The kernel driver pass this mapped address to =
pin_user_pages_fast()
>>   in FOLL_LONGTERM mode.
>>=20
>>   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
>>=20
>>  ->  pin_user_pages_fast()
>>  |   gup_fast_fallback()
>>  |    __gup_longterm_locked()
>>  |     __get_user_pages_locked()
>>  |      __get_user_pages()
>>  |       follow_page_mask()
>>  |        follow_p4d_mask()
>>  |         follow_pud_mask()
>>  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>>  |                            //huge PMD is installed. This is normal
>>  |                            //in the first round, but it shouldn't
>>  |                            //happen in the second round.
>>  |           follow_huge_pmd() //require an anonymous page
>>  |            return -EMLINK;
>>  |   faultin_page()
>>  |    handle_mm_fault()
>>  |     wp_huge_pmd() //remove PMD and fall back to PTE
>>  |     handle_pte_fault()
>>  |      do_pte_missing()
>>  |       do_fault()
>>  |        do_read_fault() //FAULT_FLAG_WRITE is not set
>>  |         finish_fault()
>>  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>>  |      do_wp_page() //create private anonymous pages
>>  <-    goto retry;
>>=20
>> Due to an incorrectly large PMD set in do_read_fault(),
>> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
>>=20
>> David pointed out that we can preallocate a page table and remap the =
PMD
>> to be mapped by a PTE table in wp_huge_pmd() in the future. But now =
we
>> can avoid this issue by not installing PMD mappings when handling a =
COW
>> and unshare fault in do_set_pmd().
>>=20
>> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when =
R/O-pinning a possibly shared anonymous page")
>> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
>> Closes: =
https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@li=
nux.intel.com/
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> ---
>> mm/memory.c | 5 +++++
>> 1 file changed, 5 insertions(+)
>>=20
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 0ba4f6b71847..0748a31367df 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, =
struct folio *folio, struct page *pa
>> if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>> return ret;
>>=20
>> + /* We're about to trigger CoW, so never map it through a PMD. */
>> + if (is_cow_mapping(vma->vm_flags) &&
>> +    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
>> + return ret;
>> +
>> if (folio_order(folio) !=3D HPAGE_PMD_ORDER)
>> return ret;
>> page =3D &folio->page;
>=20
>=20

