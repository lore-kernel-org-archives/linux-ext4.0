From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] ext4: Fix the locking with respect to ext3 to ext4 migrate.
Date: Tue, 11 Mar 2008 16:25:37 +0100
Message-ID: <20080311152537.GE6544@atrey.karlin.mff.cuni.cz>
References: <1204887184-9902-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1204888653.3627.37.camel@localhost.localdomain> <20080307113106.GA9896@skywalker> <20080307234751.GL1881@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, tytso@mit.edu,
	sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57822 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYCKPZi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2008 11:25:38 -0400
Content-Disposition: inline
In-Reply-To: <20080307234751.GL1881@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Mar 07, 2008  17:01 +0530, Aneesh Kumar K.V wrote:
> > On Fri, Mar 07, 2008 at 03:17:33AM -0800, Mingming Cao wrote:
> > > How about we start a journal with estimated worse case transaction
> > > credits  and then take the i_data_sem down? So that we could ensure that
> > > whenever the i_data_sem is hold, the i_data is protected. That is what
> > > currently DIO does, I think. It would be nice to avoid introducing
> > > another semaphore to protect i_data for migration if we could.
> > 
> > Estimating transaction for a single page directIO write may be easy. But
> > in case of migrate it involves new blocks allocated to carry the extents
> > and also we free the indirect blocks of ext3 and that would involve
> > update of bitmap from different groups. I am not sure we will be able to
> > come up with a value. But if yes and if we can get that many credits
> > from journal i agree that would be better than introducing a new
> > semaphore.
> 
> Agreed - and if we have a generic routine to calculate the journal
> credits needed for a full-file (or better a range) indirect block
> operation (including bitmaps, group descriptors, and [dt]indirect
> blocks).
> 
> I don't think there would be a serious failure case if it wasn't possible
> to convert a block-mapped file to extent-mapped while it was mmapped.
> At worst the administrator would need to do that some time later, or
> after a system reboot, so long as the conversion actually failed if the
> file had any mmaps.  If this same requirement is introduced when we
> get defrag for ext4 (because the block mapping is changing on the file)
> then we may have to reconsider the benefits of the more complex code.
  I agree here. IMHO the better option would be to just build the
extent-tree for converted inode on best-effort basis. If we find in
the end that someone has allocated new block to the file (via mmap
filling a hole) while we are converting, we can just cancel the
conversion. Because I think the cost of extra rwsem (both in terms of
additional memory needed for each inode structure and in time needed for
rwsem acquisitions) is more than I as a user would like to bear given
how rare the conversion is.

> Note we can also use the "journal credits needed" for fixing truncate in
> a similar manner to do it all in a single transaction to avoid zeroing
> all of the indirect blocks.  All that would be needed for trunate is to
> call the above function, update the on-disk i_size, possibly zero out the
> partially-truncated block, and update the group descriptors and bitmaps.
> That would also allow "undelete" to work on ext3 again because the
> inode i_blocks and indirect blocks wouldn't be zeroed out anymore,
> like it was in ext2.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
