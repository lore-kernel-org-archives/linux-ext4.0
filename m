Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794831383;
	b=tXFulThVAWAafLymh+RLpDV4pk9oWhX4mL5ZoYFT3FEJQYhbnGGi2BZTwGpv4CUUPdtN
	 KbYPiATqCbI1VXWxiLlNR7YuvO3DDHwdPWNgz1cGJrPJ1B4d+w3OkzoDbDKP1LiPkmh18
	 5CEkUf517iyI+u/DXeb3fxSdYaG50mO7btFAUbnQWLK7gKrzyu2qgpoScZDxqKlWWxXa6
	 ZB1hJannF11XGtepxr+2qp7SZvk+BGdV2zb4r6ydq7dZgA7zBOu2SoCSnUL2rBxvCc8xv
	 DoAno2KffrfJIvSwRb+s/eaeTnlLQtrkBWiYUmRgJqwP+H/C6ZODWuZCX5HAVR59zsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794831383;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=fXse6ibUr4IaWKsM+skxTfvXlFkgvxV6eDmZdcdp2jw=;
	b=XVNdXINe6WQy4DcvLnzEYxSMlx1EdZcy0dpT1M3OVvxFrS05SXco+hreS5usTm/68uhX
	 WUEa9CR15bpPY4T0ShIvoCFtQF0cYE6taD5I1p72OxutquI5/QF+BohfXUuebvH0a23fJ
	 j0T82tWtlGSprDvTUi9qS9PYgoEznfzFC/mU+mpIBe/U1nkAB1NRdHR+mR9nqm/67GUvE
	 PfAECb6OV69Zg4nusdE7pa37sJIsJIRerVXxyjB9yl7UMr7SxhAMTDPaAUEnEiFXbbI50
	 0jMem35FWSaWcwv/DVrpOlk8QY0cwXVY0E7ZaUKVscW7TrKTIHghtFOC6aUbJULBItQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cpVs+vFb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wvf0PCrR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cpVs+vFb;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wvf0PCrR;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4205D606A323;
	Mon, 16 Nov 2026 12:16:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4205D606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cpVs+vFb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wvf0PCrR;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=cpVs+vFb;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wvf0PCrR
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C5DB1FD69;
	Mon, 16 Nov 2026 12:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794831380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXse6ibUr4IaWKsM+skxTfvXlFkgvxV6eDmZdcdp2jw=;
	b=cpVs+vFbqntzIcdjRqgjBERM+YqIo/KSR/Hq9l0p3o0tWQbvrAWIeDNMrbpsUCRLTBMoTj
	OnDVSq083LCIoWX6z/hFqKKyYOL3xiloAliBhyvPvxUS6AJSjIN8WRAes/GigJ6aJ8WLfT
	sf9XrPBfDSllCaDpQNCZBu4MIXGVDaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794831380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXse6ibUr4IaWKsM+skxTfvXlFkgvxV6eDmZdcdp2jw=;
	b=wvf0PCrRDUwQNbNyXNh1PYGpYGBWgoVpLJS4ylmtfezPrEh89MzdqizQ8nw7Rjn68Z+fcM
	EDNJH+k6h3fN3WAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cpVs+vFb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wvf0PCrR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794831380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXse6ibUr4IaWKsM+skxTfvXlFkgvxV6eDmZdcdp2jw=;
	b=cpVs+vFbqntzIcdjRqgjBERM+YqIo/KSR/Hq9l0p3o0tWQbvrAWIeDNMrbpsUCRLTBMoTj
	OnDVSq083LCIoWX6z/hFqKKyYOL3xiloAliBhyvPvxUS6AJSjIN8WRAes/GigJ6aJ8WLfT
	sf9XrPBfDSllCaDpQNCZBu4MIXGVDaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794831380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fXse6ibUr4IaWKsM+skxTfvXlFkgvxV6eDmZdcdp2jw=;
	b=wvf0PCrRDUwQNbNyXNh1PYGpYGBWgoVpLJS4ylmtfezPrEh89MzdqizQ8nw7Rjn68Z+fcM
	EDNJH+k6h3fN3WAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1ED31334C;
	Mon, 16 Nov 2026 12:16:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MXIFNRP0+mrgWgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 12:16:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8FC7224DE2; Mon, 16 Nov 2026 13:16:19 +0100 (CET)
