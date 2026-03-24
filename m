Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F203F8E1D
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774355702; cv=none; b=sPpx+m2dXTWbI+7BloxVxU4satrXTaSSFRaiYVL2ykJiT7vJUztWAZCMlHAjPVECOmpKRScMiP93mqqsZ4J5+JznrQx6UhidYzoSXkohxsoWVp5B6VjulJE3DvJyfhCKuO5/hk7kzrmD+7lZQk6TgYJ4W9Sffgn6IuCpu2gbkJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774355702; c=relaxed/simple;
	bh=YT7j6G4VqHFba9JjfTn91xb08wb3JpE1uvJdfi/F5fA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTRM+x7q4TYcOpFho/reG9vZZgMGgbs10m7ZBpPNdWAlokJNWtJ4q9YKotY7vOb89n1g1EM75zfn33VpAAJ4djN6v7RGg0gKJZWnPnFHIgYSB4iT3VzyqUGvBVZ66VrXcQ2TkmS4Oh34Iyb91NFg9vFMfvt3r0DTrRBgP3mdWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c1xtsd9g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=04c7WcS3; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=c1xtsd9g; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=04c7WcS3; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c1xtsd9g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="04c7WcS3";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="c1xtsd9g";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="04c7WcS3"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3E3EB4D372;
	Tue, 24 Mar 2026 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=c1xtsd9gHrgpbaU/tq8WoUFUL3pyzhwgH/OnjBvkZ7vthOkASyofP3Jf1csg9/K7Xqz316
	zh/mM3d8HzS4ga0c0PyIVCXLKGqT4uTG1ps1wkDzgVuvjNaTJvlnGQib2ogbYQO6TW5ZFT
	nxPxqQAsscaJzmWuBsFFe1vrUczB334=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=04c7WcS3KaAArdHv83GxCHNeWZxVlnvpswo6/zkGMwnQHfXT3GjX9Eze8EbUi4SNRHNvjm
	REyfdEiPv7jg5jBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774355698; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=c1xtsd9gHrgpbaU/tq8WoUFUL3pyzhwgH/OnjBvkZ7vthOkASyofP3Jf1csg9/K7Xqz316
	zh/mM3d8HzS4ga0c0PyIVCXLKGqT4uTG1ps1wkDzgVuvjNaTJvlnGQib2ogbYQO6TW5ZFT
	nxPxqQAsscaJzmWuBsFFe1vrUczB334=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774355698;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kOD5J3EgQ3eewOupxViyCrtb2bK/f0J4VPnZdwhvBJ8=;
	b=04c7WcS3KaAArdHv83GxCHNeWZxVlnvpswo6/zkGMwnQHfXT3GjX9Eze8EbUi4SNRHNvjm
	REyfdEiPv7jg5jBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 355E543E3A;
	Tue, 24 Mar 2026 12:34:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4JAFDfKEwmlhcQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:34:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EF8C1A0B32; Tue, 24 Mar 2026 13:34:57 +0100 (CET)
Date: Tue, 24 Mar 2026 13:34:57 +0100
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
Message-ID: <ezdm6d34jqdrcohk7o6wycxvvlgtf6aqenwx5ffr3plfagdbzi@gibz7xwr6yhr>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-53-jack@suse.cz>
 <acIjxUzWFstarlwv@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIjxUzWFstarlwv@infradead.org>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email]
X-Spam-Flag: NO

On Mon 23-03-26 22:40:21, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:07PM +0100, Jan Kara wrote:
> > No filesystem calling __generic_file_fsync() uses metadata bh tracking.
> > Drop sync_mapping_buffers() call from __generic_file_fsync() as it's
> > pointless now.
> 
> Given how much this changed, maybe rename it to simple_fsync now to
> provide an obvious breakage for anyone trying to use it?  That name
> is probably also better as it's not all that generic.

I'm fine with simple_fsync() name for the helper with the trivial behavior
of writing out the mapping and the inode. Code wise this will look somewhat
different given what you've suggested for the last patch.

								Honza

> 
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/libfs.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/libfs.c b/fs/libfs.c
> > index 74134ba2e8d1..548e119668df 100644
> > --- a/fs/libfs.c
> > +++ b/fs/libfs.c
> > @@ -1555,23 +1555,19 @@ int __generic_file_fsync(struct file *file, loff_t start, loff_t end,
> >  {
> >  	struct inode *inode = file->f_mapping->host;
> >  	int err;
> > -	int ret;
> > +	int ret = 0;
> >  
> >  	err = file_write_and_wait_range(file, start, end);
> >  	if (err)
> >  		return err;
> >  
> >  	inode_lock(inode);
> > -	ret = sync_mapping_buffers(inode->i_mapping);
> >  	if (!(inode_state_read_once(inode) & I_DIRTY_ALL))
> >  		goto out;
> >  	if (datasync && !(inode_state_read_once(inode) & I_DIRTY_DATASYNC))
> >  		goto out;
> >  
> > -	err = sync_inode_metadata(inode, 1);
> > -	if (ret == 0)
> > -		ret = err;
> > -
> > +	ret = sync_inode_metadata(inode, 1);
> >  out:
> >  	inode_unlock(inode);
> >  	/* check and advance again to catch errors after syncing out buffers */
> > -- 
> > 2.51.0
> > 
> > 
> ---end quoted text---
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
