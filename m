From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC PATCH 0/4] ext4/jbd2: several possible mainline fixes
Date: Mon, 10 Jun 2013 19:38:51 -0400
Message-ID: <20130610233850.GA21795@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jun 10, 2013 at 03:31:59PM -0400, Paul Gortmaker wrote:
> Using jbd_debug() it seems that I end up with jbd2_log_do_checkpoint
> and jbd2_journal_commit_transaction running into each other.  In one of
> my attached patches, I show they overlap to the point of interrupting
> each others jbd_debug messages.  Maybe that doesn't matter?  

That should be OK.  We do allow a new transactions while we are
committing an older transaction, and if this requires more space, a
checkpoint could start.  I'm not sure why you're apparently seeing a
deadlock under RT-linux, though.

> Stuck waiting/spinning somewhere in jbd2_journal_commit_transaction.
> As near as I can tell, it never got to phase 3 of commit_transaction.
> 
> Since jbd2_journal_commit_transaction is such a large function,
> I'm tempted to break it up some, just to ease my debugging (compare
> 0x1c20 to the smaller numbers around it).  Perhaps there would be
> interest in such kinds of patches for mainline?

Instead of breaking it up, can you just use addr2line, i.e.:

% addr2line -a ffffffff8046a067 -i -e vmlinux  
0xffffffff8046a067
./include/linux/buffer_head.h:287
./fs/ext4/inode.c:5585
./fs/ext4/inode.c:5963

I find this to be incredibly useful, since with the -i option it will
handle inline functions correctly.  In the above example there are two
levels of inlining, one explicitly marked inline in
include/linux/buffer.h, and one implicit inlining taking place because
we had a static function in fs/ext4/inode.c that was only called by
one caller.

Because of gcc's implicit inlining, just breaking up the function by
itself wouldn't be enough, unless you explicitly marked the new static
functions with noinline; but that introduces inefficiencies.  If the
only reason you want to do this is to make it easier to figure out a
stack trace, addr2line really is your friend....

Cheers,

					- Ted
