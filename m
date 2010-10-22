From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 17:01:03 -0400
Message-ID: <yq1zku6ndrk.fsf@sermon.lab.mkp.net>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>
	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>
	<4CC175E6.5000700@gmail.com>
	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC19BC2.9010503@gmail.com>
	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC1A3AA.6040004@gmail.com>
	<386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31083 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0JVVCL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 17:02:11 -0400
In-Reply-To: <386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca> (Andreas
	Dilger's message of "Fri, 22 Oct 2010 11:50:40 -0600")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Andreas" == Andreas Dilger <adilger.kernel@dilger.ca> writes:

Andreas> When this patch was first under discussion, I proposed that we
Andreas> validate that the device is actually zeroed by doing a write a
Andreas> non-zero block to the disk and then calling discard+zero for
Andreas> that region, and reading back the block and verifying it.

The problem is that the devices that get this wrong don't
deterministically return zeroes.  So they may return zeroes for the
discarded test block but garbage for the stuff you actually depend on
being cleared.

-- 
Martin K. Petersen	Oracle Linux Engineering
