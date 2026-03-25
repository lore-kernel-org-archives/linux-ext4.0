Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8F2459EA
	for <linux-ext4@vger.kernel.org>; Wed, 25 Mar 2026 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774465257; cv=none; b=dAHM6nnWHTClV73pPU1IhzXRoUw9XUjt+vqTFJi4t3ih6DgmqTe+cDxtHVFS/IrLvQfHq0DfT8wrI3cU1GRPneMnjK4726skCAuQ+hHH11z0LY0OOiaoGNUYdrvPDWYCKY2ZqCGvGIeG9/HVMGQr2YmDN/92fa5EDwx01WAgTus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774465257; c=relaxed/simple;
	bh=T83VbSbFDlH1e2dPiC1t/b6q+Lt4Hy2mjfcdRcE5SL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alZ9yGSHiWhpNnqQWtlxI/uSwsd+yLd+Oi95vgLKN229wALn1+OkP2wNGPt/G4CzRlSNoWXcvyMOQs57n5iATIsDSDbLe4UG6MLTeOarPF/hgqpAck50JToMM1is4dVf9McQKz/j6N+21/tCA3EmtxK/P/6dChrb+YRKICuavYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pnsR0lbn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XjWOqJW1; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pnsR0lbn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=XjWOqJW1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pnsR0lbn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XjWOqJW1";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pnsR0lbn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="XjWOqJW1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE1574D25B;
	Wed, 25 Mar 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=pnsR0lbnogWDDvWWHJaZzoB1nD/ry2v6mA2qDgaMq74hwNvkm1mpDtNRhLpjQ4tTDhynep
	lLNzOKpBD3cmQnFSNdgQ7yOODIma8pCS4vTPTbM0gRPUqGDyZ1poXXLvZ6zCLuK9bKi19Q
	Ze8Ia03faCzlwGzPLOKircNffb2KZmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=XjWOqJW1HANyX+2k8BQ1Z3LcemmfpqeilUlFb8XOnE1EzFWnDH6LBfGw5o1ex7vO6WVEHQ
	xAHkyQK+4qrTggCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pnsR0lbn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XjWOqJW1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774465250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=pnsR0lbnogWDDvWWHJaZzoB1nD/ry2v6mA2qDgaMq74hwNvkm1mpDtNRhLpjQ4tTDhynep
	lLNzOKpBD3cmQnFSNdgQ7yOODIma8pCS4vTPTbM0gRPUqGDyZ1poXXLvZ6zCLuK9bKi19Q
	Ze8Ia03faCzlwGzPLOKircNffb2KZmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774465250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B2oYYheOhGCTdUtGseN0WmGmhiRAd3tOmDJdOSLqv28=;
	b=XjWOqJW1HANyX+2k8BQ1Z3LcemmfpqeilUlFb8XOnE1EzFWnDH6LBfGw5o1ex7vO6WVEHQ
	xAHkyQK+4qrTggCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B02BC44558;
	Wed, 25 Mar 2026 19:00:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +7L2KuIwxGkBYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Mar 2026 19:00:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6F330A085A; Wed, 25 Mar 2026 20:00:42 +0100 (CET)
Date: Wed, 25 Mar 2026 20:00:42 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/41] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <f7e57f3wfmzkh7wcsq662q5igqnxza4ryfk4uzm5kba5f5stfg@be4tpgtp5nga>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-72-jack@suse.cz>
 <acImXDl7MTsmVK_U@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acImXDl7MTsmVK_U@infradead.org>
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
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim,suse.cz:email]
X-Rspamd-Queue-Id: BE1574D25B
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 23-03-26 22:51:24, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:26PM +0100, Jan Kara wrote:
> > As part of transition toward moving mapping_metadata_bhs to fs-private
> > part of the inode, provide functions for operations on this list
> > directly instead of going through the inode / mapping.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
...
> > @@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
> >   * buffer stays on our list until IO completes (at which point it can be
> >   * reaped).
> >   */
> > -int sync_mapping_buffers(struct address_space *mapping)
> > +int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)
> 
> mmb and buffers in the same name feels a bit redundant.
> 
> mmc_sync_all?  mapping_sync_buffers?

I've called this just mmb_sync() and I've also shortened
mmb_invalidate_buffers() to mmb_invalidate().

> 
> > +int generic_mmb_fsync_noflush(struct file *file,
> > +			      struct mapping_metadata_bhs *mmb,
> > +			      loff_t start, loff_t end, bool datasync)
> 
> mmb_fsync?  mapping_buffers_fsync?

This I've called mmb_fsync().

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
