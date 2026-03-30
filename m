Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B118435AC3E
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 09:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774861711; cv=none; b=SbyPMe/5jyVgmHo7IFCuSghfBuzptxaYOu+P+P6UI+7+btOsq/jrhcDLkjSRsMlmvSwMhbSoyb6PuZtpZVXNT0X7Z3bh8wrfcGkoWXEDW7Re3HCvP5qaNyh8PyztOJIm4vvmdfVBBPaxal5OoFUmOx80KoR/b6mmkOc4A9y5Icg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774861711; c=relaxed/simple;
	bh=ncEdk2HGj9Vhj7yhGU8x2Q/nHbeKkFQz+E5maIwSRqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smFs0c4yRzW2q4JzpxXcwa9YSTfj4KgLqkhbbZiyrUXmFxluZ/BirW9nVHrkBGJTHn8k0ds9A0f9XzOy6wC8CJFjRisKUaae9cBkhgNKYPBFiegwbTgtmQZ+YjzQyheengmSnhQVvIKBTXwC+KR1i3zV74AgYQXACwU3we5T7dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=21z2fq7M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vF4HnnPs; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=21z2fq7M; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vF4HnnPs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="21z2fq7M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vF4HnnPs";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="21z2fq7M";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vF4HnnPs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 008A25BE8B;
	Mon, 30 Mar 2026 09:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774861708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=21z2fq7MEM8GlGdf2p1Uv1FeRcKESExRgP+QFExXTXCq9vjvD37Oln1sRgp63MmpBleU0K
	hcsDaH4YT7EkKrFnmgAqwxXLt3e3712CNd7DtJZvwhfeN8+oYg+A6DG2FPd01Km+HpRF92
	Q0qGVMee1nWWIhqzMvwqQd4zNbECO7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774861708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=vF4HnnPsOGy+AHlch9F2HDIU/7wavrI+NPGwGHYZTtBvptIg60FlEL5e+gbAg+/DdYXe1u
	RCzDEww/+tR4L0DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774861708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=21z2fq7MEM8GlGdf2p1Uv1FeRcKESExRgP+QFExXTXCq9vjvD37Oln1sRgp63MmpBleU0K
	hcsDaH4YT7EkKrFnmgAqwxXLt3e3712CNd7DtJZvwhfeN8+oYg+A6DG2FPd01Km+HpRF92
	Q0qGVMee1nWWIhqzMvwqQd4zNbECO7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774861708;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9NUqvGGWprPcIJMx+7V4+I9Ruxy2G3AZtaLDdqs5dnE=;
	b=vF4HnnPsOGy+AHlch9F2HDIU/7wavrI+NPGwGHYZTtBvptIg60FlEL5e+gbAg+/DdYXe1u
	RCzDEww/+tR4L0DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED7BA4A0A2;
	Mon, 30 Mar 2026 09:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jdLrOYs9ymlLDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 30 Mar 2026 09:08:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C1894A0AE1; Mon, 30 Mar 2026 11:08:27 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:08:27 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, linux-aio@kvack.org, 
	Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
Message-ID: <3oh5cbnm6dwz6rikc6laably5nvu4c4wtxjqzuu3wymzhpqrtw@skopu327hd7a>
References: <20260326082428.31660-1-jack@suse.cz>
 <20260326095354.16340-57-jack@suse.cz>
 <87ldfazqo2.fsf@mail.parknet.co.jp>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldfazqo2.fsf@mail.parknet.co.jp>
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
	RCPT_COUNT_TWELVE(0.00)[16];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,linux.dev,suse.de,kvack.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Sun 29-03-26 22:55:09, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> > There are only very few filesystems using generic metadata buffer head
> > tracking and everybody is paying the overhead. When we remove this
> > tracking for inode reclaim code .evict will start to see inodes with
> > metadata buffers attached so write them out and prune them.
> >
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/fat/inode.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> > index 3cc5fb01afa1..ce88602b0d57 100644
> > --- a/fs/fat/inode.c
> > +++ b/fs/fat/inode.c
> > @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
> >  	if (!inode->i_nlink) {
> >  		inode->i_size = 0;
> >  		fat_truncate_blocks(inode, 0);
> > -	} else
> > +	} else {
> > +		sync_mapping_buffers(inode->i_mapping);
> 
> Hm, why do we have to add this here? For FAT, if buffers are still
> dirty, buffers will be flushed via bdev flush?

The reason why I've put sync_mapping_buffers() here is the following
sequence:
  fd = open("file")
  write(fd)
  close(fd)
    - now data gets written out, dentry & inode can get evicted from memory
  fd = open("file")
  fsync(fd)
    - this should flush all dirty metadata associated with "file" but if we
      didn't call sync_mapping_buffers() during inode eviction we wouldn't
      have a way to do that.

So in general I think sync_mapping_buffers() call is indeed needed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
