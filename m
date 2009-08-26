From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Date: Wed, 26 Aug 2009 14:22:36 -0400
Message-ID: <20090826182236.GA1290@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz> <20090819162638.GE6150@infradead.org> <20090820121531.GC16486@duck.novell.com> <20090820162729.GA24659@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
	Joel Becker <joel.becker@oracle.com>,
	Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
	Anton Altaparmakov <aia21@cantab.net>,
	linux-ntfs-dev@lists.sourceforge.net,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZHZSWh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 14:22:37 -0400
Content-Disposition: inline
In-Reply-To: <20090820162729.GA24659@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 20, 2009 at 12:27:29PM -0400, Christoph Hellwig wrote:
> Maybe you can help brain storming, but I still can't see any way in that
> the
> 
>   - write data
>   - write inode
>   - wait for data
> 
> actually is a benefit in terms of semantics (I agree that it could be
> faster in theory, but even that is debatable with todays seek latencies
> in disks)

Btw, another reason why our current default is actively harmful:

	barriers

With volatile write caches we do have to flush the disk write cache in
->fsync, either implicitly by a metadata operation, or explicitly if
only data changed.  Unless the filesystems waits itself for the data
to hit the disk like XFS or btrfs will be issue the cache flush
potentially before the data write has actually reached the disk cache.
