From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Fun with fdatasync()
Date: Tue, 13 Oct 2009 12:00:28 -0400
Message-ID: <20091013160028.GA7850@think>
References: <20091012140049.GO2632@think>
 <20091012220043.GC3965@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jbacik@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:60878 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933893AbZJMQBp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 13 Oct 2009 12:01:45 -0400
Content-Disposition: inline
In-Reply-To: <20091012220043.GC3965@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 13, 2009 at 12:00:43AM +0200, Jan Kara wrote:
>   Hi,
> 
> On Mon 12-10-09 10:00:49, Chris Mason wrote:

[ clearing of I_DIRTY_DATASYNC by pdflush ]

> > 
> > Am I missing something?  I don't see how fdatasync is safe in our
> > current usage.
>   Yeah, we already discussed similar problems I_DIRTY flags with Ted and
> others in thread "fsync on ext[34] working only by an accident" on
> linux-ext4.
>   I don't quite like clearing dirty flags only on sync - pdflush would then
> unnecessarily try to get rid of those inodes and burn CPU on them.
> Actually, mapping->private_list (and bh->b_assoc_buffers) is meant to be
> used exactly for the purpose of tracking what needs to be written on fsync
> so my current plan is to somehow utilize that list to fix the problem.
>   Maybe I even get to that tomorrow ;) Thanks for the reminder.

I honestly don't remember all the details now, but I know that when
reiserfs stopped using the b_assoc_buffers stuff life got much less
complex.  From an outsider's point of view the last thing jbd needs is
another list of buffers to live on.

It seems like ext34 need to be able to answer 3 questions during an
fsync or fdatasync:

The last transaction to change this file (fill hole, change
i_size)

The last transaction to log this inode (for full fsync)

The last transaction committed such that fsync would consider it done.

Filling holes and changing i_size only happens from a handful of places,
so it would be easy to update a transid field in the in-memory inode for
that.

The inode logging code could bump a second transid field to catch all
the other ways inodes change.

The transaction code could (or already does?) export an easy way to
check the last commit.  Put the three together and you can safely jump
out of fsync or fdatasync based on what the inode really needs instead
of guessing with the I_ flags or page dirty bits.

-chris






