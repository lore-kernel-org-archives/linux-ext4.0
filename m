Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4C1286891
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783092645; cv=none; b=LK4Erlm1fMeaEJhij4mGnfbp2Lon+nSM5hQNYqbbGwZ06MDjSxLb+pyfoRDiodxC/EuIfZ0IXB/xoI/Cr1ajqcY7oD62luHq3Cx3ciGEoag1T8tSnmx4MJE08vYFktP4wTKLFqAZtVNlk+ERfJyTSFhhAOddAXZ8US9DFAx4Gvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783092645; c=relaxed/simple;
	bh=ZBtN4Euo1DOsYTAz9AK4nXIUjHgsrZ7jYuH/uLrGUGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RfFoTC9TjD6ZuDD2rnJLawp39GU3v5hrkpnPS9SwerhD+rUgWLxI296pw0wX4RvCazxZ7W6utkxhuLVUmEJsLfP0yqskOW7eJOA8hv4jwBuhgip/KZMV1aBCCqXS+RFsiWZDbTAa2TWUMqvJcoNl+KC7yy34P17dQ7uK7Al5lWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RtdAwQv6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IA/VQqQh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=RtdAwQv6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=IA/VQqQh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RtdAwQv6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IA/VQqQh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="RtdAwQv6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="IA/VQqQh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AB80D749B8;
	Fri,  3 Jul 2026 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783092640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3FnkbweO7PTivvYq83i0xDcPHibclqlDcUyPo7xbJNY=;
	b=RtdAwQv6qoNxZPMJKS2VnNfDC/gW6V0WecrGzBNp9SEu4/CyY9NCR1n13ocAH6slcfnI0D
	s7wsN3LdAa/vGZWDQL6RyCBTnB67kGQUhVEQzyKjhr74TepwFN3KzEbp6Bp2I6knRyMcq0
	jSzbfaau8XpxMHfGJL5/e0x+RhIrev8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783092640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3FnkbweO7PTivvYq83i0xDcPHibclqlDcUyPo7xbJNY=;
	b=IA/VQqQh2XCb2dhtofZPrs3psIHjCNB2LPytHfYo/6AF4oOyxsDVgjNzfhMnUYuBnxt+YU
	Gx8JkowBnnMF2sAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783092640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3FnkbweO7PTivvYq83i0xDcPHibclqlDcUyPo7xbJNY=;
	b=RtdAwQv6qoNxZPMJKS2VnNfDC/gW6V0WecrGzBNp9SEu4/CyY9NCR1n13ocAH6slcfnI0D
	s7wsN3LdAa/vGZWDQL6RyCBTnB67kGQUhVEQzyKjhr74TepwFN3KzEbp6Bp2I6knRyMcq0
	jSzbfaau8XpxMHfGJL5/e0x+RhIrev8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783092640;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3FnkbweO7PTivvYq83i0xDcPHibclqlDcUyPo7xbJNY=;
	b=IA/VQqQh2XCb2dhtofZPrs3psIHjCNB2LPytHfYo/6AF4oOyxsDVgjNzfhMnUYuBnxt+YU
	Gx8JkowBnnMF2sAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C17A779AA;
	Fri,  3 Jul 2026 15:30:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mq0ZJqDVR2pEVgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 15:30:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3D51BA12D4; Fri, 03 Jul 2026 17:30:40 +0200 (CEST)
Date: Fri, 3 Jul 2026 17:30:40 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Tao Ma <boyu.mt@taobao.com>, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] ext4: use fsdata to track inline data write state
 and fix race
