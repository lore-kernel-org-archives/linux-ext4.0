From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 55/74] libext2fs: support modifying arbitrary extended
 attributes
Date: Sun, 23 Feb 2014 23:09:51 -0500
Message-ID: <20140224040951.GC23946@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012426.30655.26259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33256 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaBXEJz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 23 Feb 2014 23:09:55 -0500
Content-Disposition: inline
In-Reply-To: <20131211012426.30655.26259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:24:26PM -0800, Darrick J. Wong wrote:
> Add functions to allow clients to get, set, and remove extended
> attributes from any file.  It also supports modifying EAs living in
> i_file_acl.
> 
> v2: Put the header declarations in the correct part of ext2fs.h,
> provide a function to release an EA block from an inode, and check
> i_extra_isize to make sure we actually have space for in-inode EAs.
> 
> v3: Add system.richacl prefix support, and only allow the new
> ext2fs_xattr_* functions to run if we have either ext_attr or
> inline_data set.  Fix some memory leaks and stack disclosure problems,
> and an accounting problem when freeing an EA block.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
