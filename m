Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9D929994B
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783610437; cv=none; b=TzJ/nBDeZbiD3j0kXVmTjL5VL/EztTlOJ569Yi/3xX4zBb0T5PNm4+J6NqC9t7BFvFslHgIfFC7qpvMpUpcz6MsOIvWYd1+9msXwSFL4YBB+rkrDmzGrkrko7rc2SKEMmpEkKdkzbboFftCvevJTETkmC0YsfHl38Nyf7cml+w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783610437; c=relaxed/simple;
	bh=2j2v8W+GihC2pIhYN0hdL4Dx5qGWJ/EgrfQNwygOWFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ib6+r4Eqo1Arvd22XJiLcdWoxSMNM/xW/ZD3o4/++kfYkwF+SK/l/x7ViDa/22aWPGwmJi0tdByjWs5PVTi3bLOGnAB1isNzZZlE2w06R4gGmOHtr/vDIrecfFMmLez1v3Fqeg1XUU+40k410a88l0ZPGOlMMMHQ1VZ9g+CNafI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=z3XvSlkr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UmJXd7NS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aaIfaSTA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xjyQenXn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="z3XvSlkr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UmJXd7NS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aaIfaSTA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xjyQenXn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DBA7974E71;
	Thu,  9 Jul 2026 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783610433; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aXGHQvKSKBX8OgxTyNjYlEOGUfg+18agvnEBr36kNn8=;
	b=z3XvSlkrzcfKQicokEVHCBmv2gn1sR36rHJOl7pCfHtKF9keW2CJzLqFQbQU4DMboQeoVS
	2A+nuT1YWeCMGS83CO7xAWtA2Icvsjx5Bjw/JDeqhuOek3C5qCb5VuwHmq4guWhtdqlPEe
	cL7Ij/1u38VPwKMhCF8t1GnMLqyuop8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783610433;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aXGHQvKSKBX8OgxTyNjYlEOGUfg+18agvnEBr36kNn8=;
	b=UmJXd7NSCfye4V4UDKkkUF2nnt7VCqqs0UmTzgg2vFTWXtBoKZ85rauFJCbPf1Zb04fNBN
	vo6sc7TlvPWNrOAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783610432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aXGHQvKSKBX8OgxTyNjYlEOGUfg+18agvnEBr36kNn8=;
	b=aaIfaSTACnDnTs3soSdMnfHmlEgayRUKkMFZWbZVBY3aKSBvsJaFWNauWTwt5sgE1zaceP
	T8IrYo2cRhtzLY676f54Xe6+6uOQqGItL6f8OeG8BkS9eqh/1uyB1ozccHI5FofgnvkDHM
	4qAeCRvfcYUYTWOVT733m1kiIlNRlNc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783610432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aXGHQvKSKBX8OgxTyNjYlEOGUfg+18agvnEBr36kNn8=;
	b=xjyQenXnFkSdTWvcDRJsT6LvIj+QbekPtUKYMBgg4SGSpiOHvqIlHm98YVMBCF2HPGEn0y
	ipwgwQORL1AMkrBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D1318779AA;
	Thu,  9 Jul 2026 15:20:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /Z4NM0C8T2pTHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 15:20:32 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 57B19A12D7; Thu, 09 Jul 2026 17:20:32 +0200 (CEST)
Date: Thu, 9 Jul 2026 17:20:32 +0200
From: Jan Kara <jack@suse.cz>
To: Guanghui Yang <3497809730@qq.com>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: fix buffer_head leak in ext4_init_orphan_info
Message-ID: <26gdpfsbevw63f43pkglmiqjnxtkz6hccyzs7pexlv6gjfwwy6@eb3urycwpfhh>
References: <wxzgqewgav3zhaoxbv6eyztoebyvrusaiajyu6rq4yoyitzowd@jzruszx6eetq>
 <tencent_B38798612A159E21450ECF959016371B0807@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_B38798612A159E21450ECF959016371B0807@qq.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[qq.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Thu 09-07-26 14:41:51, Guanghui Yang wrote:
> ext4_init_orphan_info() reads orphan file blocks with ext4_bread()
> and stores the returned buffer_head in oi->of_binfo[i].ob_bh.
> 
> If ext4_bread() succeeds but the orphan block magic or checksum
> validation fails, the function jumps to out_free. However, the old
> out_free loop starts releasing buffers from i - 1, so the current
> buffer_head at index i is skipped.
> 
> This leaks the buffer_head reference obtained by ext4_bread() on the
> bad magic and bad checksum error paths.
> 
> Fix this by tracking the number of successfully read buffer_heads and
> releasing exactly those buffer_heads on the error path.
> 
> Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
> Signed-off-by: Guanghui Yang <3497809730@qq.com>

Right, your previous code was actually correct as well with the
post-decrement. I just got confused, sorry for that.  I think the most
idiomatic way to write the cleanup loop is like:

> -	for (i--; i >= 0; i--)
> -		brelse(oi->of_binfo[i].ob_bh);
> +	while (loaded > 0) {
> +		loaded--;
> +		brelse(oi->of_binfo[loaded].ob_bh);
> +	}

	while (--loaded >= 0)
		brelse(oi->of_binfo[loaded].ob_bh);

But regardless feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

>  	kvfree(oi->of_binfo);
>  out_put:
>  	iput(inode);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
