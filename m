Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD4F36EA9F
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 08:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117158; cv=none; b=YYwmcaP29cuSk+MZ0QHty5ZqG+90TQ0uTGWI7vYNmMAKrgFtlu7TMVYQW5ZK322dDtAhs59epV/fXOwie6QDimKqQ1vdSc1ewdRr+lGQzylzBAQPP4Mf1ZC5F5vP7RhTk6JNc/J1ZkngP+jKHak9gApaT0Bu7y+sDntH4MxDGaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117158; c=relaxed/simple;
	bh=Kz4UJpgV4C1qZYuv6lqU3D1849c/mrzdYJeExIIeJ3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jd7ozH7d4LvqKsHZOA55fgcEL2Iz+OLc5Mce3C09OVDnhw39YlFjY8IClB2MWdL3kOPNYfO54SHoRnwFZE108ju2ygsH1SP/5d7u5NH/epu7cnlQrbWt1osmB5ljmzsmMWp3/JXvXjPrnTppauF4aD6S4HSoTA8B7Ow46DLW3w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PCzPOMW/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z0jKwSTU; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=PCzPOMW/; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=z0jKwSTU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PCzPOMW/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z0jKwSTU";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="PCzPOMW/";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="z0jKwSTU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3D7586B6B6;
	Mon, 22 Jun 2026 08:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782117155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYprLsX2/S65xc2oNvgEHOpM7V9AUSRE/jjaKuC8vG4=;
	b=PCzPOMW/DN/Pmay6zwxJSAfvpoDnwJVj0fD2MDF0b61jmG6eMnyggncSKeqiQcU4lSJzZE
	MWNSfAdhArbbCN1Ubs/hMhpbFygx+bA5XM5DkMl2sW+yuj9XKDrtbqzF4/VUczTu1IIhjt
	pOPNIPN5AYc1VFIvzky2EqRcJYVXEdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782117155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYprLsX2/S65xc2oNvgEHOpM7V9AUSRE/jjaKuC8vG4=;
	b=z0jKwSTUX1mVzu1jeij17zI2jilJonEcLBDfH4LbPWcHlSC7r9tfwrZigNwFqO+qS1douv
	CAr/e4cLVj7AJDBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PCzPOMW/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z0jKwSTU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782117155; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYprLsX2/S65xc2oNvgEHOpM7V9AUSRE/jjaKuC8vG4=;
	b=PCzPOMW/DN/Pmay6zwxJSAfvpoDnwJVj0fD2MDF0b61jmG6eMnyggncSKeqiQcU4lSJzZE
	MWNSfAdhArbbCN1Ubs/hMhpbFygx+bA5XM5DkMl2sW+yuj9XKDrtbqzF4/VUczTu1IIhjt
	pOPNIPN5AYc1VFIvzky2EqRcJYVXEdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782117155;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IYprLsX2/S65xc2oNvgEHOpM7V9AUSRE/jjaKuC8vG4=;
	b=z0jKwSTUX1mVzu1jeij17zI2jilJonEcLBDfH4LbPWcHlSC7r9tfwrZigNwFqO+qS1douv
	CAr/e4cLVj7AJDBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 334C5779A8;
	Mon, 22 Jun 2026 08:32:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D/aADCPzOGqpfgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 22 Jun 2026 08:32:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C209EA12DE; Mon, 22 Jun 2026 10:32:30 +0200 (CEST)
Date: Mon, 22 Jun 2026 10:32:30 +0200
From: Jan Kara <jack@suse.cz>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Jan Kara <jack@suse.cz>, tytso@mit.edu, adilger.kernel@dilger.ca, 
	libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com, 
	yi.zhang@huawei.com, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/4] ext4: introduce ext4_put_ea_inode() for safe
 deferred iput
Message-ID: <tss5x73b6cigpsmi4yvckahikktacmtsphsupa6kysr2i5bsst@laxukmhkmv22>
References: <20260616151558.1728881-1-yun.zhou@windriver.com>
 <20260616151558.1728881-4-yun.zhou@windriver.com>
 <jxcbsd2ot63wy3dcoximemkuitwoqn2a7jgxcsfdwaf5q3ecdu@sahahqqopo6y>
 <dd9e35e6-306b-4e49-9802-487ce7abd63c@windriver.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd9e35e6-306b-4e49-9802-487ce7abd63c@windriver.com>
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[suse.cz,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,gmail.com,huawei.com,vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[10];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3D7586B6B6
X-Spam-Score: -2.51

On Fri 19-06-26 14:24:51, Zhou, Yun wrote:
> On 6/18/2026 2:42 AM, Jan Kara wrote:
> > > +static void ext4_xattr_inode_array_free_deferred(struct super_block *sb,
> > > +                             struct ext4_xattr_inode_array *array)
> > 
> > The array of EA inodes used in xattr handling is just another mechanism
> > used for delaying iput() of EA inodes. It doesn't make sense to stack these
> > to one on top of another. Just completely replace the array mechanism with
> > always deferring iput of EA inode into the workqueue.
> > 
> I'm thinking that a complete replacement might be too large a change. Should
> we consider postponing this work, or perhaps appending a new patch to this
> series to handle it?

Do one patch to implement the new framework for delayed EA iputs. Then
maybe one patch to convert existing iputs() of EA inodes to the new
delaying framework and then one patch to convert users of the current
'array to release' mechanism to the new delaying framework.

> > Allocating ext4_ea_iput_entry for dropping each inode is somewhat wasteful.
> > I want to suggest another scheme (somewhat more involved but more efficient
> > scheme):
> > 
> > 1) Create a VFS helper bool iput_if_not_last(struct inode *inode) which
> > drops inode reference if it is not the last one (and returns true in that
> > case). Basically:
> > 
> > bool iput_if_not_last(struct inode *inode)
> > {
> >          return atomic_add_unless(&inode->i_count, -1, 1);
> > }
> > 
> > This needs to be a separate patch as it should get vetting from VFS
> > maintainers.
> > 
> > 2) Use iput_if_not_last() in ext4_put_ea_inode(). If it returns true, we
> > are done. Otherwise we know we were at least for a moment holders of the
> > last inode reference, so we link the inode to the list of inodes to drop
> > through llist_node embedded in ext4_inode_info. We cannot race with anybody
> > else trying to link the same inode into the list because we hold one inode
> > ref and so nobody else can hit this "I was holding the last ref" path.
> > I'd union this llist_node say with xattr_sem which is unused for EA inodes
> > to avoid growing ext4_inode_info.
> > 
> > This way we avoid offloading unless really necessary and we don't have to
> > do allocations just to drop EA inode ref.
> 
> Your idea makes a lot of sense. It greatly simplifies the current deferred
> iput logic and eliminates the risk of failing to allocate an entry during
> an OOM. However, as you mentioned, getting the VFS maintainers to agree
> might be quite challenging.

VFS maintainers don't bite, in the worst case they'd disagree :) For a fact
I'm one of VFS reviewers and I think iput_if_not_last() idea is an
acceptable one. So I think it's worth trying.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
