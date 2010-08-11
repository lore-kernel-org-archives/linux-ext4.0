From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 0/3] *** SUBJECT HERE ***  (ext4 scalability
 patches)
Date: Wed, 11 Aug 2010 17:08:09 -0400
Message-ID: <20100811210809.GC24435@thunk.org>
References: <1280851315-9167-1-git-send-email-tytso@mit.edu>
 <4C60CA3A.5070807@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, John Stultz <johnstul@us.ibm.com>,
	Keith Maanthey <kmannth@us.ibm.com>
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:39928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0HKVIM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Aug 2010 17:08:12 -0400
Content-Disposition: inline
In-Reply-To: <4C60CA3A.5070807@hp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 09, 2010 at 11:40:42PM -0400, Eric Whitney wrote:
> 
> My 48 core test results for these patches as applied to 2.6.35 can
> be found at:
> 
> http://free.linux.hp.com/~enw/ext4/2.6.35
> 
> Both the Boxacle large_file_creates and random_writes workloads
> improved significantly and consistently with these patches, and
> apparently in the single threaded case as well as at increased
> scale.

Thanks for doing these runs!  I very much appreciate it --- it's
really helped to validate these patches.  Looking at your results, the
two things which stand out to me is that we've now reached parity with
XFS on the random write workload on the 48 and 192 core runs.  On the
large file creates workload, looking at the lockstats report, it looks
like the next big thing we need to work on is to rework the
ext4_da_writepages() function.  

The problem is one that's known to me for a while; we carefully spend
a bunch of CPU time walking the page structures so we have a
contiguous extent of dirty pages that need to written out --- and then
we turn around and submit each page 4k at a time.  This is causing a
huge amount of pressure on the block device queue's rlock.  That's
almost certainly responsible for the increased CPU utilization that we
see in both the large file create workload and random writes workload
as compared to XFS.

So that's clearly the next thing we need to tackle, and which should
further increase ext4's scalability.

						- Ted
