Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7B03E1D15
	for <linux-ext4@vger.kernel.org>; Wed,  5 Aug 2026 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785920469; cv=none; b=Sk+EvoqfM0whyXI4f19KHtEvHc8OmhfPCYa+giwSObVPZ0mvGdJwbQCkqZre7ptCaRf1eEWWPYq7KxyvpXMf/rGJi+J3LdvQ4s4JPWhxntoQ7JKtOfXLZcamwgT4o5ZkzCX4jUcDAa3jIJoobBZsX5OJsLFJEUQnn0H1SJqudGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785920469; c=relaxed/simple;
	bh=R1FaZhD/ZF1hQZIfO4YQWJBsvSPxBHcdoa72jVYIBjs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ISGOnmqCT5NbIP3aKv1bmLs4zQZv5NQBrr7IiJAlQBYnDW4p7syge9GIAxmAfUeI+ET47HMNegFmBYJn28PDQS/RpwEB/W5MrVG9hMDGCNBx1uATgHlBhobxhOgb8YKNwaLZc4X5SkHPRsfa3ZtWB+YsVQ4Mj9aSuXWdHeVXBfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QSieqJbf; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kl4m23+O; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=cmZFu2S7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=SkzNL8fW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QSieqJbf";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kl4m23+O";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="cmZFu2S7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="SkzNL8fW"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F0DF40E4;
	Wed,  5 Aug 2026 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785920461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xx9xLz7w13YPVZy59Ta84uPlKd/2a07mTIeuXyXpHWg=;
	b=QSieqJbfSqaNZw8oBtMZ3wwjnwjifxT1kLwCXB+O0uV+tJddzOQ6CZWj9WEQ0DyOTOyv54
	BgNydoi8riU0sBca7qxtPoBmcWDZUj+HRKkBk1lYGRWLUJc12weLdkzSSEPO26zmasuYxp
	kEM4bd0ZKBX+93XDdLVywhDQVZ8lVnM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785920461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xx9xLz7w13YPVZy59Ta84uPlKd/2a07mTIeuXyXpHWg=;
	b=kl4m23+O7asyM4zhrbK+xIa9cfkq4BiYKMBZzFRi1sIWNbSHDgJ44ehcD3cUjFkqwoN62o
	GKyWzdYcqa5EzZDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785920457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xx9xLz7w13YPVZy59Ta84uPlKd/2a07mTIeuXyXpHWg=;
	b=cmZFu2S7uuH3sQuZ2OwFoY3qiSPicXEh9GFkZQMIOXH48LLzFYFcYafGHE4Mj3K4Z3yAer
	fyInytm7n/Yln1w/5fB66/g9F4XAij1MVsVBDAR2aiNbQk/Obky7VeCwgSzOiG1x3MEddf
	s9mOujHgP/otS+ldDDJhM3UDMMOTA8c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785920457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xx9xLz7w13YPVZy59Ta84uPlKd/2a07mTIeuXyXpHWg=;
	b=SkzNL8fWXYNyLXPdrvSC0olAofL++bI1mNGWXsWCzFVSbukN55N7R1VEKjQcUdecsCqse5
	I54iV4bAkcMlw1CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 83B49779B6;
	Wed,  5 Aug 2026 09:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2MIiIMn7cmqBGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 09:00:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 25C6EA13A7; Wed, 05 Aug 2026 11:00:57 +0200 (CEST)
Date: Wed, 5 Aug 2026 11:00:57 +0200
From: Jan Kara <jack@suse.cz>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Chao Shi <coshi036@gmail.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <willy@infradead.org>, 
	Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
	Bob Copeland <me@bobcopeland.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	linux-ext4@vger.kernel.org, ocfs2-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-karma-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] buffer: stop clearing BH_Uptodate when a write
 fails
Message-ID: <t5vasainmrq7zlo2ptmjn5qfyiy26l4vvuqfkoldtx3naf5tir@4v6bktopybsk>
References: <cover.1785621505.git.coshi036@gmail.com>
 <3aa278c3b75de2bca8a94ec0c0e40922b1170881.1785621505.git.coshi036@gmail.com>
 <ff2f92ab-6c98-42f2-be0b-0c807bc9438e@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff2f92ab-6c98-42f2-be0b-0c807bc9438e@huaweicloud.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	ARC_NA(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,suse.cz,vger.kernel.org,kernel.org,zeniv.linux.org.uk,infradead.org,mit.edu,dilger.ca,linux.alibaba.com,linux.ibm.com,huawei.com,bobcopeland.com,samsung.com,sony.com,mail.parknet.co.jp,fasheh.com,evilplan.org,redhat.com,lists.linux.dev,lists.sourceforge.net];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLhn4jw3wthgom179184pqozfe)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Wed 05-08-26 12:52:11, Zhang Yi wrote:
> On 8/2/2026 6:01 AM, Chao Shi wrote:
> > A buffer whose write failed still holds exactly the data the filesystem
> > asked to be written.  It is the disk that is out of date, not the buffer.
> > Clearing BH_Uptodate says the opposite, and callers act on it:
> > 
> >  - mark_buffer_dirty() has a WARN_ON_ONCE(!buffer_uptodate(bh)).  A
> >    filesystem that dirties the buffer again after a failed write - which is
> >    the normal way to retry - trips it.  That is the warning this series
> >    started from.
> > 
> >  - a buffer that is not up to date gets re-read from disk, which replaces
> >    the data the filesystem was trying to write with the stale on-disk copy,
> >    silently.
> > 
> >  - the window between the write completing and the buffer being marked not
> >    up to date is visible to anyone holding the folio lock, so the state is
> >    not even self consistent while it lasts.
> > 
> > BH_Write_EIO already records the failure, and by now every place in the
> > tree that needs to know about it tests that flag instead: the two core
> > helpers in this file, adfs, exfat, ext2, ext4, fat, gfs2, jbd2, ocfs2 and
> > omfs, converted one filesystem at a time in the preceding patches.  The
> > private completion handlers in jbd2 and ext4 fast commit were converted
> > along with their waiters.  Nothing is left that reads BH_Uptodate to find
> > out whether a write failed, so the clears can go.
> > 
> > Found by FuzzNvme.
> > 
> > Signed-off-by: Chao Shi <coshi036@gmail.com>
> 
> It looks like after this series, we may need to revisit the necessity of
> ext4_buffer_uptodate() in the ext4 filesystem. IIRC, it was originally
> introduced as a compromise to address this issue. Now that we no longer
> clear the buffer uptodate flag after a failed IO write, this flag will
> still remain valid when getting/reading bh. Therefore, the necessity of
> ext4_buffer_uptodate() is worth reconsidering.

Deninitely :) There are several hacks in ext4 (and other filesystems as
well) that could be removed after this patch set. But let's settle on the
generic changes first.

								Honza

> > ---
> >  fs/buffer.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index ac978d9090c2..0002f0736398 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -207,7 +207,6 @@ void bh_end_write(struct bio *bio)
> >  	} else {
> >  		buffer_io_error(bh, ", lost sync page write");
> >  		mark_buffer_write_io_error(bh);
> > -		clear_buffer_uptodate(bh);
> >  	}
> >  	unlock_buffer(bh);
> >  }
> > @@ -441,7 +440,6 @@ void bh_end_async_write(struct bio *bio)
> >  	} else {
> >  		buffer_io_error(bh, ", lost async page write");
> >  		mark_buffer_write_io_error(bh);
> > -		clear_buffer_uptodate(bh);
> >  	}
> >  
> >  	first = folio_buffers(folio);
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
