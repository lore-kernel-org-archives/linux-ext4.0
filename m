Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1714E0B8B;
	Tue, 22 Sep 2026 10:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790071666; cv=none; b=oUhLYNU414BhmZkS+rLkBIsGCSwvvE0QW3tWw8WGCSQGaz9iJxUeBjV+JnXZmptKAzJ0fkYYphXfk10DSp5P9CW3Of/rp3zKWvWvCVeTuk5NWnc9oBwEjTQaf6N5dbF77W2mslhamOB6cBaUM4ksWol34SbMNGNAWNMXNAF6pRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790071666; c=relaxed/simple;
	bh=qOHngvoeMXXnG090+xsFOmQDdA0QOGNDfWBi04hJo54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jzx7m8onEjA4KwQwz05gaZvoGs7anNif9pjPbesINFRE7asKlVqLL+fuY7QsUgnDvRQ6/g8DQdLUzPtFgA6MW94ypz25cNGtQe4Frq6qqlo+YsER1djE5AzZW35McpaoD3DE60+1NlXEZdTDFzJA2oBcuaAVigwzdCiknCkOZxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cFcuvCSK; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AE7E4WWw; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ngBPm5RX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=mBtfGshz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cFcuvCSK";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AE7E4WWw";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ngBPm5RX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="mBtfGshz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 249D61F7A2;
	Tue, 22 Sep 2026 10:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790071659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wnYZYsSsKQzx2FEyp0L0s4BOMZezq8uo6IDm42t72F8=;
	b=cFcuvCSKUoXGVqOz0eim5Sju6FnOnFPQzXVycdFmymsG7b6nOv2XwBy0bhSCuLIDrQc7Pi
	b/1Gfbq9f7H905XX4eZRK9dDZntV7zbCSO2C4KKfE29OjizspaN4qbd+pqnwlPkLZlGS7D
	pkxrzSzhDlf8mdu314vSKXo8XEgtCWI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790071659;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wnYZYsSsKQzx2FEyp0L0s4BOMZezq8uo6IDm42t72F8=;
	b=AE7E4WWwUUBF5l+TM6v2ifXuprTyRKNTBiOfx/661VKlYrYyljh2L5I+Qor+0AWNmuqRbJ
	tChsx6ZbOfMCKRDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ngBPm5RX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mBtfGshz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790071655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wnYZYsSsKQzx2FEyp0L0s4BOMZezq8uo6IDm42t72F8=;
	b=ngBPm5RXjD+rP/Z319PO4AOxpudnOyvaVwJdlj5HgVMr42oRPJWhHMK9PbdhED013HU8Kg
	Gk0BbQAGHtEq+WgCNoBoLRU450pAa3s05J5nqLtWS5JXZ7NIWwQebeffS3js9zjUks9DK8
	Rscu1AKLMeJgNHioeRURZa2CMpi7uDk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790071655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wnYZYsSsKQzx2FEyp0L0s4BOMZezq8uo6IDm42t72F8=;
	b=mBtfGshzSbbUGmTH+uioZD65FJJ300kKRbdSn8ownVifXF7zSM/oUSVF0TOPS3wzJc0wYR
	nYdX0BilMtoH8mCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA7A4136D9;
	Tue, 22 Sep 2026 10:07:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id waHxMGZTsmqtEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 22 Sep 2026 10:07:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 80323A13D4; Tue, 22 Sep 2026 12:07:34 +0200 (CEST)
Date: Tue, 22 Sep 2026 12:07:34 +0200
From: Jan Kara <jack@suse.cz>
To: MarkLee131 <kaixuanli0131@gmail.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>, 
	Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ext4: don't read past the UAPI struct in GROUP_ADD
Message-ID: <llpsok2rsawexqxwibmxrv3xjyh63lh3tmnrd33x3dh4qsk3mw@bsh73hqhpjma>
References: <20260917151441.413135-1-kaixuan.li@ntu.edu.sg>
 <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918111742.827428-1-kaixuan.li@ntu.edu.sg>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 249D61F7A2
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -4.01

On Fri 18-09-26 19:17:42, MarkLee131 wrote:
> From: Kaixuan Li <kaixuanli0131@gmail.com>
> 
> EXT4_IOC_GROUP_ADD casts the user pointer to struct ext4_new_group_input,
> its UAPI type, but sizes the copy by struct ext4_new_group_data, the
> internal type:
> 
> 	struct ext4_new_group_data input;
> 
> 	if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> 			sizeof(input)))
> 
> The UAPI struct is 40 bytes, the internal one 48.  A caller that follows
> the UAPI and allocates 40 bytes gets 8 bytes read past its object, and the
> ioctl returns EFAULT when those bytes are unmapped.  The two structs have
> differed in size for as long as I can see back -- v6.12.9, v7.2.4 and
> current master all have 40 against 48 -- so the copy has been over-reading
> the UAPI object throughout.
> 
> The first 40 bytes of the two structs have identical layout, so copying
> that much fills every field the UAPI defines.  Zero the rest:
> free_clusters_count is overwritten by verify_group_input() anyway, and
> mdata_blocks is read only by ext4_resize_fs(), which builds its own
> group_data array.
> 
> Reproducible on v6.12.9 and v7.2.4 by placing a 40-byte struct at the end
> of a mapped page whose successor is unmapped: the ioctl returns EFAULT.
> 
> Signed-off-by: Kaixuan Li <kaixuanli0131@gmail.com>
> ---
> v2: done the way you suggested -- one struct on the stack, one copy, and a
> memset of the tail, rather than v1's second struct and six field
> assignments.  The only change from your sketch is the cast in the memset
> address: &input is a struct ext4_new_group_data *, so &input +
> sizeof(*uinput) would advance by 40 * 48 bytes.
> 
> Built fs/ext4/ioctl.o warning-free with W=1 on x86_64 (clang 21), and
> checkpatch-clean.  The EFAULT reproducer behaves as before on v6.12.9 and
> v7.2.4; the fix itself was not runtime-tested.

One nit below, otherwise looks good.

> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1674,12 +1674,15 @@
>  	}
>  
>  	case EXT4_IOC_GROUP_ADD: {
> +		struct ext4_new_group_input __user *uinput = (void __user *)arg;
>  		struct ext4_new_group_data input;
>  
> -		if (copy_from_user(&input, (struct ext4_new_group_input __user *)arg,
> -				sizeof(input)))
> +		if (copy_from_user(&input, uinput, sizeof(*uinput)))
>  			return -EFAULT;
>  
> +		memset((char *)&input + sizeof(*uinput), 0,
> +		       sizeof(input) - sizeof(*uinput));
> +

I just would not bother with this complex memset. This is not performance
critical at all. Just initialize the whole 'input' to 0 (with = {} at
declaration) and be done with it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
