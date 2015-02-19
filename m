From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Allocate entire range in zero range
Date: Thu, 19 Feb 2015 11:49:35 +1100
Message-ID: <20150219004935.GR4251@dastard>
References: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:65206 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754558AbbBSAti (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Feb 2015 19:49:38 -0500
Content-Disposition: inline
In-Reply-To: <1424278168-13711-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 18, 2015 at 05:49:28PM +0100, Lukas Czerner wrote:
> Currently there is a bug in zero range code which causes zero range
> calls to only allocate block aligned portion of the range, while
> ignoring the rest in some cases.
> 
> In some cases, namely if the end of the range is past isize, we do
> attempt to preallocate the last nonaligned block. However this might
> cause kernel to BUG() in some carefully designed zero range requests on
> setups where page size > block size.

Is there a regression test you could write to exercise these casesi
in future?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
