From: Ryan Lortie <desrt@desrt.ca>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 09:51:47 -0400
Message-ID: <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49136 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030256Ab3FUNvs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 09:51:48 -0400
In-Reply-To: <20130621131521.GE10730@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,

On Fri, Jun 21, 2013, at 9:15, Theodore Ts'o wrote:
> I agree it can be read that way, although we were very careful to
> avoid the word "guarantee".

It would still be great if you could update the docs to say very clearly
that there is no guarantee.  Using words other than 'guarantee' can
(clearly) still mislead people to believing that there is.

> #2) If an existing file is removed via a rename, if there are any
>     delayed allocation blocks in the new file, they will be flushed
>     out.

Can you describe to me exactly what this means in terms of the syscall
API?  Do I void these "delayed allocation blocks" guarantees by using
fallocate() before-hand?

> > It would be great if the docs would just said "If you want safety with
> > ext4, it's going to be slow.  Please always call fsync()." instead of
> > making it sound like I'll probably be mostly OKish if I don't.
> 
> This is going to be true for all file systems.  If application writers
> are trying to surf the boundaries of what is safe or not, inevitably
> they will eventually run into problems.

btrfs explicitly states in its documentation that replace-by-rename is
safe without fsync().  Although, I start to wonder about that guarantee
considering my reading of the ext4 documentation led me to believe the
same was true for ext4...

As an application developer, what I want is extremely simple: I want to
replace a file in such a way that if, at ANY time, the system crashes or
loses power, then when it comes back on (after replaying the journal), I
will have, at the filename of the file, either the old contents or the
new contents.

This is my primary concern.  I also have a secondary concern:
performance.

I have a legitimate desire to optimise for my second concern without
sacrificing my first concern and I don't think that it's unreasonable
for me to ask where the line is.  I don't really accept this "surf the
boundaries" business about fuzzy APIs that "should do the right thing
usually, but no guarantees if you get too close to the line".  I just
want to know what I have to do in order to be safe.

If there are no guarantees then please say that, explicitly, in your
documentation.  I'm fine calling fsync() constantly if that's what your
filesystem requires me to do.

> Finally, I strongly encourage you to think very carefully about your
> strategy for storing these sorts of registry data.  Even if it is
> "safe" for btrfs, if the desktop applications are constantly writing
> back files for no good reason, it's going to burn battery, SSD write
> cycles, and etc.

I agree.  A stated design goal of dconf has always been that reads are
insanely fast at the cost of extremely expensive writes.  This is why it
is only for storing settings (which are rarely modified, but are read by
the thousands on login).  I consider fsync() to be an acceptable level
of "expensive", even on spinning disks, and the system is designed to
hide the latency from applications.

I've gone on several campaigns of bug-filing against other people's
applications in order to find cases of writes-with-no-good-reason and
I've created tools for tracking these cases down and figuring out who is
at fault.  The result is that on a properly-functioning system, the
dconf database is never written to except in response to explicit user
actions.  This means no writes on login, no writes on merely starting
apps, etc.

Meanwhile, the file size is pretty small.  100k is really on the high
side, for someone who has aggressively customised a large number of
applications.

> modifies an element or two (and said application is doing this several
> times a seocnd), the user is going to have a bad time --- in shortened
> battery and SSD life if nothing else.

I agree.  I would consider this an application bug.

But it brings me to another interesting point: I don't want to sync the
filesystem.  I really don't care when the data makes it to disk.  I
don't want to waste battery and SSD life.  But I am forced to.  I only
want one thing, which is what I said before: I want to know that either
the old data will be there, or the new data.  The fact that I have to
force the hard drive to wake up in order to get this is pretty
unreasonable.

Why can't we get what we really need?

Honestly, what would be absolutely awesome is g_file_set_contents() in
the kernel, with the "old or new" guarantee.  I have all of the data in
a single buffer and I know the size of it in advance.  I just want you
to get it onto the disk, at some point that is convenient to you, in
such a way that I don't end up destroying the old data while still not
having the new.

If not that, then I'd accept some sort of barrier operation where I
could tell the kernel "do not commit this next operation to disk until
you commit the previous one".  It's a bit sad that the only way that I
can get this to happen is to have the kernel do the first operation
*right now* and wait until it's done before telling the kernel to do the
second one.

> The fact that you are trying to optimize out the fsync() makes me
> wonder if there is something fundamentally flawed in the design of
> either the application or its underlying libraries....

I took out the fsync() because I thought it was no longer needed and
therefore pointless.  As I mentioned above, with dconf, fsync() is not a
substantial problem (or a visible problem at all, really).

Thanks
