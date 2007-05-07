From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: 2.6.21-ext4-1
Date: Mon, 07 May 2007 13:56:23 -0700
Message-ID: <1178571383.3933.8.camel@dyn9047017103.beaverton.ibm.com>
References: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Johann Lombardi <johann.lombardi@bull.net>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Dave Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:42817 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966590AbXEGU4j (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 May 2007 16:56:39 -0400
In-Reply-To: <E1HiXab-0001QX-Sk@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-04-30 at 11:14 -0400, Theodore Ts'o wrote:
> I've respun the ext4 development patchset, with Amit's updated fallocate
> patches.  I've added Dave's patch to add ia64 support to the fallocate
> system call, but *not* the XFS fallocate support patches.  (Probably
> better for them to live in an xfs tree, where they can more easily
> tested and updated.)  Yes, we haven't reached complete closure on the
> fallocate system call calling convention, but it's enough for us to get
> more testing in -mm.
> 
> Also added Johann's jbd2-stats-through-procfs patches; it provides
> useful help in turning the size of the journal, which will be useful in
> benchmarking efforts.  In addition, Alex Tomas's patch to free
> just-allocated patches when there is an error inserting the extent into
> the extent tree has also been included.
> 
> The patches have been compile-tested on x86, and compile/run-tested on
> x86/UML.  Would appreciate reports about testing on other platforms.
> 
I have tested this patch series on ppc64, x86_64 with
dbench/tiobench/fsx, all runs fine. 

I am not sure what level of testing Amit has done about the fallocate()
and preallocation code on various archs. I couldn't find a available
s390 and ia64 machines with free partition yet.

In any case, it would be useful to add a new set of testsuites for the
new fallocate() syscall and fsstress in LTP testsuites to automatically
the preallocation code in ext4/XFS.

thanks,
Mingming
> Thanks,
> 
> 						- Ted
> 
> P.S.  One bug which I've noted --- if there is a failure due to disk
> filling up, running e2fsck on the filesystem will show that the i_blocks
> fields on the inodes where there was a failure to allocate disk blocks
> are left incorrect.  I'm guessing this is a bug in the delayed
> allocation patches.  Alex, when you have a moment, could you take a
> look?  Thanks!!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
