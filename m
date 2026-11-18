Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795003462;
	b=VXAqXNE34Tmyir9PkwpTkR7HJUX+lFV2vUwSv44JW2MGI3i+2P1wLUnKKaIrf4q3YQhf
	 xfdC5yc9be5QmIbyMNDPi9KozbRab0fORzWaUNQc77rRrPEV39U5yZzItfERn8ybiOZQA
	 VpozvrCq/2lmgV6+weiv8TJEqC79/MdrMUdkwM9CwDca7TYwd9l+cXMkW2JWk/U66VmoX
	 Ig5Ufqg+0LaPeYDHfml4N+0Du5UP2Z5HZDID8BzLlPASvInUAAE15ojz3G97f7vEXSDGn
	 2vgJoIc29zaEt5eHFnyGnYvpJwMgqXbzy/SjmmuSFW6OB3QsnGixnEP4kQs15yumNbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795003462;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=LOuAsQjK+12ngHe0/jbf6hyVj03KNod9mZDaCuhJMi0=;
	b=Qo63lrObqzDXWtQJayMhsQW7cQldj/+loLkj+ZQfoOvCg3cueQugyztfh9tVbdhOX9fR
	 aOpYtjU4E5bvF5djo+ddaNuSQJo5pPJUQBmy9kBiycrmDzWJCxTi3kvyQdf/Va9HhQ21t
	 5m6Qnjj7YG/V7W6TNWZU6cs6Tbc3Mctrj/AnFkAEU45TDweOenpMdhnfo5KuLlZ4C6rBE
	 bCLhLwgnOsPHug+t63VtLKKTqHf9FsV4P0uHea45sstfvzQAOvhgBWKNvLhw9FL0Omgev
	 JWc76bVTTtVBIOUXjsGWyJTgXKhRwy+eWA2nwdCLCYFK527lrh1SzeGa5g0qRBQSI8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=w6dwGBYm;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=odxoIEns;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=w6dwGBYm;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=odxoIEns;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A7606A31C;
	Wed, 18 Nov 2026 12:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 174A7606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=w6dwGBYm;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=odxoIEns;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=w6dwGBYm;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=odxoIEns
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 166A71F827;
	Wed, 18 Nov 2026 12:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuAsQjK+12ngHe0/jbf6hyVj03KNod9mZDaCuhJMi0=;
	b=w6dwGBYmM5NYHYLn0UoR+iuFXtBGe3UdWXPjhmxDj6Hzf/Bxp0BGlUDcqkwvBw0Maex1vV
	So6XCps3KKcKu1VlfFroIUMtNnEAv2YINe5belg8mMupHgO3bixPSOurbgqruw8ARgQ04G
	Kj/b6F6ufS/qqTfyBpbgwpB+u0zDzFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuAsQjK+12ngHe0/jbf6hyVj03KNod9mZDaCuhJMi0=;
	b=odxoIEnsPcu1mAAddRb3r8QMQbdPHvT8o6Sr9ROfknBgbh9tXlv7md2shFeCivUelU4d6o
	JGPRqcNENN5hqVDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795003460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuAsQjK+12ngHe0/jbf6hyVj03KNod9mZDaCuhJMi0=;
	b=w6dwGBYmM5NYHYLn0UoR+iuFXtBGe3UdWXPjhmxDj6Hzf/Bxp0BGlUDcqkwvBw0Maex1vV
	So6XCps3KKcKu1VlfFroIUMtNnEAv2YINe5belg8mMupHgO3bixPSOurbgqruw8ARgQ04G
	Kj/b6F6ufS/qqTfyBpbgwpB+u0zDzFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795003460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LOuAsQjK+12ngHe0/jbf6hyVj03KNod9mZDaCuhJMi0=;
	b=odxoIEnsPcu1mAAddRb3r8QMQbdPHvT8o6Sr9ROfknBgbh9tXlv7md2shFeCivUelU4d6o
	JGPRqcNENN5hqVDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1FB7134E9;
	Wed, 18 Nov 2026 12:04:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id meBdL0OU/WpUJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 18 Nov 2026 12:04:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 772892502A; Wed, 18 Nov 2026 13:04:19 +0100 (CET)
