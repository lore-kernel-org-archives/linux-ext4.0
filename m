From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 23 Nov 2010 13:58:24 -0500
Message-ID: <1290538347-sup-7669@think>
References: <20101123100239.GA4232@amd> <1290515274-sup-3895@think> <20101123125223.GA4946@amd>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Nick Piggin <npiggin@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29843 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab0KWS73 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Nov 2010 13:59:29 -0500
In-reply-to: <20101123125223.GA4946@amd>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Excerpts from Nick Piggin's message of 2010-11-23 07:52:23 -0500:
> On Tue, Nov 23, 2010 at 07:34:07AM -0500, Chris Mason wrote:
> > Excerpts from Nick Piggin's message of 2010-11-23 05:02:39 -0500:
> > 
> > [ ... ]
> > 
> > > 
> > > Avoid both these issues by issuing completely asynchronous writeback request in
> > > writeback_inodes_sb_if_idle. Don't let that fool you into thinking these
> > > functions don't suck any more.
> > > 
> > > ext4 now passes extensive stress testing with xfstests, fs_mark, dbench,
> > > with a writeback_inodes_if_idle call added directly into ext4_da_write_begin
> > > to trigger the path frequently. Previously it would spew lockdep stuff and
> > > hang in a number of ways very quickly.
> > > 
> > > Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > > 
> > > ---
> > >  fs/fs-writeback.c |   32 ++++++++++++++++++++------------
> > >  1 file changed, 20 insertions(+), 12 deletions(-)
> > > 
> > > Index: linux-2.6/fs/fs-writeback.c
> > > ===================================================================
> > > --- linux-2.6.orig/fs/fs-writeback.c    2010-11-23 20:57:23.000000000 +1100
> > > +++ linux-2.6/fs/fs-writeback.c    2010-11-23 20:59:10.000000000 +1100
> > > @@ -1152,16 +1152,17 @@ EXPORT_SYMBOL(writeback_inodes_sb);
> > >   *
> > >   * Invoke writeback_inodes_sb if no writeback is currently underway.
> > >   * Returns 1 if writeback was started, 0 if not.
> > > + *
> > > + * Even if 1 is returned, writeback may not be started if memory allocation
> > > + * fails. This function makes no guarantees about anything.
> > >   */
> > >  int writeback_inodes_sb_if_idle(struct super_block *sb)
> > >  {
> > >      if (!writeback_in_progress(sb->s_bdi)) {
> > > -        down_read(&sb->s_umount);
> > > -        writeback_inodes_sb(sb);
> > > -        up_read(&sb->s_umount);
> > > +        bdi_start_writeback(sb->s_bdi, get_nr_dirty_pages());
> > 
> > I'll put on my skis and channel Christoph for a minute.  This isn't
> > quite the same as the original.  writeback_inodes_sb() writes inodes on a
> > specific super block, while bdi_start_writeback() writes them for any SB
> > on that bdi.
> 
> Right.
> 
> > For btrfs there's only one bdi per SB, but for most everyone else a disk
> > with a bunch of partitions is going to have multiple filesystems on the
> > same bdi.
> > 
> > My original btrfs patch just exported the bdi_ funcs so that btrfs could
> > do the above internally.  But Christoph objected, and I think he's
> > right.  We should either give everyone a bdi or make sure the writeback
> > func kicks only one filesystem.
> 
> Well it's just kicking the writeback thread, and it will writeback
> from that particular sb.

Hmmm?  It will writeback for all the SBs on that bdi.  In the current
form that ext4 uses, that gets pretty expensive if you have a bunch of
large partitions and you're only running out of space on one of them.

For the _nr variant that btrfs uses, it's worse for the filesystems
that don't have a 1:1 bdi<->sb mapping.  It might not actually write any
of the pages from the SB that is out of space.

> It makes no further guarantees, and anyway
> the sb has to compete for normal writeback within this bdi.

> 
> I think Christoph is right because filesystems should not really
> know about how bdi writeback queueing works. But I don't know if it's
> worth doing anything more complex for this functionality?

I think we should make a writeback_inodes_sb_unlocked() that doesn't
warn when the semaphore isn't held.  That should be enough given where
btrfs and ext4 are calling it from.

-chris
