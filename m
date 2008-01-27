From: Theodore Tso <tytso@mit.edu>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Sun, 27 Jan 2008 15:27:25 -0500
Message-ID: <20080127202725.GA2545@mit.edu>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <479C9E13.8040209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34837 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752449AbYA0U1o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2008 15:27:44 -0500
Content-Disposition: inline
In-Reply-To: <479C9E13.8040209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 27, 2008 at 09:06:59AM -0600, Eric Sandeen wrote:
> 
> * Tue Nov 15 2005 jblunck@suse.de
> - added close.patch provided by Ted Tso (IBM) to fix bug #132708

Hmm, yes, I had forgotten about the changelog in the spec file.  I'm
used to the kernel patch convention of *detailed* comments in the
patch file itself.


> *grin* Maybe obsolete by now?  haven't looked closely.

I can't tell.  Looks like my SuSE bugzilla account was flushed,
probably when it was merged with some central Novell authentication
system.  I created a new account, but "You are not authorized to view
bug #132708".  I tried searching the IBM LTC bugzilla, and turned up
nothing there, as well as the SCM logs for e2fsprogs --- and it's my
general practice that when I fix bug reported through either Red Hat
or Novell, that I include the Red Hat/SuSE/LTC bugzilla numbers in the
changelog.

The patch makes no sense, in any case, since super_shadow gets set a
few line laters, so the patch as it stands is either a no-op (assuming
a smart enough GCC), or wastes a few bytes of text segment space.

> > Patch12:        e2fsprogs-mkinstalldirs.patch
> > 
> > Why?
> > 
> 
> Probably same as why we have something similar; for one reason or other
> need to rerun autoconf, and e2fsprogs isn't compatible with latest
> autoconf.  (This is a patch I inherited, and haven't yet investigated
> all the details)

Define "latest autoconf"?  I'm using autoconf 2.61, which is
reasonably up-to-date.  Can you send me the output of config.status,
so I can see what it's setting @MKINSTALLDIRS@ to?

> > Patch22:        e2fsprogs-1.40.4-uuidd_pid_path.patch
> > 
> > The problem with this patch is that /var/run is cleared via rm -rf, so
> > it is highly problamtic to put the scratch directory for uuidd in
> > /var/run.
> 
> Hm, I had similar issues with uuidd too - common theme here?

What issues?  I thought you agreed that using /var/lib was the best
approach for now.  The Novell patch moves it back to /var/run, which
will cause significant problems if uuidd is run setuid to a non-root
user.

> > Patch32:        libcom_err-no-e2fsck.static.patch
> > 
> > This patch does two completely unrelated things.  One is to disable
> > the libcom_err regression test suite (probably because some of the
> > other changes made) and the other is to disable building the
> > e2fsck.static file.  Why these two are bundled into a single patch I'm
> > not sure.
> 
> And I have a patch to do the latter as well.  Interesting how we've
> arrived at similar needed changes, independently.  :)

Yeah, I'll check in a change so that e2fsck is built dynamically by
default, and e2fsck.static is only built if it is explicitly
requiested via --enable-static-e2fsck.

> and Patch99:        e2fsprogs-no_cmd_hiding.patch
> 
> honestly I like that; I should whip up a nice patch to emulate kbuild,
> with V=1 or something, unless there is some other easy way to show full
> build commands already?

Yes, a way to do kbuild with V=1 would be nice.  The main thing that
makes this difficult is that I've tried to make e2fsprogs not rely on
any GNU make'isms, since it builds on a number of non-Linux platforms,
including *BSD, MacOS, Solaris, etc. 

Personally, it's not a big deal; whenever I need to see what is going
on, I just edit the makefile and quickly remove the '@' signs.  It's
really not that hard, and it's rare that I need to look at things.  Of
course, that could be because I'm more familiar with e2fsprog's build
system.  :-)

					- Ted
