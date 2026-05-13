Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385323E95A8
	for <linux-ext4@vger.kernel.org>; Wed, 13 May 2026 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778669156; cv=none; b=LWWtXU0CwF69rwnAuhOt07sixPpar4mIwtkeZauqfXKO6q6PZgrFbmuBGil/z9rYNIajUXeOQVnZxeXDqucfWcl+BjoUdWOvjCwa6ISOKnHHvLdoSozQwpQUOx1ithkvnqaOZ3/qhLVhmQR6ibuJBKdxG8CuOFY0g5mwxBJMSGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778669156; c=relaxed/simple;
	bh=jtJnEO1MxBeJ1DKO7dLMwQ6IXbt9KXSjtRCpjDGQZI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2rG0CwZY1VuIlBpTCvR1dUmwj4K0tBJxy0f49uKfbI1oSUI9WxKk2Ef51FpmTeTCsAAW4RFX+XQgQ0bluVIi6m7NPQrjQkaT72H5eMzTe1Hw7hhRfutair9/BkQgcUyEEVgmVkVc7toxxNN9zSjgoG4/4XcrtHBqyYlNYxa8xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V+/5nhoO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=F788WUQ5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=V+/5nhoO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=F788WUQ5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V+/5nhoO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="F788WUQ5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="V+/5nhoO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="F788WUQ5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 57CE576326;
	Wed, 13 May 2026 10:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778669153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bHOYLeNYE0wODawBNdsqrMOBQYnczA3eTPB0yU9HhU=;
	b=V+/5nhoOZIVkcoic9shV5bd/k7YAEq0JL4Qk8Gpaiwxo/s9JlfD2AQvF7ciPK/+RKvJVtZ
	XZ0Qrl2wb6+rp4gYHVVCe1HEUq1o+EpO8lWc7vKMeBVMgT12V/7DgylId8fi3v3+7v5Z/8
	+D1rRwQsX5DJ6r8k5MJkLpzPSRtV1Fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778669153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bHOYLeNYE0wODawBNdsqrMOBQYnczA3eTPB0yU9HhU=;
	b=F788WUQ5MVideGeVYgOa9onXyE5s148+uF2t4UZaxi71MQpXHxvxxjTdo2IrvaGD3UHfaJ
	xpPWrIZvinYpxdAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="V+/5nhoO";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F788WUQ5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778669153; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bHOYLeNYE0wODawBNdsqrMOBQYnczA3eTPB0yU9HhU=;
	b=V+/5nhoOZIVkcoic9shV5bd/k7YAEq0JL4Qk8Gpaiwxo/s9JlfD2AQvF7ciPK/+RKvJVtZ
	XZ0Qrl2wb6+rp4gYHVVCe1HEUq1o+EpO8lWc7vKMeBVMgT12V/7DgylId8fi3v3+7v5Z/8
	+D1rRwQsX5DJ6r8k5MJkLpzPSRtV1Fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778669153;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5bHOYLeNYE0wODawBNdsqrMOBQYnczA3eTPB0yU9HhU=;
	b=F788WUQ5MVideGeVYgOa9onXyE5s148+uF2t4UZaxi71MQpXHxvxxjTdo2IrvaGD3UHfaJ
	xpPWrIZvinYpxdAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E17E593A9;
	Wed, 13 May 2026 10:45:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rzoKE2FWBGpzOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 13 May 2026 10:45:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EA16BA0800; Wed, 13 May 2026 12:45:52 +0200 (CEST)
Date: Wed, 13 May 2026 12:45:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	aivazian.tigran@gmail.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 9/9] ext4: Use mmb infrastructure for inode buffer
 writeout
Message-ID: <sdvyxk5ieqcbxee5rxib6un3xpnsj6ngzlfhd76zkofzrtmwln@l2egplfhpjuq>
References: <20260511115725.28441-1-jack@suse.cz>
 <20260511121356.241821-18-jack@suse.cz>
 <20260511-paletten-kekse-7dc3bc394633@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-paletten-kekse-7dc3bc394633@brauner>
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,gmail.com,mail.parknet.co.jp,mit.edu];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 57CE576326
X-Spam-Level: 

On Mon 11-05-26 15:30:34, Christian Brauner wrote:
> On Mon, May 11, 2026 at 02:13:59PM +0200, Jan Kara wrote:
> > Use mmb inode buffer writeout infrastructure to reliably write out
> > inode's inode table block on fsync(2) in nojournal mode (from
> > ext4_sync_parent() and ext4_fsync_nojournal()). This significantly
> > simplifies the code as we don't have to explicitely handle inode buffer
> > writeback in ext4_write_inode() and thus we can also remove
> > sync_inode_metadata() calls from ext4_sync_parent() and
> > ext4_write_inode() call from ext4_fsync_nojournal().
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>

...

> > @@ -6348,7 +6330,11 @@ int ext4_mark_iloc_dirty(handle_t *handle,
> >  
> >  	/* the do_update_inode consumes one bh->b_count */
> >  	get_bh(iloc->bh);
> > -
> > +	if (!ext4_handle_valid(handle)) {
> > +		if (!EXT4_I(inode)->i_metadata_bhs)
> > +			ext4_inode_attach_mmb(inode);
> > +		EXT4_I(inode)->i_metadata_bhs->inode_blk = iloc->bh->b_blocknr;
> 
> The series is great overall. The only thing I think we should change is
> that we should hide this
> 
> EXT4_I(inode)->i_metadata_bhs->inode_blk = iloc->bh->b_blocknr;
> 
> behind a dedicated static inline/regular function call instead of
> open-coding it everywhere. Can then also be paired with some
> VFS_WARN_ON_ONCE() to detect garbage bh->b_blocknr.

Good point. I've created mmb_mark_inode_buffer_dirty() helper for this
matching mmb_mark_buffer_dirty() we use for standard metadata buffers. It
now also handles dirtying the buffer and synchronization with mmb_sync()
clearing the inode_blk.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
