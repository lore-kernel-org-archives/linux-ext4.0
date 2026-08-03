Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D808413780
	for <linux-ext4@vger.kernel.org>; Mon,  3 Aug 2026 13:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764854; cv=none; b=dOgrd/OV9pDUnYrCs/GoJKt6rrhWJ2J+WlUlKNeB4pM9w8a3luL9ovvmjRD2G91t/CG77esAvqpyFZyAQQNjC/2JRMZ+wJuLL1MqSq/SYDixSU+jUabl+h1Knu6zGlFrHWHoifVkTlHHTNmHbv7wPxcMrOaH1HLmZAxI7XsC1Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764854; c=relaxed/simple;
	bh=qIuT2ZVg2f9bKmQHweRZ6D3EXQsupOI0K+sBolRUe/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gu2hfRzZvLalv/Q7t0ZZMrJeEaylLT6WLViXzfIusl0ALdRlX6wjV/lK3MznpnOIspSl+B6Ov5qiCVgp37E1KaPIs6rY1RILI/CRv9blFERc61HOqDxNaliw8hoiUk1HewTA4+8c4UPqG5RFFEvdgpSGMgt+0vIW+AA5cJ4NKyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=B39HNbKg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mOoHoMC6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=blJeR6zP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qpNCGuKE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="B39HNbKg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mOoHoMC6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="blJeR6zP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qpNCGuKE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2AC2D3E2A;
	Mon,  3 Aug 2026 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785764847; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSNnRly/YWDGSDrXnEgj2BAyD2DKLkCom8eRM49EllU=;
	b=B39HNbKgA8ysb8ElOr47Z9XCy6tBUuCLs66mo55trwiTqsA4kTc9PrCsqTTPxK42LTXcKp
	rfjoImfT/1iE+fUUk+i9Bpd2bMDmw8VMoZDiyMVLVKZ2scd193/jbNQbW3edREBmrI9lS/
	XeaCnQSfrxJa7djL4bGVLd//4WOTbxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785764847;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSNnRly/YWDGSDrXnEgj2BAyD2DKLkCom8eRM49EllU=;
	b=mOoHoMC6qMgAqK47vT2PEb4oXGuMOpjZ35S+XedV8k/i4A9Ni3h30bEp15nbDEmjLwdemc
	5v4TlA2WWmzEvrAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=blJeR6zP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qpNCGuKE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785764843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSNnRly/YWDGSDrXnEgj2BAyD2DKLkCom8eRM49EllU=;
	b=blJeR6zPdV3dTkFx1kAgIgLllAg1ZIUUzOna5XK64ZAiL4/7FriiI3zbfYOqJL81g82G+G
	blrdENdVmmdauIACNMgIdmFsHa1pn/9A6gU+CtZWfFJHSolYJerz/9tNvvhFT8nFCYY3sa
	y7xddUBtmlsbZeVk144G2ndnTjzQzpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785764843;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JSNnRly/YWDGSDrXnEgj2BAyD2DKLkCom8eRM49EllU=;
	b=qpNCGuKEZJBU+acHu/yMlXzGPCIXXWZFIV2w6ZB+fgd54uOmo0b4NXLbN2InvqngBPXEM9
	jdf3moZvgglelCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22936779C1;
	Mon,  3 Aug 2026 13:47:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W1BpCOubcGqJGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 13:47:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C14DAA13A4; Mon, 03 Aug 2026 15:47:18 +0200 (CEST)
Date: Mon, 3 Aug 2026 15:47:18 +0200
From: Jan Kara <jack@suse.cz>
To: shuo chen <1289151713@qq.com>
Cc: tytso@mit.edu, jack@suse.com, linux-ext4@vger.kernel.org
Subject: Re: [RESEND PATCH] jbd2:remove unnecessary finish_wait call in
 jbd2_journal_wait_updates
Message-ID: <xwlk2l2v7qbfdnuzjrqm3utqd55uzfgqttzetqfl4ffjmnbrdp@unafpyi34kf4>
References: <tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com>
X-Spam-Score: -4.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2AC2D3E2A
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[qq.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[qq.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,qq.com:email,suse.cz:dkim,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Mon 03-08-26 20:35:39, shuo chen wrote:
> merge transaction and atomic_read(&transaction->t_updates) check.
> remove redundant finish_wait call.
> 
> Signed-off-by: shuo chen <1289151713@qq.com>

The changelog should mention what is the motivation of the patch. Simple
cleanup?

> ---
>  fs/jbd2/transaction.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 5cc7d097b2ac..0f193d02a054 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -831,15 +831,12 @@ void jbd2_journal_wait_updates(journal_t *journal)
>  		 */
>  		transaction_t *transaction = journal->j_running_transaction;
>  
> -		if (!transaction)
> +		if (!transaction || !atomic_read(&transaction->t_updates))
>  			break;
>  
>  		prepare_to_wait(&journal->j_wait_updates, &wait,
>  				TASK_UNINTERRUPTIBLE);
> -		if (!atomic_read(&transaction->t_updates)) {
> -			finish_wait(&journal->j_wait_updates, &wait);
> -			break;
> -		}
> +

This introduces a race with stop_this_handle() possibly causing a lost
wakeup (I can see Sashiko noticed as well).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
