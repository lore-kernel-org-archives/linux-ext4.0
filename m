Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE468287E
	for <linux-ext4@vger.kernel.org>; Thu,  9 Jul 2026 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603663; cv=none; b=Zjuofuc+AzabDGIGgJEY4bZH6eRyOjsWTHzJZFR1u/pNhKZOhpz6A8Q/38/xpQPjIyzGS45M4ZS3O5sNJgjxQP7MogWjZNFXo/dUr86DkGDVB9gLPZhMZKKpBaI87Mre7qA8szZHfNhzBcOBbZRQarLdla0WzrD0h3R2wp82Ky0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603663; c=relaxed/simple;
	bh=DKFonsYgYPxb6MK9N48r0gAGDrEdIZTBOCPF8x7w6C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jhIZNLSW6SG4BoW46Q0FYY6KKSxKJRzPULdM+gzGMUMQIDFYjPdxo1FRuXJetWa+FHqkkORu+p9vEudjV8EIAh60B0ct1rhNmTGgXZvZPiNOCtTOsfkrkx8JciYqTZUxUBXMFlutdX+Z2KQ3b4PNYrrHKDjrbJ1a4x4Pt9jgIkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lnm3K0cX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DlkRbhpe; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Lnm3K0cX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DlkRbhpe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lnm3K0cX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DlkRbhpe";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Lnm3K0cX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DlkRbhpe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8E9F76207;
	Thu,  9 Jul 2026 13:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fgnpQTzRPH+RCtDTq8zueGym00taeTeZAvcCvY1dE38=;
	b=Lnm3K0cX0NdJ8Nf4C1Hg0kBl+D7lGtQzDX+BC9k4HdLRINp7Zq8P75kagMSNPaJtwXO2v8
	d6mgV40h7yAzk2VMAN8XrPcy0LRSlTc0OAXNtG3QDcRjc8bxoGIhLepUcxp0p0FEWqgjrD
	JgxG64y7WPkN4v3b1ankICo1ULA8I0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603660;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fgnpQTzRPH+RCtDTq8zueGym00taeTeZAvcCvY1dE38=;
	b=DlkRbhpe8vUUjATTuoQxdRFuX/xhCnzxfzIedt3LsBiaAfqFcUWzcxwqcGPESUDw49ujY2
	e48dmAbs0M2J/oBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lnm3K0cX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DlkRbhpe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783603660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fgnpQTzRPH+RCtDTq8zueGym00taeTeZAvcCvY1dE38=;
	b=Lnm3K0cX0NdJ8Nf4C1Hg0kBl+D7lGtQzDX+BC9k4HdLRINp7Zq8P75kagMSNPaJtwXO2v8
	d6mgV40h7yAzk2VMAN8XrPcy0LRSlTc0OAXNtG3QDcRjc8bxoGIhLepUcxp0p0FEWqgjrD
	JgxG64y7WPkN4v3b1ankICo1ULA8I0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783603660;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fgnpQTzRPH+RCtDTq8zueGym00taeTeZAvcCvY1dE38=;
	b=DlkRbhpe8vUUjATTuoQxdRFuX/xhCnzxfzIedt3LsBiaAfqFcUWzcxwqcGPESUDw49ujY2
	e48dmAbs0M2J/oBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F2CF779AA;
	Thu,  9 Jul 2026 13:27:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iXnbJsyhT2o0MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 13:27:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63775A12D7; Thu, 09 Jul 2026 15:27:40 +0200 (CEST)
Date: Thu, 9 Jul 2026 15:27:40 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v3 7/9] ext4: zero out whole block for clean edges in
 WRITE_ZEROES
Message-ID: <x7nsvr2tdcnmzmkfatfirnagzmafjux77j23cw5qev2mr7asfj@tz32qgnxrme6>
References: <20260708062049.1982410-1-yi.zhang@huaweicloud.com>
 <20260708062049.1982410-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708062049.1982410-8-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A8E9F76207
X-Spam-Flag: NO
X-Spam-Score: -2.51
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
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Wed 08-07-26 14:20:47, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
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
