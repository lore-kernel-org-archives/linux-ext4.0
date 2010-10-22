From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 13:23:36 -0500
Message-ID: <4CC1D6A8.6080000@redhat.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>	<4CC175E6.5000700@gmail.com>	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>	<4CC19BC2.9010503@gmail.com>	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>	<4CC1A3AA.6040004@gmail.com> <4CC1AFD2.2020803@redhat.com>	<4CC1B094.3090403@gmail.com> <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686Ab0JVSXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:23:44 -0400
In-Reply-To: <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Martin K. Petersen wrote:
>>>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:
> 
>>> so we're not depending on it zeroing blocks, we're just depending on
>>> it advertising correctly whether or not it -does- zero.
> 
> If the relevant bits are set (ATA: DRAT and RZAT, SCSI: TPRZ) we'll set
> the bdev's discard_zeroes_data flag.
> 
> [root@test ~]# lsscsi | grep SSD | awk '{ print $7 }'
> /dev/sde
> [root@test ~]# grep . /sys/block/sde/queue/discard_zeroes_data 
> 1
> 
> The relevant ioctl is BLKDISCARDZEROES.

which is what that patch I pointed to uses, BTW...

I really think it's on firm footing here, we're not assuming
discard == zeroed data, we are checking whether the drive
reports exactly that behavior ...

-Eric
