Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9C1221F39;
	Thu, 24 Sep 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267175; cv=none; b=ZXQQ2xm4P4uY+vpxFtTTMyrRI09TmNjPTXzgwBkYd2DYCS4ynKhdiPCQ4tIWrvltwTh2s+fTf97rOBCB/qQdQ7cAU7+Zo/WiysH4C0NwCMcBHlIjQXSE3m86JNe+0z1rrtwyuRDCkcXatY39fL8kCCmAODftbcFLTFXcg31YTk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267175; c=relaxed/simple;
	bh=GBwsGq/c16eRIf9SgP1JA885U7vvY6nsVQzlwHl9tmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=enxhkVa3bTVExjkE81fV1OEBFNxCwoYkhNC4vFECPQlYDJJ9vlUTAbVd5M/XUyDR9LXZ6spnmkwklMMJVBD41lmZWkFgRkJpYWO0FA0iIQGkdnSozAfhMIvB4qyAiHCqxrEKTeUBmDVhPZlCXIAfNVHaPFgf0MgGZr6TH/KrRuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=flo68gNn; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BWUbc2vT; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=lepQ2No0; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=nLdBX8lz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="flo68gNn";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BWUbc2vT";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="lepQ2No0";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="nLdBX8lz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 57C8C20113;
	Thu, 24 Sep 2026 16:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790267167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNsW0Ricji6qGWWtvE4nR3LeWHVL38JIWd6EhtAoHdE=;
	b=flo68gNnJauA+BscrqF0/AJmqmZW5adDveugaJ1TLvGdePMA0+lxcwtXhwzZh4WTjdqOfd
	s0nlHXJ5OyKWqDQbjGcxcpZAeFF/aOoAzNUL1MWtVpTQSPVhpTqFS4/oiylXOrHrDWunj4
	EJEd7gKKyBSHdnX5qSDrsOhuLmrAg+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790267167;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNsW0Ricji6qGWWtvE4nR3LeWHVL38JIWd6EhtAoHdE=;
	b=BWUbc2vTWvgQ9/kJAc/AvHRe1paWgYnUpcFqLZaJW2xGtrabY+HgCdvGKQe85jJdipelEe
	vX9Uoj0TmREPCAAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790267163; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNsW0Ricji6qGWWtvE4nR3LeWHVL38JIWd6EhtAoHdE=;
	b=lepQ2No0TKcFO7iRaRidoB/D9M2r/qZEV4zGLfJmN7wKCXjP544doUdJy9KHo746McbzSk
	vZQn3/MHlVyCs5mHJzts01MpnM3QtMElXOvoEQeFQC+vtVYazhRhpYwzIYGRFLvDjAYBBw
	gQkymTMEz/W3qNy/Jcen0pnYNbS83MQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790267163;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oNsW0Ricji6qGWWtvE4nR3LeWHVL38JIWd6EhtAoHdE=;
	b=nLdBX8lzORNo12gXk3fLUmXR/gG4Jsl1yO9uUoyQA865yLvvc3/6yVdrFfBNi3sK9rbTXK
	kX8L3NbEkJryRaDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E11513354;
	Thu, 24 Sep 2026 16:26:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RMtNORpPtWo6eAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 16:26:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8D727A132E; Thu, 24 Sep 2026 18:25:58 +0200 (CEST)
Date: Thu, 24 Sep 2026 18:25:58 +0200
From: Jan Kara <jack@suse.cz>
To: 781735889@qq.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, jack@suse.cz, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, harshadshirwadkar@gmail.com, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ext4: propagate errors from fast commit create replay
Message-ID: <j7ujv5ea5z32bxcut7ndcfasaqi6dfa4w2xjgeej7lcsn64yrt@7eutvqnfjvfs>
References: <tencent_46A95D4281B70962D6EC1D523A85C448DC09@qq.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_46A95D4281B70962D6EC1D523A85C448DC09@qq.com>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[qq.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,qq.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[qq.com:email,suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Thu 17-09-26 11:28:33, 781735889@qq.com wrote:
> From: lty <781735889@qq.com>
> 
> During fast-commit replay, ext4_fc_replay_create() can fail while
> looking up the parent directory, initializing a new directory, or
> dirtying the replayed inode.  The parent lookup error jumps to the
> cleanup path while ret is still zero.  Errors from ext4_init_new_dir()
> are explicitly converted to zero, and the return value from
> ext4_mark_inode_dirty() is ignored.
> 
> Consequently, replay can report success and mount the filesystem even
> though the directory creation was not completely replayed.  A failed
> parent lookup, for example, leaves an unconnected directory inode.
> 
> Propagate these errors so journal recovery aborts rather than completing
> with inconsistent metadata.
> 
> Tested with QEMU fast-commit directory replay and injected failures in
> the parent lookup, directory initialization, and inode dirtying paths.
> Before the change, recovery completed and e2fsck reported an unconnected
> directory inode or inconsistent inode metadata.  With the change, JBD2
> reports recovery failure and the mount fails in all three cases.
> 
> Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
> Cc: stable@vger.kernel.org

I don't think this is really stable material. Mostly a cosmetic bugfix...

> Signed-off-by: lty <781735889@qq.com>

Otherwise looks mostly good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

but please fix one nit below:

> diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
> index b3c22636251d..e656abd938fb 100644
> --- a/fs/ext4/fast_commit.c
> +++ b/fs/ext4/fast_commit.c
> @@ -1656,12 +1656,12 @@ static int ext4_fc_replay_create(struct super_block *sb,
>  		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
>  		if (IS_ERR(dir)) {
>  			ext4_debug("Dir %d not found.", darg.ino);
> +			ret = PTR_ERR(dir);
>  			goto out;
>  		}
>  		ret = ext4_init_new_dir(NULL, dir, inode);
>  		iput(dir);
>  		if (ret) {
> -			ret = 0;
>  			goto out;
>  		}

Please remove the now superfluous braces.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
