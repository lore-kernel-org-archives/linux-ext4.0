From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/5][TAKE2] fallocate() implementation on i86, x86_64
	and powerpc
Date: Fri, 18 May 2007 16:10:45 -0700
Message-ID: <1179529845.3768.20.camel@dyn9047017103.beaverton.ibm.com>
References: <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070514132926.GA30768@amitarora.in.ibm.com>
	 <20070514142820.GA31468@amitarora.in.ibm.com>
	 <20070514144524.GA31748@amitarora.in.ibm.com>
	 <20070515094436.d441098f.sfr@canb.auug.org.au>
	 <20070515132353.GB12964@amitarora.in.ibm.com>
	 <20070518213621.GA10655@thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:42717 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbXERXLG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 May 2007 19:11:06 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4INB0Wl025659
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 19:11:00 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4INB067220730
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 17:11:00 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4INAx0q016863
	for <linux-ext4@vger.kernel.org>; Fri, 18 May 2007 17:10:59 -0600
In-Reply-To: <20070518213621.GA10655@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-05-18 at 17:36 -0400, Theodore Tso wrote:
> On Tue, May 15, 2007 at 06:53:53PM +0530, Amit K. Arora wrote:
> > I will rebase it to 2.6.22-rc1 and repost the patches soon.
> > Thanks!
> 
> I've rebased to 2.6.22-rc1 and put it in the ext4-patch-queue.
>
> Mingming had rebased your previous (take3) set to 2.6.22-rc1, but
> apparently the series file was corrupted, so it referenced an
> incorrect patch filename, and the patch series didn't apply cleanly.
> I've fixed it and confirmed that it builds and boots under UML.  Will
> do more testing, but please take a look and confirm that it looks good.
> 

Thanks Ted. I am not sure how the series corrupted but I am glad that
you catch that and updated with fallocate patches.:-)

We don't need the ext4-fallocate-1b-fallocate_inode_op_fix.patch as Amit
fixed the ext4_fallocate() return value type to match VFS fallocate() in
takes 4, patch 5/6. I will update the series to reflect this and run
test.

I think Kalpak's patch to remove 32000 subdirs patch can be add to the
ext4 patch queue as well. Agreed?

> Amit, we should probably get you access to repo.or.cz so you can
> update the patches yourself.  My normal process is to transfer the
> patches into git using the 'guilt' tool, and then start doing test
> builds from there.  After I fix up the patches and do whatever is
> necessary so they build, I copy them back into the ext4-patch-queue
> directly, and then do a git-diff to see what has changed, and make the
> changes to the patches look sane.  Can you send me and/or mingming
> your ssh key, and we can give you push access to repo.or.cz?
> 

I am not sure Amit can response this before he leave for vacation.(from
May 19 for 10 days). 

I will checked the fallocate patches and run auto tests.

> We've missed the -rc1 merge window, so the goal should be to make sure
> that everything in the series file before the "unstable patches" is
> ready for merging.
> 
I tend to agree.  But there are some bug-fix type or mount option
patches that can try to target for rc2, what do you think?


# New patch to fix whitespace before applying new patches
whitespace.patch
 
#New patch to remove unnecessary exported symbols
ext4_remove_exported_symbles.patch
 
# New patch to add mount option to turn off extents
ext4_noextent_mount_opt.patch
# Now Turn on extents feature by default
ext4_extents_on_by_default.patch
 
#New patch to propagate inode flags
ext4-propagate_flags.patch
 
#New patch to add extent sanity checks
ext4-extent-sanity-checks.patch
 
#New patch to free blocks when failed to insert an extent
ext4-free-blocks-on-insert-extent-failure.patch

Cheers,
Mingming
