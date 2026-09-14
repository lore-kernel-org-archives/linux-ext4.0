Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9D47604A;
	Mon, 14 Sep 2026 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789395360; cv=none; b=dNVVGrxYowvrIYjHqDdxedTsGr4X/jHg8qS/MpcX1Ee0sMMYN9BxFNSnet4YgcxM//cHtlJhpPhLsAFDkxed3JjO63CxtlWVvn6Me4yvYUsHpcwFWiqe9OxdyU719llAR+hkITHA2BDehc+BuT4cs1sf/2H5bJsN26wz2xKxDbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789395360; c=relaxed/simple;
	bh=G3mN0MIgkEuobFEYl1ojHbKXzMpy/wUa0FRxlmMqsbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hgABJPFJ4QcrwbJiyph14kzpt7W0bXGfw43Bqdt3inNlmabVPLxVuZcDDFUQ5G8uCVukE39r30gQmdhia+J6MUbaSBga8aBKi7ali2i/jeUPeJSPzrmT3DacrFGkYHgA0LYaZD7JoKyGu27NDuRK0UsYJTV/3TyBn4hQpKclLCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eYbZzke+; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zf/0i6gg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=y7EZE6Z4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qbA1E4Bi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eYbZzke+";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zf/0i6gg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="y7EZE6Z4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qbA1E4Bi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21FB21FF18;
	Mon, 14 Sep 2026 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789395352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aL7b41d2SbRIzogGjk8gjAwCfjWPXLk9ALP214Lpya4=;
	b=eYbZzke+UXHijeWJpgSCokh1jJo3U4C3XwpsEJLtcMlouHZPeZXwB7p/9ET9V+4Aqxzvmk
	DCLzNbmwWK2jamht1s6RxmHtFxOhFxTTcdbNmp5jgMrya5Wx2UxWhanu15oXHslaPoAFh0
	2f/Gff7SeI7encXrx5mVIBl2Q2QsO/g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789395352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aL7b41d2SbRIzogGjk8gjAwCfjWPXLk9ALP214Lpya4=;
	b=zf/0i6ggU5Gm6oAfhuYjIJAxxoN75EF/Wr/k40sTZ5tr+lV1XwmtzdHNQhaX9P0c1YvLiW
	Z0ToR1f0FZmKh+CA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y7EZE6Z4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qbA1E4Bi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789395348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aL7b41d2SbRIzogGjk8gjAwCfjWPXLk9ALP214Lpya4=;
	b=y7EZE6Z40tVJhmzf6TjZTRee4XcXhg041MmNKMurNuCnFixzmbcGcKSgeIoCjKE6RNBzoa
	3oDge5guZWFT9VMfmX6H6VkHwSltXQWVTLAJwKDEQpZb0hFYCTICU359A+j4A4TGvzdWJ+
	altbhiSIbWccE6BZgofJaM66TwH8Jv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789395348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aL7b41d2SbRIzogGjk8gjAwCfjWPXLk9ALP214Lpya4=;
	b=qbA1E4Bi4iUQd+KepbL8ngJuFSGFGknJ7mnbiJ5og6UF3Av4rafS6HC8rA4kDD/A7VTvKZ
	fJtO795nXsfiCZCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DD72D13515;
	Mon, 14 Sep 2026 14:15:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JQELNpMBqGoqFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 14:15:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5421CA12E4; Mon, 14 Sep 2026 16:15:43 +0200 (CEST)
Date: Mon, 14 Sep 2026 16:15:43 +0200
From: Jan Kara <jack@suse.cz>
To: lty <781735889@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: propagate errors from fast commit i_blocks
 replay
Message-ID: <zdnu5bltaau3tvhcselgribzavvg7hsz72hd7ncyffwna2q6a2@noz6zvtibxsx>
References: <tencent_BCDA824359279D18963B838B15B01BC1CD06@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_BCDA824359279D18963B838B15B01BC1CD06@qq.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 21FB21FF18
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
	FREEMAIL_TO(0.00)[qq.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Mon 14-09-26 20:05:56, lty wrote:
> ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
> ext4_map_blocks() fails, but then continues with a partial block count
> and unconditionally returns success. The fast commit replay caller also
> ignores the helper return value.
> 
> Stop the count immediately on mapping errors, leave i_blocks unchanged,
> and propagate the failure to abort inode replay.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> 
> Signed-off-by: lty <781735889@qq.com>
> 
> Changes in v2:
> - Propagate errors from all ext4_find_extent() and skip_hole() calls in
>   ext4_ext_replay_set_iblocks(), as requested by Jan Kara.
> - Keep i_blocks unchanged when any replay lookup fails.

The 'Changes' paragraph belongs after the --- separator below so that it
doesn't get into the pernament changelog. Otherwise the fix looks good to
me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> fs/ext4/extents.c     | 26 ++++++++++++++++----------
>  fs/ext4/fast_commit.c |  7 +++++--
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c3655..f8c805d80c33 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -6275,7 +6275,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
>  		map.m_len = end - cur;
>  		ret = ext4_map_blocks(NULL, inode, &map, 0);
>  		if (ret < 0)
> -			break;
> +			goto cleanup;
>  		if (ret > 0)
>  			numblks += ret;
>  		cur = cur + map.m_len;
> @@ -6291,15 +6291,19 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
>  	cur = 0;
>  	ret = skip_hole(inode, &cur);
>  	if (ret < 0)
> -		goto out;
> +		goto cleanup;
>  	path = ext4_find_extent(inode, cur, path, 0);
> -	if (IS_ERR(path))
> -		goto out;
> +	if (IS_ERR(path)) {
> +		ret = PTR_ERR(path);
> +		goto cleanup;
> +	}
>  	numblks += path->p_depth;
>  	while (cur < end) {
>  		path = ext4_find_extent(inode, cur, path, 0);
> -		if (IS_ERR(path))
> -			break;
> +		if (IS_ERR(path)) {
> +			ret = PTR_ERR(path);
> +			goto cleanup;
> +		}
>  		ex = path[path->p_depth].p_ext;
>  		if (!ex)
>  			goto cleanup;
> @@ -6308,11 +6312,13 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
>  					ext4_ext_get_actual_len(ex));
>  		ret = skip_hole(inode, &cur);
>  		if (ret < 0)
> -			break;
> +			goto cleanup;
>  
>  		path2 = ext4_find_extent(inode, cur, path2, 0);
> -		if (IS_ERR(path2))
> -			break;
> +		if (IS_ERR(path2)) {
> +			ret = PTR_ERR(path2);
> +			goto cleanup;
> +		}
>  
>  		for (i = 0; i <= max(path->p_depth, path2->p_depth); i++) {
>  			cmp1 = cmp2 = 0;
> @@ -6333,7 +6339,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
>  cleanup:
>  	ext4_free_ext_path(path);
>  	ext4_free_ext_path(path2);
> -	return 0;
> +	return ret;
>  }
>  
>  int ext4_ext_clear_bb(struct inode *inode)
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 0cac890cf370..8110b01e36c1 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -2002,8 +2002,11 @@ static int ext4_fc_replay_inode(struct super_block *sb,
>  	 * crashing. This should be fixed but until then, we calculate
>  	 * the number of blocks the inode.
>  	 */
> -	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
> -		ext4_ext_replay_set_iblocks(inode);
> +	if (!ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA)) {
> +		ret = ext4_ext_replay_set_iblocks(inode);
> +		if (ret)
> +			goto out_brelse;
> +	}
>  
>  	inode->i_generation = le32_to_cpu(ext4_raw_inode(&iloc)->i_generation);
>  	ext4_reset_inode_seed(inode);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
