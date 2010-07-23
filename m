From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 240: test non-aligned AIO hole-filling
Date: Fri, 23 Jul 2010 13:58:11 +1000
Message-ID: <20100723035811.GE32635@dastard>
References: <4C489676.2000605@redhat.com>
 <20100723024938.GD32635@dastard>
 <4C490D4D.603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:59459 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755320Ab0GWD6Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Jul 2010 23:58:16 -0400
Content-Disposition: inline
In-Reply-To: <4C490D4D.603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 22, 2010 at 10:32:29PM -0500, Eric Sandeen wrote:
> Dave Chinner wrote:
> 
> > On Thu, Jul 22, 2010 at 02:05:26PM -0500, Eric Sandeen wrote:
> >   
> >> This replicates file corruption we've seen with qemu-kvm when
> >> we use if=virtio,cache=none,aio=native for IO to a sparse
> >> ext4- or xfs-hosted file, and the partitions/filesystems
> >> within that file image are not block-aligned.  (think sector
> >> 63 here...)  This results in AIO IOs not aligned to the
> >> filesystem blocks.
> >>
> >> This test modifies aiodio_sparse2.c to add an option to start
> >> the file IO at an offset.
> >>
> >> When we do 4k writes to a 16k file in 2 threads, starting
> >> at offset 512, we get 0s interspersed in the file where they
> >> should not be:
> >>
> >> 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> >> *
> >> 00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> >> *
> >> 00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> >> *
> >> 00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
> >> ....
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> >>     
> >
> > looks good - it needs to remove the $TEST_DIR/aiodio_sparse file
> > before the test starts, though, so that repeated tests fail
> > correctly. Otherwise:
> >
> >   
> hm, but:
> 
> +rm -f "$TEST_DIR/aiodio_sparse*"
> +
> +# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
> +$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
> 
> It does remove it ... no?

Sorry, my bad - that went in one eye and out the other when I read
through the whole patch.

When i was testing I was getting a repeatable fail - pass - fail -
pass ... pattern occurring without any kernel patches applied, and
the test warns about removing the file after failure, so I just
connected the dots up in the obvious manner and got it completely
wrong....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
