Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6302F3C26
	for <linux-ext4@vger.kernel.org>; Mon, 27 Apr 2026 09:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777283589; cv=none; b=mGnI2OPcHIlndKiH4RAxK6PygOqG/w2s23kF92b8CrYfLAQsOYvRjG1Jw/WGKRrHhcPIukPhswpbkxD3kchJI2nvt7kARXAYY4rGHSozeQNAbWk1fFSnbHJfg9wJ9C1UDQpAoBWp34XPY32LAeOS7U8yqu15E+w/XWRs4Ll5evc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777283589; c=relaxed/simple;
	bh=6/RbJKWhx2XbWjZ5+oa6pzcdPRytoJwxCQDkNB+XiBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzSVWzjUzbhYPrVGXeMDyLpyUifjzig2MvFI3Cw7Disy8LDIq6QMAst4tX+vXv180jslnrcwOBy/0JPKoycqC2eMFUmDShZSjceLhIYaxEyHimCUg2t6W/6wrOTK8BiAm0YEFWps0yVvsZSjwcuh3W3y0HEkYOSH7atMYi2Sdv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UegfBLNp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tc9xnou5; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=UegfBLNp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Tc9xnou5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UegfBLNp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tc9xnou5";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="UegfBLNp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Tc9xnou5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6CA265BD0A;
	Mon, 27 Apr 2026 09:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777283586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXlDoVPyr2lKHA0pOPZSGsXcqx4oBNnpddERdjSIFcI=;
	b=UegfBLNpK/dP3hEupvZZbRlGH0pXHrKBqX+WY3STD3/u3iPsAOxHlydpeJDZtivc3e1KQG
	md7k5ax3By0XzhH57YKrwJs11zsy0hzXJGzwAZP01p5kwV181YqruXCrMH5Joz8jUNVmZD
	uyzPoEFDeV8pZ2kv10IWZGnSvinpMJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777283586;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXlDoVPyr2lKHA0pOPZSGsXcqx4oBNnpddERdjSIFcI=;
	b=Tc9xnou5ZWfXdM+2Sr7djWbUJNVbgoaByJRU2XtK3IIy9T2Ktbz5wfJdX7p6+w/eXSLXDW
	4IWLag3iwsjl37Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UegfBLNp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Tc9xnou5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777283586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXlDoVPyr2lKHA0pOPZSGsXcqx4oBNnpddERdjSIFcI=;
	b=UegfBLNpK/dP3hEupvZZbRlGH0pXHrKBqX+WY3STD3/u3iPsAOxHlydpeJDZtivc3e1KQG
	md7k5ax3By0XzhH57YKrwJs11zsy0hzXJGzwAZP01p5kwV181YqruXCrMH5Joz8jUNVmZD
	uyzPoEFDeV8pZ2kv10IWZGnSvinpMJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777283586;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RXlDoVPyr2lKHA0pOPZSGsXcqx4oBNnpddERdjSIFcI=;
	b=Tc9xnou5ZWfXdM+2Sr7djWbUJNVbgoaByJRU2XtK3IIy9T2Ktbz5wfJdX7p6+w/eXSLXDW
	4IWLag3iwsjl37Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DFA9593B0;
	Mon, 27 Apr 2026 09:53:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rKLnFgIy72l3cAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 27 Apr 2026 09:53:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 18935A0AFF; Mon, 27 Apr 2026 11:53:02 +0200 (CEST)
Date: Mon, 27 Apr 2026 11:53:02 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] ext4: fix LOGFLUSH shutdown ordering to allow
 ordered-mode data writeback
Message-ID: <2d5eyieiqd4x6tum66jdrhriuknaoxeihy7yzpivgthdu4myrk@4fhxp6ngjsjs>
References: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424104201.1930823-1-yi.zhang@huaweicloud.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 6CA265BD0A
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Fri 24-04-26 18:42:01, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> In EXT4_GOING_FLAGS_LOGFLUSH mode, the EXT4_FLAGS_SHUTDOWN flag was set
> before calling ext4_force_commit().  This caused ordered-mode data
> writeback (triggered by journal commit) to fail with -EIO, since
> ext4_do_writepages() checks for the shutdown flag.  The journal would
> then be aborted prematurely before the commit could succeed.
> 
> Fix this by calling ext4_force_commit() first, then setting the
> shutdown flag, so that pending data can be written back correctly.
> 
> Note that moving ext4_force_commit() before setting the shutdown flag
> creates a small window in which new writes may occur and generate new
> journal transactions.  When the journal is subsequently aborted, the
> new transactions will not be able to write to disk.  This is intentional
> because LOGFLUSH's semantics are to flush pre-existing journal entries
> before shutdown, not to guarantee atomicity for writes that race with
> the ioctl.
> 
> Fixes: 783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> This fix addresses my new generic/970 test, which fails during the file
> size verification after shutdown and remount.
> 
>  https://lore.kernel.org/fstests/20260424092228.1396658-1-yi.zhang@huaweicloud.com/
> 
>  fs/ext4/ioctl.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 1d0c3d4bdf47..110e3fb194ec 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -830,11 +830,17 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
>  		bdev_thaw(sb->s_bdev);
>  		break;
>  	case EXT4_GOING_FLAGS_LOGFLUSH:
> +		/*
> +		 * Call ext4_force_commit() before setting EXT4_FLAGS_SHUTDOWN.
> +		 * This is because in data=ordered mode, journal commit
> +		 * triggers data writeback which fails if shutdown is already
> +		 * set, causing the journal to be aborted prematurely before
> +		 * the commit succeeds.
> +		 */
> +		(void) ext4_force_commit(sb);
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> -		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal)) {
> -			(void) ext4_force_commit(sb);
> +		if (sbi->s_journal && !is_journal_aborted(sbi->s_journal))
>  			jbd2_journal_abort(sbi->s_journal, -ESHUTDOWN);
> -		}
>  		break;
>  	case EXT4_GOING_FLAGS_NOLOGFLUSH:
>  		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
