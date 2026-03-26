Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761BD3FE653
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774540790; cv=none; b=UHEPWWxvtxdi+Cfe/naSkxz4L6KB+buQ1iq70i6t6EmLJ9TGbHZWNA6/Ctndt1VLdVs6LIFl4HGmN8H17+1dLFH+KrMNXEAxqQUOl/Nj2ikUVaLbnWLNvwV7HZu42JwzxGW6XgbMF9WHNTWHpIjQ6CWOiMZuz6L5QeP/LYJX3G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774540790; c=relaxed/simple;
	bh=GfdS3yYDUGDzC4ZemG/hytY7Q3o0LJXpJI9x4q2PKOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GsecocBtqmRiojC7mvrkkpeOU+944XC4O0/S8kX8Dwvr7LDCQnKDkaBpgYG8USuzzJypS3EwrJItq7AbKDzSZ2k+2Q+87u77kLhLh9IbYMdvUtsCTxeT7+s1MH+V6JUR0EUdCmGVgVZ9ytNNouFj33jE0aUuKKfcgp7ZPjJBO5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mz1QYnC3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A4emIdEy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Mz1QYnC3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=A4emIdEy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mz1QYnC3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A4emIdEy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Mz1QYnC3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="A4emIdEy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2D4A5BD37;
	Thu, 26 Mar 2026 15:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774540786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBHj4y5hNCsCqHYpxymvxaPrLDSmysJJJoVO2nJdBS8=;
	b=Mz1QYnC3gijQxTmY7vUtTlEqFfepGZ5qUNmbi9BUd6nIN1eD2sEqIkkihIGOAuJHGKfcq/
	mlUpcE6x7YvAESkb53QNISZd3x5wRItqXWkgF0cFihHjpYKyDZoLukD5DscQQgEc4EIszm
	UcNyI3SchsDR6CZ0jI1hbhTmGdYJvMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774540786;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBHj4y5hNCsCqHYpxymvxaPrLDSmysJJJoVO2nJdBS8=;
	b=A4emIdEyIJjdmG3rIVPgQ3h1as6LgGOdXgFP3qTJYOq0Yd6C62j9iWrAuyUnMFaL4Fmf0s
	Mw+HPYYUqChdbDCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774540786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBHj4y5hNCsCqHYpxymvxaPrLDSmysJJJoVO2nJdBS8=;
	b=Mz1QYnC3gijQxTmY7vUtTlEqFfepGZ5qUNmbi9BUd6nIN1eD2sEqIkkihIGOAuJHGKfcq/
	mlUpcE6x7YvAESkb53QNISZd3x5wRItqXWkgF0cFihHjpYKyDZoLukD5DscQQgEc4EIszm
	UcNyI3SchsDR6CZ0jI1hbhTmGdYJvMw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774540786;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CBHj4y5hNCsCqHYpxymvxaPrLDSmysJJJoVO2nJdBS8=;
	b=A4emIdEyIJjdmG3rIVPgQ3h1as6LgGOdXgFP3qTJYOq0Yd6C62j9iWrAuyUnMFaL4Fmf0s
	Mw+HPYYUqChdbDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A691D4A0A3;
	Thu, 26 Mar 2026 15:59:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1nCgKPJXxWndAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 15:59:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 53D22A0976; Thu, 26 Mar 2026 16:59:42 +0100 (CET)
Date: Thu, 26 Mar 2026 16:59:42 +0100
From: Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	yi1.lai@linux.intel.com, stable@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH] ext4: Fix deadlock on inode reallocation
Message-ID: <l6xjwl6sxtlnshdlxenusnfvavmus26z4pad7xomwjfyu2upzc@kccsqck7nbmx>
References: <20260320090428.24899-2-jack@suse.cz>
 <CAGudoHF8zgjcKiHx75EwPmz5eTp_7yk+dh+ju4Ju2xZJqFJYvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHF8zgjcKiHx75EwPmz5eTp_7yk+dh+ju4Ju2xZJqFJYvw@mail.gmail.com>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,linux.intel.com,gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,intel.com:email]