Message-ID: <cmridfqhuh7yfcewtpdgdflk3wpj4da2dh43bcruivtdqs2m2b@mhvuhr3dp7tt>
References: <20260703045414.1768-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703045414.1768-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,taobao.com,syzkaller.appspotmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 03-07-26 04:54:12, Aditya Srivastava wrote:
> From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> 
> Instead of checking the live inode state (ext4_has_inline_data(inode)
> and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
> write_end handlers, use the fsdata parameter of the address space
> operations to explicitly pass down the state in which write_begin
> prepared the write.
> 
> A concurrent thread (such as ext4_page_mkwrite()) can convert the
> inline data to an extent between write_begin and write_end. If this
> happens, the write_end handlers would previously miss the inline
> write_end path and fall through to extent-based write_end logic.
> However, since block buffers were never allocated in write_begin,
> this resulted in NULL pointer dereferences or data loss because
> folio_buffers(folio) was NULL.
> 
> Define EXT4_WRITE_DATA_INLINE (4) as a bit flag (Bit 2), treating
> fsdata as bitwise flags rather than mutually exclusive enums to keep
> states of the write path independent. Communicate this state via
> fsdata:
> 1) ext4_write_begin() and ext4_da_write_begin() set the
>    EXT4_WRITE_DATA_INLINE bit in *fsdata via bitwise OR when an inline
>    write is successfully prepared.
> 2) On entry, ext4_write_begin() clears the EXT4_WRITE_DATA_INLINE bit
>    to safely handle VFS retries (where generic_perform_write() bypasses
>    the fsdata initialization on its retry jump).
> 3) The write_end handlers perform a bitwise AND to check if the
>    EXT4_WRITE_DATA_INLINE bit is set and invoke the inline write_end
>    helper accordingly.
> 
> Furthermore, during a buffered write, ext4_write_inline_data_end()
> acquires the xattr lock after preparing the write. If a concurrent
> page fault (ext4_page_mkwrite()) converts the inline data to an extent
> after the write_end handlers check the state but before
> ext4_write_inline_data_end() acquires the xattr write lock, the
> subsequent check will trigger a kernel panic via
> BUG_ON(!ext4_has_inline_data(inode)).
> 
> To keep git history working and bisectability clean, replace the
> BUG_ON check in ext4_write_inline_data_end() with a graceful error-
> handling retry path in this same commit. If the inline data is cleared
> after locking the xattr, we safely release all resources (releasing
> iloc.bh, unlocking/putting the folio, stopping the active journal
> transaction handle) and return 0 (VFS retry) to let the generic write
> path retry the operation safely.
> 
> Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
> Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v4:
> - Resent the bug fix (Patch 1) and the cleanup (Patch 2) as a unified
>   2-patch series to ensure clean upstream application and perfect
>   logical separation, as suggested by Jan Kara.
> 
> Changes in v3:
> - Changed EXT4_WRITE_DATA_INLINE to 4 (Bit 2) and treat fsdata as
>   bitwise flags, allowing decoupling of independent states in the
>   write path (e.g. standard fallback and inline writes), as suggested
>   by Jan Kara.
> - Clear the EXT4_WRITE_DATA_INLINE bit on entry to ext4_write_begin() to
>   safely unroll state for any VFS write retries.
> - Perform bitwise AND checks for EXT4_WRITE_DATA_INLINE and
>   FALL_BACK_TO_NONDELALLOC flags in the write_end and da_write_end
>   handlers.
> 
> Changes in v2:
> - Folded the BUG_ON fix from the second patch into the first one to
>   ensure bisectability across git history, as suggested by Jan Kara.
> - Removed the pointless initialization `*fsdata = NULL` on entry to
>   `ext4_write_begin()`.
> - Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.
> 
>  fs/ext4/ext4.h   |  1 +
>  fs/ext4/inline.c | 14 +++++++++++++-
>  fs/ext4/inode.c  | 24 +++++++++++++-----------
>  3 files changed, 27 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index b37c136ea3ab..9e6f6467bdeb 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
>  void ext4_set_inode_mapping_order(struct inode *inode);
>  #define FALL_BACK_TO_NONDELALLOC 1
>  #define CONVERT_INLINE_DATA	 2
> +#define EXT4_WRITE_DATA_INLINE	 4
>  
>  typedef enum {
>  	EXT4_IGET_NORMAL =	0,
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..cfd591dc1d9c 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
>  			goto out;
>  		}
>  		ext4_write_lock_xattr(inode, &no_expand);
> -		BUG_ON(!ext4_has_inline_data(inode));
> +		/*
> +		 * We could have raced with ext4_page_mkwrite() converting
> +		 * the inode and clearing the inline data flag, so we just
> +		 * release resources and retry the whole write.
> +		 */
> +		if (unlikely(!ext4_has_inline_data(inode))) {
> +			ext4_write_unlock_xattr(inode, &no_expand);
> +			brelse(iloc.bh);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			ext4_journal_stop(handle);
> +			return 0;
> +		}
>  
>  		/*
>  		 * ei->i_inline_off may have changed since
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce99807c5f5b..4e1bf54e511d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1302,6 +1302,8 @@ static int ext4_write_begin(const struct kiocb *iocb,
>  	if (unlikely(ret))
>  		return ret;
>  
> +	*fsdata = (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);
> +
>  	trace_ext4_write_begin(inode, pos, len);
>  	/*
>  	 * Reserve one block more for addition to orphan list in case
> @@ -1316,8 +1318,10 @@ static int ext4_write_begin(const struct kiocb *iocb,
>  						    foliop);
>  		if (ret < 0)
>  			return ret;
> -		if (ret == 1)
> +		if (ret == 1) {
> +			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
>  			return 0;
> +		}
>  	}
>  
>  	/*
> @@ -1450,8 +1454,7 @@ static int ext4_write_end(const struct kiocb *iocb,
>  
>  	trace_ext4_write_end(inode, pos, len, copied);
>  
> -	if (ext4_has_inline_data(inode) &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> @@ -1560,8 +1563,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  
>  	BUG_ON(!ext4_handle_valid(handle));
>  
> -	if (ext4_has_inline_data(inode) &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
> +	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> @@ -3161,8 +3163,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
>  						     foliop, fsdata, true);
>  		if (ret < 0)
>  			return ret;
> -		if (ret == 1)
> +		if (ret == 1) {
> +			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
>  			return 0;
> +		}
>  	}
>  
>  retry:
> @@ -3291,17 +3295,15 @@ static int ext4_da_write_end(const struct kiocb *iocb,
>  			     struct folio *folio, void *fsdata)
>  {
>  	struct inode *inode = mapping->host;
> -	int write_mode = (int)(unsigned long)fsdata;
> +	unsigned long write_mode = (unsigned long)fsdata;
>  
> -	if (write_mode == FALL_BACK_TO_NONDELALLOC)
> +	if (write_mode & FALL_BACK_TO_NONDELALLOC)
>  		return ext4_write_end(iocb, mapping, pos,
>  				      len, copied, folio, fsdata);
>  
>  	trace_ext4_da_write_end(inode, pos, len, copied);
>  
> -	if (write_mode != CONVERT_INLINE_DATA &&
> -	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
> -	    ext4_has_inline_data(inode))
> +	if (write_mode & EXT4_WRITE_DATA_INLINE)
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
