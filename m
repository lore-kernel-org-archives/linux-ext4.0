From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 05/35] e2fsck: track directories to be rehashed with a
 bitmap
Date: Mon, 20 Apr 2015 22:26:45 -0400
Message-ID: <20150421022645.GC3238@thunk.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023433.25243.88338.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49162 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbbDUC0s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 22:26:48 -0400
Content-Disposition: inline
In-Reply-To: <20150402023433.25243.88338.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 01, 2015 at 07:34:33PM -0700, Darrick J. Wong wrote:
> Use a bitmap to track which directories we want to rehash, since
> bitmaps will use less memory.  This enables us to clean up the
> rehash-all case to use inode_dir_map, and we can free the dirinfo
> memory sooner.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Um, how is it that bitmaps will use less memory?  Directories
generally don't use contiguous inode numbers (i.e., it's not that
often that inodes N-1. N, and N+1 will all be directoriess), and and
the rbtree data structure is going to have more pointer overhead
compared with the u32 list.

In the case of the bitarray representation, the memory usage is
nr_inodes / 8 in bytes.  The memory usage of the u32 list is (nr_dirs
* 4) bytes.  Given that the number of inodes is generally something
that we've massively provisioned, that's not all that likely.

Looking at some files systems I have handy, it's no contest:

Filesystem	nr_inodes / 8                nr_dirs * 4
/dev/sda3	1,176,576                    382,424
/dev/heap/u1	  655,360		      63,384


Using inode_dir_map for the rehash-all case is a good idea, but I'm
not sure it follows that we should ues a bitmap for the non-rehash-all
case.

					- Ted
