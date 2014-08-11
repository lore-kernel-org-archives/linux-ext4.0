From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] e2fsck: flush out the superblock and bitmaps before
 printing final messages
Date: Mon, 11 Aug 2014 13:27:39 -0400
Message-ID: <20140811172739.GD6553@thunk.org>
References: <1407706424-22108-1-git-send-email-tytso@mit.edu>
 <20140811170935.GC2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dan Jacobson <jidanni@jidanni.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54847 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaHKR1m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Aug 2014 13:27:42 -0400
Content-Disposition: inline
In-Reply-To: <20140811170935.GC2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 10:09:35AM -0700, Darrick J. Wong wrote:
> 
> Looking at the strace output, it looks like a bunch of pwrite/write calls are
> returning -EBADF when it tries to write the group descriptors to a O_RDONLY
> file descriptor.
> 
> The call to ext2fs_flush() needs to be guarded by a "if (fs->flags &
> EXT2_FLAG_DIRTY)" because ext2fs_flush() unconditionally writes out the group
> descriptors.  We don't want to do that unless the FS is actually dirty, and we
> certainly don't want to do that for a RO check.

Oops, I had forgotten that we didn't have such a check inside
ext2fs_flush().

Thanks for catching this!

					- Ted
