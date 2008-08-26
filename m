From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 19:32:25 -0400
Message-ID: <20080826233224.GB29936@mit.edu>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59971 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbYHZXc1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 19:32:27 -0400
Content-Disposition: inline
In-Reply-To: <20080826204737.GM6029@nb.net.home>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 10:47:37PM +0200, Karel Zak wrote:
>  There is worse scenario (thanks to Milan Broz from DM camp):
> 
>  dmsetup create x --table "0 100 linear /dev/sdb 0"
>  dmsetup create y --table "0 100 linear /dev/mapper/x 0"
>  dmsetup create z --table "0 100 linear /dev/mapper/y 0"
> 
>  # dmsetup ls --tree
>   z (254:3)
>   `-y (254:2)
>     `-x (254:1)
>       `- (8:16)
> 
>  it means all these devices are exactly same, but
> 
>     mount LABEL=foo
> 
>  has to mount /dev/mapper/z (from top of the tree). The sdb, x and
>  y should be invisible for the mount(8).

Sure, but consider what happens when you create a snapshot (either
read-only or read-write) of an existing filesystem?  In that case,
both the parent and the child filesystem is mountable, and if the
child filesystem is transient, the praent one may not want to be
transient.

In fact, suppose the scenario is a virtualization scenario, where you
create the parent, create child snapshots, then use "tune2fs -U random
-L virt1 /dev/mapper/snap1" ; "tune2fs -U random -L virt2
/dev/mapper/snap2" and so on, so each of the child snapshots have
their own independent identity separate from the parent, it may very
*well* be the case that the parent device should be visible to mount.

I don't think we can make the general argument that the leaf device is
always mountable, and anything above it is *never* mountable.  Maybe
that's the default, but it's certainly not always true.

I'm beginning the right answer is we need some assist from the device
mapper infrastructure, where when we create the device mapper device,
we specify whether or not it is mountable, and this information is
made available somehow, either by trying to sneaking it into
/proc/partitions (which will be tricky without breaking legacy
programs), or by making it visible in /sys.

>  I think we can ignore this minor problem for now. I'll try to found a
>  better solution for dependencies resolution without libdevmapper. My
>  wish is to avoid libdevmapper in libfsprobe.

Speaking of which, what is your plan for caching versus non-caching in
libfsprobe?  It seems to me that if you are going to be caching,
you'll just be re-inventing blkid.  If you don't cache, you'll either
(a) have to iterate over all possible devices, which is what we did
before blkid (it was Ric Wheeler pointed out to me this problem and I
wrote blkid in response to his request, because it becomes a problem
if you have hundred of LUN's getting exported by a large EMC storage
array :-), or (b) do what vol_id does, which is depend on
/dev/disk/by-label and /dev/disk/by-uuid, which has the charming
Windows-like attribute of not getting updated until the next reboot
--- which means after you create a new filesystem or swap device on an
existing device, or change a label or UUID using tune2fs, vol_id never
notices until the next reboot or until you physically unplug and
reinsert the device.

Or is the answer that you expect libfsprobe to only do filesystem
type, uuid, and label detection, and not solve the "find a device
given a uuid/label" problem?

> > This does work, because we do find the /dev/mapper name via a
> > brute-force search of /dev looking for a matching devno when we call
> > blkid_devno_to_devname().  What I *can* do is do a special search of
> > /dev/mapper first, but instead of looking for /dev/mapper/<ptname>, to
> > do a readdir search of /dev/mapper looking for the matching devno.
> 
>  Not elegant, but... good enough :-)
> 
>  It would be nice to have /sys/block/dm-N/name where you can translate
>  the internal dm-N name to the real device name. Alasdair? Milan? :-)

Or maybe the right answer is /proc/partitions should only export
devicemapper devices that are "supposed" to be visible to mount, and
instead of exporting dm-0, dm-1...., we export the real name via
/proc/partitions?  Or do you not want to have the user-visible name
get pushed into the kernel?

						- Ted
