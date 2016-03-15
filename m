From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] generic: test I/O on dm error device
Date: Tue, 15 Mar 2016 13:46:16 +1100
Message-ID: <20160315024616.GC30721@dastard>
References: <1457710822-30532-1-git-send-email-eguan@redhat.com>
 <1457710822-30532-2-git-send-email-eguan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:31850 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbcCOCqc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Mar 2016 22:46:32 -0400
Content-Disposition: inline
In-Reply-To: <1457710822-30532-2-git-send-email-eguan@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 11, 2016 at 11:40:22PM +0800, Eryu Guan wrote:
> This is a test that performs simple I/O on dm error device, which
> returns EIO on all I/O request.
> 
> This is motivated by an ext4 bug that crashes kernel on error path when
> trying to update atime. Following kernel patch should fix the issue
> 
>   ext4: fix NULL pointer dereference in ext4_mark_inode_dirty()

Why does this test require the loop device? Why can't you just
unmount the filesystem, run 'blkdev --flushbufs <dev>' to ensure
there are no cached buffers/pages on the block device, then mount
it again?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
