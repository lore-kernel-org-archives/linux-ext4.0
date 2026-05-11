Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD3D35958
	for <linux-ext4@vger.kernel.org>; Mon, 11 May 2026 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778519033; cv=none; b=a+nqVJi7fAWw3f7I6hKfM5iGbTmtzYJQOKBC6/xRw9jdXet+RwLItwQC65c6bRm48VyX08sdLFem0WnNN0kL8ySeuDOT903CBE+BuvoaEvwq3FAd+3f0VJ8NjanT7+3XcbomRoJgLjs0KMUDI5rK3NHD6KD0E22nRhs5Gmd1ou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778519033; c=relaxed/simple;
	bh=yScn1zlY2NwcIFftNbJWqZi2soG7BLs4NsINLMIt6PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQPZ+fjP8S/TRqkZX78djXkQWepxN7RCcNwMtjmmQnGAp/wXrBY1Gh21CfrbE49SSknmogwoq2+0TGXQC5+rje0esHyWUvHvF0851USLWzQbEKumHCvnjnXJ0J/CJEHDtCCP4f4jbjxWJAuI2i0qtYRTUTmItvltmVIKpI/Rxkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NXbtRW7/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=K6UQBNMv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c3Q9csFP; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/iIhHWqn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NXbtRW7/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="K6UQBNMv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c3Q9csFP";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/iIhHWqn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 03C50683E3;
	Mon, 11 May 2026 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778519030; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nCun6SfEa2kQ8DinZIEBKS8RV42S6Xv0kKMbqMrZolg=;
	b=NXbtRW7/YkJee7NG2LSQ+U8OUDla2pVY8ce9y4Q7DkWqmqtEhW37uKhoiZnwDXPyIja1/p
	+EipJvCUYzNxz0ZwlILqUGNfC07YorMqdoB+m+ks8SqirYw4EwM4KT5ii3ZyqnvteAi5/M
	691vcnKH4R3GNCR/+g0xwnlWw3is65w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778519030;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nCun6SfEa2kQ8DinZIEBKS8RV42S6Xv0kKMbqMrZolg=;
	b=K6UQBNMvz0QTAc9F393dX8ieJBZJ2xus7QU+581Gz/45y9y4iE55ruQaoI4pF4Dfeegjwt
	oLe1gjJBDdX21ADg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778519029; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nCun6SfEa2kQ8DinZIEBKS8RV42S6Xv0kKMbqMrZolg=;
	b=c3Q9csFPrzyz7TtwiccGZ1vkDCXkb/3i/ktGfIbukPEKJkk6mr9BaM9jgTjV0+8cSl7RPs
	9Zu59pEISz/r9JGKaF+kPBLIBaQDTqwTD5XwZ5dmB7Fu+kDU/tpnoSy0WAT+kcHknzGRUU
	3ZRYu1M32vbh9NCpf8yLK3iRHl+1ptg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778519029;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nCun6SfEa2kQ8DinZIEBKS8RV42S6Xv0kKMbqMrZolg=;
	b=/iIhHWqn4icqrUbYKnhlqIPUJOybzHPHGOXfv2pVQxJ623HcGqsGWeJm+vAqijAEW1NmKG
	GRd2JgKsImXSsXCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6B40593A3;
	Mon, 11 May 2026 17:03:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id quT9N/QLAmrDAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 11 May 2026 17:03:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8C98FA079E; Mon, 11 May 2026 19:03:41 +0200 (CEST)
Date: Mon, 11 May 2026 19:03:41 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
Message-ID: <rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-15-jack@suse.cz>
 <87pl32yq2a.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pl32yq2a.fsf@mail.parknet.co.jp>
X-Spam-Flag: NO
X-Spam-Score: -2.30
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
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,gmail.com,mit.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Mon 11-05-26 23:32:45, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > Use mmb inode buffer writeout infrastructure to reliably write out
> > inode's buffer on fsync(2).
> 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/fat/inode.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> > index 28f78df086ef..4ca00b7a618b 100644
> > --- a/fs/fat/inode.c
> > +++ b/fs/fat/inode.c
> > @@ -907,6 +907,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
> >  	}
> >  	spin_unlock(&sbi->inode_hash_lock);
> >  	mark_buffer_dirty(bh);
> > +	MSDOS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
> 
> When inode position was changed/removed, this will point the wrong
> block. And maybe sync a unrelated block and wait.

So I didn't realize that e.g. rename does change the backing inode block.
But given we set i_metadata_bhs.inode_blk on each inode write, inode_blk
should always contain the current position where the inode was written so
fsync should be syncing the right block. Or am I still missing something?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