Date: Mon, 16 Nov 2026 13:16:19 +0100
From: Jan Kara <jack@suse.cz>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com
Subject: Re: [PATCH] ext4: use a stable source for the kmmpd thread name
Message-ID: <qz2gh5bbbyqjqfqclatkq34pgxnvbu3ey5kf3octnlykstzhx2@s65dxum2wdso>
References: <20261114172523.5888-1-zhaogongyi@bytedance.com>
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Post: <mailto:linux-ext4@vger.kernel.org>
List-Help: <mailto:linux-ext4+help@vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-ext4+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114172523.5888-1-zhaogongyi@bytedance.com>
X-Rspamd-Queue-Id: 1C5DB1FD69
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:dkim]
X-Spam-Score: -11.51

On Sun 15-11-26 01:25:23, Zhao Gongyi wrote:
> A concurrent MMP mount can make kvasprintf() warn about different
> vsnprintf() return values while creating kmmpd. The call chain is
> ext4_multi_mount_protect() -> kthread_run() -> kvasprintf(): the name
> comes from mmp_bdevname in the MMP block buffer, which may change
> between the two formatting passes.

What can change it? I don't see anything that should be doing that...

								Honza

> 
> Format the device name into a local buffer and use it for the thread
> name while retaining it in the MMP information field.
> 
> Fixes: d6986ce24fc0 ("kthread: dynamically allocate memory to store kthread's full name")
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> ---
> Validation: An x86 QEMU A/B run with the same test-only 1s delay in
> kvasprintf() observed the target warning 201 times without this
> patch. With the fix, no target warning appeared during a 600s
> run. Standalone replay without the delay was not reliably
> reproducible.
> 
>  fs/ext4/mmp.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index 4b18ddef468d7..09622862598b3 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -4,6 +4,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/utsname.h>
>  #include <linux/kthread.h>
> +#include <linux/string.h>
>  
>  #include "ext4.h"
>  
> @@ -277,6 +278,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
>  	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
>  	struct buffer_head *bh = NULL;
>  	struct mmp_struct *mmp = NULL;
> +	char bdevname[BDEVNAME_SIZE];
>  	u32 seq;
>  	unsigned int mmp_check_interval = le16_to_cpu(es->s_mmp_update_interval);
>  	unsigned int wait_time = 0;
> @@ -378,15 +380,16 @@ int ext4_multi_mount_protect(struct super_block *sb,
>  	EXT4_SB(sb)->s_mmp_bh = bh;
>  
>  	BUILD_BUG_ON(sizeof(mmp->mmp_bdevname) < BDEVNAME_SIZE);
> -	snprintf(mmp->mmp_bdevname, sizeof(mmp->mmp_bdevname),
> -		 "%pg", bh->b_bdev);
> +	snprintf(bdevname, sizeof(bdevname), "%pg", bh->b_bdev);
> +	strscpy_pad(mmp->mmp_bdevname, bdevname);
>  
>  	/*
> -	 * Start a kernel thread to update the MMP block periodically.
> +	 * Start a kernel thread to update the MMP block periodically.  Keep
> +	 * the name source on the stack so kvasprintf() observes the same
> +	 * string in both of its formatting passes.
>  	 */
> -	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%.*s",
> -					     (int)sizeof(mmp->mmp_bdevname),
> -					     mmp->mmp_bdevname);
> +	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%s",
> +					     bdevname);
>  	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
>  		EXT4_SB(sb)->s_mmp_tsk = NULL;
>  		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
> 
> base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
> -- 
> 2.39.5 (Apple Git-154)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
