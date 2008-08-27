From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] blkid: optimize dm_device_is_leaf() usage
Date: Wed, 27 Aug 2008 02:19:42 +0200
Message-ID: <20080827001942.GN6029@nb.net.home>
References: <1219697316-5632-1-git-send-email-kzak@redhat.com> <20080826122405.GA8720@mit.edu> <20080826135102.GK6029@nb.net.home> <20080826144721.GD8720@mit.edu> <20080826204737.GM6029@nb.net.home> <20080826233224.GB29936@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	mbroz@redhat.com, agk@redhat.com
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYH0ATu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Aug 2008 20:19:50 -0400
Content-Disposition: inline
In-Reply-To: <20080826233224.GB29936@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 26, 2008 at 07:32:25PM -0400, Theodore Tso wrote:
> On Tue, Aug 26, 2008 at 10:47:37PM +0200, Karel Zak wrote:
> >  There is worse scenario (thanks to Milan Broz from DM camp):
> > 
> >  dmsetup create x --table "0 100 linear /dev/sdb 0"
> >  dmsetup create y --table "0 100 linear /dev/mapper/x 0"
> >  dmsetup create z --table "0 100 linear /dev/mapper/y 0"
> > 
> >  # dmsetup ls --tree
> >   z (254:3)
> >   `-y (254:2)
> >     `-x (254:1)
> >       `- (8:16)
> > 
> >  it means all these devices are exactly same, but
> > 
> >     mount LABEL=foo
> > 
> >  has to mount /dev/mapper/z (from top of the tree). The sdb, x and
> >  y should be invisible for the mount(8).

 Well, s/invisible/less important/. Sorry.

> Sure, but consider what happens when you create a snapshot (either
> read-only or read-write) of an existing filesystem?  In that case,

 That's misunderstanding. I'm talking about LABEL/UUId resolution
 where we need *priorities* for duplicate tags. I think dep-tree is
 good enough for this purpose.

 The snapshot (or arbitrary other device) is mountable when you
 explicitly use device "mount /dev/mapper/the_snapshot".

> both the parent and the child filesystem is mountable, and if the
> child filesystem is transient, the praent one may not want to be
> transient.

[...]
> Speaking of which, what is your plan for caching versus non-caching in
> libfsprobe?  It seems to me that if you are going to be caching,

 Both. I think you remember our (+ Kay Sievers) discussion about it.
 We need a library which provides both ways. The smart way (cache,
 dependencies, ...) for mount(8) and others standard utils, and the
 low-level way for udev (no cache, direct FS probing, ...).

> you'll just be re-inventing blkid.  If you don't cache, you'll either

 Hehe.. I will directly copy code from blkid and vol_id. It's open
 source. I needn't re-inventing ;-)

> (a) have to iterate over all possible devices, which is what we did
> before blkid (it was Ric Wheeler pointed out to me this problem and I
> wrote blkid in response to his request, because it becomes a problem
> if you have hundred of LUN's getting exported by a large EMC storage
> array :-), or (b) do what vol_id does, which is depend on
> /dev/disk/by-label and /dev/disk/by-uuid, which has the charming
> Windows-like attribute of not getting updated until the next reboot

 What about fix mkfs tools and send relevant events to udev?

> >  It would be nice to have /sys/block/dm-N/name where you can translate
> >  the internal dm-N name to the real device name. Alasdair? Milan? :-)
> 
> Or maybe the right answer is /proc/partitions should only export
> devicemapper devices that are "supposed" to be visible to mount, and

 Yes, I have no clue why the dm-N crap is in /proc/partitions.
 Probably any legacy...

> instead of exporting dm-0, dm-1...., we export the real name via
> /proc/partitions?  Or do you not want to have the user-visible name
> get pushed into the kernel?

 I'm wrong person for these questions. DM guys are in CC: :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
