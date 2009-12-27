From: jim owens <jowens@hp.com>
Subject: Re: [Jfs-discussion] benchmark results
Date: Sun, 27 Dec 2009 14:50:14 -0500
Message-ID: <4B37BA76.7050403@hp.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de> <19251.26403.762180.228181@tree.ty.sabi.co.uk> <20091224212756.GM21594@thunk.org> <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de> <20091225161453.GD32757@thunk.org> <20091225162238.GB19303@bitmover.com> <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de> <4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Larry McVoy <lm@bitmover.com>, tytso@mit.edu,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org,
	Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>,
	ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:27076 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZL0TuS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Dec 2009 14:50:18 -0500
In-Reply-To: <4B365EBE.5050804@nerdbynature.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Christian Kujau wrote:
> On 26.12.09 08:00, jim owens wrote:
>>> I was using "sync" to make sure that the data "should" be on the disks 
>> Good, but not good enough for many tests... info sync
> [...]
>>        On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
>>        writing;  it  can  actually take a short time before all the blocks are
>>        finally written.

OK, that was wrong per Ted's explanation:
> 
> But for quite some time, under Linux the sync(2) system call will wait
> for the blocks to be flushed out to HBA, although we currently don't
> wait for the blocks to have been committed to the platters (at least
> not for all file systems).   

But Christian Kujau wrote:

> Noted, many times already. That's why I wrote "should be" - but in this
> special scenario (filesystem speed tests) I don't care for file
> integrity: if I pull the plug after "sync" and some data didn't make it
> to the disks, I'll only look if the testscript got all the timestamps
> and move on to the next test. I'm not testing for "filesystem integrity
> after someone pulls the plug" here. And remember, I'm doing "sync" for
> all the filesystems tested, so the comparison still stands.

You did not understand my point.  It was not about data integrity,
it was about test timing validity.

And even with sync(2) behaving as Ted describes, *timing* may still
tell you the wrong thing or not tell you something important.

I have a battery-backed HBA cache.  Writes are HBA cached.  Timing only
shows "to HBA memory". So 1000 pages (4MB total) that are at 1000 places
on the disk will time (almost) the same completion as 1000 pages that
are in 200 extents of 50 pages each.  Writing to disk the time difference
between these would be an obvious slap upside the head.

Hardware caches can trick you into thinking a filesystem performs
much better than it really does for some operations.  Or trick you
about relative performance between 2 filesystems.

And I don't even care about comparing 2 filesystems, I only care about
timing 2 versions of code in the single filesystem I am working on,
and forgetting about hardware cache effects has screwed me there.  

So unless you are sure you have no hardware cache effects...
"the comparison still stands" is *false*.

jim
