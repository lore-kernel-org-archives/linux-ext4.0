From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 13:29:59 -0400
Message-ID: <yq14ocep23s.fsf@sermon.lab.mkp.net>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com>
	<6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca>
	<alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com>
	<4CC175E6.5000700@gmail.com>
	<alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC19BC2.9010503@gmail.com>
	<alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com>
	<4CC1A3AA.6040004@gmail.com> <4CC1AFD2.2020803@redhat.com>
	<4CC1B094.3090403@gmail.com> <yq18w1qp3bl.fsf@sermon.lab.mkp.net>
	<4CC1C664.90109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, tytso@mit.edu
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:31376 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756447Ab0JVRbn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 13:31:43 -0400
In-Reply-To: <4CC1C664.90109@gmail.com> (Ric Wheeler's message of "Fri, 22 Oct
	2010 13:14:12 -0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:

Ric> I think that the T13 people are still reworking (or have just
Ric> finished?)  the spec. For example,

ACS-2 is pretty much set in stone (it's in ballot). The trim bits
haven't changed for quite a while and we're compliant with the latest
draft.

-- 
Martin K. Petersen	Oracle Linux Engineering
