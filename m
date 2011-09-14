From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/37] e2fsprogs: Read and write full-sized inodes
Date: Wed, 14 Sep 2011 12:39:01 -0400
Message-ID: <20110914163901.GE3429@dhcp-172-31-195-159.cam.corp.google.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
 <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com>
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
Received: from li9-11.members.linode.com ([67.18.176.11]:47290 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995Ab1INQjN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Sep 2011 12:39:13 -0400
Content-Disposition: inline
In-Reply-To: <20110901003517.1176.46651.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 31, 2011 at 05:35:17PM -0700, Darrick J. Wong wrote:
> As part of adding inode checksums, it is necessary for all e2fsprogs to read
> and write full inodes so that checksums may be calculated correctly.  Since
> struct ext2_inode_large is a superset of struct ext2_inode, replace the smaller
> one with the larger one.

OK, so I need to explain how the large inode support was designed.

The original assumption behind it was that most of the time, most user
progams outside of programs shipped natively with e2fsprogs (which are
special) don't actually need to access large inodes directly.  They
are much more likely to use ext2fs_file_{open,read}().  To the extent
that they need to access inodes at all, they will tend to do so
read-only to fetch the size or modtime or user/group ownership fields.

And when we write an inode, we need to do a read/modify/write cycle
with the inode table block anyway.  So the idea was to provide full
ABI compatibility with the struct ext4_inode structure, and the
functions that read and write them.  So ext4_inode is a fixed size,
128 byte structure, and functions that currently take ext4_inode must
only read or write the first 128 bytes.

This also implies that probably the better place to put the checksum
calculation code is in ext4_write_inode()/ext4_write_inode_large()
functions.  If we need a new function ext4_write_inode_raw() which has
the same function signature as ext4_write_inode_large(), but which
skips the checksum calculation, so be it.

Similarly, if we put the checksum verfication in
ext4_read_inode{_large}(), with a new error code if the checksum is
incorrect, all existing callers will get checksum verification for
free.

Now, about how ext4_{read,write}_inode_full().  This function is designed so
that struct ext4_inode_large can grow in newer versions of the
library.  To that end, the callers must call it as follows:

	  struct ext2_inode_large inode;

	  retval = ext2fs_read_inode_full(fs, ino, &inode, sizeof(inode));

If they happen to compile on a system where struct ext2_inode_large is
140 bytes, then they will pass in a bufsize of 140 bytes --- and it is
up to struct ext2fs_read_inode_full() to only pass back 140 bytes, and
for struct ext2fs_write_inode_full() to only read 140 bytes from the
passed-in pointer.  You can think of the bufsize parameter as being a
built-in versioning mechanism.

It is for a similar reason that gethostbyname() takes a socklen_t
parameter.  That way it doesn't have to worry about stack smashing an
legacy ipv4-only program.

So you can't just blanket replace struct ext2_inode with struct
ext2_inode_large, and have ext2fs_read_inode() blindly copy out
however many bytes happen to be in sizeof(struct ext2_inode_large)
today.  That way lies all sorts of wierd and hard-to-debug versioning
skew problems....

Does this make sense?

					- Ted

P.S.  The ext4 wiki is down right now, due to the kernel.org security
recovery efforts, but when it's back up, someone please remind me to
get this text up on the wiki.  :-)
