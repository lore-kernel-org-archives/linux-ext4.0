Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98FF49B5AC;
	Thu, 24 Sep 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790265738; cv=none; b=Vtfq712MxW8lbD0Kls5Dz9lGjfNvQ68eIOoxVWl/bAXOsT/zXtHbDUDc1/hnzOcZQ7TlhNwCIgll2ztpbMM7wEaQrjfiib6M1Tk9XDuwtctq32FK1sObGyMQMZILxP3h4A67etguBSoYiA2kF49OrKFK8RCRjrteCqP1wk5Uod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790265738; c=relaxed/simple;
	bh=DjhVqZRmolxMXe/O22jxIA9HdpE+eBYc7HNLxe+mVc4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tj3KG25JgrN4BT6X9UTm01Ns6Ex1W1X+ilYBL3+kxQBXBhOCwuv6l2jElPyM/rPNT55smFwizZQKayTwevIIGmqEpdT6Wo0WrHNNxdLfOEkHfK0IQY6/ogWJtqu2jsxaKFtRuRLej4pSjxDDFEXl4RTRAafPvML1VGhNNDZthtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=wv9na7Q7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1LgIQVDX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yGr0JHiS; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HUnJdpbW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="wv9na7Q7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1LgIQVDX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yGr0JHiS";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HUnJdpbW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B4E221F69;
	Thu, 24 Sep 2026 16:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790265730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAD/UqgWuc95ckx5iqnRiw5fwcnpSOcEx54wjmZBMfw=;
	b=wv9na7Q7nF7t7eGSXJcb22pn2WlqzW9P5b3tW3hwZFyqfRNxcjFS6ZqnNTYsfG5znFb3Wb
	goEknq7trWmyWh1gSk9FBDL0hzZa+c6uEBSRRJbc5AE5f+ale9QKH9ujwrgYkZ0EnCmnFa
	xLan6adwamVm5Q5kykPqaRDlvZQHpHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790265730;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAD/UqgWuc95ckx5iqnRiw5fwcnpSOcEx54wjmZBMfw=;
	b=1LgIQVDXw0fihBd/3YTetIQiy1lcIW7xt3bnKYVBAhptzymSQwZrxWcbk1Ds5UYzC/wCf1
	9D8UMFyHCeP+gxCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790265726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAD/UqgWuc95ckx5iqnRiw5fwcnpSOcEx54wjmZBMfw=;
	b=yGr0JHiSLpDBGMT1xZMrDvH2qpNGRwWYYZW9e03YR77dAoAG3Q/L5jR4vp6jw2ecfkWxCf
	vNAIcGyd70tNjvNVFxUglptatzE2ZfgRTY+AgEAsL+whpHiR2KID3AlVypoaONBw2OPkWA
	V84CYmmjspKMn3Tm06IfA92f8pPMq6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790265726;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yAD/UqgWuc95ckx5iqnRiw5fwcnpSOcEx54wjmZBMfw=;
	b=HUnJdpbWfauouKWiB5Ku746J8WFOuu9bOOiKjrGzWlWgGHy+8duZwOcqExZGytZChjaxyo
	gvR8lFLQFMhxTvBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C6CA13354;
	Thu, 24 Sep 2026 16:02:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v5tLCn5JtWp8WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:02:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CF47DA132E; Thu, 24 Sep 2026 18:02:01 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:02:01 +0200
From: Jan Kara <jack@suse.cz>
To: Hui Peng <benquike@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: clear EXT4_STATE_MAY_INLINE_DATA in
 swap_inode_boot_loader()
Message-ID: <sh4tr5poq6pf75ysixusuqzpw4aj7gy4yrh47owo6fj7sqlmb6@i27zbgsxlxcs>
References: <20260919204812.2814531-1-benquike@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919204812.2814531-1-benquike@gmail.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Sat 19-09-26 20:48:12, Hui Peng wrote:
> swap_inode_boot_loader() (EXT4_IOC_SWAP_BOOT) checks
> !ext4_has_inline_data(inode), but neither checks
> ext4_has_inline_data(inode_bl) nor clears EXT4_STATE_MAY_INLINE_DATA on
> inode and inode_bl after swapping their inode data.
> 
> When a newly created empty file (which has EXT4_STATE_MAY_INLINE_DATA
> set in memory) is swapped with a non-empty EXT4_BOOT_LOADER_INO that
> already has extent blocks, the target inode retains
> EXT4_STATE_MAY_INLINE_DATA == 1 alongside extent blocks. A subsequent
> ftruncate() + small pwrite() + fsync() dirties folio 0 while converting
> the inode to inline data, hitting
> BUG_ON(ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in
> ext4_writepages().
> 
> Reject inline data on inode_bl and clear EXT4_STATE_MAY_INLINE_DATA on
> both inodes in swap_inode_boot_loader().
> 
> Fixes: 67a11611e1a5 ("ext4: fix check of inode in swap_inode_boot_loader")
> Assisted-by: LLM
> Signed-off-by: Hui Peng <benquike@gmail.com>
> ---
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -397,7 +397,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
>  	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
>  	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
> -	    ext4_has_inline_data(inode)) {
> +	    ext4_has_inline_data(inode) || ext4_has_inline_data(inode_bl)) {
>  		err = -EINVAL;
>  		goto journal_err_out;
>  	}

I guess instead we should add a check to check_igot_inode() that inode
doesn't have inline data if EXT4_IGET_SPECIAL flag is set.

> @@ -461,6 +461,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  	size_bl = (qsize_t)(inode_bl->i_blocks) * (1 << 9) + inode_bl->i_bytes;
>  	diff = size - size_bl;
>  	swap_inode_data(inode, inode_bl);
> +	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
> +	ext4_clear_inode_state(inode_bl, EXT4_STATE_MAY_INLINE_DATA);

Please don't touch inode_bl. That one should never have
EXT4_STATE_MAY_INLINE_DATA set (and nobody can manipulate it directly
anyway). For 'inode' I agree it will get blocks from inode_bl so better
just clear EXT4_STATE_MAY_INLINE_DATA.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
