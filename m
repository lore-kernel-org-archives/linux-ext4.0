Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792662526;
	b=Wzga7TnoICi/flIVHqzcNu4XaN7w8tAK/dNb7QUE505Ub4v7f+NcAUkGWWjinNyH7EyD
	 ArGqFiks/+J/6EYkOz+4YdMILf/tzvXPImm8PdkDlED3icRdad6/9yp+J+fhj1Gw3NNwG
	 qUFgSUUxymXTXgNJnDVTEDN3TXoJt3dft+o1GVgAgR31Fc6XOJSawUWlaSCF9D5Wo6Nl2
	 CQ4QktjooZ2ZS4LUGbW/hh34Xtm9uXhNaoJfIZCpXBGjsnANlnVkFirt/KSZtlmJnr75h
	 HzpRw7P5QJeieec3sTPrEvzwa44yR9xuWkQ3c/O/hYrTS9BA7PI9DWPnbcP8+wp/OUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792662526;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=YaLhqZAxNujf1yf6yjVdrpEfaUMs2QKzKZiW60wQPUY=;
	b=ix371fHXhV/zp12ERidyS5IVDSNZ7lr+V0EBql8nDalTNeoXgsP6FCpNmRQ2hcz9xOWK
	 9baAl25Zn9Apn3VhgHwaOOTkTN8fDHnb5WxGX1NxasfyP/W1kHaHSEwtiOeoIwqmvBTb2
	 WcP0apu3D/IOTkVnLK5Q3+9lcyiTROkUCQ42sunBr7u8n52hkC2VpIM3JYd0xA/k/VmFF
	 QqaZe6sciJqvu9+Rn9vo+lDw9Menjwo685YjV12Mq9yxGl46SYUmkio8CsEkA1KcThaOr
	 w8XyO0gioNDhICPaWXAljtHuHK6tOFOkLudWuVGXFK0kDpa5u2GyrHgCI6Tuxbj+LuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sq0ZEkY3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9P3wS2WJ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1JQPu11m;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b+vUUJkB;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2E9606A319;
	Thu, 22 Oct 2026 09:48:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9B2E9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=sq0ZEkY3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9P3wS2WJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=1JQPu11m;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b+vUUJkB
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B5DDD1FB25;
	Thu, 22 Oct 2026 09:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792662524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YaLhqZAxNujf1yf6yjVdrpEfaUMs2QKzKZiW60wQPUY=;
	b=sq0ZEkY3GUZ6IFkcbQItrO56hTeErfKwyfnFL7plrikFQlK1FJC7oWPZqpcU3Gg/ssLSvK
	8JjS2Vi1RaW6tIyik/zCSRUrOfVJFDaFv+fDwDqaifWOjpcpu10X4JrHHgOd+J1XGmc9HP
	jm7SumRJQOgrzyfjNZTIbrOEpYwaLtw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792662524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YaLhqZAxNujf1yf6yjVdrpEfaUMs2QKzKZiW60wQPUY=;
	b=9P3wS2WJMWjwoRK3tP9kyGmMLZYWCFoyXN30fTxL9kZHLt/JNG96uUpplwHgH8CWWw25QG
	xPzzCknugj+Y+YAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792662523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YaLhqZAxNujf1yf6yjVdrpEfaUMs2QKzKZiW60wQPUY=;
	b=1JQPu11mrGFmGZd9JbyPAII7Y3+E2KlofWb/7MHvdLkEw8If8m8hDtAe8cJaoPaZayyWGO
	pA+CAszPAACd0Z81kyQSPOQoxSP9DGrLhUb+RhE7qPSBS0tgIc7hy9jUKICC/g4VFnUKwJ
	VgUcybVSxK4deQNAVLyS4nKQUSbG23U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792662523;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YaLhqZAxNujf1yf6yjVdrpEfaUMs2QKzKZiW60wQPUY=;
	b=b+vUUJkB5hut1nOg9/jf17aPk9NHGd9TRSnhkwXTABL0GLvlaGp2eJJNWI2hI0OGQV9h/D
	JGyM1kT3kENRFDCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DFE9133F3;
	Thu, 22 Oct 2026 09:48:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OnJUGvvb2WoHfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 22 Oct 2026 09:48:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 117A0A1417; Thu, 22 Oct 2026 11:48:35 +0200 (CEST)
Date: Thu, 22 Oct 2026 11:48:35 +0200
From: Jan Kara <jack@suse.cz>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: do not advance i_size on a buffered write that
 copied nothing
