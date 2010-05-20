From: tytso@mit.edu
Subject: Re: [PATCH 3/3] ext4: don't use quota reservation for speculative
 metadata blocks
Date: Thu, 20 May 2010 19:10:41 -0400
Message-ID: <20100520231041.GF16634@thunk.org>
References: <4BBCFD10.3030504@redhat.com>
 <4BBCFF68.1060000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45127 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab0ETXKo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 19:10:44 -0400
Content-Disposition: inline
In-Reply-To: <4BBCFF68.1060000@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 07, 2010 at 04:55:52PM -0500, Eric Sandeen wrote:
> Because we can badly over-reserve metadata when we
> calculate worst-case, it complicates things for quota, since
> we must reserve and then claim later, retry on EDQUOT, etc.
> Quota is also a generally smaller pool than fs free blocks,
> so this over-reservation hurts more, and more often.
> 
> I'm of the opinion that it's not the worst thing to allow
> metadata to push a user slightly over quota.  This simplifies
> the code and avoids the false quota rejections that result
> from worst-case speculation.
> 
> This patch stops the speculative quota-charging for
> worst-case metadata requirements, and just charges quota
> when the blocks are allocated at writeout.  It also is
> able to remove the try-again loop on EDQUOT.
> 
> This patch has been tested indirectly by running the xfstests
> suite with a hack to mount & enable quota prior to the test.
> 
> I also did a more specific test of fragmenting freespace
> and then doing a large delalloc write under quota; quota
> stopped me at the right amount of file IO, and then the
> writeout generated enough metadata (due to the fragmentation)
> that it put me slightly over quota, as expected.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the ext4 patch queue; there were slight adjustments to make
the patch apply.

Note: I did some testing of this patch, and found the following
warnings getting emitted when I ran fsstress:

fsstress -d /scratch/fsstress -n 100 -p 10

[   93.338647] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 594944). There's a risk of filesystem corruption in case of system crash.
[   93.390107] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 594944). There's a risk of filesystem corruption in case of system crash.
[  149.249765] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 594142). There's a risk of filesystem corruption in case of system crash.
[  149.305717] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 594142). There's a risk of filesystem corruption in case of system crash.
[  152.523048] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 590048). There's a risk of filesystem corruption in case of system crash.
[  152.544641] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 590048). There's a risk of filesystem corruption in case of system crash.
[  154.147876] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 590049). There's a risk of filesystem corruption in case of system crash.
[  154.192645] JBD: Spotted dirty metadata buffer (dev = sdc1, blocknr = 590049). There's a risk of filesystem corruption in case of system crash.

... but I found the same warning messages after I removed your patch,
so presumably this is a pre-existing condition with quotas and ext4.
Has anyone looked into this?

					- Ted
