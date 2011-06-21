From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/8] remove i_alloc_sem
Date: Wed, 22 Jun 2011 01:54:25 +0200
Message-ID: <20110621235425.GA24067@quack.suse.cz>
References: <20110620201533.847236272@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@zeniv.linux.org.uk, tglx@linutronix.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, hirofumi@mail.parknet.co.jp,
	mfasheh@suse.com, jlbec@evilplan.org, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484Ab1FUXy2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jun 2011 19:54:28 -0400
Content-Disposition: inline
In-Reply-To: <20110620201533.847236272@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 20-06-11 16:15:33, Christoph Hellwig wrote:
> i_alloc_sem has always been a bit of an odd "lock".  It's the only remaining
> rw_semaphore that can be released by a different thread than the one that
> locked it, and it's use case in the core direct I/O code is more like a
> counter given that the writers already have external serialization.
> 
> This series removes it in favour of a simpler counter scheme, thus getting
> rid of the rw_semaphore non-owner APIs as requests by Thomas, while at the
> same time shrinking the size of struct inode by 160 bytes on 64-bit systems.
> 
> The only nasty bit is that two filesystems (fat and ext4) have started
> abusing the lock for their own purposes.  I've added a new rw_semaphore
  ext4 abuse should be gone when Ted merges my rewrite of
ext4_page_mkwrite()... Ted, what happened to that patch. Should I resend
it?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
