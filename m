From: Jan Kara <jack@suse.cz>
Subject: Re: Online defragmentation and ext4migrate
Date: Tue, 22 May 2007 13:28:31 +0200
Message-ID: <20070522112831.GC27428@atrey.karlin.mff.cuni.cz>
References: <464DA4ED.9040408@linux.vnet.ibm.com> <019c01c79b92$627b3280$4168010a@bsd.tnes.nec.co.jp> <20070521103828.GB29416@atrey.karlin.mff.cuni.cz> <1179754611.389.10.camel@eric-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Eric <erpo41@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34691 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbXEVL2c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 May 2007 07:28:32 -0400
Content-Disposition: inline
In-Reply-To: <1179754611.389.10.camel@eric-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Mon, 2007-05-21 at 12:38 +0200, Jan Kara wrote:
> >   Yes. On the other hand I believe that some people would like to use
> > defragmentation but stay with ext3. For them conversion to extents is
> > no-go.
> > [...]
> >  I've written a patch that defragments non-extent files but after
> > discussion with XFS guys I've decided that the interfaces should be made
> > more generic, so that XFS and other filesystems can use them too...
> I see no reason why the ioctl to convert a file to extents and then
> defragment it should be different from the ioctl to defragment a
> non-extent file.
>
> After all, whether a file's blocks are tracked as lists of blocks or a
> set of extents is just bookkeeping, right? The set of data blocks that
> make up the file and their order is the same regardless of whether the
> extent flag is set in the inode.
  I agree that at least part of the interface should
be independent on the particular representation of data references -
especially because I want it to be useful for more filesystems than just
ext2/3/4. Currently I think that defragmenting data blocks itself can
have fs-independent interface. Of course, when you decide to defragment
metadata (i.e. indirect blocks, inodes, etc.) you have to have fs-specific
interfaces, probably ioctls...

> If the user is running the ext2/3 driver or the ext4 driver with the
> noextents option, just defragment the file. If the user is running ext4
> without the noextents option, convert to extents and then defragment.
  Defragmentation ioctl definitely should not touch the way the file is
represented. I.e. if the file uses indirect blocks it should use
indirect blocks after defragmentation. If it uses extents, it should use
extents afterwards too. It should be the userspace utility which decides
whether the file should be converted or not and uses appropriate call
for that...

> The only problem that I can think of is that defragmenting metadata
> (including indirect block and/or whatever the equivalent is in
> extent-land) presumably has performance benefits too, so maybe a
> defragmenter in userspace would want to have some knowledge/control over
> this process.
  Yes, it has measurable benefit (especially for indirect blocks) so
eventually we should do it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
