From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] filefrag: don't print extent header on bmap fallback
Date: Sat, 15 Aug 2009 23:50:32 -0400
Message-ID: <20090816035032.GD17958@mit.edu>
References: <4A7A4E68.3050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41350 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZHPDue (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Aug 2009 23:50:34 -0400
Content-Disposition: inline
In-Reply-To: <4A7A4E68.3050202@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 05, 2009 at 10:30:48PM -0500, Eric Sandeen wrote:
> The extent list header gets printed before we fall back to bmap:
> 
> # filefrag -v /mnt/test/bar
> Filesystem type is: 58465342
> File size of /mnt/test/bar is 12288 (3 blocks, blocksize 4096)
>  ext logical physical expected length flags <---- HERE
> Discontinuity: Block 2 is at 17 (was 16)
> /mnt/test/bar: 2 extents found
> 
> so delay printing it until we know fiemap is working.
> 
> (though ideally it'd be nice to have the same verbose output
> regardless of the interface we used, I think).

Thanks, applied.

					- Ted
