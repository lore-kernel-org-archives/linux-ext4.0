From: "Jayson R. King" <dev@jaysonking.com>
Subject: Re: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
Date: Tue, 01 Jun 2010 15:06:09 -0500
Message-ID: <4C056831.3020104@jaysonking.com>
References: <4C001888.8020006@jaysonking.com> <4C0018E1.5060007@jaysonking.com> <20100529004913.GL26177@thunk.org> <4C0070D8.8060500@jaysonking.com> <20100530212502.GQ26177@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Jayson R. King" <dev@jaysonking.com>,
	Stable team <stable@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Dave Chinner <david@fromorbit.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bosmailout14.eigbox.net ([66.96.189.14]:47296 "EHLO
	bosmailout14.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab0FAUjA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 16:39:00 -0400
In-Reply-To: <20100530212502.GQ26177@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/30/2010 04:25 PM, tytso@mit.edu wrote:
> Ah, OK.  So I understand the motivation now, and that's a valid
> concern.  The question is now: how much the goal of the 2.6.27 stable
> branch to fix bugs, and how much is it to get the best possible
> performance, at least with respect to ext4?  It's going to be harder
> and harder to backport fixes to 2.6.27, and I can speak from
> experience that it's very easy to introduce regressions while trying
> to do backports, since sometimes an individual upstream commit can end
> up introducing a regression, and while we do try to document
> regression fixes in later commits, sometimes the documentation isn't
> complete.

Apologies for not making the motivation for these patches more clear. 
The first two of these three patches really only exist as support for 
the last one, which fixes the deadlock that I was really concerned 
about. That was the same motivation for the earlier 11 patches I sent. 
While the other patches may fix some real bugs on .27, that wasn't my 
goal. So I won't be offering to send any more ext4-related fixes to 
.27.y either unless it is for something really serious.

I considered carefully whether to send the patches as they are now, but 
the alternative would be to re-work the fix in the last patch, which I 
didn't want to tackle, for fear of getting it wrong.

> I just spent the better part of a day trying to fix up a backport
> series for 2.6.32.  When I was engaged in this particular exercise, it
> turns out a particular commit to fix a quota deadlock introduced a
> regression, and the fix to that introduced yet another, and there were
> three or four patches that all needed to be pulled in at once.  Except
> initially I missed one, and that caused an i_blocks corruption issue
> when using fallocate() that took me several hours and a reverse
> git-bisection to find.  (And this is one set of fixes that will
> probably never be able to go into 2.6.27.y, since these changes also
> interlock with probably a dozen or so quota changes that have also
> gone in over the last couple of kernel releases.)

The concern is understandable, and I agree that .27.y is no longer a 
good candidate for receiving noncritical ext4 fixes.

> I'll also add that simply testing using dbench, as you said you used
> in another e-mail message, really isn't good enough to find all
> possible regressions (it wouldn't have found the i_blocks corruption
> problem in my initial set of 2.6.32 ext4 backports patches, for
> example, since dbench only tests a very limited set of fs operations,
> which doesn't include fallocate, or quotas, or mmap for that matter.)
>
> What I would recommend is using the XFSQA (also sometimes known
> xfstests) test suite to make sure that your changes are sound.  Dbench
> will sometimes find issues, yes, but in my experience it's not the
> best tool.  The fsstress program, which is called in a number of
> different configurations by xfstests, has found all sorts of problems
> that other thing shaven't been able to find.  Run it on at least a
> 2-core system, or preferably a 4-core or 8-core system if you have it.
> I generally run tests using both 4k and 1k blocksize file systems to
> make sure there aren't problems where the fs blocksize is less than
> the pagesize.
>
> If you are willing to take on the support burden of ext4 for 2.6.27,
> and do a lot of testing, I at least wouldn't have any objection to
> these patches.  It's really a question of risk vs. reward for the
> users of the 2.6.27 stable tree, plus a question of someone willing to
> take on the support/debugging burden, and how much testing is done to
> appropriate tilt the risk/reward balance.

Thanks for the tip. I will get xfstests running and report the results 
in a few days.

Jayson

