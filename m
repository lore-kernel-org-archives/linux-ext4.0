From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: tune2fs and setting noatime as a default mount options
Date: Fri, 29 Aug 2014 18:56:49 -0400
Message-ID: <20140829225649.GC27177@thunk.org>
References: <16b17d3bf6a5952c3f20a8644be22c58@admin.virtall.com>
 <54009D31.70703@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-ext4@vger.kernel.org,
	luto@amacapital.net
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:56549 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaH2W4x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Aug 2014 18:56:53 -0400
Content-Disposition: inline
In-Reply-To: <54009D31.70703@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 29, 2014 at 10:33:05AM -0500, Eric Sandeen wrote:
> 
> > Is there a reason why noatime can't be set as a default mount option? Thinking of all these USB connected devices where it would be handy.
> 
> I haven't looked, but I'm guessing it's because noatime is a
> vfs-level switch, and by the time the ext4 superblock is getting
> read and processed during mount, that chance has passed.

Yes, and this is also the cause of this user complaint/bug:

	https://bugzilla.kernel.org/show_bug.cgi?id=61601

There was some discussion at the kernel summit by Andy Lutomirski to
create new mount system call with sane parsing, and Al Viro wasn't
totally against that idea.  If we do go forward with some of the ideas
that was tossed about, this would be something else that would be a
nice thing to fix at the same time.

The whole distinction between VFS-level mount options (which are
parsed in userspace and passed down into the kernel using bits in a
bitfield) and file system-level mount options (which is parsed by the
kernel and passed in from userspace as a string) is just nasty.

What I would suggest is that all mount options would be passed all the
way down to the file system, and then there would be a library
function to handle common VFS-level mount options that would be called
by the file system's mount option handling code.

							- Ted

P.S.  At the kernel summit, Al recited the history of the mount system
call going all the way back to 1991-1992 when minix was the only file
system, and let's just say there is some major cruftiness going back
literally decades.  :-/

