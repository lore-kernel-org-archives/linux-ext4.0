Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753E823A564;
	Mon,  7 Sep 2026 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772575; cv=none; b=FahFwxM1Bi9GsAi0PENtWxu2yokjiYk/qAd59KNScbNhw2s3rrrje6guZpWggchshi5DoUctrjbOkdFP47IuaV5A+bIl2yaRAACDCFPH3Ky6IUZGrz6LuSDwiCQQUhvHLD+rbUFm+hyqwVFNjpDAOPlgI8218BrNITS1VnsCtAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772575; c=relaxed/simple;
	bh=nyeXT7VKcyicheWKNA3VWLtWaQDzwXpTmzKN2bqQm2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0U1V2OWRGyWN0EzoYRx/ycgzf/C0Mzm57YCq2H9LdhThf0j1iSSQ0uk+umB/QgTS9YyUJtH8UXSrj+7Ct5ZVy0/oql5IyU39PjgIs5XTrUkseLi4L7ZzeMQNgf4ljXKwWYcqvBeB52njqBkJGpSzIjDRA3qU6ExPNIAL8Ndca8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BIJ7vCEc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=YQBfdVnH; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=hqoVPnx8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FeYTZ78p; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BIJ7vCEc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YQBfdVnH";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="hqoVPnx8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FeYTZ78p"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CCE9B21B03;
	Mon,  7 Sep 2026 09:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788772566; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sYukoxLIvcIeCNv84bg5j/8WD9NrROW7Ib+rBJ/gtlU=;
	b=BIJ7vCEcJpnzPmZGdG9vWZiGQGWq8LwwSj4jMye1Yk63Znt/7YhyvxG72K1CxsfONz8Rv+
	bZUWr3B4xjhTmiN4CDjJT3sClort+kQnwz2hDqjevFj/w/DklsL4/3DgOvERbgFoq5X1Zi
	EuOF4Q5cETruvc4IOrfiOKy38KfkLxM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788772566;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sYukoxLIvcIeCNv84bg5j/8WD9NrROW7Ib+rBJ/gtlU=;
	b=YQBfdVnHZeIMR0ip+MxiIfqEojvp/RSeqBfnHkKrDeYnDveQHmzwfUv3iQbDd7F/m2BOte
	IPH7kxQgmF0ID3Bg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788772562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sYukoxLIvcIeCNv84bg5j/8WD9NrROW7Ib+rBJ/gtlU=;
	b=hqoVPnx8JyeDz1IcSutLbucJt4s/pR50CMsYiWZN9ZFX7TEtDSt5VxkAEWj9mLlPDpb3C2
	AEsE1g4RBUurZNgGkEPxY8d4nX/MnHkfP6LznyqcpzppnoPVBNCUhCCkvZECy/qe/8FjqS
	acXADyC00CpJbONY9OJt/AWWT+yobPw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788772562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sYukoxLIvcIeCNv84bg5j/8WD9NrROW7Ib+rBJ/gtlU=;
	b=FeYTZ78pIKFsIiux0JMuYXZmMS0Dy7mAIrz7VNUwLrcF9WhU5hZi1q4AAD+bZ4j12yrkp7
	MoWgdVEoxcXKh4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AAE8F13432;
	Mon,  7 Sep 2026 09:16:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nqC0KdKAnmokcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 07 Sep 2026 09:16:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4200EA13B2; Mon, 07 Sep 2026 11:15:54 +0200 (CEST)
Date: Mon, 7 Sep 2026 11:15:54 +0200
From: Jan Kara <jack@suse.cz>
To: ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, 
	jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com, Claude Sonnet 5 <noreply@anthropic.com>
Subject: Re: [PATCH] ext4: avoid buffer/folio lock inversion in
 __ext4_get_inode_loc()
