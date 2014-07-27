From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 11/18] libext2/fsck: correctly preserve fs flags when
 modifying ignore-csum-error flag
Date: Sun, 27 Jul 2014 19:27:46 -0400
Message-ID: <20140727232746.GZ6725@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003447.28334.51963.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:59583 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbaG0X1x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 27 Jul 2014 19:27:53 -0400
Content-Disposition: inline
In-Reply-To: <20140726003447.28334.51963.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 25, 2014 at 05:34:47PM -0700, Darrick J. Wong wrote:
> nor is it correct
> to assume that we can unconditionally set (or clear) the "ignore csum
> error" flag bit.

For functions inside e2fsck, why is this true?  All of the places
where we are are EXT2_FLAG_IGNORE_CSUM_ERRORS are places where we set
it, and then clear it after an ext2 call.  So as near as I can tell it
shouldn't matter.

I can understand why we need to be careful for functions inside
libext2fs, but in that particular case, none of the downstream
functions of ext2fs_read_inode_full() modify fs->flags.

So I'm really puzzled what problem this patch actually solves.  Was
this a theoretical concern, or was there something I missed?

       		   	       	   	 - Ted