Message-ID: <34dtkdstf5yxg2ulinnh4hocc53gz35ij6k62egi2ykgpyc3a5@zuxt6doiajwq>
References: <20261009044656.1993196-1-hengyul@cs.unc.edu>
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
In-Reply-To: <20261009044656.1993196-1-hengyul@cs.unc.edu>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,vger.kernel.org,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,linux.intel.com,linux-foundation.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[unc.edu:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Fri 09-10-26 00:46:56, Hengyu Liang wrote:
> Commit 665575cff098 ("filemap: move prefaulting out of hot write path")
> made generic_perform_write() call ->write_begin() and ->write_end()
> before it finds out that the source buffer cannot be read.  In that
> case ->write_end() is called with copied == 0.
> 
> However, ext4_write_end(), ext4_journalled_write_end() and
> ext4_da_do_write_end() set i_size to pos + copied without checking
> copied.  As of now, a buffered write() past EOF that fails with EFAULT
> grows the file to the write offset, and the new size can reach the
> disk.
> 
> The issue can be reproduced on an ext4 mount with:
> 
>     char *p = mmap(NULL, 4096, PROT_NONE,
>                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>     int fd = open("/mnt/ext4/file", O_CREAT | O_TRUNC | O_RDWR, 0600);
>     pwrite(fd, p, 4096, 1024 * 1024);   /* fails with EFAULT */
>     fstat(fd, &st);
> 
> Before that commit, the result is st_size = 0.
> After it, the result is st_size = 1048576.
> 
> This patch will leave i_size alone when nothing was copied, as
> ext4_write_inline_data_end() already does.  The delalloc path does not
> trim after a short write, so in this case it also has to drop the
> folio and the delayed blocks that ->write_begin() set up past i_size.
> Otherwise that folio stays dirty past EOF and writeback never cleans
> it.
> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

I agree with the problem but first, Ted has merged rewrite of ext4
buffered IO path to iomap your fix would very likely need rebasing, and
second:

> +/*
> + * Delalloc counterpart of ext4_truncate_failed_write(): ->write_begin() only
> + * reserved delayed blocks, so drop the page cache and the delayed extents
> + * beyond i_size and leave the blocks that are allocated there alone.
> + */
> +static void ext4_da_truncate_failed_write(struct inode *inode)
> +{
> +	struct address_space *mapping = inode->i_mapping;
> +	ext4_lblk_t lblk = EXT4_B_TO_LBLK(inode, inode->i_size);
> +
> +	filemap_invalidate_lock(mapping);
> +	truncate_inode_pages(mapping, inode->i_size);
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_es_remove_extent(inode, lblk, EXT_MAX_BLOCKS - lblk);
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +	filemap_invalidate_unlock(mapping);
> +}
> +

this is wrong and would leak delayed allocation reservations AFAICT. You
should just use ext4_truncate_failed_write() like e.g.
ext4_da_write_begin() does on failure.

								Honza

>  static int ext4_da_do_write_end(struct address_space *mapping,
>  			loff_t pos, unsigned len, unsigned copied,
>  			struct folio *folio)
> @@ -3247,12 +3268,12 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	 * checked, we need to update i_disksize here as certain
>  	 * ext4_writepages() paths not allocating blocks and update i_disksize.
>  	 */
> -	if (new_i_size > inode->i_size) {
> +	if (copied && new_i_size > inode->i_size) {
>  		unsigned long end;
>  
>  		i_size_write(inode, new_i_size);
>  		end = offset_in_folio(folio, new_i_size - 1);
> -		if (copied && ext4_da_should_update_i_disksize(folio, end)) {
> +		if (ext4_da_should_update_i_disksize(folio, end)) {
>  			ext4_update_i_disksize(inode, new_i_size);
>  			disksize_changed = true;
>  		}
> @@ -3261,9 +3282,16 @@ static int ext4_da_do_write_end(struct address_space *mapping,
>  	folio_unlock(folio);
>  	folio_put(folio);
>  
> -	if (pos > old_size)
> +	if (copied && pos > old_size)
>  		pagecache_isize_extended(inode, old_size, pos);
>  
> +	/*
> +	 * A write past i_size that copied nothing leaves i_size alone, so
> +	 * trim what ->write_begin() set up beyond it.
> +	 */
> +	if (!copied && pos > old_size)
> +		ext4_da_truncate_failed_write(inode);
> +
>  	if (!disksize_changed)
>  		return copied;
>  
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
