Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70D4238C0D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Mar 2026 08:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774515273; cv=none; b=gNi2qc61j4y/fxM2OcMalma8iogizrvUEsPmj8hCyEjH+htAShiJqsotHnjtKkkF3G1LwtZwhTIU5/lLhsl9bj2BzXeBw5TCdWVihHYJW5m0+h8Yt6vh1EMrS1i8Fw3FMNQTShx6QYysuU2CTceC9zG2pFVRv545X+WBmEB7kOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774515273; c=relaxed/simple;
	bh=uiiNx1ZWyQEXD/kufQhoH8rlHz/F3kdTSsVp4B2lvpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qAgCjq6VfwtSStPQwpHvPy24MFuwPmuIyDO4iYwrOY5dn8ay6Se6Sv2rhi6sYeq/FIgP7bid0UYXFsURgKRQxyrs6aWOz6v1PupixzMOM7YZSjpBxKc5nxWgDuV3JyWy6g/hrilvsMDeDCzs5CIfc/6EDFVmWca5W1Fv83N2TL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CS3CDIxY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=okCg2k1+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CS3CDIxY; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=okCg2k1+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CS3CDIxY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="okCg2k1+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CS3CDIxY";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="okCg2k1+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6A9A04D1D6;
	Thu, 26 Mar 2026 08:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774515270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Br44nmkxCVytNQXFn847Bbh23FzkCfmi1y/mW25/n5c=;
	b=CS3CDIxYNLeLDIMOI2/0+Gjngz/mZq4ADmSppj4MMQb9wzi6k8wQzgiftEIXtUlrLr9byw
	xKXsOvJ7ItRckzLe0vzNJSgJvrk5RraInUgTC40kuEO0f5W4lSwGuk8Rg9Z0unsSjut0hq
	AmcDm6nDI/WRbkDdeSiG5KQREFtAZiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774515270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Br44nmkxCVytNQXFn847Bbh23FzkCfmi1y/mW25/n5c=;
	b=okCg2k1+PkkidYVrmf+qra0iY3l4V5VCHHC6IMwmBs3QvU2K0uyp/NR5/T6E3FQWwrrmBN
	BIdid14NL9KB1DCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CS3CDIxY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=okCg2k1+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774515270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Br44nmkxCVytNQXFn847Bbh23FzkCfmi1y/mW25/n5c=;
	b=CS3CDIxYNLeLDIMOI2/0+Gjngz/mZq4ADmSppj4MMQb9wzi6k8wQzgiftEIXtUlrLr9byw
	xKXsOvJ7ItRckzLe0vzNJSgJvrk5RraInUgTC40kuEO0f5W4lSwGuk8Rg9Z0unsSjut0hq
	AmcDm6nDI/WRbkDdeSiG5KQREFtAZiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774515270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Br44nmkxCVytNQXFn847Bbh23FzkCfmi1y/mW25/n5c=;
	b=okCg2k1+PkkidYVrmf+qra0iY3l4V5VCHHC6IMwmBs3QvU2K0uyp/NR5/T6E3FQWwrrmBN
	BIdid14NL9KB1DCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 624524A0A3;
	Thu, 26 Mar 2026 08:54:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 95T0F0b0xGlkFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 08:54:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 28A5CA0976; Thu, 26 Mar 2026 09:54:15 +0100 (CET)
Date: Thu, 26 Mar 2026 09:54:15 +0100
From: Jan Kara <jack@suse.cz>
To: Gerald Yang <gerald.yang@canonical.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	linux-ext4@vger.kernel.org, gerald.yang.tw@gmail.com
Subject: Re: [PATCH] ext4: Fix call trace when remounting to read only in
 data=journal mode
