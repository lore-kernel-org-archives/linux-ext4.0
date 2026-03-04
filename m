Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599BF371064
	for <linux-ext4@vger.kernel.org>; Wed,  4 Mar 2026 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772620597; cv=none; b=pL55//tYxTooOaBvWJvYK5peJBqe6jShQ9778OYz4j+VO6U4XQebJeW/ocPNenaKRKd4lAtslWezDbFfL19P8W+KlELyaA/EnWf86hiQDCtgeUxqLKdwdybmSiHVVbgSVs8n6GIlY6ArgNoFWs4CDaRmTpG+fSmqZ8bgZ/avv+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772620597; c=relaxed/simple;
	bh=AAaYb372R3xoantgDs+TmQKbpqHy1RvhhYr3K8EKnJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ks8PjzvhfMeB1RuYOCfi8RirrGguAnakrNgrQ3TmL8wQVUj0vtKQMqds3c7IXIAevxCFnF8UMkfSoZBQhN5A7VhbA+Snhm9V34ndI/KIO5c872LxvMIqvM7okfgiy1IRh6zAsFVY8RBlnulJ8L36yL941gg9LHLi8DQz7hkEgwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zbilbouA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=h6UD410H; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=zbilbouA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=h6UD410H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zbilbouA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="h6UD410H";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="zbilbouA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="h6UD410H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 850D15BDA8;
	Wed,  4 Mar 2026 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=zbilbouAi79PwtHlicoiF+7RqOe6qooQ/oBnE6AcOXE57Iq4/Mxaib3jR1vkNMRVfByT+f
	Xy+Yd4bB21cuWG6QB0LPHgvEm/j8DtsQSmNqI1wMF+q83LGdxpttBEYgZi8QBGuVOKdOyq
	iDRS5bOHFNQkmyRCYw+1Jdp96SCXUuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=h6UD410HcIUj3J3y8gxiaHvPXQMrHZhLCPf0xqLb6Nblr+uNgkP5hvUXfcUoIeUrS6IWvu
	kHQj933123o5X9Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zbilbouA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=h6UD410H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772620593; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=zbilbouAi79PwtHlicoiF+7RqOe6qooQ/oBnE6AcOXE57Iq4/Mxaib3jR1vkNMRVfByT+f
	Xy+Yd4bB21cuWG6QB0LPHgvEm/j8DtsQSmNqI1wMF+q83LGdxpttBEYgZi8QBGuVOKdOyq
	iDRS5bOHFNQkmyRCYw+1Jdp96SCXUuM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772620593;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAUHAF9UTKpf13oP8jFEeNlGDpWhHrwgG4ztNisMz0=;
	b=h6UD410HcIUj3J3y8gxiaHvPXQMrHZhLCPf0xqLb6Nblr+uNgkP5hvUXfcUoIeUrS6IWvu
	kHQj933123o5X9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77EB33EA69;
	Wed,  4 Mar 2026 10:36:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yNI+HTELqGkjFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 04 Mar 2026 10:36:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 379CAA0A1B; Wed,  4 Mar 2026 11:36:29 +0100 (CET)
Date: Wed, 4 Mar 2026 11:36:29 +0100
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
Message-ID: <n3anrkzfguzbn5sfwsom472cx4uzejyfemz3d5jm7c4rt3qr6z@ez2cgwzmbfyi>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <aabrf4YhPJ2X7n9q@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabrf4YhPJ2X7n9q@infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[18];
	RCVD_TLS_LAST(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org,kernel.dk];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim]
X-Rspamd-Queue-Id: 850D15BDA8
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Tue 03-03-26 06:09:03, Christoph Hellwig wrote:
> FYI, linux-block only got this patch which is totally messed up.
> Please always send all patches to every list and person, otherwise
> you fill peoples inboxes with unreviewable junk.

Well, I've CCed on the whole series everybody who was non-trivially
impacted. But there are couple of these trivial "remove effectively dead
code" patches which stand on their own and a lot of people actually prefer
to only get individual patches in such cases. So I don't plan on changing
that but I guess I could have CCed linux-block on the whole series as
buffer_heads are tangentially related to block layer anyway.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
