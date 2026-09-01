Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3CE480961;
	Tue,  1 Sep 2026 13:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788268906; cv=none; b=UcYFcNZFALECclWxJFbXUEtDW44gg3VL3jG0CJWVLXdv56lHm7X7pH7EJ0YbKl6DhKqCrtI8jeqkSjXILRGq70c/aAJctQOLIwVtoqkCGIrbcpDJYspNiwYFHud2zw+fJ8ez9hef7qSrc4fOlYZi8yx4f3mUPstxB5uAYbUcsZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788268906; c=relaxed/simple;
	bh=nsmBtXYHyv2bzmeK+dgsAbh4lVmOFLqYCxCg3RVy02E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBnSjpeKjOSeDk1m1DfZ7x/cBxFStTNG3VpkfQYN3WwlMO7LIrUAhI25WjxLulq2tTe0d1QtUy4sj+ykuQWU8owCMRb41+8/rGIpS9SfRjHGjs+xp/EDuadf/eBWM+xQERzYMRkOfstU17HPf5mjht9yN0qZ2m7JJ0jn+MOtgas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=15gO+vTW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=eT99rnCX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=x/XSK3cc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qI8aaktY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="15gO+vTW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="eT99rnCX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="x/XSK3cc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qI8aaktY"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CCD321BE1;
	Tue,  1 Sep 2026 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788268898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ1u5d81P5NsUds05pPvIum9o51WwkoVc644ebqxkmw=;
	b=15gO+vTWUs5G0WdrSr1KE/7eoe4JG6UjCzBIc11GmQyPG+x4DgjZ1kOR53x+qxaRTz6a6q
	+QZHRLaznfR09djQBcbee5qCtYWBaU3RNgR7s6CNeMu6ssLmz1BAqyFQLrIRgoQeE9bpma
	QlGyJ1nUZCmirFV4plm/B0+mw2YjC10=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788268898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ1u5d81P5NsUds05pPvIum9o51WwkoVc644ebqxkmw=;
	b=eT99rnCXimMIFo6ZGgArAGAfONauZrxv31wT18FN+xwydtNm1CSaDrjvkB9PkupVBY7Ibx
	bVHfSE6WVFqeelBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788268894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ1u5d81P5NsUds05pPvIum9o51WwkoVc644ebqxkmw=;
	b=x/XSK3ccs4tSY/lQvtowsMj3PopFykfHQTqiiOZws/N3OSq4LliEeieCylXwhggx3jtaKG
	PiPVSHWw8XJwSxmNwSr4bePoj6X3pif1kj7PdZVZomPxuYljChAz5LGJYrKKvIlJoNnSJs
	SLCGxUfLGKkGm/MMUHKysFD9AR+Fb5k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788268894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sJ1u5d81P5NsUds05pPvIum9o51WwkoVc644ebqxkmw=;
	b=qI8aaktYMkC2bugv9hQ8E79W2uXniA25CyNmQgL0+eVf0NCAmzHV+LQgbFdTB/GUFcf4yR
	FZWkcwoDyGF1KdAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAD7D13515;
	Tue,  1 Sep 2026 13:21:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7rJROV3Rlmr6LQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 01 Sep 2026 13:21:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7985AA13B2; Tue, 01 Sep 2026 15:21:33 +0200 (CEST)
Date: Tue, 1 Sep 2026 15:21:33 +0200
From: Jan Kara <jack@suse.cz>
To: Joseph Qi <jiangqi903@gmail.com>
Cc: Chao Shi <coshi036@gmail.com>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 03/21] jbd2: point the shadow buffer at the frozen
 data directly
Message-ID: <lxi7r2shdcsx7oagldgpjnwgushnogqlvud42m4a5b2as5tpx6@bi6aquij5bxb>
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
 <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20d3b629-e052-492f-9a24-ee700b259c37@gmail.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,infradead.org:email]

