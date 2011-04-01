From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: breaking ext4 to test recovery
Date: Fri, 1 Apr 2011 17:26:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1104011724140.3151@dhcp-27-109.brq.redhat.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca> <4D9503C0.8080804@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andreas Dilger <adilger@dilger.ca>,
	Daniel Taylor <Daniel.Taylor@wdc.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795Ab1DAP0X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Apr 2011 11:26:23 -0400
In-Reply-To: <4D9503C0.8080804@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 31 Mar 2011, Eric Sandeen wrote:

> On 3/31/11 5:21 PM, Andreas Dilger wrote:
> 
> > We have a kernel patch "dev_read_only" that we use with Lustre to
> > disable writes to the block device while the device is in use.  This
> > allows simulating crashes at arbitrary points in the code or test
> > scripts.  It was based on Andrew Morton's test harness that he used
> > for ext3 recovery testing back when it was being ported to the 2.4
> > kernel.
> > 
> > http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD
> >
> >  The best part of this patch is that it works with any block device,
> > can simulate power failure w/o any need for automated power control,
> > and once the block device is unused (all buffers and references
> > dropped) it can be re-activated safely.
> 
> It won't simulate a lost write cache though, will it?

That's a very good question, I would like to know if there is any way at
all to force the device to drop the write cache. That would really help
the power failure testing filesystems.

-Lukas

> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
