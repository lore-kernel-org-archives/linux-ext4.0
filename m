From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] quota: Fix deadlock during path resolution
Date: Thu, 16 Sep 2010 00:52:08 +0200
Message-ID: <20100915225208.GA1490@lst.de>
References: <1284586791-8245-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>, "Ted Ts'o" <tytso@mit.edu>,
	Joel Becker <joel.becker@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35526 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0IOWwQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 18:52:16 -0400
Content-Disposition: inline
In-Reply-To: <1284586791-8245-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 15, 2010 at 11:39:51PM +0200, Jan Kara wrote:
> As Al Viro pointed out path resolution during Q_QUOTAON calls to quotactl
> is prone to deadlocks. We hold s_umount semaphore for reading during the
> path resolution and resolution itself may need to acquire the semaphore
> for writing when e. g. autofs mountpoint is passed.
> 
> Solve the problem by performing the resolution before we get hold of the
> superblock (and thus s_umount semaphore). The whole thing is complicated
> by the fact that some filesystems (OCFS2) ignore the path argument. So to
> distinguish between filesystem which want the path and which do not we
> introduce new .quota_on_meta callback which does not get the path. OCFS2
> then uses this callback instead of old .quota_on.

FYI I have a patch that switches ocfs to share the quota_on method with
XFS which behaves the same, and consolidate the quota_off method for all
filesystems.  I think that's better than adding yet another method.

I'll rebase it and send it out soon.

