Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA6927874F
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781790980; cv=none; b=sUDjq0Ergp4XlZCyfKbmnGZ5EgTHU9ATinTKws/n8wavcCAkjqgP4H23cYIGFdSakO8MqPTXkk6gYdpQoN5ETpdd3HRKDtcMs1pnmiJZCPCbjuXjLFF9WxBOzj1T+k55/wQY141FBwPRk0Lq+2GeJq+pZUEd5rEHaIX597ZSghI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781790980; c=relaxed/simple;
	bh=nxhh3RfIGgNCUk5W7ndi/8qZrOvB6DBzipqYm99g4Xw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5usTUBibEYR2gxM199emFwXIsP8ZqR7rlccNiw4TqxTcOfgOwhQT1Cl/eLmQXDP8Vhvx62weUXWE1bXXRsiQKX53Aqr4T+rghIh478E9f8uyDIe4Oi78J1hQhvKHR88aO2HI22LMxKHGgKeb8KvKj1P/bchcgFExUEaaauZGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LTibyCHC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M+hQ4VjL; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=LTibyCHC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M+hQ4VjL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LTibyCHC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M+hQ4VjL";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="LTibyCHC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M+hQ4VjL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 491C16D23D;
	Thu, 18 Jun 2026 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N8wKMA4hRH7BwVx3RBo19GbRLM1M9FjBUCUrQzdmp3c=;
	b=LTibyCHCF7BNyK+vXzvpx/fuueZAIJX1qhTkv+2OvmGW/7tB3ARITXdb8dZ/vBOtcCrmyW
	3p8R6y8qju8TDV1KkND1WfublC9RvcwQepm/zXn0hy9iGOzU/yUA3lg0iDCSnGPwHrlpDk
	t4tJ5L9zvutyzcKvMStkcSdtO32Htvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N8wKMA4hRH7BwVx3RBo19GbRLM1M9FjBUCUrQzdmp3c=;
	b=M+hQ4VjLa0gPTiLRZNUSC6nYN4ZiIFaZY6ccEfR+JCz++1TdkMB1tGfgQJanyLUuW2a3NL
	z17TR4WdGAFIIuBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LTibyCHC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M+hQ4VjL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781790977; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N8wKMA4hRH7BwVx3RBo19GbRLM1M9FjBUCUrQzdmp3c=;
	b=LTibyCHCF7BNyK+vXzvpx/fuueZAIJX1qhTkv+2OvmGW/7tB3ARITXdb8dZ/vBOtcCrmyW
	3p8R6y8qju8TDV1KkND1WfublC9RvcwQepm/zXn0hy9iGOzU/yUA3lg0iDCSnGPwHrlpDk
	t4tJ5L9zvutyzcKvMStkcSdtO32Htvw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781790977;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N8wKMA4hRH7BwVx3RBo19GbRLM1M9FjBUCUrQzdmp3c=;
	b=M+hQ4VjLa0gPTiLRZNUSC6nYN4ZiIFaZY6ccEfR+JCz++1TdkMB1tGfgQJanyLUuW2a3NL
	z17TR4WdGAFIIuBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E46F779AC;
	Thu, 18 Jun 2026 13:56:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dVsxDwH5M2ptegAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 13:56:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F393AA12D9; Thu, 18 Jun 2026 15:56:12 +0200 (CEST)
Date: Thu, 18 Jun 2026 15:56:12 +0200
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, yi.zhang@huawei.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, peng_wang@linux.alibaba.com
Subject: Re: [PATCH v2 5/8] ext4: use kiocb_modified instead of file_modified
 in DIO/DAX write path
Message-ID: <6p2rafiw4wvlr3nmnyrdz2w32ln56gw63in5d3wtzsryniokgi@rdhlw7e5pfm4>
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-6-libaokun@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618125735.4156639-6-libaokun@linux.alibaba.com>
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,huawei.com,linux.ibm.com,gmail.com,linux.alibaba.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 491C16D23D
X-Spam-Score: -2.51

On Thu 18-06-26 20:57:32, Baokun Li wrote:
> file_modified() passes flags=0 which drops IOCB_NOWAIT, causing
> file_update_time() to sleep in ext4_journal_start() via
> ext4_dirty_inode() even in non-blocking contexts.
> 
> kiocb_modified(iocb) propagates iocb->ki_flags so that
> generic_update_time() correctly returns -EAGAIN when IOCB_NOWAIT
> is set and ->dirty_inode could block, matching the behavior
> already adopted by XFS, FUSE, and ext2.
> 
> Affected paths:
> - ext4_dio_write_checks(): DIO NOWAIT write
> - ext4_write_checks(): shared by buffered (rejects NOWAIT upfront)
>   and DAX write (supports NOWAIT)
> 
> ext4_fallocate() in extents.c is not affected as it has no kiocb.
> 
> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>

Indeed, good catch! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 2681f148e7b8..5ffc1afd8050 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -307,7 +307,7 @@ static ssize_t ext4_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  	if (count <= 0)
>  		return count;
>  
> -	ret = file_modified(iocb->ki_filp);
> +	ret = kiocb_modified(iocb);
>  	if (ret)
>  		return ret;
>  
> @@ -465,7 +465,7 @@ static const struct iomap_dio_ops ext4_dio_write_ops = {
>   *
>   * The decision is layered, evaluated in this order:
>   *
> - * 1. If file_modified() needs to update security info (!IS_NOSEC), upgrade
> + * 1. If kiocb_modified() needs to update security info (!IS_NOSEC), upgrade
>   *    to the exclusive lock -- the security update itself requires it,
>   *    regardless of whether the write extends the file or is aligned.
>   *
> @@ -555,7 +555,7 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
>  		*dio_flags = IOMAP_DIO_FORCE_WAIT;
>  	}
>  
> -	ret = file_modified(file);
> +	ret = kiocb_modified(iocb);
>  	if (ret < 0)
>  		goto out;
>  
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
