From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Date: Thu, 20 Aug 2009 14:15:31 +0200
Message-ID: <20090820121531.GC16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-8-git-send-email-jack@suse.cz> <20090819162638.GE6150@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
	Evgeniy Polyakov <zbr@ioremap.net>, ocfs2-devel@oss.oracle.com,
	Joel Becker <joel.becker@oracle.com>,
	Felix Blyakher <felixb@sgi.com>, xfs@oss.sgi.com,
	Anton Altaparmakov <aia21@cantab.net>,
	linux-ntfs-dev@lists.sourceforge.net,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZHTMPb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Aug 2009 08:15:31 -0400
Content-Disposition: inline
In-Reply-To: <20090819162638.GE6150@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 19-08-09 12:26:38, Christoph Hellwig wrote:
> Looks good to me.  Eventually we should use those SYNC_ flags also all
> through the fsync codepath, but I'll see if I can incorporate that in my
> planned fsync rewrite.
  Yes, I thought I'll leave that for later. BTW it should be fairly easy to
teach generic_sync_file() to do fdatawait() before calling ->fsync() if the
filesystem sets some flag in inode->i_mapping (or somewhere else) as is
needed for XFS, btrfs, etc.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
