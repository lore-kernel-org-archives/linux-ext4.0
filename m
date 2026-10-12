Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F034A2616;
	Mon, 12 Oct 2026 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819078; cv=none; b=fBnN3JDxvwAGPBg6WLLp190biVMOgQcs9M3TFJiTo4lgnd/STOTN85ssdFiO7Oz2uzZguR+pmrOgEMx+S2gAhEVyO35rg+hGCrGIxVi5cKWNhNaNPw4NrZNqbqWxGRIbtd5arK6uLL0MIjHz8aKlJHkO8tVnJpLGSLkd3p/hnLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819078; c=relaxed/simple;
	bh=eQQCHSX2mTrNrihkju255YBRmbsk1KaBkIDyw1JaWZc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHaGcWYkr7xo5T7O68qB4KtKk1SmvcsLPtOFUSf5rvOGRD3lrY1nKh5uQXhLR1Y3mtTrJbuzBqBR1LQsyii9RcELXLIv0YNcO038MkjOGqW5bgQy8kJ+7nTbkLEaP+4i/TWmXcjhwjQKIzlpHHDNFNmutDbz9408AsXO2xjquL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2FnEF6te; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tC656tJ8; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jyTQSODa; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ghk4llOb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2FnEF6te";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tC656tJ8";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jyTQSODa";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ghk4llOb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9ADCC1F452;
	Mon, 12 Oct 2026 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791819074; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zdY5YWXodrgTEQLZZ2so1d7629xeNDwoEpZQtSvlgM4=;
	b=2FnEF6teziFokqYHQ0bEL/zHh//r+7AmkyI3s1JTGiHt0LZD56yXBYZqaaM4dV2ZRDLbHg
	Ah2IzRUOXrml+er/ZdSTuEAMw6TjGA2z6J8aKCw7L4DqfXX7L2KFPHZj9cnyj7Xx8M4S6t
	zmLkcqu2GY+lMV1iv7v/U0jF8vxQ6Ns=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791819074;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zdY5YWXodrgTEQLZZ2so1d7629xeNDwoEpZQtSvlgM4=;
	b=tC656tJ8bYu8v0+B+uyDuSXItEmjToA3hgz2MVj7lEPWy4kINyJGz+0GNN7MvbXCgq1uuD
	cjkAduQRka3gzLDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jyTQSODa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ghk4llOb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791819073; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zdY5YWXodrgTEQLZZ2so1d7629xeNDwoEpZQtSvlgM4=;
	b=jyTQSODayqWDr5KFNRWk3YsXqxfm/kMzwHc9uWYVWucMOQfuZWa4pXElPped5qEhpIfcUa
	NyZuapzXoMtK/YU61FlDj1d9hARKLcnrXdRbr1asMjjvzzMBP1xbwmwpielci/luhXVBjt
	KPhK/KqJYsHE+L5SMqFNUrd7Ibcfnbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791819073;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zdY5YWXodrgTEQLZZ2so1d7629xeNDwoEpZQtSvlgM4=;
	b=Ghk4llObqc3BhUCTQIvKZravXnLAShCFUF7zOCte2YPRABggZZi5l3PUTGoUop71HPx0h1
	tVp4J7tIg8kdbpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FF1713408;
	Mon, 12 Oct 2026 15:31:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id USzUEkH9zGordgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 15:31:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EE83DA1407; Mon, 12 Oct 2026 17:31:08 +0200 (CEST)
Date: Mon, 12 Oct 2026 17:31:08 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] jbd2: check return value of blkdev_issue_flush()
 when committing
Message-ID: <b3axtsgm7d7dauninfvmmlgjbnka4u6i7c2dv27exnhgtottj6@wow3yi7r5ub5>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261012114713.4049391-2-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012114713.4049391-2-guolingxing@tju.edu.cn>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9ADCC1F452
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,tju.edu.cn:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Mon 12-10-26 11:47:12, guolingxing wrote:
> For journals on a separate device, jbd2_commit_transaction() must
> flush the file system device before submitting the commit record,
> otherwise the transaction may get committed while the ordered data
> are still in the device cache.  However the return value of
> blkdev_issue_flush() is ignored so if the flush fails, the commit
> record is still submitted and fsync() reports success although the
> ordered data may have never reached the disk.  After a crash the
> journal recovery will consider such transactions committed and data
> written by fsync() may be lost.
> 
> Abort the journal when the flush fails.  The commit record is then
> not submitted anymore since journal_submit_commit_record() checks
> for an aborted journal.
> 
> Fixes: cc3e1bea5d87 ("ext4, jbd2: Add barriers for file systems with exernal journals")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
...
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 3029cb6f6d64..99477e9c78c7 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -800,8 +800,12 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	 */
>  	if ((commit_transaction->t_need_data_flush || update_tail) &&
>  	    (journal->j_fs_dev != journal->j_dev) &&
> -	    (journal->j_flags & JBD2_BARRIER))
> -		blkdev_issue_flush(journal->j_fs_dev);
> +	    (journal->j_flags & JBD2_BARRIER)) {
> +		int err = blkdev_issue_flush(journal->j_fs_dev);

This shadows an 'err' definition of already existing variable. Just use
that variable instead. Otherwise the patch looks good.

								Honza

> +
> +		if (err)
> +			jbd2_journal_abort(journal, err);
> +	}
>  
>  	/* Done it all: now write the commit record asynchronously. */
>  	if (jbd2_has_feature_async_commit(journal)) {
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
