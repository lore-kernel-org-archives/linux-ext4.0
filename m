Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916413D5660
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832123; cv=none; b=ko3fdjDF/mXK9lAR3qgY5I1XywYwT0oVntmnCP8GzaZOY3eE+letJ6wD8ZL05eMms21tk4rZroiE+jNUjR1EF1f0o2l5PWD1DBXKKRzuj5tymqd11rkUHU3xxyEoXpQowZOxcsaYxqhwJTn1gPf2yeBgaR/tvCuMzYvNJvIsZ8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832123; c=relaxed/simple;
	bh=cN1DEk/ej7W0Aciu7jC2NfpptjsXYdVppwUFhx3K530=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfdeNQjblEoKxYBaD80/SxzJl9tuG2WovfHKqRb1T8ZUsE+8297+tGHFe1qIDj2jFNUh/h70AIW2CkfzjYamMgc+Yn2b9BhgXj18efzhUlBrFoWVJ5wdH/gfKLBFVi8whI3cEPCHoz3EtEC9sEkzcf1HDnfE25bOtqXzXsD1dx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SYPFFfte; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/TWxgMqt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mBr5WpFN; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=W09s7Z2M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SYPFFfte";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/TWxgMqt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mBr5WpFN";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="W09s7Z2M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 847803E9F;
	Tue,  4 Aug 2026 08:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ButmVBaSVNmLVYVR+pxUIjm4xGM8w2Bmh2LaOvoBAeg=;
	b=SYPFFfteeFsLRyx/SVjEOHTIusLQfAKDTlfepmyHxgO5/N5b4HxhkqiIW8iFBQy3Oq2hMn
	TEomg15vsp4roYUSv0fvRhnoZl7yZC4CZdt8VoHQ5XruMsXPjDA0LLLkcNGwKCF05uPg5C
	ZOoJ+xyOSUSQ59e+BVDyWw1CNAV5E1g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832114;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ButmVBaSVNmLVYVR+pxUIjm4xGM8w2Bmh2LaOvoBAeg=;
	b=/TWxgMqt0YqHgKXsHh4oxNoNoAZ0OxdqaLpc5NYpmyak/O7deQZnxe5oBWvDU70iSR9tpf
	O/SkR9c6p6fjrjAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mBr5WpFN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W09s7Z2M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ButmVBaSVNmLVYVR+pxUIjm4xGM8w2Bmh2LaOvoBAeg=;
	b=mBr5WpFN/p631hg+hsQQH9ohJuSkp7/gUE08/fkgSRlNa+hxt65oPOPRNZv8RmavwLHfcI
	LlbJj5nigelSTgZMmYQED7FKZoMvQsApU6aXNm/lNfERv+QSIhg2+6c1b0sldEwsF+6wS8
	+zsB0l/esAvZA2jdPw4DClgaKw1q0Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ButmVBaSVNmLVYVR+pxUIjm4xGM8w2Bmh2LaOvoBAeg=;
	b=W09s7Z2MnZInRXyrEHr5tOImz2jkw+yumc94sUop/cjKpkL6WV+tSwiecpn8Z/lGMDkMUk
	X13nyZkUB3GVUZBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79F88779BB;
	Tue,  4 Aug 2026 08:28:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LCXCHa6icWq/WgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:28:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2849DA13A6; Tue, 04 Aug 2026 10:28:30 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:28:30 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/19] jbd2: point the shadow buffer at the frozen data
 directly
Message-ID: <aqyhnzlgxo4x2v6bfpi43ueoob2drnpcxkmy7fpx3i7bcrvkzj@rm2bn66enfc3>
References: <cover.1785621505.git.coshi036@gmail.com>
 <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2824f30bbc43e6a0b318564fa641228e9a096e37.1785621505.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.com:email,infradead.org:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,infradead.org:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 847803E9F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:47, Chao Shi wrote:
> When a metadata buffer has to be copied out before it can be journalled,
> jbd2_journal_write_metadata_buffer() writes jh->b_frozen_data rather than
> the page cache copy.  b_frozen_data is kmalloc()ed, so folio_set_bh() makes
> the shadow buffer point at a slab folio.
> 
> That is not something the buffer_head layer can reason about.  A slab folio
> overloads ->mapping, so a shadow buffer looks like it belongs to an
> address_space when it does not.  buffer_set_crypto_ctx() already has to use
> folio_mapping() to avoid tripping over this, and it is the reason
> mark_buffer_write_io_error() cannot be called on a shadow buffer today.
> 
> Point the shadow buffer at the frozen data itself instead: leave b_folio
> NULL and set b_data.  The previous patch taught fs/buffer.c to submit such
> a buffer.  The two commit-path checksum helpers are the only other users of
> the shadow buffer's contents, and they take the data directly rather than
> kmapping a folio that is already mapped.
> 
> Note that the shadow buffer must not be passed to bh_offset() while
> b_folio is NULL.  All four callers that can see one are handled here and in
> the previous patch.
> 
> Tested with ext4 mounted data=journal,journal_checksum on a metadata_csum
> filesystem, writing files whose every block begins with the JBD2 magic so
> that escaping forces the copy-out, then crashing with sysrq-b without
> unmounting and replaying the journal on the next mount.  Recovery
> completed, the file contents matched, e2fsck -fn was clean, and an
> instrumented build confirmed the b_folio == NULL path was taken.
> 
> Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

...

> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 09efa337649e..9e4cb04587b4 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -329,6 +329,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	struct buffer_head *new_bh;
>  	struct folio *new_folio;
>  	unsigned int new_offset;
> +	bool frozen = false;
>  	struct buffer_head *bh_in = jh2bh(jh_in);
>  	journal_t *journal = transaction->t_journal;
>  
> @@ -354,8 +355,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  	 * we use that version of the data for the commit.
>  	 */
>  	if (jh_in->b_frozen_data) {
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
> +		frozen = true;
>  		do_escape = jbd2_data_needs_escaping(jh_in->b_frozen_data);
>  		if (do_escape)
>  			jbd2_data_do_escape(jh_in->b_frozen_data);
> @@ -400,13 +400,22 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>  		jh_in->b_frozen_triggers = jh_in->b_triggers;
>  
>  copy_done:
> -		new_folio = virt_to_folio(jh_in->b_frozen_data);
> -		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
> +		frozen = true;
>  		jbd2_data_do_escape(jh_in->b_frozen_data);
>  	}
>  
>  escape_done:
> -	folio_set_bh(new_bh, new_folio, new_offset);
> +	if (frozen) {
> +		/*
> +		 * b_frozen_data is slab memory, not page cache.  Point the
> +		 * buffer at it directly rather than at a slab folio, whose
> +		 * ->mapping is not an address_space.
> +		 */
> +		new_bh->b_folio = NULL;
> +		new_bh->b_data = jh_in->b_frozen_data;
> +	} else {
> +		folio_set_bh(new_bh, new_folio, new_offset);
> +	}

Can we please simplify the flow in this function? folio_set_bh() is now
done only for a single branch in this function. You can move it there and
completely avoid new_folio, new_offset, and frozen variables (you just need
to set new_bh->b_data in the two branches where frozen data is used).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
