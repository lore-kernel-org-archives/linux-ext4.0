Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3852D7380
	for <linux-ext4@vger.kernel.org>; Tue, 15 Sep 2026 10:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466974; cv=none; b=eNQf5hu2SZ+zZY96dhS5PcGDocfyIJU23xKCbY8bP3MmrgbG3hkBu7t9CR0ykmzlLbCWq3kBiBo2Yy/DKHKndLqhH1N3RmkENT2zwkC0A31gnVwsjffoEtG2MQFlwK240haFfIVcrv9yu6TsWs4KEyd/pdAy2uamav/hHGdJEPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466974; c=relaxed/simple;
	bh=7J6bschseP4539XEB59De6eHwvYgVNpjUzsamcfCOIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RwrgY1VQscKgOSp0NsRqG5mlYEfuzF9yLvVIO0yFJVUjZ0x3ENSAYLXTD81yAqDaul07AteWTvwhQ0HhIe6fOToIBu93EGYdg8OXqpPqVKDdOm2tdm+iwAzQthNPjPcOmAS3MAWmw1s8AShFQ1uCe4ZzqIZioxxqoC8eiyJjUv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FRL9ys+w; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=o8NP6tBb; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=N8D0JZb2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DLkwo3Rp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FRL9ys+w";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="o8NP6tBb";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="N8D0JZb2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DLkwo3Rp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5EEDD1FD9E;
	Tue, 15 Sep 2026 10:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789466965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VnwxDoIUT5cKiz0D6yb0BImEnXVODcc0p8/C2bQlYJ4=;
	b=FRL9ys+wg9XU5+mmi8Xje4EYGydOK13/waoSaCzdwTDco31IAjKewMIHGga4dWMZ+zAsnB
	GHML27cKr34/PXAQhSt864Rx7zYqh3Zg/7uAl+uFGQali+rs4znBGPphqwhhCI6fOUyctF
	wWXM2Mi78+DLt6WUPj9upPhiwVKret8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789466965;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VnwxDoIUT5cKiz0D6yb0BImEnXVODcc0p8/C2bQlYJ4=;
	b=o8NP6tBbSfh76Vq3xkKNEL4edHedQdW0bvW4gMdwOu9leS7cOD19gSOzwD3UfVM2JLpcF1
	uBetmKMSuNcePLAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N8D0JZb2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DLkwo3Rp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789466961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VnwxDoIUT5cKiz0D6yb0BImEnXVODcc0p8/C2bQlYJ4=;
	b=N8D0JZb2uqaScNy4oANqRdep0lHgkWBre2159b45ywRCCkfxxCFxTloqnvzEIAkSuj8bcH
	Eum9LLBpdrw1QoSA13B+AgOjWBOT9nnpq+SZFv4V/+P3FURC4zOhd2a83VY5YcZBB4VJ9g
	KgP815/qOBmlK+q/hFNdJ7I//8NPMDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789466961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VnwxDoIUT5cKiz0D6yb0BImEnXVODcc0p8/C2bQlYJ4=;
	b=DLkwo3RppkMvPmnx4FvxmJjv2sewilmUwspiNdOtVr9jH7so37m7KElh0Ve1m/x75wYK70
	60w0cJ0l+TfH1KDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2978813432;
	Tue, 15 Sep 2026 10:09:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2ilPAVEZqWoDFwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 15 Sep 2026 10:09:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1F7FA13D6; Tue, 15 Sep 2026 12:09:20 +0200 (CEST)
Date: Tue, 15 Sep 2026 12:09:20 +0200
From: Jan Kara <jack@suse.cz>
To: 781735889@qq.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, harshadshirwadkar@gmail.com
Subject: Re: [PATCH v3] ext4: propagate errors from fast commit i_blocks
 replay
Message-ID: <7mthyf3hmuafafzzfufmoa5ezqb674yhxfw3pqssvzfmrj4kfv@5ku7gaup7wl6>
References: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_ECF4DA918377A7A0D8863B860B0F3025C106@qq.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 5EEDD1FD9E
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[qq.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,qq.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO

On Tue 15-09-26 09:57:46, 781735889@qq.com wrote:
> From: lty <781735889@qq.com>
> 
> ext4_ext_replay_set_iblocks() breaks out of its mapping loop when
> ext4_map_blocks() fails, but then continues with a partial block count
> and unconditionally returns success. The fast commit replay caller also
> ignores the helper return value.
> 
> Stop the count immediately on mapping errors, leave i_blocks unchanged,
> and propagate the failure to abort inode replay.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Signed-off-by: lty <781735889@qq.com>

You could have kept my Reviewed-by tag just for this changelog change.
Anyway feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v3:
> - Move the version history below the separator.
> 
> Changes in v2:
> - Propagate errors from all ext4_find_extent() and skip_hole() calls in
>   ext4_ext_replay_set_iblocks(), as requested by Jan Kara.
> - Keep i_blocks unchanged when any replay lookup fails.
> 
>  fs/ext4/extents.c     | 26 ++++++++++++++++----------
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
> 
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
