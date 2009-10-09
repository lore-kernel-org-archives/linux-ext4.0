From: Andy Isaacson <adi@hexapodia.org>
Subject: DMAR regression in 2.6.31 leads to ext4 corruption?
Date: Thu, 8 Oct 2009 23:17:29 -0700
Message-ID: <20091009061729.GA31242@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	iommu@lists.linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from straum.hexapodia.org ([64.81.70.185]:41390 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZJIGSH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Oct 2009 02:18:07 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

[resending to fit under vger's size limits, sorry if anybody gets this
twice.]

I'm testing DMAR support on 2.6.32 on Intel VT-d laptop platforms.  It
was pretty stable circa 2.6.31-rc5 (we have dozens of machines running
2.6.31-rc8), but in the last two weeks I've had a bunch of instability
on Linus' tip kernels that looked potentially like IOMMU badness.

For example,
<20090928191644.GR12922@hexapodia.org>
http://lkml.org/lkml/2009/9/28/201

Today while running 817b33d38 I got the following (on a Thinkpad X200
I'd replaced the Dell with, just in case it was previously-good hardware
going bad).

[   29.450550] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 79
[   30.022328] DRHD: handling fault status reg 3
[   30.022328] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.022328] DMAR:[fault reason 05] PTE Write access is not set
[   30.146136] DRHD: handling fault status reg 3
[   30.248938] DMAR:[DMA Write] Request device [00:02.0] fault addr ddae28000 
[   30.248939] DMAR:[fault reason 05] PTE Write access is not set

The full output of fsck and full dmesg are at the URL below.

I don't know that DMAR is resulting in my repeated filesystem
corruption, but it does seem like a potential cause (and would explain
why I'm seeing this whereas most people aren't, since few people are
using VT-d *and* i915).

I see that the BROKEN_GFX_WA code has been removed; do we actually
believe that the relevant code is working?  Could it be corrupting my
AHCI DMAs if not?  At the end of the last thread Ted thought that we'd
lost a write of an inode block; this time the symptoms look different,
in that I don't see one inode block representing a significant data
loss (though I'm by no means an expert).

Complete dmesg etc are at
http://web.hexapodia.org/~adi/bugs/20091008-ext4-dmar/

I'll try running with BROKEN_GFX_WA turned back on and see if that
improves things at all.

Thanks,
-andy
