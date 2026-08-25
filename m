Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422593812EF;
	Wed, 26 Aug 2026 07:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730644; cv=none; b=BoUZqJxs7XoWqYJYmbKGC1hn4qgiA4yglURDWv79XnJioV4cFVomPkuvwqLYiS8yAPcLy1XFxKVYlDqrYRwH/zjSmE9Ur6ngRkHhWyYk0yU2/GOOVesrlkCCLetzHKqXz2W2IAuO7OqLW5bt8ZWXy0N+pUAJsrBw8x7aPzfZxTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730644; c=relaxed/simple;
	bh=hpLkpYcUayQRjBT6QO7R5N9TlVHZHyZCMgi91HMAzgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FllVkuXWySw3RZa25s5QhGL9tVrWqiRyBRRYt5Q7YVtF2ai7MNqUbWQvQThiEf2HcTJYQccEqlvfMmtMoFEkot8+blm8v05fdcalgaNpBujfKIjt9ji9wtRW2RyBaBrrVX8kfAhPG9xGIpfk55L9ESzVWozJENkXf1QFFq2ldtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=A1mo6xCV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=osdnXDnu; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=q0XB/VhD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YbEAE3HZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="A1mo6xCV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="osdnXDnu";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="q0XB/VhD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YbEAE3HZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 69277872B6;
	Wed, 26 Aug 2026 07:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpPuxVePH5yolIPTygGNuYjjgnDJr4UHSdys9kpnyyI=;
	b=A1mo6xCV2NBJua427QuDzlakirPouuede/DLM9Mnwaa/1Q6+Fl+1vK+99KRSILqPy6JSqo
	IVQdYXaTgH6eCKhvvTXQjfF4lI4VcoWSMxd4y5yZXUq3Kj9xJlC9CU15leBcA/0+X1K4e0
	y2wEk/BGLf6gDAHQDOy/h5vkIxyYNvo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730602;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpPuxVePH5yolIPTygGNuYjjgnDJr4UHSdys9kpnyyI=;
	b=osdnXDnu9GVaoWjVt7r7SokMLtliW+yD+kGT/IEwRlP3hmpN3RCaTm/73rdGeHQlY03pHv
	lgnhebA9tgUzC3Cw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="q0XB/VhD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YbEAE3HZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpPuxVePH5yolIPTygGNuYjjgnDJr4UHSdys9kpnyyI=;
	b=q0XB/VhDAvQtXpbVJlthgOqJbWhZX0XcqFtRmLD+pCIfBhfKlORi5bskvESIE/47ckauVv
	NKBzyFFbyMCDUamB6tDzhd1yRqeHJn4jmL61BZFfymj28tAvk8pb/BG26CFjOGQdHcc5R6
	Lo38VU93EHINBxQTc/bOjiXss1EOk4I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730598;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vpPuxVePH5yolIPTygGNuYjjgnDJr4UHSdys9kpnyyI=;
	b=YbEAE3HZkFgQ9zynhjmj88oHCfjCMJSz5EskGuo32/t6HUB52TULWqc3GgMPOk66wjbj6s
	s8R0wMxKNGuZiqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6691313682;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 67zkGKOajmr+CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 028B6A13A7; Tue, 25 Aug 2026 18:12:12 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:12:12 +0200
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
Subject: Re: [PATCH v2 08/21] adfs: check for a directory write error with
 buffer_write_io_error()
Message-ID: <xwgl6g26tpkdu2uglbiigy6o745mukzefg6i5mnped3ngyvuhp@angb5zfjuhev>
References: <cover.1785951556.git.coshi036@gmail.com>
 <05cf8ad911ad7a6eb68f42e38f1eea39c38e246b.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05cf8ad911ad7a6eb68f42e38f1eea39c38e246b.1785951556.git.coshi036@gmail.com>
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[gmail.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 69277872B6
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On Thu 06-08-26 12:58:31, Chao Shi wrote:
> adfs_dir_sync() spots a failed write by testing BH_Req together with
> !BH_Uptodate.  That relies on the write completion handler clearing
> BH_Uptodate on error, which this series removes: a buffer whose write
> failed still holds the data the filesystem asked to be written, so
> declaring it not up to date is wrong and makes callers re-read it.
> 
> BH_Write_EIO says exactly what this code wants to know, and it implies
> BH_Req, so the pair collapses into one test.
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
>  fs/adfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/adfs/dir.c b/fs/adfs/dir.c
> index 11afa9e157aa..b8cc6a697a05 100644
> --- a/fs/adfs/dir.c
> +++ b/fs/adfs/dir.c
> @@ -191,7 +191,7 @@ static int adfs_dir_sync(struct adfs_dir *dir)
>  	for (i = dir->nr_buffers - 1; i >= 0; i--) {
>  		struct buffer_head *bh = dir->bhs[i];
>  		sync_dirty_buffer(bh);
> -		if (buffer_req(bh) && !buffer_uptodate(bh))
> +		if (buffer_write_io_error(bh))
>  			err = -EIO;
>  	}
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
