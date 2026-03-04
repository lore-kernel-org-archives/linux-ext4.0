Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E263A2570
	for <linux-ext4@vger.kernel.org>; Wed,  4 Mar 2026 10:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772620223; cv=none; b=plpUWoyPGNVOI2mGKnbBVI23/3lPP4hBHQ4UW/+xU0SibbOkBHFiofa5K9yz6aEDDJiR/FD608MmBbZDy5tWj8xvM5SrRMWqk5t/+49vEBlFCqr/yW3JLCHxtNK2YmWwk/Cf0xy9fTCkgQlcI6bVjmfpTuWAdQV8YK8tqqqP6Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772620223; c=relaxed/simple;
	bh=7a/WUUQxacqPYN/i8eDfaudF6ynDdM6mXdn4w7XcwU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTiY2x1OywUP20SGjzEKzvfq34uo26T+wAjQGJaLSIBh3YJvHFdVpJUzdD2B46JnUUuTFGGI+tSIgT15/4L+iv0uOwhc2jtNOiKikveICk5Zhpe/OvEquq2FzYVx8Q4AtpOexxZBIl4NPVAwkLXPtFXpQOHCGl7K9lSwplFIjSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=siZp4t3A; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hRWnixAt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=sucmmmmn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yA1+3gNC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="siZp4t3A";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hRWnixAt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="sucmmmmn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yA1+3gNC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B41D45BDE4;
	Wed,  4 Mar 2026 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=siZp4t3A6Gf7DGpcxsRRqAstaAJIVoTJ994JqZJ/yzRrFrOsdoZfaoBS/Eyhe87hyvPA6V
	ACbOl0dkkPmrlELO+M4o7JsWRHqGmA/3Et7bHuhWfPXJJNQc3bJda66Hz5nrMN3c07qkn8
	brVXr3gB0cqoE93ekYMuAdwUe3mH1rU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620220;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=hRWnixAtmwxt16gQu446BAjJv3l0nr8nlvQ2Y2YP7RqDe3+cF9h8sOnCox5H4/p8I4ATlu
	9KBD82KihbPdmGBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=sucmmmmnugeUmrf/mrx7P0vgvqWX5k1t//3lGg5lXWEFgGqkO7enjSQGkoD+bl+uIrL0A1
	LzxnMykHZHeYYQ7dbmpG1Szz+IVO/cZq4nFgfrK3Kqd6rta6XPvnnxnBbXGYmTHT+XiXON
	A6tZeLKBsCIWIy+dxSwdE3CXglxjUtk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620219;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sA285zy6QvyW+5GYqPLWOMtmxarDFnIGsLox5OjCH6I=;
	b=yA1+3gNCGVL6lZ/iRstT5HJ6afRStjV0CxO209O7gedN2drYGBQdK9Tc9YwtNB62iHONEH
	X7suKX7Zsk9/HoBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A41743EA6C;
	Wed,  4 Mar 2026 10:30:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IWsNKLsJqGmFDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 10:30:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67F9AA0A1B; Wed,  4 Mar 2026 11:30:19 +0100 (CET)
Date: Wed, 4 Mar 2026 11:30:19 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <7irr5gqmatluutbkywhvom7ryzn6j7cl4sw7q2d7e5q3grd7u2@mk54kpnqbi52>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <aabqTRvKIWo2mHz1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabqTRvKIWo2mHz1@infradead.org>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[18];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,kernel.dk];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Tue 03-03-26 06:03:57, Christoph Hellwig wrote:
> > diff --git a/block/bdev.c b/block/bdev.c
> > index ed022f8c48c7..ad1660b6b324 100644
> > --- a/block/bdev.c
> > +++ b/block/bdev.c
> > @@ -420,7 +420,6 @@ static void init_once(void *data)
> >  static void bdev_evict_inode(struct inode *inode)
> >  {
> >  	truncate_inode_pages_final(&inode->i_data);
> > -	invalidate_inode_buffers(inode); /* is it needed here? */
> >  	clear_inode(inode);
> >  }
> 
> With this, bdev_evict_inode can go away as it is equivalent to the
> default action when no ->evict_inode is provided.

Good point. I'll remove bdev_evict_inode(). Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
