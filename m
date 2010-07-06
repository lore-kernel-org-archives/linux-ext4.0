From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Rearrange i_flags to be consistent with FS_IOC_GETFLAGS
Date: Wed, 7 Jul 2010 09:03:13 +1000
Message-ID: <20100706230312.GB25018@dastard>
References: <20100706001032.GA25018@dastard>
 <20100705154319.31193.56706.stgit@warthog.procyon.org.uk>
 <29431.1278423623@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:34036 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176Ab0GFXDR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jul 2010 19:03:17 -0400
Content-Disposition: inline
In-Reply-To: <29431.1278423623@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 06, 2010 at 02:40:23PM +0100, David Howells wrote:
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > Further, it opens up the possibility that further down the track
> > someone modifies S_* flag values (say when adding some XFS
> > functionality) and corrupts extN filesystems all over the place.
> > There isn't even compiler guards to catch someone modifying the S_*
> > flags in a way that makes it incompatible with the extN on-disk
> > definitions.
> 
> That occurred to me after I sent the patch.  I can add some preprocessor guards
> for this.

I'd prefer generic flags are not dependent on fixed values from a
specific filesystem several layers down the storage stack.

Also, if the problem you are trying to solve is overhead of
calculating the flags for stat() on RISC architectures, then I'd
argue that XFS is just as important target for such an optimisation
because it is widely used in small ARM and MIPS based NAS
appliances....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
