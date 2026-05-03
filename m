Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197E9378831
	for <linux-ext4@vger.kernel.org>; Sun,  3 May 2026 17:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777829037; cv=none; b=tcdnH6Qte1uKmgwTGKfpdLMLHLkw/k6yiuGy3E5p6N58/HVQpV7Ch5/2kiWLKJyfLaqakMxRBqabTTDHR1/0htBZ5vbpURol8Cxik38jWIjhx66JXUihPls+EHntxmoEZb4aFsLuWSah+iYmxNd7ytye+e7AeFuqoa6l4GxB42E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777829037; c=relaxed/simple;
	bh=VecGYkeHoHyJcxij+yn1EVhfjUBAFycWZyFWct1Bt1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T3TE50ZQxGAEiSjJ7BjMDTY4Y62Uagds3RyAfOqB1627jx5KItLqW6wpkqCJEBj0N25i7GDYY1pLFgLENDWM9NUtg/gd6O0g38SACy/yl1wCXaUc8hOrB759pOVjNSHnpNbbH5nrd78BGyzy/fviiifR4LpJFyKkkxGXRHcc5rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pt1cnmne; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l6T+cVco; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Pt1cnmne; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=l6T+cVco; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pt1cnmne";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l6T+cVco";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Pt1cnmne";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="l6T+cVco"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 319176AB07;
	Sun,  3 May 2026 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777829034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rhLIRjj0bnYTClt9CD6WTm2BPh/yYs/KRbMjOw9bEyE=;
	b=Pt1cnmneFhNZp9s+b/lqZMFtAJ4HUL8bYyTf0ApQyQdXSumzjzyov8e46+GWySzTisiv6H
	1eA9CLTcCZzIvG0++w60HywX9BZV8/oDozgw1X6/ZOpuE2lwRkY9sQwBHunC7icn+RpMM0
	rM09BbnNTm/SmWGhsHU0RfUdHjxwnDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777829034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rhLIRjj0bnYTClt9CD6WTm2BPh/yYs/KRbMjOw9bEyE=;
	b=l6T+cVcoC2ODaQuKNGn5A+fEckEeXBN30JHg+awNzlh+05suM3HmMGpfJe1wTK04uicogL
	VpGilBHUjVCxk+Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Pt1cnmne;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=l6T+cVco
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777829034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rhLIRjj0bnYTClt9CD6WTm2BPh/yYs/KRbMjOw9bEyE=;
	b=Pt1cnmneFhNZp9s+b/lqZMFtAJ4HUL8bYyTf0ApQyQdXSumzjzyov8e46+GWySzTisiv6H
	1eA9CLTcCZzIvG0++w60HywX9BZV8/oDozgw1X6/ZOpuE2lwRkY9sQwBHunC7icn+RpMM0
	rM09BbnNTm/SmWGhsHU0RfUdHjxwnDQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777829034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rhLIRjj0bnYTClt9CD6WTm2BPh/yYs/KRbMjOw9bEyE=;
	b=l6T+cVcoC2ODaQuKNGn5A+fEckEeXBN30JHg+awNzlh+05suM3HmMGpfJe1wTK04uicogL
	VpGilBHUjVCxk+Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 21FA5593A3;
	Sun,  3 May 2026 17:23:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kCg2B6qE92kJYwAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 17:23:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1A2E7A0792; Sun, 03 May 2026 19:23:44 +0200 (CEST)
Date: Sun, 3 May 2026 19:23:44 +0200
From: Jan Kara <jack@suse.cz>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext4: possible inconsistency in ext4_append() error path
Message-ID: <5a6ibmy6tdbhbktuvoh6uftqp6pfzcepamcgdpdvq5qkhxv52z@gnzafpivutfi>
References: <20260501172506.563064-1-agarwal.vineet2006@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501172506.563064-1-agarwal.vineet2006@gmail.com>
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
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 319176AB07

Hi!

On Fri 01-05-26 22:55:06, Vineet Agarwal wrote:
> While looking into ext4 directory operations, I noticed a possible
> inconsistency in the error handling of ext4_append().
> 
> In ext4_append(), the inode size is updated before all failure points
> have been ruled out:
> 
>     bh = ext4_bread(handle, inode, *block, EXT4_GET_BLOCKS_CREATE);
>     if (IS_ERR(bh))
>         return bh;
> 
>     inode->i_size += inode->i_sb->s_blocksize;
>     EXT4_I(inode)->i_disksize = inode->i_size;
> 
>     err = ext4_mark_inode_dirty(handle, inode);
>     if (err)
>         goto out;
> 
>     err = ext4_journal_get_write_access(handle, inode->i_sb, bh,
>                                         EXT4_JTR_NONE);
>     if (err)
>         goto out;
> 
> If either ext4_mark_inode_dirty() or
> ext4_journal_get_write_access() fails, the function returns an
> error but does not restore the original inode size.
> 
> Callers of ext4_append() appear to treat it as an all-or-nothing
> operation:
> 
>     bh = ext4_append(handle, dir, &block);
>     if (IS_ERR(bh))
>         goto out;
> 
> However, in the failure case, inode->i_size may already have been
> increased.

Right.

> One possible consequence is that subsequent checks relying on i_size,
> such as:
> 
>     if (block >= inode->i_size >> inode->i_blkbits)
> 
> may allow a block index to pass bounds checks even though the append
> operation did not complete successfully.
> 
> I understand that journaling may ensure on-disk consistency, but the
> in-memory inode state may still temporarily reflect a change that did
> not logically succeed.
> 
> Is this behavior intentional, or should ext4_append() avoid updating
> i_size until after all failure points, or roll it back on error?

The thing is: If any of the above calls you mention fail, the filesystem
journal is aborted and the filesystem doesn't accept any more
modifications. So we are kind of sloppy with error recovery since it cannot
reach on-disk state. I'm not aware where the increased inode size on
failing ext4_append() would cause issues (besides further error complaints)
but if you find some such, yes, we can improve the error recovery path.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
