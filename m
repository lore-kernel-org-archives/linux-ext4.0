From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 11:44:45 -0500
Message-ID: <20091123164445.GB3292@fieldses.org>
References: <20091122222047.GB21944@fieldses.org> <20091123114831.GA2532@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:41562 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZKWQoB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 11:44:01 -0500
Content-Disposition: inline
In-Reply-To: <20091123114831.GA2532@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2009 at 06:48:31AM -0500, tytso@mit.edu wrote:
> On Sun, Nov 22, 2009 at 05:20:47PM -0500, J. Bruce Fields wrote:
> > However, the new i_version support is available only when the filesystem
> > is mounted with the i_version mount option.  And the change attribute is
> > required for completely correct NFSv4 operation, which we'd prefer to
> > offer by default!
> > 
> > I recall having a conversation with Ted Ts'o about ways to do this
> > without affecting non-NFS-exported filesystems: maybe by providing some
> > sort of persistant flag on the superblock which the nfsd code could turn
> > on automatically if desired?
> > 
> > But first it would be useful to know whether there is in fact any
> > disadvantage to just having the i_version on all the time.  Jean Noel
> > Cordenner did some tests a couple years ago:
> > 
> > 	http://www.bullopensource.org/ext4/change_attribute/index.html
> > 
> > and didn't find any significant difference.  But I don't know if those
> > results were convincing (I don't understand what we're looking for
> > here); any suggestions for workloads that would exercise the worst
> > cases?
> 
> Hmmm.... the workload that would probably see the most hit would be
> one where we have multiple processes/thread running on different cpu's
> that are modifying the inode in parallel.  (i.e., the sort of workload
> that a database with multiple clients would naturally see).

Got it, thanks.  Is there an existing easy-to-setup workload I could
start with, or would it be sufficient to try the simplest possible code
that met the above description?  (E.g., fork a process for each cpu,
each just overwriting byte 0 as fast as possible, and count total writes
performed per second?)

> The test which Bull did above used a workload which was very heavy on
> creating and destroying files, and it was only a two processor system
> (not that it mattered; it looks like the fileop benchmark was
> single-threaded anyway).  The test I would do is something like a 4 or
> 8 processor test, with lots of parallel I/O to the same file (at which
> point we would probably end up bottlenecking on inode->i_lock).
> 
> It would seem to me that a simple way of fixing this would be to use
> atomic64 type for inode->i_version, so we don't have to take the
> spinlock and bounce cache lines each time i_version gets updated.

The current locking does seem like overkill.

> What we might decide, at the end of the day, is that for common fs
> workloads no one is going to notice, and for the parallel intensive
> workloads (i.e., databases), people will be tuning for this anyway, so
> we can make i_version the default, and noi_version an option people
> can use to turn off i_version if they are optimizing for the database
> workload.
> 
> A similar tuning knob that I should add is one that allows us to set
> a custom value for sb->s_time_gran, so that we don't have to dirty the
> inode and engage the jbd2 machinery after *every* single write.  Once
> I add that, or if you use i_version on a file system with an 128-byte
> inode so the mtime update granularity is a second, I suspect the cost
> of i_version will be especially magnified, and the database people
> will very much want to turn off i_version.
> 
> And that brings up another potential compromise --- what if we only
> update i_version every n milliseconds?  That way if the file is being
> modified to the tune of hundreds of thousands of updates a second,
> NFSv4 clients will see a change fairly quickly, with n milliseconds,
> but we won't be incrementing i_version at incredibly high rates.  I
> suspect that would violate NFSv4 protocol specs somewhere, but would
> it cause seriously noticeable breakage that would be user visible? If
> not, maybe that's something we should allow the user to set, perhaps
> not as the default?  Just a thought.

That knob would affect the probability of the breakage, but not
necessarily the seriousness.  The race is:

	- clock tick
	write
	read and check i_version
	write
	- clock tick

If the second write doesn't modify the i_version, the client will never
see it.  (Unless a later write bumps i_version again.)

If the side we want to optimize is the modifications, I wonder if we
could do all the i_version increments on *read* of i_version?:

	- writes (and other inode modifications) set an "i_version_dirty"
	  flag.
	- reads of i_version clear the i_version_dirty flag, increment
	  i_version, and return the result.

As long as the reader sees i_version_flag set only after it sees the
write that caused it, I think it all works?

--b.
