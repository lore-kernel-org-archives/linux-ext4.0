Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978456;
	b=uOKkDNgftqmvf2aJlGjpocbAY2VRleZa0jvj9YvzhPC2pBX/ZO3LwXgsZWxUOz9rmc2d
	 P1IvzcYDHjmW6FkLgkfMZvLWoh7ZaYYddujSdPSl/1RknWK+Dc20cW51n0w+VOy6O3kQ5
	 PxJwCQXg3pY8cVsQs3pcY6x5HfnKtuEmUYuHU81IukXgsKtrdGxFXKT6Rwcf2R/ZGvn3J
	 gpwENmvkJHa6cqFz+LFnws0GsBoKQAX3VJzWUgl7FuO1kDRB2eVSF/boH4QBWXIrEabqt
	 6jLVktJRWuJ3Jk5pCmLT8JhPPv7WIBmFIFzsQ06QPzB/GxwnbnvFEdMg+N63k8RZohg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978456;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=lOfcUzUxRduq192IgOhioYawIM/WrKSe+bEbqw39O/Y=;
	b=XgtXmoWhe4kghS6pX1Mxd23oYspzJs2pxBwAHIUmf30KJS/xyVvIjXtHEzV840Cp4NCN
	 VeLCWm0CcNyjmHLn7tTS+/A/MhtzSclPVSFEphGpUUCNjyxX3pAuh4FUEa4XqoOJBI3L7
	 qbXSRnVPRwKfUpScxCfStRU+Ejx/rhXLI7S+x1Ezrwg7YNWBWHcy197VwBwAhLZELSNti
	 QpArbg/QoX59nEnRci4XA3md8isRJr0M/ck4ZCbxQrDgZB6yWcdaatcyjI0so5CpNubxK
	 5wn8f0EsNIlgM2E6PI94ILK/p+4yfbHMDWmnfx43yi3E+K4G+hfOVGhgfvRIfRd8UKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=h9jZyoaq;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=38Ev3DWo;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=d4HclQzv;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iNcNz+AH;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22371606A334;
	Fri,  6 Nov 2026 15:20:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 22371606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=h9jZyoaq;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=38Ev3DWo;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=d4HclQzv;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=iNcNz+AH
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 47D921F452;
	Fri,  6 Nov 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOfcUzUxRduq192IgOhioYawIM/WrKSe+bEbqw39O/Y=;
	b=h9jZyoaq1B2i6H+A5hm/gINCxnKytThn6YMUvJtsOwN5elmRsfWoaj88+bviRl2WDV+RRb
	5iH/WRqcvVCP1vpbSqlJhHPwpOX0nLN91g9IfZAo6vGv8KDrABtmZklGfWp1q+L+9h8NSL
	c/i3cPWx9U2ftUep+3oHVuYVW0Hf9jg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978454;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOfcUzUxRduq192IgOhioYawIM/WrKSe+bEbqw39O/Y=;
	b=38Ev3DWobm9B+KYBtrSzLrwn5L8Fj8SB0xjgaj34P+PN2uYJy6zPnJalFNiCBhuLu7ctRo
	h16K74ufflA7lVCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d4HclQzv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iNcNz+AH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793978453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOfcUzUxRduq192IgOhioYawIM/WrKSe+bEbqw39O/Y=;
	b=d4HclQzv/UGG7b64v3tnPeQZO/ij/NGmRbS0pKFbsiEAx8S4arF+nq14MvkKEbbme2AHwq
	d5TnqxX005FUv8+ls6Ek8Hub4rETsb79c5+6qiu9YfWAixgh9MEdrPJlxRFfCONRpBjr/f
	36pZSW2wP/ITcCIPXDVADIUzuBhMLes=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793978453;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lOfcUzUxRduq192IgOhioYawIM/WrKSe+bEbqw39O/Y=;
	b=iNcNz+AHUW9J8Sz+onaGSvgxCoIqUZhqaSMW68R+Y9h92hACwCcECwphr80cmlCUE0c0YF
	Hue5rh/VX2DbggBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 20A06134E9;
	Fri,  6 Nov 2026 15:20:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2q0lAFXw7WrSKgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 15:20:53 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BC05721BB5; Fri, 06 Nov 2026 16:20:44 +0100 (CET)
Date: Fri, 6 Nov 2026 16:20:44 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC v2 05/13] ext4: don't read the inode block in
 ext4_sync_inode_metadata()
Message-ID: <lx65jq4bdbz7srd2ff5ozjalp6clkzwuuvmdqmk5v3wsnzsv6g@holn6db5xlc7>
References: <20261105-work-inode-metadata_writeback-v2-0-48628c60c336@kernel.org>
 <20261105-work-inode-metadata_writeback-v2-5-48628c60c336@kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-work-inode-metadata_writeback-v2-5-48628c60c336@kernel.org>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iloc.bh:url,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 47D921F452

On Thu 05-11-26 13:41:34, Christian Brauner wrote:
> Without a journal ext4_sync_inode_metadata() looks the inode table
> block up with __ext4_get_inode_loc_noinmem() which reads it from disk,
> with readahead of the inode table on top, if it isn't cached. But a
> block that isn't cached is neither dirty nor under writeback, so there's
> nothing to write or to wait for.
> 
> That read is also something we can't afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> ext4_get_inode_loc_noio() instead and treat -EAGAIN as nothing to do.
> 
> Note that ext4_get_inode_loc_noio() also returns -EAGAIN for a block
> that isn't uptodate. Such a block is being read or failed to be read
> and can't be dirty either. A block whose write failed still counts as
> uptodate for ext4_buffer_uptodate() so the write error still gets
> reported.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4484c2383eaf..18362580097f 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -6815,22 +6815,24 @@ int ext4_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>  	if (WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal))
>  		return -EFSCORRUPTED;
>  
> -	err = __ext4_get_inode_loc_noinmem(inode, &iloc);
> -	if (err)
> -		return err;
>  	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
>  	if (mmb) {
>  		err = mmb_sync(mmb);
>  		if (err)
> -			goto out;
> +			return err;
>  	}
> +	/* A block that isn't cached is neither dirty nor under writeback. */
> +	err = ext4_get_inode_loc_noio(inode, &iloc);
> +	if (err == -EAGAIN)
> +		return 0;
> +	if (err)
> +		return err;
>  	sync_dirty_buffer(iloc.bh);
>  	if (buffer_write_io_error(iloc.bh)) {
>  		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
>  				       "IO error syncing inode");
>  		err = -EIO;
>  	}
> -out:
>  	brelse(iloc.bh);
>  	return err;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
