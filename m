Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793F2233721
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783092654; cv=none; b=bFy6NwcKM+TGdTzrJSvRUryDDA7FuBkc4bNqlPLlhBKdP1W9p54s8fSboq+55gSDGW3na5Sid8OaCjB5wQzTc4S6wCmQC8j8HA64ZD7TFSLQ+LAA1+UeGb/p84JhSuR4wctiM35sO3ORZTxM795idbesgcF8+f8eHwW2S5We3vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783092654; c=relaxed/simple;
	bh=FwZm3efmoWIxz3lpAfX06uvJRfT8RE+MS1WN7rbu1cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfhSLDwkRt0GW2iJcFcHO3yhqDjyWJi4uZWstd2fu2hrNDtvapT4H4baDgJM21qmBgFnStm8dm23z2/o05A8/eHN5aqGJ5GzjXVbv/ou4GTQcgwI75slp8lF7n66MQ73Gw8oD1qGCAPZEHBPxxsswDQvsTARP/WXNS1dU7pxI2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sOJ5S/tl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zcfkxgsd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wS5ZIuwM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=86lyS2UX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sOJ5S/tl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zcfkxgsd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wS5ZIuwM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="86lyS2UX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5394749B8;
	Fri,  3 Jul 2026 15:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783092652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hD1/AoY6WfEC4EwfFt59Cae3gNkNJKx1zFSoinmB454=;
	b=sOJ5S/tlz++tTP+Qp/rtP22SxAYtvHSlYU6oaz2uYADv40rJu/mIXvIHA6IwuIBkXWyIb9
	kYHvMhpYQNiDCeCFkFqXjmVKSmmEJOGwYoRXPn2W50LYB+QkL4dvTL+e8mz8B8BMUkeKlp
	nZufPy1QbhT2McMnhWFiApwav5HXia0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783092652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hD1/AoY6WfEC4EwfFt59Cae3gNkNJKx1zFSoinmB454=;
	b=zcfkxgsdSF19PPEJFcMajGZ9sRsDMjsIEYDQdYAqYChA5l5IkGqgSy0RRsewR739Qh92L5
	Gj5/sE5150FWtPDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wS5ZIuwM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=86lyS2UX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783092651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hD1/AoY6WfEC4EwfFt59Cae3gNkNJKx1zFSoinmB454=;
	b=wS5ZIuwMONadP2nRwEFVkuEBUhr8NQFvXUKwbzmKR+jqI9Gxd2HhdSKBShxYJQSZlhDG3f
	y6pyFwOckEhfx5zyo3INFutOaXHsLhcRrkBaqlRM1dGEZnl00wuQrPdz9i799w7MPn/4IR
	hNnNidqCaMubRX6dM04M129lvMFn45I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783092651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hD1/AoY6WfEC4EwfFt59Cae3gNkNJKx1zFSoinmB454=;
	b=86lyS2UX3dYajS1BzQJKarxQUko4EtR+9Efx5+un/GHyqVK7lthElasR0j+iA7/3uSolO6
	PLlpGFd8JHpb6hAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DA77779AA;
	Fri,  3 Jul 2026 15:30:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hwJ7JqvVR2rfVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 15:30:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 52689A12D4; Fri, 03 Jul 2026 17:30:51 +0200 (CEST)
