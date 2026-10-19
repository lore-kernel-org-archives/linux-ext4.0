Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF9A49A3AB;
	Mon, 19 Oct 2026 09:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792400520; cv=none; b=lrbaflQuOjikRYmnouNbfQ5o6hlKv4TL2mzk/IF6zupRW6V52yT16J921czhMdunvX3Q/Es4ua9+bzgltt5Fq+9IHT0GOOuUiTCa0WNAW0XuznAU6GvqMyfwHKIkPXj3IrpjuhJGruTOADUDcIf1EUb9JgFtw8mFwEDYePzjaOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792400520; c=relaxed/simple;
	bh=9YWx8WAm34xanNpLhpaS8oLDCPXamViXVVUfEYDnJg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eO8kbEIZcemv5k8Z2hgOtQyFKx5ebI0ZuXu09oXFbZysGpuxiTbKtr7a2LI8SefLC/zYjbEc6bRIq/xXtRlZW2O32yBNZYZKApajBKoV2PoQ/puHUHHVwzQyx0xbAQBpnyN9LEh+ztvv+j6ECcD1RJwqZp1nRO+Jc8dbyxN31dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TaXJcFkG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CJMfatPT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TaXJcFkG; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CJMfatPT; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TaXJcFkG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CJMfatPT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TaXJcFkG";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CJMfatPT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A995321BFC;
	Mon, 19 Oct 2026 09:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792400516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNnRDA0okT2U1jOeZ0ajx9DmL7Ea6AXQTcY6hG5C1uY=;
	b=TaXJcFkGDZ0EXREic6WoGSbFVHAEWbnzq3aanYZa87tbaKEl63euyfpdosy417TMOk4I4N
	zwi0p5xH0rDGjKf6GegBqyWcF16QG4MIESqw3e3cFdU6tfNdNqo3MLhUAmau4CWe2zbOHv
	EurflAFdGYV3iScwvHqPI6/qzWqLcIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792400516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNnRDA0okT2U1jOeZ0ajx9DmL7Ea6AXQTcY6hG5C1uY=;
	b=CJMfatPTMzus+53MyicnGmxneKM91UGC8BPS7bR6wPyRe+czFqKiA5IS5AuljRBlWOpQE1
	0Ku/DYD0ePTpxWAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792400516; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNnRDA0okT2U1jOeZ0ajx9DmL7Ea6AXQTcY6hG5C1uY=;
	b=TaXJcFkGDZ0EXREic6WoGSbFVHAEWbnzq3aanYZa87tbaKEl63euyfpdosy417TMOk4I4N
	zwi0p5xH0rDGjKf6GegBqyWcF16QG4MIESqw3e3cFdU6tfNdNqo3MLhUAmau4CWe2zbOHv
	EurflAFdGYV3iScwvHqPI6/qzWqLcIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792400516;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNnRDA0okT2U1jOeZ0ajx9DmL7Ea6AXQTcY6hG5C1uY=;
	b=CJMfatPTMzus+53MyicnGmxneKM91UGC8BPS7bR6wPyRe+czFqKiA5IS5AuljRBlWOpQE1
	0Ku/DYD0ePTpxWAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B8401373D;
	Mon, 19 Oct 2026 09:01:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id swPSAITc1Wo5BgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 09:01:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9B42AA1418; Mon, 19 Oct 2026 11:01:47 +0200 (CEST)
Date: Mon, 19 Oct 2026 11:01:47 +0200
From: Jan Kara <jack@suse.cz>
To: Jiaming Zhang <r772577952@gmail.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, libaokun@linux.alibaba.com, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, syzkaller@googlegroups.com, 
	yi.zhang@huawei.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: clear in-inode xattr space before adding the first
 xattr
Message-ID: <rmorrps3y6t366v4kfno7bcitpic5saoqomt2muaipcif67lzr@jum5r5zposvr>
References: <CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com>
 <20260916084723.877552-1-r772577952@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916084723.877552-1-r772577952@gmail.com>
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
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,suse.cz,linux.alibaba.com,linux.ibm.com,gmail.com,googlegroups.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO

On Wed 16-09-26 16:47:23, Jiaming Zhang wrote:
> An inode can hold extended attributes in the space that follows its extra
> fields, whose size is given by i_extra_isize.  When ext4 loads an inode,
> ext4_iget_extra_inode() validates that space only if it starts with the
> xattr magic, and only then sets EXT4_STATE_XATTR.  Without the magic, the
> space is treated as empty and is not checked.
> 
> ext4_xattr_ibody_set() passes the space to ext4_xattr_set_entry() whether
> or not EXT4_STATE_XATTR is set.  ext4_xattr_set_entry() walks the entries
> there to find min_offs, the lowest value offset.  That offset decides
> whether the new value fits and where the value is copied:
> 
> 	free = min_offs - ((void *)last - s->base) - sizeof(__u32);
> 	...
> 	void *val = s->base + min_offs - new_size;
> 
> A crafted image can leave non-zero bytes in that space without the magic
> where ext4 looks for it, for example by shrinking i_extra_isize.  Those
> bytes are parsed as entries, and an entry that claims an in-inode value at
> offset 0 sets min_offs to 0.  Because free is a size_t, the subtraction
> then wraps around to a huge value, and the free space check passes although
> the value does not fit.  The value is copied new_size bytes before the
> start of the space, over the inode's own fields and, for a large value, the
> memory in front of the inode.
> 
> On a kernel without KASAN, the copy corrupts memory: it overwrites the
> inode's own fields and, for a large value, also the memory in front of the
> inode.  The bytes and their length are decided by the setxattr() caller.
> Nothing is freed and reused here, so the use-after-free in the report only
> reflects where the write happened to land.
> 
> Triggering this issue requires mounting a crafted image, which needs
> CAP_SYS_ADMIN or automounting of removable media; after that, any
> setxattr() on the file reaches this path.  The issue was found by fuzzing
> and has not been seen in production; a reproducer is available in the
> linked report.
> 
> Clear the space in ext4_xattr_ibody_set() before calling
> ext4_xattr_set_entry() when EXT4_STATE_XATTR is not set, so that the walk
> starts from the empty entry list.
> 
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Closes: https://lore.kernel.org/lkml/CANypQFZzxTAH=4QRRDoqH6VAw1daAq88NDWiQKoM7QTOnP40sg@mail.gmail.com/
> Cc: stable@vger.kernel.org
> Assisted-by: Claude Code:claude-opus-5
> Signed-off-by: Jiaming Zhang <r772577952@gmail.com>

Thanks for the fix! One nit below:

> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index 5c310747b965..2e5f39b710bd 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -2274,6 +2274,10 @@ int ext4_xattr_ibody_set(handle_t *handle, struct inode *inode,
>  		if (IS_ERR(ea_inode))
>  			return PTR_ERR(ea_inode);
>  	}
> +
> +	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
> +		memset(s->first, 0, s->end - (void *)s->first);
> +

So this looks correct but AFAICS it should be enough to zero just the first
u32 of the xattr space? I.e.:
		*(__u32 *)s->first = 0;

That way IS_LAST_ENTRY() returns true for s->first and the whole space is
treated as empty. For larger inodes memsetting the whole space could be
unnecessarily expensive and inode without EXT4_STATE_XATTR is actually a
common thing (inode without any extented attributes will be such as well).
Also please add a comment before the check like:

	/*
	 * Make sure xattr space is properly initialized so that
	 * IS_LAST_ENTRY() returns true for it's first entry
	 */

Thanks.

								Honza

>  	error = ext4_xattr_set_entry(i, s, handle, inode, ea_inode,
>  				     false /* is_block */);
>  	if (error) {
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
