Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC54524EA90;
	Mon,  5 Oct 2026 11:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791199463; cv=none; b=ZseBfgB5o5jul1q0sEBtcnxTkQNbUCLEbpDSA94bPOumKEijEdJkKwZODmTXGixbwPuI69yWqlK0vYcVHj6ARebmeQAvvbb8AcZZxtfERZcPOlTDrzU3XCxFXZv3+QPPu88PdFpoKBALcMU95BNP5INI/9Ac/zOBvdHJ/Ytv88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791199463; c=relaxed/simple;
	bh=E+/anujU4hzfDaZKEm0jdfCYNgUqhOwTdM94oH0uJzA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRdgJfo46AQrLucLYNNnEEmKETr4+j+ddTv2PF9ZHZBLUIcmp1vSkfNh7FrsIZDOWpu6tCora/3askr85W7FwaLsjore3K9iWVGBNXyE/K3vXcWaIxRxPb4QuRQQjAv/uMM+wcESDcREo4//rB6/8POazCH5EE7OE/PHIMgwUQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jr6TwbUk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wUgEKgYB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tky9ZzWw; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=22mM/DgM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jr6TwbUk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wUgEKgYB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tky9ZzWw";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="22mM/DgM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5FA9C1F399;
	Mon,  5 Oct 2026 11:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791199455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vm/ySz3HOdR/ndmcqA8Sm3SIQvkPcyS1mZWChqoU3Q4=;
	b=jr6TwbUkasUVtvqzw/he5+JUGfc5u3Hy9DBlQkViyWT4l96+iLjzULpFpGv3Hv6jbhEapy
	gegKBh/V+Ni6z87EczlUdrZWp8jdUgPAE6/T75HEGggsIJGtR4B0jS9j7dkRR6NCo/jK+H
	nDEsu1cvS8v9XGxqF3ZuPSwx0PSQUx4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791199455;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vm/ySz3HOdR/ndmcqA8Sm3SIQvkPcyS1mZWChqoU3Q4=;
	b=wUgEKgYBxLZh57EPa0GNS8ODeeZmq85OAMqB6zny9XFEAkM5nrgrPtLSlSQ6JHTVBnYzqU
	8P/wPeXL19JeZjAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Tky9ZzWw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="22mM/DgM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791199451; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vm/ySz3HOdR/ndmcqA8Sm3SIQvkPcyS1mZWChqoU3Q4=;
	b=Tky9ZzWwEng6pVZQTB6OXGGEQil67eNYlY3XbfvGYONai6dEk4j41uyKaaBQZDnZGapBAr
	4/SoMZDFAXgtSQlZx8TRBrVdSibBHO3j8WKKHZgiNskjSCFR6houOxHXg1sVoQ04Hl4y95
	sI/Y+wUOmWyU2u9pgLXqD1yTXLugrro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791199451;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vm/ySz3HOdR/ndmcqA8Sm3SIQvkPcyS1mZWChqoU3Q4=;
	b=22mM/DgMPsZiKNj7v7q1llmo0HNgiGAsgc/3TW4j8qzf0xKpQ1Ajk/oggQEqGmbDXbjjUN
	D1EytuDgeoyKi1DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 355F713A1D;
	Mon,  5 Oct 2026 11:24:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qUAOB9uIw2p7YgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 05 Oct 2026 11:24:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5C1BBA13FD; Mon, 05 Oct 2026 13:18:44 +0200 (CEST)
Date: Mon, 5 Oct 2026 13:18:44 +0200
From: Jan Kara <jack@suse.cz>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: return an error when a journal block is not mapped
Message-ID: <vxskryoldaadfisrk27j4rohp3h2xmvk5bdeqjytivl7w5evu3@ztksgr266ujk>
References: <20261004180629.27213-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004180629.27213-1-kmehltretter@gmail.com>
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5FA9C1F399
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Sun 04-10-26 20:06:29, Karl Mehltretter wrote:
> If the internal journal inode contains a hole, ext4_map_blocks() returns
> 0. ext4_journal_bmap() logs "journal bmap failed" and aborts the
> journal, but also returns 0 and leaves *block unchanged.
> 
> jbd2_journal_bmap() takes that as success and uses the unchanged logical
> journal block number as a physical filesystem block number. Journal I/O
> can then overwrite filesystem blocks outside the journal despite the
> abort.
> 
> Return -EFSCORRUPTED for a hole, matching the error passed to
> jbd2_journal_abort(). Keep propagating negative mapping errors.
> 
> Fixes: 62913ae96de7 ("ext4, jbd2: add an optimized bmap for the journal inode")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Found with an experimental clang that warns when a function returns 0
> right after reporting a failure.
> 
> Recorded QEMU A/B testing used x86_64 kernels and a 1 KiB-block image
> with a hole in the journal inode starting at logical block 40. The
> unpatched kernel overwrote filesystem block 40, a reserved GDT block.
> With the patch, none of the marker blocks changed. There were three
> runs per kernel.
> 
> Both kernels logged the mapping failure and journal abort:
> 
>   EXT4-fs (vda): journal bmap failed: block 40 ret 0
>   Aborting journal on device vda-8.
> 
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index bca0dc87d0b7..3e7dabe45153 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5967,7 +5967,7 @@ static int ext4_journal_bmap(journal_t *journal, sector_t *block)
>  			 "journal bmap failed: block %llu ret %d\n",
>  			 *block, ret);
>  		jbd2_journal_abort(journal, ret ? ret : -EFSCORRUPTED);
> -		return ret;
> +		return ret ? ret : -EFSCORRUPTED;
>  	}
>  	*block = map.m_pblk;
>  	return 0;
> 
> base-commit: e767a4ea70a3992c37ed604157d32f0dfbf9b1e3
> -- 
> 2.53.0
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
