Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624398;
	b=vJn9Ke73oL8RTSRW6kBxsJIkoHIhm24QxQZJvDeWEuvrN9kOb9iYPfSJVhxvYgcgEigE
	 EZQVF//vP0Wt8SGb/yiE4Xd5wJUxAyNj4k3pO6eTmhG4CuQOudaMpCi7pKcPLOUamoFi8
	 bfEdd1RvAS2mHHlWO4dDqzmCPNErPebqpyG2DdKXMz4VLyDsH12ZTYptQ0D+9GSDXI9bk
	 m2UTN3cuEbMnv3gGO9pXAE1NeLTKtDsogqZErdmt46h2i9vzd2ArbDzXdpE0dK2ohekty
	 rfY2Va38HGPEpAEbDFi65jgA2ISVkz5mR/8vpBHSuYShjiSrHcnHFc7FLOE6CYOj0sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624398;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=Wa6GN5MOZD0GOxzvdoaWArGmztPy/9GLTahR7MX0tUA=;
	b=cgfrhy0WZzxPQkrJ+1KZQ7VboOYw8YkFLfg8O+O9llgVtz5sZnTNBX61s5J821Cqn3pc
	 7MAbkImOaRh8Ifz8oC2nOVmlU0/TGq2okKeAuU9K57dSgAJt611MKuiOr3cHPWGGMr69H
	 2PukcLkmwcNkFJw5+7La+Q3sHx+G1+DUO/52rb+QdULemEP+2mihQ1jU0qKv8YNOyTeyG
	 0Z5kX3qvpnoQ8Kj/or+6stdrO5AV/nLeMoCcs2BCl41JvhmhOqtghKreVd8ciafkAG19J
	 J+nHLzuyu5GiFc0ggn54zjFL/0BHescq1qoFJzq92kuP2NgL8edUArI7aof+b5I0jsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pVOzwSg3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bcL3PnnX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oK6Uxzx6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="nb3h/s6w";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10C606A69F
	for <linux-ext4@vger.kernel.org>; Wed, 25 Nov 2026 16:33:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE10C606A69F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pVOzwSg3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=bcL3PnnX;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oK6Uxzx6;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nb3h/s6w
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E5DA61FAC3;
	Wed, 25 Nov 2026 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795624396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wa6GN5MOZD0GOxzvdoaWArGmztPy/9GLTahR7MX0tUA=;
	b=pVOzwSg3LttIVR3aTQb3HEwD1YPGZcLDLt24JcPzs8bPT7pcpENoogZYNuRmteXRSy1SuA
	rueJbQ4KgFnWsC9wli8VmwFzWCqpXZfqJnMNepv6dq63UtldIXt+KzaBN5uhKn+172MzsV
	UrxQT+BEpkOgVn2gmKrMo+ITPw6upls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795624396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wa6GN5MOZD0GOxzvdoaWArGmztPy/9GLTahR7MX0tUA=;
	b=bcL3PnnXKg/A8R00L2gBkWt2B3EYx10FfKk2juRuNNVhnOoD08GSMMkBnG2/AyutSXEz9/
	dXj+1vM7Vl/kWNCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oK6Uxzx6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="nb3h/s6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795624394; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wa6GN5MOZD0GOxzvdoaWArGmztPy/9GLTahR7MX0tUA=;
	b=oK6Uxzx6nWGnXMurqSfiBaD2Z2PzexdiuPQ+2pt8ww4KBzvwUpeRPK58E1uoZl5VYfuyEG
	G5jh5XGc4Pbh6/eWOOWWBy0SGxkBm5iOk9ZJgkXMWyQl9qaG3ZXRlRGq8JjE6alqFrU6qc
	E655zI3aO2vcePjRyvrcCEGQk75lxO0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795624394;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Wa6GN5MOZD0GOxzvdoaWArGmztPy/9GLTahR7MX0tUA=;
	b=nb3h/s6ws8rcedgiPl4OztNWs++f0ZZ+uMcM1Fcy8fw6TBXIyPKILuWQQF8uh7p1D7Awb0
	iEAt9j3Gj5bOvWBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B971D134CA;
	Wed, 25 Nov 2026 16:33:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ImKeJMoNB2uKaAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 16:33:14 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 4859827CC4; Wed, 25 Nov 2026 17:33:06 +0100 (CET)
