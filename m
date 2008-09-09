From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Bug 11525] New: Unable to handle paging request at
	ext3_rmdir() and ext4_rmdir() on intentionally corrupted fs
Date: Tue, 9 Sep 2008 17:55:31 -0400
Message-ID: <20080909215531.GE21071@mit.edu>
References: <bug-11525-27@http.bugzilla.kernel.org/> <20080909134627.75bd0a80.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
	sliedes@cc.hut.fi
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42157 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYIIVzr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Sep 2008 17:55:47 -0400
Content-Disposition: inline
In-Reply-To: <20080909134627.75bd0a80.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> > Unfortunately this is one of those bugs that I can't find a way to
> > reproduce except by randomly breaking one fs after another. This
> > happens with ext3 and ext4, but so far I haven't seen it happen
> > with ext2.
> > 
> >
> > *** seed 270, ext3, 2.6.27-rc3 ***
> > *** seed 451, ext4, 2.6.27-rc5 ***

Given these seed numbers, I assume this was generating using some tool
like fsfuzzer?  Would it be possible to generate a filesystem image
*before* that triggers the problem case, before trying to execute the
rm -rf?  

That would be the fastest way to try to track the problem down.

							- Ted
