From: Dave Chinner <david@fromorbit.com>
Subject: Re: Discard request and write counters
Date: Thu, 24 Mar 2011 10:40:20 +1100
Message-ID: <20110323234020.GH26611@dastard>
References: <alpine.LFD.2.00.1103231352250.1486@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Eric Sandeen <esandeen@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:39207 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932896Ab1CWXkd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 19:40:33 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103231352250.1486@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 23, 2011 at 02:07:40PM +0100, Lukas Czerner wrote:
> Hello,
> 
> I have noticed that we do treat discard requests (REQ_DISCARD) as write
> requests which is probably right, but it has the side effect of
> increasing write counters as well (disk_stats->sectors[1]) which leads
> to confusing result.
> 
> For example in ext4 filesystem we have counter s_kbytes_written which
> stores amount of kbytes written to the filesystem throughout its
> lifetime. Now, if you mount the filesystem with -o discard mount option,
> which means that with every commit blocks used by unlinked files are
> discarded, you'll get approx. twice as many kb writes as it should be
> (if you delete every file you have previously written of course).
> 
> So this means that with -o discard the ext4 s_kbytes_written counter is
> no longer reliable. Now the question is how to fix that ? Should the
> users of the disk_stats->sectors[1] count with this behaviour as the
> REQ_DISCARD is treated as write and should be accounted for, or should
> we change that in block layer and do not count REQ_DISCARD as write in
> the first place ?

IMO discard needs to be accounted separately in new counters.
Discards are not writes, but knowing how much data is being
discarded along with read and write stats is definitely useful
information about the IO load the device is under.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
