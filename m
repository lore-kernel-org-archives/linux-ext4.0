From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] ext4: Use our own write_cache_pages()
Date: Wed, 26 May 2010 08:42:59 +1000
Message-ID: <20100525224259.GM2150@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
 <1274784852-30502-4-git-send-email-david@fromorbit.com>
 <20100525130626.GD5556@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jens.axboe@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:52422 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753903Ab0EYWnK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 May 2010 18:43:10 -0400
Content-Disposition: inline
In-Reply-To: <20100525130626.GD5556@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 25, 2010 at 09:06:26AM -0400, tytso@mit.edu wrote:
> On Tue, May 25, 2010 at 08:54:09PM +1000, Dave Chinner wrote:
> > From: Theodore Ts'o <tytso@mit.edu>
> > 
> > Make a copy of write_cache_pages() for the benefit of
> > ext4_da_writepages().  This allows us to simplify the code some, and
> > will allow us to further customize the code in future patches.
> 
> I'm going to be pushing this to Linus shortly, so it's likely you'll
> be able to drop this from your patch series.

Great!

> I just wanted to give
> you a heads up about what I was planning on doing, which hopefully
> simplified your life a little.

And that's appreciated. I included it to make sure everyone could
see how this all fitted together and others could test it if they so
desired. i.e. make sure I wasn't breaking ext4 by reverting the
changes to write_cache_pages. I'll leave it in the series until the
ext4 change is upstream, then I'll drop it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
