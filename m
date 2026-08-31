Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31D3E6386;
	Mon, 31 Aug 2026 12:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178959; cv=none; b=pojRzV0n7qXRJcX7pYQxbzbW5ACfCnQtoHvI5EAX258PAoybBvdOnAeDGHNUrIMTBBMWqYKZGCdMCk1ttz0g2My/HJXTZhy1ZWMwdMeYD7A5SL48nVpdqIEbxdECAJWUBkY+pN8ojJdbJpgTpoVGNo4gT4Vds0CwvAfrz/iJBGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178959; c=relaxed/simple;
	bh=hQlF+RlBpsVwioFHHo5iBMWnnt4OLnHkD2guK0uNZVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcSCSYauChQdh84MsmY+d7pqrtqfe/jEQyxX46GY1uVJvjkig5TIX4n/4ix/Fif1VHoIime0x0rzcGXRpD6sFsUYKTZdND/5QJQw9pkZ414eZKm0bs31CYGrZWem43lI6CQm8H23cIteXNLIWgPHXZdfw8Ej3AssmPw/CWOWgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=OC/7SLOo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=j9D0w1XB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u3ligTMF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=OsBoF80q; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="OC/7SLOo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="j9D0w1XB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u3ligTMF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="OsBoF80q"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A0111220C7;
	Mon, 31 Aug 2026 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788178951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+VyCKdP0D99p70cQubnM0W79HqKh5lLhDcWO7y/gC4=;
	b=OC/7SLOoljo25hDoEt8sIbyfuHt3DRURPO+P3SQ74DHXv5PYaE5JrQYWRG5idUX0KO9SjE
	zcEWgjUebO9oAdBReCa1LBkV3QuZMNTvSp4dUEdYvhqdypa4tvBAf6ipB7YVU5lEfXPa2h
	7wxSoUqX8lhcQbZGDYaQpnO+zlrAz98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788178951;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+VyCKdP0D99p70cQubnM0W79HqKh5lLhDcWO7y/gC4=;
	b=j9D0w1XBmH9s1twjFn6CY8tcrswaj2YdUnq2qjdfD8CyDIA6ahhzMNSvOLKAcjtk7u5ymL
	gjNRAJmxshAgthDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u3ligTMF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OsBoF80q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788178947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+VyCKdP0D99p70cQubnM0W79HqKh5lLhDcWO7y/gC4=;
	b=u3ligTMF8dv/vxkHJspOdKQKXYgtSnUNZfmdTT44jE+Kiq3XpDqdPX92gcTlm+R8Oi7iDc
	0oyJoQZfkIv1Z4/XEXt5xunybT0W4bK9Xy/nMe45vmG2OJTM/f5M2IoiMB4tEfcdRtvXVi
	hbAnWFHzzCy4Rsm12iEBV2WavpBbbqc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788178947;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+VyCKdP0D99p70cQubnM0W79HqKh5lLhDcWO7y/gC4=;
	b=OsBoF80qxWF0mjLTlizAu7ytXW/sC1OHCf7QDPWrrDFjQQPA7vBzG5hfkdzSWshYMtXqWT
	2kMkU7zOwwHM+PCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B4F213682;
	Mon, 31 Aug 2026 12:22:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /mQZHgNylWpAfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 12:22:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 10781A13B5; Mon, 31 Aug 2026 14:22:23 +0200 (CEST)
Date: Mon, 31 Aug 2026 14:22:23 +0200
From: Jan Kara <jack@suse.cz>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, pmladek@suse.com, rostedt@goodmis.org, 
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, socketcan@hartkopp.net, mkl@pengutronix.de, 
	kuniyu@google.com, willemb@google.com, jhs@mojatatu.com, jiri@resnulli.us, 
	kees@kernel.org, cyphar@cyphar.com, tglx@kernel.org, liuhangbin@gmail.com, 
	sdf@fomichev.me, nb@tipi-net.de, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH 04/11] fs: Use acquire/release for fdtable resize
 synchronization
Message-ID: <cwsvkb2bqq5zvdgqyaz7qarprl6ca6sq54cjiqxtcvzmmm5vrk@bjeea4jm2jad>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-5-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825095422.3166067-5-ruanjinjie@huawei.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: A0111220C7
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[40];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLa77mm4gi8mw7uppieotozii3)];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,kvack.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,suse.com,goodmis.org,linux.intel.com,rasmusvillemoes.dk,chromium.org,linux-foundation.org,davemloft.net,google.com,redhat.com,hartkopp.net,pengutronix.de,mojatatu.com,resnulli.us,cyphar.com,fomichev.me,tipi-net.de,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.cz:email]
X-Spam-Flag: NO

On Tue 25-08-26 17:54:15, Jinjie Ruan wrote:
> Replace the smp_wmb()/smp_rmb() barrier pair with
> smp_store_release()/smp_load_acquire() on `files->resize_in_progress`.
> The flag is the publish point for fdtable expansion: writers clear it
> via release after rcu_assign_pointer(), readers check it via acquire
> before rcu_dereference_sched(). Observing it clear guarantees the new
> fdt pointer is visible.
> 
> This expresses the pattern more clearly and allows cheaper one-way
> barriers on weakly-ordered architectures (e.g. arm64 STLR/LDAR vs
> DMB ISHST/ISHLD).
> 
> Assisted-by: DeepSeek:DeepSeek-V3
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/file.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 628ca07dc4b1..86c035d459f2 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -273,8 +273,6 @@ static int expand_fdtable(struct files_struct *files, unsigned int nr)
>  	rcu_assign_pointer(files->fdt, new_fdt);
>  	if (cur_fdt != &files->fdtab)
>  		call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
> -	/* coupled with smp_rmb() in fd_install() */
> -	smp_wmb();
>  	return 0;
>  }
>  
> @@ -313,7 +311,8 @@ static int expand_files(struct files_struct *files, unsigned int nr)
>  	/* All good, so we try */
>  	files->resize_in_progress = true;
>  	error = expand_fdtable(files, nr);
> -	files->resize_in_progress = false;
> +	/* coupled with smp_load_acquire() in fd_install() */
> +	smp_store_release(&files->resize_in_progress, false);
>  
>  	wake_up_all(&files->resize_wait);
>  	return error;
> @@ -685,13 +684,12 @@ void fd_install(unsigned int fd, struct file *file)
>  		return;
>  
>  	rcu_read_lock_sched();
> -	if (unlikely(files->resize_in_progress)) {
> +	/* coupled with smp_store_release() in expand_files() */
> +	if (unlikely(smp_load_acquire(&files->resize_in_progress))) {
>  		rcu_read_unlock_sched();
>  		fd_install_slowpath(fd, file);
>  		return;
>  	}
> -	/* coupled with smp_wmb() in expand_fdtable() */
> -	smp_rmb();
>  	fdt = rcu_dereference_sched(files->fdt);
>  	VFS_BUG_ON(rcu_access_pointer(fdt->fd[fd]) != NULL);
>  	rcu_assign_pointer(fdt->fd[fd], file);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
