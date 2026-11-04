Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793812245;
	b=yDXEfHq8s079VdycZ2PUJxoTBcGKsbp3O8aWD13mGPZgovUOdktYNx6eHxMjuMI90/Wo
	 LaDATcQY/4F2MEnZmgCt0jOFEfF92hkx8NQUKlMldqawlZpWM/Jv6S2hxkhL7AMp9ceFv
	 +UwYusVTBgfrxPxJ/MEGUc6+g1qM00l+2t6oF3lSDBdjaSqJvju7X1cSND0yutLC8Jafh
	 oO0+I/wd7384/D6RUVv3NMjVRQiT5REIkquqNMtBfx938rQttUMihAgd+tTmczb7PnEo/
	 QUGj+F6OtqKHmSjWFmTm5Il0oBhTQT7TWFJO+T6hBJO1LAOzV0MGpuYVKLPL7dnC6WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793812245;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=D30F2COUpRWm4RgWLtR15DMQRtc5OYT+QP/IsyTc/Eg=;
	b=o+VAx30eM+yVg+NNfBqA4Co4alVP5s/APD5ehu4vxtYp8Of+VG48a3S5ULxxY8nGPKDI
	 o4DMN+zc80nFZ/mq4gJf2yhlIimQn1JEfBiVxC844cBsULlhqYe68x0UtNYha9aKBVqSM
	 HDVaa6Xl4DMCzjxz4ot4ZsPCHFX9dJNCLRyqkJKjGeMehFqy0hDKvZJCQ2S5VnIvH8s9S
	 uwEelgrq+RbFsq4fvBKmYjDPPXuJN6XafjI3HD7H4aSY3l0Z7vAf4g6RfV8kAeRPJeKqy
	 P02Zbm3thU8hWBAZ9jnC/f6R381aIarZrEnDc1hyB0ESknj51o+9NZe9LGQQJ4zKz3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N5wEywae;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5pN3p0dq;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N5wEywae;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5pN3p0dq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63386606A326;
	Wed,  4 Nov 2026 17:10:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63386606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N5wEywae;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5pN3p0dq;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=N5wEywae;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5pN3p0dq
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 662D61F388;
	Wed,  4 Nov 2026 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D30F2COUpRWm4RgWLtR15DMQRtc5OYT+QP/IsyTc/Eg=;
	b=N5wEywaei4uLeLuGqcWgzHVn6810BrOAXYyTfddvwYJVzEF1zUpg4g7gm0cDL4raNDSiT2
	uCsxaZtjCcs2R5IbOiM0wM4qHhVWGpVobEXs+V4JK0L9igsz0e92qB+eQo095kPIX9ySCZ
	J27qu7ixO4c79U1S+ondhxbqgHg+Y4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D30F2COUpRWm4RgWLtR15DMQRtc5OYT+QP/IsyTc/Eg=;
	b=5pN3p0dqrCPfqf4EPvuwBj+z8D+t36STm0XDTAvIOoCvnv92Vwkt1S5eHxfUARJhanvdsS
	joi2rcOz6kO46nAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793812243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D30F2COUpRWm4RgWLtR15DMQRtc5OYT+QP/IsyTc/Eg=;
	b=N5wEywaei4uLeLuGqcWgzHVn6810BrOAXYyTfddvwYJVzEF1zUpg4g7gm0cDL4raNDSiT2
	uCsxaZtjCcs2R5IbOiM0wM4qHhVWGpVobEXs+V4JK0L9igsz0e92qB+eQo095kPIX9ySCZ
	J27qu7ixO4c79U1S+ondhxbqgHg+Y4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793812243;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=D30F2COUpRWm4RgWLtR15DMQRtc5OYT+QP/IsyTc/Eg=;
	b=5pN3p0dqrCPfqf4EPvuwBj+z8D+t36STm0XDTAvIOoCvnv92Vwkt1S5eHxfUARJhanvdsS
	joi2rcOz6kO46nAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35956134A5;
	Wed,  4 Nov 2026 17:10:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7MlSAxNn62o0GQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Nov 2026 17:10:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BD9A9B44B; Wed, 04 Nov 2026 18:10:38 +0100 (CET)
Date: Wed, 4 Nov 2026 18:10:38 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, stable@vger.kernel.org
Subject: Re: [PATCH RFC 7/9] udf: don't allocate the inode block in
 udf_sync_inode_metadata()
Message-ID: <ptpyu55emuoooh6dspkwwy6efyvgtzjah5qzfgmz7lem72vntl@bmtap355aslj>
References: <20261029-work-inode-metadata_writeback-v1-0-7d6c678a585d@kernel.org>
 <20261029-work-inode-metadata_writeback-v1-7-7d6c678a585d@kernel.org>
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
In-Reply-To: <20261029-work-inode-metadata_writeback-v1-7-7d6c678a585d@kernel.org>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Thu 29-10-26 14:28:22, Christian Brauner wrote:
> udf_sync_inode_metadata() looks up the block that holds the inode with
> sb_getblk() which allocates a buffer for it if it isn't cached. But a
> block that isn't in the buffer cache is neither dirty nor under
> writeback. So there's nothing to write or to wait for and allocating a
> buffer that just gets thrown away again is pointless.
> 
> It's also not something we can afford once inode eviction calls
> ->sync_inode_metadata() from reclaim. So look the block up with
> sb_find_get_block_nonatomic() instead.
> 
> Cc: stable@vger.kernel.org # v7.3
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/inode.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index bacf2a86161e..59f8e9bde0b1 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1744,23 +1744,22 @@ int udf_sync_inode_metadata(struct inode *inode, struct writeback_control *wbc)
>  	struct buffer_head *bh;
>  	int err = 0;
>  
> -	bh = sb_getblk(inode->i_sb,
> +	/* A block that isn't cached is neither dirty nor under writeback. */
> +	bh = sb_find_get_block_nonatomic(inode->i_sb,
>  			udf_get_lb_pblock(inode->i_sb,
>  					  &UDF_I(inode)->i_location, 0));
> -	if (!bh)
> -		return -EIO;
> -
> -	sync_dirty_buffer(bh);
> -	if (buffer_write_io_error(bh)) {
> -		udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
> -			 inode->i_ino);
> -		err = -EIO;
> -		goto out;
> +	if (bh) {
> +		sync_dirty_buffer(bh);
> +		if (buffer_write_io_error(bh)) {
> +			udf_warn(inode->i_sb, "IO error syncing udf inode [%08llx]\n",
> +				 inode->i_ino);
> +			err = -EIO;
> +		}
> +		brelse(bh);
> +		if (err)
> +			return err;
>  	}
> -	err = mmb_sync(&UDF_I(inode)->i_metadata_bhs);
> -out:
> -	brelse(bh);
> -	return err;
> +	return mmb_sync(&UDF_I(inode)->i_metadata_bhs);
>  }
>  
>  static void udf_adjust_time(struct udf_inode_info *iinfo, struct timespec64 time)
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
