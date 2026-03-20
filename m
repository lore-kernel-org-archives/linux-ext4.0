Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923E2D876B
	for <linux-ext4@vger.kernel.org>; Fri, 20 Mar 2026 10:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774002294; cv=none; b=EIqOGHCUTOhImP4mzNUBZLT+ppfwRe+0f9u/uQck1+NU4Qn++mD2R57WZa11RnpVyLGj2N6CeE0BsEL9f2teN5AMujDMtLd/U1xO6N8VMkLJEIreareRs7rqqyzEfZ/W9hSUtWV21iaLmRF3LlXPw5j8peKVE5WYPkBJHJt4OTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774002294; c=relaxed/simple;
	bh=X6jDWu2fdH0Zm0gmVcgOKx0GN9a/+AYR5mOBcninh+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=socRdClwA0KvcpllmVc0zxu8JesNhKtjrpN7XNWow5gWIEf691q2EQDyOUq8EsBijII4isieAT3PLWh75r1zAaRjYORYgzkE0WBb0f9kfP0KfOTgrZTB86Dk6tqMvKexwF/LeCCywDYg1ulM0yFB3Jc1Ti0otNFnCyn0tC5DahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D/7Ro3Ac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZBtQAsQT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=D/7Ro3Ac; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZBtQAsQT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D/7Ro3Ac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZBtQAsQT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="D/7Ro3Ac";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZBtQAsQT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EDDE5BD9B;
	Fri, 20 Mar 2026 10:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774002286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BXB+KtsveXYCXMIwnYLL97YjLNc7kaO1ffqyFRLFQ=;
	b=D/7Ro3AcqMts+oT/Y13T02QTqSn+nax4A+OR8PKuSdOKzzP1H1G5wJ50Ab/oOZMqp4Q3kV
	5cBOuIpY8wBVGv9HJPuhpleQdskpmp6d6dbwWZpeHNaHReB9jeWiz1inJn4bkWjoqubtl3
	kWUT2i+hZJYRVbLEEbKrZM/2O6GfSRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774002286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BXB+KtsveXYCXMIwnYLL97YjLNc7kaO1ffqyFRLFQ=;
	b=ZBtQAsQT+SL2ceCrFnvEjftZRSnO80jpkKnuJpQz43lsnRkAxHYJbYvvLqlNU8yhgJ0UBN
	5VYQi3MwsyQuYeCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774002286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BXB+KtsveXYCXMIwnYLL97YjLNc7kaO1ffqyFRLFQ=;
	b=D/7Ro3AcqMts+oT/Y13T02QTqSn+nax4A+OR8PKuSdOKzzP1H1G5wJ50Ab/oOZMqp4Q3kV
	5cBOuIpY8wBVGv9HJPuhpleQdskpmp6d6dbwWZpeHNaHReB9jeWiz1inJn4bkWjoqubtl3
	kWUT2i+hZJYRVbLEEbKrZM/2O6GfSRw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774002286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P9BXB+KtsveXYCXMIwnYLL97YjLNc7kaO1ffqyFRLFQ=;
	b=ZBtQAsQT+SL2ceCrFnvEjftZRSnO80jpkKnuJpQz43lsnRkAxHYJbYvvLqlNU8yhgJ0UBN
	5VYQi3MwsyQuYeCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E266D4273B;
	Fri, 20 Mar 2026 10:24:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yYNAN20gvWlPOwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 10:24:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A309DA0AFD; Fri, 20 Mar 2026 11:24:41 +0100 (CET)
Date: Fri, 20 Mar 2026 11:24:41 +0100
From: Jan Kara <jack@suse.cz>
To: NeilBrown <neil@brown.name>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] ext4: add ext4_fc_eligible()
Message-ID: <swsnaqghu7pkvmxj5tonqera2gplyvpxmpusxlreqpyjg2ea3j@b7g7pabdp74x>
References: <20260317224638.3809014-1-neilb@ownmail.net>
 <20260317224638.3809014-3-neilb@ownmail.net>
 <gh7e7uykczpyhfxrh6y54c2jlcs4pzcud65aqsjoj4am6cajzp@wq26crdxv2yd>
 <177396306176.3934327.9167241352093307006@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177396306176.3934327.9167241352093307006@noble.neil.brown.name>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO

On Fri 20-03-26 10:31:01, NeilBrown wrote:
> On Thu, 19 Mar 2026, Jan Kara wrote:
> > On Wed 18-03-26 09:39:50, NeilBrown wrote:
> > > From: NeilBrown <neil@brown.name>
> > > 
> > > Testing EXT4_MF_FC_INELIGIBLE is almost always combined with testing
> > > ext4_fc_disabled().  The code can be simplified by combining these two
> > > in a new ext4_fc_eligible().
> > > 
> > > In ext4_fc_track_inode() this moves the ext4_fc_disabled() test after
> > > ext4_fc_mark_ineligible(), but as that is a non-op when
> > > ext4_fc_disabled() is true, this is no no consequence.
> > > 
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > 
> > One nit below, otherwise feel free to add:
> > 
> > Reviewed-by: Jan Kara <jack@suse.cz>
> > 
> > > @@ -557,16 +548,13 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
> > >  	if (S_ISDIR(inode->i_mode))
> > >  		return;
> > >  
> > > -	if (ext4_fc_disabled(inode->i_sb))
> > > -		return;
> > > -
> > >  	if (ext4_should_journal_data(inode)) {
> > >  		ext4_fc_mark_ineligible(inode->i_sb,
> > >  					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
> > >  		return;
> > >  	}
> > >  
> > > -	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_INELIGIBLE))
> > > +	if (!ext4_fc_eligible(inode->i_sb))
> > >  		return;
> > 
> > Here I think the !ext4_fc_eligible() check could be actually above the
> > ext4_should_journal_data() check - if the fs is not eligible for
> > fastcommit, there's no point in marking it ineligible again...
> 
> Both you and Andreas have questioned that choice - so I should explain
> my reasoning.
> 
> ext4_fc_mark_ineligible() is NOT a no-op when the sb is already marked
> ineligible.  The code updates sb->s_fc_ineligible_tid to the largest tid
> which was ineligible for fc.  Then it only clears the "ineligible" flag
> after that highest numbered transaction has committed.  If we skip
> ext4_fc_mark_ineligible() because EXT4_MF_FC_INELIGIBLE is already set,
> then that flag could be cleared too early.

Oops, you're right. I forgot about this subtlety. Thanks for explanation!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
