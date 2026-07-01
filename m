Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659393EF0DC
	for <linux-ext4@vger.kernel.org>; Wed,  1 Jul 2026 09:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782897976; cv=none; b=bGkhk5gtmPSGuIwH1ZSsRP2G92eFaBqEUGck+T9FwVOomiVLcDvDwJUiwPFUlBXRAqMVOxBvnNhXIu4tZX6I7wnvvXGyq6fyQLzW+OHUbKr5EKW7HGtTxI0R0FpNZ8pN3aIZ/S4fL3A8d6oKdPL/f1j+wZw59fWrHegZP0nxvfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782897976; c=relaxed/simple;
	bh=d/dSlq+VQa7SUVr0FZlUevJHPvQm9cuAxzIdmOqJcP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1i/b2pwnSIXMYfaQtP2Wk2qpDT6AUimTz0p20rj0nMdyCCvH6OKCI3naKznjaW/RkTir4dQs5dSkWvFWqU95XS9PA1L//ptyWchZvH6RDJSMtLw8sVh5p19kjui7DKb00pPQiilfra4qk+z1JgC0aKYvOydNz63Wdn+DwGb8OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RckA5BXz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J0FEBwOl; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RckA5BXz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=J0FEBwOl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RckA5BXz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J0FEBwOl";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RckA5BXz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="J0FEBwOl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B4E975BD9;
	Wed,  1 Jul 2026 09:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782897972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkWizDxyGaejDFgbFHAH7IKdK4avor++y20h2/7TDew=;
	b=RckA5BXzgqAxsbbgRArVhmUf9mefcFwcOOCZxqu1l4z5lEOq47Xw6owKg9J2tcQ9pgixhz
	25tr40mYyA5t+AV6hhmYA0zQOc1AyA7bj6CshaVrkNwjHFTN0JJfL+Y2/ZbrLxs2066DXF
	2E9jHMUWTIFlrXiiZndBU6i8yqoKQuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782897972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkWizDxyGaejDFgbFHAH7IKdK4avor++y20h2/7TDew=;
	b=J0FEBwOlLJfdSaFzbf7UFP9k5o4EFTnDPoP16TAXhgpCT4gKZSTkafguMvPw5Im9mKWGIl
	erZ1IAduu4y6D/Dw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RckA5BXz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=J0FEBwOl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782897972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkWizDxyGaejDFgbFHAH7IKdK4avor++y20h2/7TDew=;
	b=RckA5BXzgqAxsbbgRArVhmUf9mefcFwcOOCZxqu1l4z5lEOq47Xw6owKg9J2tcQ9pgixhz
	25tr40mYyA5t+AV6hhmYA0zQOc1AyA7bj6CshaVrkNwjHFTN0JJfL+Y2/ZbrLxs2066DXF
	2E9jHMUWTIFlrXiiZndBU6i8yqoKQuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782897972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wkWizDxyGaejDFgbFHAH7IKdK4avor++y20h2/7TDew=;
	b=J0FEBwOlLJfdSaFzbf7UFP9k5o4EFTnDPoP16TAXhgpCT4gKZSTkafguMvPw5Im9mKWGIl
	erZ1IAduu4y6D/Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EB69779AA;
	Wed,  1 Jul 2026 09:26:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BPbsHjTdRGr+EQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Jul 2026 09:26:12 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1DF39A10B7; Wed, 01 Jul 2026 11:26:04 +0200 (CEST)
Date: Wed, 1 Jul 2026 11:26:04 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: use fsdata to track inline data write state
Message-ID: <t5jq3rva344ihih7tbvsdj4wyn6k72rkrqvxv5cimvch7pwlyn@pv6r3gkjktcn>
References: <20260630152812.1706-1-aditya.ansh182@gmail.com>
 <20260630152812.1706-2-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630152812.1706-2-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9B4E975BD9
X-Spam-Score: -2.51

