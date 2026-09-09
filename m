Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141D9524AE1;
	Wed,  9 Sep 2026 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950176; cv=none; b=HZsLLlg4Okuebo6HLAanQt9XPAWKscdVwYSdbXJ4ut4qM8uahXL4H6M1xYWb+HB73N3K6qalEZhf/nqDAHIsWvDCGbeYMEYl25agk1O5U5AcQdwARp8a7jh7iLM89X3Sr+FwIo0DdGCBB2BLuWV4hQPCsABZo9MIjx/O1j0I9pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950176; c=relaxed/simple;
	bh=x9pOYZ0vKo2MpFelsmdlUR2kFnekB8PYQbmsYoxWKyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2nkSrhGtrR3+j9qm1X3Bwak+wr5+sb3hRENoCQiFOTbVnJ/60fQilIekeVKjkBQJEKwLRwP3S6kaoQmZjftk4kJ3fB94Efz2U8TRMmJUDtu2ece06aYIXrcb4UTMifDhRfDhhXzTFs7lrmltcKq5WbDk1zijab1gGnctQcCPLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HqshYvWJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OCsRiawC; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=mFP8Jelx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=59YfVs7O; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HqshYvWJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OCsRiawC";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="mFP8Jelx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="59YfVs7O"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B6EDB1F8D7;
	Wed,  9 Sep 2026 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/eyjMQaLWAxutoKPRS2I3w4clVV8bN82eoD8zPprVT0=;
	b=HqshYvWJz2PUbZ82jVlmEi0cdjjhxvQSIHMrmWnEsBctby9TaktF+qO1Es9WY88+MIDXo1
	YGWavtIq5JgvdoyAPtIiwDaRNYJNCgsSV7pGB7sVn/kRu1ZvJ/PjR0ajEw57O54gWIepIu
	n0ldXu8s6PgGEJ3C6Hj63d4W4To6y/U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/eyjMQaLWAxutoKPRS2I3w4clVV8bN82eoD8zPprVT0=;
	b=OCsRiawC9v7mpI+VrlcyOjblMQAXsc9uVC1nxUYb4RU+eChBIhVYfX/uvKCbeDUNZfXg+t
	hpqo1EQARFUh2KAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788950164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/eyjMQaLWAxutoKPRS2I3w4clVV8bN82eoD8zPprVT0=;
	b=mFP8Jelx8LNE+nq7F0WGclTlLoxMqJSH5UUh9hVyUrWXpPNpqnNxSM6rnc0fX2RHjhUtpE
	MPQ/hQaSeLP2S3FK+pzjrmI3AihnHnD7qWD93pehikGGjT//IO6eMbWMqzFCgtPiuuYA1V
	cy17zHbWKhQ+CIO2bYaZrC8kbpyRLq0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788950164;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/eyjMQaLWAxutoKPRS2I3w4clVV8bN82eoD8zPprVT0=;
	b=59YfVs7OBgX7/WJ6CaH8mhTDHrBhpsHLCj4X3bfE0yb/tlxuzM9JmE5FV0qo3AVZBhvj20
	CZw88HkNVyz8C3Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D83C1352C;
	Wed,  9 Sep 2026 10:36:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zy2FGpQ2oWq/NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 09 Sep 2026 10:36:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E7548A1341; Wed, 09 Sep 2026 12:36:03 +0200 (CEST)
Date: Wed, 9 Sep 2026 12:36:03 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: clear journal restart indication after inserting
 extent
Message-ID: <h2uy2kyfran4gtn3aigxj6t7ch22ikpud3srsftmqx3tu5t2sz@f32g24qckbch>
References: <20260909033542.3087876-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909033542.3087876-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[uniontech.com:email,suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Wed 09-09-26 11:35:42, Yichong Chen wrote:
> ext4_datasem_ensure_credits() returns 1 when it successfully restarts
> the transaction. finish_range() leaves that value in retval when the
> subsequent ext4_ext_insert_extent() succeeds. Its callers interpret any
> nonzero return as a migration failure, so they stop building the extent
> tree and take the cleanup path instead of completing the migration.
> 
> Before ext4_ext_insert_extent() was changed to return a path, its integer
> return value overwrote the restart indication. Restore that behavior with
> PTR_ERR_OR_ZERO(), preserving insertion errors and returning zero on
> success.
> 
> Fixes: f7d1331f16a8 ("ext4: get rid of ppath in ext4_ext_insert_extent()")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/migrate.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 5d60ef10fe11..d467b5a13c62 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -53,8 +53,7 @@ static int finish_range(handle_t *handle, struct inode *inode,
>  	if (retval < 0)
>  		goto err_out;
>  	path = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
> -	if (IS_ERR(path))
> -		retval = PTR_ERR(path);
> +	retval = PTR_ERR_OR_ZERO(path);
>  err_out:
>  	up_write((&EXT4_I(inode)->i_data_sem));
>  	ext4_free_ext_path(path);
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
