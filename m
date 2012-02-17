From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] libext2fs: Add ext2fs_file_get_inode_num call (for
 fuse2fs)
Date: Fri, 17 Feb 2012 10:01:10 -0500
Message-ID: <20120217150110.GD19606@thunk.org>
References: <20120107085523.4325.42183.stgit@elm3c44.beaverton.ibm.com>
 <20120107085529.4325.17894.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:34033 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab2BQPBQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Feb 2012 10:01:16 -0500
Content-Disposition: inline
In-Reply-To: <20120107085529.4325.17894.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jan 07, 2012 at 12:55:29AM -0800, Darrick J. Wong wrote:
> Add a function to return the inode number of an open file.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Thanks, applied.

					- Ted
