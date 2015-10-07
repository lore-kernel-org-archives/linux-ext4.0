From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/ data=journal
Date: Wed, 7 Oct 2015 08:32:16 +0100
Message-ID: <CA+55aFycvHK2z_0QZ34wEJf5fBMxWDaeOs85cFSmpKnNONDxLQ@mail.gmail.com>
References: <20151005152236.GA8140@thunk.org>
	<5612BBB3.7010201@intel.com>
	<20151007033448.GB24678@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Theodore Ts'o" <tytso@mit.edu>,
	Dave Hansen <dave.hansen@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151007033448.GB24678@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 7, 2015 at 4:34 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> So your patch looks good, but in addition to that, if copied is > 0
> and less than len, we shouldn't be calling page_zero_new_buffers().
> We're going to need our own version of it that doesn't call
> mark_buffer_dirty().

Well, even with copied == 0, isn't it wrong not to zero the data and
mark it dirty, though?

At least for traditional non-prealloc filesystems, write_begin() will
have allocated the blocks on disk, and depending on the size of the
write may not have zeroed anything, or marked anything dirty. So the
disk layout may be set up, and the blocks *need* to be written back to
disk with real data at some later time.

I'm not sure that that is how write_begin() works for ext4, but the
fact that you do the page_zero_new_buffers() does imply that it's an
issue.

And none of *those* requirements change just because "copied" would be
zero. If you avoid zeroing the buffers and marking them dirty, nothing
will ever initialize them on disk, andn if the prefault then later
fails during retry, no later write will happen either. So now
eventually later, a read() can see stale data from disk.

Now, again, I didn't actually follow the ext4 code, so this may not be
an issue on ext4 due to the journaling perhaps never writing back the
actual block allocations either, so the above may be a "only happens
on old traditional unix filesystems" kind of scenario. But it worries
me.

That's why II'll just revert the change for now as a "ok, the change
itself isn't buggy, but it exposes long-time bugs in at least ext4,
and let's take this slow and give the ext4 people time to make sure
they have that case fixed".

> So if Linus wants to revert 998ef75ddb patch, we can do that, but I'm
> also happy applying your patch as a way of preventing the failure.

I do think this is an ext4 bug, and you'll need to do something *like*
that patch. Maybe Dave's patch is good as-is. It's the "I think you
need to do more" that I worry about. Not at -rc4 time. Not with a core
filesystem like ext4. Let's not hurry this too much.

                Linus
