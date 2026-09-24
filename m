Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0853845C701;
	Thu, 24 Sep 2026 16:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790266043; cv=none; b=g7xfNhA06gIsOUDED1ikWlQIzmQBFW3sJWkMsswvk0/2PbGACy4JCw1d0RhG0gT4vvW+0CbaYOS+GIqUO10Ca2SE+5G95GvoBTxVRIqxCWq8MUjwXa81TxzonsMkUBDXRmydjF+7SeFOYZsia74nOFWzQo1bFRG9vUoMbFSUYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790266043; c=relaxed/simple;
	bh=y+dPEwLgjm3bBpJXsWGXfCUHJv534hCygFhpJKYMBzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NSLTw4L2xyU3sOgCqJGaJ/ucOPn3ELVTAeZq+8ev5uct+kSe9MBfu/8yOukrFVSqhO/uapNJ1DgIIRpFqbQeEDxdQvHtIv08EkXUU7ap9YkPIJH1PYlmoxjKxMSY15CTtv6J2XHnpSEwvzw07ggRnz+TDI5aPRo3/sQbvJPpZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R2Qna2Ov; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Qo05Itxo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tUQmaGGW; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=jchCNsRu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R2Qna2Ov";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Qo05Itxo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tUQmaGGW";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="jchCNsRu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE4B021EFD;
	Thu, 24 Sep 2026 16:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xLA5vBIS2xVuJ15S0WC3ZYmD2sGCjx5zbW6sFwewPfk=;
	b=R2Qna2OvPnVtVp0An3LLcxXybCJcf8Qj49Tk1aNM92YPTIfzQF67mb7dxLqHBZQI5Tg9de
	wXcxBJN6CbaA+LcpEZfUS8wnGdqMauVk8VjfxHpE9ngzI2w8k+QlT5vG+PzIWaqvbYQbzr
	WVrvj+HBEbGx2IZXpG5WgZ13M+tFces=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xLA5vBIS2xVuJ15S0WC3ZYmD2sGCjx5zbW6sFwewPfk=;
	b=Qo05ItxovePqvAcLN9L9S3nYoa7BC0r7WE66l70qll/0ZbbxAObEpSjl8EGR/8c9QNhawv
	7yu+oG0ZatRITeAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790266031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xLA5vBIS2xVuJ15S0WC3ZYmD2sGCjx5zbW6sFwewPfk=;
	b=tUQmaGGWQQE4lwgKPdC4AoUDxmNlWWPUnqmzKTtSkKr1k7CTBGX9er/twTIhs3A8RP2mUw
	ueszZR5/RO5L/KRYab1IvChVexWjKdgXWPBVpgtVE2gVFfrw9jfIVzrMEIWqQTIFxlH9d7
	IUPa82d78FKNE76vllXr3l1ZDRMRX34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790266031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xLA5vBIS2xVuJ15S0WC3ZYmD2sGCjx5zbW6sFwewPfk=;
	b=jchCNsRuoazUX3QJNy8F6A/Uez5fCugOIR191RCP/ciZziA4salAKboUwO+QmZPjCaMXwo
	CbGLqGPDK1gNcVBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 872EF1365D;
	Thu, 24 Sep 2026 16:07:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +vsUF69KtWpWXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:07:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0ECFEA132E; Thu, 24 Sep 2026 18:07:07 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:07:07 +0200
From: Jan Kara <jack@suse.cz>
To: Yichong Chen <chenyichong@uniontech.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: don't free the tmp_inode tree after a partial
 migration swap
Message-ID: <6hqrrmg6fxygsximtt7dek2fbxg4z7lkbujkxmbhch5a3dmi2w@mhok2e4bbzmj>
References: <20260918101240.3721805-1-chenyichong@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918101240.3721805-1-chenyichong@uniontech.com>
X-Spam-Level: 
X-Spam-Score: -2.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,linux.vnet.ibm.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]

On Fri 18-09-26 18:12:40, Yichong Chen wrote:
> ext4_ext_migrate() cleans up the temporary inode when
> ext4_ext_swap_inode_data() fails:
> 
> 	retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
> 	if (retval)
> 		free_ext_block(handle, tmp_inode);
> 
> ext4_ext_swap_inode_data() switches the inode to extents and copies the
> tree root into it before it frees the old indirect block map, so it can
> return an error after the swap has already happened.  The copied root
> points at index blocks that tmp_inode allocated, and free_ext_block()
> walks that same tree and frees them, leaving the migrated inode with a
> tree node that the block bitmap considers free.
> 
> Only free the tmp_inode tree when the inode has not been switched to
> extents, which is exactly the case where the swap did not happen.
> 
> Fixes: c14c6fd5c56a ("ext4: Add EXT4_IOC_MIGRATE ioctl")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
> index 2ce587043945..e588b4157604 100644
> --- a/fs/ext4/migrate.c
> +++ b/fs/ext4/migrate.c
> @@ -562,7 +562,7 @@ int ext4_ext_migrate(struct inode *inode)
>  		free_ext_block(handle, tmp_inode);
>  	else {
>  		retval = ext4_ext_swap_inode_data(handle, inode, tmp_inode);
> -		if (retval)
> +		if (retval && !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  			/*
>  			 * if we fail to swap inode data free the extent
>  			 * details of the tmp inode
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
