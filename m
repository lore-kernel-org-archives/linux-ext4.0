Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A174A3FA5F1
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2026 10:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035988; cv=none; b=mevg3WTbbSu77nwKDnvaoxu7gmZqXTin9HxHDSh3gONT3+dn5UBN42rBMJN+ubKLF5r01BXjoFqJZOnDOQCbxfhwlWC1BgFVEbILOtd2lMs+ILvIuUC9AKzhtSuGq6Q/a6lKkmj0YO1mNQapGw1EjKu/H2naPZNflG+8CtXttOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035988; c=relaxed/simple;
	bh=RZiHIFhq06Di0z+Lj3eIHuu3JQGDTCSuAtRAuMxlp0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MffcAXhONZEwE4g9ObDe7S1CNZf8bylaQwBLhFn64q6vjrFrY0fRueu5EkfbY/UPIvnnSNn4OvIkGwsMSmXbB95ed0Wg+qBRfPILBwgszAiXJ3BejOPJfeYovUcDaNeVn2VEIXZcT/RkMQqIX8wYLmrmI/FuhuPI4keEtQAiRJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lQz2kaSL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7kHCF1po; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H0lb/+iL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4LjxTkA8; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lQz2kaSL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7kHCF1po";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H0lb/+iL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4LjxTkA8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 974441FD87;
	Thu, 10 Sep 2026 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxRxdGL0ugvvEXQZ5d651xO2pzabzBTVkzlL4WSbut0=;
	b=lQz2kaSLO6b31FKS3JB78kcDtBO7iIa1xmZFvkDjD8IzLfmXIHNsDY4zOJricUMxfTF6Pl
	HLIHGXmo2tQAAZ5KVdlRcaw/zHYVTKKhMekd4H9Flh76Bji7972ExVWFPHcPQSTW2QHTSC
	CXM3DZ6Fifx+/WEAOyqDXsawkMcK2k0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxRxdGL0ugvvEXQZ5d651xO2pzabzBTVkzlL4WSbut0=;
	b=7kHCF1poVDDAwmjlmvIxnRWX6+74CfiYi5XfC4wbY1L1D9E1C/93DmjQ2UGZhyO+JzIQAt
	SCZpYRQ71D+E5dDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789035973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxRxdGL0ugvvEXQZ5d651xO2pzabzBTVkzlL4WSbut0=;
	b=H0lb/+iLwk6AWDgCFMVc5bReO1yIXxA5mtWhyekL3gGAz0RpwkrJSvTx6tUTXLQE90CPdp
	RzhFB1Yibh4In/rxF4J1ITzCN9sui6K7jBzyxsf9FodKp/p3liDkAKhFKg2Y38f2N0kA0k
	fMjYsutESK3D3qve/xUr7ZxmbKxMx4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789035973;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxRxdGL0ugvvEXQZ5d651xO2pzabzBTVkzlL4WSbut0=;
	b=4LjxTkA8sspxMb65N1I+loWL3zL3hRMkzBsN7qmMhHS5Z7ir9cpj2FlxrYQj5kOzWa5RqA
	hW9bAltg/LAP3tAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7112913180;
	Thu, 10 Sep 2026 10:26:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O0mZG8WFompeTQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 10:26:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F33CCA12EA; Thu, 10 Sep 2026 12:26:12 +0200 (CEST)
Date: Thu, 10 Sep 2026 12:26:12 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, yi.zhang@huawei.com, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4:Update the pre-check in ext4_find_inline_data_nolock
Message-ID: <3lwoha7allqhzhj3cqjy4b33xkkmkqf4ga45gckxxzht26dp4d@v5x2w76gqnsi>
References: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0EDE840F0C8186D030DEAF5A95B8BE54350A@qq.com>
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
	FREEMAIL_TO(0.00)[qq.com];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Thu 10-09-26 11:26:14, shuo chen wrote:
> The pre-check in ext4_find_inline_data_nolock should be kept
> consistent with that in ext4_xattr_ibody_find,so as to avoid
> unnecessary operations.
> 
> Signed-off-by: shuo chen <1289151713@qq.com>

Yeah, ok, it's a tiny improvement but it's a bit cleaner this way. Feel
free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inline.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
> index ceee69a66482..9f6a4d13b9ab 100644
> --- a/fs/ext4/inline.c
> +++ b/fs/ext4/inline.c
> @@ -151,7 +151,7 @@ int ext4_find_inline_data_nolock(struct inode *inode)
>  	};
>  	int error;
>  
> -	if (EXT4_I(inode)->i_extra_isize == 0)
> +	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
>  		return 0;
>  
>  	error = ext4_get_inode_loc(inode, &is.iloc);
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