Date: Wed, 18 Nov 2026 13:04:19 +0100
From: Jan Kara <jack@suse.cz>
To: William Chuang <founder@logarcheon.com>
Cc: Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 1/2] ext4: reserve quota credits in
 swap_inode_boot_loader()
Message-ID: <emqu2ydrdock22ssfqg7sm2gjlzcmep3mbaqeqmpzrcshdxo3q@4cccpl7jgqf2>
References: <20261117052750.2955-1-founder@logarcheon.com>
 <20261117052750.2955-2-founder@logarcheon.com>
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
In-Reply-To: <20261117052750.2955-2-founder@logarcheon.com>
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
	TAGGED_RCPT(0.00)[e8180f5590685cbc9037];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,suse.cz,linux.ibm.com,gmail.com,vger.kernel.org,syzkaller.appspotmail.com,googlegroups.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30
X-Spam-Level: 
X-Spam-Flag: NO

On Tue 17-11-26 05:28:04, William Chuang wrote:
> swap_inode_boot_loader() starts its handle with 2 credits, enough for
> the two inode table blocks it dirties.  Since commit aa507b5faf38
> ("ext4: update quota information while swapping boot loader inode") it
> also calls dquot_free_space() or dquot_alloc_space() under the same
> handle.  On a filesystem with quota enabled, that marks the dquots
> dirty and ext4_write_dquot() writes them to the quota file.  The
> nested ext4_journal_start() in ext4_write_dquot() reuses the running
> handle and adds no credits, so the quota block write can find the
> handle with no credits left:
> 
>   WARNING: fs/jbd2/transaction.c:1598 at jbd2_journal_dirty_metadata
>   Call Trace:
>    __ext4_handle_dirty_metadata
>    ext4_quota_write
>    qtree_write_dquot
>    v2_write_dquot
>    dquot_commit
>    ext4_write_dquot
>    mark_all_dquot_dirty
>    __dquot_free_space
>    swap_inode_boot_loader
>    ext4_ioctl
> 
> jbd2 returns -ENOSPC and the journal is aborted.  The ioctl still
> returns 0, and the filesystem is left with the wrong i_blocks on the
> swapped inode and inconsistent quota usage, which e2fsck reports.
> 
> Reserve one quota block per quota type, as ext4_ext_migrate() does.
> 
> Tested on UML with a filesystem made by "mke2fs -O quota": write and
> sync a file, then issue EXT4_IOC_SWAP_BOOT on it.  Without this patch
> the WARN fires ("credits 3/0") and e2fsck -fn reports errors; with it
> there is no warning and e2fsck -fn is clean.
> 
> Fixes: aa507b5faf38 ("ext4: update quota information while swapping boot loader inode")
> Reported-by: syzbot+e8180f5590685cbc9037@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e8180f5590685cbc9037
> Signed-off-by: William Chuang <founder@logarcheon.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ioctl.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index e8e579498..ae03eb834 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -425,7 +425,12 @@ static long swap_inode_boot_loader(struct super_block *sb,
>  	truncate_inode_pages(&inode->i_data, 0);
>  	truncate_inode_pages(&inode_bl->i_data, 0);
>  
> -	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
> +	/*
> +	 * Two inode table blocks, plus one quota block per quota type for
> +	 * the dquot_free_space()/dquot_alloc_space() update below.
> +	 */
> +	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS,
> +				    2 + EXT4_MAXQUOTAS_TRANS_BLOCKS(sb));
>  	if (IS_ERR(handle)) {
>  		err = -EINVAL;
>  		goto err_out;
> -- 
> 2.43.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
