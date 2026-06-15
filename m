Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996A53D9689
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781515634; cv=none; b=ppgSSpUR2orXMkSqaym5Y3qi+/JfTJ/0UCTA3TaDUff+MhxVneX0wtfGYkvQh7Nlrzw/7G+IClO5TC6q32EQonaAobkpryjpfEVCt2osg2m7epBm33J4jkKwU6MOQvu7SX6TmJo5/j9Zs5cgkUvV7iUvG4g+YYrcmZolsNisRLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781515634; c=relaxed/simple;
	bh=wyEmrp8P0LJIzXEMehkMmQXolPxGBdd4nY5Fy+tW5MI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jzcqs/o0McMXnxud2v3Kra+HPWxqn7X22k2w0p712P2brlLgqd9ujiCgc3iv3OS3trdTvHUaT9Y1Xf8IABOEG0Opnfb9dhrPGOdXRFM0yJniyTYN1YlCqVzyeOs0qhcxrJTs67gdnUz+USYyzQ9f1a+fbEc8QrLkYLSt/qo9TqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qra8Lx8T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6W0rEu/P; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PvxXX2Me; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XydQo6df; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qra8Lx8T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6W0rEu/P";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PvxXX2Me";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XydQo6df"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 313246AAFD;
	Mon, 15 Jun 2026 09:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781515624; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCVdrbBWTiqr8/TE6m0ijj+PpBBIoPAkiu5wN+WKi2w=;
	b=qra8Lx8T+amdWIVaf/pl0IfWWn/8OcgaBuSF79zIXIK/oCH/hHXDjoTwFBrVdou/ii+ekg
	F1Z2G82U47SShZiVjFvRXcsUVMZt3zB3d889O/AXUQPzt6JhbHdk/yXXKZvJvVezkjlLZl
	1soHiqA1IuHxRxkGOUSiOeZ9FvhtyWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781515624;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCVdrbBWTiqr8/TE6m0ijj+PpBBIoPAkiu5wN+WKi2w=;
	b=6W0rEu/PuVWcrmM2oc4Ceebvz/WDORdfyDEGMdN6aHgmSmhZNymIAiEzsO/GwA42365GvC
	cZnpN85+8hAMu4Aw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PvxXX2Me;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XydQo6df
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781515623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCVdrbBWTiqr8/TE6m0ijj+PpBBIoPAkiu5wN+WKi2w=;
	b=PvxXX2Me8JYugwHOqxt61PH5Th7Z+FeazhKdoVCveJhr2HpO83sdF1GsTMpxuaGHu+ah1m
	mhI4DNwrezpmN1QLePqrQw4jakdTbOH8jz93D0uhvL4BtfUKkcTmha/R0KR10yOtw4GLHX
	bbjk4X9opoquWbehun66f3i7B7D9z1s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781515623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WCVdrbBWTiqr8/TE6m0ijj+PpBBIoPAkiu5wN+WKi2w=;
	b=XydQo6dfacpH+efuqKOKiEhvqOlQDkMXYJIMmnjXmjE3zKEA8oIp/HZaGpsudmJUsXww8r
	7bAMYHWTVDO6yrCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 271B9779A7;
	Mon, 15 Jun 2026 09:27:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ip6HCWfFL2rJPAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 09:27:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB4D5A10D2; Mon, 15 Jun 2026 11:27:02 +0200 (CEST)
Date: Mon, 15 Jun 2026 11:27:02 +0200
From: Jan Kara <jack@suse.cz>
To: Xiang Mei <xmei5@asu.edu>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH ext4 v3] ext4: fix out-of-bounds read in
 ext4_read_inline_dir()
Message-ID: <cohsy6t4qa7pxub7knepgd6nckybqx2xt7ps33zh7fwkx6p3ac@dswnh7vxc572>
References: <20260613221836.556019-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613221836.556019-1-xmei5@asu.edu>
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
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,asu.edu:email,suse.cz:dkim]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 313246AAFD
X-Spam-Score: -2.51

On Sat 13-06-26 15:18:36, Xiang Mei wrote:
> ext4_read_inline_dir() can read a dirent header past the end of its inline
> buffer, triggering a slab-out-of-bounds read during getdents64():
> 
>   BUG: KASAN: slab-out-of-bounds in __ext4_check_dir_entry
>   Read of size 2 at addr ffff88800f3dd23c by task exploit/148
>    ...
>    __ext4_check_dir_entry
>    ext4_read_inline_dir
>    iterate_dir
> 
> The dirent payload lives in a buffer of exactly inline_size bytes:
> 
> 	dir_buf = kmalloc(inline_size, GFP_NOFS);
> 
> but iteration runs in a position space extra_offset bytes larger
> (extra_size = extra_offset + inline_size) so the synthetic "." and ".."
> land at their block-dir offsets. A dirent is formed at "dir_buf + pos -
> extra_offset", yet the loop bound (ctx->pos < extra_size) and the
> ext4_check_dir_entry() length argument both use the larger extra_size. A
> ctx->pos that is valid in extra_size space but whose de lies past 
> inline_size is therefore accepted, and the rescan loop's rec_len probe 
> and ext4_check_dir_entry() dereference de->rec_len before the entry is
> rejected.
> 
> Bound the dirent header by inline_size in both loops: break out of the
> rescan loop once a minimum-size header no longer fits, reject such a
> position in the main loop before forming de, and pass inline_size rather
> than extra_size to ext4_check_dir_entry().
> 
> Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Looks mostly good, just one simplification suggestion below:

> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..1266c8827cca 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1454,6 +1454,9 @@ int ext4_read_inline_dir(struct file *file,
>  			/* for other entry, the real offset in
>  			 * the buf has to be tuned accordingly.
>  			 */
> +			if (i - extra_offset + ext4_dir_rec_len(1, NULL) >
> +			    inline_size)
> +				break;

Since 'i' lives in "dir logical offset space", it might be simpler to check
this as:
			if (i + ext4_dir_rec_len(1, NULL) > extra_size)


>  			de = (struct ext4_dir_entry_2 *)
>  				(dir_buf + i - extra_offset);
>  			/* It's too expensive to do a full
> @@ -1488,10 +1491,18 @@ int ext4_read_inline_dir(struct file *file,
>  			continue;
>  		}
>  
> +		/*
> +		 * de lives at dir_buf + ctx->pos - extra_offset, within the
> +		 * kmalloc(inline_size) buffer.  Make sure its header fits before
> +		 * ext4_check_dir_entry() dereferences de->rec_len.
> +		 */
> +		if (ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
> +		    inline_size)

Similarly here this could be checked as:

		if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)

which is both more consistent with the loop termination condition and saves
the conversion from logical offset to physical offset.

Otherwise the patch looks good.

								Honza

> +			goto out;
>  		de = (struct ext4_dir_entry_2 *)
>  			(dir_buf + ctx->pos - extra_offset);
>  		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
> -					 extra_size, ctx->pos))
> +					 inline_size, ctx->pos))
>  			goto out;
>  		if (le32_to_cpu(de->inode)) {
>  			if (!dir_emit(ctx, de->name, de->name_len,
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
