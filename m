From: Kevin Shanahan <kmshanah@ucwb.org.au>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Wed, 11 Mar 2009 07:44:51 +1030
Message-ID: <1236719691.16191.9.camel@kulgan.wumi.org.au>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
	 <49B5D71D.1030802@redhat.com>
	 <1236655451.30280.29.camel@kulgan.wumi.org.au>
	 <49B5EDFE.8060405@redhat.com>
	 <1236661371.30280.33.camel@kulgan.wumi.org.au>
	 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bowden.ucwb.org.au ([203.122.237.119]:55402 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZCJVOz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 17:14:55 -0400
In-Reply-To: <20090310144651.GC23075@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-03-10 at 10:46 -0400, Theodore Tso wrote:
> > > hermes:~# debugfs /dev/dm-0 
> > > debugfs 1.41.3 (12-Oct-2008)
> > > debugfs:  stat "local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32sv.dll"
> > > 
> > > Gives the following output:
> > > 
> > >   Inode: 867   Type: bad type    Mode:  0404   Flags: 0x802a61af
> > >   Generation: 2483046020    Version: 0xb9286359:17a7fdfd
> > >   User: 1455931783   Group: -798021131   Size: -1808719531
> > >   File ACL: 141934744    Directory ACL: 0
> > >   Links: 15681   Blockcount: 171984001880781
> > >   Fragment:  Address: 956780679    Number: 0    Size: 0
> > >    ctime: 0xdca60244:006c5b08 -- Wed Apr 23 01:54:36 2087
> > >    atime: 0x5c9e956c:777587a4 -- Sat Mar 30 08:30:12 2019
> > >    mtime: 0x2ce44e11:286138f8 -- Sat Nov 13 13:31:37 1993
> > >   crtime: 0x737781cb:5661f351 -- Thu May 22 19:54:11 2031
> > >   dtime: 0xf19c4882 -- Sat Jun 14 11:57:14 2098
> > >   Size of extra inode fields: 3625
> > >   BLOCKS:
> 
> This looks like a block written to the wrong place on disk.  One of
> the things that can be done is to dump out the disk block
> corresponding to inode #867 before the fsck, and see if we can
> recognize what the source of the block was.

Thanks Ted. Just so I know what I'm doing if/when this comes up again, I
guess the process would be:

  - debugfs /dev/some-filesystem
  - debugfs:  stat "some/problem/file"
  - get the inode number from the output above (867 in this case)
  - debugfs dump 867 inode867.bin

Or perhaps running e2fsck -n first to see which inodes really look
corrupted and get the numbers that way. 

> Failures like this have been reported on ext3 filesystems as well, but
> it's rare, and it's been written off to hardware failure, although it
> could be really anything --- from the device driver, block layer, a
> filesystem problem, or hardware hiccup.
> 
> Given that you've fixed it, all I think we can tell you is to keep an
> eye out for any further failures....

Thanks, will do.

Cheers,
Kevin.


