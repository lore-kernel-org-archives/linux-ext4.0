Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2CD3D3D12
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jul 2026 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785183907; cv=none; b=SHSzQw2wCN/6ffIOrF/y79lgmuKx0tI/c+pUksrC8gfafpjMyag18gM2tVR9B5XTgoyBsiCdANj2TR4QTrV+pPp1NWIvDcWnM9OPCPn5wv2Q1WksMFnmfDc7EUPxg8xv44SiZmjJOsOejISUiIfkSzZfElyIgF5/8NCCCjMm6Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785183907; c=relaxed/simple;
	bh=EuJuJ0yp5OF83LZY8sRxs0ALx824CT8ZZvXPNljWLXs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gO2LVQNE/D4bEtPmJJ9BUdO/CjYY6GpGX62Cd52cBpcdaV2JUdWcKipWqjfKeIcLbds7c5bKLEbiFs8i5k4m/UTzpFaCwV5US85UB+O+WPXeEcuFR0+9K7QMGcjKbuLB1TlgZ1TIeMLJecrquU//574BR6p31Nnq4VAj8TwFlXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=osMcZslv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="osMcZslv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=j2+Es7+6vFq7EAJspHY4eAo3VmkFoFJpdeN9ntNanJg=; b=osMcZslvI4lWhtCL0jeF7LGqP1
	QObEstejiFlPASwlXuDTRTDVHTnKhQdu97PX/v85T7sxvdh2hEBbA6UI6XEBYo4jRoacB8RtooSKu
	dZo34m1+s2Co2s9F3KFxkpZjd19s/E0LZHzP8nXQUmdGI0WjBkx8oeVEHbbS8g+Yc8FypQvhO/A1J
	tPEd9MitAAGnVNvE992422M33e8hkls+gIz2odBnchXGDDrsjruQ+mJtXw7COmyCF25L41xxOol8V
	x7E1hwtbGaHGgrbP9OqSKcmyqrLmXyi4fWshL5m5mIQ7xHsuUv2P7CPzBRWNF+2gvxE5qHW9iq6zn
	P1nETtsw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woRsj-0000000BOjd-2pNW;
	Mon, 27 Jul 2026 20:25:01 +0000
Date: Mon, 27 Jul 2026 21:25:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-ext4@vger.kernel.org
Cc: Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Ts'o <tytso@mit.edu>
Subject: Misuse of mapping_set_folio_order_range()
Message-ID: <ame-nZTo5hd5JD8P@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While reviewing an unrelated change, Sashiko seems to have found a bug
in ext4:

> --- Patch [9]: [PATCH v6 09/12] filemap: Remove checks in mapping_set_folio_order_range() ---
> commit c0859bbb9afcf450bfdee34a144cba981c50e605
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> filemap: Remove checks in mapping_set_folio_order_range()
> 
> This commit removes the maximum order checks in mapping_set_folio_order_range()
> to allow its use in hugetlb.
> 
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 2c3718d592d6d..968b791cfd148 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -405,29 +405,23 @@ static inline size_t mapping_max_folio_size_supported(void)
> 
> [ ... ]
> 
> >  static inline void mapping_set_folio_order_range(struct address_space *mapping,
> > -						 unsigned int min,
> > -						 unsigned int max)
> > +		unsigned int min, unsigned int max)
> >  {
> > -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> > +	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
> >  		return;
> > -
> > -	if (min > MAX_PAGECACHE_ORDER)
> > -		min = MAX_PAGECACHE_ORDER;
> > -
> > -	if (max > MAX_PAGECACHE_ORDER)
> > -		max = MAX_PAGECACHE_ORDER;
> > -
> >  	if (max < min)
> >  		max = min;
> >  
> >  	mapping->flags = (mapping->flags & ~AS_FOLIO_ORDER_MASK) |
> >  		(min << AS_FOLIO_ORDER_MIN) | (max << AS_FOLIO_ORDER_MAX);
> 
> This is a pre-existing issue, but can this non-atomic read-modify-write of
> mapping->flags cause lost updates to concurrently set atomic bit flags?
> 
> While the documentation above this function states it should not be called
> while the inode is active, ext4_change_inode_journal_flag() dynamically
> invokes it on an active inode during the EXT4_IOC_SETFLAGS ioctl:
> 
> fs/ext4/inode.c:ext4_change_inode_journal_flag() {
>     ...
>     ext4_set_inode_mapping_order(inode);
>     ...
> }
> 
> If a privileged user toggles the ext4 journal flag, could this non-atomic
> update race with mm_take_all_locks() (which can be triggered by userfaultfd
> or KVM) modifying AS_MM_ALL_LOCKS via atomic bitops?
> 
> Since they do not share any locks (ext4_change_inode_journal_flag() holds
> inode_lock and invalidate_lock, while mm_take_all_locks() holds mmap_lock
> and i_mmap_rwsem), losing the AS_MM_ALL_LOCKS bit could cause
> vm_unlock_mapping() to skip unlocking mapping->i_mmap_rwsem, resulting in a
> permanent deadlock.

Making mapping_set_folio_order_range() atomic would be a pain -- it'd
involve a cmpxchg() loop which would be utterly useless for most
callers.  Can you figure out how to fix this in ext4?
