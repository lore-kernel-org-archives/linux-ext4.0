From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Thu, 15 Sep 2011 13:25:00 -0700
Message-ID: <20110915202500.GD12086@tux1.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com> <20110914163901.GE3429@dhcp-172-31-195-159.cam.corp.google.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50686 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934736Ab1IOUZH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 16:25:07 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8FKAZkK015983
	for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 16:10:36 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p8FKP4Lp3223662
	for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 16:25:04 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p8FKP243027041
	for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 16:25:03 -0400
Content-Disposition: inline
In-Reply-To: <20110914163901.GE3429@dhcp-172-31-195-159.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 14, 2011 at 12:39:01PM -0400, Ted Ts'o wrote:
> On Wed, Aug 31, 2011 at 05:35:17PM -0700, Darrick J. Wong wrote:
> > As part of adding inode checksums, it is necessary for all e2fsprogs to read
> > and write full inodes so that checksums may be calculated correctly.  Since
> > struct ext2_inode_large is a superset of struct ext2_inode, replace the smaller
> > one with the larger one.
> 
> OK, so I need to explain how the large inode support was designed.
> 
> The original assumption behind it was that most of the time, most user
> progams outside of programs shipped natively with e2fsprogs (which are
> special) don't actually need to access large inodes directly.  They
> are much more likely to use ext2fs_file_{open,read}().  To the extent
> that they need to access inodes at all, they will tend to do so
> read-only to fetch the size or modtime or user/group ownership fields.
> 
> And when we write an inode, we need to do a read/modify/write cycle
> with the inode table block anyway.  So the idea was to provide full
> ABI compatibility with the struct ext4_inode structure, and the
> functions that read and write them.  So ext4_inode is a fixed size,
> 128 byte structure, and functions that currently take ext4_inode must
> only read or write the first 128 bytes.
> 
> This also implies that probably the better place to put the checksum
> calculation code is in ext4_write_inode()/ext4_write_inode_large()
> functions.  If we need a new function ext4_write_inode_raw() which has
> the same function signature as ext4_write_inode_large(), but which
> skips the checksum calculation, so be it.

Okay, so here's my new game plan ... internally, libext2fs needs to read/write
whatever sb->inode_size is.  However, to avoid ABI breakage, it will use an
internal buffer (stack variable, memory block, whatever) for the IO operation
and the checksum operations.  As for whatever buffer+size the caller passes in,
it will memcpy this (potentially smaller) amount so that external programs that
still use the 128-byte structure won't get corrupted.  The other tools within
e2fsprogs can of course allocate the largest inode size they care about
(ext2_inode_large) if they so choose.

So I think this means that I can rip out both superpatches.  The inode read and
scan functions will need to allocate a buffer that is whatever size the
superblock says inodes are so that it can read, and checksum the inode.  After
that, the functions will copy however many bytes the caller tells us to copy
into the caller's buffer.  The write function will allocate a buffer that is
whatever size the superblock says inodes are, read that size off the disk, copy
however many bytes the caller gave us into this temporary buffer, then
calculate the checksum and write the buffer out to disk.  e2fsprogs that care
about extended inode fields can be modified to use ext2_inode_large, and
everything else can keep using ext2_inode.  This also keeps it so that client
programs don't have to know or care how big inodes really are.

Sorry I wasn't aware that there are non-e2fsprogs users of libext2fs.

--D

> Similarly, if we put the checksum verfication in
> ext4_read_inode{_large}(), with a new error code if the checksum is
> incorrect, all existing callers will get checksum verification for
> free.
> 
> Now, about how ext4_{read,write}_inode_full().  This function is designed so
> that struct ext4_inode_large can grow in newer versions of the
> library.  To that end, the callers must call it as follows:
> 
> 	  struct ext2_inode_large inode;
> 
> 	  retval = ext2fs_read_inode_full(fs, ino, &inode, sizeof(inode));
> 
> If they happen to compile on a system where struct ext2_inode_large is
> 140 bytes, then they will pass in a bufsize of 140 bytes --- and it is
> up to struct ext2fs_read_inode_full() to only pass back 140 bytes, and
> for struct ext2fs_write_inode_full() to only read 140 bytes from the
> passed-in pointer.  You can think of the bufsize parameter as being a
> built-in versioning mechanism.
> 
> It is for a similar reason that gethostbyname() takes a socklen_t
> parameter.  That way it doesn't have to worry about stack smashing an
> legacy ipv4-only program.
> 
> So you can't just blanket replace struct ext2_inode with struct
> ext2_inode_large, and have ext2fs_read_inode() blindly copy out
> however many bytes happen to be in sizeof(struct ext2_inode_large)
> today.  That way lies all sorts of wierd and hard-to-debug versioning
> skew problems....
> 
> Does this make sense?
> 
> 					- Ted
> 
> P.S.  The ext4 wiki is down right now, due to the kernel.org security
> recovery efforts, but when it's back up, someone please remind me to
> get this text up on the wiki.  :-)
> 
