From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 13:03:42 -0400
Message-ID: <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>
	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>
	<4CC175E6.5000700@gmail.com>
	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC19BC2.9010503@gmail.com>
	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC1A3AA.6040004@gmail.com> <4CC1AFD2.2020803@redhat.com>
	<4CC1B094.3090403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43577 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JVREZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 13:04:25 -0400
In-Reply-To: <4CC1B094.3090403@gmail.com> (Ric Wheeler's message of "Fri, 22
	Oct 2010 11:41:08 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:

>> so we're not depending on it zeroing blocks, we're just depending on
>> it advertising correctly whether or not it -does- zero.

If the relevant bits are set (ATA: DRAT and RZAT, SCSI: TPRZ) we'll set
the bdev's discard_zeroes_data flag.

[root@test ~]# lsscsi | grep SSD | awk '{ print $7 }'
/dev/sde
[root@test ~]# grep . /sys/block/sde/queue/discard_zeroes_data 
1

The relevant ioctl is BLKDISCARDZEROES.


Ric> I think that ATA devices have historically not done this correctly,

I'm only aware of one drive that advertised RZAT and got it wrong. I
believe a firmware update fixed it.

Generally we assume that if the firmware writers go through the effort
of reporting things correctly then they have also implemented the
feature. We have quite a few sanity checks in place in libata so we
won't trigger if the firmware guys just put all ones in a word, for
instance. There are several things that need to line up for us to
actually set the discard flags.


PS. http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
