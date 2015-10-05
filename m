From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 16:33:17 -0700
Message-ID: <561308BD.5090304@linux.intel.com>
References: <20151005152236.GA8140@thunk.org>
 <CA+55aFzARo_ZtbO6PDxgenWQtEEbynBCWFWCwVJT2NbXmJOd9Q@mail.gmail.com>
 <5612A3F3.2040609@linux.intel.com>
 <CA+55aFw1AcOL7+ZUKL=bC9GLJ3iMehQyqLWThAa=O7p1YdoEAQ@mail.gmail.com>
 <5612E23B.7070606@linux.intel.com>
 <CA+55aFwkA1EODc0bsrdmob945DYfDW_jE+nmrFKpq2YmBn+W4Q@mail.gmail.com>
 <CA+55aFz9hH26=iQa832J5789Kf1ufYEJPt5L_D1wcDhCycUCFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Peter Anvin <hpa@zytor.com>, Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFz9hH26=iQa832J5789Kf1ufYEJPt5L_D1wcDhCycUCFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Mon, Oct 5, 2015 at 10:18 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Your ext4 patch may well fix the issue, and be the right thing to do
>> (_regardless_ of the revert, in fact - while it might make the revert
>> unnecessary, it might also be a good idea even if we do revert).
> 
> Thinking a bit more about your patch, I actually am getting more and
> more convinced that it's the wrong thing to do.
> 
> Why?
> 
> Because the whole "Setting copied=0 will tell the upper layers to
> repeat the write" just seems a nasty layering violation, where the
> low-level filesystem uses a magic return code to introduce a special
> case at the upper layers. But the upper layers are actually already
> *aware* of the special case, and in fact have a comment about it.

It's nasty, but it's widespread.  I'm fairly sure some version of that
code shows up in all these places:

	ext4_journalled_write_end()
	generic_write_end()->block_write_end()
	ocfs2_write_end_inline()
	ocfs2_write_end_nolock()
	logfs_write_end()
	ext3_journalled_write_end()
	btrfs_copy_from_user()
	reiserfs_write_end()

> The ext4 side still worries me, though. You made that
> "page_zero_new_buffers()" conditional on "copied" being non-zero, but
> I'm not convinced it can be conditional. Even if we retry, that retry
> may end up failing (for example, because the source isn't mapped, so
> we return -EFAULT rather than re-doing the write), but we have those
> new buffers that got allocated in write_begin(), and now nobody has
> ever written any data to them at all, so they have random stale
> contents.

Yeah, I guess they're not uptodate and nobody is on the hook to make
them uptodate.

> So I do think this needs more thought. Or at least somebody should
> explain to me better why it's all ok.
> 
> I'm attaching the "copied = 0" special case thing at the
> generic_perform_write() level as a patch for comments. But for now I
> still think that reverting would seem to be the safer thing (which
> still possibly leaves things buggy with a racy unmap, but at least
> it's the old bug that we've never hit in practice).

FWIW, I'm not objecting at all to a revert.  It's obviously the safe
thing to do.

> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2493,6 +2493,20 @@ again:
>  		pagefault_enable();
>  		flush_dcache_page(page);
>  
> +		/*
> +		 * If we didn't successfully copy all the data from user space,
> +		 * and the target page is not up-to-date, we will have to prefault
> +		 * the source. And if the page wasn't up-to-date before the write,
> +		 * the "write_end()" may need to *make* it up-to-date, and thus
> +		 * overwrite our partial copy.
> +		 *
> +		 * So for that case, thow away the whole thing and force a full
> +		 * restart (see comment above, and iov_iter_fault_in_readable()
> +		 * below).
> +		 */
> +		if (copied < bytes && !PageUptodate(page))
> +			copied = 0;
> +
>  		status = a_ops->write_end(file, mapping, pos, bytes, copied,
>  						page, fsdata);

Did you mean that as a cleanup, or to fix the regression?

Since the page isn't faulted in yet, iov_iter_copy_from_user_atomic()
had already set copied=0, so that has no effect on the ext4 code being
called and it spits out the same warning Ted originally reported.

Ted, do we really just need to tell ext4 that this dirtying operation is
OK?  Or is there really a risk of filesystem corruption that we're not
seeing?
