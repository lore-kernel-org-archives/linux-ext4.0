Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F140B396
	for <linux-ext4@vger.kernel.org>; Mon, 15 Jun 2026 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781540893; cv=none; b=EZZskkqV1ptB6MKvQduk9qWB22YGSKZbrHrpzeSsSvkDOk0jhS3cglhZonv35Ao1+3SOFa9AvZC2fPIIw9Cj6JJGisbfx6xnO33mq2aqNA4X2gOx4Yk7IpQhyhcsSIyiEQWyjuFJi63aAagYFEsiRV3qpKwpnAMEF1PxorXALuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781540893; c=relaxed/simple;
	bh=zLXY3gAjoSPsSXspLlv5MLuUq23gtThCX5dYEg7Hvz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XU/YsHgxzVpLzqfsny00Zd6fJpXbspz/XTesVJDNGDqucLfhjvd9dLlB7UHQ9kGHTHe3ti+ZNpgmtQdjJ66vHVEkresiaFXq+6KEG3jSv/sI7kGqGFqKwVWwSM8EUygtshTx66ufxCtlZrNEIzU814VoMm9AkuLCBj2QZy7Hz2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zG3im2RM; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AU4sAOMw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DIa3O+IX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=PY+GbsSu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zG3im2RM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AU4sAOMw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DIa3O+IX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="PY+GbsSu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2BB2E759F9;
	Mon, 15 Jun 2026 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781540889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9SWOH8yD8IETo1H8Xhap+zYiBYD+xd/IGYsdLwEmpG0=;
	b=zG3im2RMZjUGILZVBl4BynhiwuXc+cZ9hRO6xcucia7/H9GV6WI2bjvVYTwHm5sfCLPi/D
	38DzCHjM+7BXZ381LMOHGuFeVv/JD8DFY7zSwUsKQzwLHB+fCBRJJbfiVHbcPGrTyPNXvp
	6a9ryqCwJzsJyCEE9HdA6SvFwUJJSyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781540889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9SWOH8yD8IETo1H8Xhap+zYiBYD+xd/IGYsdLwEmpG0=;
	b=AU4sAOMwlBLVtandHPiSo3nDDU5TyPcavr6ZJNi32R9f4iOxc1a5zsdNGlDm/dnQD52N3n
	YQVvNOj2v3Ta6PCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781540888; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9SWOH8yD8IETo1H8Xhap+zYiBYD+xd/IGYsdLwEmpG0=;
	b=DIa3O+IX/vaWg7sLopTfdNxmqpsUtC6rb+cau6U8o66hvFqrBKbmO8/SGjkmJN2oF8MJ7T
	gCJvK0lnltKgR/BEGwHKQOlbDd5px5Juj1GVCoaihKsFIJDyLdXjCJ+XqSMso10Hp/uroK
	ilVfR6pRillrQsJb3VQCa4CIhtwQrZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781540888;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9SWOH8yD8IETo1H8Xhap+zYiBYD+xd/IGYsdLwEmpG0=;
	b=PY+GbsSuKaIQDSrS4sqK5u2dmLRBvbAZ7FMjHaYSOwcjKgyQX6uaikObaOBNytQRvKmNiw
	Unt0lmf0yh3vrLCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C6F9779A7;
	Mon, 15 Jun 2026 16:28:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F+LoBhgoMGprZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 15 Jun 2026 16:28:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB455A12D2; Mon, 15 Jun 2026 18:28:03 +0200 (CEST)
Date: Mon, 15 Jun 2026 18:28:03 +0200
From: Jan Kara <jack@suse.cz>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Message-ID: <nbw2agiltoim62rjj6wzp3cspz4fjvtl5ple6hrirafx2o6qgo@s3kvln4ytk67>
References: <20260615115317.3549469-1-yun.zhou@windriver.com>
 <20260615115317.3549469-3-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615115317.3549469-3-yun.zhou@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,windriver.com:email,suse.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Mon 15-06-26 19:53:16, Yun Zhou wrote:
> An inode being evicted will never need its extra isize expanded.  Set
> EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
> to make this explicit and prevent any unnecessary work in
> ext4_try_to_expand_extra_isize().
> 
> This also provides defense-in-depth for the s_writepages_rwsem deadlock
> during mount-time orphan cleanup, ensuring the expand path is blocked
> for inodes under eviction regardless of how they are reached.
> 
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>

Looks good. I'd move the setting somewhat earlier (just before
dquot_initialize()) so that it obviously covers all the inode dirtying that
can happen while deleting the inode. But otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index be1e3eaa4f23..60c91c098fa0 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -264,6 +264,7 @@ void ext4_evict_inode(struct inode *inode)
>  	if (ext4_inode_is_fast_symlink(inode))
>  		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
>  	inode->i_size = 0;
> +	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
>  	err = ext4_mark_inode_dirty(handle, inode);
>  	if (err) {
>  		ext4_warning(inode->i_sb,
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
