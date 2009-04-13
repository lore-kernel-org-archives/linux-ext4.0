From: "Ricardo M. Correia" <Ricardo.M.Correia@Sun.COM>
Subject: Re: [PATCH e2fsprogs] Add ZFS detection to libblkid
Date: Mon, 13 Apr 2009 20:18:45 +0100
Message-ID: <1239650325.18123.35.camel@localhost>
References: <1212171647.7508.46.camel@localhost> <49D6C844.5070604@redhat.com>
 <49D75AD1.7060101@redhat.com> <20090404212507.GC3199@webber.adilger.int>
 <1239045758.7486.80.camel@localhost> <49DA6283.6030800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Cc: Andreas Dilger <adilger@Sun.COM>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Karel Zak <kzak@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:46525 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZDMTTD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 15:19:03 -0400
Received: from fe-emea-10.sun.com (gmp-eb-lb-2-fe3.eu.sun.com [192.18.6.12])
	by gmp-eb-inf-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n3DJImli023446
	for <linux-ext4@vger.kernel.org>; Mon, 13 Apr 2009 19:19:00 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java(tm) System Messaging Server 7.0-5.01 64bit (built Feb 19 2009))
 id <0KI200E0003WHH00@fe-emea-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 13 Apr 2009 20:18:48 +0100 (BST)
In-reply-to: <49DA6283.6030800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

On Seg, 2009-04-06 at 13:13 -0700, Eric Sandeen wrote: 
> Can you perhaps just chime in on these bugs & ask?  you speak zfs better
> than I do...
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=494070
> https://bugzilla.redhat.com/show_bug.cgi?id=490795

Sorry for taking a while to get back to you.

I've just looked at these bugs and everything seems to make more sense
now. Those partitions are actually Solaris partitions, which contain
their own partition table inside.

So in bug 494070, the /dev/sda2 partition is internally subdivided into
what Solaris calls "slices" (which are similar to partitions) and then
the root ZFS pool/filesystem is stored inside one of these slices. So in
fact, the ZFS pool is not directly in /dev/sda2, it's somewhere inside
it. This is why the ZFS magic numbers don't seem to be in the right
place.

These slices don't seem to be visible to that Linux system, which I
suspect is due to the kernel not being compiled with Solaris partition
table support. If it were, other partitions (including the ZFS one)
would show up (if my assumption is correct).

So from looking at the libblkid magic offsets, it seems that ext3 magic
value is stored between 1K-2K, which means that it will fall into the
boot slice, not in the ZFS slice. So AFAICS this bug doesn't have
anything to do with ZFS, i.e., the same thing would happen if the root
filesystem of the OpenSolaris installation was UFS.

It'd be nice if OpenSolaris zeroed the boot slice when it is installed,
but on the other hand, should the Anaconda installer fail just because
it can't mount a (possibly corrupted/leftover) filesystem?

I can file a bug for OpenSolaris if you feel strongly about this.

Thanks,
Ricardo


