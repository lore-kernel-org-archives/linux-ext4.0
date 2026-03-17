Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535EE3AEF31
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773748217; cv=none; b=A29BbShk83rPZ2WLBUUWWOTkShskMm4U9ww3nNRzaV9ndO0K3uPjH5zX6WmduCY+P2mU7EvhkJB1QI/C0pW99afC4vM+C+y5wvV6YcHyyvSwl4RAB30LMeod2uHDhcjdf6qAcQf01uMDx30V7aUDoi0klkvjGNmntInlCxyB6ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773748217; c=relaxed/simple;
	bh=Erj8Kzj69FZGFXVp7fnEZzZdL208JVwvNceFTqTWGqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=naMHvpJ38n21G40bjqKoiBedV/a6Oy5t6VV6YYgSq5rTsYLUIhwO2lNWlpvDMVXfgfkqtv3yiRy53T1ePZ8gDkCqwDT8LYB3x6B6iM9XeAfDEB5UqypayHzyb9Ak4S3wbd6bEn/hxT0Ok7EP4DR0zghPo2W6Kl+fxysVrW8iUao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p2YWXluh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wzqWwUOp; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=p2YWXluh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=wzqWwUOp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p2YWXluh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wzqWwUOp";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="p2YWXluh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="wzqWwUOp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EC785BDCA;
	Tue, 17 Mar 2026 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773748213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMa+bUvJhcvAmmrgLCA3Tnv+9U4u85bmrB/H/AwTyOU=;
	b=p2YWXluhoPSwFY6OE5iOnDXFbTxA9V+yMq/+ykjFH528UyNnCAhNsYfYyyoG76SoB81MK4
	5dvJ51RI2GjyziincpR6KdS8WAPscbOMn0wcXYH7fcX9U6cy4r2yJ5urOVsUuPyXw3qESq
	Bd/XFAgxlrIR9zhRwTX8iREAf5AJcyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773748213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMa+bUvJhcvAmmrgLCA3Tnv+9U4u85bmrB/H/AwTyOU=;
	b=wzqWwUOpDMKvigyk1zGubbokodWnbiFd40YJ/c4ZH+BDuKssGKJdA4U5RDaIm5cuDbmADP
	BKui7LprFJICwUAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=p2YWXluh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wzqWwUOp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1773748213; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMa+bUvJhcvAmmrgLCA3Tnv+9U4u85bmrB/H/AwTyOU=;
	b=p2YWXluhoPSwFY6OE5iOnDXFbTxA9V+yMq/+ykjFH528UyNnCAhNsYfYyyoG76SoB81MK4
	5dvJ51RI2GjyziincpR6KdS8WAPscbOMn0wcXYH7fcX9U6cy4r2yJ5urOVsUuPyXw3qESq
	Bd/XFAgxlrIR9zhRwTX8iREAf5AJcyU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1773748213;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QMa+bUvJhcvAmmrgLCA3Tnv+9U4u85bmrB/H/AwTyOU=;
	b=wzqWwUOpDMKvigyk1zGubbokodWnbiFd40YJ/c4ZH+BDuKssGKJdA4U5RDaIm5cuDbmADP
	BKui7LprFJICwUAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 64BE84273B;
	Tue, 17 Mar 2026 11:50:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nzmWGPU/uWlPWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 17 Mar 2026 11:50:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 205CCA0A5B; Tue, 17 Mar 2026 12:50:09 +0100 (CET)
Date: Tue, 17 Mar 2026 12:50:09 +0100
From: Jan Kara <jack@suse.cz>
To: Baokun Li <libaokun@linux.alibaba.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, 
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH e2fsprogs] lib/quota: fix checksum mismatch on
 uninitialized PRJQUOTA inode
Message-ID: <bd5gg6pv5czo6okeelhiq4smerzlrdvqxcho7gillkfltowmvy@gyped3r7vpwn>
References: <20251210081558.2714709-1-libaokun@huaweicloud.com>
 <8382fe78-5b3f-4c1a-96eb-62494835f693@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8382fe78-5b3f-4c1a-96eb-62494835f693@linux.alibaba.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.com:email,suse.cz:dkim,suse.cz:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 6EC785BDCA
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 

