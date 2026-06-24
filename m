Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58AA21CFEF
	for <linux-ext4@vger.kernel.org>; Wed, 24 Jun 2026 12:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304352; cv=none; b=J+Cq1JMm6LT+/ImrjXFhsa5s//UWpZj9wYmfj3v+/3UBmEIhVdEJeJUnGMMB9yNroo3m0dM34K/RQQ37dtmfep6M8fIRehZjMx/7Qwk+UeQWtxSthWqe5w3nbqPwYKhTx4xmeDlb8zCOhyQemlrrVhXKAL6XSBsrYBLrK/QmCiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304352; c=relaxed/simple;
	bh=ZSMr8n96tP8DyCeppXBS+NQeIVlOq3SLEbuhMFbmMO0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFkA0iAGGY98NHY6MDje2Le/dejYSp6IAuWHWFtxCTW1RjmYS+VvIF4ujQp7MVgqZl0fyhQL2A5I86BdD5tyPa8O4gtyA1zL2+Cj2gFpyWEQh8FDTND+lJhhlNpi2zM8G+1BePst+arVadyVD4GTm6Cr36biBnRxV8Okazt5aRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pNZE7KcU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ERgFW1Oh; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=fOEBBgZr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=/bNkphOy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pNZE7KcU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ERgFW1Oh";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="fOEBBgZr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="/bNkphOy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00A1E714A9;
	Wed, 24 Jun 2026 12:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782304349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwB4l2OR8lhh3BMI8+CAcTC8ICNaMX1A67tCtlbObLo=;
	b=pNZE7KcUuHptn87lw24CIujC0bzCEqaO9aEeVBzTaBNLpFXbE1vdgOmWMFGbu+N2jTrG49
	B6NUHcgYdW4B0Rk4yR8S9V+LECqklSsH6r0lmOlaH/HsDSQQXbTvFhvUuMFP2N3PSnlq+W
	VoYvlpoJN9JEcWZWmyFL0J9TCUWUWY0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782304349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwB4l2OR8lhh3BMI8+CAcTC8ICNaMX1A67tCtlbObLo=;
	b=ERgFW1OhVetjqcj6Sa25xyfTWQ2uHGxJRaMXb925uTtd2Be2Ius1uSA/AESUtI5NNJURPl
	OYq2UF09OIFRouDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782304348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwB4l2OR8lhh3BMI8+CAcTC8ICNaMX1A67tCtlbObLo=;
	b=fOEBBgZrVW8blFX63lLmWOHxcMUglIej2TbAeZ7tlac5wDG9Skh+0qBno2MdoS+S7YMSnx
	s/upk4EVdj5ImJdfq+e8GNSL0rKsL1FaOnAwLhKN4xitKmOimyc4euZkE6B3cXS5Ckzhzs
	lKaE54Uu5e3CKdOqWGalPTMOnAcGgSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782304348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mwB4l2OR8lhh3BMI8+CAcTC8ICNaMX1A67tCtlbObLo=;
	b=/bNkphOynAPQw5yHtSWEbC17sWB4BNN4yBkE7k5/zDbstXBoMbdoKl7joX3XNBJazq+bYg
	5i797Rw6SeHPimBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA44F779A8;
	Wed, 24 Jun 2026 12:32:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6BgpOVvOO2pBUAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 24 Jun 2026 12:32:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 954B8A093E; Wed, 24 Jun 2026 14:32:27 +0200 (CEST)
Date: Wed, 24 Jun 2026 14:32:27 +0200
From: Jan Kara <jack@suse.cz>
To: Zhu Jia <zhujia.zj@bytedance.com>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
Message-ID: <x3jm3mhgsr7zx4hvfgdvmwoqyz5vxx2fjyxy6gs6him46767f6@dkkirnw54x6x>
References: <20260623094947.7853-1-zhujia.zj@bytedance.com>
 <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
 <20260624094535.1-zhujia.zj@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624094535.1-zhujia.zj@bytedance.com>
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
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[huaweicloud.com,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Wed 24-06-26 17:52:06, Zhu Jia wrote:
> Hi Yi,
> 
> Thanks for taking a look.
> 
> Yes, clearing PAGECACHE_TAG_DIRTY/TOWRITE would make the page-cache state
> cleaner. I had a version that did this by adding a helper around
> folio_cancel_dirty() and clearing the xarray tags after confirming the
> folio was still the same clean page-cache entry.
> 
> It looked like this:
> 
> static void ext4_cancel_dirty_folio(struct address_space *mapping,
> 				    struct folio *folio)
> {
> 	XA_STATE(xas, &mapping->i_pages, folio->index);
> 	unsigned long flags;
> 
> 	folio_cancel_dirty(folio);
> 
> 	xas_lock_irqsave(&xas, flags);
> 	if (xas_load(&xas) == folio && !folio_test_dirty(folio)) {
> 		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
> 		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
> 	}
> 	xas_unlock_irqrestore(&xas, flags);
> }
> 
> The reason I left the tags unchanged in this version is that I was not sure
> whether it is appropriate for ext4 to open-code xarray tag cleanup directly.
> 
> If you think this is the right direction, I can add the helper back and
> send a v2.

That was a good judgement! Playing with xarray tags like this in filesystem
code is certainly not a good thing. For now, I'd leave the xarray tags
dangling - they will be eventually synced with reality on next writeback
attempt. If this inconsistency of tags needs to be fixed, the fix belongs
to the generic code (so that it can be used in other places as well).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
