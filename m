From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] avoid scanning bitmaps for group preallocation
Date: Fri, 26 Mar 2010 15:58:12 +0530
Message-ID: <87y6hfwf5v.fsf@linux.vnet.ibm.com>
References: <A2A61325-CB7F-40E0-B9B9-A918135BCBC6@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: Andreas Dilger <adilger@sun.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35503 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab0CZK2W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 06:28:22 -0400
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id o2QASJqn017784
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 15:58:19 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2QASEma2887850
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 15:58:14 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o2QASDnh000965
	for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 21:28:13 +1100
In-Reply-To: <A2A61325-CB7F-40E0-B9B9-A918135BCBC6@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 22 Mar 2010 16:03:10 -0600, Andreas Dilger <adilger@sun.com> wrote:
> Here is the patch I mentioned today on the call.  It avoids (or at  
> least reduces) serious latency (10 minutes or more) on a large  
> filesystem (8TB+) on the first write, if the filesystem is nearly  
> full.  The latency is entirely due to seeking to read the block  
> bitmaps, so is considerably less serious on flex_bg formatted  
> filesystems.
> 
> A better long-term approach would be to store in the superblock the  
> last group that had space to allocate a stripe-sized chunk and/or flag  
> in the group descriptor if there is not a large amount of contiguous  
> free space therein (cleared on freeing blocks in the group).
> 
> Having the mount-time buddy-bitmap (and checksum verifying) scanning  
> thread start at mount would only help if the first write to the  
> filesystem is not immediately after mount (which it is in Lustre at  
> least).  Having a filesystem-wide (r)btree for the freespace (ala XFS)  
> would also only help if the btree could be (at least partially) built  
> from bitmaps before the first write, unless we cache the bitmap on  
> disk, which caused Lustre plenty in the past and I'm leery to do it.
> 
> 

@@ -125,8 +125,7 @@
  * list. In case of inode preallocation we follow a list of heuristics
  * based on file size. This can be found in ext4_mb_normalize_request. If
  * we are doing a group prealloc we try to normalize the request to
- * sbi->s_mb_group_prealloc. Default value of s_mb_group_prealloc is
- * 512 blocks. This can be tuned via
+ * sbi->s_mb_group_prealloc.  This can be tuned via
  * /sys/fs/ext4/<partition/mb_group_prealloc. The value is represented in
  * terms of number of blocks. If we have mounted the file system with -O
  * stripe=<value> option the group prealloc request is normalized to the
@@ -2029,9 +2028,12 @@ repeat:
			if (group == ngroups)
				group = 0;
 
-			/* quick check to skip empty groups */
+			/* If there's no chance that this group has a better
+			 * extent, just skip it instead of seeking to read
+			 * block bitmap from disk. Initially ac_b_ex.fe_len = 0,
+			 * so this always skips groups with no free space. */
			grp = ext4_get_group_info(sb, group);
-			if (grp->bb_free == 0)
+			if (grp->bb_free <= ac->ac_b_ex.fe_len)
				continue;
 
			err = ext4_mb_load_buddy(sb, group, &e4b);

I was wondering whether we need to make sure we also use criteria value
when checking for bb_free. If we are really low on space we may want to
return what is left right ?. Or does ac_b_ex take care of that ?

-aneesh
