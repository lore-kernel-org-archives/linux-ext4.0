From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V4] ext4: Fix lockdep recursive locking warning
Date: Sun, 23 Nov 2008 22:03:49 +0530
Message-ID: <20081123163349.GB17002@skywalker>
References: <1227285646-16263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081122204625.GF9150@mit.edu> <20081123024911.GG9150@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44848 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYKWQjB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Nov 2008 11:39:01 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mANGcAHQ020967
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 03:38:10 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mANGXxJO223812
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 03:33:59 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mANGXwN2002954
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 03:33:59 +1100
Content-Disposition: inline
In-Reply-To: <20081123024911.GG9150@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Nov 22, 2008 at 09:49:11PM -0500, Theodore Tso wrote:
> On Sat, Nov 22, 2008 at 03:46:25PM -0500, Theodore Tso wrote:
> > On Fri, Nov 21, 2008 at 10:10:46PM +0530, Aneesh Kumar K.V wrote:
> > > Indicate that the group locks can be taken in loop.
> > 
> > I've been looking at this patch more closely, and I think there's a
> > major problem here.
> 
> OK, after looking at this in yet more detail (and having changed
> planes in Dallas :-), I am more than ever convinced this patch is not
> rightq.  We have an rw_sem for each block group, grp->alloc_sem, which
> is allocated in groups of meta blockgroups.  The whole reason why we
> should worry about keeping them in the same class is we should worry
> about is if for some reason, the multiblock allocator happens to
> allocate two block group's alloc_sem, but one does them out of order
> (say, bg 4, then bg 2, while another does bg 2, then 4), we would get
> a dead lock.
> 
> I'm guessing that what caused the problem for you was
> ext4_mb_init_group(), which if you are using 1k filesystems, tries to
> grab multiple grp->alloc_sem's.  In each place where we find those, we
> need to use down_write_nested --- see Documentation/lockdep-design.txt.  

Correct

> 
> If there are any other places in mballoc.c which grabs multiple
> alloc_sem's at the same time, we'll have to use define new subclasses.

No. That is the only call site.

How about the below patch. We can have more than 2 groups in a page
depending on the page size and blocksize. So instead of using
single_depth I guess we should use the relative group number ?.

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 1fa311c..891ce41 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1783,7 +1783,7 @@ static int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
 		 * no block allocation going on in any
 		 * of that groups
 		 */
-		down_write(&grp->alloc_sem);
+		down_write_nested(&grp->alloc_sem, i);
 	}
 	/*
 	 * make sure we look at only those groups
