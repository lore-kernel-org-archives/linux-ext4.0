Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD993FB7E9
	for <linux-ext4@vger.kernel.org>; Fri, 26 Jun 2026 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782491427; cv=none; b=C/TswYt811edhH8YEAdWawF/LX9CvwD6cgmbCHq5MaTfNhR1oHMsr8cUQwq09YEeQZYcfRNC1rHOtFd5pTiYJlN6+bu7Ovhp/fIjd707vndX59J+ZowF7a+4SENZ5LvPSeKdwM5urDsaXlu7Z7YxZebzDsk3PA/PHEhtU6noFe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782491427; c=relaxed/simple;
	bh=FSBUERRSuusoPYBYVb1ev6KT9dsw7t18FqnTyI9KV7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jaOoXOffrhTLHXB6rpTEKeIeKruPlVecWP24RyT561PKck82ZvpkcmChwV4sPBIZNyZ6tqPheZzuS7X51pbhZhkBS0rxIQvN3BSfdCMbCwB5jWOp2+xtiahh4CUh6KJ+Gse4HakylLvTqrUzBzFAzIwjBqjMgH0wXfuvSIJN+Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZaBxR0Rz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=I8pvMrYQ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rRtq/6Zz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S9yrPtCj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZaBxR0Rz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="I8pvMrYQ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rRtq/6Zz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S9yrPtCj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D64C3710B0;
	Fri, 26 Jun 2026 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782491424; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPpCIJOMFDBBanuAGfZP+Mf6d8nWX1cIvyZCJZPyRvs=;
	b=ZaBxR0RzRSAAUWUT122KnanfLutR0UoZP76iIi8n6lDiMldP/A6a06BHKKSU91pPhl2HH5
	yppBvP6Cg9LO31zyiQZ+LK0Bu/Wtrgu0TvmvVLyQncUi7+k8kZvGxjuQMxSBFeLsMLiLo/
	gwwlJ4ewN167SFKY/r29ANSNP/OwCqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782491424;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPpCIJOMFDBBanuAGfZP+Mf6d8nWX1cIvyZCJZPyRvs=;
	b=I8pvMrYQ50Djqa7SoHatv2oL+IxvfdRlRe6fUDGLY7G/AhmYluajreDZEUADAT2UMCSaZS
	H/m3q5wPxUNFlODQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="rRtq/6Zz";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=S9yrPtCj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782491423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPpCIJOMFDBBanuAGfZP+Mf6d8nWX1cIvyZCJZPyRvs=;
	b=rRtq/6Zzc+8/P/ymG9EEAN6crx4i47M9AW0H9rmp4h4+2qOt3HxWSZXmvFbgZvjdlaMhCC
	7L0oNdfwwxQ4lVseUxQwxS81HQNCe0nVsOG7Kzch/KDTDCNKYUZkh9mZqfK5HDOlymTGhT
	0HmFDl1dXldFioCSox4LGFpj7PhYVIk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782491423;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LPpCIJOMFDBBanuAGfZP+Mf6d8nWX1cIvyZCJZPyRvs=;
	b=S9yrPtCj7aEfbLbPkNFVW+QcphKskHKBd1ZAsCpOiMfSCmmFpwSxOLlmqEo/XrBUern30l
	jENZ8VjfAtUCsuBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB9CD779A8;
	Fri, 26 Jun 2026 16:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XdzHMR+pPmqJXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 16:30:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5E8F1A10A3; Fri, 26 Jun 2026 18:30:15 +0200 (CEST)
Date: Fri, 26 Jun 2026 18:30:15 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v10 1/5] fs: add iput_if_not_last() helper
Message-ID: <7yskwsnguq5y5j444asgtrmnygemjkzrkeqyst7supaqtbqvz6@xiprfaevpkrq>
References: <20260625152941.24788-1-yun.zhou@windriver.com>
 <20260625152941.24788-2-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625152941.24788-2-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,windriver.com:email];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D64C3710B0
X-Spam-Score: -2.51

On Thu 25-06-26 23:29:37, Yun Zhou wrote:
> Add a helper that drops an inode reference only if the caller does not
> hold the last one.  Returns true if the reference was dropped, false
> otherwise.
> 
> This is useful for filesystems that need to release inode references
> in contexts where triggering final iput (and thus eviction) would be
> unsafe due to lock ordering constraints.  The caller can check the
> return value and defer the final iput to a safe context.
> 
> Unlike iput_not_last() which BUG_ON's if called with the last ref,
> this variant is designed to be called speculatively.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Suggested-by: Jan Kara <jack@suse.cz>

Yes, I think this is a sensible addition to the inode refcounting API which
will allow filesystems to save the hassle of iput offloading in the common
case. Just one nit below, otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6da44573ce45..4916a9d54347 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2418,6 +2418,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  void iput_not_last(struct inode *);
> +
> +/**
> + * iput_if_not_last - drop an inode reference only if it is not the last one
> + * @inode: inode to put
> + *
> + * Returns true if the reference was dropped, false if this was the last
> + * reference and the caller must arrange for final iput() in a safe context.
> + */
> +static inline bool iput_if_not_last(struct inode *inode)

I'd add __must_check to the declaration.

								Honza

> +{
> +	return atomic_add_unless(&inode->i_count, -1, 1);
> +}
> +
>  int inode_update_time(struct inode *inode, enum fs_update_time type,
>  		unsigned int flags);
>  int generic_update_time(struct inode *inode, enum fs_update_time type,
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
