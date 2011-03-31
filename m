From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: breaking ext4 to test recovery
Date: Thu, 31 Mar 2011 17:44:16 -0500
Message-ID: <4D9503C0.8080804@redhat.com>
References: <25B374CC0D9DFB4698BB331F82CD0CF20D61B8@wdscexbe08.sc.wdc.com> <4D91E39A.3000800@redhat.com> <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaWoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Mar 2011 18:44:21 -0400
In-Reply-To: <6617927D-7C9C-4D02-97FD-C9CC75609448@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/31/11 5:21 PM, Andreas Dilger wrote:

> We have a kernel patch "dev_read_only" that we use with Lustre to
> disable writes to the block device while the device is in use.  This
> allows simulating crashes at arbitrary points in the code or test
> scripts.  It was based on Andrew Morton's test harness that he used
> for ext3 recovery testing back when it was being ported to the 2.4
> kernel.
> 
> http://git.whamcloud.com/?p=fs/lustre-release.git;a=blob_plain;f=lustre/kernel_patches/patches/dev_read_only-2.6.32-rhel6.patch;hb=HEAD
>
>  The best part of this patch is that it works with any block device,
> can simulate power failure w/o any need for automated power control,
> and once the block device is unused (all buffers and references
> dropped) it can be re-activated safely.

It won't simulate a lost write cache though, will it?

-Eric
