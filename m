From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 12:17:31 -0600
Message-ID: <6C34898A-508C-4140-A494-B279C04EDD50@dilger.ca>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC19BC2.9010503@gmail.com> <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC1A3AA.6040004@gmail.com> <386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca> <alpine.LFD.2.00.1010221958440.3007@dhcp-lab-213.englab.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ric Wheeler <ricwheeler@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu, sandeen@redhat.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:34905 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0JVSRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Oct 2010 14:17:33 -0400
In-Reply-To: <alpine.LFD.2.00.1010221958440.3007@dhcp-lab-213.englab.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-10-22, at 12:01, Lukas Czerner wrote:
>> That patch also checks for the zeroing feature.  When this patch was first under discussion, I proposed that we validate that the device is actually zeroed by doing a write a non-zero block to the disk and then calling discard+zero for that region, and reading back the block and verifying it.
>> 
>> Eric wasn't convinced that was necessary, maybe you can convince him more...
> 
> One of the counter arguments was, that some devices does not preserve
> this behavior through power cycles. I think Ted was the one talking
> about that.

Sure, I don't think we can handle every pathology, but doing a write/discard/read of a few blocks (when it has the potential to avoid many GB of writes for zeroing) is surely easy and worthwhile?

In any case, I thought that discussion was about a device that didn't report BLKDISCARDSZEROES=1, but only that a normal DISCARD would read back zero until the next restart?  That prevents optimizations like "read until we see non-zero data, then start writing zeroes", which would still be faster for many RAID devices (or older kernels that don't have DISCARD/ZERO support at all).

Cheers, Andreas





