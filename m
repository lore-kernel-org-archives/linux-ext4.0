Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F7347DF95
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782986013; cv=none; b=Ddrvi716zeamABzodN9E6rFSNaBo4L8X0/zz7xJQ1nzYAu04CgvvxMCEuLWaOm16lr9WY3JRCx4G0qznkwbH478/jkcqDsucQGMGP7k9AK647XgCQsphPLG8YdzVuNr5pNwrw8+Tl63FEbwK88cwUP2W1qXfz6XRY9O3GTeDl4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782986013; c=relaxed/simple;
	bh=PC4S+h5RQewtbXNMwfSPuXe+sfJH6u2FPz/RpBDUh4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jl5FHOodbj890KGMk3i6FonCJpNJB6VWz8tYpUvnJLdNeuf/xODupDxNm8CZ959NyjyljH4UZVwVXGm1JCcTLQwWycMKOIQH2cr+FNHo6NDXQ1fu9XAfk45yUOdPNAohl3FzFqgYbVf5TyssGo3g0FMKM7U2QmPqAO+Kt3q2BA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LNvPbOTM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Nvnp+0sU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ERusVuvZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=pZ1Wm5e9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LNvPbOTM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Nvnp+0sU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ERusVuvZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="pZ1Wm5e9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A209D7599B;
	Thu,  2 Jul 2026 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782985993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg3zgvqEgt54r7q2aDYOHf1F1DHKUTC4/jlTYFfih7w=;
	b=LNvPbOTMKUppVcaf+CVlYL1txNf7/Lks00tWVowO0sozugp5/YUzKibigHOp1pVK7IvErw
	1/2vmQ14JB13G3wGv3qtYq8Kntta4aKgMOA6Vt2e5DQlBV1saty9OPRQpTBRmikgUm7nMR
	HoC/Ecv+/Emtg8YL0JzFq3j/6IfjwRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782985993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg3zgvqEgt54r7q2aDYOHf1F1DHKUTC4/jlTYFfih7w=;
	b=Nvnp+0sUJwYMNXwHOynOaB2Zj/hn/Cc+sQVj7nES53MTHjjM2wZNl+jSEQdArpb2e7ofHP
	wuie1bF3l5D/5UDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ERusVuvZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pZ1Wm5e9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782985991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg3zgvqEgt54r7q2aDYOHf1F1DHKUTC4/jlTYFfih7w=;
	b=ERusVuvZd2ll6bXWx4eFIuqV7nGo890PI18ffHeTPiT547pZtBssfBHWf2nRZDenS2wy1f
	qlnbUp6SQiGuXIRsTUloRY4b4UW/5P65uE8cnAS2wMiK86tQr6YIY/7Jt2EBbe/BQwa4LW
	LIkLXk/QNGQVSxdcui1S6yJveJKlrFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782985991;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yg3zgvqEgt54r7q2aDYOHf1F1DHKUTC4/jlTYFfih7w=;
	b=pZ1Wm5e9DlKRP224CBCQiB3Tz+vAQ6ovjT0bNqBeoxLC7jDL4xdWUUEcbfnEMKEYm3zedP
	Fi9BK8ApV3pOQoDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95734779AA;
	Thu,  2 Jul 2026 09:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vux2JAc1RmpeFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 09:53:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 35783A12AD; Thu, 02 Jul 2026 11:53:03 +0200 (CEST)
Date: Thu, 2 Jul 2026 11:53:03 +0200
From: Jan Kara <jack@suse.cz>
To: yizhang089@gmail.com
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com
Subject: Re: [PATCH 2/6] ext4: clarify return semantics of ext4_load_tail_bh()
Message-ID: <qpxvjsdnq6jgigjnwzkxny6lms6gi6t4bq5l33rr2f6m6l4oum@5e6ayymrgcbd>
References: <20260701142009.1510104-1-yizhang089@gmail.com>
 <20260701142009.1510104-3-yizhang089@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701142009.1510104-3-yizhang089@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A209D7599B
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,huawei.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed 01-07-26 22:20:05, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
> buffers, but the conditions that lead to this are not obvious from the
> code alone. Document this behavior to clarify the return value, so that
> readers do not mistakenly assume that only holes result in a NULL
> return.
> 
> Also update the inline comment following the ext4_get_block() call to
> reflect this: both holes and clean unwritten buffers fall through to the
> "nothing to do" path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/ext4/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..0b31fa873743 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>   * because it might have data in pagecache (eg, if called from ext4_zero_range,
>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>   * racing writeback can come later and flush the stale pagecache to disk.
> + *
> + * Return the loaded bh if it actually needs zeroing - in written, dirty
> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
> + * a clean unwritten block).
>   */

Great that you're adding this comment because when I was reading previous
patch, I've spent like 10 minutes trying to figure that out :). But as far
as I'm reading the code, ext4_load_tail_bh() will return the unwritten bh
even if it is clean - map_bh() in _ext4_get_block() will set
buffer_mapped() even for unwritten extent. What am I missing? BTW, it also
seems to be ext4_load_tail_bh() could attempt to ext4_read_bh_lock() on
unwritten bh if things align wrongly...

								Honza

>  static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  {
> @@ -4065,7 +4069,7 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  	if (!buffer_mapped(bh)) {
>  		BUFFER_TRACE(bh, "unmapped");
>  		ext4_get_block(inode, iblock, bh, 0);
> -		/* unmapped? It's a hole - nothing to do */
> +		/* It's a hole or a clean unwritten block - nothing to do */
>  		if (!buffer_mapped(bh)) {
>  			BUFFER_TRACE(bh, "still unmapped");
>  			goto unlock;
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
