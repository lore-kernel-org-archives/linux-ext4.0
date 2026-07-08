Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D732ED3A
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 15:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783524961; cv=none; b=I86oUB3owM49+ILJTMmthHWSbL/Du+KwvfjMwRrGi4qBwjlhCk+DAChbO9qkS+c5f+9MDc3BkTgkST7zDjh3It448dMhIVXB2NjGQ7o+0I7P6O8V+0EeDb1z4EvkYx4paIniqsstSKP9xm+7QxNOo99sqGuhzl/MN0vhoAx1DZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783524961; c=relaxed/simple;
	bh=F4o3Q+oxrkD8nJHhgpPehokzu8kRYy2jTvH9ghISvUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f8cXaIWlWGFYqgYXaFBLJw1xIAhWW8Zj7TpW1Zn7EyJSNPFlUfZD2cc2+taDef1RSY6jSxbrEfw6l/xlHCn08YZ1yBBIP9gjzfqvRoh8LXDm5jsdegcKqbS6Mhe9V4HOGdPEp8sqduxMWcyJZJefVB2HROt/USy1Z+g1vA7Xm2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j0nO5I/Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ECHABPJ+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=j0nO5I/Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ECHABPJ+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j0nO5I/Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ECHABPJ+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="j0nO5I/Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ECHABPJ+"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6BB7275EA6;
	Wed,  8 Jul 2026 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/8BDZ6LGRuZucYyhvMpqDQYWnG5v/FH181Zmf6pJk=;
	b=j0nO5I/YFB4ZVedZG/MLBmRJYok4sAZD1sazV8AmGRqIlWqgph7O31tw6OzPw4tvGmVw2e
	4Fnja96aXVJaKkzVmgQlY4SE4gLuxvzwDsrOrWzICTiKM0UFVUZrczpaQUDLUknnZdAt9m
	LGLsNNRup+Hfs9keolT5Sp4Ge2k8IWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524958;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/8BDZ6LGRuZucYyhvMpqDQYWnG5v/FH181Zmf6pJk=;
	b=ECHABPJ+owFQvD6K5NC68SjjfF6My23+EoBFgtwbPXdZsk3BKAtEi2AIfi9Tqhx6cHvReq
	nKPWJtSX8jse06BQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/8BDZ6LGRuZucYyhvMpqDQYWnG5v/FH181Zmf6pJk=;
	b=j0nO5I/YFB4ZVedZG/MLBmRJYok4sAZD1sazV8AmGRqIlWqgph7O31tw6OzPw4tvGmVw2e
	4Fnja96aXVJaKkzVmgQlY4SE4gLuxvzwDsrOrWzICTiKM0UFVUZrczpaQUDLUknnZdAt9m
	LGLsNNRup+Hfs9keolT5Sp4Ge2k8IWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524958;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pw/8BDZ6LGRuZucYyhvMpqDQYWnG5v/FH181Zmf6pJk=;
	b=ECHABPJ+owFQvD6K5NC68SjjfF6My23+EoBFgtwbPXdZsk3BKAtEi2AIfi9Tqhx6cHvReq
	nKPWJtSX8jse06BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DE3C779AE;
	Wed,  8 Jul 2026 15:35:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4vUCE15uTmozQwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Jul 2026 15:35:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C8252A12D6; Wed, 08 Jul 2026 17:35:57 +0200 (CEST)
Date: Wed, 8 Jul 2026 17:35:57 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huaweicloud.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 4/6] ext4: zero out whole block for clean edges in
 WRITE_ZEROES
Message-ID: <fxtlzytlgn5gnj5mtvo3x3e4g4eri7yhpaawketmsmhrhehj4e@pwqhyod4kezm>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-5-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707021338.1182268-5-yi.zhang@huawei.com>
X-Spam-Flag: NO
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huaweicloud.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,huawei.com:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Tue 07-07-26 10:13:36, Zhang Yi wrote:
> FALLOC_FL_WRITE_ZEROES requires that all blocks in the requested range
> end up as written extents with zeroed content. For unaligned edges that
> were already allocated, ext4_zero_partial_blocks() zeros them directly.
> However, for unaligned edges whose underlying extent is a clean
> unwritten extent or a hole, the extent type remains unwritten after
> partial zeroing, which does not align with the semantics of
> WRITE_ZEROES.
> 
> Therefore, when ext4_zero_partial_blocks() skips partial zeroing, it
> indicates that the corresponding edges are clean unwritten extents or
> holes. In this case, we need to expand the aligned allocation range
> outward to cover such edges, so that ext4_alloc_file_blocks() can
> correctly allocate blocks for the unaligned range. Edges that were
> partial-zeroed (i.e., written or dirty) are left untouched.
> 
> Fixes: f4265b8d32c4 ("ext4: add FALLOC_FL_WRITE_ZEROES support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7a8f9f188a29..c34505765521 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4760,6 +4760,21 @@ static long ext4_zero_range(struct file *file, loff_t offset,
>  	/* Zero range excluding the unaligned edges */
>  	align_start = round_up(offset, blocksize);
>  	align_end = round_down(end, blocksize);
> +
> +	/*
> +	 * In WRITE_ZEROES mode, edges that were not partial-zeroed (clean
> +	 * unwritten or hole) must be allocated and zeroed as whole blocks.
> +	 * Expand the aligned range outward to cover them.
> +	 */
> +	if (mode & FALLOC_FL_WRITE_ZEROES) {
> +		if (!IS_ALIGNED(offset, blocksize) &&
> +		    !(partial_zeroed & EXT4_PARTIAL_ZERO_START))
> +			align_start = round_down(offset, blocksize);
> +		if (!IS_ALIGNED(end, blocksize) &&
> +		    !(partial_zeroed & EXT4_PARTIAL_ZERO_END))
> +			align_end = round_up(end, blocksize);
> +	}
> +
>  	if (align_end > align_start) {
>  		if (mode & FALLOC_FL_WRITE_ZEROES)
>  			flags = EXT4_GET_BLOCKS_CREATE_ZERO | EXT4_EX_NOCACHE;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
