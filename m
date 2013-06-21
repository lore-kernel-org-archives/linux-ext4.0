From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 09:15:21 -0400
Message-ID: <20130621131521.GE10730@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ryan Lortie <desrt@desrt.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60084 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161295Ab3FUNPZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 09:15:25 -0400
Content-Disposition: inline
In-Reply-To: <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 08:43:16AM -0400, Ryan Lortie wrote:
> 
> On Thu, Jun 20, 2013, at 20:59, Theodore Ts'o wrote:
> > It's not _guaranteed_ safe.  It significantly reduces the chances of
> > data loss in case of a crash, but it's possible for the transaction
> > containing the rename to close before the blocks are written back.
> 
> I think you need to update the documentation.  Specifically, this:
> 
> "avoids the                     "zero-length" problem that can happen
> when a system crashes before the delayed allocation                     
>  blocks are forced to disk"
> 
> makes it sound like the replace-by-rename-without-fsync problem has been
> solved.  This is the statement that caused me to remove the extra
> fsync() we had in GLib.

I agree it can be read that way, although we were very careful to
avoid the word "guarantee".

> Note that "significantly reduces the chances of" is not good enough to
> prevent about a dozen reports of lost data that I alone have heard about
> in the past few days...
> 
> https://bugzilla.gnome.org/show_bug.cgi?id=701560#c30

So in at least a few of these bugs, people are failing to fsync()
after creatinig a new file.  The implied flush *only* happens in two
cases:

#1) If an existing file was opened using O_TRUNC, an implied flush is
    sent after the file is closed.

#2) If an existing file is removed via a rename, if there are any
    delayed allocation blocks in the new file, they will be flushed
    out.

One of the test cases created lots of new files, and that's not one of
the two cases shown above.

> It would be great if the docs would just said "If you want safety with
> ext4, it's going to be slow.  Please always call fsync()." instead of
> making it sound like I'll probably be mostly OKish if I don't.

This is going to be true for all file systems.  If application writers
are trying to surf the boundaries of what is safe or not, inevitably
they will eventually run into problems.

Also, although fsync() is not free, it's not the performance disaster
it was in ext3.  Precisely because of delayed allocation, we don't
have to flush out pending writes of unrelated files when you do a
fsync().

Finally, I strongly encourage you to think very carefully about your
strategy for storing these sorts of registry data.  Even if it is
"safe" for btrfs, if the desktop applications are constantly writing
back files for no good reason, it's going to burn battery, SSD write
cycles, and etc.  And if said registry files are large XML files that
have to be complete rewritten every single time an applicatoin
modifies an element or two (and said application is doing this several
times a seocnd), the user is going to have a bad time --- in shortened
battery and SSD life if nothing else.  And this is not a problem a
file system can protect you against, since while we can try to be more
clever about how we manage the metadata, the data blocks still have to
be written to disk.

The fact that you are trying to optimize out the fsync() makes me
wonder if there is something fundamentally flawed in the design of
either the application or its underlying libraries....

						- Ted
