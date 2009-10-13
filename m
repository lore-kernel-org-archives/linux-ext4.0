From: Jan Kara <jack@suse.cz>
Subject: Re: Fun with fdatasync()
Date: Tue, 13 Oct 2009 21:23:57 +0200
Message-ID: <20091013192357.GD31440@duck.suse.cz>
References: <20091012140049.GO2632@think> <20091012220043.GC3965@duck.suse.cz> <20091013160028.GA7850@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jbacik@redhat.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091013160028.GA7850@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 13-10-09 12:00:28, Chris Mason wrote:
> On Tue, Oct 13, 2009 at 12:00:43AM +0200, Jan Kara wrote:
> >   Hi,
> > 
> > On Mon 12-10-09 10:00:49, Chris Mason wrote:
> 
> [ clearing of I_DIRTY_DATASYNC by pdflush ]
> 
> > > 
> > > Am I missing something?  I don't see how fdatasync is safe in our
> > > current usage.
> >   Yeah, we already discussed similar problems I_DIRTY flags with Ted and
> > others in thread "fsync on ext[34] working only by an accident" on
> > linux-ext4.
> >   I don't quite like clearing dirty flags only on sync - pdflush would then
> > unnecessarily try to get rid of those inodes and burn CPU on them.
> > Actually, mapping->private_list (and bh->b_assoc_buffers) is meant to be
> > used exactly for the purpose of tracking what needs to be written on fsync
> > so my current plan is to somehow utilize that list to fix the problem.
> >   Maybe I even get to that tomorrow ;) Thanks for the reminder.
> 
> I honestly don't remember all the details now, but I know that when
> reiserfs stopped using the b_assoc_buffers stuff life got much less
> complex.  From an outsider's point of view the last thing jbd needs is
> another list of buffers to live on.
> 
> It seems like ext34 need to be able to answer 3 questions during an
> fsync or fdatasync:
> 
> The last transaction to change this file (fill hole, change
> i_size)
> 
> The last transaction to log this inode (for full fsync)
> 
> The last transaction committed such that fsync would consider it done.
> 
> Filling holes and changing i_size only happens from a handful of places,
> so it would be easy to update a transid field in the in-memory inode for
> that.
> 
> The inode logging code could bump a second transid field to catch all
> the other ways inodes change.
> 
> The transaction code could (or already does?) export an easy way to
> check the last commit.  Put the three together and you can safely jump
> out of fsync or fdatasync based on what the inode really needs instead
> of guessing with the I_ flags or page dirty bits.
  I was thinking about this solution as well (before thinking about
using b_assoc_queue). But to make this reliable we have to pin the inode
in memory until transactions modifying it (or its data) are committed.
Otherwise it could be reclaimed and we'd loose the information about
which transactions we have to wait for. And when we pin the inode, we'd
have to unpin it at transaction commit which implies we have to somehow
attach the inode to the transaction... That doesn't look more appealing
than b_assoc_queue in my opinion (OK, for ext4/JBD2 we have a way to
attach inodes to transactions but ext3/JBD does not have such way).
  So to me it seemed easier to use b_assoc_queue but I admit I haven't
thought through all the details and your experiences with reiserfs
frighten me a bit ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
