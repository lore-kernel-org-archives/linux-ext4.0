Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D773D7D6A;
	Wed,  5 Aug 2026 20:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962485; cv=none; b=XdHljvbF7zqJoVGNHgEMwg2zpUkh3SlzSQ7v6kKQs9QoeGb6pqfgo7W1dsY8Sj2QBDvQMoUqyonJ48GF4JSUQIfABctdlFG+HL0Pi2u7EYM//3G2pq3Pxmgcj8FOqJyTbc1sS0zKUCQEGq6QpSU07hgV38NWCi9kGwcwIStaG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962485; c=relaxed/simple;
	bh=bKHF6u0QFrLiKhwziRU9z0gIPX0/5d2MZCi2+Cv5dZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meNB8YsLxN9yudiqDc0gH1kzH00IYhgk2VjwQCrVMB53CzFGOJOmbmeR9wpQgAhE8PcvtHKo5oKhefWk7A+sk6nXFPZbok4gywpfYk8M+MnanMqb6Ib7YILMslDsTLNL0tASlVXIqtvnY8rz/KMvDvv5UvQWuhSOsDI0TcXrKGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=p3I43qte; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="p3I43qte"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y2VOXKtf863PLMWvVnlp8n68uju+vZ0BqWAtRD1HEeM=; b=p3I43qte4ysCVWGyt6CdofRNq1
	vv9J3pOYzyDaT51j14fwuFr4gCccuTNlMpPpx2IfCm+zOGeVC93SyWLXyLR2NTBjPOSgXa+b0K6uW
	t5BzNaZ3Wsh9QGkN3WbPeHTpw4IwgiJUk8K6RD607y8NcRfUggsKFf2wkdPICysg2GM4La9N/NPVh
	4UE0bK1Z0DVVTXUSRBn5EX13PH7kwnY6Tx2noRzIielIMrTerse8l47vM/qhGXo060Zcf6Zp92CUL
	BLY/AGr30pKYgmbyENfuGKSnH2u7Zs7iGySkibAh/Fy+QwYvWdojec3bLQMAQIDcNZSZzDuo/vv5M
	QPu8q+dg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wriQE-00000004fGu-3BHb;
	Wed, 05 Aug 2026 20:41:06 +0000
Date: Wed, 5 Aug 2026 21:41:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Chris S <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	gfs2@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data
 directly
Message-ID: <anOf4vNU_XPvyhb0@casper.infradead.org>
References: <cover.1785621505.git.coshi036@gmail.com>
 <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
 <anDZ5YG-Ljflv7Vm@casper.infradead.org>
 <anFYf1iKrNLAjJMw@casper.infradead.org>
 <CACd_6n2GY2RRQPeKtJEuVkHcSBN-Ne2gJdHRfwxg2i=OT06MFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACd_6n2GY2RRQPeKtJEuVkHcSBN-Ne2gJdHRfwxg2i=OT06MFg@mail.gmail.com>

On Wed, Aug 05, 2026 at 03:02:05PM -0400, Chris S wrote:
> Thank you so much.
> Taken, with a change: the helper needs a matching unmap, and must not map
> the folio-less case at all.
> 
> static inline void *kmap_local_bh(const struct buffer_head *bh)
> {
> if (!bh->b_folio)
> return bh->b_data;
> return kmap_local_folio(bh->b_folio, bh_offset(bh));
> }
> 
> static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
> {
> if (bh->b_folio)
> kunmap_local(addr);
> }

Ah, I hadn't considered that option.  Yes, I think this is the right
approach.  Thanks!

> Two reasons.  kmap_local_page(virt_to_page(bh->b_data)) loses the offset
> within the page, and b_frozen_data is kmalloc(b_size), which is only
> guaranteed page aligned when the block size is at least PAGE_SIZE.

Yeah; my bad.  I should have added in PAGE_MASK(bh->b_data) to that,
but what you have is better.

> The second one is your other point.  With CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
> __kmap_local_page_prot() maps even a lowmem page, one page at a time.  So
> mapping memory that is already permanently mapped would walk this path
> straight into the bs>PS problem you just described, which it is otherwise
> immune to - b_data covers the whole block whatever its size.  Returning
> b_data and calling kunmap_local() on it anyway is not an option either:
> kunmap_local_indexed() WARNs on an address outside the fixmap range under
> that config.  Hence the pair.
> 
> On the bs>PS folio path itself: agreed it is real and predates this series.
> I would rather not fold a fix into this one, but I will take it - I'll look
> at it separately once this has settled.

I've been considering adding a folio_vmap() which would be a nop for
!highmem, kmap_local() for order-0 highmem folios and vmap() for
large highmem folios.  It's not reached the top of my todo list yet.
