From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Tue, 15 Feb 2011 18:29:54 +0100
Message-ID: <20110215172954.GK17313@quack.suse.cz>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
 <20110215170352.GE4255@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215170352.GE4255@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 15-02-11 12:03:52, Ted Ts'o wrote:
> On Tue, Feb 15, 2011 at 05:06:30PM +0100, Jan Kara wrote:
> > Thanks for detailed analysis. Indeed this is a bug. Whenever we do IO
> > under s_umount semaphore, we are prone to deadlock like the one you
> > describe above.
> 
> One of the fundamental problems here is that the freeze and thaw
> routines are using down_write(&sb->s_umount) for two purposes.  The
> first is to prevent the resume/thaw from racing with a umount (which
> it could do just as well by taking a read lock), but the second is to
> prevent the resume/thaw code from racing with itself.  That's the core
> fundamental problem here.
> 
> So I think we can solve this by introduce a new mutex, s_freeze, and
> having the the resume/thaw first take the s_freeze mutex and then
> second take a read lock on the s_umount.
  Sadly this does not quite work because even down_read(&sb->s_umount)
in thaw_super() can block if there is another process that tries to acquire
s_umount for writing - a situation like:
  TASK 1 (e.g. flusher)		TASK 2	(e.g. remount)		TASK 3 (unfreeze)
down_read(&sb->s_umount)
  block on s_frozen
				down_write(&sb->s_umount)
				  -blocked
								down_read(&sb->s_umount)
								  -blocked
behind the write access...

The only working solution I see is to check for frozen filesystem before
taking s_umount semaphore which seems rather ugly (but might be bearable if
we did so in some well described wrapper).

And in particular ext4 has another deadlock of this kind because it does
IO from ext4_remount() e.g. when doing online resize (I know it's a bit
artifical but still ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
