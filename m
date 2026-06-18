Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC4428C86C
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781767331; cv=none; b=U193Fj+ZQeo8dGGYgCTEa8ix/d8+u8qJyBMuCoJS1XkHeoc/kpKUp5b1AMmGfCo4JN9ZW8PlYmqDKWRi/TIIzUUGD3UCbThzFsTPfs9iGgrNFlCXtmG46ULa6tBt6DUqfJsL3HQuS8LO3P+FOBAdom9ij5hp+kNeLdvuvgEvsuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781767331; c=relaxed/simple;
	bh=uZ3+xapxFKqnNLW5I7KNEVIzKnxiKUnh58Bx8yarE68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pnfAu6Y+6bjq0a7DmifLsWHcr9m3xsSm4SkLK+DoVxbkOANguI0AXmZjW9osl1zrj01lkp32V+9oMuvzICM9A6Xlb/n9JMR4fj79uDm75iswsKUXpXzzEiLGYoHASENc4V8xRItCBXGCFcKMBAszvvaLvQ9i0iY7Vd9atpinBaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k3hfGGuQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=RzocQxaY; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Sgp4jykB; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0qUl6/yq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k3hfGGuQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="RzocQxaY";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Sgp4jykB";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0qUl6/yq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C892275D2A;
	Thu, 18 Jun 2026 07:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781767328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x/UpBSxdLrbqRpbxVAOK6fH/d7zjPCxA7A2lBhDqbaw=;
	b=k3hfGGuQDOtz47C5i+GSveFEEeSVJ/wz9Y0oq75j/ayOHK1HOaInR/Na9g795xWbONacfF
	dA/8L232rq9aiIX3sFLI/CpG76h27wbrt1b+R7kImIwl/kio34iSCGXqpmrHTHhrATfHH8
	s+JMRthRKVkQYNlEEO650pAIc7dhT+0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781767328;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x/UpBSxdLrbqRpbxVAOK6fH/d7zjPCxA7A2lBhDqbaw=;
	b=RzocQxaYT070YATBqW1XJoLMaXEptJnMY/QatlAWy70Pv8btP84L2hsEc/ErmSZyWzVH0W
	H9wktKvZgqVsneCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781767326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x/UpBSxdLrbqRpbxVAOK6fH/d7zjPCxA7A2lBhDqbaw=;
	b=Sgp4jykBBNf5d+jMiVQ/bklBQBshB3eGrqqJkCCaE+kCXTUvQljTQBzn1lQNVxMLoG0hMY
	FUYn3S9wbnd2LfNFxEo2n4x7yG6InpCexWgLyV5NUejm92FZrK2rc0Dtq25Pf911Gci/8u
	5UXLhQumpPb40IcN+BQCq4Z+m7RaavU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781767326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x/UpBSxdLrbqRpbxVAOK6fH/d7zjPCxA7A2lBhDqbaw=;
	b=0qUl6/yqWdAV/nfWf6yus1+T007s9C9ofdi5R5Jwh/GZ8bbbSRhxUuskWoRVubI6Z93IBL
	dkxx8YNG+9ehNuAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCA4B779A8;
	Thu, 18 Jun 2026 07:22:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 62MLLp6cM2qAbAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 18 Jun 2026 07:22:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5BFA6A0EC0; Thu, 18 Jun 2026 09:21:58 +0200 (CEST)
Date: Thu, 18 Jun 2026 09:21:58 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, ebiggers@google.com, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ext4: validate EA inode i_nlink in
 ext4_xattr_inode_iget
Message-ID: <yee323q3l2tvonhf2ng6n4hmitygksbbsayr5xzyyo6xwxhxru@ctqxpvzi6nio>
References: <20260615053512.1315992-1-yun.zhou@windriver.com>
 <xzd6pbxhxxwf3ngj5v5pz2ilhykh7vsegohe6iwfkfytfuuv4o@5obqeoc5wocr>
 <ee05e46d-6ec8-4291-a61e-213812934da3@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee05e46d-6ec8-4291-a61e-213812934da3@windriver.com>
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,google.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Level: 

On Thu 18-06-26 09:02:10, Zhou, Yun wrote:
> 
> 
> On 6/18/26 04:25, Jan Kara wrote:
> > On Mon 15-06-26 13:35:12, Yun Zhou wrote:
> > 
> > --- a/fs/ext4/xattr.c
> > +++ b/fs/ext4/xattr.c
> > @@ -464,6 +464,33 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
> >                inode_unlock(inode);
> >        }
> > 
> > +     /*
> > +      * Since this function resolves references from active xattr entries,
> > +      * the EA inode must be in active state (i_nlink=1, ref_count>0).
> > +      * i_nlink > 1, i_nlink == 0 (dangling reference), or ref_count == 0
> > +      * (inconsistent with an active entry) all indicate corruption or
> > +      * a concurrent last-reference drop.
> > +      */
> > +     if (inode->i_nlink != 1 || !ext4_xattr_inode_get_ref(inode)) {
> > +             ext4_error(parent->i_sb,
> > +                        "EA inode %lu has unexpected i_nlink=%u ref_count=%llu",
> > +                        ea_ino, inode->i_nlink,
> > +                        ext4_xattr_inode_get_ref(inode));
> > Hum, given motivation of this is syzbot corrupted fs image, I'd just put
> > check in ext4_iget() verifying ext4_xattr_inode_get_ref() is > 0 and be
> > done with it. Much simpler and catches at least the obvious cases. The
> > consistency of xattr refcount and i_nlink is otherwise guarded by
> > ext4_xattr_inode_update_ref() and it can never be perfect as in the kernel
> > we don't have the full view of the filesystem and so cannot ascertain that
> > xattr ref count matches reality...
> > 
> Thanks very much for your review and suggestions, The issue should be easily
> fixed after "introduce ext4_put_ea_inode() for safe deferred iput" merged.
> Just need to defer iput() and no longer to make inode bad.

OK, just to make it clear, calling make_bad_inode() is never a right thing
to do once the inode has been exposed to other users. It is only usable
within iget functions when loading inode into memory and finding out the
content isn't valid. This function is one of the traps we have in VFS...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
