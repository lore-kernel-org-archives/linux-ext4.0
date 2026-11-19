Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795099930;
	b=tWbPWViEBFl8vKqD0QbyOen3pNiQLr/6pZmwaL0zlqbCiBvFQ+/PEOtbxTy/QS1TgUx6
	 r4BkIHa/h610LwRUX3kIFHnc0Xe/zbKLXZWzh1I2QxsphxVwk6Rj8d+m1TVYbMQ/IXlVO
	 Ft4tfoQn9WXtRyJP8ZGiryd/obvBHJAKzz3RK9K/XbJ8cZKhVcSLkCY7uoxHmREIOz5aV
	 6l1O5mnTAUYD0M1o3wscA0vljqFTgB+z32PMAyv1K1GosFFea9lnyiuP2B+1hXZBXH6d1
	 zdDQ+h0LekTtCKUVijg4FTc5YBOHEId7J2l8NDEYERX/UZiGWBi6igpkF9958LNMX0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795099930;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=Lkf5rBZF0aIMpj4+ZVv+xmHDw9ngzq/M+Irn/T80JwE=;
	b=mnYx3lqY800BtIZcmLgRjdqDPneDYhnZFYHoYMvK+KhCWW7y4VBKubiw6+N8WCayDgGj
	 EspedE1dmP9YtW2rKrWh41doADBSmPB3UfJ5rPiw2LBuU0j8QzJg8cMJuDD5z0qYrNLwZ
	 FhQwfgWsEjkJjQY9CTzUaCOxgeftMGXZSMVI1WKWN51uYuRPID/ORGItHR5eHKOeq0PHC
	 FhwH8CUhOZ0+/NyzoHGzZ9By2+ZOSOmrGbFQx28eL8W4YzcH7GHv1PvnmcFyJuQC9zDbS
	 DPzpLGqW2s9LfadJYacwjnWbe1lh0cAjJACWDv6xmoxY+QB3cJzLbNmw8NpgtccQdRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=g5PAepkT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aNlX4cpK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DtXf1zhf;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="/SiK+BAs";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3600F606A333;
	Thu, 19 Nov 2026 14:52:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3600F606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=g5PAepkT;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=aNlX4cpK;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=DtXf1zhf;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/SiK+BAs
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B6D31FA90;
	Thu, 19 Nov 2026 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795099928; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lkf5rBZF0aIMpj4+ZVv+xmHDw9ngzq/M+Irn/T80JwE=;
	b=g5PAepkT/G6VwUxh+LFFYJKbui47Ix4nrQevKQZO8yvAM92bRdXJGJmKlm1TQdaHUESEie
	F/aE1f4s2XZGn5FDCJoagrWTlgmoqSSsXpPzrwR4zsJLN+cSfuIt/92cuOKDOVldMXTOt2
	1fZUgFs0WDkx9XtAx4r9u6hrL9JBvZg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795099928;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lkf5rBZF0aIMpj4+ZVv+xmHDw9ngzq/M+Irn/T80JwE=;
	b=aNlX4cpKp9ebGvi1IGPd6+1knGni9wJurdEyGaRPZjv5nEx7pq4Tb0kOInfXrNxjGhA0wU
	slR80nFaMUCHktCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795099926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lkf5rBZF0aIMpj4+ZVv+xmHDw9ngzq/M+Irn/T80JwE=;
	b=DtXf1zhf/pmGmzjs1bsQGiHBxyJwhmMf8qcfN7RhV+ywZVZZnynGDK7bElXYGHphStdnMZ
	ft9KkiEpIsoSLDB1txNSQYq8pM80zlsiIdx3xI4JWy/s4iZx5TXU12eTpc2GqCqqFWOrwj
	KfVMgavIgg5J7cp3uiabhyvqonVlTxQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795099926;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lkf5rBZF0aIMpj4+ZVv+xmHDw9ngzq/M+Irn/T80JwE=;
	b=/SiK+BAsqX/YAtNu3Al6gqAh416eKLhpUfjEYOqw5jKSztnmuDMGTBj9vxUAGE8GicN5ly
	RTz1WgEW9apZMuDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 414A11342D;
	Thu, 19 Nov 2026 14:52:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ly8lCBYN/2rSHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 14:52:06 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C396025251; Thu, 19 Nov 2026 15:52:05 +0100 (CET)
Date: Thu, 19 Nov 2026 15:52:05 +0100
From: Jan Kara <jack@suse.cz>
To: William Chuang <founder@logarcheon.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ext4: reject a non-regular boot loader inode in
 EXT4_IOC_SWAP_BOOT
