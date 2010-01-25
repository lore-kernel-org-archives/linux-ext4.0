From: tytso@mit.edu
Subject: Re: [PATCH -V2] ext4: unmap the underlying metadata when
 allocating blocks via fallocate
Date: Mon, 25 Jan 2010 12:55:12 -0500
Message-ID: <20100125175512.GC28459@thunk.org>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1262805762-6862-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <4B4F4DB7.1070501@redhat.com>
 <87wrzklesd.fsf@linux.vnet.ibm.com>
 <20100124182445.GA4372@thunk.org>
 <87k4v6py3e.fsf@linux.vnet.ibm.com>
 <20100125090243.GA28459@thunk.org>
 <4B5DBC15.9030004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36123 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab0AYRz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jan 2010 12:55:29 -0500
Content-Disposition: inline
In-Reply-To: <4B5DBC15.9030004@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 09:43:17AM -0600, Eric Sandeen wrote:
> > Aneesh Kumar K.V (3):
> >       ext4: Handle -EDQUOT error on write
> >       ext4: Fix quota accounting error with fallocate
> >       ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag
> 
> You may wish to add the patch from Jiaying (via me) as well, to handle
> the blocks-past-eof case, if it's had sufficient review.

I'm going to merge it, but I only want to push regressions to Linus at
this stage.  We can add the blocks-past-EOF for the next merge window,
and mark it for merging via -stable, but it's really late for
non-regression bug fixes at this point.

					- Ted
