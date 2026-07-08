Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE0B3A6F17
	for <linux-ext4@vger.kernel.org>; Wed,  8 Jul 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783524393; cv=none; b=UFDRNxzDOdJz80kychF5kpnWz2uKDdoFyCbcj0fcER7XM30g31kurYZPDQFZXZPFOuyUZDMBRiwacx5GbEwGNxkWnZj0mQp5YIBrOo1sKqWUdGBt9gFOrBXo2BFtHlVMhxrWGkFrf7rU6TaX0zWS7cGH3MlhBLG3ZB/NELDB0dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783524393; c=relaxed/simple;
	bh=/O9WSHyOMk5miS3ARsyouSLfQOQaim2uDnbGOvBmcdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cJYJjJpQMmeFxcq0/XAx/DvzXcBn1h6dHSmMcZ71a3WU/rvCPgoB2+ETABPhbHSqCpIEucqxv/RcWWcS1EH2Gn9QysfHMzKfOG+UEri2nRgLTaVbRz91g9nHPt4iEJAyxJdJBWYN93I2jSEgEsf7G0c2yoolBq9Kv578/oTnb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lF2+iYcA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S/cxUuJc; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lF2+iYcA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=S/cxUuJc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lF2+iYcA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S/cxUuJc";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lF2+iYcA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="S/cxUuJc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EDD2758C9;
	Wed,  8 Jul 2026 15:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7w8809JcR4Hp53COwFxsh4x5LkRdnIWSgD5jjeN01k=;
	b=lF2+iYcAj1kZNF+r5DndXd4EZyZ0u4OHn/JOjZX3uC/MneyI1mEgWqBDc1ktrj/BpN/c3z
	1zzYgdiefm8Pdo0u23Nt5QsJoNoz4C8vjKfV6q6A2lBdYMkWztu3n/q3x+SDDB9Y12N7NP
	DRBv+zWEAVlyFSob+MY5gNFEgEIKt7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7w8809JcR4Hp53COwFxsh4x5LkRdnIWSgD5jjeN01k=;
	b=S/cxUuJc56rDBZ6q73J9v6yCgCkcR34In02q0/hg/BoESwlknoxAHdxmJHDEVSDzaGNK9T
	gdr7CzuT1Cl5VWBg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lF2+iYcA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="S/cxUuJc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783524389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7w8809JcR4Hp53COwFxsh4x5LkRdnIWSgD5jjeN01k=;
	b=lF2+iYcAj1kZNF+r5DndXd4EZyZ0u4OHn/JOjZX3uC/MneyI1mEgWqBDc1ktrj/BpN/c3z
	1zzYgdiefm8Pdo0u23Nt5QsJoNoz4C8vjKfV6q6A2lBdYMkWztu3n/q3x+SDDB9Y12N7NP
	DRBv+zWEAVlyFSob+MY5gNFEgEIKt7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783524389;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j7w8809JcR4Hp53COwFxsh4x5LkRdnIWSgD5jjeN01k=;
	b=S/cxUuJc56rDBZ6q73J9v6yCgCkcR34In02q0/hg/BoESwlknoxAHdxmJHDEVSDzaGNK9T
	gdr7CzuT1Cl5VWBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57749779AE;
	Wed,  8 Jul 2026 15:26:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7wVWFSVsTmqVOQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Jul 2026 15:26:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DAFF7A12D6; Wed, 08 Jul 2026 17:26:20 +0200 (CEST)
Date: Wed, 8 Jul 2026 17:26:20 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huawei.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huaweicloud.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 2/6] ext4: clarify return semantics of
 ext4_load_tail_bh()
Message-ID: <fn6frodirjc2zvd3sl5zwh4h7q5dfbbha2le3eylq2sne4k7fm@upemtxsqhsz3>
References: <20260707021338.1182268-1-yi.zhang@huawei.com>
 <20260707021338.1182268-3-yi.zhang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707021338.1182268-3-yi.zhang@huawei.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[15];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huaweicloud.com,huawei.com,fnnas.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 6EDD2758C9
X-Spam-Score: -2.51

On Tue 07-07-26 10:13:34, Zhang Yi wrote:
> ext4_load_tail_bh() returns NULL for both holes and clean unwritten
> buffers, but the conditions that lead to this are not obvious from the
> code alone. Document this behavior to clarify the return value, so that
> readers do not mistakenly assume that only holes result in a NULL
> return.
> 
> Also update the inline comment following the ext4_get_block() call to
> reflect this, and note that a lookup-only get_block (without
> EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean unwritten
> extents, which is why a clean unwritten bh falls through to the
> "nothing to do" path.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..45a7e6cdb2a1 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4026,6 +4026,10 @@ void ext4_set_aops(struct inode *inode)
>   * because it might have data in pagecache (eg, if called from ext4_zero_range,
>   * ext4_punch_hole, etc) which needs to be properly zeroed out. Otherwise a
>   * racing writeback can come later and flush the stale pagecache to disk.
> + *
> + * Return the loaded bh if it actually needs zeroing - in written, dirty
> + * unwritten, or delalloc state. Return NULL if it's clean (i.e., a hole or
> + * a clean unwritten block).
>   */
>  static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  {
> @@ -4065,7 +4069,12 @@ static struct buffer_head *ext4_load_tail_bh(struct inode *inode, loff_t from)
>  	if (!buffer_mapped(bh)) {
>  		BUFFER_TRACE(bh, "unmapped");
>  		ext4_get_block(inode, iblock, bh, 0);
> -		/* unmapped? It's a hole - nothing to do */
> +		/*
> +		 * It's a hole or a clean unwritten block - nothing to do.
> +		 * Note that a lookup-only get_block (without
> +		 * EXT4_GET_BLOCKS_CREATE) never sets BH_Mapped for clean
> +		 * unwritten extents.
> +		 */
>  		if (!buffer_mapped(bh)) {
>  			BUFFER_TRACE(bh, "still unmapped");
>  			goto unlock;
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