Date: Wed, 25 Nov 2026 17:33:06 +0100
From: Jan Kara <jack@suse.cz>
To: Ye Bin <yebin@huaweicloud.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	jack@suse.cz
Subject: Re: [PATCH v2 2/2] ext4: protect ext4_acquire_dquot against freezing
Message-ID: <qvymh23mrblxtse4pkuuo2pov6najpuhysxcc2v244t2ljmd6c@eakqpouixagr>
References: <20261125111055.3672233-1-yebin@huaweicloud.com>
 <20261125111055.3672233-3-yebin@huaweicloud.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125111055.3672233-3-yebin@huaweicloud.com>
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.cz:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: E5DA61FAC3

On Wed 25-11-26 19:10:55, Ye Bin wrote:
> From: Ye Bin <yebin10@huawei.com>
> 
> A writable open of a regular file reaches the filesystem's ->open()
> callback without holding any superblock write (freeze) protection, but
> ext4_file_open() -> dquot_file_open() -> dquot_initialize() may need to
> acquire a dquot and write the quota file.  If the filesystem reaches
> SB_FREEZE_COMPLETE in that window, ext4_journal_check_start() hits
> 
> 	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
> 
> and the open then sleeps in jbd2 until the filesystem is thawed.
> 
> Taking freeze protection for every writable open in the VFS would make a
> plain open(O_WRONLY) on a frozen filesystem block even when it never
> writes, which is an unacceptable behaviour change.  Instead protect the
> quota acquisition path itself: take sb_start_intwrite() around
> ext4_acquire_dquot() when no transaction is already running.  Running
> transactions are already protected against freezing and taking
> sb_start_intwrite() inside one can deadlock.
> 
> This protection relies on the preceding quota change ("quota: Forbid
> Q_XGETQUOTA and Q_XGETNEXTQUOTA for frozen filesystem").  Those commands
> are treated as read-only and run with s_umount held for reading, but they
> can still reach ext4_acquire_dquot().  Taking sb_start_intwrite() there
> would deadlock against thaw_super(), which can only release the
> SB_FREEZE_FS protection after taking s_umount exclusively.  The preceding
> change forbids those commands on a frozen filesystem, which makes the new
> protection safe, so both patches have to be applied together.
> 
> Fixes: 907f4554e252 ("dquot: move dquot initialization responsibility into the filesystem")
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Ye Bin <yebin10@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d0415e5948e1..fc63219f5972 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -7110,11 +7110,25 @@ static int ext4_acquire_dquot(struct dquot *dquot)
>  {
>  	int ret, err;
>  	handle_t *handle;
> +	bool freeze_protected = false;
> +
> +	/*
> +	 * Trying to sb_start_intwrite() in a running transaction
> +	 * can result in a deadlock. Further, running transactions
> +	 * are already protected from freezing.
> +	 */
> +	if (!ext4_journal_current_handle()) {
> +		sb_start_intwrite(dquot->dq_sb);
> +		freeze_protected = true;
> +	}
>  
>  	handle = ext4_journal_start(dquot_to_inode(dquot), EXT4_HT_QUOTA,
>  				    EXT4_QUOTA_INIT_BLOCKS(dquot->dq_sb));
> -	if (IS_ERR(handle))
> +	if (IS_ERR(handle)) {
> +		if (freeze_protected)
> +			sb_end_intwrite(dquot->dq_sb);
>  		return PTR_ERR(handle);
> +	}
>  	ret = dquot_acquire(dquot);
>  	if (ret < 0)
>  		ext4_error_err(dquot->dq_sb, -ret,
> @@ -7123,6 +7137,10 @@ static int ext4_acquire_dquot(struct dquot *dquot)
>  	err = ext4_journal_stop(handle);
>  	if (!ret)
>  		ret = err;
> +
> +	if (freeze_protected)
> +		sb_end_intwrite(dquot->dq_sb);
> +
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
