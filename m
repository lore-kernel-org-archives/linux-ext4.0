From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [GIT PULL] ext4 changes for 4.2-rc1
Date: Sat, 27 Jun 2015 00:02:37 -0400
Message-ID: <20150627040237.GC474@thunk.org>
References: <20150625034626.GA21682@thunk.org>
 <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwXgrcfqN2f7R8PbcDr9yiWXv4cicKmKfQFxR_KsHaiwQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 26, 2015 at 08:05:48PM -0700, Linus Torvalds wrote:
> On Wed, Jun 24, 2015 at 8:46 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > A very large number of cleanups and bug fixes --- in particular for
> > the ext4 encryption patches, which is a new feature added in the last
> > merge window.  Also fix a number of long-standing xfstest failures.
> > (Quota writes failing due to ENOSPC, a race between truncate and
> > writepage in data=journalled mode that was causing generic/068 to
> > fail, and other corner cases.)
> >
> > Also add support for FALLOC_FL_INSERT_RANGE, and improve jbd2
> > performance eliminating locking when a buffer is modified more than
> > once during a transaction (which is very common for allocation
> > bitmaps, for example), in which case the state of the journalled
> > buffer head doesn't need to change.
> 
> I think this is very broken.
> 
> I just got this while compiling:
> 
>    ------------[ cut here ]------------
>    kernel BUG at fs/jbd2/transaction.c:1325!
> ...
>
> The most obvious candidate for a culprit would seem to be
> 
>    2143c1965a76 "jbd2: speedup jbd2_journal_dirty_metadata()"
> 
> which is the commit that introduced the assert that triggers. Ted? Jan?

I would tend to agree.  The weird thing though is that I haven't seen
this problem myself, despite running multiple regression tests before
I sent the pull request, as well as running it on my laptop and doing
kernel compiles with make -j16 and reading e-mail (I'm typing this
e-mail on a 4.1 kernel merged with the ext4 patches for this merge
window, so I have this commit running in my development laptop, and it
hasn't triggered for me).

All of this being said, my suggestion would be to revert it for now
and we'll investigate more closely for the next merge window.  This is
just a performance improvement, and so better safe than sorry.  Jan,
do you agree?

							- Ted
							
