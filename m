From: Andreas Dilger <adilger@sun.com>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Tue, 10 Mar 2009 18:38:45 -0600
Message-ID: <20090311003845.GB3199@webber.adilger.int>
References: <1236642197.30280.18.camel@kulgan.wumi.org.au>
 <49B5D71D.1030802@redhat.com> <1236655451.30280.29.camel@kulgan.wumi.org.au>
 <49B5EDFE.8060405@redhat.com> <1236661371.30280.33.camel@kulgan.wumi.org.au>
 <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu>
 <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Kevin Shanahan <kmshanah@ucwb.org.au>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40386 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZCKAjE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Mar 2009 20:39:04 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n2B0cw1A004512
	for <linux-ext4@vger.kernel.org>; Tue, 10 Mar 2009 17:38:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KGB00M00GDI4300@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 10 Mar 2009 17:38:58 -0700 (PDT)
In-reply-to: <20090310224810.GA15229@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 10, 2009  18:48 -0400, Theodore Ts'o wrote:
> On Wed, Mar 11, 2009 at 07:44:51AM +1030, Kevin Shanahan wrote:
> > Thanks Ted. Just so I know what I'm doing if/when this comes up again, I
> > guess the process would be:
> > 
> >   - debugfs /dev/some-filesystem
> >   - debugfs:  stat "some/problem/file"
> >   - get the inode number from the output above (867 in this case)
> >   - debugfs dump 867 inode867.bin
> 
> Actually, it's a bit more complicated than that.  I should really add
> a hook to debugfs to automate this, but... to find the block to grab,
> you do this.   

[many complex steps deleted]

> So now we know that the block containing inode 867 is 65+54 = 119

Or you can use imap (which Ted probably wrote in the first place. :-)

debugfs: imap some/problem/file
Inode 867 is part of block group 0
	located at block 119, offset 0x0180

> Now to dump that block, we do:
> 
>     dd if=/dev/fs-device of=block-119.dump bs=4k skip=119 count=1

This part is the same.

> > Or perhaps running e2fsck -n first to see which inodes really look
> > corrupted and get the numbers that way. 
> 
> Yep.  In general, when you get corruption like this, the bad inodes
> comes in chunks of 16 (if you are using 256 byte inodes) or 32 (if you
> are using 128 byte inodes).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

