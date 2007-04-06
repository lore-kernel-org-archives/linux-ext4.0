From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libext2fs memory leak in ext2fs_write_new_inode()
Date: Fri, 6 Apr 2007 08:53:27 -0400
Message-ID: <20070406125327.GD29189@thunk.org>
References: <Pine.LNX.4.61.0704041717470.1374@webb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jim Garlick <garlick@llnl.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34979 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767592AbXDFMx3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2007 08:53:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704041717470.1374@webb>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 04, 2007 at 05:21:05PM -0700, Jim Garlick wrote:
> The following patch addresses a memory leak in libext2fs
> that occurs when using ext2fs_write_new_inode() on a file system
> configured with large inodes.
> 
> Signed-off-by: Jim Garlick <garlick@llnl.gov>

Thanks for this patch!  I've committed into the e2fsprogs hg source
code repository, and it will be in the next release of e2fsprogs.

						- Ted
