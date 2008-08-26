From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 10:47:21 -0400
Message-ID: <20080826144721.GD8720@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52035 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756372AbYHZOrX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 10:47:23 -0400
Content-Disposition: inline
In-Reply-To: <20080826135102.GK6029@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 03:51:02PM +0200, Karel Zak wrote:
>  Well, I see few problems:
> 
>  * /proc/partitions containing internal dm device names (e.g. dm-0).
>    The libdevmapper provides translation from internal to the "real"
>    names (e.g /dev/mapper/foo). I guess (hope:-) /sys provides the
>    real names too.

You're right.  So seaching for /dev/mapper/dm-n doesn't make any
sense; adding /dev/mapper to the dirlist doesn't help, and in fact is
a waste of time.  However, the patch actually *did* work, and the
reason why it does is because we are also are searching /dev/mapper by
device number, and so we are finding the device name that way.


>  * we probably need to resolve dependencies for multi-path devices
>    where the same FS is accessable by more than one physical device.
>    If I good remember it was the original purpose for DM support 
>    in libblkid.
> 
>         # mount LABEL=blabla /mnt
> 
>    has to mount the "right" device. I guess that only DM is able to
>    answer which device is the "right" one ;-)

I don't think you mean multipath support in terms of where there are
multiple paths to the same physical device ala fiber channel, but
rather where are multiple devices which are built on each other,
right?  So where /dev/sda is used to create the LVM PV's, and so on,
right?

>    The /sys/block/<devname>/slaves/ provides information about
>    dependencies.
> 
>  I see these two things as critical for fsck, mount, ...

Right.  And here, we are solving the problem already in that we prefer
the /dev/mapper/* names over names like /dev/sda and /dev/sdb.  That's
what the priority field is all about.

What we don't solve is the problem where one devicemapper device is
used to build another device mapper device.  This could happen in a
number of circumstances.  You might have some wierd circumstance where
/dev/mapper/part1 and /dev/mapper/part2 are glued together to make
/dev/mapper/whole-filesystem.  Why you might do this instead of simply
using something like lvextend is beyond me, but that is something
legitimate can be done with the low-level device mapper primitives.

But, #1, there are times when picking a leaf dm device over a non-leaf
dm device is not the right thing to do (which would be the case when
you make a live snapshot of a filesystem), and #2, your patch only
checks non-leaf dm devices for non-dm devices, probably because of #1.

So with both of our patches, we have the problem where we could pick
the wrong dm device if the user builds one dm device on top of another
dm device.  (Although for transient devices, such as temporary
snapshots, if the permanent devices is already in /etc/blkid.tab, the
cache makes us win since we'll prefer the device already in the cache
file to the other.)

But in terms of making sure we pick the device mapper file over the
raw file, which is the 99.99% common case, we do the right thing, and
we can do the right thing without calling the devmapper library.

> > +/* Directories where we will try to search for device names */
> > +static const char *dirlist[] = { "/dev", "/dev/mapper", "/devfs", "/devices", NULL };
> 
> I think "/dev/mapper" does not make any sense here, ...because the
> names from /proc/partitions are in dm-<N> format, but the names in
> /dev/mapper uses different format.

Yep, I should remove that.

> > +	if (dev) {
> > +		if (pri)
> > +			dev->bid_pri = pri;
> > +		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11))
> > +			dev->bid_pri = BLKID_PRI_DM;
> 
>  the same problem

This does work, because we do find the /dev/mapper name via a
brute-force search of /dev looking for a matching devno when we call
blkid_devno_to_devname().  What I *can* do is do a special search of
/dev/mapper first, but instead of looking for /dev/mapper/<ptname>, to
do a readdir search of /dev/mapper looking for the matching devno.
That's merely an optimization, which doesn't really matter for Linux
since stat's are so fast.  But it's probably worth doing.

      	     	    	       	    	     	   - Ted
