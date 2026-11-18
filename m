Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001459;
	b=t5vvWbZTzxxOCS+9rB2V/VDz45nTqfrAUto7dAOWPRSUqPDUsbhZMrX+v76ZyKp9CWvm
	 832VpHoA2ttQ8SRPFSG92BHAAZsuuq5/MXmLOemHxZsEnxBHO1hH+NQkXYkEzq+buz7S/
	 hmAFPbZwq6YA/namYnzTr0jZaAFNK1Kze2OpwyQharB/9Sg+8ZwKZS5o3GbguCBx/Qko7
	 MUf2u1p9/FhDFMkksaKLUujJgynwo06iI9JGQx7iWj/pwcLLl+qxlYycFVC3yQRmlo+JS
	 WT3rUjKIknvh8hnNg1bYDYhYzjaalznB4liscVxdlazhGs40+Est5lCvuFcgusTXYTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001459;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=finFtFd55D9AfQW/KhkVg+EcflCFfdRfis3CjIr5nD4=;
	b=lGEJAfB3rra7OH+O1ywotA2MDqf2T4ipl+glmvxSp2GchFoyXLgn20vnW6ZfBpjs1ZKx
	 WGNAYc3PPymZjix9mEDbb+U9IsvkFbMAXTRtuBRAbsTVUKLeWJND8OQzM5k2gLq1yFinw
	 5LVOneUvxCgjGg47xXD+AxhkPq48A2Az+MfJYDO4oVr38QoFZPUqN9e6igBTKQUD/vNL/
	 vr9rGkGVRiQks/BIGauBq+ly7Swyksfv2icnI/VgRVn+80oW05hYum0umrT4hlj0rkLo8
	 RPMGk9ehxQ3qKpaNEojIaE6JM+iUgOP+lM5LL0l+jLCdUoU9RNIg88IlT/N/8BiifYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t98bH0Dl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OhIZt3tc;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t98bH0Dl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OhIZt3tc;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6D606A31C;
	Wed, 18 Nov 2026 11:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63B6D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t98bH0Dl;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OhIZt3tc;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=t98bH0Dl;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OhIZt3tc
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 35FE022323;
	Wed, 18 Nov 2026 11:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795001457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=finFtFd55D9AfQW/KhkVg+EcflCFfdRfis3CjIr5nD4=;
	b=t98bH0DlBzSUB4Pjf11EO8c/8xXfrQywOsRrlivJVxMMWHzi6CkQY2rMdUUn86RlHkfge1
	TRkiaVin1xPS5jU5w28RFBDQEobFHPCuMOBiwa3hWCn7g7jh20DM8z0RKNByHQwClsoZrR
	ZL7h6wVx1TVD1q/tXDyXGoiG8XJ3M6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795001457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=finFtFd55D9AfQW/KhkVg+EcflCFfdRfis3CjIr5nD4=;
	b=OhIZt3tczxGH2HTpBNdFAhaEcDI3qzTW3U/l5jMEzZqzWjVdSKjekGiU+YFyzuHZvDG8/C
	shbgSR/hSvwT5jAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795001457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=finFtFd55D9AfQW/KhkVg+EcflCFfdRfis3CjIr5nD4=;
	b=t98bH0DlBzSUB4Pjf11EO8c/8xXfrQywOsRrlivJVxMMWHzi6CkQY2rMdUUn86RlHkfge1
	TRkiaVin1xPS5jU5w28RFBDQEobFHPCuMOBiwa3hWCn7g7jh20DM8z0RKNByHQwClsoZrR
	ZL7h6wVx1TVD1q/tXDyXGoiG8XJ3M6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795001457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=finFtFd55D9AfQW/KhkVg+EcflCFfdRfis3CjIr5nD4=;
	b=OhIZt3tczxGH2HTpBNdFAhaEcDI3qzTW3U/l5jMEzZqzWjVdSKjekGiU+YFyzuHZvDG8/C
	shbgSR/hSvwT5jAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F4951334C;
	Wed, 18 Nov 2026 11:30:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1Rm7NnCM/WqSAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 11:30:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9472A25012; Wed, 18 Nov 2026 12:30:56 +0100 (CET)
Date: Wed, 18 Nov 2026 12:30:56 +0100
From: Jan Kara <jack@suse.cz>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH] ext4: fix wrong unit of ratelimit_interval_ms sysfs
 attributes
Message-ID: <varvaw6u3l26vwumguoemlidckuunpcofhwii6fzzt2hajhdjz@oojqvejz3cvf>
References: <20261116161701.3664310-1-ekffu200098@gmail.com>
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
In-Reply-To: <20261116161701.3664310-1-ekffu200098@gmail.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,vger.kernel.org,linux.ibm.com,gmail.com,huawei.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30

On Tue 17-11-26 01:17:00, Sang-Heon Jeon wrote:
> The interval of ratelimit_state is in jiffies. But the
> ratelimit_interval_ms sysfs attributes are read and written without
> converting the interval, so the values are in milliseconds only if HZ
> is 1000.
> 
> If HZ is 250, the default interval of 5 seconds is read as 1250, and
> writing 5000 sets the interval to 20 seconds.
> 
> So use jiffies_to_msecs() and msecs_to_jiffies() when reading and
> writing. Also reject values which are too large for the interval.
> 
> Fixes: efbed4dc5857 ("ext4: add ratelimiting to ext4 messages")
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  fs/ext4/sysfs.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 923b375e017f..7cc3a2e663f0 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -33,6 +33,7 @@ typedef enum {
>  	attr_mb_order,
>  	attr_feature,
>  	attr_pointer_pi,
> +	attr_pointer_pi_msecs,
>  	attr_pointer_ui,
>  	attr_pointer_ul,
>  	attr_pointer_u64,
> @@ -215,6 +216,11 @@ static struct ext4_attr ext4_attr_##_name = {			\
>  #define EXT4_RW_ATTR_SBI_PI(_name,_elname)      \
>  	EXT4_ATTR_OFFSET(_name, 0644, pointer_pi, ext4_sb_info, _elname)
>  
> +#define EXT4_RATELIMIT_INTERVAL_MAX_MS	(INT_MAX / DIV_ROUND_UP(HZ, MSEC_PER_SEC))

I was staring at this for a while before I understood what's going on here.
Please add here a comment like:
/* Limit value so that we fit into int after a conversion to jiffies */


Otherwise the patch looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
