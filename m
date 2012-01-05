From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfstests: make 275 pass
Date: Thu, 5 Jan 2012 11:39:28 +1100
Message-ID: <20120105003928.GC24466@dastard>
References: <4F04A6E6.1090304@redhat.com>
 <4F04BC81.1000207@redhat.com>
 <20120104231725.GB24466@dastard>
 <4F04DEDC.6020807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:26620 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757264Ab2AEAjq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 19:39:46 -0500
Content-Disposition: inline
In-Reply-To: <4F04DEDC.6020807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 04, 2012 at 05:21:00PM -0600, Eric Sandeen wrote:
> On 1/4/12 5:17 PM, Dave Chinner wrote:
> > On Wed, Jan 04, 2012 at 02:54:25PM -0600, Eric Sandeen wrote:
> >> Ok, this is a significant rework of 275, which made too many
> >> assumptions about details of space usage and failed on several
> >> filesystems (it passed on xfs, but only by accident).
> >>
> >> This new version tries to leave about 256k free, then tries
> >> a single 1M IO, and fails only if 0 bytes are written.
> >>
> >> It also sends a lot more to $seq.full for debugging on failure
> >> and fixes a few other stylistic things.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > I just had another thought about this, Eric....
> > 
> >> +# And at least some of it should succeed.
> >> +_filesize=`du $SCRATCH_MNT/tmp1 | awk '{print $1}'`
> >> +[ $_filesize -eq 0 ] && _fail "write file err: Partial write until enospc failed; wrote 0 bytes."
> > 
> > The question that just came to mind was this assumes that allocation
> > succeeded so therefore the partial write succeeded. But that's not
> > necessary the case. The partial write might not succeed leaving the
> > file size as zero, but the underlying FS might not remove all the
> > blocks it allocated (nothing says that it has to). Hence to
> > determine if a partial write succeeded, we also need to check that
> > the file size itself is greater than zero....
> 
> Probably need to read up on what posix says it should do.  I think
> what you're saying is that it might leave blocks allocated past EOF?
> That'd be surprising to me, but maybe I misunderstand?

There's no guarantee that du is even reporting blocks on disk. e.g
for XFS du will also report reserved (in-memory) delalloc space on
the inode and that includes speculative allocation beyond EOF. We
don't have to remove specultive delalloc ranges when a partial write
occurs, so effectively checking du output to see if a partial write
succeeded is not a sufficient test to determine if the partial write
succeeded or not.

However, if the partial write did succeed then the file size *must*
change to reflect what was written. Hence I suspect all we actually
need here is a file size check...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
