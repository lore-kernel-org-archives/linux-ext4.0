From: Theodore Tso <tytso@mit.edu>
Subject: Re: [RFC][take 4] e2fsprogs: Add ext4migrate
Date: Mon, 7 May 2007 09:20:01 -0400
Message-ID: <20070507132001.GB17180@thunk.org>
References: <11782700042368-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20070506051759.GP6220@schatzie.adilger.int> <463E9C53.8000503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45970 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933781AbXEGNUL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 09:20:11 -0400
Content-Disposition: inline
In-Reply-To: <463E9C53.8000503@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 07, 2007 at 08:56:11AM +0530, Aneesh Kumar K.V wrote:
> Andreas Dilger wrote:
> >If this code could also (or optionally just) increase the size of inodes
> >it would be very useful.  AFAIK right now it will only change the inodes
> >from block-mapped to extent-mapped?

Actually, changing the inode size is actually going to be more useful
to a larger number of people, since they can use it today to support
in-inode EA's.  In addition, changing the inode size must be done
off-line, whereas it's not so clear that off-line conversion to
extents is the best way to go (more on that below).

One generic concern I have about simply migrating existing files to
use extents is that unless we actually also combine the tool with
defragmentation support, the file ends up being fairly badly
fragmented simply because of the "holes" left in the file from the
indirect blocks.  Therefore the tree ends up being far larger than it
needs to be, and future attempts allocate blocks in that block group
will fill in the holes, further degrading the performance of the
filesystem and whatever file is being written at the time.

The other reason why increasing the inode size would actually be more
valuable is that right now, if we have the disk space, the user can do
on-line migration of a file simply by copying it and then moving it
over the original file --- and if we have delayed allocation support
and sufficient memory, we can avoid the fragmentation problems
currently with the off-line ext4migration approach.

So we may need to think a bit about what's the best way to handle
ext4migrate.  It may be that correct approach is to combine it with a
defragmentation tool, either on-line or off-line.  

> That is correct. My next step is to enhance the tool to support 
> migration to large inodes.

I would actually suggest that the place to add that functionality
would be via "tune2fs -I <inode_size>".  Since mke2fs -I <inode_size>
is used to set the inode size, it makes sense that tune2fs -I would
change the inode size.  Obviously this would have to be done when the
filesystem is not mounted, and tune2fs should abort gracefully if
determines that the filesystem is mounted.

						- Ted
