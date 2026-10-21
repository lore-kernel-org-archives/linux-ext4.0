Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792593282;
	b=WW643u9DTiPu+t24UB+pIAiG50FbsEb7sRltyiF/olJ8kp1CqTObkL4lz8OcVC2O+RGU
	 y9QeMh0Ov8uCCK8NmG16MfxzdHkFo1mTwVn6qmaEDfG0PNSocszD6z/KRdT11tlSOe6aE
	 j0dafOYd3/+inIA2StZWaynIbV6UWiWoJ9zR4K/s0uXGD3TWr9OHQxT7axMU1wzdbe5B9
	 7MEvlFhfcGmfu14mOLBkf43eTb1JnnyKwAHcM1Tz2cx8T8DdLxXLB/+oo+HCDWiLlmfCT
	 lEa9rzIGQsA/BmH/Fvchn+PTA6UgyePkgo61WgMxDJXbXU0FlVbcBiBPZJzr8ZjO0GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792593282;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=iep7syUHx63mxMwZv9E3itRqjkHRksmcjumISh2RYTY=;
	b=KBKnheZ9Jp1U7okitB0uQXV+5D4s/5EGlwc0s0XTUvLNWCMngHRosN2qJQ6083U4DWvr
	 EnTK4afg2U5feB5Z+wxgfhonDbf8v3dQWS30qo6jXMjTtkl0FPUa1HrpuoUot7l5RplBq
	 Bl7ugf86XEzazXxKOpO2j6KVXvORa9jagfUNEjaCyk4CS0HVsg3AhvNlWrGCEFBEPOq04
	 ymBuhGdz4zH19USY/H2r6vGWg4ULSDDPAo8FuwbrF4MJxHzNys2iX3KaaZdWmRN08etHP
	 zbwXI6sS+eLQSkny8r4stCtpneA1/aQmOhzMl7iqVFs0vTJltQmhk6P6ixb7BOw9Ikg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2ewuX6++;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ifGXKZvT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2ewuX6++;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ifGXKZvT;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA9A606A31B;
	Wed, 21 Oct 2026 14:34:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4AA9A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2ewuX6++;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ifGXKZvT;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=2ewuX6++;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ifGXKZvT
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 619C31FA83;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iep7syUHx63mxMwZv9E3itRqjkHRksmcjumISh2RYTY=;
	b=2ewuX6++DKsqsBN6N4wfbcgu6xM7hIAZ0JiNst6yccms38UgEmQ2Bkxp5t7prz7yJJ5/NQ
	Oq3wCXBZccFrGzcLI1OQlzX/vpi4+58qgzArkRuIVU0nkGfTJMN3LVK0y9Ax8+BIYD6goN
	On7KFXJtz6ejs0mCsWsTfi445vL/e8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iep7syUHx63mxMwZv9E3itRqjkHRksmcjumISh2RYTY=;
	b=ifGXKZvTwWRjGiecYnijyyqvDVx0QtnWC/kAIM4AXMQhNC8+HttJfR4hZmqkpI1OgRlke0
	0pFjWvqrQxlbRUBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792593279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iep7syUHx63mxMwZv9E3itRqjkHRksmcjumISh2RYTY=;
	b=2ewuX6++DKsqsBN6N4wfbcgu6xM7hIAZ0JiNst6yccms38UgEmQ2Bkxp5t7prz7yJJ5/NQ
	Oq3wCXBZccFrGzcLI1OQlzX/vpi4+58qgzArkRuIVU0nkGfTJMN3LVK0y9Ax8+BIYD6goN
	On7KFXJtz6ejs0mCsWsTfi445vL/e8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792593279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iep7syUHx63mxMwZv9E3itRqjkHRksmcjumISh2RYTY=;
	b=ifGXKZvTwWRjGiecYnijyyqvDVx0QtnWC/kAIM4AXMQhNC8+HttJfR4hZmqkpI1OgRlke0
	0pFjWvqrQxlbRUBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C63E13518;
	Wed, 21 Oct 2026 14:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DGZ+AX/N2GoHWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 14:34:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 457EEA1425; Wed, 21 Oct 2026 14:03:38 +0200 (CEST)
Date: Wed, 21 Oct 2026 14:03:38 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: drop tmp inode ownership before migration cleanup
Message-ID: <wjfjy4xo2csqrcmvcetol7nj2kqzm2zn6hdu5zajlaslnvqefr@ralv37qbyx6s>
References: <20260930080241.414973-1-chenyichong@uniontech.com>
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
In-Reply-To: <20260930080241.414973-1-chenyichong@uniontech.com>
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
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[uniontech.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Wed 30-09-26 16:02:41, Yichong Chen wrote:
> After the extent tree is transferred to the original inode,
> ext4_journal_ensure_credits() can fail before tmp_inode is cleared.  The
> subsequent iput(tmp_inode) may then free the transferred tree.
> 
> Clear tmp_inode's size and block count as soon as ownership is transferred.
> 
> Fixes: a413036791d0 ("ext4: Provide function to handle transaction restarts")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
>  fs/ext4/migrate.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index e588b4157604..11b3da396966 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -570,6 +570,12 @@ int ext4_ext_migrate(struct inode *inode)
>  			free_ext_block(handle, tmp_inode);
>  	}
>  
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> +		i_size_write(tmp_inode, 0);
> +		tmp_inode->i_blocks = 0;
> +		EXT4_I(tmp_inode)->i_csum_seed = tmp_csum_seed;
> +	}

I'd just move the setting of i_size, i_blocks and i_csum_seed above the
ext4_journal_ensure_credits() instead of adding this extra branch...

								Honza

> +
>  	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
>  	err = ext4_journal_ensure_credits(handle, 1, 0);
>  	if (err < 0) {
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
