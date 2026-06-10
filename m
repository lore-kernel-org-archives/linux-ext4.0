Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEAF3E7151
	for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2026 10:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781085692; cv=none; b=ADkzT7JUon08RL6jJKDyCBlZLfTxux4OZZxFUMd3IzD0rDgQ5gWX5dp+1H0VoS5c9MLR+mnITj2sN4XpU3i9q2VrnGiVDlzLnTTTPtHRnX7SxiobiaZSTxrDIsccFkWYjrWABXEMEtLAk9n+KVIAFMSgRmhBXPbiXlIrAGnElPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781085692; c=relaxed/simple;
	bh=pqHZVtc/1uyXIvaMjAqbvklZGxDsQY1F0qb0UCRe0Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=axkiVtz60Tqnd1/9U1zOALVszxXSYqvASIDARa2OblnlaSYwhn25F6Ujh/zCntyZVnG1GyrQIx14UUpKQO6vAgNaOXYV8FBXmmVLJKiEdWI+4PWcIRyy2eKofbpmSKNjEg4C+XS6MlAjWw+1Gz9oRKzNxWvR5nQUkWSF04f8v8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=J0B0zaxJ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+bNkaQtB; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Is4J4J3Y; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Gcyw/L7/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="J0B0zaxJ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+bNkaQtB";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Is4J4J3Y";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Gcyw/L7/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5DCB475D38;
	Wed, 10 Jun 2026 10:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781085685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zLDZnWrsiCj5TukL5/upXsrCXy2Ex7Toos56kZ9tum8=;
	b=J0B0zaxJh8Od8FHvmHatwyeSfmEDI3On/ogChD2njhHPCGpeV4I9B/T389Kxgir+WCdJsw
	6FYZRNolQrNqzSYs+DaWuXeXzjdW3njtEAyOuueRl0Z+t/okFz0lV+b6Z14Du/8lwDeAF+
	NYj7xZVkmvT3AUJ422rZxEhGPSNUex8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781085685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zLDZnWrsiCj5TukL5/upXsrCXy2Ex7Toos56kZ9tum8=;
	b=+bNkaQtB99sg+JpvfPlrYc56DJ7/hq95IWf1I1sSGHCVgny8tvl1n+y5QdsSIJvsmMTwG1
	trPTUL8wDl9j8FAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Is4J4J3Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Gcyw/L7/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781085680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zLDZnWrsiCj5TukL5/upXsrCXy2Ex7Toos56kZ9tum8=;
	b=Is4J4J3Y83OjBKYybGaWsJGZj1w6stDUjjYxGdJcRLuEzi78sPSRbr3qGWilxAJVoEKvrI
	f4dDmKQcPeb8S15ee4PEnwQiQIOODHenUbxp2hqcW8QaM5mtRJG/oFzCkTGYgrOE6NIfoB
	8wnsC62HHLs7HHsxZaF2omH3SAId9dM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781085680;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zLDZnWrsiCj5TukL5/upXsrCXy2Ex7Toos56kZ9tum8=;
	b=Gcyw/L7/5J58yFQLkC4QoMovrY5YyVuyqPKTfwqrXARE+WsuyI/HShv9NIksMSyIDI+7AD
	+dtZcDLrHIFpOABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A884779A7;
	Wed, 10 Jun 2026 10:01:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2YIrEvA1KWqbWQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 10 Jun 2026 10:01:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E75CDA0A90; Wed, 10 Jun 2026 12:01:15 +0200 (CEST)
Date: Wed, 10 Jun 2026 12:01:15 +0200
From: Jan Kara <jack@suse.cz>
To: Xiang Mei <xmei5@asu.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH net v2] ext4: fix out-of-bounds read in
 ext4_read_inline_dir()
Message-ID: <p2kykhe5532mxqgnmgyrg24cmlpcz24qn2erw3lkzabjjubbyq@i2c3mfdm7mpc>
References: <20260609010739.2278172-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609010739.2278172-1-xmei5@asu.edu>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.cz:dkim,suse.com:email,asu.edu:email]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5DCB475D38
X-Spam-Score: -2.51

