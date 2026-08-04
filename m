Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE96429CF2
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785833369; cv=none; b=SwtolF6NLlb120kD3hLF9P5SBQ3H2zDRqd0HFo1jqoL4dK0fuu6Q11W+6FGjGhgHw5LJ7Gq4cXOc4nQW1H9M4gFWx9aNZlaTUJvUQ0wEEnO2M/TmE+KD6K6vfR8upOngcw00A1KenzUY0TTsgWbVCJUCcQ8fzIObI0SnPOzKmqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785833369; c=relaxed/simple;
	bh=dF4scuXWvD23kCwingMzXWqFuk6IVoLwQM6KKFUJcTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVQfAU/jAIc8WZWZtL7PENc+/+UHLIkx1Y3Pmq9TfVUIijWgqaE3PJ2frDlFQpAzc6i2uZmMrOKUcBAp150cinZmdIciIkNGtFYIqsjsQENRA6z4ymdi8VsJa9/HuKsm9iiXshdM6vYD+rCiMYqQUmsXx7Pu3E1XV5BEuVCzKdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Kx9nJWft; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=CSxOdfYm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=GJw8f3Q8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=zP7pt2Bs; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Kx9nJWft";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="CSxOdfYm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="GJw8f3Q8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="zP7pt2Bs"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 283867F72E;
	Tue,  4 Aug 2026 08:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785833361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tTMLkJ1Zy3XOygz4WgrC6rjuZ02/P3Jll4UXDnuLtQ=;
	b=Kx9nJWfth1ZxY2vI+m9O7fylsHvWEPLY+PkQso0TS6YgSrgnPYf1wHOBx7KdyKoobMGmrQ
	Qnv0O4VkSquh/udfvv3D0yDP6dNkIQ1296bNZ8o6SWBtAuXuj5N/w70q2X+6lKLWI6OTME
	SP0Gx1nVAtcdDM3GZJL2FfO2qxk9G40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785833361;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tTMLkJ1Zy3XOygz4WgrC6rjuZ02/P3Jll4UXDnuLtQ=;
	b=CSxOdfYmLgOFwUY+nZP8FyXmgeMsnxLK6Km1juoeyEYSFv0GUNPD8bbwS1iDVG1yC1cU85
	6SjEYvUf3iJUDzDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GJw8f3Q8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zP7pt2Bs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785833357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tTMLkJ1Zy3XOygz4WgrC6rjuZ02/P3Jll4UXDnuLtQ=;
	b=GJw8f3Q8ulnJEKFcPxoldUmFUswAPLCSDa1Y0UPouS+yReIitCNjrKVWBtCbN6dmOKWoHt
	eTJo1mnL/jt3JQMH5Jh+14o12Xku/2X2FD3I/rzrFNZspiSkxkFgmqSl8H3I0tzsiIklEU
	Pctyrp1sYFEnWzjMM9ZEZEALfRxWfYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785833357;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4tTMLkJ1Zy3XOygz4WgrC6rjuZ02/P3Jll4UXDnuLtQ=;
	b=zP7pt2BsR9Y8B6kLP/RToKglCPck/vdWKm3J5pFPpqnChOIOvnQFHWIOFhAM1DJv6AJcMU
	4SWbwqqRjIn3wXAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1BA5F779BB;
	Tue,  4 Aug 2026 08:49:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yem9Bo2ncWo/bwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:49:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BB2B5A13A6; Tue, 04 Aug 2026 10:49:12 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:49:12 +0200
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
Subject: Re: [PATCH 13/19] ocfs2: check for a metadata write error with
 buffer_write_io_error()
Message-ID: <zr3we2xntqhn7ieev2khdkqvoi44vrkyd5hhgxjol2bggcllhr@g4wpvgfolwni>
References: <cover.1785621505.git.coshi036@gmail.com>
 <bd2c982e7c91fcfdb8a326ae8166853351398aa2.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd2c982e7c91fcfdb8a326ae8166853351398aa2.1785621505.git.coshi036@gmail.com>
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
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 283867F72E
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Sat 01-08-26 18:00:57, Chao Shi wrote:
> ocfs2_write_block() and ocfs2_write_super_or_backup() detect a failed write
> by looking at BH_Uptodate afterwards.  That relies on the write completion
> handler clearing BH_Uptodate on error, which this series removes: a buffer
> whose write failed still holds the data the filesystem asked to be written,
> so declaring it not up to date is wrong and makes callers re-read it.
> 
> Test BH_Write_EIO instead.  Note that ocfs2_write_block()'s test is the
> positive one, so the sense has to be inverted rather than the flag simply
> swapped.
> 
> The comment in ocfs2_write_block()'s error arm needs updating for the same
> reason.  It said the clustered uptodate information did not have to be
> removed because the buffer was not marked locally uptodate; after this
> series it is, so the reason no longer holds.  Not advertising the block to
> the cluster is still the right thing to do - the data is in memory but not
> on disk - so only the justification changes, not the behaviour.
> 
> No behaviour change today - a failed write sets BH_Write_EIO and clears
> BH_Uptodate together.  It stops being a no-op at the end of the series,
> where the new test is the one that still works.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>

This looks ok to me so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

but it would be good to get a feedback from ocfs2 maintainers whether the
logic change in ocfs2_write_block() where we now keep the cluster cache
block uptodate after write IO error doesn't break some expectations of
ocfs2.

								Honza

> ---
>  fs/ocfs2/buffer_head_io.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
> index 7bfe377af2df..733ceda79ca1 100644
> --- a/fs/ocfs2/buffer_head_io.c
> +++ b/fs/ocfs2/buffer_head_io.c
> @@ -66,12 +66,14 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
>  
>  	wait_on_buffer(bh);
>  
> -	if (buffer_uptodate(bh)) {
> +	if (!buffer_write_io_error(bh)) {
>  		ocfs2_set_buffer_uptodate(ci, bh);
>  	} else {
> -		/* We don't need to remove the clustered uptodate
> -		 * information for this bh as it's not marked locally
> -		 * uptodate. */
> +		/*
> +		 * The buffer still holds what we tried to write, but it did
> +		 * not reach the disk, so don't advertise it to the cluster
> +		 * as up to date.
> +		 */
>  		ret = -EIO;
>  		mlog_errno(ret);
>  	}
> @@ -446,7 +448,7 @@ int ocfs2_write_super_or_backup(struct ocfs2_super *osb,
>  
>  	wait_on_buffer(bh);
>  
> -	if (!buffer_uptodate(bh)) {
> +	if (buffer_write_io_error(bh)) {
>  		ret = -EIO;
>  		mlog_errno(ret);
>  	}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
