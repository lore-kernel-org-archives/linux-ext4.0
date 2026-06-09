Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC6E3F9A0E
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 10:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781002333; cv=none; b=lNQiExhbGw6ZIKBP6IE3YGN0Zv5FFFVV8u8nW86AMl0n8hT7nzTK7KYnZg0YOm6AbTIu0O4+qufahzZ5zPDzdf49mYVOZ7K4BUDQwgetgL7q71MsurbaWxc5ri4IuPtZq5HBekBUYXP0GEax0bWVrK2cJbOGdvodEhQYzaxO0g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781002333; c=relaxed/simple;
	bh=7yAmUeJJu1Xu1O807mkW16TT6/FVivgAN2hnnjDlkcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nH5aZ+HCMQnn1sPYehcY1+nUp3IlwRDCHEHFzklJDAlW9qXVTyhEKPK6nFPDOJf3aTBwHnRnLggqRDsDP6ZxFYUo/fSaEgEyq9HfG3iUDhDi8Mpgw0tlZPl/2yCuNJON7Lfy0RZD+PCujtL5PqEUshdQWw00bezl++02mKzwBIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=vztyAwxg; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=VpH14vKI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=S856kBfl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7YnmkzY3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="vztyAwxg";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="VpH14vKI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="S856kBfl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7YnmkzY3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8F79758CD;
	Tue,  9 Jun 2026 10:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781002330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lt1iIzVGwbuwL8Vr5/fh2av4zGuoA1UhDy2MrDLk7c4=;
	b=vztyAwxgcOD8+KVx5rQvEBZFXOex5r2rKpbfMqrteDtlKUodi7i5ErF6mtDVmZphPlhMCm
	XvARxXhTxxeCuQLKNI7bEfpnx5C3b1/NsgvDWVFIo0L5DFPVv16dVr9ccMV32lgPmB4ibe
	33zPHiCPuhfA2KhpFaEPTHtKc0AXrBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781002330;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lt1iIzVGwbuwL8Vr5/fh2av4zGuoA1UhDy2MrDLk7c4=;
	b=VpH14vKIRVczYray9N0b8m9hGZg6lYy4c6GOkeL6bUS7fNf2schfxWcgLZ6nkCH+qT8+cW
	7iBRRjlO5+VI9LBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781002329; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lt1iIzVGwbuwL8Vr5/fh2av4zGuoA1UhDy2MrDLk7c4=;
	b=S856kBfla/LDokBP3cgLK13RwooQLvlISDuSdlMXYZ0BdJ64B8UbP1gReXjguthrsk2XNC
	bb5ElvzxlyVVJbrO1rGGri0Z6keVnUfCEXBK3ICocGaxcI+Ud/o/sgSKebC/MbstDZzXXk
	EFaaTU75yrHfu9YToY1yGTmF4aPDqu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781002329;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lt1iIzVGwbuwL8Vr5/fh2av4zGuoA1UhDy2MrDLk7c4=;
	b=7YnmkzY3mIonSdM7Cj+KLSrqYD+KGJTCLVDUcSyKqsJMEekAlwKoT6fqkaQt4FjLuiYmge
	SUALsEmecMBwjKBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0187779A7;
	Tue,  9 Jun 2026 10:52:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2nMMlnwJ2q0dQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 10:52:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 74CAEA0A90; Tue, 09 Jun 2026 12:52:09 +0200 (CEST)
Date: Tue, 9 Jun 2026 12:52:09 +0200
From: Jan Kara <jack@suse.cz>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: fix kernel BUG in ext4_write_inline_data_end
Message-ID: <w7zmtkoa4ieb676gkl6m2ax5hp76dxr2rhkfzgqvlydvw4hpfr@hixijfpumliv>
References: <20260608065227.3018-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608065227.3018-1-aditya.ansh182@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[0c89d865531d053abb2d];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.com:email,appspotmail.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On Mon 08-06-26 06:52:27, Aditya Prakash Srivastava wrote:
> When the data=journal mount option is used, the ext4_journalled_write_end()
> function incorrectly calls ext4_write_inline_data_end() without checking
> if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.
> 
> If a previous attempt to convert the inline data to an extent failed (e.g.
> due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
> the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
> call to ext4_write_begin() will not prepare the inline data xattr for
> writing, but ext4_journalled_write_end() will incorrectly attempt to write
> to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
> ext4_write_inline_data() since i_inline_size was not expanded.
> 
> Fix this by ensuring that ext4_journalled_write_end() only calls
> ext4_write_inline_data_end() if the EXT4_STATE_MAY_INLINE_DATA flag is
> set, mirroring the behavior of ext4_write_end() and ext4_da_write_end().
> 
> Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
> Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c2c2d6ac7f3d..4fce9ec176f8 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1560,7 +1560,8 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
>  
>  	BUG_ON(!ext4_handle_valid(handle));
>  
> -	if (ext4_has_inline_data(inode))
> +	if (ext4_has_inline_data(inode) &&
> +	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
>  		return ext4_write_inline_data_end(inode, pos, len, copied,
>  						  folio);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
