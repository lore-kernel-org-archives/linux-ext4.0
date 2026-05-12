Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939F247CC97
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2026 07:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778571011; cv=none; b=uih7hnAVAlAvofEu0E6GVFkoTZnLvI8RIZlzc4m2dp7+Qo4wuuagDuAHZWKORkIpmIlPacBd/XvuqbNodZ46at9ErT5OaHjFFMoxaUMry32tGHQjzVgTKeEchrJbsRD92IFDZfh49Jz1WclEVzVvjJSpcSYOJzzm7xbXBYoN60c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778571011; c=relaxed/simple;
	bh=V2T2q35qC+0SmyTemCkhPffJ/YpEW2krA3L3sNjc1Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BZ/z9Lzu0G5Kqa3XYPCoGSP5dedc+h1h9h7CCCGim+YKmcV9haM594mEKAoTJbrL5cGnkvQPmfkwDlZmYTB5dzstcjhqZVcZpwQSYPFG+0OB6DPC6szMCGuO1ZUEWo7AcdpayV8iVKvVKwxBKaeuzqyRNYH9ftj8s+1Dkii2RGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXi29eo5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ynHj0xYJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MXi29eo5; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ynHj0xYJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXi29eo5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ynHj0xYJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MXi29eo5";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ynHj0xYJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13BD361F4A;
	Tue, 12 May 2026 07:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8pMZB3vTalJTQxF5w7iA9BY5NB2AkVeTgbYumXjTTk=;
	b=MXi29eo5tPGF4g7eW7Iyrw4Tippc3/tfMBJvwWyON9aVu1mAGGv6g74cj3GdsUqQcR+FG3
	BomRvnxYBlsbTDGCAaOjH4M4nhc/hdVEPIDwSwLpXztEgoV4RvfXhNQh+Iyu28jhIn8iZZ
	sB+gLkpE68ggue3o+DhdPsLy77v7lR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8pMZB3vTalJTQxF5w7iA9BY5NB2AkVeTgbYumXjTTk=;
	b=ynHj0xYJ2ycUkp0Gv76B9N7Voy0LAgZ8ZgaYcxdQp1n+oitMc6NE/oq9+d6EpswSW2Kmh4
	OegK9MCQhzUlAsCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8pMZB3vTalJTQxF5w7iA9BY5NB2AkVeTgbYumXjTTk=;
	b=MXi29eo5tPGF4g7eW7Iyrw4Tippc3/tfMBJvwWyON9aVu1mAGGv6g74cj3GdsUqQcR+FG3
	BomRvnxYBlsbTDGCAaOjH4M4nhc/hdVEPIDwSwLpXztEgoV4RvfXhNQh+Iyu28jhIn8iZZ
	sB+gLkpE68ggue3o+DhdPsLy77v7lR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d8pMZB3vTalJTQxF5w7iA9BY5NB2AkVeTgbYumXjTTk=;
	b=ynHj0xYJ2ycUkp0Gv76B9N7Voy0LAgZ8ZgaYcxdQp1n+oitMc6NE/oq9+d6EpswSW2Kmh4
	OegK9MCQhzUlAsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0BB96593A9;
	Tue, 12 May 2026 07:30:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LJLWAv3WAmoSQQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 07:30:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9DAF6A093D; Tue, 12 May 2026 09:29:56 +0200 (CEST)
Date: Tue, 12 May 2026 09:29:56 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, aivazian.tigran@gmail.com, Ted Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH 6/9] fat: Fix possibly missing inode write on fsync(2)
Message-ID: <jb536ihpuajtk4dcpxquos5fmmllfs7uiq3ryvnsfl4tesiidj@jwhnlrdiaih3>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-15-jack@suse.cz>
 <87pl32yq2a.fsf@mail.parknet.co.jp>
 <rnl552jwa6x72ibx3sg2oeitn6sh6jp5tnfu7evycol2fopw7v@ahwlfjnuoiwy>
 <87v7ctddui.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7ctddui.fsf@mail.parknet.co.jp>
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	URIBL_BLOCKED(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,gmail.com,mit.edu];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30

On Tue 12-05-26 03:02:13, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Mon 11-05-26 23:32:45, OGAWA Hirofumi wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> > Use mmb inode buffer writeout infrastructure to reliably write out
> >> > inode's buffer on fsync(2).
> >> 
> >> > Signed-off-by: Jan Kara <jack@suse.cz>
> >> > ---
> >> >  fs/fat/inode.c | 3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> >> > index 28f78df086ef..4ca00b7a618b 100644
> >> > --- a/fs/fat/inode.c
> >> > +++ b/fs/fat/inode.c
> >> > @@ -907,6 +907,7 @@ static int __fat_write_inode(struct inode *inode, int wait)
> >> >  	}
> >> >  	spin_unlock(&sbi->inode_hash_lock);
> >> >  	mark_buffer_dirty(bh);
> >> > +	MSDOS_I(inode)->i_metadata_bhs.inode_blk = bh->b_blocknr;
> >> 
> >> When inode position was changed/removed, this will point the wrong
> >> block. And maybe sync a unrelated block and wait.
> >
> > So I didn't realize that e.g. rename does change the backing inode block.
> > But given we set i_metadata_bhs.inode_blk on each inode write, inode_blk
> > should always contain the current position where the inode was written so
> > fsync should be syncing the right block. Or am I still missing something?
> 
> I didn't check the case of rename completely, just recalled it when I
> saw this code, need confirm/check.  But at least, the case of remove
> will leave it even after the block is reused.

Right. fat_detach() should set i_metadata_bhs.inode_blk to INVALID_BLK,
thanks for catching that. I was thinking whether we should set
i_metadata_bhs.inode_blk in fat_attach() instead of during inode dirtying.
It would be somewhat more obviously correct but it could lead to
unnecessary flushing in case the directory block gets dirtied by some other
entry in it while the inode we are fsyncing got never dirtied. IMHO that's
a sensible tradeoff so I'd do that but what is your opinion?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
