From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
 callback
Date: Tue, 25 Aug 2009 17:49:08 -0700
Message-ID: <1251247748.3930.23.camel@mingming-laptop>
References: <1250092470.18329.27.camel@mingming-laptop>
	 <20090819141557.GA4705@atrey.karlin.mff.cuni.cz>
	 <1250717176.3924.116.camel@mingming-laptop>
	 <20090820115212.GA16486@duck.novell.com>
	 <1251149893.4280.69.camel@mingming-laptop>
	 <20090825140113.GG405@duck.novell.com>
	 <1251229270.3930.17.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39677 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbZHZAtI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Aug 2009 20:49:08 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n7Q0lAHq005356
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 18:47:10 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n7Q0nALq174798
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 18:49:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n7Q0n9W9010520
	for <linux-ext4@vger.kernel.org>; Tue, 25 Aug 2009 18:49:10 -0600
In-Reply-To: <1251229270.3930.17.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2009-08-25 at 12:41 -0700, Mingming wrote:
> On Tue, 2009-08-25 at 16:01 +0200, Jan Kara wrote:
> > On Mon 24-08-09 14:38:13, Mingming wrote:
> > > On Thu, 2009-08-20 at 13:52 +0200, Jan Kara wrote:
> > > > On Wed 19-08-09 14:26:16, Mingming wrote:
> > > > > On Wed, 2009-08-19 at 16:15 +0200, Jan Kara wrote:
> > > > > > > For direct IO write to the end of file, we now also could get rid of
> > > > > > > using orphan list to protect expose stale data out after crash, when
> > > > > > > direct write to end of file isn't complete. We now fallocate blocks for
> > > > > > > the direct IO write to the end of file as well, and convert those
> > > > > > > fallocated blocks at the end of file to written when IO is complete. If
> > > > > > > fs crashed before the IO complete, it will only seen the file tail has
> > > > > > > been fallocated but won't get the stale data out.
> > > > > >   But you still probably need orphan list to truncate blocks allocated
> > > > > > beyond file end during extending direct write. So I'd just remove this
> > > > > > paragraph...
> > > > > > 
> > > > > 
> > > > > Do we still need to truncate blocks allocated at the end of file? Those
> > > > > blocks are marked as uninitialized extents (as any block allocation from
> > > > > DIO are flagged as uninitialized extents, before IO is complete), so
> > > > > that after recover from crash, the stale data won't get exposed. 
> > > > > 
> > > > > I guess I missed the cases you concerned that we need the orphan list to
> > > > > protect, could you plain a little more?
> > > >   Well, you are right it's not a security problem since no data gets
> > > > exposed. It's just that after a crash, there will be blocks allocated to
> > > > a file and it's not trivial to it find out unless you specifically stat the
> > > > file. So it's just *not nice* kind of thing. If it brings us some
> > > > advantage to not put the inode on the orphan list, then sure it might be
> > > > a tradeoff we are willing to make. But otherwise I see no point.
> > > > 
> > > 
> > > Hmm... I see what you concerned now...user probably don't like allocated
> > > blocks at the end...
> >   Yes, it's kind of counterintuitive that blocks can get allocated but
> > don't really "show up" in the file (because they are unwritten and beyond
> > i_size).
> > 
> > > I am trying to think of the ext3 case. In ext3 case, inode will be
> > > removed from orphan list once the IO is complete, but that is before the
> > > i_disksize get updated and journal handle being closed. What if the
> > > system crash after inode removed from orphan list but before the
> > > i_disksize get updated?
> >   As you write below, until we stop the handle, the transaction cannot be
> > committed and so no change actually gets written to disk.
> > 
> 
> Then in case this, if no change actually gets written to disk, then
> i_disksize hasn't get updated on disk, why we need the orphan list?
> 

Never mind, I missed the fact that i_size was updated in ext3_direct_IO
before submit the IO, so orphan list is there to truncate i_size to
i_disksize in case of crash.

> > > But since the journal handled has not marked as stopped, even without
> > > putting the inode on the orpah list, wouldn't the open journal handle
> > > and delayed i_disksize update until IO complete time, prevent we see
> > > half DIO data on disk? Though blocks are allocated to the file, but
> > > those block mapping wouldn't show up on disk, no? Did I miss anything?
> > > 
> > > In the ext4 +patch case (non AIO case), we also close the handle when
> > > end_io completed. If the system crashed we would see the blocks are
> > > allocated but marked as unwritten.
> >   Exactly, you end up with allocated and unwritten blocks beyond i_size and
> > that's what I'd like to avoid if user did not explicitely fallocate() these
> > blocks.
> > 
> 
> Yes but same as ext3, nothing should write to disk until we stop the
> handle, so the unwritten blocks flag should also been seen as the
> i_disksize has not been updated on disk yet.
> 

Please ignore this, I see what you are saying..

I think it over today, I understand the race is with AIO DIO io has not
completed, while there are truncate or other non AIO DIO which happened
completed before the pending AIO DIO completed. What we do with
i_disksize?

Maybe I just split the patches, only deals with holes and preallocation,
with doesn't need to update i_disksize... and worry about fixing DIO
write to the end of file for AIO later.

Mingming

