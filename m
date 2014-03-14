From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 12/49] libext2fs: during inlinedata expand, don't corrupt
 inode
Date: Fri, 14 Mar 2014 09:29:02 -0400
Message-ID: <20140314132902.GG8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065515.30585.24716.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41341 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaCNN3H (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:29:07 -0400
Content-Disposition: inline
In-Reply-To: <20140311065515.30585.24716.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:55:15PM -0700, Darrick J. Wong wrote:
> When expanding an inline data inode, it's possible that the reduction
> in the size of the EA structures causes the freeing of the EA block,
> which changes the inode.  If this happens, the local version of the
> inode that ext2fs_inline_data_expand was modifying will be out of sync
> with what's on the disk.  This local copy gets written out to disk
> after a block allocation, at which point it's possible that the inode
> EA block and logical block zero point to the same physical block,
> which is bad news.
> 
> Therefore, write the local copy to disk before removing the inline
> data EA, and reread it afterwards.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
