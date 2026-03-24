Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B619377ED4
	for <linux-ext4@vger.kernel.org>; Tue, 24 Mar 2026 12:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774356681; cv=none; b=NDdSv86d5L3MdXNmo3CT+8Fju9MsYEjUrxGxSnlJtQd2GbvstqiFvAT8QsZyRo9/ZupJopuHUwpOi/z+DmBfKJwzearVc1nEtcuyP7UlFmcPbcKJrqerxShBeTL2w2cUhVZWgQOMiNLjnZndk9xEZ8/ATjjXeMMgb7p4tx1TMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774356681; c=relaxed/simple;
	bh=UM5/RD1aeQ7z5GxH2rhsmLx6xDKJoBhJYb498uboGHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r14VrfzfV+k+hGgz3NFPzxUMgmAdr9YGT08O0ivHFTsmdoBUdeJFBkln+3VRJZ17chdBKvakHlB9J3dyXT1VnIw+Vr9FcWKoYkvzJ8FGUpA2JeKbFhQmFWD6ntoYyNnzqURwHYVHjfRrrqzX4ZLC4hIIvLYWL+/VzkBm7pzhd+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CkXM2qqf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lS/AAT+a; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=CkXM2qqf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lS/AAT+a; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CkXM2qqf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lS/AAT+a";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="CkXM2qqf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lS/AAT+a"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75CA74D4E6;
	Tue, 24 Mar 2026 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774356678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=CkXM2qqfqoQoJPfy5qQoPuU0n2jdb6wAEMMNP74JiXs3pb0gw+ZWdZLUv7fOIMKwbm8wbI
	4tMsvX1TIn9EO1e7hHwjbv99Zrc4viJXRMMEkfh0fXD+m1rkUyBSVNWI1E49Ypalm2v2pv
	VmnlXOZJV24RIXdcyXCAksUa5wTEynU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774356678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=lS/AAT+ag7CxAS5QsLazid/zTAJYBU8bEnu0S3GpJCClX7OfBrY45XPrARrzgHDVGJOX8S
	EA7+x2UkU1LNo5AQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774356678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=CkXM2qqfqoQoJPfy5qQoPuU0n2jdb6wAEMMNP74JiXs3pb0gw+ZWdZLUv7fOIMKwbm8wbI
	4tMsvX1TIn9EO1e7hHwjbv99Zrc4viJXRMMEkfh0fXD+m1rkUyBSVNWI1E49Ypalm2v2pv
	VmnlXOZJV24RIXdcyXCAksUa5wTEynU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774356678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=lS/AAT+ag7CxAS5QsLazid/zTAJYBU8bEnu0S3GpJCClX7OfBrY45XPrARrzgHDVGJOX8S
	EA7+x2UkU1LNo5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648DF43E48;
	Tue, 24 Mar 2026 12:51:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 60WAGMaIwmkoAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:51:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 26FB3A0B32; Tue, 24 Mar 2026 13:51:18 +0100 (CET)
Date: Tue, 24 Mar 2026 13:51:18 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 20/41] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <flb3si2jxjg4gy7beqxr3zt3tvq74msftee5ewmwgpd77vqj5r@h5rqgjuws3zr>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-61-jack@suse.cz>
 <acIkOmat4Y_M2SUC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIkOmat4Y_M2SUC@infradead.org>
X-Spam-Score: -2.30
X-Spam-Level: 
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCPT_COUNT_TWELVE(0.00)[17];
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
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,mit.edu,gmail.com,suse.com,mail.parknet.co.jp,linux.dev,suse.de,kvack.org];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Mon 23-03-26 22:42:18, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:15PM +0100, Jan Kara wrote:
> > There are only a few filesystems that use generic tracking of inode
> > metadata buffer heads. As such it is mostly pointless to verify such
> > attached buffer heads during inode reclaim. Drop the handling from
> > inode_lru_isolate().
> 
> But the code isn't just verifying (which to me implies debug code),
> but doing actual work to remove the buffers.  This does look like a
> behavior change to me, buf it is not due to previous patches or
> because it was dead code, it would help greatly to explain that here.

Right, I've rewritten the changelog to explain things better:

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such the logic to reclaim tracked metadata 
buffer heads in inode_lru_isolate() doesn't bring a benefit big enough 
to justify intertwining of inode reclaim and metadata buffer head
tracking. Just treat tracked metadata buffer heads as any other metadata
filesystem has to properly clean up on inode eviction and stop handling
it in inode_lru_isolate(). As a result filesystems using generic
tracking of metadata buffer heads may now see dirty metadata buffers in
their .evict methods more often which can slow down inode reclaim but
given these filesystems aren't used in performance demanding setups we
should be fine.

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
