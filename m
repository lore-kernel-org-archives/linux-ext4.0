From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: test data integrity under disk failure
Date: Fri, 17 May 2013 09:31:53 +1000
Message-ID: <20130516233153.GI24635@dastard>
References: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 16, 2013 at 04:07:32PM +0400, Dmitry Monakhov wrote:
> Parallels team have old good tool called hwflush-check which is server/client
> application for testing data integrity under system/disk failure conditions.
> Usually we run hwflush-check on two different hosts and use PMU to trigger real
> power failure of the client as a whole unit. This tests may be used for
> SSD checking (some of them are known to have probelms with hwflush).
> I hope it will be good to share it with community.
> 
> This tests simulate just one disk failure while client system should
> survive this failure. This test extend idea of shared/305.
> 1) Run hwflush-check server and client on same host as usual
> 2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
> 3) Umount failed device
> 4) Makes disk operatable again
> 5) Mount filesystem
> 3) Check data integrity

So, for local disk failure, why do we need a client/server network
architecture? That just complicates the code, and AFAICT

all the client does is send report report packets to server which
contain an id number that is kept in memory. If on restart of the
client after failure the ID in the report packet doesn't match what
the server wants, then it fails the test.

So, why is the server needed here? Just dump the IDs the client
writes to the file on a device not being tested, and either diff
them against a golden image or run a check to see all the IDs are
monotonically increasing. That removes all the networking code from
the test, the need for a client/server architecture, etc, and makes
the test far easier to review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