Message-ID: <ege6cyr27qho4w45yp2idgywux5jkk4ttf6wye4muwdgsqxb6j@ndobmdkaimud>
References: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906104841.56075-1-ngocthang2710.1999@gmail.com>
X-Spam-Level: 
X-Spam-Score: -2.30
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
	TAGGED_RCPT(0.00)[03afbb29537f0336b7ad];
	RCPT_COUNT_TWELVE(0.00)[12];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org,syzkaller.appspotmail.com,anthropic.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,syzkaller.appspot.com:url,imap1.dmz-prg2.suse.org:helo,suse.com:email,anthropic.com:email,suse.cz:email]

On Sun 06-09-26 17:48:41, ThangNN99 wrote:
> The itable-block bh is locked, then the "is bitmap cached?" probe calls
> sb_getblk(), which can block on that bitmap block's folio lock. A
> concurrent block_read_full_folio() on the same bdev folio locks buffers
> in the opposite order (folio lock, then each bh), so the two tasks can
> deadlock on each other's lock. Use the non-blocking cache lookup here
> instead; a miss already falls back to make_io exactly as before.
> 
> Only ext4_reserve_inode_write() reaches this probe with a real inode
> (ext4_iget() passes NULL, which skips it), and it normally runs right
> after the read that loaded that same inode, so the itable buffer is
> still warm and the early "already uptodate" return skips the probe.
> The window needs the folio reclaimed between load and writeback, which
> is why this is rare and why syzbot's bisection could not pin it down.

Thanks for the analysis! Maybe the description would me more understandable
as:

__ext4_get_inode_loc() looks up inode bitmap bh under the lock of inode
table bh like:

__ext4_get_inode_loc()
  lock_buffer(itable block)
  sb_getblk(inode bitmap block)
    __find_get_block_nonatomic()
      folio_lock(bdev folio for bitmap block)

OTOH block_read_full_folio() does:
   folio_lock(some folio)
     lock_buffer(bh in folio)

block_read_full_folio() can be executed for example from userspace by
reading bdev inode.

Now generally (in particular if folio size == block size) the itable block
is not in the same folio as the inode bitmap block so this isn't really a
problem. But when folio size > block size, it can happen that the itable
block is in the same folio as inode bitmap block and this can the deadlock.

--

Is my understanding correct?

Also it seems this is a general problem for places where we call
sb_getblk() for one buffer while having locked another buffer. I suspect we
may have more places in the code than just this one. We'll need to
investigate.

> Reproduction status: root-caused from source and confirmed against
> both syzbot stacks (inode.c:__ext4_get_inode_loc vs.
> buffer.c:block_read_full_folio); the lock_buffer()/reserve_inode_write
> path was exercised live (orphan cleanup on mount) to confirm reachability
> and to confirm this patch introduces no regression there. The deadlock
> itself was not reproduced locally -- doing so needs the itable buffer
> genuinely reclaimed between inode load and writeback, which a small
> single-shot QEMU test doesn't naturally produce.
> 
> Reported-by: syzbot+03afbb29537f0336b7ad@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=03afbb29537f0336b7ad
> Signed-off-by: ThangNN99 <ngocthang2710.1999@gmail.com>
> Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>

LLMs cannot be authors. Please just put here tag:

Assisted-by: LLM

Otherwise the fix for this problem looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bd4b778df9eb..13e3cb829461 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4942,8 +4942,12 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
>  
>  		start = inode_offset & ~(inodes_per_block - 1);
>  
> -		/* Is the inode bitmap in cache? */
> -		bitmap_bh = sb_getblk(sb, ext4_inode_bitmap(sb, gdp));
> +		/*
> +		 * Is the inode bitmap in cache? Non-blocking lookup: bh above
> +		 * is locked, and blocking here would folio_lock() against a
> +		 * block_read_full_folio() that locks bh the other way round.
> +		 */
> +		bitmap_bh = sb_find_get_block(sb, ext4_inode_bitmap(sb, gdp));
>  		if (unlikely(!bitmap_bh))
>  			goto make_io;
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
