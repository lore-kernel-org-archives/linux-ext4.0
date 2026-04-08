Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B763B8D78
	for <linux-ext4@vger.kernel.org>; Wed,  8 Apr 2026 13:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655382; cv=none; b=RMaxGP/A7T6fueiPIq+NT/qIGcKtvhHjK+f1xFzILVBV/SAWkIXJdqthzPze17F1LwE5NilsMt35LMtRa/d/vXHvAALKtEhMoLoOVjLA6fjxhOBk7m3Tjwl/Az790SaJXZO8M4sQuYx6Pf4Aa3I6I7gpzLXHxU2+Gy9lfEbQwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655382; c=relaxed/simple;
	bh=EqP8/FvncSUb7aBsqFSDjREJJJusvapLcSq0v6ylJW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VsmdqzKvFHFxitTNqNLoGK6Btaz6p9F/J1AQM+pBc9x41CYSHJC62h0xC36SsacksfSQEyBhvaf2yd5+MZwA69C2m5nmvumz1s0QW2rY9eRokL0Bgy7svxm5Vinj2YhFCLbl1YZszbNLz8mvvRWcWeIiHXhz+95KZqd3QgJ/kLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKNAefHz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bABybiQd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XKNAefHz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=bABybiQd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKNAefHz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bABybiQd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XKNAefHz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="bABybiQd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFC865BCC1;
	Wed,  8 Apr 2026 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775655378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwTavLrc/kQ/Vsd5Ty2cWzcIWNYP4TdPzKHycl4IJLs=;
	b=XKNAefHzI1RkdJsybkgBJWMPRB1Ro7Op899l2XD+hlc1LcO0FqajLka06LusDWoJx70iXn
	ex9tVtqDt2jwoZJhfa8kvHfSCf5RCfzUirTcvoA+gf+F1uIRES7ndbz4Nx0Le8jUL948OZ
	Q/dRpd+/bFjJ7v5JikKHJOMw15TjtSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775655378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwTavLrc/kQ/Vsd5Ty2cWzcIWNYP4TdPzKHycl4IJLs=;
	b=bABybiQdrLUjUeAOf/AFebhBE8a84iiHJkwB7LAmgqkRscYxPtRRPdteS+1ZRiiFvfNDXN
	WrEAH57N4AJJawBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1775655378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwTavLrc/kQ/Vsd5Ty2cWzcIWNYP4TdPzKHycl4IJLs=;
	b=XKNAefHzI1RkdJsybkgBJWMPRB1Ro7Op899l2XD+hlc1LcO0FqajLka06LusDWoJx70iXn
	ex9tVtqDt2jwoZJhfa8kvHfSCf5RCfzUirTcvoA+gf+F1uIRES7ndbz4Nx0Le8jUL948OZ
	Q/dRpd+/bFjJ7v5JikKHJOMw15TjtSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1775655378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IwTavLrc/kQ/Vsd5Ty2cWzcIWNYP4TdPzKHycl4IJLs=;
	b=bABybiQdrLUjUeAOf/AFebhBE8a84iiHJkwB7LAmgqkRscYxPtRRPdteS+1ZRiiFvfNDXN
	WrEAH57N4AJJawBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D53DA4A0B3;
	Wed,  8 Apr 2026 13:36:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y1wKNNJZ1mnKLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 08 Apr 2026 13:36:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8C3F2A0A7E; Wed,  8 Apr 2026 15:36:10 +0200 (CEST)
Date: Wed, 8 Apr 2026 15:36:10 +0200
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Ye Bin <yebin@huaweicloud.com>, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] show orphan file inode detail info
Message-ID: <fdil2jz7kizzrlew7airdlpvnz7qyzigigaw3huktm66455wuh@yyqhacmxe4qk>
References: <20260403082507.1882703-1-yebin@huaweicloud.com>
 <n4sccudy5avcgnkdhc27rzofzoprxqtwhfrlmsh3yyrj6vbc6d@mmu73gmtawkq>
 <20260407202845.GA38246@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407202845.GA38246@macsyma-wired.lan>
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Tue 07-04-26 16:28:45, Theodore Tso wrote:
> On Tue, Apr 07, 2026 at 12:29:23PM +0200, Jan Kara wrote:
> > I agree listing orphan inodes for a superblock is useful and the usefulness
> > could actually go beyond ext4. I imagine the very same problem is there for
> > XFS or btrfs so perhaps we could think for a while whether we can provide
> > an interface that wouldn't be ext4 specific? Perhaps an ioctl
> > (GET_ORPHAN_FILES) that would return an fd and reading from that fd would
> > return entries for orphan inodes?
> 
> I'm really not a fan of ioctl's returning a fd, but that does seem to
> be a thing these days, for better or for worse, and I agree that
> having a portable solution that works across multiple file systems
> would be a good thing.

Yes, ioctl returning fd isn't great but frankly a file in /proc looks even
worse to me...

> > Also regarding information reported about orphan inodes - won't it be better
> > interface to just return a list of file handles? Userspace can then do
> > whatever it needs with them - open, statx, calling ioctl, etc - so we
> > thwart feature creep with people asking us to add more information to the
> > interface. This also offloads a lot of security questions about the
> > interface to appropriate syscalls. So overall it looks like a win to me.
> 
> The problem with using a file handle is that the only way to get the
> pathname is to open the file handle, and then call readlink on
> /proc/self/fd/NN.

Right, which is pretty standard I'd say.

> And inodes on the orphan inode list have been unlinked, so we don't want
> to allow people to be able to open them.

Why? You can reopen unlinked files using magic links in proc or file
handles just fine today (just tested this if I'm not missing anything in
the code). Only once the inode is really deleted you cannot open using the
handle anymore.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
