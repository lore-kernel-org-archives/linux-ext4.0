From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tune2fs and setting noatime as a default mount options
Date: Mon, 1 Sep 2014 23:36:23 -0400
Message-ID: <20140902033623.GT8974@thunk.org>
References: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
 <54009D31.70703@redhat.com>
 <20140829225649.GC27177@thunk.org>
 <CALCETrWwozeOGxbv1r1y=NUSxem_uTmfP=FbkcKy8YPzT=mLOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60066 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbaIBDgf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Sep 2014 23:36:35 -0400
Content-Disposition: inline
In-Reply-To: <CALCETrWwozeOGxbv1r1y=NUSxem_uTmfP=FbkcKy8YPzT=mLOA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 01, 2014 at 02:23:46PM -0700, Andy Lutomirski wrote:
> To clarify: do you mean that per-superblock options would all be
> strings and would all get passed down to the fs?  If so, I like it.  I
> think that whatever corresponds to MNT_READONLY shouldn't be passed
> down to the filesystem or necessarily specified when loading the
> filesystem at all.  But MNT_READONLY is a very different thing than
> "ro".

So the way I see it, we should be very clear about the distinction
between the mount flags (MS_READONLY) and the mountpoint flags
(MNT_READONLY).  The former are set when the file system is "mounted"
via the call to the file system's fill_super function.

The latter is set when the file system is attached to the namespace
via the creation of a mount point.  From the perspective of the user
using the mount(8) userspace program, the way I would envision this
working is that the mount(8) progam would query the MS_* flags and use
them to populate the MNT_* flags for the initial mount of the file
system.  That way, the user experience gets preserved, but we move all
of the parsing to a single place --- in the kernel.

This would also fix the bug where rootflags=noatime doesn't work,
because today some mount options are parsed in the kernel, and some
are parsed in userspace, and it's really, fundamentally, not fair that
the user should be forced to understand the difference between the
string "acl" and the magic mount flag, MS_READONLY which happens to be
set if "ro" is passed to the mount option alongside "acl".

For MS_READONLY, there's no problem because we do currently make a
hard distinction between MS_READONLY and MNT_READONLY.  The two have
distinct meanings, and so I think it makes sense that "ro" be passed
down to the file system alongside "acl", even if there is a library
function which translates "ro" into the standard MS_READONLY flag.

What's more difficult is MS_NOATIME, which exists as a superblock
flag, but it's not actually checked as a superblock flag, except to
decide whether or not to set MNT_NOATIME.

What might make sense is to give the kernel responsibility for parsing
the mountpoint flags as well, so we pass text strings for
corresponding to MNT_NOATIME, etc. to the kernel as well.  If the
mountpoint flag isn't specified, then the value of superblock flag
(i.e., MS_NOATIME) gets used as the default.

Cheers,

						- Ted
