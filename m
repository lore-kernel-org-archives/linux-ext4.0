From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Tue, 26 Aug 2008 22:47:37 +0200
Message-ID: <20080826204737.GM6029@nb.net.home>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbYHZUrm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 16:47:42 -0400
Content-Disposition: inline
In-Reply-To: <20080826144721.GD8720@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 10:47:21AM -0400, Theodore Tso wrote:
> On Tue, Aug 26, 2008 at 03:51:02PM +0200, Karel Zak wrote:
> >  Well, I see few problems:
> > 
> >  * /proc/partitions containing internal dm device names (e.g. dm-0).
> >    The libdevmapper provides translation from internal to the "real"
> >    names (e.g /dev/mapper/foo). I guess (hope:-) /sys provides the
> >    real names too.
> 
> You're right.  So seaching for /dev/mapper/dm-n doesn't make any
> sense; adding /dev/mapper to the dirlist doesn't help, and in fact is
> a waste of time.  However, the patch actually *did* work, and the
> reason why it does is because we are also are searching /dev/mapper by
> device number, and so we are finding the device name that way.

 OK.

> I don't think you mean multipath support in terms of where there are
> multiple paths to the same physical device ala fiber channel, but

 Ignore this point. You are right. The physical devices are slaves to
 the final DM device (when dm-multipath is on). BTW, I look forward to
 see multiple paths vs. udev (e.g. /dev/disk/by-* ) :-)

> What we don't solve is the problem where one devicemapper device is
> used to build another device mapper device.  This could happen in a
> number of circumstances.  You might have some wierd circumstance where
> /dev/mapper/part1 and /dev/mapper/part2 are glued together to make
> /dev/mapper/whole-filesystem.  Why you might do this instead of simply
> using something like lvextend is beyond me, but that is something
> legitimate can be done with the low-level device mapper primitives.

 There is worse scenario (thanks to Milan Broz from DM camp):

 dmsetup create x --table "0 100 linear /dev/sdb 0"
 dmsetup create y --table "0 100 linear /dev/mapper/x 0"
 dmsetup create z --table "0 100 linear /dev/mapper/y 0"

 # dmsetup ls --tree
  z (254:3)
  `-y (254:2)
    `-x (254:1)
      `- (8:16)

 it means all these devices are exactly same, but

    mount LABEL=foo

 has to mount /dev/mapper/z (from top of the tree). The sdb, x and
 y should be invisible for the mount(8).

> But, #1, there are times when picking a leaf dm device over a non-leaf
> dm device is not the right thing to do (which would be the case when
> you make a live snapshot of a filesystem), and #2, your patch only
> checks non-leaf dm devices for non-dm devices, probably because of #1.
> 
> So with both of our patches, we have the problem where we could pick
> the wrong dm device if the user builds one dm device on top of another

 I don't think so. The dm_probe_all() function never returns any
 DM device which is slave to any other device. It means it always
 returns the device from top of the hierarchy.

 All devices from dm_probe_all() have greater priority than other
 stuff from /proc/partitions (for example dm-N devs).

 So back to your example...

 /dev/mapper/part1 + /dev/mapper/part2 = /dev/mapper/whole-filesystem

 the /dev/mapper/part1 and /dev/mapper/part2 will be visible for the
 library (e.g. blkid.tab), but with *smaller priority* than
 /dev/mapper/whole-filesystem.

 In your non-libdevmapper implementation you need to check
 /sys/block/dm-N/holders/ and prefer devices without holders.

 I think we can ignore this minor problem for now. I'll try to found a
 better solution for dependencies resolution without libdevmapper. My
 wish is to avoid libdevmapper in libfsprobe.

> > > +	if (dev) {
> > > +		if (pri)
> > > +			dev->bid_pri = pri;
> > > +		else if (!strncmp(dev->bid_name, "/dev/mapper/", 11))

 what about "if (major(devno) == DMMAJOR)" rather than strcmp()?

> > > +			dev->bid_pri = BLKID_PRI_DM;
> > 
> >  the same problem
> 
> This does work, because we do find the /dev/mapper name via a
> brute-force search of /dev looking for a matching devno when we call
> blkid_devno_to_devname().  What I *can* do is do a special search of
> /dev/mapper first, but instead of looking for /dev/mapper/<ptname>, to
> do a readdir search of /dev/mapper looking for the matching devno.

 Not elegant, but... good enough :-)

 It would be nice to have /sys/block/dm-N/name where you can translate
 the internal dm-N name to the real device name. Alasdair? Milan? :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
