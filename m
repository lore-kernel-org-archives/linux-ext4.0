Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60303ED5C6
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774355084; cv=none; b=OWgrcwAI06VgVK3r0pBwNpuULxv0pAc5Oac/EjhUyFlRsOCbu64oKd0b+0sRxEdsr0UBo48CD4I2V9xqQc0M66Nsro7nb/7sC5PI/UQFzke9WI1o+iPxWdJSNFOW39BbP2YUZhsrYJwVmBUkMks8QfIWZCFx6eBsroTh2x4OflE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774355084; c=relaxed/simple;
	bh=wcKp3Pl6pRVT+gdKTViHzJQVRzFzEiMUCXFNpOqaGZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fokKeq/OJS9yGyiG8DAE8sgYSMAcffQWdRTqNlznzreFw91eA5A97RvLNyNQb+3/IZIwz6pR1Glm2jwQPwuDP3Jiqczcx2LYpHUTA8AYC2rdbtfwwOcZlLwvk3GTqh9UTcENXvKeVFetm14Wa2xhMNjIuFNxQx1eWC1BXZiTfY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DpuXonCA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6SYWk5aM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DpuXonCA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=6SYWk5aM; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DpuXonCA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6SYWk5aM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DpuXonCA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="6SYWk5aM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2013C4D1EF;
	Tue, 24 Mar 2026 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=DpuXonCAJTnmzxmj7MYbY7fs9pYY7omNJcSCIeYO8vB/nirZ6rHkpsPPK6KxHnhDmUaNcx
	L9NYifeiZINqnAQPnQP4yF8eVcWsd9IH2qPE4MRdxtElllkN57VVCmTz6ZDKe5PhJ3CAE6
	YbFFFBfBGzgnBvfVWXaGaxBpD7hbiMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=6SYWk5aMcCZU0dZjkafUYdIcw0wAXHlJNIYRYpyQzUAft1K5VtU3yc6xBmNukWXDq58f2m
	I4A9UHrmX26DjBDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=DpuXonCAJTnmzxmj7MYbY7fs9pYY7omNJcSCIeYO8vB/nirZ6rHkpsPPK6KxHnhDmUaNcx
	L9NYifeiZINqnAQPnQP4yF8eVcWsd9IH2qPE4MRdxtElllkN57VVCmTz6ZDKe5PhJ3CAE6
	YbFFFBfBGzgnBvfVWXaGaxBpD7hbiMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KgoKi1OgCdZcZFP6Et5CX7iK1EIpccqv7UhF6gHfaM8=;
	b=6SYWk5aMcCZU0dZjkafUYdIcw0wAXHlJNIYRYpyQzUAft1K5VtU3yc6xBmNukWXDq58f2m
	I4A9UHrmX26DjBDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1451A43E2D;
	Tue, 24 Mar 2026 12:24:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JhfqBImCwmlEZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:24:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B81D6A0B32; Tue, 24 Mar 2026 13:24:36 +0100 (CET)
Date: Tue, 24 Mar 2026 13:24:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Message-ID: <lrkdrgbiyaxn4lkpsxcrb4pbuoxcxzz6k3wvafp3ffg5xtenbr@edag7ovfmzi2>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-49-jack@suse.cz>
 <acIjQVRICiVBndVr@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIjQVRICiVBndVr@infradead.org>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Mon 23-03-26 22:38:09, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:03PM +0100, Jan Kara wrote:
> > UDF uses metadata bh list attached to inode. Switch it to
> > generic_buffers_fsync() instead of generic_file_fsync().
> 
> Can you explain this a bit more?  Right now the only difference between
> generic_file_fsync and generic_buffers_fsync is that the former takes
> i_rwsem and the other does not.  I'd expect the commit log to explain
> why dropping the lock is safe and desirable.
> 
> Same for the other similar patches.

Yeah, I was a bit sloppy with the explanation here and put it only into the
last patch 41. If we move that patch early in the series, explanations
won't be needed which is a good thing I guess.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
