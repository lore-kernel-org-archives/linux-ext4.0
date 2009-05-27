From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/11] Fix page_mkwrite() for blocksize < pagesize
Date: Wed, 27 May 2009 21:03:58 +0530
Message-ID: <20090527153358.GA19989@skywalker>
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:32866 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZE0PeJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 May 2009 11:34:09 -0400
Content-Disposition: inline
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 27, 2009 at 03:00:57PM +0200, Jan Kara wrote:
> 
> patches below are an attempt to solve problems filesystems have with
> page_mkwrite() when blocksize < pagesize (see the changelog of the third patch
> for details).
> 
> The series is against 2.6.30-rc7. The first two patches are just small cleanup
> and should be merged separately (Ted should have the ext4 cleanup rebased on
> top of current ext4 tree). For ext3 the fix is done in two phases, in the first
> we make it to correctly allocate space at page-fault time from page_mkwrite().
> This has the disadvantage that under random mmaped writes, the file gets much
> more fragmented and performance of e.g. Berkeley DB drops by ~20%. Therefore
> in the second phase I've implemented delayed allocation for ext3 and blocks
> are just reserved during page_mkwrite time and really allocated only during
> writepage. This gets the performance back to original numbers for me.
> 
> The patches should be fairly complete and sustained quite some testing. OTOH
> the area is kind of complex so please review them so that they can get merged.
> Thanks.

Can you move patch 7 and patch 11 as the last two patches. That would
make sure we can push rest of the patches earlier. Rest of the patches
are needed for ext4 to fix some of the bugs we are seeing. For eg:
																	  http://bugzilla.kernel.org/show_bug.cgi?id=12624
http://bugzilla.kernel.org/show_bug.cgi?id=13369

I have few writepage patches also on top of your last series. Having
patch 7 and patch 11 as last two patches make sure we can get the rest
of the patches in ext4 patchqueue and get wider testing.

-aneesh
