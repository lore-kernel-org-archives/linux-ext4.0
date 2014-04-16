From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add fallocate mode blocking for debugging purposes
Date: Tue, 15 Apr 2014 20:23:46 -0400
Message-ID: <20140416002346.GA12078@thunk.org>
References: <1397420518-29218-1-git-send-email-tytso@mit.edu>
 <20140413220016.GD8122@thunk.org>
 <alpine.LFD.2.00.1404151749490.2146@localhost.localdomain>
 <534D5B2D.70408@redhat.com>
 <20140415184442.GC4456@thunk.org>
 <20140415232556.GS15995@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Namjae Jeon <linkinjeon@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54836 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaDPAXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Apr 2014 20:23:53 -0400
Content-Disposition: inline
In-Reply-To: <20140415232556.GS15995@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 16, 2014 at 09:25:56AM +1000, Dave Chinner wrote:
> Actually, we shouldn't be changing xfstests or adding workarounds in
> the kernel to avoid certain operations. We should be fixing the damn
> bugs that are being exposed.

Well, I'm waiting for Namjae to look into the test failures.
Unfortunately I don't have time right now to fix it myself.

In the meantime, I wanted to do a full baseline test run to make sure
we didn't have any other regressions or failures post -rc1, and so
being able to filter out collapse range allowed me to kick off a test
of the rest of the patches I was hoping to push to Linus for -rc2.

> i.e. that we have to add the FALLOC_FL_INSERT_RANGE to fsx and
> fsstress as well as having corner case tests and it needs to pass
> those tests before XFS support is ready for upstream inclusion. At
> least, that's the lesson I learnt from as the xfstests and XFS
> Maintainer - we didn't put the QA bar for inclusion high enough, and
> so problems slipped through.
> 
> If you want to add more strict testing requirements for ext4
> inclusion, then you're welcome to request them for the ext4
> implementation of that functionality. You don't have to accept the
> code until you're happy with it....

No arguments here; I plan to do the same.

Regards,

						- Ted
