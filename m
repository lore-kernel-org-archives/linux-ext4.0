From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/54] libext2fs: Read and write full size inodes
Date: Fri, 9 Mar 2012 18:36:31 -0500
Message-ID: <20120309233631.GE5635@thunk.org>
References: <20120306235720.11945.30629.stgit@elm3b70.beaverton.ibm.com>
 <20120306235727.11945.11066.stgit@elm3b70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55871 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab2CIXgl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 9 Mar 2012 18:36:41 -0500
Content-Disposition: inline
In-Reply-To: <20120306235727.11945.11066.stgit@elm3b70.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 06, 2012 at 03:57:27PM -0800, Darrick J. Wong wrote:
> Change libext2fs to read and write full-size inodes in preparation for the
> metadata checksumming patchset, which will require this.  Due to ABI
> compatibility requirements, this change must be hidden from client programs.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

After applying this first patch, the e2fsprogs regression test suite
blew up spectacularly caused by the malloc-managed free lists pointers
getting corrupted:

*** glibc detected *** /usr/projects/e2fsprogs/e2fsprogs/build/debugfs/debugfs: free(): invalid next size (fast): 0x000000000063f9d0 ***
======= Backtrace: =========
/lib/libc.so.6(+0x77806)[0x7ffff6e4a806]
/lib/libc.so.6(cfree+0x73)[0x7ffff6e510d3]
/usr/projects/e2fsprogs/e2fsprogs/build/lib/libext2fs.so.2(ext2fs_free_mem+0x30)[0x7ffff7bb562f]


Interestingly, valgrind was *not* useful in finding the problem;
apparently it was getting confused by the ext2fs_get_mem()
abstraction, which is unfortunate.  I'll have to look into that at
some point.

Anyway, the problem was in ext2fs_write_inode_full(), and it could be
replicated by simply writing to an inode, i.e.

   mke2fs  -F -O resize_inode -o Linux -b 1024 /tmp/image  16384
   debugfs -w -R "set_inode_field <7> mtime now" /tmp/image

is enough to trigger it.  The problem is with a 128 byte ext2 file
system, ext2fs_write_inode_full() is passed a large inode and so
bufsize is 156, but EXT2_INODE_SIZE(fs->super) is 128.  So at
lib/ext2fs/inode.c:698:

	memcpy(w_inode, inode, bufsize);

you end up writing 156 bytes into a memory buffer that was allocated
to a size of 128 bytes.  Hilarity ensues.

The fix is relatively simple:

	memcpy(w_inode, inode, (bufsize > length) ? length : bufsize);

Anyway, this is *why* running the regression tests are important.
(And why projects which don't have regression test suites are just
asking for trouble.)

They catch all sorts of interesting oversights like this....

     	       	     		    	       - Ted