Message-ID: <z4f3glvy73z45sm5pzj27id7hlgio7qyjsdft6gmlahd32y2pg@vbig6wh7rwyb>
References: <20261117061822.3826-1-founder@logarcheon.com>
 <20261117065645.4409-1-founder@logarcheon.com>
 <20261117223350.6920-1-founder@logarcheon.com>
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
In-Reply-To: <20261117223350.6920-1-founder@logarcheon.com>
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,logarcheon.com:email,sashiko.dev:url,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 17-11-26 22:33:59, William Chuang wrote:
> swap_inode_boot_loader() gets the boot loader inode (inode 5) with
> EXT4_IGET_BAD.  On a new filesystem that inode is unused, its mode is
> 0, and ext4_iget() returns it as a bad inode, which make_bad_inode()
> sets to S_IFREG.  On a corrupted or crafted filesystem, ext4_iget()
> can instead return inode 5 as a directory or another non-regular type,
> fully set up with that type's inode and file operations.
> 
> Such an inode is first passed to lock_two_nondirectories(), which
> warns if it is a directory:
> 
>   WARNING: fs/inode.c:1271 at lock_two_nondirectories
>    swap_inode_boot_loader
>    __ext4_ioctl
> 
> The "never used as a boot loader" branch then sets inode_bl->i_mode
> to S_IFREG, changing the type of a live in-core inode while it keeps
> the operations of its old type.
> 
> Check the type right after ext4_iget(): report the corruption and
> return -EFSCORRUPTED unless the inode is a regular file.  Leave the
> cached inode's type unchanged, so that a concurrent caller holding the
> same inode rejects it too.  ext4_iget() lets inode 5 through with
> i_nlink == 0; in that case set i_nlink to 1 in memory, under the inode
> lock, so that the final iput() does not send the reserved inode down
> the deletion path of ext4_evict_inode().
> 
> With non-regular types rejected up front, the later
> "is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)" test only needs
> is_bad_inode().  The unused
> case is unaffected, since make_bad_inode() has already made it
> S_IFREG.  This is the check Ted Ts'o suggested when the warning was
> first reported.
> 
> Tested on UML at 666539eec: inode 5 set with debugfs to a directory
> (with i_links_count 1, and with 0) or a character device, then
> EXT4_IOC_SWAP_BOOT issued twice.  Before this patch, the directory
> cases warn, and all cases succeed and leave inode 5 as a regular file
> on disk.  After it, all return EFSCORRUPTED, the error is logged,
> inode 5 is unchanged, and no attempt is made to free it.  Two
> processes issuing the ioctl concurrently 500 times each against a
> directory inode 5 never succeed.  On a
> new filesystem the ioctl still succeeds, twice.  Not tested: KASAN
> builds and syzbot's 2023 reproducer.
> 
> Fixes: 991ed014de08 ("ext4: fix bug_on in __es_tree_search caused by bad boot loader inode")
> Suggested-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/all/tencent_DABB2333139E8D1BCF4B5D1B2725FABA9108@qq.com/T/
> Link: https://sashiko.dev/#/bug/linux-8cfc8e22-8259-4c89-8a8b-64c16e4481a5
> Signed-off-by: William Chuang <founder@logarcheon.com>

Yeah, this looks sane. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
> v3: following Sashiko's review of v2:
>     - do not call make_bad_inode() on the rejected inode: it changes the
>       type of a cached inode that a concurrent caller may hold, which
>       then passes the regular-file check and is swapped.  Instead, when
>       i_nlink is 0, set it to 1 in memory under the inode lock, so the
>       final iput() does not try to delete inode 5;
>     - drop the now redundant !S_ISREG() from the later is_bad_inode()
>       test.
>     The concurrent case was run on single-CPU UML, where the v2 race did
>     not show up either; v3 avoids it by not changing the inode's type.
> v2: https://lore.kernel.org/all/20261117065645.4409-1-founder@logarcheon.com/
>     mark the rejected inode bad before iput() (Sashiko review of v1).
> v1: https://lore.kernel.org/all/20261117061822.3826-1-founder@logarcheon.com/
> 
>  fs/ext4/ioctl.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498..41e8934a7 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -390,6 +390,30 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  		return PTR_ERR(inode_bl);
>  	ei_bl = EXT4_I(inode_bl);
>  
> +	/*
> +	 * An unused boot loader inode comes back from ext4_iget() as a bad
> +	 * inode, which make_bad_inode() leaves as S_IFREG.  Any other type
> +	 * means the on-disk inode is corrupted; its type cannot be changed
> +	 * in place below.
> +	 */
> +	if (!S_ISREG(inode_bl->i_mode)) {
> +		EXT4_ERROR_INODE(inode_bl,
> +				 "boot loader inode is not a regular file (mode 0%o)",
> +				 inode_bl->i_mode);
> +		/*
> +		 * Leave the type alone: other callers may hold this cached
> +		 * inode, and must reject it too.  ext4_iget() lets inode 5
> +		 * through with i_nlink == 0, so keep the last iput() from
> +		 * treating the reserved inode as deleted.
> +		 */
> +		inode_lock(inode_bl);
> +		if (!inode_bl->i_nlink)
> +			set_nlink(inode_bl, 1);
> +		inode_unlock(inode_bl);
> +		iput(inode_bl);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	/* Protect orig inodes against a truncate and make sure,
>  	 * that only 1 swap_inode_boot_loader is running. */
>  	lock_two_nondirectories(inode, inode_bl);
> @@ -435,7 +459,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  	/* Protect extent tree against block allocations via delalloc */
>  	ext4_double_down_write_data_sem(inode, inode_bl);
>  
> -	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
> +	if (is_bad_inode(inode_bl)) {
>  		/* this inode has never been used as a BOOT_LOADER */
>  		set_nlink(inode_bl, 1);
>  		i_uid_write(inode_bl, 0);
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
