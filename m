Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DAB3E3150
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 13:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774360354; cv=none; b=Iz2UJEcelEHVN3MYhtMuB/1Pf4ielqP3q6aosfeztl+K2zKktfQ3rJfozl6mG4cisuDsu62NqKSFrkuFB3MCCRjS3hhQQBg+XWa26gyzV7FeT3tLesXot4IqGAI4VW88hhjJVyPekK5V/bwTNaaY3Wzxue0pJpYQKCIKsR0uDaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774360354; c=relaxed/simple;
	bh=UT6CWXv4BidstC/EImQRHW6izHfpZi0TlMnQCoZdy8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ArNKDkLil0JdZMk9W5sf0oCTzuKQ0MtX/qWywyL1sXxVDBwFX73TlUOw+aUu48+5pEIGQ4QAVVXkFHBQu+ZoT14b9dR+MYY4a0Qun6zf+nB+RTu/lFcUK11bGw3K8wplj8LvsH9WpEFtd0nOS1P/JJUC49oyQszRzsd9fVThd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QcOMDL4E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e1ks+Msg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QcOMDL4E; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=e1ks+Msg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QcOMDL4E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e1ks+Msg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QcOMDL4E";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="e1ks+Msg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DD7C5BCEB;
	Tue, 24 Mar 2026 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774360351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzUJiK0Jsd8W2FOeN2md5b65aVTohx0lmkYKrmYqfqU=;
	b=QcOMDL4EM9+hNA9dbdnc8iKYUCqyHZiULcfMXNDjc7xg/EoncK6vGA0cx+pZm12ydkssn4
	DOcpIFGLhZ9A1xMO/+zMzzp5nKYGr5zmAabfXp6iaXrxgO9lZwxZVOb3nvlqq4wwVqJCBO
	KzzCkH13I7xGKyLz4cskj4quEgZUIwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774360351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzUJiK0Jsd8W2FOeN2md5b65aVTohx0lmkYKrmYqfqU=;
	b=e1ks+MsgWq9SlBuE8S4aLtlwMm4KTxQDWFXcZBrC6Zlg+QsxH0gkF/nequei490wwT5BLa
	TLgwNz7Ql443kuAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QcOMDL4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=e1ks+Msg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774360351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzUJiK0Jsd8W2FOeN2md5b65aVTohx0lmkYKrmYqfqU=;
	b=QcOMDL4EM9+hNA9dbdnc8iKYUCqyHZiULcfMXNDjc7xg/EoncK6vGA0cx+pZm12ydkssn4
	DOcpIFGLhZ9A1xMO/+zMzzp5nKYGr5zmAabfXp6iaXrxgO9lZwxZVOb3nvlqq4wwVqJCBO
	KzzCkH13I7xGKyLz4cskj4quEgZUIwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774360351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wzUJiK0Jsd8W2FOeN2md5b65aVTohx0lmkYKrmYqfqU=;
	b=e1ks+MsgWq9SlBuE8S4aLtlwMm4KTxQDWFXcZBrC6Zlg+QsxH0gkF/nequei490wwT5BLa
	TLgwNz7Ql443kuAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74E8B43E87;
	Tue, 24 Mar 2026 13:52:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CK+FHB+XwmmPQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:52:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 360E8A0B32; Tue, 24 Mar 2026 14:52:23 +0100 (CET)
Date: Tue, 24 Mar 2026 14:52:23 +0100
From: Jan Kara <jack@suse.cz>
To: Milos Nikic <nikic.milos@gmail.com>
Cc: jack@suse.cz, tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>, 
	Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v5 1/2] jbd2: gracefully abort instead of panicking on
 unlocked buffer
Message-ID: <au4akf3qdluvblskpk4vjz4ylav7ykjubngthqcfhknswlh3kl@qrukgpcr5u6c>
References: <20260304172016.23525-1-nikic.milos@gmail.com>
 <20260304172016.23525-2-nikic.milos@gmail.com>
 <CAOeJtk8hrcM6NR73Xo5++aU_ZXyM8GvN7U44iA-rJdp0evhrpQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOeJtk8hrcM6NR73Xo5++aU_ZXyM8GvN7U44iA-rJdp0evhrpQ@mail.gmail.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7DD7C5BCEB

Hello!

On Mon 23-03-26 14:50:00, Milos Nikic wrote:
> Just sending a gentle ping on this v5 series from March 4th.
> It looks like both patches have collected Reviewed-by tags from Jan,
> Andreas and Zhang.
> 
> Please let me know if there is anything else you need from my side, or
> if this is good to be queued up in the ext4 tree for the next merge
> window.

Ted Tso is generally picking jbd2 patches. Since this is a cleanup, I
expect him to pick up this patch for the next merge window - i.e., in a
week or two :)

								Honza

> 
> Thanks, Milos
> 
> On Wed, Mar 4, 2026 at 9:20 AM Milos Nikic <nikic.milos@gmail.com> wrote:
> >
> > In jbd2_journal_get_create_access(), if the caller passes an unlocked
> > buffer, the code currently triggers a fatal J_ASSERT.
> >
> > While an unlocked buffer here is a clear API violation and a bug in the
> > caller, crashing the entire system is an overly severe response. It brings
> > down the whole machine for a localized filesystem inconsistency.
> >
> > Replace the J_ASSERT with a WARN_ON_ONCE to capture the offending caller's
> > stack trace, and return an error (-EINVAL). This allows the journal to
> > gracefully abort the transaction, protecting data integrity without
> > causing a kernel panic.
> >
> > Signed-off-by: Milos Nikic <nikic.milos@gmail.com>
> > Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> > ---
> >  fs/jbd2/transaction.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index dca4b5d8aaaa..04d17a5f2a82 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -1302,7 +1302,12 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
> >                 goto out;
> >         }
> >
> > -       J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
> > +       if (WARN_ON_ONCE(!buffer_locked(jh2bh(jh)))) {
> > +               err = -EINVAL;
> > +               spin_unlock(&jh->b_state_lock);
> > +               jbd2_journal_abort(journal, err);
> > +               goto out;
> > +       }
> >
> >         if (jh->b_transaction == NULL) {
> >                 /*
> > --
> > 2.53.0
> >
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
