Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795430330;
	b=o9HUTc8B8S/TxSQhvP5GPEBeMP/93Kuik3c8NbBsNpXMIrJgLNB9rACi99OwZJmeDIkX
	 WMC9l8siTALQrfD1EmF1bjJdsGbbMIWDMvF14xf1NsM+V+YhCRyk9XjtpSgxEiRUXX+cg
	 xnCLrVexutt9w71G1YtuUetOqpBzqysEhkRwMB6DCSBg7laOEAgfQ/A6eRq6/F6bDA8HX
	 LnwExxeksUhRyHH2q+krg48bh9GXvuIOILgtJhHOa+B3N4xqXQFrIS94kDK0uVLqG9Us6
	 aYLK8Udwf14Re7K5539mjAIUSpbgqJjMd6lLjzYQ/t1cf+SoxLUMak2XCgp91FKxd9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795430330;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=25HQwnu7e3FGuiwMIPkT94HGf3K/Bf7tNaljloY0VDM=;
	b=zoaq//Ub4w0pI7ZTb2Xz9S2/9z7Oyh+31yRfSAUQjVlaauYPgBPWvsWimiB02wbXjfYe
	 OiQ8n8f/IdsPh5Qax30f6RNRKWfuZhNjecoc7hc5+32Qo17h8icd65XoeyKV13pSmQqxE
	 kcol3aOXl7MwGuO/MDvtKdK+KkHscJ5TbO7N87xYA7cdGCeLVjuOoMwyVLixrNaxVlfNu
	 QeqfVSB6LjSDrTXpL+qONsaYZ8om/o3gHtCloJuNOO7yMj64YLP3Dyyw3zdVdHBfv3EVM
	 ISI3Jp1X7fDC5g3mjqjxmmJQqsWVzj7BoXaGUa+/91GuEhxsKuLfXLuCCEpcgvYE9iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eXFg6f0E;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EOI4hZlt;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=VgMODSmF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QMQzL15M;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FD5606A31E;
	Mon, 23 Nov 2026 10:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8FD5606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=eXFg6f0E;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EOI4hZlt;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=VgMODSmF;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=QMQzL15M
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B67FD22098;
	Mon, 23 Nov 2026 10:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795430328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=25HQwnu7e3FGuiwMIPkT94HGf3K/Bf7tNaljloY0VDM=;
	b=eXFg6f0ETZg6Z005XQCOn7gRg3XRZYpcBd/STGQVniKXeDk0p8g1oxe6eIMxNhdxQjRXBd
	G6OW6+eN1BQvlLv40cbtrOlu0sU011Eu3F+0Pwe5qc/x2D5R35lojwaoV7Q2LOiOxe2nNJ
	oVrpbnUKkzPXhApFsT7VomP5m6DcQmU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795430328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=25HQwnu7e3FGuiwMIPkT94HGf3K/Bf7tNaljloY0VDM=;
	b=EOI4hZlte2PozI7e75cDQ5JyubRkVvRc3Zm0mM8g0w+6KuyCyDpd1QAkXaSHSLb7QUtmBl
	un7UTguWKvUEGRDg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VgMODSmF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QMQzL15M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795430326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=25HQwnu7e3FGuiwMIPkT94HGf3K/Bf7tNaljloY0VDM=;
	b=VgMODSmF11gwFn08muFFUuXAPKh2NR5Nmbe2A9fdhlgq5mwfUoUGzRsfw410SGfgs2kXU9
	gV01oRajU7l+4KSa3x5J8dJ5wuMpzGORO81Jav/RZ1YpHG3UHJ5M5VkaGchrbuDpAhliFM
	rcHI0geL4rClm4xKYkkTLQd3ks3ODbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795430326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=25HQwnu7e3FGuiwMIPkT94HGf3K/Bf7tNaljloY0VDM=;
	b=QMQzL15M0ID233nroooDuiyVoPowyyJasKmFSfmcbB1S8NX8oCb0EowiT3Aupu2OhzKCBR
	A9l3h6X5VXSaMbDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F79C13510;
	Mon, 23 Nov 2026 10:38:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 854JG7YXBGtTawAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 10:38:46 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 192702764E; Mon, 23 Nov 2026 11:38:31 +0100 (CET)
Date: Mon, 23 Nov 2026 11:38:31 +0100
From: Jan Kara <jack@suse.cz>
To: Arbab Haider <arbabhaider649@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH] ext2: handle NULL fc->source in ext2_msg_fc()
Message-ID: <csic66pmgrepiii5gkegqjykm3oceytmjymq323kqpx3mzlfrf@u6leijtq2hrh>
References: <20261122182331.13740-2-arbabhaider649@gmail.com>
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
In-Reply-To: <20261122182331.13740-2-arbabhaider649@gmail.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[1d23ad199a3bfd6f9149];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,vaf.va:url,suse.cz:dkim,syzkaller.appspot.com:url]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: B67FD22098

On Sun 22-11-26 23:23:31, Arbab Haider wrote:
> With the new mount API (fsopen()/fsconfig()), userspace can pass mount
> options such as "nobh", "dax", or "reservation" before setting the
> "source" parameter, leaving fc->source as NULL during option parsing.
> 
> In ext2_msg_fc(), when fc->purpose != FS_CONTEXT_FOR_RECONFIGURE,
> strrchr(fc->source, '/') is called unconditionally without checking if
> fc->source is non-NULL, causing a kernel NULL pointer dereference:
> 
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: 0010:strrchr+0x24/0x80
>   ext2_msg_fc+0x157/0x1e3
> 
> Check fc->source before calling strrchr(), and omit the "(%s)" device
> prefix when s_id is NULL or empty (e.g., when source is unset, empty,
> or ends with '/').
> 
> Tested locally in QEMU (x86_64, KASAN+UBSAN) using fsopen()/fsconfig()
> with NULL, empty, trailing-slash, relative, and full-path sources.
> 
> Reported-by: syzbot+1d23ad199a3bfd6f9149@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=1d23ad199a3bfd6f9149
> Fixes: 98f18c76c2c3 ("ext2: create ext2_msg_fc for use during parsing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>

Thanks but I've already merged a similar fix on Friday to my tree.

								Honza

> ---
>  fs/ext2/super.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 54a6c26d0..c99367652 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -89,20 +89,25 @@ static void ext2_msg_fc(struct fs_context *fc, const char *prefix,
>  
>  	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
>  		s_id = fc->root->d_sb->s_id;
> -	} else {
> +	} else if (fc->source) {
>  		/* get last path component of source */
>  		s_id = strrchr(fc->source, '/');
>  		if (s_id)
>  			s_id++;
>  		else
>  			s_id = fc->source;
> +	} else {
> +		s_id = NULL;
>  	}
>  	va_start(args, fmt);
>  
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  
> -	printk("%sEXT2-fs (%s): %pV\n", prefix, s_id, &vaf);
> +	if (s_id && *s_id)
> +		printk("%sEXT2-fs (%s): %pV\n", prefix, s_id, &vaf);
> +	else
> +		printk("%sEXT2-fs: %pV\n", prefix, &vaf);
>  
>  	va_end(args);
>  }
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
