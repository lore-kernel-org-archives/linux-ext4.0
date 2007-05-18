From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64 and powerpc
Date: Fri, 18 May 2007 17:36:21 -0400
Message-ID: <20070518213621.GA10655@thunk.org>
References: <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070514142820.GA31468@amitarora.in.ibm.com> <20070514144524.GA31748@amitarora.in.ibm.com> <20070515094436.d441098f.sfr@canb.auug.org.au> <20070515132353.GB12964@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51089 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXERVgc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 May 2007 17:36:32 -0400
Content-Disposition: inline
In-Reply-To: <20070515132353.GB12964@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 15, 2007 at 06:53:53PM +0530, Amit K. Arora wrote:
> I will rebase it to 2.6.22-rc1 and repost the patches soon.
> Thanks!

I've rebased to 2.6.22-rc1 and put it in the ext4-patch-queue.

Mingming had rebased your previous (take3) set to 2.6.22-rc1, but
apparently the series file was corrupted, so it referenced an
incorrect patch filename, and the patch series didn't apply cleanly.
I've fixed it and confirmed that it builds and boots under UML.  Will
do more testing, but please take a look and confirm that it looks good.

Amit, we should probably get you access to repo.or.cz so you can
update the patches yourself.  My normal process is to transfer the
patches into git using the 'guilt' tool, and then start doing test
builds from there.  After I fix up the patches and do whatever is
necessary so they build, I copy them back into the ext4-patch-queue
directly, and then do a git-diff to see what has changed, and make the
changes to the patches look sane.  Can you send me and/or mingming
your ssh key, and we can give you push access to repo.or.cz?

We've missed the -rc1 merge window, so the goal should be to make sure
that everything in the series file before the "unstable patches" is
ready for merging.

Regards,

						- Ted
