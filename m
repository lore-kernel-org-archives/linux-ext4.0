Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1875351C02;
	Wed, 26 Aug 2026 07:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730677; cv=none; b=OelbD6ERBGAn7fipaQlGRmC3onm7fuMxTzxUuVz/R2awLgoUAxektyzNCoHXnRCSmqlRV9olc2+h7yAFbeN6n8Kf1jdUR25ohHzjdFVzPujxC9cHfdGUKdwjYoWEVQNLXHBsNjiSJ5o2yVby7rSis9eoPO0N0ltTwg2JDlxcgto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730677; c=relaxed/simple;
	bh=tewgDcaPuqdXmP8mzpq9QJye/ARzRyKWRDFsYBo8I/o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mh4WQpluvvKxpwwIWrHuzKyaT6raseHfTL0goGY8zQ6FbuZf7LYGNyMKS1FTYyNE/CVWPaArB80p36E8d3wrW5I/7h4EfCYUp3c/sVa+QLh9oogncKXIaMN8799/Mc12UdyNWC4esOajVqPWrJfbVIj0PVYyNZUAe66Yvg3c2LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ll5LOZSB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S16+kWMX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wAd8ENQA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=W75Vnmb6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ll5LOZSB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S16+kWMX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wAd8ENQA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="W75Vnmb6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D83E0872B4;
	Wed, 26 Aug 2026 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X9TU1kIHF/i4uNHTSlySSa79BYJgx4ANZxwADHxiyV8=;
	b=ll5LOZSBjwYM2sVdCskYdOxJQajMVbs6RU6GU4RhRupZywLNwfkr48QAHk71N8dxJ9E91w
	yYU4IRrTHzgj8VqZvN1EZa9oyR5OPbRkbFi0bQrb8RM6EkRiwOPT+ymoAxdiTMAvsjaFmL
	u+eWrWL6Qv79tY2FdUQmkqYyoWCvOqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X9TU1kIHF/i4uNHTSlySSa79BYJgx4ANZxwADHxiyV8=;
	b=S16+kWMXgsq5tGmdXh7G+oJ1eFHP/JpZLVvF3imIC11WotwxneCjQn8FDM5HUUS6KfzCPZ
	fui3I2H7ZnebFlDg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X9TU1kIHF/i4uNHTSlySSa79BYJgx4ANZxwADHxiyV8=;
	b=wAd8ENQAGN66ka7asoabe74l/RsP8+i/Iw5E9L9FXaxYcAkQmoNWPAPp5XbY5GLaMUMIeX
	Z8vtjp4R/A6lUpXiiXy9WKKJssbQ/sXOzz9ZUAFdntBCK9CrFQZm4Jpm7WYhU1lWtKZSyx
	Nf7acewbAqqoj7Cuzr1wJPfGd8NwcU0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730606;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X9TU1kIHF/i4uNHTSlySSa79BYJgx4ANZxwADHxiyV8=;
	b=W75Vnmb6ye2H7EJsdQYsXR0+tP2mQcX6Bc7BGMhUXB14D3YnUydDAFR9BWhhyPzYnGPfH7
	7vs3HHNTNNl9asAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AE99136AA;
	Wed, 26 Aug 2026 07:49:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QSOnAqSajmosDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 660D3A13A4; Tue, 25 Aug 2026 18:09:55 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:09:55 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
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
Message-ID: <2qyd52k3ipzigeq5jwuwekmv4bzsjppacnm7ghdbpuwwi443nj@lflqmoyxbuvh>
References: <cover.1785951556.git.coshi036@gmail.com>
 <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6140cd23beb88e99f40eaeff4044a16213f6caab.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[infradead.org:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,fiu.edu:email,suse.cz:email];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	TAGGED_RCPT(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	FREEMAIL_TO(0.00)[gmail.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,infradead.org:email]

On Thu 06-08-26 12:58:26, Chao Shi wrote:
> When a metadata buffer has to be copied out before it can be journalled,
> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
> the shadow buffer point at a slab folio.
> 
> That is not something the buffer_head layer can reason about.  A slab folio
> overloads ->mapping, so a shadow buffer looks like it belongs to an
> address_space when it does not.  buffer_set_crypto_ctx() already has to
> work around this, and it is the reason mark_buffer_write_io_error() cannot
> be called on a shadow buffer today.
> 
> Point the shadow buffer at the frozen data itself instead: leave b_folio
> NULL, which it already is out of alloc_buffer_head(), and set b_data.  The
> previous patch taught fs/buffer.c to submit such a buffer.  folio_set_bh()
> is now needed on only one path - the one that journals the page cache copy
> directly - so it moves there, and new_folio, new_offset and the flag that
> used to pick between them all go away.
> 
> The two commit-path checksum helpers reach the shadow buffer's contents
> through a new kmap_local_bh()/kunmap_local_bh() pair, which handle a buffer
> with or without a folio.  Memory outside the page cache is always mapped,
> so for those there is nothing to map or unmap.  Mapping it anyway would be
> worse than pointless: with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP,
> kmap_local_page() hands back a one page mapping even for such memory, which
> is not enough for a buffer bigger than a page.
> 
> Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
> filesystem, writing files whose every block begins with the JBD2 magic so
> that escaping forces the copy-out, then crashing with sysrq-b without
> unmounting and replaying the journal on the next mount.  Recovery
> completed, the file contents matched, e2fsck -fn was clean, and an
> instrumented build confirmed the b_folio == NULL path was taken.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c            |  8 ++++----
>  fs/jbd2/journal.c           | 29 +++++++++++++++++------------
>  include/linux/buffer_head.h | 29 +++++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 3029cb6f6d64..0c85af91f9b2 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -330,9 +330,9 @@ static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
>  	char *addr;
>  	__u32 checksum;
>  
> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> +	addr = kmap_local_bh(bh);
>  	checksum = crc32_be(crc32_sum, addr, bh->b_size);
> -	kunmap_local(addr);
> +	kunmap_local_bh(bh, addr);
>  
>  	return checksum;
>  }
> @@ -357,10 +357,10 @@ static void jbd2_block_tag_csum_set(journal_t *j, journal_block_tag_t *tag,
>  		return;
>  
>  	seq = cpu_to_be32(sequence);
> -	addr = kmap_local_folio(bh->b_folio, bh_offset(bh));
> +	addr = kmap_local_bh(bh);
>  	csum32 = jbd2_chksum(j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
>  	csum32 = jbd2_chksum(csum32, addr, bh->b_size);
> -	kunmap_local(addr);
> +	kunmap_local_bh(bh, addr);
>  
>  	if (jbd2_has_feature_csum3(j))
>  		tag3->t_checksum = cpu_to_be32(csum32);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e..6e05dc47e20a 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -327,8 +327,6 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  {
>  	int do_escape = 0;
>  	struct buffer_head *new_bh;
> -	struct folio *new_folio;
> -	unsigned int new_offset;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
>  	journal_t *journal = transaction->t_journal;
>  
> @@ -348,24 +346,31 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	/* keep subsequent assertions sane */
>  	atomic_set(&new_bh->b_count, 1);
>  
> +	/*
> +	 * b_frozen_data is slab memory, not page cache, so when we use it the
> +	 * shadow buffer gets no folio at all: b_folio stays NULL from the
> +	 * allocation and b_data points straight at the copy.  Pointing it at
> +	 * the slab folio instead would hand its overloaded ->mapping to
> +	 * anything that goes looking for an address_space.
> +	 */
> +
>  	spin_lock(&jh_in->b_state_lock);
>  	/*
>  	 * If a new transaction has already done a buffer copy-out, then
>  	 * we use that version of the data for the commit.
>  	 */
>  	if (jh_in->b_frozen_data) {
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>  		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
>  		if (do_escape)
>  			jbd2_data_do_escape(jh_in->b_frozen_data);
> +		new_bh->b_data = jh_in->b_frozen_data;
>  	} else {
> +		struct folio *folio = bh_in->b_folio;
> +		unsigned int offset = offset_in_folio(folio, bh_in->b_data);
>  		char *tmp;
>  		char *mapped_data;
>  
> -		new_folio = bh_in->b_folio;
> -		new_offset = offset_in_folio(new_folio, bh_in->b_data);
> -		mapped_data = kmap_local_folio(new_folio, new_offset);
> +		mapped_data = kmap_local_folio(folio, offset);
>  		/*
>  		 * Fire data frozen trigger if data already wasn't frozen. Do
>  		 * this before checking for escaping, as the trigger may modify
> @@ -379,8 +384,10 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		/*
>  		 * Do we need to do a data copy?
>  		 */
> -		if (!do_escape)
> +		if (!do_escape) {
> +			folio_set_bh(new_bh, folio, offset);
>  			goto escape_done;
> +		}
>  
>  		spin_unlock(&jh_in->b_state_lock);
>  		tmp = kmalloc(bh_in->b_size, GFP_NOFS | __GFP_NOFAIL);
> @@ -391,7 +398,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		}
>  
>  		jh_in->b_frozen_data = tmp;
> -		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
> +		memcpy_from_folio(tmp, folio, offset, bh_in->b_size);
>  		/*
>  		 * This isn't strictly necessary, as we're using frozen
>  		 * data for the escaping, but it keeps consistency with
> @@ -400,13 +407,11 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		jh_in->b_frozen_triggers = jh_in->b_triggers;
>  
>  copy_done:
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
>  		jbd2_data_do_escape(jh_in->b_frozen_data);
> +		new_bh->b_data = jh_in->b_frozen_data;
>  	}
>  
>  escape_done:
> -	folio_set_bh(new_bh, new_folio, new_offset);
>  	new_bh->b_size = bh_in->b_size;
>  	new_bh->b_bdev = journal->j_dev;
>  	new_bh->b_blocknr = blocknr;
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index 699970b4bbf2..20b8fca1abfa 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -172,6 +172,35 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
>  	return (unsigned long)(bh)->b_data & (folio_size(bh->b_folio) - 1);
>  }
>  
> +/**
> + * kmap_local_bh - Map the data of a buffer.
> + * @bh: The buffer.
> + *
> + * Buffers usually live in the page cache, but a few are built over memory
> + * which is not.  Those carry no folio and b_data is already a kernel address
> + * which is always mapped, so there is nothing to do for them.  Pair with
> + * kunmap_local_bh().
> + *
> + * Return: A pointer to the buffer's data.
> + */
> +static inline void *kmap_local_bh(const struct buffer_head *bh)
> +{
> +	if (!bh->b_folio)
> +		return bh->b_data;
> +	return kmap_local_folio(bh->b_folio, bh_offset(bh));
> +}
> +
> +/**
> + * kunmap_local_bh - Unmap the data of a buffer.
> + * @bh: The buffer.
> + * @addr: The address returned by kmap_local_bh().
> + */
> +static inline void kunmap_local_bh(const struct buffer_head *bh, void *addr)
> +{
> +	if (bh->b_folio)
> +		kunmap_local(addr);
> +}
> +
>  /* If we *know* page->private refers to buffer_heads */
>  #define page_buffers(page)					\
>  	({							\
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
