Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655996;
	b=Gal+7bXiyUiWONFz/oY2uFifqkuzBHJxGIQ9tYmxElJ/k4d8OcUA2ar3LXLd/YLn5i03
	 Tjqq0ytuNc+iD43FfosIk3hp1PRywaijuiuZ6eqjAibWbN3OoKr70L6mDfUDHVOuI4gCm
	 Sw9TxUpUW84t4FxEgux9XZRk5VkXCYxs//hVyFKJw8Fqn88eSnidlwpJRv37VBpiOxXwc
	 Z4yRLDsar711ftfBzC7WUcMP6ERTFdlKbrSpdMPgU5LJoXLey6E96R6oxsRmRBNxw8eqi
	 z1a6nkW5uv781bGNPamAOMoD2oBLdDtR6bWTjBwZoCZpCs8WP5xrHuCzDmHhNgwvF7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655996;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=r7osJrqKFY47G7pAE+Ny+zpUsVHSKRVVOjeOqegEKbg=;
	b=B4Svh01a5L6LO9iwuCjHRtIieaHWaCUZ8pfc03+VjdMp6Qd+t4VjPabWSjpLcuWbPq/0
	 mnmHDFd54gcyjNqmmoXmXDxaPHJSi+jGHeYXZiAqxDlv6LIBNsPlfWlaoJIaEsiFKLvna
	 FJ1XGwEYZZV+rwfR1FrPP2YWFUA4IjD91lxHt3g8z9f8hYFNcC4M9I420sepv5m/GLI+w
	 qmoLo9na/NkxC4AzzRIz/1hngBatFGT4EmKneqbsCrMdJFhO7rEPyuYIAJKEhZHdXDLpC
	 ZbpBrt+qbVXPsWUA9OEYH1okBsMLkZr7wY9lvwLZFkLM8bGPid/amnYo9JuOGX/0XQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vTfQN7Qs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UtKAVpYF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yWQE2qaa;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3ykvZvOj;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B58606A332;
	Mon,  2 Nov 2026 21:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 40B58606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=vTfQN7Qs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=UtKAVpYF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yWQE2qaa;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3ykvZvOj
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 668B51FB0B;
	Mon,  2 Nov 2026 21:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7osJrqKFY47G7pAE+Ny+zpUsVHSKRVVOjeOqegEKbg=;
	b=vTfQN7QsrjcpoO+6EBD9chZXiAPui7vhF9TL2OeN8dX6/o1iMUZw3q78KD5mDllhaiRi5k
	1EVXkN3wE/UcFKd97O1y0uKXf48I/OjWLp57E+phnCWnByztxiERhz+DIE51xrdYOFu5eh
	IRMfExj2IPO6C/HA0pa5UxbWvuOsfWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655994;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7osJrqKFY47G7pAE+Ny+zpUsVHSKRVVOjeOqegEKbg=;
	b=UtKAVpYFIMJA6nIDUXhHWHpn+LUsSQDUTOtrNiTESo8YL1eUK96BeeiiWdE6+31VhuHxVg
	sjLCVKqt8UOiUyDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yWQE2qaa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3ykvZvOj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793655993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7osJrqKFY47G7pAE+Ny+zpUsVHSKRVVOjeOqegEKbg=;
	b=yWQE2qaaTyV4EzeoQY/t5qDeTau3Y8x+iYxaKnS0OjDoj3aTumaaPExlcXezEmEqA0X34r
	IV0ymaa3WA/dKUzoWOMKeKAraBJudXiPdcaJYYmq2AlDZU0URH8fDRBAqhqbXlTGotDOJ2
	JQM683hLmWjVIh0juUvswyta6tmmFD0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793655993;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r7osJrqKFY47G7pAE+Ny+zpUsVHSKRVVOjeOqegEKbg=;
	b=3ykvZvOjSIxF0u1DKG53hDTAaLNtzigAuBbL0gh7O00U33e749Wya4r6BkBZ2RSD2vdhty
	j5qfOiBObwRZwKBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18D981351F;
	Mon,  2 Nov 2026 21:46:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uXxWO7gE6WqufwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:33 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id BBC5EB165; Mon, 02 Nov 2026 22:46:32 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:32 +0100
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, yizhang089@gmail.com, chengzhihao1@huawei.com, 
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 1/4] ext4: return 0 instead of stale ret in
 ext4_iomap_writepages()
Message-ID: <x3x4mffcmoljjvvlfnahyykduxrvfyokl4hjx7jg2nc4q47rkf@4pkboz2f3fbp>
References: <20261030021338.1768292-1-yi.zhang@huaweicloud.com>
 <20261030021338.1768292-2-yi.zhang@huaweicloud.com>
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
In-Reply-To: <20261030021338.1768292-2-yi.zhang@huaweicloud.com>
X-Rspamd-Queue-Id: 668B51FB0B
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,fnnas.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,intel.com:email,huawei.com:email,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.51

On Fri 30-10-26 10:13:35, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> smatch reports a "missing error code" warning:
> 
>   fs/ext4/inode.c:4518 ext4_iomap_writepages() warn: missing error code? 'ret'
> 
> The 'ret' variable has already been consumed by the
> ext4_emergency_state() check at the beginning of the function, so its
> value is always zero at this point. Returning it is equivalent to
> returning 0, but it is misleading because it looks like an error code is
> being propagated.
> 
> This branch handles the race with ext4_change_inode_journal_flag(),
> which flushes the dirty data and drops the page cache before switching
> the inode to the buffer_head path, so there is genuinely nothing to
> write back here. Return 0 explicitly to make the intent clear.
> 
> Fixes: bdcbb0f19e92 ("ext4: partially enable iomap for the buffered I/O path of regular files")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/r/202610160314.PLMEXaOJ-lkp@intel.com/
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b4d581aa5ee1a..6b2f1b07f41e6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4515,7 +4515,7 @@ static int ext4_iomap_writepages(struct address_space *mapping,
>  	 */
>  	if (!ext4_inode_buffered_iomap(inode)) {
>  		ext4_writepages_up_read(sb, alloc_ctx);
> -		return ret;
> +		return 0;
>  	}
>  
>  	trace_ext4_writepages(inode, wbc);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
