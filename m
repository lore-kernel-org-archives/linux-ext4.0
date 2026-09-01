Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F273189F43;
	Tue,  1 Sep 2026 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270940; cv=none; b=P55HpyBm4cLXD7h667a2kUu9TNzARhkls/SvOX0TpwixmXkR2Z0sclp2htFF86pM1+yx6VEzjRwhp0Yi8yFqEqiCRN89Gzy4gbEUx/1iUTUhyAcuViY86WoW5SohBUK7WF4ot3XsqX4uehmKt29UIA3VtyIaG/RuJmAnrKDAxcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270940; c=relaxed/simple;
	bh=+lv3JU9YTFJRgUVSopnnbVbsgjFo1rzZBz1rfXXsuCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOR2uQELNJDCzb5p3ANu5eqopCjPY1Z5uxabJurbEyEGLgs5G87srxh8b+MfTQPX7frj2jGtMn8dkjwPWDSuUqd+n4vDAOncSY8g9o2OIC58vKZd6rH9S49E6ITCKADDDeYuzTMoQ0+ECe31NLOtz/O303PqYebDhFRrwhqNFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=DG1vdoEv; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bJPNBMR6; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=SsGE3c2V; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=4vjzU0at; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="DG1vdoEv";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bJPNBMR6";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="SsGE3c2V";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="4vjzU0at"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 021CD1F456;
	Tue,  1 Sep 2026 13:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788270932; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjO7b8BiqciaFISpoTL+zOgGR0VbUuS8pqnqjH6vazg=;
	b=DG1vdoEv/Qe0Ufw2JayuTZr02OWvgr7G423SHFU/Kairm9U5Z+f5HBz/mQId3jru3N7Lzf
	37fkOReTNLktpXlWP9d+IUoGmWhi0q/k8aJWab0axtTF4wCtnFOHl6voPtK3taoodHnOMl
	7R+rcwY014S+Yl23vWANLg3dztg0yN8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788270932;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjO7b8BiqciaFISpoTL+zOgGR0VbUuS8pqnqjH6vazg=;
	b=bJPNBMR6zsGmB2AdER/JH3+bPrI75g1+0FGhZCra2N06UiwchyGorohCU1VvB3bVyVuTDj
	SOHi6E1tjNUAFeAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SsGE3c2V;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4vjzU0at
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788270928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjO7b8BiqciaFISpoTL+zOgGR0VbUuS8pqnqjH6vazg=;
	b=SsGE3c2VCZ1i7jOMs8iGzU1GV2o4dM408bGlh0CwvF3X2RHyIdUs77ToeVcMQhqUl2A38+
	RNHiPLqRAh9x3sjmR1Ak7M0nfPe5cBM9Li2ctePCmhL3IeeeH78eQHoKnfhPRWZg1IGq9o
	4BeOY6g/ttzlzRqdMLLYLVGeIS2aerM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788270928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MjO7b8BiqciaFISpoTL+zOgGR0VbUuS8pqnqjH6vazg=;
	b=4vjzU0atSAzEHkYExz/OGYJLWXLKKYe4QdD8eI9iaqYPpBam7W0AtCOiCgffvpR5P1zj7i
	PnBnC53fXpDyUzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D20FD136A2;
	Tue,  1 Sep 2026 13:55:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eYk7M0/ZlmoaUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 01 Sep 2026 13:55:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6AF7BA13B2; Tue, 01 Sep 2026 15:55:23 +0200 (CEST)
Date: Tue, 1 Sep 2026 15:55:23 +0200
From: Jan Kara <jack@suse.cz>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	bcrl@kvack.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, sforshee@kernel.org, pmladek@suse.com, rostedt@goodmis.org, 
	andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk, senozhatsky@chromium.org, 
	akpm@linux-foundation.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, kuniyu@google.com, willemb@google.com, 
	jhs@mojatatu.com, jiri@resnulli.us, kees@kernel.org, cyphar@cyphar.com, 
	tglx@kernel.org, sdf@fomichev.me, nb@tipi-net.de, liuhangbin@gmail.com, 
	da-x@monatomic.org, jeff@garzik.org, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 07/12] ext4: Fix out-of-bounds read in
 ext4_get_group_info()
Message-ID: <stftjabhlylnomnoc445lfa6cio4fdtdtjlo6awia4xczfpum6@vmnfqv3omqfc>
References: <20260901024234.135119-1-ruanjinjie@huawei.com>
 <20260901024234.135119-8-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901024234.135119-8-ruanjinjie@huawei.com>
X-Spam-Score: -2.51
X-Rspamd-Queue-Id: 021CD1F456
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
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[40];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,kvack.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,suse.com,goodmis.org,linux.intel.com,rasmusvillemoes.dk,chromium.org,linux-foundation.org,davemloft.net,google.com,redhat.com,mojatatu.com,resnulli.us,cyphar.com,fomichev.me,tipi-net.de,monatomic.org,garzik.org,vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLa77mm4gi8mw7uppieotozii3)];
	MISSING_XM_UA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from]
X-Spam-Flag: NO

On Tue 01-09-26 10:42:29, Jinjie Ruan wrote:
> A plain read of s_groups_count in ext4_get_group_info() allows CPU
> load-load reordering. On weak memory models, speculative prefetch of
> s_group_info prior to the boundary check could lead to an out-of-bounds
> read if a concurrent online resize expands the array and increments
> s_groups_count.
> 
> The data race occurs between the ioctl configuration path (holding the
> resize lock via ext4_resize_begin) and the lockless metadata lookup path:
> 
>    CPU 0 (Writer, Resize Lock)                CPU 1 (Reader, Lockless)
>    ---------------------------                ------------------------
>    ext4_ioctl()
>      [EXT4_IOC_GROUP_ADD]
>      ext4_ioctl_group_add()
>        ext4_resize_begin() // Takes lock
>        ext4_group_add()
>          ext4_mb_alloc_groupinfo()
>            // Publishes expanded array via RCU
>            rcu_assign_pointer(s_group_info, ...)
> 
>          ext4_flex_group_add()
>            ext4_update_super()
>                                               ext4_get_group_info()
>                                                 // Speculative / out-of-order read
>                                                 [Loads old/smaller s_group_info pointer]
>              [Plain C store / smp_wmb()]
>              sbi->s_groups_count += ...;
>                                                 // Reads new s_groups_count,
>                                                 // boundary check passes
>                                                 if (group >= s_groups_count)
> 
>                                                 // Out-of-bounds array access!
>                                                 sbi_array_rcu_deref(..., s_group_info)
> 
> Fix this by using ext4_get_groups_count() to enforce acquire semantics.
> 
> Cc: stable@vger.kernel.org
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Baokun Li <libaokun@linux.alibaba.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Zhang Yi <yi.zhang@huawei.com>
> Fixes: 5354b2af3406 ("ext4: allow ext4_get_group_info() to fail")
> Link: https://sashiko.dev/#/patchset/20260825095422.3166067-1-ruanjinjie%40huawei.com
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/balloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 52f4c5169f91..778fe8788f06 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -329,7 +329,7 @@ struct ext4_group_info *ext4_get_group_info(struct super_block *sb,
>  	struct ext4_group_info **grp_info;
>  	long indexv, indexh;
>  
> -	if (unlikely(group >= EXT4_SB(sb)->s_groups_count))
> +	if (unlikely(group >= ext4_get_groups_count(sb)))
>  		return NULL;
>  	if (unlikely(!EXT4_SB(sb)->s_group_info))
>  		return NULL;
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
