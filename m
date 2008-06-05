From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Fri, 6 Jun 2008 00:42:51 +0530
Message-ID: <20080605191251.GC4723@skywalker>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker> <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker> <20080605153701.GB25477@mit.edu> <20080605182830.GW2961@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:41290 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYFETNN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 15:13:13 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m55JDkuX005640
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 05:13:46 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m55JHLFb133972
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 05:17:21 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m55JD9x2030746
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jun 2008 05:13:10 +1000
Content-Disposition: inline
In-Reply-To: <20080605182830.GW2961@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 05, 2008 at 12:28:30PM -0600, Andreas Dilger wrote:
> On Jun 05, 2008  11:37 -0400, Theodore Ts'o wrote:
> > This is better, but it still means that we are exporting a large
> > number of functions to the callers.  It's not clear to me we need so
> > many different variants of ext4_new_blocks_* --- what is their
> > justification to exist?
> > 
> > For example, why not just have:
> > 
> > static ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
> >        				ext4_lblk_t iblock, ext4_fsblk_t goal,
> > 				unsigned long *count, int *errp, int meta)
> > 
> > where if inode is NULL, then you're allocating a metadata block, and
> > if count is NULL, then you only want one block.  Of course, this needs
> > to be carefully documented at the function.
> 
> I don't necessarily agree that meta should be implied by inode != NULL.
> We do want to cluster metadata allocations for a single inode if possible,
> so keeping the inode information is useful.  We may want to keep a separate
> "metadata goal block" from the "data goal block" in the inode...
> 
> That said, it seems you still have a "meta" parameter here?  I always hate
> having an int for a boolean, and we may as well make this a "flags" so
> that when we want to improve it later we don't need to rename it and change
> all of the "1" parameters to "EXT4_META_BLOCK".  Do it right the first time.
> 

how about ?

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index c6e6a6f..014e5b5 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1928,9 +1928,11 @@ ext4_fsblk_t ext4_orlov_new_blocks(handle_t *handle, struct inode *inode,
        return 0;
 }

+#defin EXT4_META_BLOCK 0x1
+
 static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
                                ext4_lblk_t iblock, ext4_fsblk_t goal,
-                               unsigned long *count, int *errp, int meta)
+                               unsigned long *count, int *errp, int flags)
 {
        struct ext4_allocation_request ar;
        ext4_fsblk_t ret;
@@ -1950,7 +1952,7 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
        ar.goal = goal;
        ar.len = *count;
        ar.logical = iblock;
-       if (S_ISREG(inode->i_mode) && !meta)
+       if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
                ar.flags = EXT4_MB_HINT_DATA;
        else
                /* disable in-core preallocation for non-regular files */
@@ -1965,13 +1967,15 @@ ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
                ext4_fsblk_t goal, int *errp)
 {
        unsigned long count = 1;
-       return do_blk_alloc(handle, inode, 0, goal, &count, errp, 1);
+       return do_blk_alloc(handle, inode, 0, goal, &count,
+                                               errp, EXT4_META_BLOCK);
 }

 ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
                ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
-       return do_blk_alloc(handle, inode, 0, goal, count, errp, 1);
+       return do_blk_alloc(handle, inode, 0, goal, count,
+                                       errp, EXT4_META_BLOCK);
 }

 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,

