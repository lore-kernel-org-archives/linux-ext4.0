From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v2 3/5] vfs: don't let the dirty time inodes get more
 than a day stale
Date: Mon, 24 Nov 2014 12:10:54 -0500
Message-ID: <20141124171054.GB31339@thunk.org>
References: <1416675267-2191-1-git-send-email-tytso@mit.edu>
 <1416675267-2191-4-git-send-email-tytso@mit.edu>
 <87egss3hsm.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87egss3hsm.fsf@rasmusvillemoes.dk>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 24, 2014 at 01:27:21PM +0100, Rasmus Villemoes wrote:
> On Sat, Nov 22 2014, Theodore Ts'o <tytso@mit.edu> wrote:
> 
> > Guarantee that the on-disk timestamps will be no more than 24 hours
> > stale.
> >
> > +	unsigned short days_since_boot = jiffies / (HZ * 86400);
> 
> This seems to wrap every 49 days (assuming 32 bit jiffies and HZ==1000),
> so on-disk updates can be delayed indefinitely, assuming just the right
> delays between writes.

Good point, I'll fix this.

> Would it make sense to introduce days_since_boot as a global variable
> and avoid these issues? This would presumably also make update_time a
> few cycles faster (avoiding a division-by-constant), but not sure if
> that's important. And something of course needs to update
> days_since_boot, but that should be doable.

I can do this fairly simply like this:

	get_monotonic_boottime(&uptime);
	daycode = uptime.tv_sec / (HZ * 86400);

and we only need to do this if lazytime is set, and the inode isn't
marked as I_DIRTY_TIME:

	if ((inode->i_sb->s_flags & MS_LAZYTIME) &&
	    !(flags & S_VERSION)) {
		if (inode->i_state & I_DIRTY_TIME)
			return 0;
		get_monotonic_boottime(&uptime);
		daycode = do_div64(uptime.tv_sec do_div, (HZ * 86400));
		if (!inode->i_ts_dirty_day ||
		    inode->i_ts_dirty_day == daycode) {
			spin_lock(&inode->i_lock);
			inode->i_state |= I_DIRTY_TIME;
			spin_unlock(&inode->i_lock);
			inode->i_ts_dirty_day = daycode;
			return 0;
		}
	}

So I'm not entirely sure it's worth it to create a global variable for
days since boot; I've been runnin with this patch in my laptop, we
wouldn't be triggering the get_monotonic_bootime() function all that
often.  (Since once the dirty_time flg is set, we don't need to check
about whether we need to set it again.)  And if we *did* care, it
would be simple enough to use a static counter which only recalculates
daycode every 30 or 60 minutes.


Cheers,

							- Ted
