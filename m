From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/4] ext4: Add XIP functionality
Date: Fri, 6 Dec 2013 14:13:54 +1100
Message-ID: <20131206031354.GS10988@dastard>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
 <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:52061 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab3LFDOB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Dec 2013 22:14:01 -0500
Content-Disposition: inline
In-Reply-To: <1386273769-12828-3-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 05, 2013 at 01:02:46PM -0700, Ross Zwisler wrote:
> This is a port of the XIP functionality found in the current version =
of
> ext2.  This patch set is intended to achieve feature parity with XIP =
in
> ext2 rather than non-XIP in ext4.=A0 In particular, it lacks support =
for
> splice and AIO.=A0 We'll be submitting patches in the future to add t=
hat
> functionality, but we think this is a good start.
>=20
> The motivation behind this work is that we believe that the XIP featu=
re
> will begin to find new uses as various persistent memory devices and
> technologies come on to the market.  Having direct, byte-addressable
> access to persistent memory without having an additional copy in the
> page cache can be a win in terms of I/O latency and overall memory
> usage.
>=20
> This patch applies cleanly to v3.13-rc2, and was tested using brd as =
our
> block driver.

I think I see a significant problem here with XIP write support:
unwritten extents.

xip_file_write() has no concept of post IO completion processing -
it assumes that all that is necessary is to memcpy() the data into
the backing memory obtained by ->get_xip_mem(), and that's all it
needs to do.

=46or ext4 (and other filesystems that use unwritten extents) they
need a callback - normally done from bio completion - to run
transactions to convert extent status from unwritten to written, or
run other post-IO completion operations.

I don't see any hooks into ext4 to turn off preallocation (e.g.
fallocate is explicitly hooked up for XIP) when XIP is in use, so I
can't see how XIP can work with such filesystem requirements without
further infrastructure being added. i.e. bypassing the need for the
page cache does not remove the need to post-IO completion
notification to the filesystem....

Indeed, for making filesystems like XFS be able to use XIP, we're
going to need such facilities to be provided by the XIP
infrastructure....

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
