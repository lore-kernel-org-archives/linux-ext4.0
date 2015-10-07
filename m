From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Tue, 6 Oct 2015 23:34:48 -0400
Message-ID: <20151007033448.GB24678@thunk.org>
References: <20151005152236.GA8140@thunk.org>
 <5612BBB3.7010201@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5612BBB3.7010201@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 05, 2015 at 11:04:35AM -0700, Dave Hansen wrote:
> 
> The warning comes out of ext4_walk_page_buffers() and the dirty state
> comes from page_zero_new_buffers(). That seems a _bit_ goofy that the
> filesystem is marking the page dirty and then so shortly warning about it.

Yes, this is a bug in ext4 --- and in fact in ext3, which apparently
we've lived with for *years*.  The problem is that when we are
journalling data buffers, we can't use page_zero_new_buffers(),
because instead of calling mark_buffer_dirty(bh), we need to call
ext4_handle_dirty_metadata(bh).  This will call mark_buffer_dirty(bh)
if journalling is not enabled, or if journalling is enabled, it will
call jbd2_journal_dirty_metadata(handle,bh).

Apprently it is extremely rare that (copied < len) --- especially when
mm/filemap.c was doing a prefault.  :-)

So your patch looks good, but in addition to that, if copied is > 0
and less than len, we shouldn't be calling page_zero_new_buffers().
We're going to need our own version of it that doesn't call
mark_buffer_dirty().

So if Linus wants to revert 998ef75ddb patch, we can do that, but I'm
also happy applying your patch as a way of preventing the failure.
We'll need to do more work to make ext4_journalled_write_end(), but
that's a bigger change which I'd rather not do at this point in the
development cycle.

Thanks again for taking a closer look at things.  I'm currently
running a full soak test to make sure your patch to
ext4_journalled_write_end() doesn't introduce any other problems, but
I'm quite confident it should be fine.

Cheers,

						- Ted
