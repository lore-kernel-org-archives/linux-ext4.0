From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/35] e2fsck: track directories to be rehashed with a
 bitmap
Date: Mon, 20 Apr 2015 21:43:45 -0700
Message-ID: <20150421044345.GF11592@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
 <20150402023433.25243.88338.stgit@birch.djwong.org>
 <20150421022645.GC3238@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20405 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbDUEnw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Apr 2015 00:43:52 -0400
Content-Disposition: inline
In-Reply-To: <20150421022645.GC3238@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 20, 2015 at 10:26:45PM -0400, Theodore Ts'o wrote:
> On Wed, Apr 01, 2015 at 07:34:33PM -0700, Darrick J. Wong wrote:
> > Use a bitmap to track which directories we want to rehash, since
> > bitmaps will use less memory.  This enables us to clean up the
> > rehash-all case to use inode_dir_map, and we can free the dirinfo
> > memory sooner.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Um, how is it that bitmaps will use less memory?  Directories
> generally don't use contiguous inode numbers (i.e., it's not that
> often that inodes N-1. N, and N+1 will all be directoriess), and and
> the rbtree data structure is going to have more pointer overhead
> compared with the u32 list.
> 
> In the case of the bitarray representation, the memory usage is
> nr_inodes / 8 in bytes.  The memory usage of the u32 list is (nr_dirs
> * 4) bytes.  Given that the number of inodes is generally something
> that we've massively provisioned, that's not all that likely.
> 
> Looking at some files systems I have handy, it's no contest:
> 
> Filesystem	nr_inodes / 8                nr_dirs * 4
> /dev/sda3	1,176,576                    382,424
> /dev/heap/u1	  655,360		      63,384
> 
> 
> Using inode_dir_map for the rehash-all case is a good idea, but I'm
> not sure it follows that we should ues a bitmap for the non-rehash-all
> case.

Eh, you're right, let's drop this one.  Honestly it's been so long I don't
remember my motivation for writing this up in the first place.  Thanks for
pulling in the e2fsck readahead pieces, though!

--D

> 
> 					- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
