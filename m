Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B83DA7D2
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386323; cv=none; b=OrAHPt84tri9HehlNmugPq6RY8TifNmt8ggSbnB65Ny6D/3EFbDPyMDWwPc+AeX2lFxA4tvcso8QdCFeONtLdUuICp1qSUxfATnixqsPhZ6Ku7mDIbH3pfRAylS7kuRm070C4zbPY5c3hFZdx3h/oubOwTEa2NBzgB8zwRloqWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386323; c=relaxed/simple;
	bh=xmLOoiT6TBzwkK85DlSaoo1fNthMCp/kt7uhTP/ogdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8nIZv6Y9twcZrtmMvXLS2HCve53spcU1j/rYmvZ2XfyE+8LK1/ZlhTsm8dcPvKTrcM3tgRHR+82/+DAreUKReFS/FjOMJhd6rAx2kIh+kdZiVMVW14kbKsMESZTvuCIbJN90CznmQ+OLoq5P4zrA/N7+XAFn61W1xgmm0OQl6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R5ebWx5G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R8uIuPLg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=R5ebWx5G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=R8uIuPLg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R5ebWx5G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R8uIuPLg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="R5ebWx5G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="R8uIuPLg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1FE766C558;
	Thu, 25 Jun 2026 11:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782386316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVgh/MYhZLl584hQFz+xIWLcKAARijhFU0ERTJx69SY=;
	b=R5ebWx5GgaT29sOWNrdQb/Q0Srp4RlnNoflJI1+GSQRxQ/BQnzMl1aBffLPtv3pqCNUCbI
	xlryBlRGtZQA0RcZrZcBVFPiBAgIi++7CXkX04k/q1WWmFJa2MvibcygfDM//36xBWV//6
	m/eTbNs/2Q/+ooQ8TE/PLsmaa3QB+F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782386316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVgh/MYhZLl584hQFz+xIWLcKAARijhFU0ERTJx69SY=;
	b=R8uIuPLgM5Ek10jLihxNngQ9GLXA4c/l6PaEFAK1jzOE2Ma2GZ7jwrbemT1iMIrniEQ4/N
	QvoOGGRDPbEdR9Dw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782386316; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVgh/MYhZLl584hQFz+xIWLcKAARijhFU0ERTJx69SY=;
	b=R5ebWx5GgaT29sOWNrdQb/Q0Srp4RlnNoflJI1+GSQRxQ/BQnzMl1aBffLPtv3pqCNUCbI
	xlryBlRGtZQA0RcZrZcBVFPiBAgIi++7CXkX04k/q1WWmFJa2MvibcygfDM//36xBWV//6
	m/eTbNs/2Q/+ooQ8TE/PLsmaa3QB+F8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782386316;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVgh/MYhZLl584hQFz+xIWLcKAARijhFU0ERTJx69SY=;
	b=R8uIuPLgM5Ek10jLihxNngQ9GLXA4c/l6PaEFAK1jzOE2Ma2GZ7jwrbemT1iMIrniEQ4/N
	QvoOGGRDPbEdR9Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12AF1779A8;
	Thu, 25 Jun 2026 11:18:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lbGLBIwOPWqpXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 25 Jun 2026 11:18:36 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AD1DBA10A3; Thu, 25 Jun 2026 13:18:31 +0200 (CEST)
Date: Thu, 25 Jun 2026 13:18:31 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yizhang089@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Zhu Jia <zhujia.zj@bytedance.com>, 
	Zhang Yi <yi.zhang@huaweicloud.com>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: cancel dirty accounting for folios without buffers
Message-ID: <qwe3wrfaoqoowiywhskhewfcjbh5aolmgeoy7am6xcl7id4fam@zxqmz7266uaq>
References: <20260623094947.7853-1-zhujia.zj@bytedance.com>
 <81ed36cc-b5c8-41cf-8b7d-16611e61e294@huaweicloud.com>
 <20260624094535.1-zhujia.zj@bytedance.com>
 <x3jm3mhgsr7zx4hvfgdvmwoqyz5vxx2fjyxy6gs6him46767f6@dkkirnw54x6x>
 <7471b9cb-158a-4ed4-a1ce-95270ef38974@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7471b9cb-158a-4ed4-a1ce-95270ef38974@gmail.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,bytedance.com,huaweicloud.com,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,vger.kernel.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Wed 24-06-26 21:29:58, Zhang Yi wrote:
> On 6/24/2026 8:32 PM, Jan Kara wrote:
> > On Wed 24-06-26 17:52:06, Zhu Jia wrote:
> > > Hi Yi,
> > > 
> > > Thanks for taking a look.
> > > 
> > > Yes, clearing PAGECACHE_TAG_DIRTY/TOWRITE would make the page-cache state
> > > cleaner. I had a version that did this by adding a helper around
> > > folio_cancel_dirty() and clearing the xarray tags after confirming the
> > > folio was still the same clean page-cache entry.
> > > 
> > > It looked like this:
> > > 
> > > static void ext4_cancel_dirty_folio(struct address_space *mapping,
> > > 				    struct folio *folio)
> > > {
> > > 	XA_STATE(xas, &mapping->i_pages, folio->index);
> > > 	unsigned long flags;
> > > 
> > > 	folio_cancel_dirty(folio);
> > > 
> > > 	xas_lock_irqsave(&xas, flags);
> > > 	if (xas_load(&xas) == folio && !folio_test_dirty(folio)) {
> > > 		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
> > > 		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
> > > 	}
> > > 	xas_unlock_irqrestore(&xas, flags);
> > > }
> > > 
> > > The reason I left the tags unchanged in this version is that I was not sure
> > > whether it is appropriate for ext4 to open-code xarray tag cleanup directly.
> > > 
> > > If you think this is the right direction, I can add the helper back and
> > > send a v2.
> > 
> > That was a good judgement! Playing with xarray tags like this in filesystem
> > code is certainly not a good thing. For now, I'd leave the xarray tags
> > dangling - they will be eventually synced with reality on next writeback
> > attempt. If this inconsistency of tags needs to be fixed, the fix belongs
> > to the generic code (so that it can be used in other places as well).
> > 
> > 								Honza
> 
> Yes, I agree. Directly clearing the tag via open code is not a good
> approach. However, I took a look at the !nr_to_submit branch in
> ext4_bio_write_folio(), and it seems to have a similar simple handling
> pattern—it directly calls __folio_start_writeback() and
> folio_end_writeback(), which appears to be an elegant way to clear them.
> Could we also call these two helpers just after folio_cancel_dirty()
> here?

Right, that would be actually doable there and would keep things more
consistent so I think that's a good idea! Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
