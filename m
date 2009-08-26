From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2 V2] Direct IO for holes and fallocate: add end_io
	callback
Date: Wed, 26 Aug 2009 15:39:32 +0200
Message-ID: <20090826133932.GA14534@duck.novell.com>
References: <1250092470.18329.27.camel@mingming-laptop> <20090819141557.GA4705@atrey.karlin.mff.cuni.cz> <1250717176.3924.116.camel@mingming-laptop> <20090820115212.GA16486@duck.novell.com> <1251149893.4280.69.camel@mingming-laptop> <20090825140113.GG405@duck.novell.com> <1251229270.3930.17.camel@mingming-laptop> <1251247748.3930.23.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Theodore Tso <tytso@mit.edu>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:32955 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757286AbZHZNje (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Aug 2009 09:39:34 -0400
Content-Disposition: inline
In-Reply-To: <1251247748.3930.23.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 25-08-09 17:49:08, Mingming wrote:
> On Tue, 2009-08-25 at 12:41 -0700, Mingming wrote:
> > On Tue, 2009-08-25 at 16:01 +0200, Jan Kara wrote:
> > > On Mon 24-08-09 14:38:13, Mingming wrote:
> > > > On Thu, 2009-08-20 at 13:52 +0200, Jan Kara wrote:
> > > > > On Wed 19-08-09 14:26:16, Mingming wrote:
> > > > > > On Wed, 2009-08-19 at 16:15 +0200, Jan Kara wrote:
> > > > > > > > For direct IO write to the end of file, we now also could get rid of
> > > > > > > > using orphan list to protect expose stale data out after crash, when
> > > > > > > > direct write to end of file isn't complete. We now fallocate blocks for
> > > > > > > > the direct IO write to the end of file as well, and convert those
> > > > > > > > fallocated blocks at the end of file to written when IO is complete. If
> > > > > > > > fs crashed before the IO complete, it will only seen the file tail has
> > > > > > > > been fallocated but won't get the stale data out.
> > > > > > >   But you still probably need orphan list to truncate blocks allocated
> > > > > > > beyond file end during extending direct write. So I'd just remove this
> > > > > > > paragraph...
> > > > > > > 
> > > > > > 
> > > > > > Do we still need to truncate blocks allocated at the end of file? Those
> > > > > > blocks are marked as uninitialized extents (as any block allocation from
> > > > > > DIO are flagged as uninitialized extents, before IO is complete), so
> > > > > > that after recover from crash, the stale data won't get exposed. 
> > > > > > 
> > > > > > I guess I missed the cases you concerned that we need the orphan list to
> > > > > > protect, could you plain a little more?
> > > > >   Well, you are right it's not a security problem since no data gets
> > > > > exposed. It's just that after a crash, there will be blocks allocated to
> > > > > a file and it's not trivial to it find out unless you specifically stat the
> > > > > file. So it's just *not nice* kind of thing. If it brings us some
> > > > > advantage to not put the inode on the orphan list, then sure it might be
> > > > > a tradeoff we are willing to make. But otherwise I see no point.
> > > > > 
> > > > 
> > > > Hmm... I see what you concerned now...user probably don't like allocated
> > > > blocks at the end...
> > >   Yes, it's kind of counterintuitive that blocks can get allocated but
> > > don't really "show up" in the file (because they are unwritten and beyond
> > > i_size).
> > > 
> > > > I am trying to think of the ext3 case. In ext3 case, inode will be
> > > > removed from orphan list once the IO is complete, but that is before the
> > > > i_disksize get updated and journal handle being closed. What if the
> > > > system crash after inode removed from orphan list but before the
> > > > i_disksize get updated?
> > >   As you write below, until we stop the handle, the transaction cannot be
> > > committed and so no change actually gets written to disk.
> > > 
> > 
> > Then in case this, if no change actually gets written to disk, then
> > i_disksize hasn't get updated on disk, why we need the orphan list?
> > 
> 
> Never mind, I missed the fact that i_size was updated in ext3_direct_IO
> before submit the IO, so orphan list is there to truncate i_size to
> i_disksize in case of crash.
  I think we still don't understand ourselves. We don't care to much about
i_size being updated because we never write it to disk. We write only
i_disksize and that gets updated in the end. The problem is:
  create(f)
  direct_write(f, buf, 65536)
    -> allocates 32 KB beyond EOF and then crash happens

  If 'f' was not on the orphan list you'd see:
ls -l
  -rw-r--r--  1 jack users      0 2008-06-26 11:01 f
  but the file has actually those 32 KB allocated and user has no way of
knowing about that.
  Because 'f' *is* on orphan list, we free those 32 KB beyond EOF and
everything is happy.
  That's the whole point I was trying to make.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
