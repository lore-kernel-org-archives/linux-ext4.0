Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE943CE68
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 09:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835109; cv=none; b=T4xJso2VTZUCAHOtthCkloQ8cd3jDRYADocWtkbtkcz4L0w7q0hdCM5Havv+P7fdjVPprIooAkE2f6CGtkldGAwAkO1A8yJ1xOWlKl0p8pRSxh2kavk8n9gBFyTodR7cDb1HIo3JwyBKOz3aE9d1HXw3g0CPb6nuti3f7wdwVE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835109; c=relaxed/simple;
	bh=uJbkvNGmdYGATVOvCjeyKh6nPAoLxfcatTM8PtpybGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPMM4lt53+IAo7hvh1fcDyaZkkZkaBH6nOtiI8qQHruzLDbYWTxCMqHGe/ekF+puhiZm01n+s99I0VAA+VM+fYO59/DjcpGiOa+1NefQBfrWE6v7/0tWWYfLmsiCLUfSGQ06o/0IrbzuF7ucFTRfSk9GR8f1eDGdBbdaehVnxbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rkIa7Ste; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=56jtlwl+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rMCbr6wL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BWvxYcfB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rkIa7Ste";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="56jtlwl+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rMCbr6wL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BWvxYcfB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C19B93DFB;
	Tue,  4 Aug 2026 09:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785835101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YHfTYbUXSVtXLh3H26ft01bEMhKajr290Z45IteN8pg=;
	b=rkIa7SteVVZqgutMKMiJGICTDHerVyiqzKmXXc0OLg3KFQAilvHmC+9KtcLsYl2u6zOWsH
	JvGIind7+OjmJNC6ue5FgLg+KUGM03sVjwTy/VReie7S0zq6nsBXHbEBzsKVb8jEG03bwW
	cgFpnZVi8qaaCMWB4Ioua9ajo6d8pOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785835101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YHfTYbUXSVtXLh3H26ft01bEMhKajr290Z45IteN8pg=;
	b=56jtlwl+O8iLK1icSknCqAJ2RKqRZY8Gtmd1wVvqRVBAmgmal9SDhJ0OYeikSnIIQIoY25
	VYd+/w+IpnJlukDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785835097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YHfTYbUXSVtXLh3H26ft01bEMhKajr290Z45IteN8pg=;
	b=rMCbr6wLxiTnUMB/R6Il3jVcwz1OJqrhcbvqzPYZ/iAeg22TRlljxAtbrlAs/SURh7QxC5
	Dlm+5+56+pNY1Ug3Zh3d9PxlQ0KBYzK+cQR5R7HQb0+itdEQsr36Pz9rP71qy/kG9wnJFQ
	0K6wPAhXB8sC6I73Jgd81/cTG+BFEl8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785835097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YHfTYbUXSVtXLh3H26ft01bEMhKajr290Z45IteN8pg=;
	b=BWvxYcfBMUvf+XbKks4NKZWmdnVVzmamxgAuJKwAX5QmrtGfaozFYHButilvviN8hRQby2
	1XCqA5CJV+LC2LCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8CB8779BB;
	Tue,  4 Aug 2026 09:18:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OEUeLVmucWrPDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 09:18:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6617BA13A6; Tue, 04 Aug 2026 11:18:17 +0200 (CEST)
Date: Tue, 4 Aug 2026 11:18:17 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write
 fails
Message-ID: <k6v2pwtt67ifaeqyeiv5fiwuui7vttyet3firu6v3huxbq334q@jhl56exixqru>
References: <cover.1785621505.git.coshi036@gmail.com>
 <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Sat 01-08-26 18:01:03, Chao Shi wrote:
> A buffer whose write failed still holds exactly the data the filesystem
> asked to be written.  It is the disk that is out of date, not the buffer.
> Clearing BH_Uptodate says the opposite, and callers act on it:
> 
>  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
>    filesystem that dirties the buffer again after a failed write - which is
>    the normal way to retry - trips it.  That is the warning this series
>    started from.
> 
>  - a buffer that is not up to date gets re-read from disk, which replaces
>    the data the filesystem was trying to write with the stale on-disk copy,
>    silently.
> 
>  - the window between the write completing and the buffer being marked not
>    up to date is visible to anyone holding the folio lock, so the state is
>    not even self consistent while it lasts.
> 
> BH_Write_EIO already records the failure, and by now every place in the
> tree that needs to know about it tests that flag instead: the two core
> helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
> omfs, converted one filesystem at a time in the preceding patches.  The
> private completion handlers in jbd2 and ext4 fast commit were converted
> along with their waiters.  Nothing is left that reads BH_Uptodate to find
> out whether a write failed, so the clears can go.
> 
> Found by FuzzNvme.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>
> ---
>  fs/buffer.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index ac978d9090c2..0002f0736398 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
>  	} else {
>  		buffer_io_error(bh, ", lost sync page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  	unlock_buffer(bh);
>  }
> @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
>  	} else {
>  		buffer_io_error(bh, ", lost async page write");
>  		mark_buffer_write_io_error(bh);
> -		clear_buffer_uptodate(bh);
>  	}
>  
>  	first = folio_buffers(folio);

Please remove setting of the uptodate flag from these functions as well.
Write IO completion shouldn't really touch the uptodate flag at all...

Hum, maybe we should actually clear the BH_Write_EIO flag on successful
write completion in all the end io handlers. And then we can drop the
clearing from __bh_submit(). And this will actually also address the
concern Sahiko raised (mostly harmless but still) that if the user gets to
check BH_Write_EIO after another process managed to redirty the buffer and
resubmit it for IO, it can miss detecting IO error that happened.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
