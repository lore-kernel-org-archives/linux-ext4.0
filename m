Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFF2346AC0;
	Wed, 26 Aug 2026 07:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730703; cv=none; b=o6GYj/f4keTbAvefIAlvOkD/Qydq3UleAQAi24c9MJjxvxhd6D9g9ui9V77mHSOCaQEd/7ad8JXeArMwcW4N+LiCdNrcznFcGcQpulQQSmAHe105VcTBLFgIbzKTsJV3xwMK7oNMo1zV3jYYFL5UBIIpD/1/0L1tBX4aZFJMScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730703; c=relaxed/simple;
	bh=cpb+YEljXsITP+tp286CsQZMHIFGdGE6IwaNzR7PgC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BXK9L/OafT4S53euUexQYg3NTFbyYrcKsYNgL5DGNSYLdItAE/WaJ8lrdEHtVsMxO2F1XjDZAj0n6cDUZa0uc5vfJLZLm8in0JLA2uortdBr9bsTK0GFZpuEO7XpsVNj2V5BK2b5Z4VbJ6KG96hvK5SyWFCUNUKhRecm7qQoGO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=eH51a6gp; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ol1Nxors; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0vMJ3rNT; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qWhu+6fw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="eH51a6gp";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ol1Nxors";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0vMJ3rNT";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qWhu+6fw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47534872AC;
	Wed, 26 Aug 2026 07:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmnBKofXjBfdp35ulnKbUsM/cyufvjmu4/km6WCcN9k=;
	b=eH51a6gpA2vfi1us1QGFpoP28cIad9JUhrkxAceOdfVisXRQeUJoZsn8W39vuMivHAX9/9
	ZWUz6YWElje4INGQkYJpMDASM9T6WAS0zb11dwCaJk0KtnLDGEkWp9uzQVRaDkWJGMpjBV
	pt36S0DAiDIAesq0nUhPRzpWnWWgZGQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmnBKofXjBfdp35ulnKbUsM/cyufvjmu4/km6WCcN9k=;
	b=Ol1NxorsO8zpsNYZLscKIUFW+14p6mdKwYzGSlWMX8qIskvvZ/3MUP21uf8uA+QUsd82JE
	6JJbQ40Tc0+xqJBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0vMJ3rNT;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qWhu+6fw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1787730601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmnBKofXjBfdp35ulnKbUsM/cyufvjmu4/km6WCcN9k=;
	b=0vMJ3rNTRJKo+71UqvhN4Uw+5REHe2T8A6wALcAXe19+j3kCBLZhZDRgMuXweMWsqBX82Z
	TW8CH8d7pPShdxgMaHzcmizV9oW/ZK/kTMW0K710IYnI0N1Fx5LYvGnRvYmIEm/9hdG/jA
	Ua8eTbKzhAbXQvF5Dy2m00Se/9DXcb8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1787730601;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rmnBKofXjBfdp35ulnKbUsM/cyufvjmu4/km6WCcN9k=;
	b=qWhu+6fwx+zEoY0kx52leBuYx4ocMF9Tl5xEWbwjsQVYDGSdmqc9WaehllmD4GnaXGjnnj
	YjC9psVLaPE2RvAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BA9A13687;
	Wed, 26 Aug 2026 07:49:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iP0WIqOajmoGDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 26 Aug 2026 07:49:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4BCA2A13AE; Tue, 25 Aug 2026 18:19:10 +0200 (CEST)
Date: Tue, 25 Aug 2026 18:19:10 +0200
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
Subject: Re: [PATCH v2 12/21] fat: check for a metadata write error with
 buffer_write_io_error()
Message-ID: <2ts7q6mper74vkfxvrjhv2ewyldfj7opmrisobadjqvjfk6tq5@gl7vdum3fdys>
References: <cover.1785951556.git.coshi036@gmail.com>
 <4b6019b5a48b83c8235918b084248983a57692e1.1785951556.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b6019b5a48b83c8235918b084248983a57692e1.1785951556.git.coshi036@gmail.com>
X-Spam-Score: -2.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 47534872AC
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	URIBL_BLOCKED(0.00)[fiu.edu:email,suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[27];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,huaweicloud.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,fiu.edu];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	R_RATELIMIT(0.00)[to_ip_from(RLr6u35b1fsnb818ss3au1oekd)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On Thu 06-08-26 12:58:35, Chao Shi wrote:
> fat_sync_bhs() waits for the writes it issued and then tests
> !buffer_uptodate() to find the ones that failed.  That relies on the write
> completion handler clearing BH_Uptodate on error, which this series
> removes: a buffer whose write failed still holds the data the filesystem
> asked to be written, so declaring it not up to date is wrong and makes
> callers re-read it.
> 
> Test BH_Write_EIO, which is what the completion handler sets and what this
> code actually wants to know.
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
>  fs/fat/misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index be18f6b5819b..4a4cd0111e47 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -356,7 +356,7 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
>  
>  	for (i = 0; i < nr_bhs; i++) {
>  		wait_on_buffer(bhs[i]);
> -		if (!err && !buffer_uptodate(bhs[i]))
> +		if (!err && buffer_write_io_error(bhs[i]))
>  			err = -EIO;
>  	}
>  	return err;
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
