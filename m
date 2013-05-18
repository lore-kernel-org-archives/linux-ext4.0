From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] xfstests: test data integrity under disk failure
Date: Sat, 18 May 2013 16:13:25 +0400
Message-ID: <878v3cv63e.fsf@openvz.org>
References: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org> <20130516233153.GI24635@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs@oss.sgi.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:48910 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3ERMNb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 18 May 2013 08:13:31 -0400
In-Reply-To: <20130516233153.GI24635@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 17 May 2013 09:31:53 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 16, 2013 at 04:07:32PM +0400, Dmitry Monakhov wrote:
> > Parallels team have old good tool called hwflush-check which is server/client
> > application for testing data integrity under system/disk failure conditions.
> > Usually we run hwflush-check on two different hosts and use PMU to trigger real
> > power failure of the client as a whole unit. This tests may be used for
> > SSD checking (some of them are known to have probelms with hwflush).
> > I hope it will be good to share it with community.
> > 
> > This tests simulate just one disk failure while client system should
> > survive this failure. This test extend idea of shared/305.
> > 1) Run hwflush-check server and client on same host as usual
> > 2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
> > 3) Umount failed device
> > 4) Makes disk operatable again
> > 5) Mount filesystem
> > 3) Check data integrity
> 
> So, for local disk failure, why do we need a client/server network
> architecture? That just complicates the code, and AFAICT
> 
> all the client does is send report report packets to server which
> contain an id number that is kept in memory. If on restart of the
> client after failure the ID in the report packet doesn't match what
> the server wants, then it fails the test.
> 
> So, why is the server needed here? Just dump the IDs the client
> writes to the file on a device not being tested, and either diff
> them against a golden image or run a check to see all the IDs are
> monotonically increasing. That removes all the networking code from
> the test, the need for a client/server architecture, etc, and makes
> the test far easier to review
In fact the reason is quite simple. Initially the this tool was designed
for real disk cache testing under power failure conditions. And want to
share it with community. Off course it is possible to simplify things 
for 'one hose' case but it is not too big. Let's review it one and keep
it simple but useful not just for local but also for real power failure
tests.
Fairly to say that initial idea was to add persistent state to FIO.
But logic starts to getting too complex so we write hwflush-check.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
