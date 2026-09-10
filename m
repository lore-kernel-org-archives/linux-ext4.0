Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C244582D8;
	Thu, 10 Sep 2026 11:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038866; cv=none; b=VyslO4kmQZXRNlWrOktUGujMimKlApGWCmQeGXfiu3M/J6kGP47IsLjxv8C9WWVdVG3c9PQ6NB62FlYRbho7QR0n8CIjPunBcQdk/DhBRO1Zkk5dg3lGCS8lfzXQ1+TnF/OVgxrLG0dm+nVqforLebjBcKsf+V8suVdXkdMLWf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038866; c=relaxed/simple;
	bh=mIWqYvvr4wmShWpjh9vtn/kFNDBpC0yk77hOpP+ZaO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pb337VdRZNulO9dZS9m7M+WJLuc8cR8Q6Xh/w3ZlkRFAc6votolhQPHWtG3E1vlZPuFoiIbLSVJXhqIs5PQeY/WRZyWb3Tv70K+SGQT1dNlD/icHM7RDxKnRta/4OG+TYzoA9Dho7tNw1WZb7wlZTUHWLE4mByDN1p0wZygZiv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=1mIPhr4b; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kIV9XFzZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=oy4kXq5U; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Q99hAu+1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="1mIPhr4b";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kIV9XFzZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="oy4kXq5U";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Q99hAu+1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AFB9021B84;
	Thu, 10 Sep 2026 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789038858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FYgxcG2rQp/o3X/Px8ZDzwFq7W+7hX2lzAINnC3CS50=;
	b=1mIPhr4bF5IFje0BLZAbT0jPKiZXOmwhmKAxKn2crlYZQdrq7SQ9JWs5sGj9QiJBPhG31w
	Tkq7ZoF6jnfb16IDtvdbyMBXG2bENx4JNtgZot6uB8tZSNr68xwhtxvzuzU626MECpsHu3
	AP4rcG0Tv3J756sJy975gJjYTw443gE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789038858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FYgxcG2rQp/o3X/Px8ZDzwFq7W+7hX2lzAINnC3CS50=;
	b=kIV9XFzZYCxTftgycIWh1YDD2CQMuAPeP8YRe+Lh6NoTCMbci3u5mFm6MPn6tSZXadAhyx
	QWWWIhNTHP8IYiAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789038854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FYgxcG2rQp/o3X/Px8ZDzwFq7W+7hX2lzAINnC3CS50=;
	b=oy4kXq5UdeEhgV6bMWk9l6ShlROTZURqwpb63oXjA0OQ+/YzEXZgN2mauIFgO+JUAl9qQc
	XySj2IVmfwPGsSAwlb4aOngR6CcrPb67tMERpXasbXO8JO8Fk0UnhSHTuBTF8gq/OJAu1n
	77sM0A+7ITQl/PvpnQqjq5t3D6UkdJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789038854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FYgxcG2rQp/o3X/Px8ZDzwFq7W+7hX2lzAINnC3CS50=;
	b=Q99hAu+19l0DVAddjHe1V3IL9QiN7baixrVbzRmCsK6Juzuprgl53ur2xYJqljUx4brjWE
	VlLaN6PUrk9UYSDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 87F601321C;
	Thu, 10 Sep 2026 11:14:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DUQoIQaRompFfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 11:14:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 13C79A12EA; Thu, 10 Sep 2026 13:14:06 +0200 (CEST)
Date: Thu, 10 Sep 2026 13:14:06 +0200
From: Jan Kara <jack@suse.cz>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Srikanth Aithal <Srikanth.Aithal@amd.com>, Luca Weiss <luca.weiss@fairphone.com>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] buffer: fix NULL dereference of bh->b_folio in
 __bh_submit()
Message-ID: <m5dja33j5pa7ynhk5bmbsildujkcfjwyy3yvnhinmhlvcnsk7s@rcpnnnzhhteq>
References: <20260902013357.2815214-1-joseph.qi@linux.alibaba.com>
 <e77d4410-e7fa-4885-9d9f-6dd09fb7cebb@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77d4410-e7fa-4885-9d9f-6dd09fb7cebb@oss.qualcomm.com>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,suse.com:email,alibaba.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]

On Thu 10-09-26 10:08:55, Konrad Dybcio wrote:
> On 9/2/26 3:33 AM, Joseph Qi wrote:
> > Commit a2c924c240e7 ("buffer: set BIO_COMPLETE_IN_TASK for dropbehind
> > writeback") added an unconditional folio_test_dropbehind(bh->b_folio) in
> > __bh_submit().  But jbd2 shadow buffers have a NULL b_folio since commit
> > 5febcba29792 ("jbd2: point the shadow buffer at the frozen data
> > directly") made them point b_data at the kmalloced frozen data rather
> > than a folio.  Submitting such a buffer during journal commit oopses:
> > 
> >   BUG: kernel NULL pointer dereference, address: 0000000000000000
> >   RIP: 0010:__bh_submit.constprop.0+0x87/0x120
> >   Call Trace:
> >    jbd2_journal_commit_transaction+0x932/0x1b10
> >    kjournald2+0xb2/0x250
> > 
> > Hit by the ocfs2-testsuite fill_verify_holes test running with
> > data=writeback.
> > 
> > Dropbehind only applies to buffers backed by a folio, so skip the check
> > when b_folio is NULL.
> > 
> > Fixes: 5febcba29792 ("jbd2: point the shadow buffer at the frozen data directly")
> > Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> > Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > ---
> >  fs/buffer.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 427d8a817cd5..f46fa6413032 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -1106,7 +1106,8 @@ static void __bh_submit(struct buffer_head *bh, blk_opf_t opf,
> >  
> >  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
> >  
> > -	if (folio_test_dropbehind(bh->b_folio) && op_is_write(opf))
> > +	if (bh->b_folio && folio_test_dropbehind(bh->b_folio) &&
> > +	    op_is_write(opf))
> >  		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> 
> 
> -next has been broken for a week+ already, please pick this up..

Christian has pushed out a branch with the fixed version of the code today
so hopefully it should get fixed in linux-next soon.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
