From: Andreas Dilger <adilger@sun.com>
Subject: Re: BUG with delayed allocation
Date: Fri, 21 Mar 2008 07:55:12 +0800
Message-ID: <20080320235512.GY2971@webber.adilger.int>
References: <20080319085235.GA6752@skywalker>
 <1205974018.3637.9.camel@localhost.localdomain>
 <20080320053902.GD6967@skywalker>
 <1206034190.3637.25.camel@localhost.localdomain>
 <20080320175625.GA6931@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, Eric Sandeen <sandeen@redhat.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54995 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbYCTXzW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Mar 2008 19:55:22 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2KNtHAK022395
	for <linux-ext4@vger.kernel.org>; Thu, 20 Mar 2008 16:55:18 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JY100A01ZRNT600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 20 Mar 2008 16:55:17 -0700 (PDT)
In-reply-to: <20080320175625.GA6931@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 20, 2008  23:26 +0530, Aneesh Kumar K.V wrote:
> On Thu, Mar 20, 2008 at 10:29:50AM -0700, Mingming Cao wrote:
> > On Thu, 2008-03-20 at 11:09 +0530, Aneesh Kumar K.V wrote:
> > > > Could you try the following patch? It updates the i_disksize at the
> > > > write_end time.
> > > 
> > > I will test the patch and update you. BTW shouldn't we update
> > > i_disksize only after actual block got allocated ?
> >
> > Hmm...I am not  100% sure but I think we should not to change the
> > behavior that the on-disk inode size should be updated when write()
> > returns to user. Right now the in-memory inode size is updated, user
> > would expecting the same when they run e2fsck, but e2fsck reads inode
> > size from disk. Pushing the inode i_disksize update at the writeout
> > (allocation) time will cause the window that i_size is different than
> > the i_disksize being enlarged quite big.
> 
> If we are updating i_disksize during write_end and if we crash before actually
> allocating the blocks e2fsck will find errors because the inode doesn't
> really have that many blocks right ?

No, it would just think the file is sparse and return \0 for the reads.

That said, I don't agree with Mingming - the i_disksize should only be
increased at the time the blocks are allocated on disk and not when the
file is extended in memory.  Even if the window where i_size is different
than i_disksize is large, this is only important after a crash, and at
that time ordered mode users want the file to have a shorter i_disksize
and the file contains only valid data, instead of the extended i_size
but the file contains \0 bytes at the end.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

