Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794407569;
	b=HmhcMRnvYs5Dha1kAbQYzO1ZS3u5FmCyNZB/uUwrYpD4gsTzwDWAmBmh+vGe1zchIEnV
	 NoI/lwBOAiVqfjsEWhBQeiOLwX8GLnxiGv+kd2a5mQ7MAbQCkugjcGEztwNwhnOo9L5hu
	 HmqWsa0ePx+S/S1sKOzOSX5aKhCGm+4QHLMTbkLOj3vHnso5zg5F+safKoys6DZzX2GDv
	 K6wOs36gDIOLsBb4VytANOmoOpodWsfIQHQfVpJT3Brj6j1rf68ieBf7UKPqkVUQnwz5+
	 4Kr2JIJqdplfgIsIUVVMCr5Prwu9IaHGmXACrPgPhXBGfCCM/SY2Thkse07tqEKOLCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794407569;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=iuAEn3ToV9/xlRVs/meef4o8smqKL3aYt8e18TDIqp8=;
	b=Cx5wKwB0XSa02G4rkF0X7Kpum7sxo4JZcsnYD12OiizCobQW2qVJ6b7SlgI+6M8772m9
	 xXOrqjBmBSTlJi+HVPayNPAv0G4WJRIVT3QkjBNl+KKDUje8L6j/XFGmsi6ipBZSSTlkw
	 GgH43T5dJcujbEM4dZ5xTVLk/Yi2s3C0OHrJPRKSc3hXNqUk0d2875hnupKqWXphskdrG
	 E8k2S7USUGMDF4JiQOKBTAvzAsKjnbe+jUniJ1nfwaHND/upFpXDhIZB15846OA7sEnim
	 GYkzqpqOrR76IoOQ/hzJ2i7ptXDd4BMKVWq0U8lM4KwzUkypKusKz1MLdoWwcrOMhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yysjnDdd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MxZRAOOA;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yysjnDdd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MxZRAOOA;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D05F60A2628;
	Wed, 11 Nov 2026 14:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D05F60A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yysjnDdd;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MxZRAOOA;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yysjnDdd;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MxZRAOOA
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 870D420162;
	Wed, 11 Nov 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iuAEn3ToV9/xlRVs/meef4o8smqKL3aYt8e18TDIqp8=;
	b=yysjnDddhoVxl/CSPMYWi4M9vF3nC8cMPoJtED1cYvuonFdDCuf8uyxgjJeRsVsM1E4HPk
	slWa0/UDC1gAWHCWaXw9OZkfNmkHfLtP94DaEFhAkmA+EyW7Voq2Lp/bhULgu+zlMMkl0e
	/Ah1ctSyZUVAKzilI1S2NzszwK8YKXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iuAEn3ToV9/xlRVs/meef4o8smqKL3aYt8e18TDIqp8=;
	b=MxZRAOOAuVfWasfLkIb/CrrncTOQiA5DAOzabwA6r0lFa+GejN1lhqF25qYlXP0MWNVTMs
	Bs82uopJI/80MQCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yysjnDdd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MxZRAOOA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iuAEn3ToV9/xlRVs/meef4o8smqKL3aYt8e18TDIqp8=;
	b=yysjnDddhoVxl/CSPMYWi4M9vF3nC8cMPoJtED1cYvuonFdDCuf8uyxgjJeRsVsM1E4HPk
	slWa0/UDC1gAWHCWaXw9OZkfNmkHfLtP94DaEFhAkmA+EyW7Voq2Lp/bhULgu+zlMMkl0e
	/Ah1ctSyZUVAKzilI1S2NzszwK8YKXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iuAEn3ToV9/xlRVs/meef4o8smqKL3aYt8e18TDIqp8=;
	b=MxZRAOOAuVfWasfLkIb/CrrncTOQiA5DAOzabwA6r0lFa+GejN1lhqF25qYlXP0MWNVTMs
	Bs82uopJI/80MQCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46603134E5;
	Wed, 11 Nov 2026 14:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9FAEB4589GpxFAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 14:32:46 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C309D22948; Wed, 11 Nov 2026 15:32:45 +0100 (CET)
Date: Wed, 11 Nov 2026 15:32:45 +0100
From: Jan Kara <jack@suse.cz>
To: diasyzhangqing@gmail.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, jack@suse.cz, 
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu, 
	adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, 
	ritesh.list@gmail.com, yi.zhang@huawei.com, 
	syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com, diasyzhang@tencent.com
Subject: Re: [PATCH v2] block: make bdev_freeze() mutex waits killable
Message-ID: <yohtvcxdbwkmtw7ccorsiwzfekpq63gxdgnoiuexind4fc2qhv@c36635vawatf>
References: <20261110132118.11265-1-diasyzhangqing@gmail.com>
 <20261111123530.871952-1-diasyzhangqing@gmail.com>
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
In-Reply-To: <20261111123530.871952-1-diasyzhangqing@gmail.com>
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
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,vger.kernel.org,suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,syzkaller.appspotmail.com,tencent.com];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[d4ecb9a1e5b3dcf8baec];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 870D420162

On Wed 11-11-26 20:35:29, diasyzhangqing@gmail.com wrote:
> From: Qing Zhang <diasyzhang@tencent.com>
> 
> Concurrent bdev_freeze() callers may wait a long time on
> bd_fsfreeze_mutex while another caller freezes and syncs the filesystem.
> Use mutex_lock_killable() to allow fatal signals to interrupt this wait.
> 
> An interrupted wait returns -EINTR before bd_fsfreeze_count is
> incremented, so no freeze reference needs to be dropped. This does not
> make the filesystem freeze operation itself killable.
> 
> Reported-by: syzbot+d4ecb9a1e5b3dcf8baec@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d4ecb9a1e5b3dcf8baec
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Qing Zhang <diasyzhang@tencent.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Changes since v1:
> - per Jan's suggestion, move the killable wait from a new ext4
>   per-superblock mutex into bdev_freeze() itself.
> 
> block/bdev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index f20f91b3176e..e57be2320423 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -301,7 +301,9 @@ int bdev_freeze(struct block_device *bdev)
>  {
>  	int error = 0;
>  
> -	mutex_lock(&bdev->bd_fsfreeze_mutex);
> +	error = mutex_lock_killable(&bdev->bd_fsfreeze_mutex);
> +	if (error)
> +		return error;
>  
>  	/* A device being removed from its filesystem refuses freezes. */
>  	if (!atomic_inc_unless_negative(&bdev->bd_fsfreeze_count)) {
> -- 
> 2.43.7
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
