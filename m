Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A764A1E02;
	Thu, 24 Sep 2026 16:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790269016; cv=none; b=cOXj3qkEggGsAlHvTXHuhI2Purk6ebPdg2BCiJziVp8jTipDWazpm7PbvwpSI6RH5cFdvqBKkzIDtwYRoD5gj0tCaD417hdU8yesL3NTGFwNp0v3uwXu5MNf3rMQ4s56Y0LIn5BjPV6Ff/mzrNid9dbTKjR/qFGdDWLJKwhtyWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790269016; c=relaxed/simple;
	bh=6GoBYB20cNxu/nXI4zC2xvZw5WS3sdmYWWg1srXYBWg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qENmCTp0qnccCknylWy+qdg/KbGyJFH7g1K2q5l7Wnb64gOK5goP7SEAxQeJjburIN/9aZW149fndm6A1+IhH/rVuNZqOBSBgP02EsJgEVezSYPc+5zOgrtZdMr+DNnZmPBNUJcVsITOLK7+CoHGgrXqcdovIk8oxASHUq07/Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D79S1lvn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/j42n/1x; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TDVXUjny; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RAdzgSla; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D79S1lvn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/j42n/1x";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TDVXUjny";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RAdzgSla"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 953F6200E2;
	Thu, 24 Sep 2026 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieJvlrAgk+y/IIunMtd5uXKsQGJx+qv4AsIourcCCbw=;
	b=D79S1lvnOmv4eA4aLqE72WH5VuMNXzyXjlh7Aj8P1a3TEeawfzhHXzM2MPThpB1iChr1rc
	XAiv4nsmxW+dNc3e+ZYGdzT+8yXSIkU3WFraAZHm6qbZBrCaCeKw5MFxmpO7Dx7AxSr/Ma
	rhwkHhZ498XNKNrPZcZixKyEfZH1D20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269008;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieJvlrAgk+y/IIunMtd5uXKsQGJx+qv4AsIourcCCbw=;
	b=/j42n/1xrNTp8UUvNhWPQEBzcBL7IYy2kQmUU/4FSDJdgNps5c5F1Az/xWoA3UxM10Pi61
	/t5NrrCMJhSCR7Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TDVXUjny;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RAdzgSla
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790269004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieJvlrAgk+y/IIunMtd5uXKsQGJx+qv4AsIourcCCbw=;
	b=TDVXUjnyVHwuFhIPaGjnkTEEEXyztBJH4+KecIRtzrtWqtvOqLPiZ9M4scb7EnBuB0EDio
	UH1Fp8SDFCHT2SXlaG+BGGquMHgy4abRoqEgJKAWqKwo71YLCpFv7MpL7mmgpcfd5J8Zud
	bglC1jEOYpsaELo4y89n2YsT0FrIbaE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790269004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ieJvlrAgk+y/IIunMtd5uXKsQGJx+qv4AsIourcCCbw=;
	b=RAdzgSlauPkvkdUG0C6RXec1vWQwtrmNSTQcq/rc4x/piFUgHnHeAAcvys57ponMWg3zmc
	kw39rHwf/UzJoOAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CE8213354;
	Thu, 24 Sep 2026 16:56:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aJdmEkxWtWp3OgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:56:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0F41A132E; Thu, 24 Sep 2026 18:56:39 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:56:39 +0200
From: Jan Kara <jack@suse.cz>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3] ext4: drop extra ea_inode ref in cached-block reuse
 path
Message-ID: <p72ohr4pnixuhsi4mve2saudzmcomxb6h2tamvl6qwnr7msiyi@q2gcmmhmyjvp>
References: <20260916071046.2182813-1-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916071046.2182813-1-matthias.goergens@gmail.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 953F6200E2
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
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim,suse.cz:email,sashiko.dev:url]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Wed 16-09-26 15:10:46, Matthias Goergens wrote:
> ext4_xattr_block_set() takes a reference on the ea_inode via
> ext4_xattr_inode_lookup_create() before it builds the new xattr block.
> The new-block path drops that reference once
> ext4_xattr_inode_inc_ref_all() has counted every entry in the block.
> When a separately built block is discarded in favour of an identical
> cached block, the cached block already counts its entries and the
> lookup reference is left unbalanced.
> 
> Each affected reuse leaks one on-disk reference, and the ea_inode and
> its data blocks stay allocated after the last xattr referring to them
> is gone.  Setting the same xattr on two files is enough when the value
> needs an EA inode and the entry does not fit in the inode body: the
> second set reuses the first file's block and leaves the ea_inode at
> refcount 2, and removing the xattr from both files leaves it at 1.
> 
> Drop the reference when the entry was not written into the old block in
> place.  new_bh != bs->bh is not the right test: the in-place path can
> reach 'inserted' and match a different cached block, and there the
> reference belongs to the old block and ext4_xattr_release_block() drops
> it, so dropping it here too would under-count.  Conversely, new_bh ==
> bs->bh with a cloned s->base (re-setting an unchanged external value on
> a shared block) leaks the reference as well, so the check follows both
> branches.
> 
> If the decrement fails the filesystem is already broken: report the
> error and return it without rolling back, putting and clearing ea_inode
> first so that cleanup does not retry the decrement.  The reused block
> keeps its incremented refcount and its block quota charge; e2fsck
> corrects the refcount.
> 
> Found by the Sashiko AI review bot while reviewing commit 54b6bd40898d
> ("ext4: stop retrying saturated xattr cache entries"):
> https://sashiko.dev/#/patchset/20260802065941.1726052-1-matthias.goergens@gmail.com?part=1
> 
> Fixes: 0a46ef234756 ("ext4: do not create EA inode under buffer lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>

Grumble. This code is really subtle and needs some simplification. But your
fix looks good to me now so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v3:
> - Error path per Jan: report with ext4_error_inode() and return, no
>   unwinding.  Put and clear ea_inode there so cleanup does not retry the
>   decrement.  After a successful decrement the branch reaches cleanup
>   with error == 0, which only puts the inode, so nothing is needed there.
>   The new-block path is unchanged.
> - Keep the in-place condition instead of new_bh != bs->bh; reasons and
>   measurements in the reply to v2.
> - Changelog: the normal-path leak does not retain quota charges; state
>   the preconditions of the example.
> - Shorter comment, EXT4_ERROR_INODE(); rebased onto ext4 dev; Cc stable.
> v2: fail the operation on a failed decrement instead of masking it.
>  fs/ext4/xattr.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b9650..d9e60b5952d2d 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2113,6 +2113,24 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
>  			mb_cache_entry_touch(ea_block_cache, ce);
>  			mb_cache_entry_put(ea_block_cache, ce);
>  			ce = NULL;
> +			if (ea_inode && !(bs->bh && s->base == bs->bh->b_data)) {
> +				/*
> +				 * The cached block already owns its EA inode
> +				 * references.  For an in-place update the lookup
> +				 * reference belongs to the old block and is
> +				 * dropped when that block is released.
> +				 */
> +				error = ext4_xattr_inode_dec_ref(handle,
> +								 ea_inode);
> +				if (error) {
> +					EXT4_ERROR_INODE(inode,
> +							 "dec ref error=%d",
> +							 error);
> +					ext4_put_ea_inode(ea_inode);
> +					ea_inode = NULL;
> +					goto cleanup;
> +				}
> +			}
>  		} else if (bs->bh && s->base == bs->bh->b_data) {
>  			/* We were modifying this block in-place. */
>  			ea_bdebug(bs->bh, "keeping this block");
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
