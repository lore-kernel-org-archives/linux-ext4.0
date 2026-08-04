Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0221F43F8A5
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 08:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832864; cv=none; b=Oqs5Zpq52uAz4rekB50TON8ujPlCtslCz8rhJZVLbJlxgqma9qUBS1akxq4m4CHE4buBQ0DFXryMyzaFHRh3LRlsjZg44eCBEtSb2Fr+BtaJlZs6aP9bqhzd6ivU7iox5P938/3aiCC3RZkSAcKf7cbDRQtdhOtPCwldVs+U2bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832864; c=relaxed/simple;
	bh=nEBBIo1M8ArwW41w1iRIh2eixE8nk+dn65cT24O2B6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XmKtc+a5/2QUJd9HERojCFUqZgxLB6g/+CrXPwgz5ZsnLqfg30BGG6zIIZBzfrTUSZrmWrLW47/PmSgULtqOSY1ldSWERAzYXJjk5TWgZvw4r+PSPEYRW9GQqkdcQVIpJJ3798Ktn3uwc3VfB7PTEkw7SSYOFd9LV5c+NPdIM6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=b23irAsU; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=qXmQj8xI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=s7TI4fh7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hz97fj1s; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="b23irAsU";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="qXmQj8xI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="s7TI4fh7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hz97fj1s"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFEE3406C;
	Tue,  4 Aug 2026 08:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLKbDMvfRDZJOe0L2jtn4eYyuenfjaTy83OjwV3ZDAs=;
	b=b23irAsUDBugHdwPHQSKb/vbnzMKvmVXg8LlbAyhoXFFVpoW8Bk8Gidym6jPrqhQyRy8f8
	xru7ddBMyOixBipLO+KMV1cBF1a0W+0vhvGiF+/Cpd89JssR8SPOrSlaehE6855owNP7bF
	Sq3uuST1MjfwwrkyeTYw5/54VuymFks=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLKbDMvfRDZJOe0L2jtn4eYyuenfjaTy83OjwV3ZDAs=;
	b=qXmQj8xIFEz0XqN8D+XcctdqEgWlupE0N7HT+h7+zSSw6853LoEUgo2qMnR8lduR6FAX/t
	KCiw4Ybo9GMUF1Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785832850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLKbDMvfRDZJOe0L2jtn4eYyuenfjaTy83OjwV3ZDAs=;
	b=s7TI4fh7JgfYgKEL648Rj8JlMnmrdoL1oFr+Aq/2J3XwKjTmWfduELzb+pIuec/PWZzLz4
	ooh1RSzDh1++D6EsL7FKBbvy+HJEwnPjO+dsc/lXwxfgTOsIcMVpjN75rkWmuh3ipsDVW1
	CJBQ9MczJbr3qtnkiWGQnWuN7nbvFx8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785832850;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cLKbDMvfRDZJOe0L2jtn4eYyuenfjaTy83OjwV3ZDAs=;
	b=Hz97fj1sxPykr+L3cUpwmSMCMjmCYu/n+XhulZpOxZAbdjJJRVlIEdTB7EqaxU7x6atDJ1
	RODqQmfd9fNGP9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D5159779BE;
	Tue,  4 Aug 2026 08:40:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1lYDNJKlcWoMZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 04 Aug 2026 08:40:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 85244A13A6; Tue, 04 Aug 2026 10:40:50 +0200 (CEST)
Date: Tue, 4 Aug 2026 10:40:50 +0200
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
Subject: Re: [PATCH 08/19] ext2: check for an xattr block write error with
 buffer_write_io_error()
Message-ID: <6ftoth3c5myyf4ig2g6p6ypqom5jo77fkkbfcsmaeptlvh7nsd@6wzx5qqtjuhr>
References: <cover.1785621505.git.coshi036@gmail.com>
 <f4c58a745b508ba79c114a3467eceaeb08647385.1785621505.git.coshi036@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4c58a745b508ba79c114a3467eceaeb08647385.1785621505.git.coshi036@gmail.com>
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
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,suse.cz:email];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,kernel.org,zeniv.linux.org.uk,infradead.org,vger.kernel.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]

On Sat 01-08-26 18:00:52, Chao Shi wrote:
> ext2_xattr_set2() spots a failed synchronous write by testing BH_Req
> together with !BH_Uptodate.  That relies on the write completion handler
> clearing BH_Uptodate on error, which this series removes: a buffer whose
> write failed still holds the data the filesystem asked to be written, so
> declaring it not up to date is wrong and makes callers re-read it.
> 
> BH_Write_EIO says exactly what this code wants to know, and it implies
> BH_Req, so the pair collapses into one test.
> 
> No behaviour change today - a failed write sets BH_Write_EIO and clears
> BH_Uptodate together.  It stops being a no-op at the end of the series,
> where the new test is the one that still works.
> 
> Signed-off-by: Chao Shi <coshi036@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext2/xattr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index be63f89402a3..39005ec23fe5 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -769,7 +769,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
>  		if (IS_SYNC(inode)) {
>  			sync_dirty_buffer(new_bh);
>  			error = -EIO;
> -			if (buffer_req(new_bh) && !buffer_uptodate(new_bh))
> +			if (buffer_write_io_error(new_bh))
>  				goto cleanup;
>  		}
>  	}
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