On Thu 12-03-26 14:26:08, Baokun Li wrote:
> A gentle ping...
> 
> On 12/10/25 4:15 PM, libaokun@huaweicloud.com wrote:
> > From: Baokun Li <libaokun1@huawei.com>
> >
> > In quota_inode_init_new(), we attempt to read and truncate an existing
> > quota inode before proceeding with its initialization.
> >
> > This read operation verifies the inode's checksum. This works fine for
> > USRQUOTA and GRPQUOTA inodes because write_reserved_inodes() is always
> > called during ext4 image creation to set appropriate checksums for these
> > reserved inodes.
> >
> > However, the PRJQUOTA inode is not reserved, and its corresponding inode
> > table block may not have been zeroed, potentially containing stale data.
> > Consequently, reading this inode can fail due to a checksum mismatch.
> >
> > This can be reproduced by running the following sequence:
> >
> >   dd if=/dev/random of=$DISK bs=1M count=128
> >   mkfs.ext4 -F -q -b 1024 $DISK 5G
> >   tune2fs -O quota,project $DISK
> >
> > Which results in the following error output:
> >
> >  tune2fs 1.47.3 (8-Jul-2025)
> >  [ERROR] quotaio.c:279:quota_inode_init_new: ex2fs_read_inode failed
> >  [ERROR] quotaio.c:341:quota_file_create: init_new_quota_inode failed
> >  tune2fs: Inode checksum does not match inode while writing quota file (2)
> >
> > While running `kvm-xfstests -c ext4/1k -C 1 generic/383`, the test itself
> > does not fail, but checksum verification failures are reported even
> > without fault injection, which led to discovering this issue.
> >
> > To fix this, we stop attempting to read the quota inode that is about
> > to be initialized inside quota_inode_init_new(). Instead, the logic
> > to attempt truncation of an existing quota inode is moved to be handled
> > inside quota_file_create().
> >
> > Fixes: 080e09b4 ("Add project quota support")
> > Signed-off-by: Baokun Li <libaokun1@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> > ---
> >  lib/support/quotaio.c | 30 +++++++++++++-----------------
> >  1 file changed, 13 insertions(+), 17 deletions(-)
> >
> > diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
> > index f5f2c7f7..827df85b 100644
> > --- a/lib/support/quotaio.c
> > +++ b/lib/support/quotaio.c
> > @@ -274,18 +274,6 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
> >  	errcode_t err = 0;
> >  	time_t now;
> >  
> > -	err = ext2fs_read_inode(fs, ino, &inode);
> > -	if (err) {
> > -		log_err("ex2fs_read_inode failed");
> > -		return err;
> > -	}
> > -
> > -	if (EXT2_I_SIZE(&inode)) {
> > -		err = quota_inode_truncate(fs, ino);
> > -		if (err)
> > -			return err;
> > -	}
> > -
> >  	memset(&inode, 0, sizeof(struct ext2_inode));
> >  	ext2fs_iblk_set(fs, &inode, 0);
> >  	now = fs->now ? fs->now : time(0);
> > @@ -319,6 +307,10 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> >  	if (fmt == -1)
> >  		fmt = QFMT_VFS_V1;
> >  
> > +	err = ext2fs_read_bitmaps(fs);
> > +	if (err)
> > +		goto out_err;
> > +
> >  	h->qh_qf.fs = fs;
> >  	qf_inum = quota_type2inum(qtype, fs->super);
> >  	if (qf_inum == 0 && qtype == PRJQUOTA) {
> > @@ -330,15 +322,19 @@ errcode_t quota_file_create(struct quota_handle *h, ext2_filsys fs,
> >  		ext2fs_mark_ib_dirty(fs);
> >  	} else if (qf_inum == 0) {
> >  		return EXT2_ET_BAD_INODE_NUM;
> > +	} else {
> > +		err = quota_inode_truncate(fs, qf_inum);
> > +		if (err) {
> > +			log_err("quota_inode_truncate failed, ino=%u, type=%d",
> > +				qf_inum, qtype);
> > +			return err;
> > +		}
> >  	}
> >  
> > -	err = ext2fs_read_bitmaps(fs);
> > -	if (err)
> > -		goto out_err;
> > -
> >  	err = quota_inode_init_new(fs, qf_inum);
> >  	if (err) {
> > -		log_err("init_new_quota_inode failed");
> > +		log_err("init_new_quota_inode failed, ino=%u, type=%d",
> > +			qf_inum, qtype);
> >  		goto out_err;
> >  	}
> >  	h->qh_qf.ino = qf_inum;
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
