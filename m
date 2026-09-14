Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0017541CB2E;
	Mon, 14 Sep 2026 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379525; cv=none; b=Lo4ptdbKUc6LRYJbFTwvfhSXRR5nWLpHEXqvx+rpiVwV+FjTQTzhz0qa8VHsWlwDNg7BQvndEQrO2wAGwYiZm2vAiJBNvfKOgB9WSbalX1l2aMewvKsrgnp8t8rnP/nlfIZzvVCljeRIQbolP/gNCNntargm7ulG48jhfyVhpsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379525; c=relaxed/simple;
	bh=I+T1PPx8zuVvC7eypK4x05Nqsbh1bnWeFRqp2F5UEYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWutinB2qNDepbQsxiFVNgTjn2t/lDVU/IX5/AWCswMk+pux6Fg9mp4m99ABmUkO1Uzkt/tiuQaiQvyG9+btMFyrWkaBQfOOh59jXIAi86O9Ngtsxwch8IAyhXcYOGI5mSgi5vBUMIbYovqCittItw7FIWLfACpSJ8z6j8Er0vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TatQz+GV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=TxHtTLKE; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=yaJ0ZJ6q; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=MN3m9SMU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TatQz+GV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="TxHtTLKE";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="yaJ0ZJ6q";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="MN3m9SMU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A270D1F7CC;
	Mon, 14 Sep 2026 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789379517; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gfRvBK/IcJdC7UlrAnXSig94IX6bo9wVy8QZiXcw0uI=;
	b=TatQz+GVd5CKd2SmaQtDuMrMig+cgseMjCAOW8m9MLmDI9qAVl/tQvDN2kFEUVIVAvXzlH
	wEHmSYpuw31svOiqIgoKWPGhBAMQsbGFVw+J/z5usU8V17uA2pyFCqwBSKlCVwyqrAWnUy
	Y+9jy7Fv63Nl8fJDcXZKP4MwchIENk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789379517;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gfRvBK/IcJdC7UlrAnXSig94IX6bo9wVy8QZiXcw0uI=;
	b=TxHtTLKECCLiLcA2EPA3MfJg2SfDCdVYbq5Fpvasr4uGLKVm2U3Mxw2fKLEGzy3VfSoG1A
	+ZDcYSxyhfzWFQAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yaJ0ZJ6q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MN3m9SMU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789379513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gfRvBK/IcJdC7UlrAnXSig94IX6bo9wVy8QZiXcw0uI=;
	b=yaJ0ZJ6q04pGBv9RswbzcGg3bvYagnu0iwz681mwYTnpe7mcVqZU3WKjDj4tDamXZVWUxA
	gPOn6dY2mPohYVwU3wBKvKLcKc0NMFb6nTxidc0vtjee0d2jAek46CdcaQXzDmu15/2KSm
	XVq3nv+Ph1/SAh8mYSCfuMSptu7V+ec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789379513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gfRvBK/IcJdC7UlrAnXSig94IX6bo9wVy8QZiXcw0uI=;
	b=MN3m9SMUZ88ysBaVN4n4eGsj0jl5iYHOnAZWFcCOfp9MznMNwEmeaHBtMbX2NJP1g/5wcW
	Ygx0IRItR0I0vMAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 776C313693;
	Mon, 14 Sep 2026 09:51:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xNcjHbnDp2pqcwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 14 Sep 2026 09:51:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0DB87A12E4; Mon, 14 Sep 2026 11:51:53 +0200 (CEST)
Date: Mon, 14 Sep 2026 11:51:53 +0200
From: Jan Kara <jack@suse.cz>
To: lty <781735889@qq.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit i_blocks replay
Message-ID: <mkrgixktv46juywijsh3oe53iyspjcg2fje46pi3zcok7ygkou@htf2ngrxzglg>
References: <tencent_46F42EDFC0F504046B160E939DB76255EE08@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_46F42EDFC0F504046B160E939DB76255EE08@qq.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A270D1F7CC
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[qq.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.51

On Mon 14-09-26 15:16:45, lty wrote:
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

I guess this is fair but please propagate all errors from
ext4_ext_replay_set_iblocks(). There are several other places in that
function doing things like:

	path = ext4_find_extent(inode, cur, path, 0);
        if (IS_ERR(path))
                goto out;

which can return errors we should be propagating up.

								Honza
> ---
>  fs/ext4/extents.c     | 4 ++--
>  fs/ext4/fast_commit.c | 7 +++++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 76038b6c3655..d67e30cf44ad 100644
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
> @@ -6333,7 +6333,7 @@ int ext4_ext_replay_set_iblocks(struct inode *inode)
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
> base-commit: 704340f1cd0dcef829eb62f5b48ae95a2ce17bdf
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
