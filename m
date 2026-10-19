Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB564AD7FA;
	Mon, 19 Oct 2026 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792403902; cv=none; b=Ub8DBeiVqtF1Lh0dt5Q+k7F4j3DAjX27XqDrsqiy6TbOiuRT1rCeJQmbtgBjbZNIC4oQDv9XbmJinOV0oieTxvhxu1BC3eVorFv/JEiJEgY0lQC07SihyrgkeiLhuhq2OPnQ7HJXbyP7cTFubdf5NMuCNZ8qpOW3kSdylonR26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792403902; c=relaxed/simple;
	bh=ZMWYvtNBqX3sK4rMewAJOYsR6Edetbdl7u7iNcPOyoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpRJaDeve3kaWaiChKyy64G0QzfvCrhwAVC8QIA2VCnDFQgCCHJDxHoBjv68oo5d7P8+8RAgnTzPNU25N63fX4MwJaXIjkELxztHr7he54tCOYYBBJ/OYlWL25HHOqmybzWQFbl9K5ChtsF76vydiWwsJh2pkLQVWsQ54gGy2HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MfgXCsHQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=glrSYx/F; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MfgXCsHQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=glrSYx/F; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MfgXCsHQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="glrSYx/F";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MfgXCsHQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="glrSYx/F"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F395F21BBF;
	Mon, 19 Oct 2026 09:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yt5dSW0F7NM0MAAicExNOVH+ycgQuyjXq4u5nVYNKE=;
	b=MfgXCsHQnDY5AvZn/ibiPn3cyADOxR4QCIfp7d0+2/bKOJMKHBv0vV5hOrczLUIeuzlokr
	fzb+HVpmRr14w2/0pzNScto0MBHX+4l5c5dyDc1rL36gircsPxFWwujDJX6ATTBQwPaAT+
	5/A5MrIQ3KPxZ0OU6KfOBH3ysPWMypU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yt5dSW0F7NM0MAAicExNOVH+ycgQuyjXq4u5nVYNKE=;
	b=glrSYx/FLaEm46Gg4hoomrP3DVB8p/lOY7dARts4AuKDGaCs6DfjmWvDQtcW+vuvZGe4rQ
	+mUQqqoNiQOi0CBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792403898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yt5dSW0F7NM0MAAicExNOVH+ycgQuyjXq4u5nVYNKE=;
	b=MfgXCsHQnDY5AvZn/ibiPn3cyADOxR4QCIfp7d0+2/bKOJMKHBv0vV5hOrczLUIeuzlokr
	fzb+HVpmRr14w2/0pzNScto0MBHX+4l5c5dyDc1rL36gircsPxFWwujDJX6ATTBQwPaAT+
	5/A5MrIQ3KPxZ0OU6KfOBH3ysPWMypU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792403898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yt5dSW0F7NM0MAAicExNOVH+ycgQuyjXq4u5nVYNKE=;
	b=glrSYx/FLaEm46Gg4hoomrP3DVB8p/lOY7dARts4AuKDGaCs6DfjmWvDQtcW+vuvZGe4rQ
	+mUQqqoNiQOi0CBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C89761375D;
	Mon, 19 Oct 2026 09:58:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B1M3Krnp1WpoQAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 09:58:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 605BBA1413; Mon, 19 Oct 2026 11:58:17 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:58:17 +0200
From: Jan Kara <jack@suse.cz>
To: guolingxing <guolingxing@tju.edu.cn>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: report unwritten extent conversion failures as
 writeback errors
Message-ID: <sclc7h74z7nwfwnx2r62svytfaxquxws5chnopgryh2lpwqqd2@twxuiugbudw2>
References: <20261015102943.74632-1-guolingxing@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015102943.74632-1-guolingxing@tju.edu.cn>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email,tju.edu.cn:email];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Thu 15-10-26 10:29:43, guolingxing wrote:
> When a data writeback bio completes successfully but the subsequent
> unwritten extent conversion fails, ext4_end_io_end() does not record
> the error in the inode's mapping writeback error state.
> 
> Bio failures are already recorded by ext4_end_bio(), but conversion
> failures are not. When the conversion is processed asynchronously,
> its return value is not propagated to userspace, so fsync() may
> return success despite the failed conversion.
> 
> Record conversion errors with mapping_set_error() before
> ext4_release_io_end() ends folio writeback and wakes waiters. This
> allows fsync() to observe the failure.
> 
> Fixes: b82e384c7bb9 ("ext4: optimize locking for end_io extent conversion")
> Cc: stable@vger.kernel.org
> Signed-off-by: guolingxing <guolingxing@tju.edu.cn>

I don't think the Fixes tag is correct. Even before b82e384c7bb9 we seem to
have been dropping the error on the floor. But otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/page-io.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 0236b6b9785a..2afa4c096156 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -189,6 +189,8 @@ static int ext4_end_io_end(ext4_io_end_t *io_end)
>  			jbd2_journal_abort(EXT4_SB(sb)->s_journal, ret);
>  	} else {
>  		ret = ext4_convert_unwritten_io_end_vec(handle, io_end);
> +		if (ret < 0)
> +			mapping_set_error(inode->i_mapping, ret);
>  	}
>  	if (ret < 0 && !ext4_emergency_state(sb) &&
>  	    io_end->flag & EXT4_IO_END_UNWRITTEN) {
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
