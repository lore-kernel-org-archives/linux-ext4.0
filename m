Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1320F49E13F;
	Tue,  6 Oct 2026 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303431; cv=none; b=lq/tG2vvi7itu0lEvQtz81xIm409h/BNkqBkT0qO0uCadGF0u6hrFuN56Z68kAB78DWd+TjGWKkZfd4xqtvL5d2iCvfBIrK77qHn0Lr8LZ8YRHwILw+GUMMrcXxC6xcmxcaFdUAO12nrHsZhE7UrGp1nQbxfcMfY9iw6FlUxlKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303431; c=relaxed/simple;
	bh=PczUcbNg4hIwm4j3OVoMKwDwH7cBMxGxmCO+d4NCjgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTcnlDzbzpx5eajsrW7gUV7fNHcsDzDUzwlIcoofE253fg5VQHY18OWr2njkKBaPhUITWWBHniFwWX+SMc91CBG+4GN+9yC3v1XWpEfEMz/ro4z8kv98832NHnZ27Ib26H/QaQlxxAQSmUZJplwfjnMffgVWyBtnTKY2Aq4oGRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yswJp7mk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c2IzJ9k3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Bq9XnZGZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mV90ntUf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yswJp7mk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c2IzJ9k3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Bq9XnZGZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mV90ntUf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 865BA1F790;
	Tue,  6 Oct 2026 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791303423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ns/hZi66/IrEl2Y6Vcc6eI+8eCzOlyk0H+fCfWrrKR0=;
	b=yswJp7mkQ2kuBhF3Gy+GUyAhb0Ny+pTQ41frbawuJ+Hu3qCgaIwju1ZCBGbNmj8iDABbbb
	zf6UtRKO83WbGWxHlGnAhvjbPFx4b2uffm0nXkdauORoMk6bD/MlI5BzBTKYICeSJDgJCC
	zS1zjnCOoJHJYmZ5HKBalX4s8/34c5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791303423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ns/hZi66/IrEl2Y6Vcc6eI+8eCzOlyk0H+fCfWrrKR0=;
	b=c2IzJ9k3+3VrL+2m3IuzNN295pCfNZ8wBjLfVkXVc4zJBIhUMgNZzZyX29z+o/oFYe1kHF
	6euJuKX0i4rytFBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791303419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ns/hZi66/IrEl2Y6Vcc6eI+8eCzOlyk0H+fCfWrrKR0=;
	b=Bq9XnZGZr0VXvS70w8VGf3MNy3GeToFxxi5uymn8x2rOnpe45RdE1K2ElQgFBAweMEDUNX
	IG0yDrJJzR5kggNKhgNgYL1/Xvnc0xTjyc2OkAH6Q0mz4YW45YJ+9Ouogn4WQPxbtqAYAP
	32NgtplKOKGy+rUrNuHrNM4eg3mLzUA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791303419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ns/hZi66/IrEl2Y6Vcc6eI+8eCzOlyk0H+fCfWrrKR0=;
	b=mV90ntUfNhFbcYzuTq/60ooElRqmBW9NumUgnB4t/7STxofAh9UA5y8fXSRIfdXOHm6MKG
	Q13hTDxAg+b8gDDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3752D137AC;
	Tue,  6 Oct 2026 16:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NvFABPsexWqhIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 06 Oct 2026 16:16:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7D7FBA13FA; Tue, 06 Oct 2026 18:16:58 +0200 (CEST)
Date: Tue, 6 Oct 2026 18:16:58 +0200
From: Jan Kara <jack@suse.cz>
To: hengyul@cs.unc.edu
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not accept rec_len 0 for block sizes below 64k
Message-ID: <qvaeibtro3i7xxpxbgomjmsvnaejtlo5if57lp5aeowl42e6v2@x3ckk5ovep4s>
References: <20261006111546.3252481-1-hengyul@cs.unc.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006111546.3252481-1-hengyul@cs.unc.edu>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,unc.edu:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 06-10-26 07:15:46, hengyul@cs.unc.edu wrote:
> From: Hengyu Liang <hengyul@cs.unc.edu>
> 
> Commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion") made ext4_rec_len_from_disk() read a rec_len of 0 as "this
> entry covers the whole block" for every block size.
> 
> However, this special value only exists for block sizes of 64k and
> more. With smaller blocks, a rec_len of 0 means that the directory
> block is corrupted. As of now, a directory block that has been
> overwritten with zeroes is treated as an empty block. The kernel no
> longer reports the corruption and can store new entries in that block,
> while e2fsck still reports the block as corrupted.
> 
> The issue can be reproduced on a file system without metadata_csum:
> 
>     mke2fs -q -t ext4 -b 1024 -O ^metadata_csum,^dir_index img 8M
>     mount -o loop img /mnt
>     mkdir /mnt/d
>     for i in $(seq 100); do touch /mnt/d/file_with_a_long_name_$i; done
>     umount /mnt
>     dd if=/dev/zero of=img bs=1024 count=1 conv=notrunc \
>         seek=$(debugfs -R "bmap d 1" img)
>     mount -o loop img /mnt
>     touch /mnt/d/new
> 
> Before commit afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len
> conversion"), the last command fails with "Structure needs cleaning".
> After that commit, it succeeds.
> 
> This patch makes ext4_rec_len_from_disk() return the on-disk value
> unchanged when the block size is below 64k, as e2fsprogs does.
> 
> Fixes: afa6d5a16bf2 ("ext4: remove PAGE_SIZE checks for rec_len conversion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

BTW, the kernel never allowed larger than 64k block size so I'm kind of at
loss why we have that strange code trying to accommodate upto 256k
blocksize here. I'd just delete that code (not really related to your
chnage). Ted?

								Honza

> ---
>  fs/ext4/ext4.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 724a27e8be61..ab716a5ad6da 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -2611,6 +2611,13 @@ ext4_rec_len_from_disk(__le16 dlen, unsigned blocksize)
>  {
>  	unsigned len = le16_to_cpu(dlen);
>  
> +	/*
> +	 * Only blocks of 64k and more need the special encoding of rec_len.
> +	 * For smaller blocks 0 and EXT4_MAX_REC_LEN are not valid lengths
> +	 * and must not be taken for an entry that spans the whole block.
> +	 */
> +	if (blocksize < 65536)
> +		return len;
>  	if (len == EXT4_MAX_REC_LEN || len == 0)
>  		return blocksize;
>  	return (len & 65532) | ((len & 3) << 16);
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
