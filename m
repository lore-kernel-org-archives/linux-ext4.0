From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] large-fs: fix ext4 defragmentation tests
Date: Thu, 11 Jul 2013 11:17:41 +1000
Message-ID: <20130711011741.GW3438@dastard>
References: <1373367918-7516-1-git-send-email-dmonakhov@openvz.org>
 <1373367918-7516-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dchinner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:30785 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab3GKBS3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jul 2013 21:18:29 -0400
Content-Disposition: inline
In-Reply-To: <1373367918-7516-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 09, 2013 at 03:05:18PM +0400, Dmitry Monakhov wrote:
> Initially work space size calculation was based on size of blkdev which
> obviously wrong for large-fs case. This patch calculate work space based
> on `df` cmd.

when have a "_used" command in common/rc for getting the used space
on a device (i.e. _used $SCRATCH_DEV). This loocks like a case for a
"_free" equivalent....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
