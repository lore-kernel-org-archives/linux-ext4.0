Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A23FD123
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774359420; cv=none; b=VUiXgYwo5E1jxvrlboMYcl+mOcTYiLcDCoPvVzYZyri005hph5CptSIaYL1j6MO7QdZQvD/jfGWHAyYv6baDBsimkNiDlzSsnCoX9MRCnSXYse1Aow+v3AZAWPGZZXozt2lt4MKG3DYXuB4GTvoaajhspanxhcoW8h/T0UIx5QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774359420; c=relaxed/simple;
	bh=QdQdALV86sJIqxP52ms3ChwXRWDwASMzepVWJV4RJ8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iOicVNv9ej4cahNC1mSlCGuKnZKB+UnDNgDSqXI0tW9PaW8OfJfJSSfZfBZOwZEJqhGIh6udxhz8ZeEqSJGe7Dd8KF7BXsNqArkNnhB82lWwk2JEueAsTYgk6AuKjsZxl9mI6OiCzQ4HDsqDPhRMAqU0oWnoWNg+w2SG0GF5tBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYdnsU/b; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cAGqIaMH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OYdnsU/b; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cAGqIaMH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYdnsU/b";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cAGqIaMH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OYdnsU/b";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cAGqIaMH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79D114D1F5;
	Tue, 24 Mar 2026 13:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=OYdnsU/bqa7wH78lX/xP4ENpOJBiyZZO1a1HEfPH871pcSsA9hxRzckzP2p2FD/xY1LRyf
	46+FNamy7mSYYYw/iEAmFFXphc3xGZWtbjAHt23G+N3pbmfyh27YvXmW9e0H31f5RuKATG
	P8W0lmrXh6cyc1cz0cYnEWx2zf8NTXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=cAGqIaMHX9aBjl8trg/9H0ZuskPR38NyCcUZV1e09EHsMTcfZGnGNw1e3+DSZWy0yjhbkA
	+KrYteJU6bfT5PAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="OYdnsU/b";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cAGqIaMH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774359417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=OYdnsU/bqa7wH78lX/xP4ENpOJBiyZZO1a1HEfPH871pcSsA9hxRzckzP2p2FD/xY1LRyf
	46+FNamy7mSYYYw/iEAmFFXphc3xGZWtbjAHt23G+N3pbmfyh27YvXmW9e0H31f5RuKATG
	P8W0lmrXh6cyc1cz0cYnEWx2zf8NTXA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774359417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CYLLG8yAfF+r3jUkoHDeuDHN91spuYGqUAcPuaMTY84=;
	b=cAGqIaMHX9aBjl8trg/9H0ZuskPR38NyCcUZV1e09EHsMTcfZGnGNw1e3+DSZWy0yjhbkA
	+KrYteJU6bfT5PAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C4FD43E76;
	Tue, 24 Mar 2026 13:36:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOFuGnmTwmnDMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 13:36:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2D129A0B32; Tue, 24 Mar 2026 14:36:53 +0100 (CET)
Date: Tue, 24 Mar 2026 14:36:53 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 12/41] fs: Drop sync_mapping_buffers() from
 __generic_file_fsync()
Message-ID: <rsftk7gdlamfryksv63vhmewdi6etvvfyi6as5m2zs75ctvzkq@fnoiwumyfdsv>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
 <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
 <acKO3NRw852FdGUO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKO3NRw852FdGUO@infradead.org>
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
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim];
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
X-Rspamd-Queue-Id: 79D114D1F5

On Tue 24-03-26 06:17:16, Christoph Hellwig wrote:
> On Tue, Mar 24, 2026 at 01:34:57PM +0100, Jan Kara wrote:
> > I'm fine with simple_fsync() name for the helper with the trivial behavior
> > of writing out the mapping and the inode. Code wise this will look somewhat
> > different given what you've suggested for the last patch.
> 
> Yeah, the pitfalls of going sequentially through the series :)
> 
> But sketching this out I'm not even sure all this makes sense any more.
> Maybe instad of the allback we should just have a helper for checking the
> inode state like:
> 
> static inline bool inode_need_fsync(struct inode *inode, bool datasync)
> {
> 	enum inode_state_flags_enum state = inode_state_read_once(inode);
> 
> 	if (!(state & I_DIRTY_ALL))
>                 return false;
>         if (datasync && !(state & I_DIRTY_DATASYNC))
>                 retun false;
> 	return true;
> }
> 
> and otherwise just open code the calls int the two implementations
> without any callbacks, as it feels cleaner to avoid the entanglement.

Leaving the two implementations separate certainly works for me as well
(that's why I've put that patch to the end because I've expected some
discussions around it :)). Just the amount of common trivial calls you need
to do (fdatawrite(), sync_inode_metadata(),
file_check_and_advance_wb_err(), blkdev_issue_flush()) looked high enough
to me to be worth merging the implementations. But I don't feel strongly
either way.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