Message-ID: <si7uicc6vntron5s64lt5fzcubizryshxeafdeysqdid2xfmfx@mrjpfbddtdqk>
References: <20260128074515.2028982-1-gerald.yang@canonical.com>
 <4u2l4huoj7zsfy2u37lgdzlmwwdntgqaer7wta7ud3kat7ox2n@oxhbcqryre3r>
 <CAMsNC+s1R-AUzhe80vjxYCSRu0X9Ybp33sSMHGHKpBL6=dG2_w@mail.gmail.com>
 <bycdopvwzfaskilhk3nsljuk3gkztvoa3is466a6utuj2lozmj@pxf44ulcnqup>
 <CAMsNC+ve3dRwT1xGWB0pvBJXqBpeksf7PgbEeihcnfs=AmwVRQ@mail.gmail.com>
 <gluj62pw5pu7ag2juf5ejwsr3ghvckag7wh4zunwyk57slcrmg@42of57gybigz>
 <tmtgzmvkfag4r6lbt4i2ej5ad3bfudezcm35l27ybit25r7l4d@5o2i4cuymh5j>
 <CAMsNC+svSX9AiZbs1dd4qigZqBuOjuCHOjpyXzgaO0sNLUHDYA@mail.gmail.com>
 <CAMsNC+vQceRaw9DkbQFo1p2piwcwDbTgohqt=Gtqj27n42kLTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMsNC+vQceRaw9DkbQFo1p2piwcwDbTgohqt=Gtqj27n42kLTQ@mail.gmail.com>
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
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,vger.kernel.org,gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 6A9A04D1D6
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

Hi!

On Thu 26-03-26 09:50:39, Gerald Yang wrote:
> I'd like to ask when this will land in upstream kernel? Thanks.

Well, this is more a question to Ted. He didn't pick up the patch [1] to
his tree yet. I guess he'll pick it up for the next merge window which will
start in two weeks or so.

								Honza

[1] https://lore.kernel.org/linux-ext4/20260205092223.21287-2-jack@suse.cz/

> 
> On Thu, Feb 5, 2026 at 8:59 PM Gerald Yang <gerald.yang@canonical.com> wrote:
> >
> > Thanks Jan for fixing this issue, I can confirm the patch works for me too.
> >
> >
> > On Thu, Feb 5, 2026 at 5:25 PM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Tue 03-02-26 15:50:43, Jan Kara wrote:
> > > > Hello,
> > > >
> > > > On Fri 30-01-26 19:38:55, Gerald Yang wrote:
> > > > > Thanks for sharing the findings, I'd also like to share some findings:
> > > > > I tried to figure out why the buffer is dirty after calling sync_filesystem,
> > > > > in mpage_prepare_extent_to_map, first I printed folio_test_dirty(folio):
> > > > >
> > > > > while (index <= end)
> > > > >     ...
> > > > >     for (i = 0; i < nr_folios; i++) {
> > > > >         ...
> > > > >         (print if folio is dirty here)
> > > > >
> > > > > and actually all folios are clean:
> > > > > if (!folio_test_dirty(folio) ||
> > > > >     ...
> > > > >     folio_unlock(folio);
> > > > >     continue;       <==== continue here without writing anything
> > > > >
> > > > > Because the call trace happens before going into the above while loop:
> > > > >
> > > > > if (ext4_should_journal_data(mpd->inode)) {
> > > > >     handle = ext4_journal_start(mpd->inode, EXT4_HT_WRITE_PAGE,
> > > > >
> > > > > it checks if the file system is read only and dumps the call trace in
> > > > > ext4_journal_check_start, but it doesn't check if there are any real writes
> > > > > that will happen later in the loop.
> > > > >
> > > > > To confirm this, first I added 2 more lines in the reproduce script before
> > > > > remounting read only:
> > > > > sync      <==== it calls ext4_sync_fs to flush all dirty data same as what's
> > > > >                          called during remount read only
> > > > > echo 1 > /proc/sys/vm/drop_caches       <==== drop clean page cache
> > > > > mount -o remount,ro ext4disk mnt
> > > > >
> > > > > Then I can no longer reproduce the call trace.
> > > >
> > > > OK, but ext4_do_writepages() has a check at the beginning:
> > > >
> > > >         if (!mapping->nrpages || !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
> > > >                 goto out_writepages;
> > > >
> > > > So if there are no dirty pages, mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)
> > > > should be false and so we shouldn't go further?
> > > >
> > > > It all looks like some kind of a race because I'm not always able to
> > > > reproduce the problem... I'll try to look more into this.
> > >
> > > OK, the race is with checkpointing code writing the buffers while flush
> > > worker tries to writeback the pages. I've posted a patch which fixes the
> > > issue for me.
> > >
> > >                                                                 Honza
> > > --
> > > Jan Kara <jack@suse.com>
> > > SUSE Labs, CR
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
