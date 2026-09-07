Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76372443A88;
	Mon,  7 Sep 2026 09:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788773898; cv=none; b=mYhY4jQ01w3Z7rnQpbCFYLoQDWoYIgrF+mTaJbaSabO2eNSgl0Pi5AWMS0UqWl2VHdGPtJlfzf9bP57rYgdStTBci7tC1NRvduf1VBrc0xkjgKNm2HtWZ9dMUbDt7+mz5XD35/1Zo2U04rbEQ1FoS6SoF+S2XU2izZ0jav1o4II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788773898; c=relaxed/simple;
	bh=R63bx+xX3JQRER7Tr6S+LUveJ+/jhjzBMxFrKET2ic8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLMn5vGjVAIa/qwGWM24iuIrlFLUe7xlTJB/CtctK/Ce54gHZM2+pPpkZ94miY1UbYgW1ke5dI+LytotnSXzAJazEdOpVRpikk7nYZsGNSTqbGZW6j+WpvPSH8sT+6tnUmydhLnyoPMdyl3Qei7H/YmgWZWP0fT2JujbH2qXDWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QctX+zfn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SZd4lt7G; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EvDOzSh/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2mAlopWX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QctX+zfn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SZd4lt7G";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EvDOzSh/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2mAlopWX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2ADFD21995;
	Mon,  7 Sep 2026 09:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788773890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4/DFt/OCkn092Igrm1vEHphTYTYdwHd/pskOHMDcIzs=;
	b=QctX+zfnfwc1cvlEst1Liy1KEFrjRhKOviSrMPgOdwrPyT1FHa/KN8mzEqVch3rExDwthY
	21qn0wW+4Em4q/zxXmG6oht/q+gqHC+AKZ6rj3tQ0MVux1nr4WylEZVzeSXX/P8HMw7Rsi
	+Tgri3SmM+esO6uE9mJf+sJUtQJLvE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788773890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4/DFt/OCkn092Igrm1vEHphTYTYdwHd/pskOHMDcIzs=;
	b=SZd4lt7GmgBKtMrPO1vrZVboJvjTRF7yrOzmj0Qewrhm8M5tD/LC16yFvHaEG34fotq168
	DjvWMAo8YR3DvfBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788773886; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4/DFt/OCkn092Igrm1vEHphTYTYdwHd/pskOHMDcIzs=;
	b=EvDOzSh/evda62Fyd7DOiW2dNUCqB5QlZCzaCinMidPoAaoesQNkxF8l04+oBP67Aepc5N
	SIp1dZsDKZ8v9W/9hGXzpHgWQKkchln3ZMapLzxfUZkQBqUZsPVrK3koVYvxLds5/sRcOm
	b8CLgxatJJDXPIsyU4NaAHv6+ab/65Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788773886;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4/DFt/OCkn092Igrm1vEHphTYTYdwHd/pskOHMDcIzs=;
	b=2mAlopWX4j2VNpybySaIeqmB3W7dklBM99oASDppmO8zS0LxbZC5L3mW+FFdNX6XTSBdfo
	dRF6QPcvjdIfOaCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE8D11368D;
	Mon,  7 Sep 2026 09:38:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2u9NNv2FnmqNBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 07 Sep 2026 09:38:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 82F7BA13B2; Mon, 07 Sep 2026 11:38:01 +0200 (CEST)
Date: Mon, 7 Sep 2026 11:38:01 +0200
From: Jan Kara <jack@suse.cz>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix typos in comments
Message-ID: <hrcn4wvmkirl2fgngtekmdbwessx4xllhx4iy6rt4pn2oqdonk@636ap54eluhh>
References: <20260907064046.36515-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907064046.36515-1-hemanth.selam@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO

On Mon 07-09-26 12:10:46, Hemanth Selam wrote:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 2 +-
>  fs/ext4/inode.c   | 2 +-
>  fs/ext4/mballoc.c | 8 ++++----
>  fs/ext4/mballoc.h | 4 ++--
>  4 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c3655..d5d7ee229e4a 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3186,7 +3186,7 @@ int ext4_ext_zeroout(struct inode *inode, struct ext4_extent *ex)
>   * @handle: the journal handle
>   * @inode: the file inode
>   * @path: the path to the extent
> - * @split: the logical block where the extent is splitted.
> + * @split: the logical block where the extent is split.
>   * @flags: flags used to insert new extent to extent tree.
>   *
>   *
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bd4b778df9eb..e719fa3cbaaf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2163,7 +2163,7 @@ static bool mpage_add_bh_to_extent(struct mpage_da_data *mpd, ext4_lblk_t lblk,
>   * @bh - buffer we should start processing from
>   * @lblk - logical number of the block in the file corresponding to @bh
>   *
> - * Walk through page buffers from @bh upto @head (exclusive) and either submit
> + * Walk through page buffers from @bh up to @head (exclusive) and either submit
>   * the page for IO if all buffers in this page were mapped and there's no
>   * accumulated extent of buffers to map or add buffers in the page to the
>   * extent of buffers to map. The function returns 1 if the caller can continue
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 06171a11db12..47156ce9e5c0 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -234,7 +234,7 @@
>   *
>   * there are two types of preallocations:
>   *  - inode
> - *    assiged to specific inode and can be used for this inode only.
> + *    assigned to specific inode and can be used for this inode only.
>   *    it describes part of inode's space preallocated to specific
>   *    physical blocks. any block from that preallocated can be used
>   *    independent. the descriptor just tracks number of blocks left
> @@ -2326,11 +2326,11 @@ static void ext4_mb_check_limits(struct ext4_allocation_context *ac,
>   *   stop the scan and use it immediately
>   *
>   * * If free extent found is smaller than goal, then keep retrying
> - *   upto a max of sbi->s_mb_max_to_scan times (default 200). After
> + *   up to a max of sbi->s_mb_max_to_scan times (default 200). After
>   *   that stop scanning and use whatever we have.
>   *
>   * * If free extent found is bigger than goal, then keep retrying
> - *   upto a max of sbi->s_mb_min_to_scan times (default 10) before
> + *   up to a max of sbi->s_mb_min_to_scan times (default 10) before
>   *   stopping the scan and using the extent.
>   *
>   *
> @@ -3029,7 +3029,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
>  	 * is greater than equal to the sbi_s_mb_order2_reqs
>  	 * You can tune it via /sys/fs/ext4/<partition>/mb_order2_req
>  	 * We also support searching for power-of-two requests only for
> -	 * requests upto maximum buddy size we have constructed.
> +	 * requests up to maximum buddy size we have constructed.
>  	 */
>  	if (i >= sbi->s_mb_order2_reqs && i <= MB_NUM_ORDERS(sb)) {
>  		if (is_power_of_2(ac->ac_g_ex.fe_len))
> diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
> index 39333ce72cbd..571d9bd93810 100644
> --- a/fs/ext4/mballoc.h
> +++ b/fs/ext4/mballoc.h
> @@ -86,9 +86,9 @@
>  #define MB_DEFAULT_LINEAR_SCAN_THRESHOLD	16
>  
>  /*
> - * The maximum order upto which CR_BEST_AVAIL_LEN can trim a particular
> + * The maximum order up to which CR_BEST_AVAIL_LEN can trim a particular
>   * allocation request. Example, if we have an order 7 request and max trim order
> - * of 3, we can trim this request upto order 4.
> + * of 3, we can trim this request up to order 4.
>   */
>  #define MB_DEFAULT_BEST_AVAIL_TRIM_ORDER	3
>  
> -- 
> 2.48.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
