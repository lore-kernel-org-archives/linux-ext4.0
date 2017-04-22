From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] e2fsck: update quota when optimizing the extent tree
Date: Sat, 22 Apr 2017 17:48:02 -0400
Message-ID: <20170422214802.z4qekigaoaucwffl@thunk.org>
References: <20170415134118.17808-1-tytso@mit.edu>
 <20170416191739.GA5185@birch.djwong.org>
 <20170421073743.btwz6274h4ou3bze@thunk.org>
 <20170421162711.GA3972@birch.djwong.org>
 <20170421200600.zvgjbblbrftvlfb4@thunk.org>
 <C0EE07FD-40C0-4074-83CE-32F6A092A265@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37452 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1427146AbdDVVsW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 22 Apr 2017 17:48:22 -0400
Content-Disposition: inline
In-Reply-To: <C0EE07FD-40C0-4074-83CE-32F6A092A265@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 21, 2017 at 03:15:07PM -0600, Andreas Dilger wrote:
> 
> Should this quota_data_sub() call be after ext2fs_iblk_sub_blocks() has
> completed successfully, or are the blocks already freed at this point
> and only the inode->i_blocks counter would be outdated?

The blocks are already freed at this point.

> In theory this could go at the start before any changes are made to the
> inode, and then there wouldn't be the need for the intermediate call to
> quota_data_sub() above?  That avoids a small amount of overhead, and
> also avoids the more complicated issue of the quota file being modified
> even if this operation hits an error and is skipped (i.e. any "goto err"
> case).

We're actually not modifying the quota file at this point; we're just
modifying the in-memory "correct" quota data numbers.

Also, if we fail in the middle, given that the extent tree blocks have
been freed and potentially partially reused, the fact that the quota
file has been modified is the least of our problems.  In theory we
could save the list of old extent tree index blocks, and try to use
new blocks for the new extent tree index blocks as much as possible.
But that's not true today.

    	   				- Ted
				
