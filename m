Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D82262FFC
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602655; cv=none; b=AgTsbitqXQWYpolwavvDB1E+lYzYkKK/6j+pZXBD+fe9HdoXN9DbqYM+I+/kLUgIsiziWSiU8ZkCq5c54GIVYVZ7u2VBOX7eqXb+R7kkOL7insTllrCMTUt0c7eWbWlPThTUeOsCdGz5AIpcnIEH0OGyulN5Ggfd/7mJgS94ysc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602655; c=relaxed/simple;
	bh=qOr2Z6YlzCpxy1ek3tikIYJ75+QBNPoYOf1QsKPQLrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XzZsKLIeOHmCB9pW2Sd2g9I6lowWGbgq0H1OdVBwpqg5b6imObQdoryEfZfzfQepkXoz3B8Nme+TKiiB02n1UzTy+swTbYQ3KYR1HLg1Pou5FYSdqouY+J8zzsKUbmUkNKzutr9AZI+9F4GPD25hrdJa2RnnYchpT5ai64pzIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=h33kCt18; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SdNlI2Ix; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UFVVS4AG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cZHDlYIk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="h33kCt18";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SdNlI2Ix";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UFVVS4AG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cZHDlYIk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF98F761FA;
	Thu,  9 Jul 2026 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783602652; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lc+FedwxeabnU+e89IhTBioY+rh5m0Zk/BMVghmxFC0=;
	b=h33kCt18zL8v2WnhFynsSNjL2eJjRuQB5mxXD392KdMNvCd4pziKDX8hy781/yfj8yyet0
	SftoS6XhocvH4fVCR7T9U9ZbtjKxN8LXRdpfMC7eYeC1T9EgliAEbcvHQPrbTBEsfTTz9L
	um3dY8H0thZgYOAtHddfU+qriBkTzfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783602652;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lc+FedwxeabnU+e89IhTBioY+rh5m0Zk/BMVghmxFC0=;
	b=SdNlI2Ix/79ofinMoGKOiE1HPU5QSk7k/coylgSMPUXH+fXjVpW9CQL8uW9DPBuODPP2pQ
	TfuW/oXJB5Kf6pAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783602651; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lc+FedwxeabnU+e89IhTBioY+rh5m0Zk/BMVghmxFC0=;
	b=UFVVS4AGKMfSjijY86S+6h1mCceHWQLg8xY2jg6wZb898aBPkO6GaO/yNmPjppVN6QgkC6
	kdZxB4riSqMkKO5FWm9f7gJTjHnrSZYHAVjauouisNJO0pKjn6LSdIXIQPqMQRHo9ngd4a
	ctIcTYTiZGP5ldjPm0nFGCOFaH2LV8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783602651;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lc+FedwxeabnU+e89IhTBioY+rh5m0Zk/BMVghmxFC0=;
	b=cZHDlYIkW+/BwL8wLZdMR1OBffNvbJ2OTZOyq0w5Zwog1l6eJZ/RspBni1BY8i/6lommnX
	fvkBIZkh4oS4OZCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7662779AA;
	Thu,  9 Jul 2026 13:10:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tZaUNNudT2rnHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:10:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 81AA2A12D7; Thu, 09 Jul 2026 15:10:51 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:10:51 +0200
From: Jan Kara <jack@suse.cz>
To: Guanghui Yang <3497809730@qq.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix buffer_head leak in ext4_init_orphan_info
Message-ID: <wxzgqewgav3zhaoxbv6eyztoebyvrusaiajyu6rq4yoyitzowd@jzruszx6eetq>
References: <tencent_B6A92A781E14093CF74314DD20201262EC09@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B6A92A781E14093CF74314DD20201262EC09@qq.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[qq.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,qq.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Wed 08-07-26 05:24:08, Guanghui Yang wrote:
> ext4_init_orphan_info() reads orphan file blocks with ext4_bread()
> and stores the returned buffer_head in oi->of_binfo[i].ob_bh.
> 
> If ext4_bread() succeeds but the orphan block magic or checksum
> validation fails, the function jumps to out_free. However, out_free
> starts releasing buffers from i - 1, so the current buffer_head at
> index i is skipped.
> 
> This leaks the buffer_head reference obtained by ext4_bread() on the
> bad magic and bad checksum error paths.
> 
> Fix this by tracking the number of successfully read buffer_heads and
> releasing exactly those buffer_heads on the error path.
> 
> Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

I like the approach but it has an off-by-one error as well ;)

> @@ -635,8 +637,8 @@ int ext4_init_orphan_info(struct super_block *sb)
>  	iput(inode);
>  	return 0;
>  out_free:
> -	for (i--; i >= 0; i--)
> -		brelse(oi->of_binfo[i].ob_bh);
> +	while (loaded-- > 0)
			^^^ this should be >= 0.

								Honza

> +		brelse(oi->of_binfo[loaded].ob_bh);
>  	kvfree(oi->of_binfo);
>  out_put:
>  	iput(inode);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
