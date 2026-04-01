Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B130538A73A
	for <linux-ext4@vger.kernel.org>; Wed,  1 Apr 2026 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775063394; cv=none; b=lGnbjvO8iuxkx/33LzvHCvYIcbo3Nc+CA6YBv+9wwepKSkdCqz6afSW4ezshexXGiVkMT+A0DieQJr0Yf6sP9gsm5ugjRAXDR6CpwFPD/ua33UqwLd+3gsk/MeFKAK8ZB2Mg10AYr6cxWsv/Dht6leiQhXM9S00AgPdguCHg1H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775063394; c=relaxed/simple;
	bh=zuswW9Ijwau12aEArle5jZB/zDri6gpTHLihHZoZE+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qx7E4x1vcSiJ5zgvDF7HCp98uVSCVfyq5NftfyLi2X8Bbjrykg/tsNrjsNO9u/+sydMCE1OSOKYDY2HjGZMbLpZnD9jPeKtjybwgxZ9TDWCGNu0thfic9ntcFUMqF7zl2ypev4tISSEeXCbjEACuz9I9cg7NVEW4GbHzzXQnA64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uLSfyvjq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uc63ha5M; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=uLSfyvjq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uc63ha5M; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uLSfyvjq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uc63ha5M";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="uLSfyvjq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uc63ha5M"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D6574D2FA;
	Wed,  1 Apr 2026 17:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSgRhppgwKWIEfWQoyoSQRU+OilmAJs4JdNcpHT8F0U=;
	b=uLSfyvjqeXsxReF4Fsnfgvt92NNM+qFFN/d4curKQu8Pxt3MEIavlKMN+nmZgn7u8HszNX
	36FFO1daha2Hs18FWKvYvdT/mu+D3EKlW3LDrAgrFXnTveio0sqAeAEL7TyB/mGrV0M7s9
	jAeHGbcSnpmw6sTv1sqI69z8SuJ/QTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSgRhppgwKWIEfWQoyoSQRU+OilmAJs4JdNcpHT8F0U=;
	b=uc63ha5Mfh0q5GxGvLlznXYXm1JWJuLYQ6uASUiQW7wGdeqKt1/fs/p4AINK+UfF9BQQAx
	wjtRceQaPFRjs6Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775063391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSgRhppgwKWIEfWQoyoSQRU+OilmAJs4JdNcpHT8F0U=;
	b=uLSfyvjqeXsxReF4Fsnfgvt92NNM+qFFN/d4curKQu8Pxt3MEIavlKMN+nmZgn7u8HszNX
	36FFO1daha2Hs18FWKvYvdT/mu+D3EKlW3LDrAgrFXnTveio0sqAeAEL7TyB/mGrV0M7s9
	jAeHGbcSnpmw6sTv1sqI69z8SuJ/QTU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775063391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSgRhppgwKWIEfWQoyoSQRU+OilmAJs4JdNcpHT8F0U=;
	b=uc63ha5Mfh0q5GxGvLlznXYXm1JWJuLYQ6uASUiQW7wGdeqKt1/fs/p4AINK+UfF9BQQAx
	wjtRceQaPFRjs6Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0103A4A0B0;
	Wed,  1 Apr 2026 17:09:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Whg8AF9RzWmpKAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 01 Apr 2026 17:09:51 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 76F30A0B39; Wed,  1 Apr 2026 19:09:35 +0200 (CEST)
Date: Wed, 1 Apr 2026 19:09:35 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, libaokun@linux.alibaba.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v4 11/13] ext4: remove ctime/mtime update from
 ext4_alloc_file_blocks()
Message-ID: <7smodlgpgfkmd2wmdmfe5vkdhuvjelmejh6nho5vn3dnij3cai@y4zxwrqtcujj>
References: <20260327102939.1095257-1-yi.zhang@huaweicloud.com>
 <20260327102939.1095257-12-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327102939.1095257-12-yi.zhang@huaweicloud.com>
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
	RCPT_COUNT_TWELVE(0.00)[14];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,linux.alibaba.com,huawei.com,fnnas.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Fri 27-03-26 18:29:37, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The ctime and mtime update is already handled by file_modified() in
> ext4_fallocate(), the caller of ext4_alloc_file_blocks(). So remove the
> redundant calls to inode_set_ctime_current() and inode_set_mtime_to_ts()
> in ext4_alloc_file_blocks().
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/extents.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f4009544f762..7abe47f923c0 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4623,13 +4623,10 @@ static int ext4_alloc_file_blocks(struct file *file, loff_t offset, loff_t len,
>  		 */
>  		retries = 0;
>  		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
> -		inode_set_ctime_current(inode);
>  		if (new_size) {
>  			if (epos > new_size)
>  				epos = new_size;
> -			if (ext4_update_inode_size(inode, epos) & 0x1)
> -				inode_set_mtime_to_ts(inode,
> -						      inode_get_ctime(inode));
> +			ext4_update_inode_size(inode, epos);
>  			if (epos > old_size)
>  				pagecache_isize_extended(inode, old_size, epos);
>  		}
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