X-Spam-Flag: NO

On Wed 25-03-26 22:07:20, Mateusz Guzik wrote:
> can this get any traction?

I've talked to Ted today and is currently picking up fixes into his tree so
we should get some action soon. Ted, here is one patch which needs either
fast-tracking to 7.0 or we need to revert a VFS change to avoid deadlocks
on ext4.

								Honza


> master as-is contains a change which uncovered the ext4 problem.
> either the deadlock needs to be fixed in time for the release or the
> other change needs to get temporarily reverted.
> 
> interested parties can find proposed revert here:
> https://lore.kernel.org/linux-fsdevel/20260316103306.1258289-1-mjguzik@gmail.com/
> 
> On Fri, Mar 20, 2026 at 10:04 AM Jan Kara <jack@suse.cz> wrote:
> >
> > Currently there is a race in ext4 when reallocating freed inode
> > resulting in a deadlock:
> >
> > Task1                                   Task2
> > ext4_evict_inode()
> >   handle = ext4_journal_start();
> >   ...
> >   if (IS_SYNC(inode))
> >     handle->h_sync = 1;
> >   ext4_free_inode()
> >                                         ext4_new_inode()
> >                                           handle = ext4_journal_start()
> >                                           finds the bit in inode bitmap
> >                                             already clear
> >                                           insert_inode_locked()
> >                                             waits for inode to be
> >                                               removed from the hash.
> >   ext4_journal_stop(handle)
> >     jbd2_journal_stop(handle)
> >       jbd2_log_wait_commit(journal, tid);
> >         - deadlocks waiting for transaction handle Task2 holds
> >
> > Fix the problem by removing inode from the hash already in
> > ext4_clear_inode() by which time all IO for the inode is done so reuse
> > is already fine but we are still before possibly blocking on transaction
> > commit.
> >
> > Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
> > Link: https://lore.kernel.org/all/abNvb2PcrKj1FBeC@ly-workstation
> > Fixes: 88ec797c4680 ("fs: make insert_inode_locked() wait for inode destruction")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/super.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > Ted, this is a regression recently introduced by VFS changes in
> > insert_inode_locked() but I think it's best fixed in ext4. If you agree, it
> > would be nice to merge this so that it makes it to 7.0 release. Thanks!
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 43f680c750ae..b8122d24c083 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1527,6 +1527,27 @@ void ext4_clear_inode(struct inode *inode)
> >         invalidate_inode_buffers(inode);
> >         clear_inode(inode);
> >         ext4_discard_preallocations(inode);
> > +       /*
> > +        * We must remove the inode from the hash before ext4_free_inode()
> > +        * clears the bit in inode bitmap as otherwise another process reusing
> > +        * the inode will block in insert_inode_hash() waiting for inode
> > +        * eviction to complete while holding transaction handle open, but
> > +        * ext4_evict_inode() still running for that inode could block waiting
> > +        * for transaction commit if the inode is marked as IS_SYNC => deadlock.
> > +        *
> > +        * Removing the inode from the hash here is safe. There are two cases
> > +        * to consider:
> > +        * 1) The inode still has references to it (i_nlink > 0). In that case
> > +        * we are keeping the inode and once we remove the inode from the hash,
> > +        * iget() can create the new inode structure for the same inode number
> > +        * and we are fine with that as all IO on behalf of the inode is
> > +        * finished.
> > +        * 2) We are deleting the inode (i_nlink == 0). In that case inode
> > +        * number cannot be reused until ext4_free_inode() clears the bit in
> > +        * the inode bitmap, at which point all IO is done and reuse is fine
> > +        * again.
> > +        */
> > +       remove_inode_hash(inode);
> >         ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> >         dquot_drop(inode);
> >         if (EXT4_I(inode)->jinode) {
> > --
> > 2.51.0
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
