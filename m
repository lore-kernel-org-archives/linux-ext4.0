From: Theodore Tso <tytso@mit.edu>
Subject: Re: Revert  Fix-EXT_MAX_BLOCK.patch
Date: Fri, 11 Jul 2008 08:43:04 -0400
Message-ID: <20080711124304.GB8154@mit.edu>
References: <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de> <20080619110947.GB11516@mit.edu> <Pine.LNX.4.64.0807071047430.17563@diagnostix.dwd.de> <Pine.LNX.4.64.0807100804050.16071@diagnostix.dwd.de> <20080710092425.GA16451@skywalker> <20080710092517.GB16451@skywalker> <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Girish Shilamkar <Girish.Shilamkar@sun.com>,
	linux-ext4@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43126 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751648AbYGKMnt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 08:43:49 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807110947290.31436@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2008 at 09:57:47AM +0000, Holger Kiehl wrote:
> Thanks. Reverting that patch also fixed it for me. I was able to do my
> test however performance is down another 10% (compared to
> ext4-patch-queue-52c8a02a8a7b7e5915b9301e9c171b4faf22b928). ext4 is getting
> slower and slower :(

How reproducible are your results?  That is, if you run the benchmarks
multiple times, how much variance is there between different runs?

If you are willing, this would be helpful.  In your ext4 patch
repository, try out commit 179a876b.  (You can do this via 
"git checkout -b rc9-rebase 179a876b"; after doing the test you can
switch the working directory of the ext4 patch queue back to the master
branch via "git checkout master".)   This commit is pretty much 
identical to your previous 52c8a02a test, modulo rebasing to -rc9.

If you see the same results, you could try going to the next patch,
via "git checkout -b i-blocks-stat ef019f0a" which also has the fix so
that stat returns a valid i_blocks field for files that have been
freshly written when delayed allocation is enabled.  Both of these
revisions rae before the patches that were causing corrupion were
added to the patch queue, so it should be fine.

The funny thing is looking at the various recent patches, I don't see
how they could be affecting performance of your patches so
significantly.  I gather afdbench is very metadata intensive, with
lots of small files, but even so, none of these patches should make
that kind of difference.  So that's why I'm wondering how much
variance there is between runs of afdbench, and whether that might be
a possible explanation.

> Also the group descriptors still get corrupted.

Hmm, can you send me the output of dumpe2fs before and after the
benchmark run which corrupts the group descriptors?  And can you send
me the output of "e2fsck -fy /dev/XXXXX >& /tmp/log", so I can see
what got corrupted?

I also note that you are using a fairly old e2fsprogs from April 27th.
You might want to try going to the just-released e2fsprogs 1.41.0
released yesterday, as that has some flex_bg layout changes that might
help out performance for afdbench.  Also note that with both the April
27th and the latest e2fsprogs 1.41.0 release, there is a mke2fs.conf
file in misc/mke2fs.conf that should be installed in /etc/mke2fs.conf
for best results.

> PS: http://repo.or.cz/w/ext4-patch-queue.git is empty, is that correct?

Nope, we're working on that.  Things seem to have gotten corrupted on
repo.or.cz, as you may have seen on another e-mail thread.  I have
established an git repository here:

	    git://git.kernel.org/pub/scm/fs/ext2/ext4-patch-queue.git

As an interim replacement.

						- Ted
