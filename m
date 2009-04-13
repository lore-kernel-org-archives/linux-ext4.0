From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 13 Apr 2009 14:27:19 -0500
Message-ID: <49E39217.60200@redhat.com>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com> <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int> <1239045758.7486.80.camel@localhost> <49DA6283.6030800@redhat.com> <1239650325.18123.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@Sun.COM>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:58752 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDMT1Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Apr 2009 15:27:25 -0400
In-Reply-To: <1239650325.18123.35.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ricardo M. Correia wrote:
> Hi Eric,
> 
> On Seg, 2009-04-06 at 13:13 -0700, Eric Sandeen wrote: 
>> Can you perhaps just chime in on these bugs & ask?  you speak zfs better
>> than I do...
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=494070
>> https://bugzilla.redhat.com/show_bug.cgi?id=490795
> 
> Sorry for taking a while to get back to you.
> 
> I've just looked at these bugs and everything seems to make more sense
> now. Those partitions are actually Solaris partitions, which contain
> their own partition table inside.
> 
> So in bug 494070, the /dev/sda2 partition is internally subdivided into
> what Solaris calls "slices" (which are similar to partitions) and then
> the root ZFS pool/filesystem is stored inside one of these slices. So in
> fact, the ZFS pool is not directly in /dev/sda2, it's somewhere inside
> it. This is why the ZFS magic numbers don't seem to be in the right
> place.
> 
> These slices don't seem to be visible to that Linux system, which I
> suspect is due to the kernel not being compiled with Solaris partition
> table support. If it were, other partitions (including the ZFS one)
> would show up (if my assumption is correct).

It actually is compiled with that... but then we didn't look at
/proc/partitions (the kernel's view) in the bug but rather fdisk output,
which probably doesn't understand this at all.

> So from looking at the libblkid magic offsets, it seems that ext3 magic
> value is stored between 1K-2K, which means that it will fall into the
> boot slice, not in the ZFS slice. So AFAICS this bug doesn't have
> anything to do with ZFS, i.e., the same thing would happen if the root
> filesystem of the OpenSolaris installation was UFS.

ok, makes sense. (maybe blkid should recognize sda2 as being this
special sort of partition and stop there...)

> It'd be nice if OpenSolaris zeroed the boot slice when it is installed,
> but on the other hand, should the Anaconda installer fail just because
> it can't mount a (possibly corrupted/leftover) filesystem?

Generally, no; and anaconda now will not fail if the mount simply fails.
 But if the mount attempt results in a kernel oops there's not much
anaconda can do... the filesystem that attempts the mount should be
robust enough to not oops as well, of course...

> I can file a bug for OpenSolaris if you feel strongly about this.

Well, it's always nice to be able to recognize a partition; blkid just
can't do this reliably if some tools leave old signatures lying around.
 So zeroing it out would be the "polite" thing to do in any case.  :)

Thanks,
-Eric

> Thanks,
> Ricardo
> 
> 

