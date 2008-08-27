From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 21:21:21 -0400
Message-ID: <20080827012121.GD29936@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home> <20080826233224.GB29936@mit.edu> <20080827001942.GN6029@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:56825 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386AbYH0BVX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 21:21:23 -0400
Content-Disposition: inline
In-Reply-To: <20080827001942.GN6029@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 27, 2008 at 02:19:42AM +0200, Karel Zak wrote:
> 
>  That's misunderstanding. I'm talking about LABEL/UUId resolution
>  where we need *priorities* for duplicate tags. I think dep-tree is
>  good enough for this purpose.

OK, so what you're saying is that that a leaf dm-device is always more
important (and should therefore have a higher priority) than a
non-leaf device.

But I'm not sure that is *still* not always the right thing to do.
Suppose someone creates a snapshot of a device in order to run e2fsck,
or to do create a coherent snapshot.  Now suppose the machine crashes
while the snapshot still exists; even though the read-only snapshot is
the "leaf" device, you don't want to try use that snapshot to be
mounted as the root filesystem.

There are a number of solutions of course --- most of which do not
require adding more smarts into blkid (or some other probing library).
We could make the scripts that create the snapshots update the UUID
and LABEL of the snapshot, although that means adding some kind
filesystem-specific hook to lvcreate.  Or we could create the concept
of "ephemeral snapshots" that don't survive a reboot.  Or we could try
to mark certain LVM volumes with explicit priorities that would be
pulled into blkid (possibly via the dm interfaces).  Or we could try
to put a lot of that smarts into the blkid library.

Personally, I like the idea of emphermal snapshots as the best
system-wide solution, but the point is we need to think about this not
from a single component's point of view, but what is the best solution
from a systems perspective.

>  Both. I think you remember our (+ Kay Sievers) discussion about it.
>  We need a library which provides both ways. The smart way (cache,
>  dependencies, ...) for mount(8) and others standard utils, and the
>  low-level way for udev (no cache, direct FS probing, ...).

Sure, but if that's the case, we already have most of the "smart way"
from blkid.  What's the point of making fsprobe re-invent the caching
solution?   I could just point blkid at fsprobe.

>
>  What about fix mkfs tools and send relevant events to udev?
> 

Well, for one, it means changing every single mkfs/mkswap/tune*fs
program on the system; so it seems more than a bit of kludge.
Sometimes these tools are run by an unprivileged user, so there are
some security problems have to be carefully thought out.  Obviously
you can't just tell udev the new label and uuid, since the source
might be untrusted.  The userspace program send an event to udevd that
a device has changed, but that means that you have to allow an
unprivileged process to kick udevd and then reprobe a device, which
means there is a possibility of a denial of service attack.  It also
makes it easier to exploit any potential buffer overrun, since the
attacker can now set up the buggered block device image and then
politely ask udev to call fsprobe (possibly running with root prives)
to access the attack image.

Of course, if there is a security bug in a filesystem probing code,
we're in deep trouble if there are user-writable devices.  A push
model just means that the fs probing code can get triggered at a time
of the attacker's choosing, as opposed at some point in the future.

I also don't think it's realistic to assume that we can sweep through
all of the possibile tool that creates or modifies filesystem/swap
superblocks in order for the tool to work correctly.  If a tool sends
a hint that to udev so that the cache and /dev/disk/* can get updated,
that may be fine; but we shouldn't be dependent on that hint.  (And
maybe system administrators or security officers will have policies
not allowing non-privileged users running the tool to send that hint.)

BTW, I think /dev/disk/by-label is a really nasty idea.  Suppose you
have hundreds of LUN's and/or device mapper devices.  Now suppose we
change the label, or become aware that the label of a device has
changed.  Right now, if you don't know the previous label (which will
often be the case), the only way to install the new label and remove
the old label is to iterate over all of the symlinks in
/dev/disk/by-label and calling readlink() on each one.  It's
convenient and maybe it's a nice to have on disktop systems, but if
you have a huge number of devices, it's not very scalable at all.

    	     		    	  	      - Ted
