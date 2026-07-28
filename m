Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74633B813D
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267151; cv=none; b=GGuftgbzAe1h6ajucuiqbbwyLIs3sAJ2IDAzKWerktvolpuif5tXgtFtFvXf6cDsHUtsmrlFTygGYO5Agy/Voeqfq2ymAw+AdZJ9H8Fcaf65Yoi62Ua53QTAEbxlhDvyctVfNWiMwT/9v6Fm+5htBsB+0nZ1pAGrrZmDEdqBuLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267151; c=relaxed/simple;
	bh=q8x8A16fRZBzY396SEdJqLVoPkg02a/XP6fVRLLHxY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nshbIIMAwqCTcdmlc4VZ8dN4W73A5HuMCWHBWjbEaCZ7iLdl83puX3SveggyfmUjQfWMtn4U4s/FD5EbRwcZ/m5zJmNW+6xa6AXzNF6AQqz6L908MywrKM6PnUvwlPH2RkW51SQPQN5Nz9A0BWL+/NJzr4NCm04OZElEozcCejE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rJOKLE+t; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QteVd83t; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AnAcfKEg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=EcxBonl+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rJOKLE+t";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QteVd83t";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AnAcfKEg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="EcxBonl+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E9D37B671;
	Tue, 28 Jul 2026 19:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785267143; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbs6BEN5p6Zyge8IPMcdWiqLYvS0eHnMQL/QFAf0UwM=;
	b=rJOKLE+tJ0aSoCdGHs1P0d9LHPq/SSMkutwrq3sYp5Q9mhVHmJEm7G1EYgxdOgP+y0vhhf
	ie627VEAzgroeaxXyJg1UrFynJD3BESDhijgUDyvK4Od4nrVkwomRPo7OuBaWjmeTnmRDh
	1KEu4Yu7OqkaRWMvjVUsAkjgRSJifqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785267143;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbs6BEN5p6Zyge8IPMcdWiqLYvS0eHnMQL/QFAf0UwM=;
	b=QteVd83tCa2XeJm9ecBfHMFRQpdNoKdt6bs54fmWeKEvUJyqZs7E9A/cECmxrzMGC4+T17
	2RcPUH6otfLF50BQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AnAcfKEg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EcxBonl+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785267139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbs6BEN5p6Zyge8IPMcdWiqLYvS0eHnMQL/QFAf0UwM=;
	b=AnAcfKEgJSJhKQnyS7NFbUyDIi7c6huusJAs9v/PjMzFT6n9+VU3ECli0BxB/M0HU6Ty9W
	YWj+v1DkdoOvWRcir1wQ5LCVAJQawbUzWXHFPQNDy/naWopFGOyj64wz4jXXu8V3rgAcRo
	wGvnNj7j1lec3xNAM3B4JtAhSw4igEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785267139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lbs6BEN5p6Zyge8IPMcdWiqLYvS0eHnMQL/QFAf0UwM=;
	b=EcxBonl+dlq/EOQPh0iTha5mzlVSkyzctosHV8KccPw7pHnhPedCThFPiSeg62KKlxyEtO
	4PavmysCu1nJKnAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95D2E779B1;
	Tue, 28 Jul 2026 19:32:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id COqDJMMDaWo9OAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 19:32:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3D9BFA10B6; Tue, 28 Jul 2026 21:32:19 +0200 (CEST)
Date: Tue, 28 Jul 2026 21:32:19 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-ext4@vger.kernel.org, Baokun Li <libaokun1@huawei.com>, 
	Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huawei.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: Misuse of mapping_set_folio_order_range()
