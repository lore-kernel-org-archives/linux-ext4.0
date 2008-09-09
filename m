From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] ext4: fix #11321: create /proc/ext4/*/stats et al more
	carefully
Date: Tue, 9 Sep 2008 14:24:57 -0400
Message-ID: <20080909182457.GS21071@mit.edu>
References: <20080905210652.GE11569@x200.localdomain> <20080906075713.GM3086@webber.adilger.int> <20080907121557.GA3432@x200.localdomain> <20080907162447.GB32429@mit.edu> <20080907164130.GA3376@x200.localdomain> <20080908143951.GH8161@mit.edu> <20080909070630.GC5786@x200.localdomain> <20080909001203.7480549e.akpm@linux-foundation.org> <20080909130900.GS8161@mit.edu> <20080909111006.cc8aae89.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62709 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754209AbYIISZp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 14:25:45 -0400
Content-Disposition: inline
In-Reply-To: <20080909111006.cc8aae89.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 09, 2008 at 11:10:06AM -0700, Andrew Morton wrote:
> 
> "the percpu cleanup patch" is nowhere nearly specific enough to be
> useful.  I don't know what patch this is.

Sorry, I should have been more specific.  It's called:

percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch 

in in your mmotm tree.

> If stuff turns up in linux-next then I'll just drop the -mm duplicate
> under the assumption that the patch is being taken care of by someone
> else.

Well, in the past you've been asked me not to include non-ext4 patches
in the ext4 tree.  So I could include that patch in an ext4 patchset
and push it to linux-next, since it *does* involve changes to fs/ext4
as well as to include/linux/percpu_counter.h and lib/percpu_counter.c,
if that would be easier.  Or we can keep it out of the set of patches
I push to Linus, but then we have to worry about patch ordering and
dependencies a bit more.

> I will usually attempt to verify that the subsystem tree merged
> the correct patch.  Fairly often they didn't.

I've checked, and modulo some minor changelog comment fixups I had
made to fix grammar and spelling that I had made to my version of the
patch, and the fact that we didn't have your signed-off-by in your
version of the patch, the patch we have is identical.  I'll reconcile
the changelog comments headers on my end, and if you want to keep it
in -mm, I'll send them back to you.  Otherwise I'll include it in ext4
patches and you can drop it from yours if that's OK with you.
Whatever's easier....

							- Ted
