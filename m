Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10773C2D
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 09:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834635; cv=none; b=rFfm4puclOLwTraB9D9nPqKTHKoG+CksJABiJ4qnyQ4epadERteamhcIAg1PZyCthdhVOtcEIYWaJGB35sYv/1pSIC0eu6mQI4Vw2twZIYsgxt4XLmg4eYHBz5MDFjXk6EJSfTpVTqKQmea4ODqBykSBd+S7N1FpFAB2TqdCZuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834635; c=relaxed/simple;
	bh=Dm+WcmtJIdrAlqcMuETGsawKLkar/oBEYDbnIKezgE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEOvggm6quCYbSrnccMXh/fF1n3GIO59aDYsynqApZH9h2OFDsTWbuYGRNOgNWGrm3sZd3Johuv6GSAG/zAKknLv+yhiNckDXoZHRwvkUnTr5k6sGm8H6QDybZgp86UICLHWKkJ1B0jHh8AhBHUdq0fXp8q92IV32WeUraXGJxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jc8srSpU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HDA1ogAz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EQzAouNQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=20ZRj0eN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jc8srSpU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HDA1ogAz";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EQzAouNQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="20ZRj0eN"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2ADB7F473;
	Tue,  4 Aug 2026 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUP1l0EKNMqKBUT8gCiiWMkTy9DFdU6WVJfJKomWwXw=;
	b=Jc8srSpUcQIrf5bofVJZ5IvY/hVHUmIs6izzTn6qtNnG+RIRC3OAVqqK9W16S7PnBVfRL/
	YsPycBmGAisjD6ZoL1FWjH1+TG+tf9O/mj98vIkJtXo/OVXy1UN3eIH62gb7fi/C/p4Gm4
	6LMk5HbM1SfKR7WLTX/2b/NqrI3+X4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834627;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUP1l0EKNMqKBUT8gCiiWMkTy9DFdU6WVJfJKomWwXw=;
	b=HDA1ogAzeTlw2yuJ0mO9xb5YzFlj4bgdeN6Bb0fGxb94Db26oHEcWYOLwC4xb406q6AxsJ
	FrSBuzHqFP63aaAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EQzAouNQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=20ZRj0eN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUP1l0EKNMqKBUT8gCiiWMkTy9DFdU6WVJfJKomWwXw=;
	b=EQzAouNQ0gJdMC5BQIYmrXaIa88I9G7XLFuWRhKSC+0xs4SkrQrXMWsm89TzZkJQD2jhVA
	mAmMULPHqh3bncYW2YC40j/L6IMtIb0gD0acQ4A7rexOBONQuNlH9t8bq9OyIt2m1NcZjF
	oeiUoRaHVaECGqw3R+92kKM39h2p1dU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834623;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KUP1l0EKNMqKBUT8gCiiWMkTy9DFdU6WVJfJKomWwXw=;
	b=20ZRj0eNv6zXmpi3GoFqjXxAyMXDLxIWbF5hdhM0uhKXoCDlrXfvUiWppDVRxKUSbF0MGv
	q5iuY/md+CEON2Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90CD5779BB;
	Tue,  4 Aug 2026 09:10:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KytWI3+scWpBBQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 09:10:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 18D6DA13A6; Tue, 04 Aug 2026 11:10:19 +0200 (CEST)
Date: Tue, 4 Aug 2026 11:10:19 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/19] jbd2: report journal write errors with BH_Write_EIO
Message-ID: <7qfbpj66hdtxc23lox63hqss42yo5xz2dazigf7nwdorplmec5@vv6jsnqa6viu>
References: <cover.1785621505.git.coshi036@gmail.com>
 <f0e0fd8516487b774d8cf1384949a0c616921fbd.1785621505.git.coshi036@gmail.com>
 <ppnbgcljrjb5wqqvqiyh254wkunfutydykgbi7zheuf2mfdjqv@j6lngn5vywxj>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ppnbgcljrjb5wqqvqiyh254wkunfutydykgbi7zheuf2mfdjqv@j6lngn5vywxj>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: A2ADB7F473
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Tue 04-08-26 10:54:37, Jan Kara wrote:
> On Sat 01-08-26 18:01:00, Chao Shi wrote:
> > The journal's own write completion handler,
> > journal_end_buffer_io_sync(), reports a failed write by clearing
> > BH_Uptodate, and the three places that wait for journal writes look for
> > that.  This series is removing that convention: a buffer whose write failed
> > still holds the data that was supposed to reach the disk, and saying it is
> > not up to date makes callers rewrite, re-read or WARN over data that was
> > never wrong.
> > 
> > Set BH_Write_EIO instead, with mark_buffer_write_io_error(), and test it in
> > journal_wait_on_commit_record() and in the two commit-phase waits.
> > 
> > The two changes have to go together, because commit phase 4 waits on a
> > mixed list: descriptor blocks are submitted with
> > journal_end_buffer_io_sync(), while revoke blocks go through
> > write_dirty_buffer() and land in bh_end_write().  bh_end_write() already
> > sets BH_Write_EIO, so converting the consumer alone would keep working for
> > revoke blocks and silently stop detecting failed descriptor writes.  With
> > the handler converted, both halves of the list report the same way.
> > 
> > mark_buffer_write_io_error() is safe on all of these buffers.  The shadow
> > buffers from jbd2_journal_write_metadata_buffer() have no folio and no
> > associated mapping, so it does nothing beyond setting the flag.  Descriptor
> > and commit blocks are ordinary buffers on the journal device, and marking
> > the journal's mapping with the error is what write_dirty_buffer() already
> > does for revoke blocks on the same device.
> > 
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> > ---
> >  fs/jbd2/commit.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index 60273cddf434..8912786ebebb 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -39,7 +39,7 @@ static void journal_end_buffer_io_sync(struct bio *bio)
> >  	if (uptodate)
> >  		set_buffer_uptodate(bh);
> >  	else
> > -		clear_buffer_uptodate(bh);
> > +		mark_buffer_write_io_error(bh);
> 
> There's no need to set uptodate flag here at all (all callers set it before
> submitting IO). So you can just simplify this to:
> 
> 	if (!uptodate)
> 		mark_buffer_write_io_error(bh);
> 
> Also I'd rename the local variable from 'uptodate' to 'ioerr' or something
> like that.

Sorry, not 'ioerr' but rather 'success'. I can see fs/buffer.c names it like
that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
