From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: add disk failure simulation test
Date: Thu, 14 Feb 2013 08:32:17 +1100
Message-ID: <20130213213217.GG26694@dastard>
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, dchinner@redhat.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16178 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964910Ab3BMVc4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 16:32:56 -0500
Content-Disposition: inline
In-Reply-To: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 13, 2013 at 07:41:37PM +0400, Dmitry Monakhov wrote:
> BE CAREFUL!! test known to cause memory corruption for XFS
> see: https://gist.github.com/dmonakhov/4945005

Commit 9f87832 (xfs: fix shutdown hang on invalid inode during
create) might actually fix this. IIRC, it went into 3.8-rc7 so that
wouldn't have been in the kernel you were testing. Can you retest
with a more recent kernel and if it is still busted, send a bug
report to the list?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
