Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED633BBFD2
	for <linux-ext4@vger.kernel.org>; Mon, 17 Aug 2026 11:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786966775; cv=none; b=uVe2k5eg0wnIg7Qjsr9tmY7zCKHecyAZSEmmYYZrRWxF6Zm5qIUvnqqoM/vY6upO1agZ8ovWFhPN8IvPyT2N99LcWi+bV9neK1XqbBpa+SMfA5zPJjrIc4TczB65geK96RE2qOTs7k+3YB47TMXxyt5zviPru1OFrIeTUNSUZIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786966775; c=relaxed/simple;
	bh=g4ya2czWkgylgYzTXWRUAIAPHHCUoUOUnKGXmCCHt7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSC0DeHbt8LReHONb6z/zPjiCXZTifE/Tn7XfvVqKIQZrEenQb8Fnz5vPYGfwHswMy2jEaNpTKwqocIkAgm8NF1Lo2PuignTjX5qggN/+34a2F84gDUkYuFhDCKHkpcYtWu9s5b+QiMrABlESOaB/tPVreXT/EvE7hjaa3VtI5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kxY4eub7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=2IQ/VFUP; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=2wGvKZW7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ci6Yqsi3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kxY4eub7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="2IQ/VFUP";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2wGvKZW7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ci6Yqsi3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E303C3E12;
	Mon, 17 Aug 2026 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786966762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v25YGG1W8E2jAiOvhhxu8F+N4z8ZlGphP4G1y5PMYLM=;
	b=kxY4eub7lK3rMO0V7xoWFX8+5SDhqrCdhhlQvwtdaNvdZo6cVVAtkCYV4iI0I6bIJzEztZ
	v6TrCMKsZN8hLGtvGf46+bARx7uJL6qEM7ZYk1MqIDA/24OVbTZOfnHv1Gm0G9sFzGtFpU
	FE2EAVm2qAglHFyGfH9BesOJlJrlBwg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786966762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v25YGG1W8E2jAiOvhhxu8F+N4z8ZlGphP4G1y5PMYLM=;
	b=2IQ/VFUPaIJ+HzkQ2vL19FXG1TX4DO4gxImtCfWdI0o0OhCSYG0Zcd9SISpLlbFIpALurW
	/d8O7tBD+elg05Dg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2wGvKZW7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ci6Yqsi3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1786966757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v25YGG1W8E2jAiOvhhxu8F+N4z8ZlGphP4G1y5PMYLM=;
	b=2wGvKZW7xUyR0tQNsfKMDXTS57wyXABxVM1hJMIlQsL/nD2vFD/9Y33sMo2eZaKUEYGOnB
	H+ZLr22FyHGAuB7w89y/TS5t7rnP6UEEhALpJBzz1kZXCRtdrWyUnFgzPK0ADGEJhSRVPV
	tbmFlV71AuYSwXMmUdSiSLDkYOX0J+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1786966757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v25YGG1W8E2jAiOvhhxu8F+N4z8ZlGphP4G1y5PMYLM=;
	b=ci6Yqsi3Kz1I5jzYc/uaAkcSbpPbX5Idh1ePfmCBP4UI5QvMcmjnRy40GwHSq5kPeODoWA
	uBS7QIni7OnRsBDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D951C79444;
	Mon, 17 Aug 2026 11:39:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DEsMNeXygmpRRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 17 Aug 2026 11:39:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8348CA13B5; Mon, 17 Aug 2026 13:39:09 +0200 (CEST)
Date: Mon, 17 Aug 2026 13:39:09 +0200
From: Jan Kara <jack@suse.cz>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>, 
	linux-ext4@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: Re: [PATCH 3/3] ext4: Fix estimate extent index blocks in
 ext4_ext_index_trans_blocks()
Message-ID: <xjj4knbbdmielzi4yzifao6qj3nueeflj4hkaitstzw56cwort@l7eh3coy7czf>
References: <20260805153202.29814-1-jack@suse.cz>
 <20260805153605.166545-6-jack@suse.cz>
 <anV9QPd1RvK3qVUC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anV9QPd1RvK3qVUC@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,vger.kernel.org,linux.alibaba.com,huawei.com,gmail.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: E303C3E12
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

Hi!

On Fri 07-08-26 12:07:52, Ojaswin Mujoo wrote:
> On Wed, Aug 05, 2026 at 05:35:49PM +0200, Jan Kara wrote:
> > The estimate of the number of impacted extent tree index blocks could be
> > one-too-low. If we modify say 2 extents, already two leaf index blocks
> 
> Its minor but just to be sure, by two "leaf index blocks" do you mean
> the two leaf blocks that hold extents or the last index blocks which
> hold pointers to leaf blocks?

I meant two leaf blocks that hold extents.

								Honza

> 
> > could be impacted, not just one the current estimate counts with. Fix
> > the estimate.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/ext4/extents.c | 14 +++++++++++---
> >  1 file changed, 11 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index 44ab246a3176..713b2c098af5 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -2427,9 +2427,17 @@ int ext4_ext_index_trans_blocks(struct inode *inode, int extents)
> >  	 */
> >  	if (extents <= 1)
> >  		index = (EXT4_MAX_EXTENT_DEPTH * 2) + extents;
> > -	else
> > -		index = (EXT4_MAX_EXTENT_DEPTH * 3) +
> > -			DIV_ROUND_UP(extents, ext4_ext_space_block(inode, 0));
> > +	else {
> > +		int ext_max = ext4_ext_space_block(inode, 0);
> > +
> > +		index = EXT4_MAX_EXTENT_DEPTH * 3;
> > +		/*
> > +		 * Modified extents need not start at the beginning of the
> > +		 * leaf. Already two extents may need two leaf block
> > +		 * modifications...
> > +		 */
> > +		index += DIV_ROUND_UP(extents + ext_max - 1, ext_max);
> > +	}
> >  
> >  	return index;
> >  }
> > -- 
> > 2.51.0
> > 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