On Tue 30-06-26 15:28:11, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> Instead of checking the live inode state (`ext4_has_inline_data(inode)`
> and `ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)`) in the
> write_end handlers, use the `fsdata` parameter of the address space
> operations to explicitly pass down the state in which `write_begin`
> prepared the write.
> 
> A concurrent thread (such as `ext4_page_mkwrite()`) can convert the
> inline data to an extent between `write_begin` and `write_end`. If this
> happens, the write_end handlers would previously miss the inline
> write_end path and fall through to extent-based write_end logic. However,
> since block buffers were never allocated in `write_begin`, this resulted
> in NULL pointer dereferences or data loss because `folio_buffers(folio)`
> was NULL.
> 
> By defining `EXT4_WRITE_DATA_INLINE` (3) and communicating this state via
> `fsdata`:
> 1) `ext4_write_begin()` and `ext4_da_write_begin()` explicitly set
>    `*fsdata` to `EXT4_WRITE_DATA_INLINE` when an inline write is
>    successfully prepared.
> 2) `ext4_write_end()`, `ext4_journalled_write_end()`, and
>    `ext4_da_write_end()` rely solely on `fsdata` / `write_mode` to
>    invoke `ext4_write_inline_data_end()`.
> 
> This removes the crude race fallbacks and makes the write_end
> determination unambiguous, simple, and clean.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/ext4/ext4.h  |  1 +
>  fs/ext4/inode.c | 22 +++++++++++++---------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..521bd5d6321c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>  void ext4_set_inode_mapping_order(struct inode *inode);
>  #define FALL_BACK_TO_NONDELALLOC 1
>  #define CONVERT_INLINE_DATA	 2
> +#define EXT4_WRITE_DATA_INLINE	 3
>  
>  typedef enum {
>  	EXT4_IGET_NORMAL =	0,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..e2e8ac5fb8d8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1302,6 +1302,9 @@ static int ext4_write_begin(const struct kiocb *iocb,
>  	if (unlikely(ret))
>  		return ret;
>  
> +	if (fsdata && *fsdata != (void *)FALL_BACK_TO_NONDELALLOC)
> +		*fsdata = NULL;

This is pointless. *fsdata is guaranteed to be NULL on entry to
->write_begin from generic code, ext4 calls ext4_write_begin() from one
place and there it has FALL_BACK_TO_NONDELALLOC value.

> +
>  	trace_ext4_write_begin(inode, pos, len);
>  	/*
>  	 * Reserve one block more for addition to orphan list in case
> @@ -1316,8 +1319,11 @@ static int ext4_write_begin(const struct kiocb *iocb,
>  						    foliop);
>  		if (ret < 0)
>  			return ret;
> -		if (ret == 1)
> +		if (ret == 1) {
> +			if (fsdata)

fsdata is guaranteed to be non-NULL so no need to check for it here.

> +				*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
>  			return 0;
> +		}
>  	}
>  
>  	/*
> @@ -1450,8 +1456,7 @@ static int ext4_write_end(const struct kiocb *iocb,
>  
>  	trace_ext4_write_end(inode, pos, len, copied);
>  
> -	if (ext4_has_inline_data(inode) &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);

OK, but if we race like:
  CPU1						CPU2
  ext4_try_to_write_inline_data()
						ext4_page_mkwrite()
  ext4_write_inline_data_end()

Then ext4_write_inline_data_end() will now hit:

  BUG_ON(!ext4_has_inline_data(inode));

with much higher probability. You fix that in patch 2 but generally we try
hard to avoid such breaking points in git history. So please fold patch 2
into this one to keep things working all the time.

								Honza

>  
> @@ -1560,8 +1565,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  
>  	BUG_ON(!ext4_handle_valid(handle));
>  
> -	if (ext4_has_inline_data(inode) &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> @@ -3161,8 +3165,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
>  						     foliop, fsdata, true);
>  		if (ret < 0)
>  			return ret;
> -		if (ret == 1)
> +		if (ret == 1) {
> +			*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
>  			return 0;
> +		}
>  	}
>  
>  retry:
> @@ -3299,9 +3305,7 @@ static int ext4_da_write_end(const struct kiocb *iocb,
>  
>  	trace_ext4_da_write_end(inode, pos, len, copied);
>  
> -	if (write_mode != CONVERT_INLINE_DATA &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
> -	    ext4_has_inline_data(inode))
> +	if (write_mode == EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
