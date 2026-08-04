Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A2631F9B9
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 09:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834454; cv=none; b=teQfJzHZcUSMzrnFb5fls/per3Gi5c4MNzTFX46NkqcYuIT6+RChGRGQn11s8jbvJYJstDEYiKkLn9Ew+ikq08Eyn4H2z7jN4EwWgo0kFUPw/r+SbVnEZwigXCB3zwBJjrjD/NMH6dZO2GTPay8Hs++qU+06qLpBTtL9oxUWTwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834454; c=relaxed/simple;
	bh=z6LTDi7Ic+PVPkbEHnwOr9XgG8t4JVARcvNXupFzE8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgAsTrcJjR180AvKvYiQXyZ0Er8tAOiF0Zq2EaW0ecu1RZFqnFUJtM7pYkZo0cxvz09l+rh3Yz5QBG+tAZHOV5LnlgqaUbkN1sKFKXsgVgINaz4KK/PMVmMVAW4/K2+CAS1N7KXyIxUGmsik8I3ZtYKxmxZU7ktf53NO7IDY6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=K/cqtAeL; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=AcODX7jn; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=I63le3YZ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bkAw1XAg; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="K/cqtAeL";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="AcODX7jn";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="I63le3YZ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bkAw1XAg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 039AB7F74F;
	Tue,  4 Aug 2026 09:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Drr1dSVtHc85g36j/cdUzwzLApJcbJGcKCrshmpuzKk=;
	b=K/cqtAeLAd4P42aInn4bwbWFJckEnTxq0AROVfQfd8ZMNtQ6LbYVRltl33zp/+6mMUJrjV
	rgjFD5vF7rio1yPSeDKyLcoRGcGNJTo1L4Dm5yjLL3JRQCw4iuBRl/LjkvN4uCScZj1wUv
	t7qhEITJGMiX6C1Pp7h8sYVrKilkFWk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834446;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Drr1dSVtHc85g36j/cdUzwzLApJcbJGcKCrshmpuzKk=;
	b=AcODX7jnSoChLNobfnWQy657w2U413w3kbSXIV9F2sl9Ahd/5gyD/tdrb9frvFoyzksMlU
	ccDLqWesQPwIJWDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785834442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Drr1dSVtHc85g36j/cdUzwzLApJcbJGcKCrshmpuzKk=;
	b=I63le3YZDvryW3FZRlaSUo0IuT8IMLJxdZ7d4sjnTfccP2hP1dAPcUL1TMz4uR6VPAav2h
	7IgM/VqTCIP7ZZx447GBUedPXdJbCgfr+PVKipx20LGZRJPkhv4JuzaJ+V1kF85Y7jSxgN
	7iMbfTjCIvXJtlcpC1qBkbkeDEiejxk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785834442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Drr1dSVtHc85g36j/cdUzwzLApJcbJGcKCrshmpuzKk=;
	b=bkAw1XAgWfBOjTX5E3BzMdwZDEuOZJUMEQRLRJBnDd1DEJQC/4yASUokMR5OAL/NfpQkJn
	4X828/lnRm5UaDDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAB34779BB;
	Tue,  4 Aug 2026 09:07:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id esybLcmrcWosAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 09:07:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A5EA9A13A6; Tue, 04 Aug 2026 11:07:20 +0200 (CEST)
Date: Tue, 4 Aug 2026 11:07:20 +0200
From: Jan Kara <jack@suse.cz>
To: Chao Shi <coshi036@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Baokun Li <libaokun@linux.alibaba.com>, 
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Bob Copeland <me@bobcopeland.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] ext4, jbd2: report fast commit write errors with
 BH_Write_EIO
Message-ID: <liddhnv7367ifj3mk5qokdax5jexltpvbtxpkqpkt6qzolv7af@zll26cngckwl>
References: <cover.1785621505.git.coshi036@gmail.com>
 <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f988ec74b5d1135d5d67771240639e57ba9e0f4.1785621505.git.coshi036@gmail.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Sat 01-08-26 18:01:02, Chao Shi wrote:
> ext4_end_buffer_io_sync() is the third completion handler in this
> series that reports a failed write by clearing BH_Uptodate, and
> jbd2_fc_wait_bufs() is the only thing that looks at the result.
> Convert both.
> 
> They have to move in the same patch.  The handler lives in ext4 and
> the wait in jbd2, but neither is used by anything else: the buffers
> are ext4's fast commit blocks, submitted by ext4_fc_submit_bh() and
> waited for by jbd2_fc_wait_bufs().  Converting one without the other
> silently disables fast commit write error reporting.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>
> ---
>  fs/ext4/fast_commit.c | 2 +-
>  fs/jbd2/journal.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index 8e2259799614..8cd60c9f2272 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -213,7 +213,7 @@ static void ext4_end_buffer_io_sync(struct bio *bio)
>  	} else {
>  		ext4_debug("%s: Block %lld not up-to-date",
>  			   __func__, bh->b_blocknr);
> -		clear_buffer_uptodate(bh);
> +		mark_buffer_write_io_error(bh);
>  	}

Again, this is only ever used for writes and buffer is guaranteed to be
uptodate so please rename 'uptodate' to 'ioerr' and remove the setting of
uptodate bit as well. And the ext4_debug() messages need slight update as
well.

								Honza

>  
>  	unlock_buffer(bh);
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 9e4cb04587b4..ffe7a22e6699 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -890,7 +890,7 @@ int jbd2_fc_wait_bufs(journal_t *journal, int num_blks)
>  		 * Update j_fc_off so jbd2_fc_release_bufs can release remain
>  		 * buffer head.
>  		 */
> -		if (unlikely(!buffer_uptodate(bh))) {
> +		if (unlikely(buffer_write_io_error(bh))) {
>  			journal->j_fc_off = i + 1;
>  			return -EIO;
>  		}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
