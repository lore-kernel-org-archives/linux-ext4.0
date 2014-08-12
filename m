From: TR Reardon <thomas_reardon@hotmail.com>
Subject: Re: journal_checksum_v2 on-disk format change? (was: Re: journal
 recovery problems with metadata_csum, *non-64bit*)
Date: Tue, 12 Aug 2014 01:39:35 -0400
Message-ID: <BLU436-SMTP123C75E96D9A42B3CA66A12FDEA0@phx.gbl>
References: <BLU437-SMTP3407533C3883653626BD3DFDEC0@phx.gbl>
	<20140811071025.GE19223@birch.djwong.org>
	<20140811192529.GG2808@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from blu004-omc1s14.hotmail.com ([65.55.116.25]:59225 "EHLO
	BLU004-OMC1S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaHLFjj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Aug 2014 01:39:39 -0400
Received: by mail-yh0-f42.google.com with SMTP id a41so7117059yho.15
        for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2014 22:39:35 -0700 (PDT)
In-Reply-To: <20140811192529.GG2808@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/11/14, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> Hi all,
>
> Mr. Reardon has discovered that due to a bug in journal_tag_bytes(), if the
> the
> "journal csum v2" feature flag is turned on, block tag records are being
> written with two extra bytes of space because we don't need to execute
> "x += sizeof(tag.t_checksum);".  In 32-bit mode, other parts of the journal
> then perform incorrect size comparisons, leading to BUG() being called.  In
> 64-bit mode, there's enough padding that bad things won't happen.
>
> This is a remnant of the days when I tried to enlarge journal_block_tag_t
> to
> hold the full 32-bit checksum for a data block that's stored in the
> journal.
> Back in 2011, we decided (though sadly I can't find the link; I think we
> might
> have discussed this in the concall) that it was better not to change the
> size
> of journal_block_tag_t than it was to make it bigger so that it could hold
> the
> full checksum.
>
> A simple fix for the problem has been proposed by Mr. Reardon which fixes
> journal_tag_bytes() and leaves everything else unchanged.  However, that is
> technically a disk format change since the size of journal_block_tag_t on
> disk
> changes, albeit only for people running experimental metadata_csum
> filesystems.
> Since we've been allocating disk space for the enlarged checksum this whole
> time, if we apply that patch, anyone with an unclean 64bit FS will not be
> able
> to recover the journal.  (Anyone with an unclean 32-bit FS has been broken
> the
> whole time, and still will be.)
>
> The other thing we could do is actually use the two bytes to store the high
> 16-bits of the checksum, fix the jbd2 helper functions to reflect that
> reality
> (so that they don't BUG()), and change the checksum verify routine to pass
> the
> block if either the full checksum matches, or if the lower 16 bits match
> and
> the upper 16 bits are zero.  With this route, anybody with an uncleanly
> unmounted FS could still recover the journal, since we're not changing the
> size
> of anything.
>
> Fortunately, journal tag blocks are fairly ephemeral and nobody ought to be
> using metadata_csum on a production filesystem, so at this point we can
> probably change the disk format without too many repercussions.  If you
> make
> sure to cleanly unmount the filesystem when changing kernel/e2fsprogs
> versions,
> there will be no problems.
>
> So, uh... comments?  How should we proceed?
>
> --D

My only concern is that legacy applies to in-the-wild kernels, not
just journals.  Any post 3.4 kernel has this problem, which will be
exposed as soon as e2fsprogs 1.43 is released.  A common (enough) use
case might be, say, a 2TB USB drive, being unplugged and replugged
across machines  without proper shutdown.  Old machines will think
they recognize the journal but don't actually, and replay something
destructive.

In other words, this is a future-retro problem.  The problem is not so
much with existing fs experimenting with metadata_csum, but a future
properly-journaled drive being plugged into an legacy faulty machine.
Those incompat flags are supposed to protect against just this
scenario, but won't.  So perhaps you'll need make a new
"INCOMPAT_CSUM_V3" flag to protect?  Actually, dwelling on this a bit
today, I think whether or not you retain those 2 extra checksum bytes
in final fix, you ought use a new flag for the format.

+Reardon
