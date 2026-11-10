Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794306579;
	b=rV8Qut+kH2zC3gOrzvhF80lZrcGsdw3HDsvAXj9a2gaQtCCUFh2vUzma0ine8lOeUk+N
	 5SQAE8PvsOdok/N9xnw9IenKmFS7Ny4ElXfJdJ0ywE19MFT9ZGgy1DJBiZ1Ec3WQKZj8k
	 I0BfmMOO/GdDDy6FC6HNg3bkRmYGjI/ffCNcjjSSReAWusLaG7dG/wP0gn42nHQLRRodi
	 9nFWW45K55arKvMXn/3zU8XIq8aw7Bkv18J+U0nERltmvEj4Zl2kyP/o8xcds1JW20NgM
	 BBP1SxXBUCf/d8rVlsL61aF7+RfIdB4Dj7k8jwBk4vhojgXMBYPziBqRobFha2/vnuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794306579;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=nw0NgajiFYy/H48l2M72VyZRctVsTCycv6+JT7hes38=;
	b=UAtJb+f7JGUEHQ6sxhmnvqTgfGwqHmwdHaiACu0qtt3EbFPMUj61Z4R0uH4JORJAW9gc
	 3Irfao7sFNxHXcXzuvvVpUq/lPkudnGfMFzAKHCWAmRTPvSyCCasC7bZ0B6+TmCqDw62G
	 YueSd9u+MJIHfU3699n8mmflIo3tInJLqpX7qrXW+EOke/XWzjWqqRIj6980m0lmCmMUh
	 VIUrHAzh1P3x3rtVuptx5JIyHyUIxqOZnbGXOKQq6nxPkLIMevLTbp/QKm+SA9VDU5S0/
	 fPjQf4f9tawl1sF4Qjbuz/o9mKEMt1/FQIHEKIGyoWEDEf6tnkcc0HL+Y9Mg67U5z1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="ZYH9OH/Q";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghFk6Oqj;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="ZYH9OH/Q";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghFk6Oqj;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F529606A321;
	Tue, 10 Nov 2026 10:29:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F529606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZYH9OH/Q;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghFk6Oqj;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZYH9OH/Q;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ghFk6Oqj
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2705C21EB1;
	Tue, 10 Nov 2026 10:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nw0NgajiFYy/H48l2M72VyZRctVsTCycv6+JT7hes38=;
	b=ZYH9OH/QzT78U70GM13G/jwBPK0e1H7H/WdqIsP8SeWpPlM2XIrTQRqtJ7ZQGYyZb8XPrb
	ii/CzvI6C6gMbbDET5DSUxjcK9ip+Gmzccs58v9S21ShQBipUT8zWv10Q5kk/0f1NM2vsV
	W+yZJJ3QE2fdPOEwXeX5VdjvfgvNimM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nw0NgajiFYy/H48l2M72VyZRctVsTCycv6+JT7hes38=;
	b=ghFk6OqjjuQrazKHEDv4Lr/8PQSv1qPWjvgsYVrTLQpH9yww3PW+BaYBrmTtLRpc9o84wC
	XusG7smUGzawbJAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794306577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nw0NgajiFYy/H48l2M72VyZRctVsTCycv6+JT7hes38=;
	b=ZYH9OH/QzT78U70GM13G/jwBPK0e1H7H/WdqIsP8SeWpPlM2XIrTQRqtJ7ZQGYyZb8XPrb
	ii/CzvI6C6gMbbDET5DSUxjcK9ip+Gmzccs58v9S21ShQBipUT8zWv10Q5kk/0f1NM2vsV
	W+yZJJ3QE2fdPOEwXeX5VdjvfgvNimM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794306577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nw0NgajiFYy/H48l2M72VyZRctVsTCycv6+JT7hes38=;
	b=ghFk6OqjjuQrazKHEDv4Lr/8PQSv1qPWjvgsYVrTLQpH9yww3PW+BaYBrmTtLRpc9o84wC
	XusG7smUGzawbJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F0CDF1339F;
	Tue, 10 Nov 2026 10:29:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k2wGMhDy8mo0LAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 10:29:36 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 924C02247B; Tue, 10 Nov 2026 11:29:36 +0100 (CET)
Date: Tue, 10 Nov 2026 11:29:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, linux-ext4@vger.kernel.org, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RFC v3 14/14] fat: drop mmb_sync() from fat_evict_inode()
Message-ID: <hj3v4vunp25fwuhlv5f5bbwfuu7sfdohcqmici5d2wknu6xqmh@wrimwxh5puwn>
References: <20261109-work-inode-metadata_writeback-v3-0-91ac6c024018@kernel.org>
 <20261109-work-inode-metadata_writeback-v3-14-91ac6c024018@kernel.org>
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
In-Reply-To: <20261109-work-inode-metadata_writeback-v3-14-91ac6c024018@kernel.org>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,suse.cz,toxicpanda.com,kernel.org,mail.parknet.co.jp,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,samsung.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Mon 09-11-26 17:51:29, Christian Brauner wrote:
> evict() writes out what I_METADATA_WRITEBACK tracks before it calls
> ->evict_inode() and since mmb_mark_buffer_dirty() sets the bit that
> includes the tracked metadata buffers. So there's nothing left for
> fat_evict_inode() to sync. The write-out happens before
> fat_free_eofblocks() updates the directory entry again, so that update
> stays as asynchronous as it is now.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fat/inode.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index d85c8fbdcca4..243b18949164 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -693,7 +693,6 @@ static void fat_evict_inode(struct inode *inode)
>  		inode->i_size = 0;
>  		fat_truncate_blocks(inode, 0);
>  	} else {
> -		mmb_sync(&MSDOS_I(inode)->i_metadata_bhs);
>  		fat_free_eofblocks(inode);
>  	}
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
