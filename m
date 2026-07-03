Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E77340B372
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 15:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783093409; cv=none; b=H8aboQvWyUBA1nKVU1ArhRPCrLKk4eKrP5cp1tVB7iHBsPFPXQVWRTdJTEIDCnUuy1HTKcyPeIYxz/QjqihiYj7KUYsgy8h2pXBX8vziikjlz6RY8wQuX38hOYOIl2ViwfnrEbqiWjAw5KUNEnl1uhGK2UqJINFjYyg5UJUSGYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783093409; c=relaxed/simple;
	bh=pVUcl/BQoGmleWsNy+8nYC4dt0Zf317IMzQ3hyQiz7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RumIAUjy8tHveoYfvtn7CUBjyBoZSzvpg5JZJgyZTemIdFdbhBM+E2GWSBnC0xxFjLe3GhcRIQ2lxxb/3faJ11FtBVMo11suicwxYRM6M4ZkkgnXcCh3zc+wSLRLtd79/xBd6x8Kw7Oy4uTll5orQVU8TrLIlSh9N3S2kiIi6MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kygDO9aD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NvtNqTzM; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kygDO9aD; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NvtNqTzM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kygDO9aD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NvtNqTzM";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kygDO9aD";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NvtNqTzM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7DF9775C31;
	Fri,  3 Jul 2026 15:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783093405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HD8Plv90zQ7HbcFK2s1b29lb8TMgOGVzg3QQ+mFDVY=;
	b=kygDO9aD7ZRBb7v9GEbiFJZ0w1/b5SnC9O8d06g5OA6LKwNP7IMBJpkxQvZj/7kd74BY3G
	4ph53w/kr/T7Izt7MgmP+SRmFlg8MvcTWhSUqZQ9kB1vpqFoga9Gcr8Sfe7D0tWxbixJzn
	4bSnrEvHJGzzS9WeRj+aO4WyHueBprE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783093405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HD8Plv90zQ7HbcFK2s1b29lb8TMgOGVzg3QQ+mFDVY=;
	b=NvtNqTzMv2Wbzn95g7TKyMa2nJrstJtosXq3Axf/3X4InyofneUtJVgEXRqi6XhY4cqjKx
	HqRtiJCon5OIT6Dg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783093405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HD8Plv90zQ7HbcFK2s1b29lb8TMgOGVzg3QQ+mFDVY=;
	b=kygDO9aD7ZRBb7v9GEbiFJZ0w1/b5SnC9O8d06g5OA6LKwNP7IMBJpkxQvZj/7kd74BY3G
	4ph53w/kr/T7Izt7MgmP+SRmFlg8MvcTWhSUqZQ9kB1vpqFoga9Gcr8Sfe7D0tWxbixJzn
	4bSnrEvHJGzzS9WeRj+aO4WyHueBprE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783093405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2HD8Plv90zQ7HbcFK2s1b29lb8TMgOGVzg3QQ+mFDVY=;
	b=NvtNqTzMv2Wbzn95g7TKyMa2nJrstJtosXq3Axf/3X4InyofneUtJVgEXRqi6XhY4cqjKx
	HqRtiJCon5OIT6Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7087B779AC;
	Fri,  3 Jul 2026 15:43:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ko92G53YR2pyYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 03 Jul 2026 15:43:25 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1C9CBA12D4; Fri, 03 Jul 2026 17:43:21 +0200 (CEST)
Date: Fri, 3 Jul 2026 17:43:21 +0200
From: Jan Kara <jack@suse.cz>
To: Yao Kai <yaokai34@huawei.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, chengzhihao1@huawei.com, 
	liuyongqiang13@huawei.com, syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
Subject: Re: [PATCH] ext4: validate readdir offset before accessing dirent
Message-ID: <ictxydbin3ljp2j7a6okd2w3ly5kwox53zuipzbssemwq7bijw@nkxvis5rg4mh>
References: <20260703015106.3570064-1-yaokai34@huawei.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703015106.3570064-1-yaokai34@huawei.com>
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[5322c5c260eb44d209ed];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,syzkaller.appspotmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,syzkaller.appspot.com:url,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,huawei.com:email]
X-Spam-Level: 
X-Spam-Score: -2.30

On Fri 03-07-26 09:51:06, Yao Kai wrote:
> A corrupted directory can trigger the following KASAN report when
> ext4_readdir() resumes from an invalid position:
> 
>   BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
>   Read of size 2 at addr ffff88810a646000 by task repro_linear/509
> 
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x53/0x70
>    print_report+0xd0/0x630
>    kasan_report+0xce/0x100
>    __ext4_check_dir_entry+0x5ef/0x820
>    ext4_readdir+0xcde/0x2b70
>    iterate_dir+0x1a1/0x520
>    __x64_sys_getdents64+0x12b/0x220
>    do_syscall_64+0xf9/0x540
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>    </TASK>
> 
> KASAN reports use-after-free because the out-of-bounds access lands in an
> adjacent freed page. The directory buffer itself is still referenced.
> 
> ext4_dir_llseek() invalidates the directory cookie so that ext4_readdir()
> rescans directory entries from the start of the block. The rescan checks
> only the lower bound of rec_len before advancing. A corrupted rec_len can
> therefore place the offset where the block has insufficient space for a
> complete directory entry. The rescan itself may dereference that truncated
> entry, or the main loop may pass it to __ext4_check_dir_entry(). The latter
> reads de->rec_len before validating the range. For example:
> 
>   block offset  0                           4092  4096
>                 |---- de1.rec_len = 4092 -----|----|
>                                                de2.inode
>                                                     | de2.rec_len
>                                                     ^ OOB, reported as UAF
> 
> de2 starts at offset 4092 in this 4 KiB block. Its four-byte inode fits in
> the block, but its rec_len starts at offset 4096 and crosses the boundary.
> 
> The minimum safe length is inode-dependent. Encrypted and casefolded
> directory entries need eight additional hash bytes, while a valid metadata
> checksum tail is only 12 bytes.
> 
> Cache the metadata checksum feature state and derive the minimum directory
> entry length from the on-disk format. Use it to bound both the rescan and
> the offset passed to the main loop. Report an offset in a truncated block
> tail and skip the remainder of the block, while continuing to accept an
> offset exactly at the block boundary.
> 
> Reported-by: syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=5322c5c260eb44d209ed
> Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
> Signed-off-by: Yao Kai <yaokai34@huawei.com>

Just one nit below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -257,6 +261,17 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  			info->cookie = inode_query_iversion(inode);
>  		}
>  
> +		if (unlikely(offset < sb->s_blocksize &&
> +			     offset > sb->s_blocksize -
> +			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
> +			EXT4_ERROR_FILE(file, bh->b_blocknr,
> +					"bad entry in directory: %s - offset=%u, size=%lu",
> +					"directory entry too close to block end",
> +					offset, sb->s_blocksize);
> +			ctx->pos = (ctx->pos | (sb->s_blocksize - 1)) + 1;
				   ^^^ this is round_up(ctx->pos, sb->s_blocksize)


> +			goto next_block;
> +		}
> +
>  		while (ctx->pos < inode->i_size
>  		       && offset < sb->s_blocksize) {
>  			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
