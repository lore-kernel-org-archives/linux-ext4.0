Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66134F3EAF;
	Tue, 13 Oct 2026 12:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894026; cv=none; b=W9B9mRLGwFNJ+ZFvaeFPcEXy/F8TghmTnvI0uNxSreNh93xrbF9V2xJzPzPsFTCrNZZS2QxpFQafbNu4ss9P35V9emyN3Ov86kvhUa0mOFEsrMWhAZB3IXgZbwtAvSI3lh7pKX8debiDIluVtUT+RsPdMIB2yzvil3VYAjaEEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894026; c=relaxed/simple;
	bh=gLHOz6njKTNxjDFN02B8L8v99H/7ZMGByM9sSmYJovA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBSXfE6Yj6kaipm58utFFXUQMq2HsXfjBx78q3OLrkJfkMq+Kwx6sMUf1foT+1rHOm60nfO4BlljMOtiD4J1NknZUFy1XPY7byvhMDItqiVjyiMn7i+0kbY9ls4YZwjcoCqFwUBy0elI++2y+92DtZfMJDoylJtU8HKOWPx6YYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MYPtX1pq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UIMJ6gtk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MYPtX1pq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=UIMJ6gtk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MYPtX1pq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UIMJ6gtk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MYPtX1pq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="UIMJ6gtk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3B4851F38E;
	Tue, 13 Oct 2026 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OlJGBCagWvXQGO1VIHshMZ8zFkjRtPwQ0FF4ct4s8xw=;
	b=MYPtX1pqwVUK0zZLZ7JvsDlUrVeuxO2nws3ChajkvINSlQYgy3PyDbw/9d3fAfPnyrfW4K
	H1IH3q1/ZDU6NP3Zefp8sgQM0853fsandUaEbxwiTPkRc5qAIp0dVWrQ4vArbygF1shmv+
	FJYGCSiEF+Zh1pTqYt1GO43sCfgdH+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OlJGBCagWvXQGO1VIHshMZ8zFkjRtPwQ0FF4ct4s8xw=;
	b=UIMJ6gtkD8PBH05LiVAMA2MYaKywXMR4QoVM3vTGpCC7e704+xtAI6w1wc/TFo8fJltuF9
	+vdubEu+r1kOTgDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MYPtX1pq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UIMJ6gtk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791894022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OlJGBCagWvXQGO1VIHshMZ8zFkjRtPwQ0FF4ct4s8xw=;
	b=MYPtX1pqwVUK0zZLZ7JvsDlUrVeuxO2nws3ChajkvINSlQYgy3PyDbw/9d3fAfPnyrfW4K
	H1IH3q1/ZDU6NP3Zefp8sgQM0853fsandUaEbxwiTPkRc5qAIp0dVWrQ4vArbygF1shmv+
	FJYGCSiEF+Zh1pTqYt1GO43sCfgdH+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791894022;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OlJGBCagWvXQGO1VIHshMZ8zFkjRtPwQ0FF4ct4s8xw=;
	b=UIMJ6gtkD8PBH05LiVAMA2MYaKywXMR4QoVM3vTGpCC7e704+xtAI6w1wc/TFo8fJltuF9
	+vdubEu+r1kOTgDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DAA73134B8;
	Tue, 13 Oct 2026 12:20:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cd1nLAUizmraJgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 13 Oct 2026 12:20:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 627C6A1407; Tue, 13 Oct 2026 14:20:21 +0200 (CEST)
Date: Tue, 13 Oct 2026 14:20:21 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] jbd2: check return value of blkdev_issue_flush()
 for async commits
Message-ID: <ntruc4otct22v67ajoclslm7dr73fuyhqlcwpt3djnzhcacnjy@tap3ofwarqim>
References: <20261012114713.4049391-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-1-guolingxing@tju.edu.cn>
 <20261013014028.1152277-4-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013014028.1152277-4-guolingxing@tju.edu.cn>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3B4851F38E
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
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DWL_DNSWL_BLOCKED(0.00)[suse.cz:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:email,suse.cz:dkim]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Tue 13-10-26 01:40:28, guolingxing wrote:
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

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8c561e42b60a..4e8ebce34077 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -912,7 +912,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	stats.run.rs_blocks_logged++;
>  	if (jbd2_has_feature_async_commit(journal) &&
>  	    journal->j_flags & JBD2_BARRIER) {
> -		blkdev_issue_flush(journal->j_dev);
> +		int flush_err = blkdev_issue_flush(journal->j_dev);
> +
> +		if (!err)
> +			err = flush_err;
>  	}
>  
>  	if (err)
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
