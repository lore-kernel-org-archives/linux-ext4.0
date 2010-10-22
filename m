From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 17:19:16 -0400
Message-ID: <yq1sjzyncx7.fsf@sermon.lab.mkp.net>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>
	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>
	<4CC175E6.5000700@gmail.com>
	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC19BC2.9010503@gmail.com>
	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC1A3AA.6040004@gmail.com>
	<386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca>
	<alpine.LFD.2.00.1010221958440.3007@dhcp-lab-213.englab.brq.redhat.com>
	<6C34898A-508C-4140-A494-B279C04EDD50@dilger.ca>
	<4CC1D694.3040006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:41271 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab0JVVUy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 17:20:54 -0400
In-Reply-To: <4CC1D694.3040006@gmail.com> (Ric Wheeler's message of "Fri, 22
	Oct 2010 14:23:16 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:

Ric> Just to further confuse things, if we just want to zero a device,
Ric> there is the (relatively old) WRITE_SAME command that arrays
Ric> use. Note that it is quite a bit faster than doing this from the
Ric> server since you only transfer over one block of data and the disk
Ric> firmware does the rest - no data transfer for each block once you
Ric> start.

Ric> It can certainly take a long, long time, but would be faster than
Ric> zeroing a drive with write() system calls :)

I took some stabs at this in the spring. And while it looked like a good
idea on paper it turned out not to be a huge win unless the FC link was
heavily congested due to traffic to other devices.

First of all many drives have a cap on the maximum number of blocks
that can be written using one WRITE SAME command. Typically you can only
write 16-32 megs at a time. So I needed to have a bunch of magic to
scale down and retry while attempting to find the sweet spot.

Fred tried to convince T10 that it would be nice to have a field in the
block limits VPD that would indicate the max WRITE SAME blocks a device
supported. But T10 thought that was a bad idea and the proposal was
rejected. Otherwise I would have wired that up and we could have handled
generic WRITE SAME like we do the discard case.

The other problem is that the WRITE SAME may take a looong time. And so
we need special timeouts in place to prevent regular error handling from
kicking in while the drive is busy wiping stuff.

I guess we could just pick a number (16 MB, maybe) and define that as
the max. Picking a low number also has the benefit of being less likely
to interfere with timeouts.

If there's interest I'll be happy to revisit my patches...

-- 
Martin K. Petersen	Oracle Linux Engineering
