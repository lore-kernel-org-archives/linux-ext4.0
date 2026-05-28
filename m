Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203023E51EF
	for <linux-ext4@vger.kernel.org>; Thu, 28 May 2026 11:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779968501; cv=none; b=gVcowZCNSjCywThLMD5Khhm5Et4zK8LUAafttNxC+Vp750J15MzjUccupNeAbspkOOIFeFWngzB84JN+JvptEA/jMw8oviWE/l+qjS7OphYPyCeWyXzMRK0iBAEbmBkT5y8kNtoOcTogbBSGsUhXTvlVhOsczrxWqz3k3iWqxyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779968501; c=relaxed/simple;
	bh=+OVO6wDzgsMJRKFYP5vd8V1YDyemaODPE1iE+5nLQoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puaYaYrqGi11RodHvFri1d4hQjSbsvyWq/lAH8E/9GfG1KH95Dv3b10JOssUwYfwQ+b498FqYL6YKTs/1ge7dRUHpIseiSB+oYPK1XqZdB/SxAQltcwsdCKKIOv3Dq28gsIKXAxG4tOpxVSqS/qnXwBhXi6m2448B68aJqn+xb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zGyCGH5v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xPnr1sdP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zGyCGH5v; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xPnr1sdP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zGyCGH5v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xPnr1sdP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zGyCGH5v";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xPnr1sdP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F9DA66DBF;
	Thu, 28 May 2026 11:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779968498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5i6Hn7vw3BNyEnoG0FVBuklc7R49iLt8PwV0tlwvFz4=;
	b=zGyCGH5vVWsqRxzi5ccXMDVud4qMTJzRWVzTUoy74ohWuHjSRWiRhBnnJLWoAGpxXNIqEG
	BTgrH+AnjDm8jRx2dSuHHiptwwLXFFxV9FHZY1trshZ+0razDaF9EU7RTbN4r/EFTW7099
	UvaqKGX3ORrg08drHY2azwW+0T+FY9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779968498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5i6Hn7vw3BNyEnoG0FVBuklc7R49iLt8PwV0tlwvFz4=;
	b=xPnr1sdPA3xuhaytvPi74FRrlYaYJMW82YheeMJ6kfqrYo72sppknIH+9vsYUN9VHUFQba
	QQX2dlrzFjIMfkDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zGyCGH5v;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xPnr1sdP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779968498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5i6Hn7vw3BNyEnoG0FVBuklc7R49iLt8PwV0tlwvFz4=;
	b=zGyCGH5vVWsqRxzi5ccXMDVud4qMTJzRWVzTUoy74ohWuHjSRWiRhBnnJLWoAGpxXNIqEG
	BTgrH+AnjDm8jRx2dSuHHiptwwLXFFxV9FHZY1trshZ+0razDaF9EU7RTbN4r/EFTW7099
	UvaqKGX3ORrg08drHY2azwW+0T+FY9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779968498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5i6Hn7vw3BNyEnoG0FVBuklc7R49iLt8PwV0tlwvFz4=;
	b=xPnr1sdPA3xuhaytvPi74FRrlYaYJMW82YheeMJ6kfqrYo72sppknIH+9vsYUN9VHUFQba
	QQX2dlrzFjIMfkDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 260A95AD7C;
	Thu, 28 May 2026 11:41:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8LVJCfIpGGo4TwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 28 May 2026 11:41:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1ED4A0905; Thu, 28 May 2026 13:41:37 +0200 (CEST)
Date: Thu, 28 May 2026 13:41:37 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Remove mention of PageWriteback
Message-ID: <6ajazupewirr5gokbk7ibtsbr6fsq5eef777zz42caivqkrpps@l3i7m3sqi3sk>
References: <20260526190805.341676-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526190805.341676-1-willy@infradead.org>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2F9DA66DBF
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
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,infradead.org:email]

On Tue 26-05-26 20:08:02, Matthew Wilcox (Oracle) wrote:
> Update a comment to refer to the concept of writeback instead of the
> (now obsolete) detail of how it's implemented.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/page-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index dc82e7b57e75..bc674aa4a656 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -168,7 +168,7 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
>   * written. On IO failure, check if journal abort is needed. Note that
>   * we are protected from truncate touching same part of extent tree by the
>   * fact that truncate code waits for all DIO to finish (thus exclusion from
> - * direct IO is achieved) and also waits for PageWriteback bits. Thus we
> + * direct IO is achieved) and also waits for writeback to complete. Thus we
>   * cannot get to ext4_ext_truncate() before all IOs overlapping that range are
>   * completed (happens from ext4_free_ioend()).
>   */
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
