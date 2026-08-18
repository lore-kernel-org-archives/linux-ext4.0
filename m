Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB77478E57
	for <linux-ext4@vger.kernel.org>; Tue, 18 Aug 2026 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062186; cv=none; b=hcJwMyrL+jUxDbC8c9lbrUZJomE8URlADAOR4YhYTsGp0FAWecpHIVFNJTkQCParAZ+1RCCH2HbV3pv1UabMw6iwVTn34A2SC2eSxD6KVb00ConLpCuy9EzgWJa7y9mVAZJcvE1JKGEJIkxWDcgwkWdMDq+hFB8/l34o8WeZvcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062186; c=relaxed/simple;
	bh=burHHQtDRZ1pSWsZpc/Oe34IQTZhWV4Mj7ss0VFUY9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1D3iAywnTe2JnGvZWy0NH7nJewMIBtbxvQkLzaVne9vF+YapvuhlRsVzzQuRUG6yNwHyU61wpBjL6rlIFDVtkPOjILoJNN71As31i3TwxCdvEDCnVPrzk6EtFINfU1gUjttN6Wm8ApIHneZvKeufxdg9C+UL8RW0yG/fENUhb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=AYL1XjCA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aEiax5nw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vl/zKjEU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HPQJtw+3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="AYL1XjCA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aEiax5nw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vl/zKjEU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HPQJtw+3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1E5B845BC;
	Tue, 18 Aug 2026 14:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787062179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=066dYql/lijSuc7gvI+6k56CFO3ZtQ88ir+vs/oXVCY=;
	b=AYL1XjCABtk+vwdFfYZtZXihCQuGplUZCEyYGC/6ECchCqbcu1lXk0zTMFPci986s0j0MQ
	nXsi493Wn0GasK+wgILUXL/njRdG9NZvUvh+MKDtTmvrhAyfXRlhYEfl1/wY/1+qPkqiKO
	84T8RS7o0ON3LOMNA6Vxm7kp7hZqp2o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787062179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=066dYql/lijSuc7gvI+6k56CFO3ZtQ88ir+vs/oXVCY=;
	b=aEiax5nwFny6EKnkHzA93M6uDDD5n7BBwliHxSDwlQ2GIWfwBmUzrricjUT31QVDZ3Rmgo
	ysSX2sdCjiSKTFAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787062174; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=066dYql/lijSuc7gvI+6k56CFO3ZtQ88ir+vs/oXVCY=;
	b=vl/zKjEUB8MDE4Ps5O9s31mg73bweC1+sMmjDl5bnO6kKNZTblTHFKgTp+RO+zOH0ndcu7
	NgR55yh9RjxJdbaI8mfHwCVEHG38DZjWTusSiILZVvQfoxO/80GJpAXtjrjCTgXJqwpl2x
	PTDFqT6CQyghAp4WQ+01HDFY4yCxZmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787062174;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=066dYql/lijSuc7gvI+6k56CFO3ZtQ88ir+vs/oXVCY=;
	b=HPQJtw+3wcArmm55uW8Ij5McBdh1e59sdcnE2fFbg91wequDyralWcf4AO8zjwNXhS7Alv
	jizuuH2qR11p/ACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E3E4522BA;
	Tue, 18 Aug 2026 14:09:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id //l7N55nhGrYbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 18 Aug 2026 14:09:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 83977A13AB; Tue, 18 Aug 2026 16:09:30 +0200 (CEST)
Date: Tue, 18 Aug 2026 16:09:30 +0200
From: Jan Kara <jack@suse.cz>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
Subject: Re: [PATCH v2] ext4: drop extra ea_inode ref in cached-block reuse
 path
Message-ID: <kn66y456qvowbu4irzqtkl2ttrubknnir6yi5bdh4c7uup4ave@7b6ybqm2e7ya>
References: <20260812044556.2209787-1-matthias.goergens@gmail.com>
 <20260814065023.3466742-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814065023.3466742-1-matthias.goergens@gmail.com>
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
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Fri 14-08-26 14:50:23, Matthias Goergens wrote:
> ext4_xattr_block_set() acquires a reference to the ea_inode via
> ext4_xattr_inode_lookup_create() before constructing the new xattr
> block.  In the new-block allocation path this extra reference is dropped
> after ext4_xattr_inode_inc_ref_all() accounts for every entry in the
> block.  But when mbcache supplies an identical existing block and that
> block is reused, the cached block already carries the correct refcount
> for its entries, and the extra reference is never dropped.
> 
> The cleanup block at the end of the function only calls
> ext4_xattr_inode_dec_ref() when error is non-zero, so the success path
> through cache reuse leaks one refcount.  Each reuse event adds another;
> eventually the saturated refcount prevents the ea_inode from being freed
> when its last real reference is dropped.
> 
> Add the matching drop when the entry was not written directly to the old
> physical buffer (bs->bh && s->base == bs->bh->b_data).  In that case the
> reference belongs to the old buffer, which the later release_block()
> handles.  When s->base is a clone or a fresh allocation and is discarded
> in favour of the cached block, the extra reference must be dropped.
> 

