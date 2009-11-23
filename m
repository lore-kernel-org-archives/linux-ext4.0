From: tytso@mit.edu
Subject: Re: i_version, NFSv4 change attribute
Date: Mon, 23 Nov 2009 13:51:05 -0500
Message-ID: <20091123185105.GC2183@thunk.org>
References: <20091122222047.GB21944@fieldses.org>
 <20091123114831.GA2532@thunk.org>
 <20091123164445.GB3292@fieldses.org>
 <1258999879.8700.17.camel@localhost>
 <20091123181951.GB5583@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: "J. Bruce Fields" <bfields@fieldses.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091123181951.GB5583@fieldses.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 23, 2009 at 01:19:51PM -0500, J. Bruce Fields wrote:
> > The question is, though, why does the jbd2 machinery need to be engaged
> > on _every_ write?
> 
> Is it?
> 
> I thought I remembered a journaling issue from previous discussions, but
> Ted seemed concerned just about the overhead of an additional
> spinlock, and looking at the code, the only test of I_VERSION that I can
> see indeed is in ext4_mark_iloc_dirty(), and indeed just takes a
> spinlock and updates the i_version.

There are two concerns.  One is the inode->i_lock overhead, which at
the time when we added i_version, the atomic64 type wasn't added, so
the only simple way it could have been implemented was by taking the
spinlock.  This we can fix, and I think it's a no-brainer that we
switch it to be an atomic64, especially for the most common Intel
platforms.

The second problem is the jbd2 machinery, which gets engaged when the
inode changes, which means in the case of sys_write(), if i_version or
i_mtime gets changed.  At the moment, if we are using a 256-byte inode
with ext4, we will be updating i_mtime on every single write, and so
when ext4_setattr(), which is called from notify_change() notices that
i_mtime is changed, we are engaging the entire jbd2 machinery for
every single write.  

This is not true for a 128-byte inode, since in that case
sb->s_time_gran is set to one second, so we would only be updating the
inode and engaging the jbd2 machinery once a second.  This is true for
ext3 and ext4 with 128-byte inodes.

Now, all of this having been said, Feodra 11 and 12 have been using
ext4 as the default filesystem, and for generic desktop usage, people
haven't been screaming about the increased CPU overhead implied by
engaging the jbd2 machinery on every sys_write().

However, we have had a report that some enterprise database developers
have noticed the increased overhead in ext4, and this is on our list
of things that require some performance tuning.  Hence my comments
about a mount option to adjust s_time_gran for the benefit of database
workloads, and once we have that moun option, since enabling i_version
would mean once again needing to update the inode at every single
write(2) call, we would be back with the same problem.

Maybe we can find a way to be more clever about doing some (but not
all) of the jbd2 work on each sys_write(), and deferring as much as
possible to the commit handling.  We need to do some investigating to
see if that's possible.  Even if it isn't, though, my gut tells me
that we will probably be able to enable i_version by default for
desktop workloads, and tell database server folks that they should
mount with the mount options "noi_version,time_gran=1s", or some such.

I'd like to do some testing to confirm my intuition first, of course,
but that's how I'm currently leaning.   Does that make sense?

Regards,

						- Ted
