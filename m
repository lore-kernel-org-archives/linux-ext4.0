Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77911C2AA
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 20:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555736; cv=none; b=CVu+8XXMyB9Uf5UnkXlwV/dN2Gl5izzvs8cx0EuuwgFxeLavRVPlcCV+s/FejE6pdDtbrUMMIveaY9RRMHC/lAIJi7Dff2uJrzCpjXjNO1LYOhqjcKc11vhp7lzelLRmqJTbFMOzU954lWI31uQGjE/oNIak5rkHRPxmxCoWI9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555736; c=relaxed/simple;
	bh=K+o79t85ZvwkaHFh19ly1gCKhHR7BMbjU27XVBNJPDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saaq25HrDNbSGHHHgdSBzlAYxyXccsuheU6uzsnuvKVJsuFoqXdlQHKpqamkiDW8QbbB6EPbpm5N7eb6Y7Jt8bVmRVLImZxcG/Y4ymAkC1JhmDUS8yU0GXCSFOwLUVWg/9XagG7XKg+vj2ZxPzsQen8xY1jk0tQ1Lk6lXij2+A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=G++1xeW6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ldCrnka0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=m34c7WeM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jdtPdrgU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="G++1xeW6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ldCrnka0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="m34c7WeM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jdtPdrgU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 90A4A6C646;
	Mon, 15 Jun 2026 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781555732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i19PoNxNTyu9sYlB5dhMU7kvBhy7p0KQxDuo/UmWPec=;
	b=G++1xeW6SNVaXvK3LknXt/Y7rnd6ux6lmVoz6i0yYSZINVzolK2Z3bvxSFKQ4MBmJQnKWb
	8zIDG0CfDcsbI7zjWx6UlaMpTBKAVZmwkaijWAdIlfrut6n9QUJB8TdT+rMFVKFk/qN0h5
	0v2JsEHgT2Pe34AHkXyQ2puawzNlWpU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781555732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i19PoNxNTyu9sYlB5dhMU7kvBhy7p0KQxDuo/UmWPec=;
	b=ldCrnka0k7qDMZhlDorfRbnrBuTptJ63iQAYVslaG0agB4iZ48zcHR4FKbmFsBosmbOzFC
	A5OQdcSBYNGgfsDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=m34c7WeM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jdtPdrgU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781555731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i19PoNxNTyu9sYlB5dhMU7kvBhy7p0KQxDuo/UmWPec=;
	b=m34c7WeMf/8eirnbKaMgp4HkD1mXG0onLKtR4J4bKtrf/hp1sy+6dNkenU9J/fYaS//Ebd
	1YAI7HAtkTLz1UOpfq3Y0x+LgST7W8f/rkwJmjfXScNEiYwEgEsheme5Y3tYrZrdN65oT8
	vRyrgebLnYv1Wrh/087emWRDhKOiP0I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781555731;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i19PoNxNTyu9sYlB5dhMU7kvBhy7p0KQxDuo/UmWPec=;
	b=jdtPdrgU2CkdV4zhhnqYtTKfmlpvvEGbCJqxpwuyVcHAysPbrKt1wkVthV/Vh9PxDXn8l2
	R96dsATwubwB1tAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 876C2779A7;
	Mon, 15 Jun 2026 20:35:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pCcOIRNiMGpbUwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 20:35:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1023FA12D2; Mon, 15 Jun 2026 22:35:31 +0200 (CEST)
Date: Mon, 15 Jun 2026 22:35:31 +0200
From: Jan Kara <jack@suse.cz>
To: Xiang Mei <xmei5@asu.edu>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH ext4 v4] ext4: fix out-of-bounds read in
 ext4_read_inline_dir()
Message-ID: <oziktcalsnvdwpeynvknztclepea7o5zx52jf7c4exlyq6t443@4zln4owfv7pu>
References: <20260615190519.946736-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615190519.946736-1-xmei5@asu.edu>
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[asu.edu:email,suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 90A4A6C646
X-Spam-Score: -2.51

On Mon 15-06-26 12:05:19, Xiang Mei wrote:
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
> extra_offset", yet the ext4_check_dir_entry() length argument uses the
> larger extra_size. A position whose dirent header would extend past
> extra_size is therefore accepted, and the rescan loop's rec_len probe and
> ext4_check_dir_entry() dereference de->rec_len before the entry is rejected.
> 
> Reject a position whose minimum-size dirent header would not fit within
> extra_size before forming de, in both the rescan and main loops, and pass
> inline_size rather than extra_size to ext4_check_dir_entry() so the length
> check matches the physical buffer.
> 
> Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v4: use Jan's suggested logical-space bound (i/ctx->pos + rec_len >
>     extra_size), consistent with the loop condition.
> v3: dropped the unreachable ctx->pos < extra_offset underflow check.
> v2: validate against inline_size instead of extra_size.
> 
>  fs/ext4/inline.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index 8045e4ff270c..f1f7104d3dac 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -1454,6 +1454,8 @@ int ext4_read_inline_dir(struct file *file,
>  			/* for other entry, the real offset in
>  			 * the buf has to be tuned accordingly.
>  			 */
> +			if (i + ext4_dir_rec_len(1, NULL) > extra_size)
> +				break;
>  			de = (struct ext4_dir_entry_2 *)
>  				(dir_buf + i - extra_offset);
>  			/* It's too expensive to do a full
> @@ -1488,10 +1490,17 @@ int ext4_read_inline_dir(struct file *file,
>  			continue;
>  		}
>  
> +		/*
> +		 * de lives at dir_buf + ctx->pos - extra_offset, within the
> +		 * kmalloc(inline_size) buffer.  Make sure its header fits before
> +		 * ext4_check_dir_entry() dereferences de->rec_len.
> +		 */
> +		if (ctx->pos + ext4_dir_rec_len(1, NULL) > extra_size)
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
