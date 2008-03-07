From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4
	migrate.
Date: Fri, 07 Mar 2008 16:47:51 -0700
Message-ID: <20080307234751.GL1881@webber.adilger.int>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204888653.3627.37.camel@localhost.localdomain>
 <20080307113106.GA9896@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:32874 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYCGXsD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Mar 2008 18:48:03 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m27Nm1GT023472
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 15:48:01 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JXD00A01WOAVT00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 07 Mar 2008 15:48:01 -0800 (PST)
In-reply-to: <20080307113106.GA9896@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 07, 2008  17:01 +0530, Aneesh Kumar K.V wrote:
> On Fri, Mar 07, 2008 at 03:17:33AM -0800, Mingming Cao wrote:
> > How about we start a journal with estimated worse case transaction
> > credits  and then take the i_data_sem down? So that we could ensure that
> > whenever the i_data_sem is hold, the i_data is protected. That is what
> > currently DIO does, I think. It would be nice to avoid introducing
> > another semaphore to protect i_data for migration if we could.
> 
> Estimating transaction for a single page directIO write may be easy. But
> in case of migrate it involves new blocks allocated to carry the extents
> and also we free the indirect blocks of ext3 and that would involve
> update of bitmap from different groups. I am not sure we will be able to
> come up with a value. But if yes and if we can get that many credits
> from journal i agree that would be better than introducing a new
> semaphore.

Agreed - and if we have a generic routine to calculate the journal
credits needed for a full-file (or better a range) indirect block
operation (including bitmaps, group descriptors, and [dt]indirect
blocks).

I don't think there would be a serious failure case if it wasn't possible
to convert a block-mapped file to extent-mapped while it was mmapped.
At worst the administrator would need to do that some time later, or
after a system reboot, so long as the conversion actually failed if the
file had any mmaps.  If this same requirement is introduced when we
get defrag for ext4 (because the block mapping is changing on the file)
then we may have to reconsider the benefits of the more complex code.


Note we can also use the "journal credits needed" for fixing truncate in
a similar manner to do it all in a single transaction to avoid zeroing
all of the indirect blocks.  All that would be needed for trunate is to
call the above function, update the on-disk i_size, possibly zero out the
partially-truncated block, and update the group descriptors and bitmaps.
That would also allow "undelete" to work on ext3 again because the
inode i_blocks and indirect blocks wouldn't be zeroed out anymore,
like it was in ext2.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

