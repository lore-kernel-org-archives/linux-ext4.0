Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7266F3B637C;
	Wed, 26 Aug 2026 07:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730717; cv=none; b=ZI1uCf1nvZ5opcMWtAPW48uNvAfgj7kL9dBneCj7qL1N5Kf+mJKsgDCTsUajo6OkDMltkFcFmUMlRcaznGeykE9QraIxYIhZKpYlbXWwQdJO+erbDoG4YUD+iH7oGJu5GXNqQEC2AHSFSDgMhLM2+MZUCXa6TWBbRv7kZt6vB3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730717; c=relaxed/simple;
	bh=XCbD+sx7CZGssODFXnuM6YS+QGWK9a/4/kkG+aXLeck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iJ/LZx0hAi1f0jZHRJt9KUOqrxhoulpnP7meYX/yvrHElA0JPe9f1VRQyodC7qj0uVPFX2vCruRPoIEtM7OQjww1+jG0FJFI2oJ1zGdPQk4QqgbmqoQYnRZXIPzmwqet7PqF4ms+ZPLL0zHTKpsNdfdb87eY9rohWUSz6GF1Zis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=rOh5pcFH; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=cozWz2Kt; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=y2EON6aq; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Jaz6yMzp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="rOh5pcFH";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="cozWz2Kt";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="y2EON6aq";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Jaz6yMzp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 25DF21F7F9;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AHzPLxNfmFOzVgCOf0wN2NXtl5b3r3RzSHsdHwNMsB8=;
	b=rOh5pcFHRnuIyRbW7GDMuJXMv0tY7FmkDrNxy+mVBjkB1/aqn1RwSAdwEQ51M77ex3Yn6S
	O3E8UY51imRY+I8epheBKycOqdrqAJMLVf+0aLEwhu4ev+nbkoEoNRtpDP2M4YOMcyvQ7j
	HpztyVIL1veDdRSiWKX4JnLKgWNlxk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AHzPLxNfmFOzVgCOf0wN2NXtl5b3r3RzSHsdHwNMsB8=;
	b=cozWz2Kt2QXq9/W6/hS8Xwooeo+OmaqbmREPM0z9xHMC5pyI42aJEPAJ6nFdhLjlbpordt
	b2wRQPcInOKD+3AA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y2EON6aq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jaz6yMzp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AHzPLxNfmFOzVgCOf0wN2NXtl5b3r3RzSHsdHwNMsB8=;
	b=y2EON6aq9XvK7mB48SyavznIMSwCf9kZ3Nls2VaMqrIbdwksDgdSs6R0OLxL5WOLn6cBKk
	xc4uMKCYnoZCQafPa2mExUk3LJAE+su69iCdIya60hHDYZKcLvXFzS9HYMrlk8a87hUtza
	8g1DljZi/01rOYMXb1ds/1nfRZsW26c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730595;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AHzPLxNfmFOzVgCOf0wN2NXtl5b3r3RzSHsdHwNMsB8=;
	b=Jaz6yMzpr5OXvxoliCt10Dwf/6viViuE0Ih4FNUy6/B+gzifOfaTlPE0ng9XvffOAz8aj/
	23RsJ0IoiLtQnqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 161801364F;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l1x5BaOajmrrCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 57B5CA13AD; Tue, 25 Aug 2026 18:17:56 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:17:56 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Zhang Yi <yi.zhang@huaweicloud.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Weidong Zhu <weizhu@fiu.edu>
Subject: Re: [PATCH v2 11/21] exfat: check for a directory write error with
 buffer_write_io_error()
Message-ID: <gges2wdstgy2ipca6hulvkprin3cir6z2x6nslg3iqa4jg2fmu@lpgf7vokma54>
References: <cover.1785951556.git.coshi036@gmail.com>
 <0784ef63a525434e7c0aff730eca7b43e043095d.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0784ef63a525434e7c0aff730eca7b43e043095d.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 25DF21F7F9
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[fiu.edu:email,suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 06-08-26 12:58:34, Chao Shi wrote:
> exfat_update_bhs() waits for the writes it issued and then tests
> !buffer_uptodate() to find the ones that failed.  That relies on the write
> completion handler clearing BH_Uptodate on error, which this series
> removes: a buffer whose write failed still holds the data the filesystem
> asked to be written, so declaring it not up to date is wrong and makes
> callers re-read it.
> 
> Test BH_Write_EIO, which is what the completion handler sets and what this
> code actually wants to know.
> 
> No behaviour change today - a failed write sets BH_Write_EIO and clears
> BH_Uptodate together.  It stops being a no-op at the end of the series,
> where the new test is the one that still works.
> 
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/exfat/misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
> index 6f11a96a4ffa..dfd0bbf31c94 100644
> --- a/fs/exfat/misc.c
> +++ b/fs/exfat/misc.c
> @@ -187,7 +187,7 @@ int exfat_update_bhs(struct buffer_head **bhs, int nr_bhs, int sync)
>  
>  	for (i = 0; i < nr_bhs && sync; i++) {
>  		wait_on_buffer(bhs[i]);
> -		if (!err && !buffer_uptodate(bhs[i]))
> +		if (!err && buffer_write_io_error(bhs[i]))
>  			err = -EIO;
>  	}
>  	return err;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