Message-ID: <b3t6rtuszod6kz5b6btleqf2cjkul7i7aysgn3cknr5ppqcab4@5xjyanf6jscj>
References: <ame-nZTo5hd5JD8P@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ame-nZTo5hd5JD8P@casper.infradead.org>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,suse.com:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 9E9D37B671
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Mon 27-07-26 21:25:01, Matthew Wilcox wrote:
> While reviewing an unrelated change, Sashiko seems to have found a bug
> in ext4:
> 
> > --- Patch [9]: [PATCH v6 09/12] filemap: Remove checks in mapping_set_folio_order_range() ---
> > commit c0859bbb9afcf450bfdee34a144cba981c50e605
> > Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> > 
> > filemap: Remove checks in mapping_set_folio_order_range()
> > 
> > This commit removes the maximum order checks in mapping_set_folio_order_range()
> > to allow its use in hugetlb.
> > 
> > > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > > index 2c3718d592d6d..968b791cfd148 100644
> > > --- a/include/linux/pagemap.h
> > > +++ b/include/linux/pagemap.h
> > > @@ -405,29 +405,23 @@ static inline size_t mapping_max_folio_size_supported(void)
> > 
> > [ ... ]
> > 
> > >  static inline void mapping_set_folio_order_range(struct address_space *mapping,
> > > -						 unsigned int min,
> > > -						 unsigned int max)
> > > +		unsigned int min, unsigned int max)
> > >  {
> > > -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> > > +	if (!IS_ENABLED(CONFIG_LARGE_FOLIO))
> > >  		return;
> > > -
> > > -	if (min > MAX_PAGECACHE_ORDER)
> > > -		min = MAX_PAGECACHE_ORDER;
> > > -
> > > -	if (max > MAX_PAGECACHE_ORDER)
> > > -		max = MAX_PAGECACHE_ORDER;
> > > -
> > >  	if (max < min)
> > >  		max = min;
> > >  
> > >  	mapping->flags = (mapping->flags & ~AS_FOLIO_ORDER_MASK) |
> > >  		(min << AS_FOLIO_ORDER_MIN) | (max << AS_FOLIO_ORDER_MAX);
> > 
> > This is a pre-existing issue, but can this non-atomic read-modify-write of
> > mapping->flags cause lost updates to concurrently set atomic bit flags?
> > 
> > While the documentation above this function states it should not be called
> > while the inode is active, ext4_change_inode_journal_flag() dynamically
> > invokes it on an active inode during the EXT4_IOC_SETFLAGS ioctl:
> > 
> > fs/ext4/inode.c:ext4_change_inode_journal_flag() {
> >     ...
> >     ext4_set_inode_mapping_order(inode);
> >     ...
> > }
> > 
> > If a privileged user toggles the ext4 journal flag, could this non-atomic
> > update race with mm_take_all_locks() (which can be triggered by userfaultfd
> > or KVM) modifying AS_MM_ALL_LOCKS via atomic bitops?
> > 
> > Since they do not share any locks (ext4_change_inode_journal_flag() holds
> > inode_lock and invalidate_lock, while mm_take_all_locks() holds mmap_lock
> > and i_mmap_rwsem), losing the AS_MM_ALL_LOCKS bit could cause
> > vm_unlock_mapping() to skip unlocking mapping->i_mmap_rwsem, resulting in a
> > permanent deadlock.
> 
> Making mapping_set_folio_order_range() atomic would be a pain -- it'd
> involve a cmpxchg() loop which would be utterly useless for most
> callers.  Can you figure out how to fix this in ext4?

What we need to do in ext4_change_inode_journal_flag() is that we want to
disable / enable large folios when enabling / disabling data journalling
for an inode (because writeback of large folios would strain the journal
too much when journalling data). We are actually pretty careful in
ext4_change_inode_journal_flag() - we lock the inode_lock, invalidate_lock,
writeout everything, prune all the page cache, make sure to synchronize
with writeback path and then we switch adress_space_operations and allowed
folio orders.

As far as I can tell AS_MM_ALL_LOCKS flags bit manipulation is the only
thing we can realistically race with. But I don't see how we could
avoid that race from ext4 :-|. Maybe we could have
mapping_set_folio_order_range_atomic() helper to avoid the pointless
overhead for everybody?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
