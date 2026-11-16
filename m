Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794832651;
	b=ea3tPrUm56p9zqlL5iHG/CtHMcVK5MSj7J91tGqVH2dAXPnmXlgZETUcpSj94rYY78SC
	 5P2MA1VDMuwqxCq1rFvdN8z1XpLHXvvveYIs+TAVpCjQAQU1bMeAhpI5JwFTW9LBDjAVZ
	 2xgVKMtF4QQfq8ZIwDowgHgHvIjM1kzVxAAme7qWZPgzUp1LyG4/JjciQOm0lKzmQ0IOS
	 J+iavESevhCsswKy2LM8vEWp2fh4UcHLn22b5EnGFUTKnDp8vCnzocEw1bMUaKPH8iouE
	 /ufWF/YUrCs2WR1xcHy/QkqFW+8jBzJq+uJ5cq65rK0QYkCYzKMM2W3POm7i8298YtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794832651;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=8sdoLOBhsgHCl/XuDqgaw5ckZV6lC7JqKjQIjSfIFbY=;
	b=ZV45BOrGsV5e6SvUgD7XL13MHFrw2Mlyoxu4AYFbEu/UpFVRKgGBPl9DRJz7z2xYKeTH
	 7C59ZhYau0+aIlquZGlcBp+ISlF7pcZV5TNTmtlkvXDn5StRqXYQE6F6utseHDxaoUF8v
	 XA0j0EgJmSa/j3W0+UCg1y6LUco43Rzgk5oPG7Lo+QzSqLgfHcleh4nOBsnkf5sU9Ji63
	 DiNR5O7oRz4U6gAbLlMHFL+/PYmVP1S9H+r5UX7rtaVpQckggGw8TGlOoLKcfMDdOLPMp
	 FjGwm2aR4TwJwVXYmPgbOgErfnNNqJhkxKFPI0KBaP/UEDCR8yZB8n0wMWP5/2Bvtdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="xZ/3SU/y";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="FGhvwlq/";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NxnPW3cY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uQkZelfd;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45496606A31C;
	Mon, 16 Nov 2026 12:37:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45496606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xZ/3SU/y;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FGhvwlq/;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=NxnPW3cY;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=uQkZelfd
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C221222F0;
	Mon, 16 Nov 2026 12:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794832649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8sdoLOBhsgHCl/XuDqgaw5ckZV6lC7JqKjQIjSfIFbY=;
	b=xZ/3SU/yIb57H7e00MpJyKf5I5BkUufyHA60Q8yZA43wwp/eaPnDDlWekiy3P0guPLk2vM
	mq6oCfaX83nD3rdTvVNb/qTELVe3HVgzio9OjKsaw0IiefRXr97QVfsFzHHdqaDHdNlz8u
	e4r8mVTWNLkskw7Wt732ZDtr40QGSDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794832649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8sdoLOBhsgHCl/XuDqgaw5ckZV6lC7JqKjQIjSfIFbY=;
	b=FGhvwlq/fWgH1H3X5yarUne45mIZ84zYcFiefHMPa4rAP4pU34OUFMbX42aW+pZ2mHHPH0
	s0QIszhp/589zeCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794832648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8sdoLOBhsgHCl/XuDqgaw5ckZV6lC7JqKjQIjSfIFbY=;
	b=NxnPW3cY3zPIp1sIWfvIkmv98IOJnC1WlTPsoXZgNF29BAFSHouhC0yYNVUWGIQL+OmR0N
	SwMG3PoFHSqO66+kQpLe3SPokAuF7obBWAmhqhegVUifAKciTYwyb1axYrbZB7pyn92w4B
	KYHqG0xcIsoYtGC7GznOtJyUWvcI2B8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794832648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8sdoLOBhsgHCl/XuDqgaw5ckZV6lC7JqKjQIjSfIFbY=;
	b=uQkZelfduej10fPuK9xI2jNZ6vIu0vfJOFqrg8bG6hQ0C4KK2g51SYuoboRltRZQwv+qJ6
	1io8q5HsdiigNYCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D0751334C;
	Mon, 16 Nov 2026 12:37:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DDsGAQj5+mrCcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 12:37:28 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A924C24DF0; Mon, 16 Nov 2026 13:37:27 +0100 (CET)
Date: Mon, 16 Nov 2026 13:37:27 +0100
From: Jan Kara <jack@suse.cz>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: free HTree fname rb-tree at EOF in
 ext4_dx_readdir()
Message-ID: <wsdefflvbpuic6qmqy5xfftq3d6oikzbvypvcs6itdxlykpowb@w4gttnixj4dj>
References: <18e865672dda2d41.3137322e32332e3235332e313736.36f4d7.0000sendgmr@google.com>
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
In-Reply-To: <18e865672dda2d41.3137322e32332e3235332e313736.36f4d7.0000sendgmr@google.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Score: -11.30

On Mon 16-11-26 02:25:44, Chris Wiseman wrote:
> When ext4_dx_readdir() finishes scanning the last HTree leaf block of
> an indexed directory, ext4_htree_fill_tree() sets info->next_hash to
> ~0.  On the final iteration, once rb_next(info->curr_node) returns NULL,
> ext4_dx_readdir() sets ctx->pos to ext4_get_htree_eof(file) and breaks
> out of the loop without calling free_rb_tree_fname(&info->root).
> 
> While ext4_dx_readdir() frees info->root when advancing across leaf
> blocks or resetting on seek, reaching EOF leaves the final leaf block's
> red-black tree of struct fname nodes pinned in file->private_data until
> the directory fd is closed in ext4_release_dir().  Processes and daemons
> that keep directory descriptors open after reading to EOF retain those
> slab allocations for the lifetime of the open fd.
> 
> Free info->root before returning EOF when info->next_hash == ~0.  If the
> caller later seeks back, the existing !info->curr_node check at the top
> of the loop repopulates the tree on demand.
> 
> Benchmark results (/proc/allocinfo, 256 open HTree dirs at EOF):
> 
>   Metric                                  Before        After     Delta
>   ----------------------------------  -----------  ----------  --------
>   ext4_htree_store_dirent live slab   1,007,616 B         0 B   -100.0%
>   ext4_htree_store_dirent live objs        10,496           0   -100.0%
>   /proc/meminfo SUnreclaim delta        +1,246 kB     +133 kB    -89.3%
> 
> Signed-off-by: Chris Wiseman <chriswiseman@google.com>

Looks sensible. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/dir.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 8d7b81e6948e..435300cd2c61 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -640,6 +640,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
>  			info->curr_minor_hash = fname->minor_hash;
>  		} else {
>  			if (info->next_hash == ~0) {
> +				free_rb_tree_fname(&info->root);
>  				ctx->pos = ext4_get_htree_eof(file);
>  				break;
>  			}
> -- 
> 2.56.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
