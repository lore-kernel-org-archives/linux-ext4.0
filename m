From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC v2 00/13] NLS/UTF-8 Case-Insensitive lookups for ext4
 and VFS proposal
Date: Thu, 25 Jan 2018 14:32:39 -0500
Message-ID: <20180125193239.GA8005@thunk.org>
References: <20180125025349.31494-1-krisman@collabora.co.uk>
 <20180125031650.GU13338@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        david@fromorbit.com, olaf@sgi.com, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, alvaro.soliverez@collabora.co.uk,
        kernel@lists.collabora.co.uk
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180125031650.GU13338@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 25, 2018 at 03:16:50AM +0000, Al Viro wrote:
> On Thu, Jan 25, 2018 at 12:53:36AM -0200, Gabriel Krisman Bertazi wrote:
> 
> > The second proposal is related to the VFS layer:
> > 
> > (2) Enable Insensitive lookup support on a per-mountpoint basis,
> > via a MS_CASEFOLD flag, with the ultimate goal of supporting a
> > case-insensitive bind mount of a subtree, side-by-side with a
> > sensitive version of the filesystem.
> 
> First reaction: No.  With the side of HELL NO.
> 
> Your ultimate goal sounds utterly insane - dcache tree must be shared
> for all mounts.  Moreover, "would these two names refer to the same
> object" can not be mount-dependent.  Not going to happen.
> 
> Please, post the description of what you are planning to do.
> Detailed.  I'm not saying that it's 100% impossible to do correctly,
> but I'm _very_ sceptical about the feasibility.

So I can't speak authoratatively about the Collabora's customer
requirements that drove this particular feature, but I can talk about
why I am interested in this feature --- although I understand why it's
hard to do correctly.

Android is currently using a horrible wrapfs scheme to provide case
insesitive lookups.  We talked about this last year at LSF/MM[1].  It
is using separate dentry entries for the upper and lower layers, and
it is *definitely* prone to races.  Running fsstress on the top and
lower layers simultaneously is a pretty simple way to induce hilarity,
although my understanding is that the developers working on it having
been hammering on it for a while so that the races that cause kernel
panicks or file system damage are rare.  I don't believe they have
been completely elimniated, because it's not clear to me that any
wrapfs solution can ever be made race-free.

[1] https://lwn.net/Articles/718640/

The problem is that both the case insensitive and case sensitive
directory trees are made available to userspace, and for backwards
compatibility reasons, they can't just make it disappear.  Although
they don't have a Linus Torvalds going all Mr. Shouty about breaking
userspace, the combined whinging from the App developer ecosystem
probably can be a fairly good substitute for Linus when they complain
about compatibility breakages visible to the Android application
programmer.  :-)

So my hope has been to find a way to (a) make wrapfs go away, and (b)
allow the functionality of case sensitive and case insensitive bind
mounts of the same underlying file system directories be *somehow*
supported.

If the answer is that if two files that differ only in case are
created via the case sensitive mount results in it being undefined
which file you get when you open, rename, or delete that file via the
case insensitive mount, that's fine.  I think that's what happpens in
the wrapfs implementation today anyway.  It would probably be fine if
the answer was you get the file with an exact match if it is present,
but if the two files created on the case sensitive side are "makefile"
and "Makefile", and you try open/delete "MaKeFiLe" via the case
insensitive mount, it's undefined which file you get --- that's fine.

Anyone who does that will get everything they deserve, and they get
that today anyway with the wrapfs or the previous fuse hack anyway.

This may indeed be an O_PONIES style request.  And in the worst case,
Android will continue using an out-of-tree wrapfs solution, and
hopefully I can fend off people asking me for help when the wrapfs
code blows up in various not-so-entertainng ways.  Which is,
admittedly, a purely selfish reason for why I would like to see if we
can give Android folks equivalent functionality to the wrapfs hack in
a sane, safe, and consensual way.   :-)

Cheers,

						- Ted
