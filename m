From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 241: run parallel dbench
Date: Wed, 18 Aug 2010 21:45:07 +1000
Message-ID: <20100818114507.GS10429@dastard>
References: <4C6AE57D.7090807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-oss <xfs@oss.sgi.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:40080 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949Ab0HRLpN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Aug 2010 07:45:13 -0400
Content-Disposition: inline
In-Reply-To: <4C6AE57D.7090807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 17, 2010 at 02:39:41PM -0500, Eric Sandeen wrote:
> ext4 was corrupting inode table bitmaps due to a mishmash of
> atomic & nonatomic bitops.  This got broken twice and fixed
> twice; let's add a test.
> 
> On a 4-way box this reliably ends up with a corrupted filesystem
> if we get it wrong (upstream as of 2.6.35 at least is fine again)
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good, except it's missing a 241.out file for the golden
output.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
