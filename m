From: Theodore Tso <tytso@mit.edu>
Subject: Re: Performance of ext4
Date: Thu, 12 Jun 2008 09:19:28 -0400
Message-ID: <20080612131928.GB18229@mit.edu>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de> <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de> <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de> <18513.345.553912.449710@frecb006361.adech.frec.bull.fr> <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Solofo.Ramangalahy@bull.net, Nick Dokos <nicholas.dokos@hp.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:40333 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761939AbYFLNUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 09:20:17 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 12:00:54PM +0000, Holger Kiehl wrote: 
> Yes, that is the one I took. Just to make sure, I downloaded it
> again (and the linux-2.6.26-rc5 tree) and now it works. When I
> compare the two patchsets the one I pulled this morning had patches
> from 7 June and this one has more and they are from 11th June.

Note that you don't have to download things from scratch, necessarily;
the git command "git pull" will (if you havent made any changes in the
git repository; if you have there are a few more steps you might have
to take) pull down any newer changes and update your patch directory
directly.

Note that after you type "git pull", you may find that the
ext4-patch-queue has been rebased to a newer version of the kernel.
For example, the patch queue is currently against 2.6.26-rc5.  The
latest bleedig edge kernel as released by Linus in his git tree of the
kernel already has these patches:

ext4-fix-use-of-uninitalized-data.patch
ext4-fix-uninit-block-group-initialization-with-FLEX_BG.patch
ext4-fix-onine-resize-bug.patch
fix-journal-checksum-mem-leak
jbd2-if-a-journal-checksum-error-is-detected-propa.patch 
show-journal-async-commit-option
jbd2-Fix-barrier-fallback-code-to-re-lock-the-buffe.patch
ext4-enable-barriers-by-default.patch

from the patch series.  But, he hasn't released an official kernel
release for 2.6.26-rc5 yet.  So in the near future, the ext4 patch
queue will probably get rebased against one of the "daily snapshots",
as found in /pub/linux/kernel/v2.6/snapshots on ftp.kernel.org.  So
for example, 2.6.26-rc5-git6 is the sixth snapshot since -rc5 was
released.  There is a patch against -rc5 named
patch-2.6.26-rc5-git6.bz2 as located in the aforementioned directory
on ftp.kernel.org, or if you are tracking Linus's kernel git tree, the
file patch-2.6.26-rc5-git6.id proclaims that -rc5-git6 is git id
631025b.  You will see that when you look at the first line of the
series file in the ext4 patch queue, where it currently states:

# BASE 2.6.26-rc5

and where it will in the future say something like this:

# BASE 2.6.26-rc5-git6

That can be used by automated scripts to automatically determine which
version of the Linux kernel should be grabbed before trying to apply
the latest version of the ext4 patch queue.  In general we try to use
mainly official -rc1, -rc2, etc. release points, but after Linus
pulled down some stable bug fixes, we will sometimes use a daily git
snapshot release such as -rc5-git6 as described above.

Hope this helps,

							- Ted
