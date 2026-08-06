Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1634D429031;
	Thu,  6 Aug 2026 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786009791; cv=none; b=OsjsTUn2XDj9vu7ZnBRmTlDRTFygIECoPg6i8+InTtDLWiCtmaHNGpPEKV2CS4O1Wnf55oL7K3aNO3LiaM7xkj+R1RLMn1T3YvTXowS+rdBcbkUixQF1gF5BnElNWYea5tNQL7QfegXZ14+DU9aKdqEiHt8EP2m6ZhNk7f8oHig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786009791; c=relaxed/simple;
	bh=PyyR5u0EwuW47gTLnNkcMk78neRvuMUXDXEXfBD8Y0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O6Qztlp755h3xkD7sqck2Lju6j60Es2Pk0zyBkkhHVM1i4J0htuunS6FPXcizoDEfUSMOUCVRz2VuXURFQ2/5JPjG1ui2+SyeVIGsenrP1FuDKeWMaG0usE4qTAkTWL9+N4+71yvZzOeGCEQ/sPtPZR/AnOie6MKmsyjpqSHzQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vMEJTmnk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5bhgTQsY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qZMkqYPW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=m8Ox6hDw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vMEJTmnk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5bhgTQsY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qZMkqYPW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="m8Ox6hDw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E6EA37FF7E;
	Thu,  6 Aug 2026 09:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786009784; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zA/GI9E1r/G2Vxu4AUDo+MgvMEhwayxaYlFyHlnEBPg=;
	b=vMEJTmnkBN1paRd8FHiK0iLFXlsafaMqzlP9MvEWRlENhr5Bl1DOg0ERrTDz4aJw7JK5mU
	9ebZxWqDJLTp1WEg+Ls+1HWX4Va1SmgFe7x9AbkuI6fOXPumVnnB4xxh5KbtU2sNJj6LDU
	39ZyOLsatVi4+pGu3MolfrfmKJ7mf68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786009784;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zA/GI9E1r/G2Vxu4AUDo+MgvMEhwayxaYlFyHlnEBPg=;
	b=5bhgTQsYFRB2PdwSfxp09LNiLQ3SMBRHdKWkkNh1i5uFKtmHFO3imvB8dYmtF9pkanNiqj
	+jK+H5RiZxzJ7vBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786009779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zA/GI9E1r/G2Vxu4AUDo+MgvMEhwayxaYlFyHlnEBPg=;
	b=qZMkqYPWY1LWkYz6IjTs+xFfKSlaH7Ot9q3pFfZY1WrV3PUGg0qAm1Xwf73HziSOVPYy1R
	P6In0yRlU596GsmbfMuKjOYNowjO5pdqmL0C2vQElZfrlq8ILWZ01pEolDgElqcsecNTcu
	5yOqQaF34IqQ8fxvChuzU+uGndf2hKI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786009779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zA/GI9E1r/G2Vxu4AUDo+MgvMEhwayxaYlFyHlnEBPg=;
	b=m8Ox6hDwOQ0m1VhpEEqw1o89dApl0UlW9A+gEXghE5La8D7GLoIwRa+eveGZ7EHpz7g2Jh
	In+7XDxrJDE7iPDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD50C779BF;
	Thu,  6 Aug 2026 09:49:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dTUCNrNYdGrvPwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 06 Aug 2026 09:49:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8CABAA13B1; Thu, 06 Aug 2026 11:49:31 +0200 (CEST)
Date: Thu, 6 Aug 2026 11:49:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Joseph Qi <joseph.qi@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] ext4: fix readdir position truncation on 32-bit
 kernels
Message-ID: <jodqssdetawej6xytscjgfia72awx4exvjhdorksgiimrpfilw@nddk3kvjipn4>
References: <20260806022044.167962-1-zhanxusheng@xiaomi.com>
 <20260806022044.167962-2-zhanxusheng@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806022044.167962-2-zhanxusheng@xiaomi.com>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	URIBL_BLOCKED(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,xiaomi.com:email];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fasheh.com,evilplan.org,linux-foundation.org,vger.kernel.org,lists.linux.dev,xiaomi.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,xiaomi.com:email]

On Thu 06-08-26 10:20:43, Zhan Xusheng wrote:
> In ext4_readdir(), the directory cookie position is rebuilt with
> 
> 	ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1)) | offset;
> 
> `ctx->pos` is loff_t (signed 64-bit), while `sb->s_blocksize` is
> unsigned long.  On 32-bit kernels unsigned long is 32-bit, so the mask
> 
> 	~(sb->s_blocksize - 1)
> 
> is computed as a 32-bit unsigned value (e.g. 0xfffff000 for a 4 KiB
> block size).  In the AND expression with the 64-bit `ctx->pos`, that
> unsigned operand is zero-extended to 64 bits per the usual arithmetic
> conversions, yielding 0x00000000fffff000.  The high 32 bits of
> `ctx->pos` are silently cleared, even though directory size is
> allowed to exceed 4 GiB on 32-bit (s_maxbytes for ext4 is many TiB).
> 
> When readdir() crosses the 4 GiB boundary on a 32-bit kernel the
> position is reset back into the first 4 GiB block, making the
> re-validation path re-enumerate already-returned dirents indefinitely.
> 
> ext4_readdir() reaches this linear path for non-indexed directories, and
> as the fallback after ext4_dx_readdir() returns ERR_BAD_DX_DIR, so a
> directory large enough to cross 4 GiB can hit it.
> 
> This is the same class of bug that commit 3dce5bb82c97 ("exfat: Fix
> bitwise operation having different size") fixed in exfat.  Cast the
> operand to loff_t so the mask is 64-bit before the AND:
> 
> 	ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1)) | offset;
> 
> 64-bit kernels are unaffected (unsigned long is 64-bit there, no
> truncation occurs).
> 
> The truncation was confirmed with a freestanding 32-bit test program
> mirroring the kernel expression: input ctx->pos = 0x100000100 produces
> output 0x100 with the unfixed expression and 0x100000100 with the
> cast.
> 
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>

I'll note this is a very theoretical issue. I don't think your life it long
enough to create a 4GB non-indexed directory in ext4 :) (due to quadratic
complexity of the adding of directory entry). But the fix is right so feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 17edd678fa87..8113f43d4989 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -252,7 +252,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  							    sb->s_blocksize);
>  			}
>  			offset = i;
> -			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
> +			ctx->pos = (ctx->pos & ~((loff_t)sb->s_blocksize - 1))
>  				| offset;
>  			info->cookie = inode_query_iversion(inode);
>  		}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
