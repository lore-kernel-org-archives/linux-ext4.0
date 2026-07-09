Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540D62D3A7C
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783604336; cv=none; b=HV0yi175QEv9Zg1O2hSgN521mr7/Le6/HN0iQAk2i9Dnocoyw9hyUA1SgQ1EgWETyJPIZ7H/6u0IjLy8+28i/qpJCUBwo4wzoKzXGn4LuZQGaoiifCXnNHIbc68Joe6+n8Vs0In3P2J9X3wXjCjU7rNjGh5rnqsBminD30GlK70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783604336; c=relaxed/simple;
	bh=FuxrTtUOtUI0RDLsJPNpId57kssMmvm2jW6YObvg1So=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8cFvkDAbPJso4Kvh0Z6V0u0a+uWBWXSwzvtADT8Er7sIuYfxg9D2ev7QUyXuQE3GVeiDFeWE7i9RgkGwjxqVD5rruEsmrAi2j+xRYLV12Nod8VzoDKENLgR270AXqkQ2M+6WOMYSnMBpOFZMAijs2t3v41fpF8sNK6onqxxhwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KLmkmffk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Dj/H9Hm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=KLmkmffk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1Dj/H9Hm; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KLmkmffk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Dj/H9Hm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="KLmkmffk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1Dj/H9Hm"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC3A575F3A;
	Thu,  9 Jul 2026 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783604333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ui0gQ3mlPXjw5fNyY1/qKg71ebatuMWHLYyZD1cw82w=;
	b=KLmkmffkUkl5Ha+f7K7TV1vMua8kh/5k/5lVe4yv6hf5ns8AKk1S3xK6sK/v9IL7zO2S4j
	KM+DUHJkHOlT7a+kC7y6wxsMTgRL/TIvBGS4DbnmGpEaECfZuS7WEpOAwnteUrIQIAb1uU
	jgYbjnq2drwv4EQ/E4N5llKgxxtkkjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783604333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ui0gQ3mlPXjw5fNyY1/qKg71ebatuMWHLYyZD1cw82w=;
	b=1Dj/H9HmMyxLEHy9Ya/Dn/VAoRJSUGqwEQnaVEg+go3/ily5xmBWV5J1tCAGBXg+cViYSj
	Fl2hbIivWtXIz6Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783604333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ui0gQ3mlPXjw5fNyY1/qKg71ebatuMWHLYyZD1cw82w=;
	b=KLmkmffkUkl5Ha+f7K7TV1vMua8kh/5k/5lVe4yv6hf5ns8AKk1S3xK6sK/v9IL7zO2S4j
	KM+DUHJkHOlT7a+kC7y6wxsMTgRL/TIvBGS4DbnmGpEaECfZuS7WEpOAwnteUrIQIAb1uU
	jgYbjnq2drwv4EQ/E4N5llKgxxtkkjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783604333;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ui0gQ3mlPXjw5fNyY1/qKg71ebatuMWHLYyZD1cw82w=;
	b=1Dj/H9HmMyxLEHy9Ya/Dn/VAoRJSUGqwEQnaVEg+go3/ily5xmBWV5J1tCAGBXg+cViYSj
	Fl2hbIivWtXIz6Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3CD1779AA;
	Thu,  9 Jul 2026 13:38:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b6PlK22kT2oCOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:38:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79A55A12D7; Thu, 09 Jul 2026 15:38:49 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:38:49 +0200
From: Jan Kara <jack@suse.cz>
To: Guanghui Yang <3497809730@qq.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: clear error before retrying inode xattr space
 fallback
Message-ID: <l4lnibhsedvsb45zo3aqrmggnrcpt5axvtkqs3vbbybw3qcth7@4saumozc7nrx>
References: <tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_192F8A699EFD21126E02101131C9546F3C08@qq.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[qq.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	URIBL_BLOCKED(0.00)[qq.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,qq.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 08-07-26 12:57:19, Guanghui Yang wrote:
> When ext4_xattr_make_inode_space() returns -ENOSPC,
> ext4_expand_extra_isize_ea() can retry the expansion with
> s_min_extra_isize.  If that retry succeeds by finding enough ibody free
> space, control jumps directly to the shift label.
> 
> The previous -ENOSPC is still stored in error in that path, so the
> function can update i_extra_isize but still return -ENOSPC to the
> caller.  Clear error before retrying so a successful fallback expansion
> returns success.
> 
> Reproduced with an ext4 image using 1 KiB blocks, project quota support,
> 256-byte inodes, and min_extra_isize/want_extra_isize set to 32.
> FS_IOC_FSSETXATTR failures dropped from 802 to 86 after the fix.
> 
> Fixes: 69f3a3039b0d ("ext4: introduce ITAIL helper")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Indeed. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/xattr.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 982a1f831e22..9da5dfcea7b8 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2839,6 +2839,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
>  		    s_min_extra_isize) {
>  			tried_min_extra_isize++;
>  			new_extra_isize = s_min_extra_isize;
> +			error = 0;
>  			goto retry;
>  		}
>  		goto cleanup;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
