Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1694B14F70;
	Mon,  2 Feb 2026 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041651; cv=none; b=aUmXltmFAc6YhC4WdmbLg8Qv4MIqS/ECI96nL0du58B1T0Nzw1IZoGNfKeLXg9WT1nYBMGSprTXBkLoMLD1fx846L3Wq3Fltcjj/RnbLKEAFeHTsCNwiNk/QgkyVXc7ZYGEagKRLYep3tHdSzOtM+5fS72Nhgnb20KPp8EwCE2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041651; c=relaxed/simple;
	bh=JqKUl60vf2mk2q6WHXRfrQSgpfjh0GgY9vftFLodTqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6rFg5ptkSJcFLRUt5qP4ty6rYWgK/ck5rVSva+JNVp/t3yUqK8xafvxSTkGGADJylwb7fPCg8Nn5EsUoaaO3zlRGwz4taXn9q9ByYUXH3PgbLJEevR1GSux08uDNpEjFiHIOHK2ZwUhXbFK2njsa2Qtu27EGxw0IdxYBh3SSw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vuf9nYmW; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vuf9nYmW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=wAc1k4+zJsRHlPOaEXkpUDHcRc6VbrRi9Rvm6Gsx3+s=; b=Vuf9nYmW73DOvW4W1bCFO/Hxhf
	uedDfAw5PpTFnap8ZcF5G1fMOqOe2VE3qvN/KvhNd6cK/1iX33t9qDefGu5dtybDwg6SHc/mTsaQ3
	4pfJ7q7Q7UW/Fqy7tYwfS+di3ywvNLV6d4u27oBErXywciqNsEyG6fUzAxxvO/DPTJKAQQhnfbGdQ
	4XAG22Ps8Iq9rSuz7NqYPvMUDTfjmzZ2ZNqT89ksZxR5D2Mda66892y7vk+/5MOUllpHQhIGQ/Zbb
	I3M46ENR0WVdvoH/48JMvhlIsSh2JE8qpY1GgUH9yrSJOD8h21d48T4MMyRVu5NO597BRMa2BcCMK
	Xt9iQZtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmugo-0000000Gb0L-1joD;
	Mon, 02 Feb 2026 14:14:06 +0000
Date: Mon, 2 Feb 2026 14:14:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 filemap_free_folio
Message-ID: <aYCxLsCVUT_kky4o@casper.infradead.org>
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>

On Mon, Feb 02, 2026 at 02:20:50PM +0800, 李龙兴 wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. KASAN:

Don't be syzbot.  Get your changes into syzkaller upstream and let
syzbot do its thing.

> Allocated by task 49607:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:342 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:368
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4978 [inline]
>  slab_alloc_node mm/slub.c:5288 [inline]
>  kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
>  ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393

I'd suggest this is an ext4 problem, not a pagecache problem.

syzbot has good heuristics for this kind of thing now.  You don't.
