From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: Updated ext4/jbd2 patches based on 2.6.19-rc1
Date: Fri, 6 Oct 2006 12:22:17 +0530
Message-ID: <20061006065217.GA541@in.ibm.com>
References: <1160072610.8508.12.camel@kleikamp.austin.ibm.com> <20061005205526.7fe744f5.akpm@osdl.org> <20061005215442.310b7792.rdunlap@xenotime.net> <20061006055305.GG22010@schatzie.adilger.int> <20061005230401.0159e31b.akpm@osdl.org> <20061006064103.GJ22010@schatzie.adilger.int>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
	Dave Kleikamp <shaggy@austin.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:13538 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932642AbWJFGuS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Oct 2006 02:50:18 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k966oRuk007809
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 02:50:27 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k966oIGS131858
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 02:50:18 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k966oHMr018930
	for <linux-ext4@vger.kernel.org>; Fri, 6 Oct 2006 02:50:17 -0400
To: Andreas Dilger <adilger@clusterfs.com>
Content-Disposition: inline
In-Reply-To: <20061006064103.GJ22010@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 06, 2006 at 12:41:03AM -0600, Andreas Dilger wrote:
> On Oct 05, 2006  23:04 -0700, Andrew Morton wrote:
> > On Thu, 5 Oct 2006 23:53:05 -0600
> > Andreas Dilger <adilger@clusterfs.com> wrote:
> > > No, we want to leave it at ext4dev for a while, to make it very clear
> > > that this is still under development.  We want to get the existing
> > > patches upstream so they don't become completely unwieldy, and earlier
> > > testing is also good, but it is not yet feature complete.
> > > 
> > 
> > What features are missing?
> 
> There are several under discussion, whether they all make it in is
> partly a function of how much time everyone has to work on them:
> - improved file allocation (multi-block alloc, delayed alloc; basically done)
> - fix 32000 subdirectory limit (patch exists, needs some e2fsck work)
> - nsec timestamps for mtime, atime, ctime, create time (patch exists,
>   needs some e2fsck work)
> - inode version field on disk (NFSv4, Lustre; prototype exists) 
> - reduced mke2fs/e2fsck time via uninitialized groups (prototype exists)
> - journal checksumming for robustness, performance (prototype exists)
> 
> Features like metadata checksumming have been discussed and planned for
> a bit but no patches exist yet so I'm not sure they're in the near-term
> roadmap.

I would add persistent preallocation (of uninitialized blocks) support to the
list. Right now we have only put in support to recognize uninitialized
extents so that we can add preallocation, but will be working on developing
the actual implementation for persistent preallocation.

Regards
Suparna

> 
> > Heck, what features does it have now?  Guys, we cannot release this thing
> > to the public without telling them what it is, how to use it, where to get
> > the tools from and what the roadmap is.
> 
> Features now:
> - ability to use filesystems > 16TB
> - extent format reduces metadata overhead (RAM, IO for access, transactions)
> - extent format more robust in face of on-disk corruption due to magics,
>   internal redunancy in tree
> 
> Features soon (previously available, to be enabled by default by "mkefs.ext4"):
> - dir_index and resize inode will be on by default
> - large inodes will be used by default for fast EAs, nsec timestamps, etc
> 
> Other features as above patches are committed.
> 
> The big performance win will come with mballoc and delalloc.  CFS has
> been using mballoc for a few years already with Lustre, and IBM + Bull
> did a lot of benchmarking on it.  The reason it isn't in the first set of
> patches is partly a manageability issue, and partly because it doesn't
> directly affect the on-disk format (outside of much better allocation)
> so it isn't critical to get into the first round of changes.  I believe
> Alex is working on a new set of patches right now.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

