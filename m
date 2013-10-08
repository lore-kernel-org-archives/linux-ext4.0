From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 14/31] libext2fs: Fix ext2fs_open2() truncation of the
 superblock parameter
Date: Tue, 8 Oct 2013 11:58:59 -0400
Message-ID: <20131008155859.GG17896@thunk.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012812.28415.49840.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43692 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab3JHP7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Oct 2013 11:59:22 -0400
Content-Disposition: inline
In-Reply-To: <20131001012812.28415.49840.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 30, 2013 at 06:28:12PM -0700, Darrick J. Wong wrote:
> Since it's possible for very large filesystems to store backup superblocks at
> very large (> 2^32) block numbers, we need to be able to handle the case of a
> caller directing us to read one of these high-numbered backups.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Hmm... This is technically true, but I'm wondering how much we should
care.  In practice, users almost always use the first couple of backup
superblocks.  I could imagine a situation with a RAID array where the
first disk(s) were trashed, so we needed to use a backup superblock
beyond 2**32, but it's a bit unlikely.

If there was some other reason why we needed to add a new ext2fs_open3
variant, it would certainly be a good thing to fix.  But I'm wondering
if it's worth adding a new interface just for this.

Is there perhaps any other extensions to ext2fs_open() that we might
want to make, either now or in the future?

Regards,

						- Ted
