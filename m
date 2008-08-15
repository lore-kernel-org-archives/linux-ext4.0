From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix small file fragmentation
Date: Fri, 15 Aug 2008 23:37:45 +0530
Message-ID: <20080815180745.GE6511@skywalker>
References: <1218735880-10915-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080814231816.GA13048@mit.edu> <20080815175243.GD6511@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:33355 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYHOSHy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Aug 2008 14:07:54 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7FI727Z007875
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:07:02 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FI7qub303904
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:07:52 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FI7p0W003597
	for <linux-ext4@vger.kernel.org>; Sat, 16 Aug 2008 04:07:52 +1000
Content-Disposition: inline
In-Reply-To: <20080815175243.GD6511@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 15, 2008 at 11:22:43PM +0530, Aneesh Kumar K.V wrote:
> On Thu, Aug 14, 2008 at 07:18:17PM -0400, Theodore Tso wrote:
> > On Thu, Aug 14, 2008 at 11:14:40PM +0530, Aneesh Kumar K.V wrote:
> > > mballoc small file block allocation use per cpu prealloc
> > > space. Use goal block when searching for the right prealloc
> > > space. Also make sure ext4_da_writepages tries to write
> > > all the pages for small files in single attempt
> > 
> > Hi Aneesh, how are you testing your patch?  I've created the following
> > shell script:
> > 
> > -------------------------------
> > #!/bin/sh
> > #
> > # small-files-frag-test --- test for small files fragmentation
> > 
> > DEVICE=/dev/thunk/testbench
> > 
> > mke2fs -t ext4dev $DEVICE
> > mount -t ext4dev $DEVICE /mnt
> > tar -C /usr -cf - bin lib | tar -C /mnt -xpf - 
> > sync; sleep 5
> > umount $DEVICE
> > e2fsck -nfv -E fragcheck $DEVICE
> > -------------------------------
> > 
> > ... and the results show roughly the same amount of fragmentation, and the
> > same pattern.  In fact, it's a ltitle worse (30% vs 25%).
> > 
> >    37912 inodes used (11.57%)
> >    11468 non-contiguous inodes (30.2%)
> >          # of inodes with ind/dind/tind blocks: 0/0/0
> >          Extent depth histogram: 32638/5
> >   711894 blocks used (54.31%)
> > 
> 
> 
> I have better results with the below patch on top of the patch i sent.
> 
>    21156 inodes used (0.47%)
>      158 non-contiguous inodes (0.7%)
>          # of inodes with ind/dind/tind blocks: 4/4/4
>   581216 blocks used (3.24%)
>        0 bad blocks
>        1 large file
> 

And the fragmented inodes are all directories for which we don't
use prealloc space

debugfs:  ncheck 12
Inode   Pathname
12      /bin
debugfs:  ncheck 1987
Inode   Pathname
1987    /lib
debugfs:  ncheck 7657
Inode   Pathname
7657    /lib/python2.5
debugfs:  ncheck 11602
Inode   Pathname
11602   /lib/X11/xserver
debugfs:  ncheck 14279
Inode   Pathname
14279   /lib/locale
debugfs:  ncheck 20615
Inode   Pathname
20615   /lib/ooo-2.0/program
debugfs:

-aneesh
