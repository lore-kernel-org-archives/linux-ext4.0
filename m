From: tytso@mit.edu
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when
 allocating blocks via fallocate
Date: Mon, 25 Jan 2010 04:02:43 -0500
Message-ID: <20100125090243.GA28459@thunk.org>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <4B4F4DB7.1070501@redhat.com>
 <87wrzklesd.fsf@linux.vnet.ibm.com>
 <20100124182445.GA4372@thunk.org>
 <87k4v6py3e.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, cmm@us.ibm.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51607 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0AYJCy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 04:02:54 -0500
Content-Disposition: inline
In-Reply-To: <87k4v6py3e.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:42:05AM +0530, Aneesh Kumar K. V wrote:
> My goal was to see if we can drop the BH_New flag when returning
> preallocated blocks. But now i look at it again i guess you don't need
> to take this patch. We cannot unmap underlying meta data during
> fallocate because even if we remove the old mapping for the blocks,
> we could reboot and later somebody(e2fsprogs) can directly read the blocks
> and create a bh with old data. So i guess we should be doing
> unmap_underlying_blocks when we are returning blocks to userspace or
> when we actually zero out blocks.

OK, so I'll drop this patch from the patch queue, and will do a full
test run (XFSQA -g auto using both 1k and 4k block sizes) of the
following patches:

Aneesh Kumar K.V (3):
      ext4: Handle -EDQUOT error on write
      ext4: Fix quota accounting error with fallocate
      ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag

Of all of the patches in the ext4 patch queue, these seem to be the
ones which need to be urgently pushed to Linus before 2.6.33.

Any objections, or nominations for other patches that should go in
before 2.6.33, please speak up now...

						- Ted
