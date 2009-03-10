From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 10:46:51 -0400
Message-ID: <20090310144651.GC23075@mit.edu>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au> <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au> <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au> <20090310070915.GN3199@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45941 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbZCJOrE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Mar 2009 10:47:04 -0400
Content-Disposition: inline
In-Reply-To: <20090310070915.GN3199@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 10, 2009 at 01:09:15AM -0600, Andreas Dilger wrote:
> > > >>> kernel: init_special_inode: bogus i_mode (53253)
> 
> If anyone has a chance, fixing this error message to be not-useless would
> be good...  Including the device name and the inode number would help
> track down the source of the problem.

Agreed!

> > hermes:~# debugfs /dev/dm-0 
> > debugfs 1.41.3 (12-Oct-2008)
> > debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll"
> > 
> > Gives the following output:
> > 
> >   Inode: 867   Type: bad type    Mode:  0404   Flags: 0x802a61af
> >   Generation: 2483046020    Version: 0xb9286359:17a7fdfd
> >   User: 1455931783   Group: -798021131   Size: -1808719531
> >   File ACL: 141934744    Directory ACL: 0
> >   Links: 15681   Blockcount: 171984001880781
> >   Fragment:  Address: 956780679    Number: 0    Size: 0
> >    ctime: 0xdca60244:006c5b08 -- Wed Apr 23 01:54:36 2087
> >    atime: 0x5c9e956c:777587a4 -- Sat Mar 30 08:30:12 2019
> >    mtime: 0x2ce44e11:286138f8 -- Sat Nov 13 13:31:37 1993
> >   crtime: 0x737781cb:5661f351 -- Thu May 22 19:54:11 2031
> >   dtime: 0xf19c4882 -- Sat Jun 14 11:57:14 2098
> >   Size of extra inode fields: 3625
> >   BLOCKS:

This looks like a block written to the wrong place on disk.  One of
the things that can be done is to dump out the disk block
corresponding to inode #867 before the fsck, and see if we can
recognize what the source of the block was.  I don't see any ASCII in
any of the files (i.e., 0xdca60244, 0x5c9e956c, etc. don't appear to
be ascii), but it might be that we could determine what the block that
got written into the inode table originally came from.

As Andreas said, this e2fsck will this, but it won't explain how a
block in the inode table got corrupted in the first place.  It could
be a random hardware hiccup; it could be a corruption on disk or in
memory that lead the Linux kernel to write the block in the wrong
place, etc.  The problem is that it could be a filesystem or kernel
bug, but it could also just as easily be a hardware one-time failure.

Failures like this have been reported on ext3 filesystems as well, but
it's rare, and it's been written off to hardware failure, although it
could be really anything --- from the device driver, block layer, a
filesystem problem, or hardware hiccup.

Given that you've fixed it, all I think we can tell you is to keep an
eye out for any further failures....  

						- Ted