What does the 'net' in [PATCH net v2] mean?

On Mon 08-06-26 18:07:39, Xiang Mei wrote:
> ext4_read_inline_dir() reads de->rec_len / de->name past the end of its
> inline buffer for a crafted or corrupted inline directory, triggering a
> slab-out-of-bounds read during getdents64():
> 
>   BUG: KASAN: slab-out-of-bounds in filldir64 (fs/readdir.c:371)
>   Read of size 8 at addr ffff88800fd3da3c by task exploit/146
>    ...
>    kasan_report (mm/kasan/report.c:595)
>    filldir64 (fs/readdir.c:371)
>    iterate_dir (fs/readdir.c:110)
>    ...
> 
> The payload is copied into a buffer of exactly inline_size bytes:
> 
> 	dir_buf = kmalloc(inline_size, GFP_NOFS);
> 
> but iteration runs in a logical position space extra_offset bytes larger
> than the buffer (extra_size = extra_offset + inline_size), so the synthetic
> "." and ".." entries land at the offsets they would have in a block-based
> directory. A real dirent is formed at "dir_buf + pos - extra_offset", yet
> the loop bounds and the ext4_check_dir_entry() length argument are all
> expressed in the larger extra_size. Two reachable sites dereference a
> dirent before confirming its physical offset is inside the allocation:
> 
> In the main loop, ctx->pos is attacker-controlled via lseek() and the entry
> is validated with extra_size, so ext4_check_dir_entry() accepts a dirent
> running up to extra_offset bytes past the allocation before its length
> check fires. ctx->pos is also a signed loff_t: an lseek() to a small value
> below extra_offset makes "ctx->pos - extra_offset" negative, so a check
> that only bounds the top of the buffer is bypassed by underflow and de is
> formed before dir_buf.
> 
> In the cookie-rescan loop, entered when i_version changed since the last
> readdir(2), the walk restarts from the beginning with i bounded by
> extra_size, so as i approaches extra_size the unconditional read of
> de->rec_len runs past the allocation before any validation.
> 
> Both are the same defect, logical extra_size space versus the physical
> inline_size buffer. In each loop, reject a dirent whose header would not
> fit within inline_size before forming de, and in the main loop also reject a
> position that underflows below extra_offset. Validate the main-loop entry
> against inline_size rather than extra_size. Entries that legitimately fill
> the inline data still pass.
> 
> Fixes: c4d8b0235aa9 ("ext4: fix readdir error in case inline_data+^dir_index.")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>

Thanks for the analysis and the patch. See some suggestions for improvement
below:

> @@ -1488,10 +1491,20 @@ int ext4_read_inline_dir(struct file *file,
>  			continue;
>  		}
>  
> +		/*
> +		 * de lives at dir_buf + ctx->pos - extra_offset, so the dirent
> +		 * header must fit within inline_size.  ctx->pos is a signed,
> +		 * lseek()-controlled loff_t: check the lower bound first, or
> +		 * ctx->pos < extra_offset underflows and points de before dir_buf.
> +		 */
> +		if (ctx->pos < extra_offset ||
> +		    ctx->pos - extra_offset + ext4_dir_rec_len(1, NULL) >
> +		    inline_size)
> +			goto out;

So I don't think this is really possible. ctx->pos isn't really fully user
controlled. When you use seek to modify ctx->pos, ext4_dir_llseek() does
set info->cookie to invalid value so the next time we enter
ext4_read_inline_dir() we are guaranteed to revalidate the offset and reset
it to 0, dotdot_offset, or some value greater than extra_size. 

>  		de = (struct ext4_dir_entry_2 *)
>  			(dir_buf + ctx->pos - extra_offset);
>  		if (ext4_check_dir_entry(inode, file, de, iloc.bh, dir_buf,
> -					 extra_size, ctx->pos))
> +					 inline_size, ctx->pos))
>  			goto out;
>  		if (le32_to_cpu(de->inode)) {
>  			if (!dir_emit(ctx, de->name, de->name_len,

Otherwise the patch looks good.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