On Tue 01-09-26 11:37:14, Joseph Qi wrote:
> On 8/7/26 12:58 AM, Chao Shi wrote:
> > When a metadata buffer has to be copied out before it can be journalled,
> > jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
> > the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
> > the shadow buffer point at a slab folio.
> > 
> > That is not something the buffer_head layer can reason about.  A slab folio
> > overloads ->mapping, so a shadow buffer looks like it belongs to an
> > address_space when it does not.  buffer_set_crypto_ctx() already has to
> > work around this, and it is the reason mark_buffer_write_io_error() cannot
> > be called on a shadow buffer today.
> > 
> > Point the shadow buffer at the frozen data itself instead: leave b_folio
> > NULL, which it already is out of alloc_buffer_head(), and set b_data.  The
> > previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh()
> > is now needed on only one path - the one that journals the page cache copy
> > directly - so it moves there, and new_folio, new_offset and the flag that
> > used to pick between them all go away.
> > 
> > The two commit-path checksum helpers reach the shadow buffer's contents
> > through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buffer
> > with or without a folio.  Memory outside the page cache is always mapped,
> > so for those there is nothing to map or unmap.  Mapping it anyway would be
> > worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
> > kmap_local_page() hands back a one page mapping even for such memory, which
> > is not enough for a buffer bigger than a page.
> > 
> > Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
> > filesystem, writing files whose every block begins with the JBD2 magic so
> > that escaping forces the copy-out, then crashing with sysrq-b without
> > unmounting and replaying the journal on the next mount.  Recovery
> > completed, the file contents matched, e2fsck -fn was clean, and an
> > instrumented build confirmed the b_folio == NULL path was taken.
> > 
> > Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Acked-by: Weidong Zhu <weizhu@fiu.edu>
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/jbd2/commit.c            |  8 ++++----
> >  fs/jbd2/journal.c           | 29 +++++++++++++++++------------
> >  include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
> >  3 files changed, 50 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 3029cb6f6d64..0c85af91f9b2 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
> >  	char *addr;
> >  	__u32 checksum;
> >  
> > -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +	addr = kmap_local_bh(bh);
> >  	checksum = crc32_be(crc32_sum, addr, bh->b_size);
> > -	kunmap_local(addr);
> > +	kunmap_local_bh(bh, addr);
> >  
> >  	return checksum;
> >  }
> > @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
> >  		return;
> >  
> >  	seq = cpu_to_be32(sequence);
> > -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +	addr = kmap_local_bh(bh);
> >  	csum32 = jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
> >  	csum32 = jbd2_chksum(csum32, addr, bh->b_size);
> > -	kunmap_local(addr);
> > +	kunmap_local_bh(bh, addr);
> >  
> >  	if (jbd2_has_feature_csum3(j))
> >  		tag3->t_checksum = cpu_to_be32(csum32);
> > diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> > index 09efa337649e..6e05dc47e20a 100644
> > --- a/fs/jbd2/journal.c
> > +++ b/fs/jbd2/journal.c
> > @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
> >  {
> >  	int do_escape = 0;
> >  	struct buffer_head *new_bh;
> > -	struct folio *new_folio;
> > -	unsigned int new_offset;
> >  	struct buffer_head *bh_in = jh2bh(jh_in);
> >  	journal_t *journal = transaction->t_journal;
> >  
> > @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
> >  	/* keep subsequent assertions sane */
> >  	atomic_set(&new_bh->b_count, 1);
> >  
> > +	/*
> > +	 * b_frozen_data is slab memory, not page cache, so when we use it the
> > +	 * shadow buffer gets no folio at all: b_folio stays NULL from the
> > +	 * allocation and b_data points straight at the copy.  Pointing it at
> > +	 * the slab folio instead would hand its overloaded ->mapping to
> > +	 * anything that goes looking for an address_space.
> > +	 */
> > +
> >  	spin_lock(&jh_in->b_state_lock);
> >  	/*
> >  	 * If a new transaction has already done a buffer copy-out, then
> >  	 * we use that version of the data for the commit.
> >  	 */
> >  	if (jh_in->b_frozen_data) {
> > -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> > -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
> >  		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
> >  		if (do_escape)
> >  			jbd2_data_do_escape(jh_in->b_frozen_data);
> > +		new_bh->b_data = jh_in->b_frozen_data;
> >  	} else {
> > +		struct folio *folio = bh_in->b_folio;
> > +		unsigned int offset = offset_in_folio(folio, bh_in->b_data);
> >  		char *tmp;
> >  		char *mapped_data;
> >  
> > -		new_folio = bh_in->b_folio;
> > -		new_offset = offset_in_folio(new_folio, bh_in->b_data);
> > -		mapped_data = kmap_local_folio(new_folio, new_offset);
> > +		mapped_data = kmap_local_folio(folio, offset);
> >  		/*
> >  		 * Fire data frozen trigger if data already wasn't frozen. Do
> >  		 * this before checking for escaping, as the trigger may modify
> > @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
> >  		/*
> >  		 * Do we need to do a data copy?
> >  		 */
> > -		if (!do_escape)
> > +		if (!do_escape) {
> > +			folio_set_bh(new_bh, folio, offset);
> >  			goto escape_done;
> > +		}
> >  
> >  		spin_unlock(&jh_in->b_state_lock);
> >  		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
> > @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
> >  		}
> >  
> >  		jh_in->b_frozen_data = tmp;
> > -		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
> > +		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
> >  		/*
> >  		 * This isn't strictly necessary, as we're using frozen
> >  		 * data for the escaping, but it keeps consistency with
> > @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
> >  		jh_in->b_frozen_triggers = jh_in->b_triggers;
> >  
> >  copy_done:
> > -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> > -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
> >  		jbd2_data_do_escape(jh_in->b_frozen_data);
> > +		new_bh->b_data = jh_in->b_frozen_data;
> >  	}
> >  
> >  escape_done:
> > -	folio_set_bh(new_bh, new_folio, new_offset);
> >  	new_bh->b_size = bh_in->b_size;
> >  	new_bh->b_bdev = journal->j_dev;
> >  	new_bh->b_blocknr = blocknr;
> > diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> > index 699970b4bbf2..20b8fca1abfa 100644
> > --- a/include/linux/buffer_head.h
> > +++ b/include/linux/buffer_head.h
> > @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
> >  	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
> >  }
> >  
> > +/**
> > + * kmap_local_bh - Map the data of a buffer.
> > + * @bh: The buffer.
> > + *
> > + * Buffers usually live in the page cache, but a few are built over memory
> > + * which is not.  Those carry no folio and b_data is already a kernel address
> > + * which is always mapped, so there is nothing to do for them.  Pair with
> > + * kunmap_local_bh().
> > + *
> > + * Return: A pointer to the buffer's data.
> > + */
> > +static inline void *kmap_local_bh(const struct buffer_head *bh)
> > +{
> > +	if (!bh->b_folio)
> > +		return bh->b_data;
> > +	return kmap_local_folio(bh->b_folio, bh_offset(bh));
> > +}
> > +
> > +/**
> > + * kunmap_local_bh - Unmap the data of a buffer.
> > + * @bh: The buffer.
> > + * @addr: The address returned by kmap_local_bh().
> > + */
> > +static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
> > +{
> > +	if (bh->b_folio)
> > +		kunmap_local(addr);
> > +}
> > +
> >  /* If we *know* page->private refers to buffer_heads */
> >  #define page_buffers(page)					\
> >  	({							\
> 
> When tested ocfs2 on next-20260831, I've encountered the following NULL
> pointer dereference:
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000000
>   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
>   Call Trace:
>     jbd2_journal_commit_transaction+0x932/0x1b10
>     kjournald2+0xb2/0x250
> 
> Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> __bh_submit(). But jbd2 shadow buffers have a NULL b_folio since commit
> 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> directly") made them point b_data at the kmalloced frozen data rather
> than a folio. So submitting such a buffer during journal commit oopses.
> 
> A simple fix:
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 427d8a817cd5..f46fa6413032 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
>  
>  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
>  
> -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> +	    op_is_write(opf))
>  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  
>  	if (IS_ENABLED(CONFIG_FS_ENCRYPTION))

Thanks for debugging this Joseph! Please send a formal fix to Christian
(both changes are now upstream) and feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
