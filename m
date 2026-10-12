Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1DB49B5C2;
	Mon, 12 Oct 2026 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791819198; cv=none; b=ZJf/r6xvgOPMEORGh4+iSk7eoWvu9f+3DkJCd0G+OGs6UzL85JCh2GucMpDsAs/vBvpu+BreL65S4R0TkrUxhkSQLlR3xl9liEVabXt6qna0SjJ3DAAZmgGSk6HqtR1a22MOKEDAg6WMR3oGq1bdOf4QtRdpQ2Aj7mKG1cllz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791819198; c=relaxed/simple;
	bh=yhaeo+33KBHB7DYaUg4O1iCLOqNoMeoMDzsEspE1J9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syOBlhuQynyqmqFnKRhJAvqIYNdGsVgcP4yc5tSt9/yv2dh5SWyPA6aVtPBCViEWKmw+Os7YZ7u5gqKStf2G3fGvZMwsEj6yZyq/tU9S24HKQpUYYOQmLmyqDB4D6F6zRZt07L8UrvTsEAUGrEbO0Ii+Lj0Y8XxmcleGYiZ3vFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zpCHq9DK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/ndpQ3ZX; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=IhRen+sC; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NqiNwOI+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zpCHq9DK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/ndpQ3ZX";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="IhRen+sC";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NqiNwOI+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C61691F391;
	Mon, 12 Oct 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791819195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cg/3QY4N7vANLO6tsQkD5rCgqieZ7atYzmFbPHoaUwg=;
	b=zpCHq9DKxCUT3HgwjYz+fJsehZ8ay6kGu7+WiJIiIsyd8GYcP6oiPQUPzbtggdR672gVnV
	MF6cvyEdXqn3Zr1HyUCdAyhWLCWFwvkGTEFI9aUSjtTs7/1zQtVVPLR8Lh9BUTjhUN0z0c
	y9GLq6cnhU70CFjiuZBCKidztd5M0E0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791819195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cg/3QY4N7vANLO6tsQkD5rCgqieZ7atYzmFbPHoaUwg=;
	b=/ndpQ3ZXDKi+oM3zNMStYYBa9R57mAk98Np6T6YHGnpNLDrUwnE2T3BCHFrTYi76Ouuzx/
	LfTzokVPso6v5hCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791819193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cg/3QY4N7vANLO6tsQkD5rCgqieZ7atYzmFbPHoaUwg=;
	b=IhRen+sCiyQ/Gnk+s9q+M6mgphMTrXhPrFs0IZ0ejVI773EubDTWdtr3NzpFSquS4aklpQ
	1V07NqCtwTcdlC1rj6Nho361E6/pdwgaGN42ycjOvganDvWNz92aY4r0mJTRa/dbDk/era
	zcxCtUlu9bsgiIv9Gc0Hmp58OJdZfZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791819193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cg/3QY4N7vANLO6tsQkD5rCgqieZ7atYzmFbPHoaUwg=;
	b=NqiNwOI+PudWCFQwq4QeWaEPOwQYANYTymluO6Q9PE1pd50iWdP05/Rt+hKEa9eXtDp6eT
	NHH+zI0DOiIs40AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EE6F13408;
	Mon, 12 Oct 2026 15:33:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B358Hrn9zGoaeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 15:33:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2D812A1407; Mon, 12 Oct 2026 17:33:13 +0200 (CEST)
Date: Mon, 12 Oct 2026 17:33:13 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] jbd2: check return value of blkdev_issue_flush() for
 async commits
Message-ID: <72fp6unfdifte47ppqjclkblcikfiaffudlwmsjp6vtkjg4nkg@ndabhrgz7yjp>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261012114713.4049391-3-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012114713.4049391-3-guolingxing@tju.edu.cn>
X-Spam-Flag: NO
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,tju.edu.cn:email,imap1.dmz-prg2.suse.org:helo]

On Mon 12-10-26 11:47:13, guolingxing wrote:
> When asynchronous commits are enabled, jbd2_commit_transaction()
> calls blkdev_issue_flush() on the journal device to make the commit
> record permanent.  However the return value is ignored so if the
> flush fails, the transaction is considered committed although the
> commit record may have never reached the disk.  Abort the journal
> when the flush fails, as we already do when waiting for the commit
> record fails.
> 
> Fixes: f73bee49855f ("jbd2: Modify ASYNC_COMMIT code to not rely on queue draining on barrier")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
...
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 99477e9c78c7..32ca502603be 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -912,7 +912,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	stats.run.rs_blocks_logged++;
>  	if (jbd2_has_feature_async_commit(journal) &&
>  	    journal->j_flags & JBD2_BARRIER) {
> -		blkdev_issue_flush(journal->j_dev);
> +		int err = blkdev_issue_flush(journal->j_dev);

Again this shadows existing local variable, which is a bad practice. Just
call this flush_err or something.

> +
> +		if (err)
> +			jbd2_journal_abort(journal, err);

And here we can do instead:
		if (!err)
			err = flush_err;
since below we take care of aborting the journal if err is set.

								Honza

>  	}
>  
>  	if (err)
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
