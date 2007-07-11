From: Theodore Tso <tytso@mit.edu>
Subject: Re: Initial results of FLEX_BG feature.
Date: Wed, 11 Jul 2007 18:14:25 -0400
Message-ID: <20070711221425.GH19456@thunk.org>
References: <20070710112307.34c2ba5c@rx8> <20070711041213.GH6417@schatzie.adilger.int> <20070711003004.531c9307@naruto>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:60398 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761750AbXGKWO2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2007 18:14:28 -0400
Content-Disposition: inline
In-Reply-To: <20070711003004.531c9307@naruto>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 11, 2007 at 12:30:04AM -0500, Jose R. Santos wrote:
> Right now what I've done is allocate the bitmaps and inode tables at the
> beginning of each group of 64 BG.  Still need to work on fsck since just
> removing the restriction on were the bitmaps and inode table are
> located still gives me errors of uninitialized inodes with dtime set.
> Seems like fsck still expect inode information to be located at
> specific locations within the disk.

Can you send me the patch which you were playing with?  I might be
able to help you with this.  It should be pretty straightforward to
remove the constraint on the inode table location.  

It really should only be a check in e2fsck/super.c:check_super_block(),
as far as I know.

If you're seeing errors of unitialized inodes with dtime set, that
sounds like maybe something else is going on.  All of e2fsprogs should
be referencing the inode table via fs->group_desc[group_num].bg_inode_table.  
See lib/ext2fs/inode.c, functions ext2fs_open_inode_scan(), 
get_next_blockgroup(), and ext2fs_read_inode_full().

							- Ted
