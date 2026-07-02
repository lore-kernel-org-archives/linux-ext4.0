Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159171D86E4
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783002575; cv=none; b=aBF3J/fIAstKGTw2SFpcJS89kP2ScvBbeGVl15c3GQMdZi4oGriTO+ca6LOQbB6fUnQHtlJEfUZn0RAucgLAQJOxtFiQ5Qm4iIVAf18zI2jSPxF4Zaq9NxYrZwiTrfs2vchRmWDDtIzISIg8P289l1jZfW4M+9rHWHg00SNDOuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783002575; c=relaxed/simple;
	bh=ciQ3qgaDnN4+BvW8UeXpyFaZghj+hvCeoZo+2ACqkZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpgbbIwQKOy51dfnEUvu2xfLIsvVtN3Am9t24VsHSbW2yN4/QpHC8tI8d1uckRTE1LtGTqkmmzdn6A5dGChoIOdEpAHSCqpmUqAl5R8jfDgLZ5HEIGIJwXWCr+8BXgfDXKlLZVTi7coBJvVK50EzldGqWno2xSRS2Elm3EidcI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0YtUMD7h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FX6URIOn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0YtUMD7h; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FX6URIOn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0YtUMD7h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FX6URIOn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0YtUMD7h";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FX6URIOn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44EE275853;
	Thu,  2 Jul 2026 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuXaNzbLUjh54CYOSO5+US4E4ezHXPNDl/gXOinpe3A=;
	b=0YtUMD7huXD33OsaeybL8sIY3F6P59stTBHqwD0yMCjqIHX863DY3r0B1BfitQHgW5Yz2Q
	MGuvDUv08i3Fj7RQey2Iuf4eZdbr4gFQOm3PtEeT6ifq6vkIR940vTJRauHmw0rHRlvZCx
	swnMjLEMgmKAyzg+6wvq3DkYQFilmrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002571;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuXaNzbLUjh54CYOSO5+US4E4ezHXPNDl/gXOinpe3A=;
	b=FX6URIOnZR7WQ7esiuivEayCT+pFrbeuF84BgY/oL5hJB4hXX01JytSt68t0RTPS8zTpxH
	kT6dxMGiZ/eFY/Cw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783002571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuXaNzbLUjh54CYOSO5+US4E4ezHXPNDl/gXOinpe3A=;
	b=0YtUMD7huXD33OsaeybL8sIY3F6P59stTBHqwD0yMCjqIHX863DY3r0B1BfitQHgW5Yz2Q
	MGuvDUv08i3Fj7RQey2Iuf4eZdbr4gFQOm3PtEeT6ifq6vkIR940vTJRauHmw0rHRlvZCx
	swnMjLEMgmKAyzg+6wvq3DkYQFilmrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783002571;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZuXaNzbLUjh54CYOSO5+US4E4ezHXPNDl/gXOinpe3A=;
	b=FX6URIOnZR7WQ7esiuivEayCT+pFrbeuF84BgY/oL5hJB4hXX01JytSt68t0RTPS8zTpxH
	kT6dxMGiZ/eFY/Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32277779AA;
	Thu,  2 Jul 2026 14:29:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EA09DMt1RmogMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 02 Jul 2026 14:29:31 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 92054A0AE1; Thu, 02 Jul 2026 16:29:30 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:29:30 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>, 
	tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xiaowu.417@qq.com
Subject: Re: [PATCH v11 1/5] fs: add iput_if_not_last() helper
Message-ID: <mqchxi74vrsmsitr46gtnw5w7tooj7go2tm2jadg4mktppjafc@5uplsind6ooq>
References: <20260629110848.3085662-1-yun.zhou@windriver.com>
 <20260629110848.3085662-2-yun.zhou@windriver.com>
 <4k4crl4oobz4xtmvjoqwoefrd6in46xf725z3ewme3smgh5ide@6dmywcnp6o6y>
 <txvgbvn77wjgfz4ywdb25v7ol4ecszqh5yg3p4g56sbxq6prlo@rpfwveotnfvz>
 <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4e9256-5727-44b2-b63c-e18fe1b95194@windriver.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	RCPT_COUNT_TWELVE(0.00)[15];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,gmail.com,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com,zeniv.linux.org.uk,kernel.org,vger.kernel.org,qq.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email]
X-Spam-Level: 
X-Spam-Score: -2.30

Hi!

On Thu 02-07-26 21:35:47, Zhou, Yun wrote:
> On 6/30/2026 7:34 PM, Jan Kara wrote:
> > On Tue 30-06-26 11:05:50, Mateusz Guzik wrote:
> > > On Mon, Jun 29, 2026 at 07:08:44PM +0800, Yun Zhou wrote:
> > > > Unlike iput_not_last() which BUG_ON's if called with the last ref,
> > > > this variant is designed to be called speculatively.
> > > > 
> > > > Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> > > > Suggested-by: Jan Kara <jack@suse.cz>
> > > > Reviewed-by: Jan Kara <jack@suse.cz>
> > > > ---
> > > >   include/linux/fs.h | 13 +++++++++++++
> > > >   1 file changed, 13 insertions(+)
> > > > 
> > > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > > index d10897b3a1e3..04f0de78fa7a 100644
> > > > --- a/include/linux/fs.h
> > > > +++ b/include/linux/fs.h
> > > > @@ -2413,6 +2413,19 @@ static inline void super_set_sysfs_name_generic(struct super_block *sb, const ch
> > > >   extern void ihold(struct inode * inode);
> > > >   extern void iput(struct inode *);
> > > >   void iput_not_last(struct inode *);
> > > > +
> > > > +/**
> > > > + * iput_if_not_last - drop an inode reference only if it is not the last one
> > > > + * @inode: inode to put
> > > > + *
> > > > + * Returns true if the reference was dropped, false if this was the last
> > > > + * reference and the caller must arrange for final iput() in a safe context.
> > > > + */
> > > > +static inline bool __must_check iput_if_not_last(struct inode *inode)
> > > > +{
> > > > +   return atomic_add_unless(&inode->i_count, -1, 1);
> > > > +}
> > > > +
> > > 
> > > This still could assert on the count, for example:
> > >        VFS_BUG_ON_INODE(inode_state_read_once(inode) & (I_FREEING | I_CLEAR), inode);
> > >        VFS_BUG_ON_INODE(atomic_read(&inode->i_count) < 1, inode);
> > 
> > Yes, it makes sense to be consistent with other helpers. Thanks for the
> > idea.
> 
> Should I wait for now, or go ahead and include the two macros mentioned
> above in v13 as Mateusz suggested? As you know, the v12 series has been
> fully reviewed [1] , and I'm wondering if making this change now might cause
> any inconvenience to everyone.
> 
> [1] https://lore.kernel.org/linux-ext4/20260630100829.1257618-1-yun.zhou@windriver.com/T/#t

I think there will be no more feedback to this series. So just include this
suggested change (keeping current Reviewed-by tags - the change is minimal)
and submit one more version. Mention in the cover letter that there's only
minor adjustment to this one patch, everything is reviewed and ready to be
merged so that Ted knows.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
