Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D0327BEC
	for <linux-ext4@vger.kernel.org>; Tue, 28 Jul 2026 19:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267311; cv=none; b=A/FmKk1AM/wx0kyhOg3Ezy9lPaR937vznz+HuyK0h2oXkO25TnbnQFgVBbI19TS1W4rUiB8K5zKCOnjZ4i4sk9rqsBeG3D5WVlNnVdInEHpOjzZ8Ktuu2EKTQlQngbhgeGJbM7WpgP/i1VSvX5lUo3AdgPvQXwhR2XmVmD/5d5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267311; c=relaxed/simple;
	bh=CnIDFGdzNFsfMrQlaaWLbVqrhFvl3GvA65eItrT2lBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=paPpnjmxE5LStcet+4YiNcBRF9oPJeoFSHFn3bVMD3SNhQWG1ojfZ/ldNUJE1/Vst2OCAuzv/jNJDwxWTeGnieezz71Iv9Zm//FezVzzNi4LQ2xy0xaXvflaP1GHsc0YA00g4MEk4FleYkSIMlfM3b+wDnkiA743DjTryC2RdI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=v2SBOmw7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=n8zp1Q7T; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nw9agmsb; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hovwnrqV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="v2SBOmw7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="n8zp1Q7T";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nw9agmsb";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hovwnrqV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 163F87B671;
	Tue, 28 Jul 2026 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785267304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iwDBQzwF8OxmQcb69Yg4qYtWpN4zRTl6NDQNap959w8=;
	b=v2SBOmw7MNxq29bmUbkN2lVC2JzcyuYoOs79S/kqGEwHKU/1v/IAX3fkq1TdXi0mxhImws
	6CkaGf3DBcUsqOmqGhpaU3fu3KHpZMBQJZ4peUUkJ8caedhzF2biWqqaYFNxmY+9ziArzn
	xGxWFAiMfgFHXAnjJ4WAPT3DOywzuco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785267304;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iwDBQzwF8OxmQcb69Yg4qYtWpN4zRTl6NDQNap959w8=;
	b=n8zp1Q7T07cm4JdomrJKQXWUrTNSpy9qAZDRMMLC5Osugp9Rr9LBGDLWwk5wh1qVFgXEec
	AiBeyLXotaIM/1Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nw9agmsb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hovwnrqV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785267300; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iwDBQzwF8OxmQcb69Yg4qYtWpN4zRTl6NDQNap959w8=;
	b=nw9agmsbh+qfi79J25oWFhFEJwrkGmnrE2w2a3+23vgJ4A+gNEzRditdvzVbS52E2e8+cm
	5VNlcOuG7j1LdiFymt5hqmR7oSzkvf4WyT/EPfwrqPaGLRSIPnWcpXwztMzGsfT+H+z8V4
	GPZErOZhJ53T0TKt8CakRq2lcOR4Bdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785267300;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iwDBQzwF8OxmQcb69Yg4qYtWpN4zRTl6NDQNap959w8=;
	b=hovwnrqVNuony7Vl2elXpBdteOwmpQJwMnXvcgCbM9i3s3lc1naFMh9bK8fQ/bbASHvq6j
	Xhyg6vDOXfIoOACA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D526779B1;
	Tue, 28 Jul 2026 19:35:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pAs4A2QEaWoSOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Jul 2026 19:35:00 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AAA58A10B6; Tue, 28 Jul 2026 21:34:59 +0200 (CEST)
Date: Tue, 28 Jul 2026 21:34:59 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	Theodore Ts'o <tytso@mit.edu>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, linux-kernel@vger.kernel.org, 
	Baokun Li <libaokun@linux.alibaba.com>, Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ext4: turn off DAX on new files when encryption is set
Message-ID: <abfhi3sqmiwho54dxzgqgkimmbzpcmhcr6l3h7zao4hcjtn56b@fks57lxrfvxj>
References: <20260723085648.1500357-1-ojaswin@linux.ibm.com>
 <kekum3d7vakufwz75guyr5mzn6w4rujmssyom5qynpbxucbqpf@f4va7cswqspx>
 <amkAL232Q2O649r3@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amkAL232Q2O649r3@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 163F87B671
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,mit.edu,gmail.com,huawei.com,linux.alibaba.com,linux.ibm.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Wed 29-07-26 00:47:03, Ojaswin Mujoo wrote:
> On Mon, Jul 27, 2026 at 09:06:23PM +0200, Jan Kara wrote:
> > On Thu 23-07-26 14:26:48, Ojaswin Mujoo wrote:
> > > Currently, when setting the S_ENCRYPTED flag on a new regular inode in
> > > a -o dax=always mounted FS, we seem to be erroneously retaining the S_DAX
> > > flag. This is because the newly created inode ends up with the following:
> > > 
> > >   __ext4_new_inode()
> > >     ext4_set_inode_flags(init=true) // sets S_DAX
> > >       fscrypt_set_context()
> > >         ext4_set_context()
> > >           ext4_set_inode_flags(init=false) // sets S_ENCRYPTED but
> > >                                               doesn't clears S_DAX
> > >       ext4_set_aops
> > >         inode->i_mapping->a_ops = &ext4_dax_aops;
> > > 
> > > Due to the S_DAX flag, the excrypted inode gets ext4_dax_aops and it
> > > silently ends up bypassing encryption completely. This is reflected in
> > > multiple xfstests failures like generic/548. To fix this, ensure we disable
> > > S_DAX correctly when S_ENCRYPTED is being set on a newly created inode. It
> > > is safe to change DAX state there because ext4_set_aops() later can
> > > correctly detect S_DAX unset and assign the correct aops.
> > > 
> > > The fix was actually the intended behavior however it seemed to have
> > > silently changed in 043546e46dc7.
> > > 
> > > Fixes: 043546e46dc7 ("fs/ext4: Only change S_DAX on inode load")
> > > Reported-by: Disha Goel <disgoel@linux.ibm.com>
> > > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> > > ---
> > >  fs/ext4/crypto.c | 15 +++++++++++----
> > >  fs/ext4/inode.c  | 10 ++++++----
> > >  2 files changed, 17 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
> > > index f41f320f4437..2d409114e02e 100644
> > > --- a/fs/ext4/crypto.c
> > > +++ b/fs/ext4/crypto.c
> > > @@ -134,6 +134,7 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
> > >  {
> > >  	handle_t *handle = fs_data;
> > >  	int res, res2, credits, retries = 0;
> > > +	bool init = S_ISREG(inode->i_mode);
> > 
> > Hum, I have some comments: IMHO the change is confusing because the meaning
> > of 'init' argument of ext4_set_inode_flags() doesn't mean the first setting
> > of flags any longer. And the reliance on ext4_set_context() getting called
> > in a safe place exactly for regular files is rather subtle as well.
> 
> Hi Jan, thanks for the review. 
> Yes I agree the init naming and checking for ISREG is a bit hacky.
> > 
> > Also does the change to ext4_set_inode_flags() really work? As far as I'm
> > reading the ext4 crypto implementation, I don't see where we'd be setting
> > EXT4_INODE_ENCRYPT for inodes with already enabled encryption (where we
> > load the context from xattrs through ext4_get_context()) and thus DAX would
> > still get enabled for such inodes? What am I missing?
> 
> Hmm do you mean __ext4_iget() on an already encrypted inode? In that
> case raw_inode->i_flags with EXT4_ENCRYPT_FL set will get carried over
> to ei->i_flags and we will still get the right aops no? Or do you mean
> some other case?

Yes, I've realized that today when reading Eric's patch and checking how
f2fs works. But thanks for confirmation anyway :)

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
