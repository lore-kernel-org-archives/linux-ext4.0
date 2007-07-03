From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Teach do_mpage_readpage() about unwritten buffers
Date: Tue, 3 Jul 2007 13:52:27 +1000
Message-ID: <20070703035227.GS989688@sgi.com>
References: <20070703011019.GQ989688@sgi.com> <20070702202827.ffc59255.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
	xfs-oss <xfs@oss.sgi.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753615AbXGCDwg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jul 2007 23:52:36 -0400
Content-Disposition: inline
In-Reply-To: <20070702202827.ffc59255.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 02, 2007 at 08:28:27PM -0700, Andrew Morton wrote:
> On Tue, 3 Jul 2007 11:10:19 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> Seems sane, although one does wonder whether it's a worthy tradeoff.  We
> add additional overhead to readpage[s]() just to avoid some IO during
> mkswap?

It removes the hidden magic from XFS that hides unwritten extents
behind holes so that they get zero filled by readpages. With other
filesystems starting to use unwritten extents, these sorts of tricksy
hacks should be avoided and we should be explicitly handling unwritten
buffers just like we explicitly handle holes.

The side effect of this change is that other things (like sys_swapon)
behave sanely when faced with unwritten extents (i.e. they are not
detected incorrectly as holes).

FWIW, using unwritten extents for swap files means you can allocate
gigabytes of swap space on demand, even under severe memory pressure
because you don't need to write those gigabytes of data to disk.
Also, the only way to read the contents of the swap file is to go
directly to the underlying device so even if you screw up the
permissions on the swap file it will still always read as zeros.
So there are some benefits here....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
