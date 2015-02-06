From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 4/11] xfsprogs: xfs_io: add finsert command for insert
 range
Date: Fri, 6 Feb 2015 14:11:29 +1100
Message-ID: <20150206031129.GL12722@dastard>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
 <1421853126-4505-5-git-send-email-linkinjeon@gmail.com>
 <20150205234033.GW4251@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
	a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:5902 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469AbbBFDLo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2015 22:11:44 -0500
Content-Disposition: inline
In-Reply-To: <20150205234033.GW4251@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Namjae,

On Fri, Feb 06, 2015 at 10:40:33AM +1100, Dave Chinner wrote:
> On Thu, Jan 22, 2015 at 12:11:59AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > 
> > Add finsert command for fallocate FALLOC_FL_INSERT_RANGE flag.
> > 
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> I've just pulled this patch into xfsprogs in preparation for getting
> this functionality fully reviewed and merged in the 3.21 kernel
> cycle.

xfs/293 3s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/293.out.bad)
    --- tests/xfs/293.out       2014-01-20 16:57:34.000000000 +1100
    +++ /home/dave/src/xfstests-dev/results//xfs/293.out.bad    2015-02-06 12:21:47.000000000 +1100
    @@ -1,2 +1,3 @@
     QA output created by 293
     Silence is golden
    +finsert not documented in the xfs_io manpage
    .....

Can you send a patch that updates the xfs_io man page, please?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
