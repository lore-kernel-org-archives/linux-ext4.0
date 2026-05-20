Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869B93AFD1B
	for <linux-ext4@vger.kernel.org>; Wed, 20 May 2026 08:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779266585; cv=none; b=LeL0ojwJ43H0RVuQr0XkOz8CM9SYMB7P2IGoRc0vrWucrUnKSi9VbV/vTMiDrcbym7EDpOwTEYgE5w1TSYm9A0IVCnhsiPGUtsVfGOw5zsbBQMQe8ZTzZ9h+kBFy1hSlBWRtAWexnACoF8ESQMrYWcwT6WbH7RaFQOicYY3YvMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779266585; c=relaxed/simple;
	bh=6dCKShsds5lMEBMgLpR3Q4dOo2KeoHmcsy9nQBxkWkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LL43oao/M2rFes+zm2OlSIirKSsXZf0IG6bG4Nkbkdbb7mV23Jwg3/OCFDqxBQUZOdoT7PdqmTsvob79K2n02aLy8OcUsAVyw3S4yc41wZd7GDiZsPrp1sdRYRQdR2PCmg8gYa0ZebD5lQj59Y4mQ9IpZj3QP3vnbXPYIJ3xly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oRS0QHA/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HB8zQ96y; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oRS0QHA/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HB8zQ96y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oRS0QHA/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HB8zQ96y";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oRS0QHA/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HB8zQ96y"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A56B36A92D;
	Wed, 20 May 2026 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779266581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WS9XEtiOZKoN5dL35BxoqHhAT+cmlCOvG5bs6Eju31o=;
	b=oRS0QHA/Qd4YWeLAEC04f7vhYC5GBx9tmRL74yzO7CbyTYue7bV7yPa3oIeocchRlG8UeI
	YtmSvL961ig50Z3drWJDtmETYms29Sg4EWkrhLb0VDvpR2UiCEi8oFSXbzVogiI1d32ovp
	UKu7YXBV7BrNGkSXKBPdLHrv2oaoGjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779266581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WS9XEtiOZKoN5dL35BxoqHhAT+cmlCOvG5bs6Eju31o=;
	b=HB8zQ96yjT0HzdXrWGUBiGXQdwOn+vLmDnfCTf4esG7BfLKr7T3zj6UK30JCR7nj/jofP+
	VRGomAhnMRRTcNAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779266581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WS9XEtiOZKoN5dL35BxoqHhAT+cmlCOvG5bs6Eju31o=;
	b=oRS0QHA/Qd4YWeLAEC04f7vhYC5GBx9tmRL74yzO7CbyTYue7bV7yPa3oIeocchRlG8UeI
	YtmSvL961ig50Z3drWJDtmETYms29Sg4EWkrhLb0VDvpR2UiCEi8oFSXbzVogiI1d32ovp
	UKu7YXBV7BrNGkSXKBPdLHrv2oaoGjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779266581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WS9XEtiOZKoN5dL35BxoqHhAT+cmlCOvG5bs6Eju31o=;
	b=HB8zQ96yjT0HzdXrWGUBiGXQdwOn+vLmDnfCTf4esG7BfLKr7T3zj6UK30JCR7nj/jofP+
	VRGomAhnMRRTcNAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C357593AA;
	Wed, 20 May 2026 08:43:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RkEdJhV0DWoDKgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 20 May 2026 08:43:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B6EDAA08D7; Wed, 20 May 2026 10:42:52 +0200 (CEST)
Date: Wed, 20 May 2026 10:42:52 +0200
From: Jan Kara <jack@suse.cz>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, neil@brown.name, brauner@kernel.org, jlayton@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, zhongling0719@126.com
Subject: Re: [PATCH] ext4: Fix ERR_PTR(0) in ext4_mkdir()
Message-ID: <2kwhm6ortr6nxfj47u6dhrrgsiocmmg4tfah6mhqsavwq5dllf@zjshla4i2jlw>
References: <20260520074634.53656-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520074634.53656-1-zenghongling@kylinos.cn>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[126.com,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,brown.name,kernel.org,vger.kernel.org,126.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 

On Wed 20-05-26 15:46:34, Hongling Zeng wrote:
> When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
> It should return NULL instead for success and ERR_PTR() only with
> negative error codes for failure.
> 
> Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

You're right this is a bit sloppy programming although there's no actual
functional difference at this point. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 4a47fbd8dd30..8cadaeb15b2b 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -3054,7 +3054,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
>  out_retry:
>  	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
>  		goto retry;
> -	return ERR_PTR(err);
> +	return err ? ERR_PTR(err) : NULL;
>  }
>  
>  /*
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
