From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: block groups with no inode tables
Date: Tue, 10 Jul 2007 22:50:29 -0600
Message-ID: <20070711045029.GK6417@schatzie.adilger.int>
References: <20070710121221.5478a1e3@rx8> <1184088605.17636.1.camel@colyt43.site> <1184089232.13379.6.camel@kleikamp.austin.ibm.com> <1184083189.3759.15.camel@localhost.localdomain> <1184094545.13379.20.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, coly li <colyli@gmail.com>,
	"Jose R. Santos" <jrs@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:33445 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXGKEub (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jul 2007 00:50:31 -0400
Content-Disposition: inline
In-Reply-To: <1184094545.13379.20.camel@kleikamp.austin.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jul 10, 2007  14:09 -0500, Dave Kleikamp wrote:
> Assuming you mean the parent directory?  An inode isn't tied to a
> specific parent.
> 
> 	ln dir1/file1 dir2/
> 	mv dir1/file1 dir3/
> 	rmdir dir1
> 
> What is happens to the inode?

The inode stays in the same place, and the block map of the directories
are changed to enclose the inode.  In ideal (== normal) circumstances,
inodes are allocated within a directory in a sequential manner, and this
would also result in linear inode block allocation, great for extent-mapped
files.  In cases like the above, you will have fragmented IO patterns,
but those are already true for existing directories.

> I really don't think that the directory is the right place to store an inode.

There are actually some performance benefits from this, see
http://citeseer.ist.psu.edu/ganger97embedded.html

Each inode would be a disk block, or possibly a few (slightly larger than
now) inodes per block, on the order of 1kB or more.  This allows for
packing small files into the inode also (as an EA) or alternately having
many extents in the inode for huge files or lots of inline EAs.

I've also got a plan to overcome the hard-link limitations in that paper,
by storing the filename of an inode as an EA in the inode, prefixed by
the inode number & generation of the parent.  When doing a readdir or
lookup, we know the parent directory in which we are looking, so we can
only consider names in that directory.  When doing a readdir, we can
immediately list all of the names for this inode together.  The caveat
is that we need a flexible EA scheme to handle this, maybe a directory
with more EAs in it?

The one thing that I'm not sure about is how to handle the case where
inode blocks are allocated in relatively random order.  I'd _like_ to
be able to avoid the POSIX telldir/seekdir problem by doing readdir()
in block order, but that also means that if we allocate an inode block
between two other existing inode blocks in a directory that we should
"insert" the block into the directory instead of e.g. appending it.
That means the file offset in a directory is not constant, but maybe it
is OK to return the physical block number for telldir?

We would still have a hash for the files, but instead of per block
as it is now, it would need to have leaf entries for each name, since
an inode can have many names and would appear in multiple hash buckets.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
