Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AF63CA491
	for <linux-ext4@vger.kernel.org>; Thu,  5 Mar 2026 16:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772728808; cv=none; b=iuvy9luPDRWDa2ah/864qZRU5IlMfit9jej+s+rMoaL42XytDGSPwgkMhBuxYZEB21X1uiNuijZqRj0mrTyBblcc/PLdh2QcIarHCgC2uDPaF/K+vLhXd8EQpHrJTjR64P0IzY5yA17z+Bzlo8bWuCgGhzvw9gYL6f8Mqlr/2Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772728808; c=relaxed/simple;
	bh=7e3VlIwgOuOFZBcH4NmX8tV4iUIje/63xUuh+3s8xBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeyywzdiBprtJl8ERhvoeAcJqdD+7cUjKyBlDhDTM7AF/oRu4bLCwo1K1SLIbZYHocaI7frQh59Bjk+Kj6f666JzGShujWN0LQkyPn/JDjDMe8sNkHTQTXvmEpaLa5jI0KeAlfd9xkZl/WIHQuxvllYBNmqKSsOFKf8YEG9uUx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qtkO6LqI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oCx4m7fZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qtkO6LqI; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=oCx4m7fZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qtkO6LqI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oCx4m7fZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qtkO6LqI";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="oCx4m7fZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9CD103F958;
	Thu,  5 Mar 2026 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=qtkO6LqIVk9Wl1gDJzd8iBzDcwqFDv0BaumZH3AOIR+6AUIy73DAJ4u0VXAC2uZscFXqNl
	Bn3Y+X+mTOkC2dxV5iYll01YewOZEaeESdeCHxI6yMFUQ5K9CQR6XI3Wz2uGF7Kyw5OSLC
	8uxLvhe+jHal7R+gfvECFKOnBNAbvSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=oCx4m7fZ1RQ9/I5dB35OSD8Yx+UobdVPgvIsAZc+gE64dNgv+TRSBhkxwaF91No7foe5hq
	pB2nT6Pm/6QI8iCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qtkO6LqI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oCx4m7fZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772728804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=qtkO6LqIVk9Wl1gDJzd8iBzDcwqFDv0BaumZH3AOIR+6AUIy73DAJ4u0VXAC2uZscFXqNl
	Bn3Y+X+mTOkC2dxV5iYll01YewOZEaeESdeCHxI6yMFUQ5K9CQR6XI3Wz2uGF7Kyw5OSLC
	8uxLvhe+jHal7R+gfvECFKOnBNAbvSY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772728804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5g5mQu63BsP2Pqb08F6vHC+ukOXCK5SIBo6DC3I37QU=;
	b=oCx4m7fZ1RQ9/I5dB35OSD8Yx+UobdVPgvIsAZc+gE64dNgv+TRSBhkxwaF91No7foe5hq
	pB2nT6Pm/6QI8iCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 901933EA68;
	Thu,  5 Mar 2026 16:40:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W8ooI+SxqWnBAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Mar 2026 16:40:04 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EBFFAA0A8D; Thu,  5 Mar 2026 17:39:59 +0100 (CET)
Date: Thu, 5 Mar 2026 17:39:59 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, 
	Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>, 
	David Sterba <dsterba@suse.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 17/32] fs: Move metadata bhs tracking to a separate struct
Message-ID: <5quave3vkmvgstqggaijh3b5225kfofkri6psl5xsib27gknq2@lzaj6uzs2pqj>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-49-jack@suse.cz>
 <aag2URb_D0h--RKX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aag2URb_D0h--RKX@infradead.org>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[16];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9CD103F958

On Wed 04-03-26 05:40:33, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 11:34:06AM +0100, Jan Kara wrote:
> > +static void remove_assoc_queue(struct buffer_head *bh)
> > +{
> > +	struct address_space *mapping;
> > +	struct mapping_metadata_bhs *mmb;
> > +
> > +	/*
> > +	 * The locking dance is ugly here. We need to acquire lock
> > +	 * protecting metadata bh list while possibly racing with bh
> > +	 * being removed from the list or moved to a different one.  We
> > +	 * use RCU to pin mapping_metadata_bhs in memory to
> > +	 * opportunistically acquire the lock and then recheck the bh
> > +	 * didn't move under us.
> > +	 */
> 
> Should the buffer_head simply have a pointer to the metadata bh list,
> as that would avoid all this and keep a lot of the references to the
> list self-contained?

Yes, after some thinking that should be doable if we then add pointer to
address_space to struct mapping_metadata_bhs. I'll try how the patches are
going to look like.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
