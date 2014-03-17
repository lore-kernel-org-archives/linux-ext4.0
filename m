From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Mon, 17 Mar 2014 13:59:35 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403171358580.30625@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <20140316190820.GB14162@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932855AbaCQM7p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 08:59:45 -0400
In-Reply-To: <20140316190820.GB14162@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 16 Mar 2014, tytso@mit.edu wrote:

> Date: Sun, 16 Mar 2014 15:08:20 -0400
> From: tytso@mit.edu
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Tue, Feb 25, 2014 at 08:14:33PM +0100, Lukas Czerner wrote:
> > Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
> > functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
> 
> Hi Lukas,
> 
> I've been trying to merge these patches into the ext4 tree, and I'm
> running into a large number of test failures.  Could you take a quick
> eyeball and see if there's anything obvious wrong?
> 
> The "dev2" branch in the ext4 git tree has all the patches in this
> series (1, 2, and 5) --- 3 was included earlier applied on top of the
> "dev" branch.  The "test" branch is the dev2 branch with the
> xfs-collapse-range branch pulled in, which actually enables the
> ZERO_RANGE flags (as well as the collapse range patches).
> 
> I have tested the "dev" branch both standalone and with the
> xfs-collapse-range branch pulled in, and things seem to be pretty
> stable.  I'm doing more comprehensive testing now to confirm things.
> (I'm using xfstests commit id 3948694eb12 which has the latest tests
> to exercise the zero_range codepath.)
> 
> When I tried testing with the "test" branch, things failed pretty
> quickly.  I've attached two of these in this patch set.  I'm guessing
> it's some kind of memory corruption problem.  These failures are
> pretty repeatable, and it fails fast.
> 
> If I try running the "dev2" branch, without the xfstests collapse
> range branch pulled in, things are much better (so there's clearly a
> bug in the ZERO_RANGE code path), but there was still a few more
> errors than the baseline.  I'm rerunning those tests so I can be sure
> that the results are repeatable.
> 
> I suspect the problem is that something in the dev branch isn't
> playing well with your patches, or I screwed up while fixing up some
> merge conflicts -- but the merge conflicts were pretty minimal, so
> that seems a bit unlikely.
> 
> Anyway, if you could take a look, I'd really appreciate it.  Thanks!!
> 
> 	       	     	    	      	     - Ted

That's definitely very weird and I have not seen that before. i am
looking into this right not.

Thanks!
-Lukas

> 
> 
