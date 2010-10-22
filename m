From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] e2fsck: Discard free data and inode blocks.
Date: Fri, 22 Oct 2010 20:01:53 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1010221958440.3007@dhcp-lab-213.englab.brq.redhat.com>
References: <1287670556-23460-1-git-send-email-lczerner@redhat.com> <6388FD2D-50A8-42B9-A955-3824451ACBF4@dilger.ca> <alpine.LFD.2.00.1010221059490.3007@dhcp-lab-213.englab.brq.redhat.com> <4CC175E6.5000700@gmail.com> <alpine.LFD.2.00.1010221335080.3390@dhcp-lab-213.englab.brq.redhat.com>
 <4CC19BC2.9010503@gmail.com> <alpine.LFD.2.00.1010221620490.3390@dhcp-lab-213.englab.brq.redhat.com> <4CC1A3AA.6040004@gmail.com> <386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ric Wheeler <ricwheeler@gmail.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab0JVSCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Oct 2010 14:02:00 -0400
In-Reply-To: <386E61B0-BF4D-4F96-9541-A614F63DE808@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 22 Oct 2010, Andreas Dilger wrote:

> On 2010-10-22, at 08:46, Ric Wheeler wrote:
> > On 10/22/2010 10:32 AM, Lukas Czerner wrote:
> >> 
> >> Also there is a big win, when discard
> >> also zeroes data, because in that case we can just skip inode table
> >> initialization (zeroing) without any need of in-kernel lazyinit code
> >> enabled. And we get all this for free. It was introduced with Sandeens
> >> patch:
> >> 
> >> http://marc.info/?l=linux-ext4&m=128234048208327&w=2
> >> 
> >> So, I would rather leave it on by default.
> > 
> > You cannot 100% depend on discard zeroing blocks - that is not a universal requirement of devices that support it. Specifically, for ATA devices, I think that there are optional bits that specify how a device will behave when you read from a trimmed region.
> 
> That patch also checks for the zeroing feature.  When this patch was first under discussion, I proposed that we validate that the device is actually zeroed by doing a write a non-zero block to the disk and then calling discard+zero for that region, and reading back the block and verifying it.
> 
> Eric wasn't convinced that was necessary, maybe you can convince him more...
> 
> Cheers, Andreas

One of the counter arguments was, that some devices does not preserve
this behavior through power cycles. I think Ted was the one talking
about that.

-Lukas
