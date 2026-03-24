Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8F83FADEC
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774358924; cv=none; b=Jym5aoclAlWk0cQjHOPtiFwBl7YVc6sUd5gnJugXvkqlZHxH2qIX5c0wWCX5/a7ShllD1ILJADPtGanNTt3DE7WqUNXo8exQfwe8Xdz1PxFiu0aBSyuqndkYOk8IR/xt9li3Hxa6DoUH5BrBJ3AZmcEDGYl4T+ILncSL9mMoKas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774358924; c=relaxed/simple;
	bh=B2h/TfC0Ylohel8ZsnXPPff62Ryq0BfS/E9ti0u6gIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DubNzVxVKAt8lOCyAckefDVxfSlDCmRbZrvxXrBokhArm/dlZdpDe2Qn5XTXbcUhmUcZxSjB7NwT4mWnIxOBvMr/wEb5EGQ4vXTTy2s9B5TQ/HRTBeyhHlC9cnUmkXoMJAPNRcRRZd0gDMXpB4jXLmh9okIw4N7D38imCnclZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=VLRhQVNO; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=focKEBP0; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=aajPyr8d; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=rX7EZ+XB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="VLRhQVNO";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="focKEBP0";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="aajPyr8d";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="rX7EZ+XB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8A874D201;
	Tue, 24 Mar 2026 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774358919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=VLRhQVNOMcakGuxjD8XRZHoDsUzpel+Uj1r1dyAM9I7mjwv7UUc0n0BtxtcQj45GzEoSa3
	w8IVlKC0+QGFIzcZuWkDc4gPz+GVN7igKmsARilZohmARyqIbsG8PzFgP2Q5ZskHHb4rfN
	Fhy+EgK4nv8TEu/ajnfijmqjEB5rut0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774358919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=focKEBP0E3pHdlM7sQULbEwzuzvsQPBrqJvzjKKxJjgmQRMQxA1cmNw7bSloelqOY2i2Yu
	CBY9LLry/9DKcHBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aajPyr8d;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rX7EZ+XB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774358918; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=aajPyr8dL2qXEsc5Nma+UUjmL2g2Yg0vA3FN+G85F9wgq4nh1awYXZRDhWxWI31rOCmnIc
	RJq/NmYC6euUAJlHHI4ZOzn3ZrAX/WbuMLkXcKWCNYgZwt8GeG7PNImf9dgShKN3MXp+sh
	4HpgyX1kPaqVsdGto9mQ6PgJEAm56gc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774358918;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ppEkS3HSTzVrSRJgJOCc3F5Y6HfE24KCj/2LLh4oC7w=;
	b=rX7EZ+XBlJoOpiXR19mqVLEUK/Q6yZAGakQOxocTCViQTVOBeydbsz4kWJaPCS4a8eu6Ik
	37B2Y9+w5aqtDNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CBDBB43E6D;
	Tue, 24 Mar 2026 13:28:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id f+C+MYaRwmniKQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:28:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8D106A0B32; Tue, 24 Mar 2026 14:28:34 +0100 (CET)
Date: Tue, 24 Mar 2026 14:28:34 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 41/41] fs: Unify generic_file_fsync() with mmb methods
Message-ID: <k5422gxvhqqmabpf6csub7opo3vbacvibaqwwigzx7t3b65vna@jzh35hxc4jz7>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-82-jack@suse.cz>
 <acInjoDTJAz62eUp@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acInjoDTJAz62eUp@infradead.org>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D8A874D201

On Mon 23-03-26 22:56:30, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:36PM +0100, Jan Kara wrote:
> > Taking inode lock when writing out the inode seems pointless in
> > particular because there are lots of places (most notably sync(2) path)
> > that don't do that so hardly anything can depend on it.
> 
> This is really something that needs to stand out clearly for bisecting
> and documentation.  I.e. make this a patch on its own and preferably
> before all the other refactoring that already is affected by moving
> between the implementations at the beginning of the series.
>
> > So let's remove __generic_file_fsync() and use
> > generic_mmb_fsync_noflush() instead to reduce code duplication. Arguably
> > this leaks a bit of buffer_head knowledge into fs/libfs.c which is not
> > great but avoiding the duplication seems worth it.
> 
> You could just pass a callback to the generic version.  The cost of an
> indirect call should not matter compared to the rest of the fsync code.
> That would also be a nice thing before all the renaming, as that means
> we could add the version with the callback first to unify the
> implementations and then the file systems are switched away from
> the buffers fsync variant to explicitly pass a callback, or to not
> pass a callback when they currently get the default one.

OK, makes sense. I can put the patch removing inode_lock from
__generic_file_fsync() at the place in the series where we start
dealing with fsync handlers. Then I'd introduce fsync variant with the
callback and then convert filesystems. As I was thinking about it, it would
be natural for the callback to be called sync_metadata and handle
writeout of the metadata including the inode. That would actually simplify
life in the following series I wanted to write which will make sure that
fsync properly writes out & waits for the buffer head containing the inode
(currently if background flush work happens to write inode first, buffer
head is not written to the backing device during fsync). And if the
callback isn't provided, we'd just write out the inode. That sounds
reasonable to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