Good find!

> v2:
> - The v1 dropped the reference best-effort: a failure was logged but
>   masked by the later "error = 0" on the success path, so the syscall
>   could succeed with the on-disk refcount one too high.  Fail the
>   operation instead, and undo the locally-owned part of the reuse
>   through ext4_xattr_reuse_undo(), the same helper the success path
>   uses for the old block.  Any reference that nonetheless persists
>   (e.g. under errors=continue) is repaired by e2fsck.
> - A failed decrement is never retried: it may already have mutated
>   the refcount before failing (e.g. an EA inode inheriting S_SYNC from
>   the root directory can fail ext4_mark_iloc_dirty() after the
>   mutation in nojournal mode), so a retry could decrement twice.  The
>   failure paths free the quota charge and drop the inode reference
>   directly.

The only reasons why ext4_xattr_inode_dec_ref() can fail are catastrophic
fs failures => no chance of keeping the fs consistent anyway. So just
reporting the issue with ext4_error_inode() and otherwise bailing out with
the least effort is the right thing. Sadly Sashiko is giving misguiding
recommendations in these cases.

> - Propagate the same masked failure at the new-block branch's
>   identical drop: it has always been best-effort (warn and continue).

This changelog belongs below the diffstat so that it doesn't get included
into the commit message. The comment about Sashiko belongs to the proper
changelog.

> Found by the Sashiko AI review bot while reviewing the xattr
> saturation-livelock fix.
> 
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  fs/ext4/xattr.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 57 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e228..0ce937d890042 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -1362,6 +1362,17 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
>  	return;
>  }
>  
> +/* Undo the locally-owned part of a cached-block reuse. */
> +static void ext4_xattr_reuse_undo(handle_t *handle, struct inode *inode,
> +				  struct buffer_head *bh)
> +{
> +	struct ext4_xattr_inode_array *ea_inode_array = NULL;
> +
> +	ext4_xattr_release_block(handle, inode, bh, &ea_inode_array,
> +				 0 /* extra_credits */);
> +	ext4_xattr_inode_array_free(ea_inode_array);
> +}
> +
>  /*
>   * Find the available free space for EAs. This also returns the total number of
>   * bytes used by EA entries.
> @@ -2107,6 +2118,39 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			mb_cache_entry_touch(ea_block_cache, ce);
>  			mb_cache_entry_put(ea_block_cache, ce);
>  			ce = NULL;
> +			if (!(bs->bh && s->base == bs->bh->b_data) &&
> +			    ea_inode) {
> +				/*
> +				 * The reused block already holds its own
> +				 * reference; drop the extra one unless the
> +				 * entry went into the old buffer directly.
> +				 */
> +				error = ext4_xattr_inode_dec_ref(handle,
> +								 ea_inode);

I can be missing something but why don't you just call
ext4_xattr_inode_dec_ref() like:
		if (new_bh) {
			if (new_bh == bs->bh)
			else {
				...
				/* here */
				if (ea_inode)
					ext4_xattr_inode_dec_ref()
			}

and be done with it? No need for more complicated condition, also no need
for iput() or clearing of ea_inode. That would look like the easiest
solution to me but I might be missing something subtle.

								Honza

> +				if (error) {
> +					/*
> +					 * The decrement may already have run;
> +					 * do not retry it: free the charge,
> +					 * undo the reuse, and fail the op.
> +					 */
> +					ext4_error_inode(inode, __func__,
> +							 __LINE__, 0,
> +							"dec ref error=%d",
> +							 error);
> +					ext4_xattr_inode_free_quota(inode,
> +								    ea_inode,
> +								    i_size_read(ea_inode));
> +					iput(ea_inode);
> +					ea_inode = NULL;
> +					if (new_bh != bs->bh)
> +						ext4_xattr_reuse_undo(handle,
> +								      inode,
> +								      new_bh);
> +					goto cleanup;
> +				}
> +				iput(ea_inode);
> +				ea_inode = NULL;
> +			}
>  		} else if (bs->bh && s->base == bs->bh->b_data) {
>  			/* We were modifying this block in-place. */
>  			ea_bdebug(bs->bh, "keeping this block");
> @@ -2143,13 +2187,21 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			if (error)
>  				goto getblk_failed;
>  			if (ea_inode) {
> -				/* Drop the extra ref on ea_inode. */
> +				/*
> +				 * Drop the extra ref on ea_inode; on
> +				 * failure the decrement may already have
> +				 * run, so just fail and free the block.
> +				 */
>  				error = ext4_xattr_inode_dec_ref(handle,
>  								 ea_inode);
> -				if (error)
> -					ext4_warning_inode(ea_inode,
> -							   "dec ref error=%d",
> -							   error);
> +				if (error) {
> +					ext4_xattr_inode_free_quota(inode,
> +								    ea_inode,
> +								    i_size_read(ea_inode));
> +					iput(ea_inode);
> +					ea_inode = NULL;
> +					goto getblk_failed;
> +				}
>  				iput(ea_inode);
>  				ea_inode = NULL;
>  			}
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
