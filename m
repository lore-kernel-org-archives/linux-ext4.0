From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 09/49] libext2fs: don't fail when doing a strict rewrite
 of inline data
Date: Fri, 14 Mar 2014 09:19:14 -0400
Message-ID: <20140314131914.GD8282@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065456.30585.47345.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41324 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaCNNTW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 14 Mar 2014 09:19:22 -0400
Content-Disposition: inline
In-Reply-To: <20140311065456.30585.47345.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 10, 2014 at 11:54:56PM -0700, Darrick J. Wong wrote:
> ext2fs_inline_data_set() tries to ensure that there is sufficient free
> space in the inode to store the inline data.  Unfortunately, it gets
> the check wrong -- ext2fs_xattr_inode_max_size() returns the amount of
> unused bytes in the EA area, and _data_set() doesn't factor in the
> size of the existing inline data.  Therefore, a strict rewrite of an
> N-byte inlinedata with another N-byte inlinedata fails.
> 
> Fix the code to do the size check correctly.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