Date: Fri, 3 Jul 2026 17:30:51 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] ext4: cleanup unused CONVERT_INLINE_DATA flag
Message-ID: <yfokg6ncks3eitna4b6h3rmeo5ly4r7tyic6ckp4vx37qzn4bu@qkxnv2lgtx4n>
References: <20260703045414.1768-1-aditya.ansh182@gmail.com>
 <20260703045414.1768-2-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703045414.1768-2-aditya.ansh182@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B5394749B8
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Fri 03-07-26 04:54:13, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> After implementing bitwise flags for tracking the inline data write
> state in the address space fsdata parameter, the CONVERT_INLINE_DATA
> state flag is left unused and can be removed.
> 
> Perform this clean-up by:
> 1) Deleting the CONVERT_INLINE_DATA definition from ext4.h.
> 2) Removing the void **fsdata argument from both the forward
>    declaration and the definition of the internal helper
>    ext4_da_convert_inline_data_to_extent().
> 3) Removing the void **fsdata argument from the declaration and
>    definition of ext4_generic_write_inline_data() and updating
>    the caller ext4_try_to_write_inline_data() and the internal
>    re-alloc retry logic accordingly.
> 4) Updating ext4_da_write_begin() to call
>    ext4_generic_write_inline_data() without the fsdata parameter.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v4:
> - Resent as Patch 2/2 of the v4 series, as suggested by Jan Kara.
> 
> Changes in v3:
> - Initial version of the cleanup patch.
> 
>  fs/ext4/ext4.h   |  5 ++---
>  fs/ext4/inline.c | 13 +++++--------
>  fs/ext4/inode.c  |  2 +-
>  3 files changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9e6f6467bdeb..c2e4262406a7 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3137,8 +3137,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>  				struct buffer_head *bh);
>  void ext4_set_inode_mapping_order(struct inode *inode);
>  #define FALL_BACK_TO_NONDELALLOC 1
> -#define CONVERT_INLINE_DATA	 2
> -#define EXT4_WRITE_DATA_INLINE	 4
> +#define EXT4_WRITE_DATA_INLINE	 2
>  
>  typedef enum {
>  	EXT4_IGET_NORMAL =	0,
> @@ -3749,7 +3748,7 @@ extern int ext4_generic_write_inline_data(struct address_space *mapping,
>  					  struct inode *inode,
>  					  loff_t pos, unsigned len,
>  					  struct folio **foliop,
> -					  void **fsdata, bool da);
> +					  bool da);
>  extern int ext4_try_add_inline_entry(handle_t *handle,
>  				     struct ext4_filename *fname,
>  				     struct inode *dir, struct inode *inode);
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index cfd591dc1d9c..0cb2dc195d23 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -22,8 +22,7 @@
>  
>  
>  static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
> -						 struct inode *inode,
> -						 void **fsdata);
> +						 struct inode *inode);
>  
>  static int ext4_get_inline_size(struct inode *inode)
>  {
> @@ -697,7 +696,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  					  struct inode *inode,
>  					  loff_t pos, unsigned len,
>  					  struct folio **foliop,
> -					  void **fsdata, bool da)
> +					  bool da)
>  {
>  	int ret;
>  	handle_t *handle;
> @@ -728,7 +727,7 @@ int ext4_generic_write_inline_data(struct address_space *mapping,
>  			return ext4_convert_inline_data_to_extent(mapping, inode);
>  		}
>  
> -		ret = ext4_da_convert_inline_data_to_extent(mapping, inode, fsdata);
> +		ret = ext4_da_convert_inline_data_to_extent(mapping, inode);
>  		if (ret == -ENOSPC &&
>  		    ext4_should_retry_alloc(inode->i_sb, &retries))
>  			goto retry_journal;
> @@ -788,7 +787,7 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
>  	if (pos + len > ext4_get_max_inline_size(inode))
>  		return ext4_convert_inline_data_to_extent(mapping, inode);
>  	return ext4_generic_write_inline_data(mapping, inode, pos, len,
> -					      foliop, NULL, false);
> +					      foliop, false);
>  }
>  
>  int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
> @@ -895,8 +894,7 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
>   *    need to start the journal since the file's metadata isn't changed now.
>   */
>  static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
> -						 struct inode *inode,
> -						 void **fsdata)
> +						 struct inode *inode)
>  {
>  	int ret = 0, inline_size;
>  	struct folio *folio;
> @@ -934,7 +932,6 @@ static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
>  	folio_mark_dirty(folio);
>  	folio_mark_uptodate(folio);
>  	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> -	*fsdata = (void *)CONVERT_INLINE_DATA;
>  
>  out:
>  	up_read(&EXT4_I(inode)->xattr_sem);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4e1bf54e511d..9a0fbaf73ce2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3160,7 +3160,7 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
>  
>  	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
>  		ret = ext4_generic_write_inline_data(mapping, inode, pos, len,
> -						     foliop, fsdata, true);
> +						     foliop, true);
>  		if (ret < 0)
>  			return ret;
>  		if (ret == 1) {
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
