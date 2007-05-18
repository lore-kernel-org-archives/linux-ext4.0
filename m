From: Theodore Tso <tytso@mit.edu>
Subject: Re: poor performance of mount due to libblkid
Date: Thu, 17 May 2007 23:20:13 -0400
Message-ID: <20070518032013.GA8363@thunk.org>
References: <20070509170646.C12805@cbr.shaptech.com> <20070510003005.GV6375@schatzie.adilger.int> <20070509234532.D12805@cbr.shaptech.com> <20070510064448.GA13450@thunk.org> <20070514164026.E12805@cbr.shaptech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
To: Shapor Naghibzadeh <shapor@shapor.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:36501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbXERDU3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 May 2007 23:20:29 -0400
Content-Disposition: inline
In-Reply-To: <20070514164026.E12805@cbr.shaptech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Sorry for the delay in getting back to you; I've been on travel this
past week, didn't have much time to keep completely up on e-mail.

On Mon, May 14, 2007 at 04:40:26PM -0500, Shapor Naghibzadeh wrote:
> My point with the USB example was that it keeps their labels around in a
> world-readable cache infinitely (or until a device with the same name gets
> mounted again).  Its probably not a security issue in most cases, but its
> clutter which one doesn't expect to stick around.

It's not a lot of clutter in practice.  

> > try to stat the device file, and if it doesn't exist, to skip parsing
> > the line together.  This would prevent blkid.tab from growing without
> > bound given your workload.
> 
> This idea of doing garbage collection every time blkid.tab is read destroys
> the cache if, for example, you mount /usr or /var before other block devices
> have been brought up.  AoE and nbd come to mind as a potentially large number
> of devices that might not exist until later in the boot process.

True, for nbd and AoE, that's a real problem.  And certainly there's
no guarantee that device mapper nodes will be created from the beginning.

> > The whole point of blkid.tab file was so that having searched all of
> > the devices to find the particular filesystem with a specified volume
> > label or UUID, that all of the information that was gathered doesn't
> > have to be searched a next time you need to do a mount-by-uuid or
> > mount-by-label.  And if you have a large number of disks that you
> > might have to potentially spin up, you definitely want to keep this
> > cache across boots, which is why we store it in /etc/blkid.tab.
> 
> Ok, but why do we bother caching the filesystem type?  The desire to optimize
> the scanning for UUIDs or labels is indeed a real problem, but caching the
> filesystem type has the potential for introducing bugs and doesn't seem to
> have any real payoff.  I for one have been bitten by the ext2 to ext3 upgrade
> bug more than once.

First of all, what ext2 to ext3 upgrade bug?  What version of blkid/e2fsprogs
are you using?   It works just fine for me:

# blkid /dev/loop0
/dev/loop0: UUID="cc211710-904a-48a4-9073-c84821963931" TYPE="ext2" 
# tune2fs -O has_journal /dev/loop0
tune2fs 1.40-WIP (14-Nov-2006)
Creating journal inode: done
This filesystem will be automatically checked every 30 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# blkid /dev/loop0
/dev/loop0: UUID="cc211710-904a-48a4-9073-c84821963931" SEC_TYPE="ext2" TYPE="ext3" 
# tune2fs -O ^has_journal /dev/loop0
tune2fs 1.40-WIP (14-Nov-2006)
# blkid /dev/loop0
/dev/loop0: UUID="cc211710-904a-48a4-9073-c84821963931" TYPE="ext2" 

As far as caching the filesystem type, the goal was to cache
everything, since you never know when you might need the information,
since doing an exhaustive search could be quite expensive.  So we want
to cache the label and UUID information whenever we get our hands on
it --- and as it turns out, in order to get the filesystem type,
getting the label and UUID information comes for free, and contrawise,
in order to get the label and UUID information, you need to know the
filesystem type first, so you know where to find label and UUID
information.

Hence, it makes sense for blkid to know how to find the filesystem
type information, and in the process of gathering the filesystem type
information, it is prudent to the cache the UUID and LABEL information
if it is present.  After all, if doing so avoids needing to do a brute
force search of all of the devicesin the system, it is a net win.

> There should be a better way of maintaining a UUID and label cache other than
> having mount keep an XML cache in /etc (which seems to violate the Linux
> filesystem hierarchy standard).  

Well, the problem is that /var might not be mounted, and in some
applications, it might itself be located on the SAN network.  One of
the customers that I am working with is doing precisely that, with the
blades booting and storing all of their filesystems across a SAN
filesystem network.  

A certain amount of bootstrapping information in /etc is certainly
within the sprit of the Linux FHS, and if the root is read-only, it is
not a disaster, since the blkid code can handle that case by simply
not relying on the cache.  Basically, you have to store the
information somewhere, and /etc is the only place that is guaranteed
to be around when the system is initially coming up.  

> The first and safest step would seem to be removing the use of blkid.tab from
> mount except when trying to mount by UUID or volume label to prevent the
> performance issue when the cache is large.  I think garbage collection is more
> complex to do safely and the whole approach might some re-thinking.

I agree that mount should be patched to only read in the blkid
information when the blkid library needs to be consulted.  I disagree
that we shouldn't be caching caching the label and UUID information
when it is discovered as a side effect of doing a filesystem type
detection; it could be useful later.  

Probably the right answer is to have an explicit blkid GC operation,
callable either from the blkid library API, or via /sbin/blkid -g.
This could be called by the init scripts once the system has been
brought fully up, or at some other point when a system application
finds that it is necessary.

Fundamentally, I think the use case that your application brought up
where vast number of devices are created and then destroyed is unique
enough that if your application needs to explicit request a garbage
collection operation, that is an acceptable thing to require of it; it
is doing something very, very, strange, after all.

						- Ted
