Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED033563FA
	for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2026 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774260163; cv=none; b=hCAgW31cXeu1Ja9C4xQ4nIYCFPc5OmAfJ5TjcT5/YMyHj3mRbrb3URXVCeHBjdXFCKLNd2/F80482yQt4Chcb9GvyHz97ouVUxlIqtWAHT6lkKI3FzOOL7MuHNqa6PM5yj8+0dNkXhkNTPuXnU0YI2o1cE+ea63xMo0Bs7bD+IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774260163; c=relaxed/simple;
	bh=MGKj7yEFBYl+zFHTEC0Qg2oH98SQNlkscA8erOrNHL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tWM/alOzziiv17Slcj5XQSpxGR5yFRfpys2emKN01CSyMQnRXJKq4vBGe+pLyBumQeAbflrYh8UxkeNWStb5uJ8ymdcb3Eabpcl9uiBYzpHb13MFM1b9eKBDU/kVCDREI3IBVycblrXNpVVbWSjWSHfKJZ6USrYTBvm65cfdm7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nG9J2nJV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R75ShmCY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nG9J2nJV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R75ShmCY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nG9J2nJV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R75ShmCY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nG9J2nJV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R75ShmCY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AAB924D2A4;
	Mon, 23 Mar 2026 10:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774260159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQ/mtWw2DukCS0uMm/7VxKKT60Igb4l5bx9fNDRs3nU=;
	b=nG9J2nJVimas2HWPVkQdH7z3PWCuGtuW2tFsfgFD5HvX9qGzH+a94SaNdW+sVVLBXiKwxf
	vzzUUs/KunS9n9mDj+6XQO5Uyh6SFYght9NB8hvk5i9NyYKUcbpXwpj0OoJrKgm7lrth2d
	XZ9swOkhRW28dHq5T4Dcs9sFW3XKZ8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774260159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQ/mtWw2DukCS0uMm/7VxKKT60Igb4l5bx9fNDRs3nU=;
	b=R75ShmCYWJmmWQ8wVdmMyqjiNECebJjjwD5q7MCXWzZJnbvkH4d63lzuecov2toW6G4Gkc
	PhLIcp7pD+UD37Bw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nG9J2nJV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R75ShmCY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774260159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQ/mtWw2DukCS0uMm/7VxKKT60Igb4l5bx9fNDRs3nU=;
	b=nG9J2nJVimas2HWPVkQdH7z3PWCuGtuW2tFsfgFD5HvX9qGzH+a94SaNdW+sVVLBXiKwxf
	vzzUUs/KunS9n9mDj+6XQO5Uyh6SFYght9NB8hvk5i9NyYKUcbpXwpj0OoJrKgm7lrth2d
	XZ9swOkhRW28dHq5T4Dcs9sFW3XKZ8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774260159;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vQ/mtWw2DukCS0uMm/7VxKKT60Igb4l5bx9fNDRs3nU=;
	b=R75ShmCYWJmmWQ8wVdmMyqjiNECebJjjwD5q7MCXWzZJnbvkH4d63lzuecov2toW6G4Gkc
	PhLIcp7pD+UD37Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0AA0437FE;
	Mon, 23 Mar 2026 10:02:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ezE3J78PwWloBQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Mar 2026 10:02:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 553C9A0B2E; Mon, 23 Mar 2026 11:02:35 +0100 (CET)
Date: Mon, 23 Mar 2026 11:02:35 +0100
From: Jan Kara <jack@suse.cz>
To: hongao <hongao@uniontech.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	yi.zhang@huawei.com, ojaswin@linux.ibm.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: skip split extent recovery on corruption
Message-ID: <oy32dcoi224a24jryvl2gnidp3jqikwoke75kdvulzpd7hanez@7ceqdj5jnh2f>
References: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA074540F4E30F27+20260323015752.60064-1-hongao@uniontech.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,syzkaller.appspot.com:url,uniontech.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[1ffa5d865557e51cb604];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,syzkaller.appspot.com:url,suse.cz:dkim,suse.cz:email,uniontech.com:email,appspotmail.com:email]
X-Rspamd-Queue-Id: AAB924D2A4
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 23-03-26 09:57:52, hongao wrote:
> ext4_split_extent_at() retries after ext4_ext_insert_extent() fails by
> refinding the original extent and restoring its length. That recovery is
> only safe for transient resource failures such as -ENOSPC, -EDQUOT, and
> -ENOMEM.
> 
> When ext4_ext_insert_extent() fails because the extent tree is already
> corrupted, ext4_find_extent() can return a leaf path without p_ext.
> ext4_split_extent_at() then dereferences path[depth].p_ext while trying to
> fix up the original extent length, causing a NULL pointer dereference while
> handling a pre-existing filesystem corruption.
> 
> Do not enter the recovery path for corruption errors, and validate p_ext
> after refinding the extent before touching it. This keeps the recovery path
> limited to cases it can actually repair and turns the syzbot-triggered crash
> into a proper corruption report.
> 
> Fixes: 716b9c23b862 ("ext4: refactor split and convert extents")
> Reported-by: syzbot+1ffa5d865557e51cb604@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1ffa5d865557e51cb604
> Signed-off-by: hongao <hongao@uniontech.com>

Thanks! The fix looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ae3804f36535..aba9947fd151 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3239,6 +3239,9 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	insert_err = PTR_ERR(path);
>  	err = 0;
> +	if (insert_err != -ENOSPC && insert_err != -EDQUOT &&
> +	    insert_err != -ENOMEM)
> +		goto out_path;
>  
>  	/*
>  	 * Get a new path to try to zeroout or fix the extent length.
> @@ -3261,6 +3264,13 @@ static struct ext4_ext_path *ext4_split_extent_at(handle_t *handle,
>  
>  	depth = ext_depth(inode);
>  	ex = path[depth].p_ext;
> +	if (!ex) {
> +		EXT4_ERROR_INODE(inode,
> +				 "bad extent address lblock: %lu, depth: %d pblock %lld",
> +				 (unsigned long)ee_block, depth, path[depth].p_block);
> +		err = -EFSCORRUPTED;
> +		goto out;
> +	}
>  
>  fix_extent_len:
>  	ex->ee_len = orig_ex.ee_len;
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
