From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Understanding mballoc
Date: Mon, 3 Dec 2007 23:42:37 +0530
Message-ID: <20071203181237.GD7222@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Alex Tomas <bzzz@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:33927 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183AbXLCSMm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2007 13:12:42 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id lB3ICeCE021261
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 23:42:40 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lB3ICd9o4477070
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 23:42:40 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id lB3ICdIO002537
	for <linux-ext4@vger.kernel.org>; Mon, 3 Dec 2007 18:12:39 GMT
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Alex,

This is my attempt at understanding multi block allocator. I have
few questions marked as FIXME below. Can you help answering them.
Most of this data is already in the patch queue as commit message.
I have updated some details regarding preallocation. Once we
understand the details i will update the patch queue commit message.



The allocation request involve request for multiple number of
blocks near to the goal(block) value specified.

During initialization phase of the allocator we decide to use the group
preallocation or inode preallocation depending on the size of the request. If
the request is smaller than  sbi->s_mb_small_req we select the group
preallocation.  This is needed because we would like to have the small files
closer. The value of s_mb_small_req  is 256 blocks.

/* FIXME!!
Does the value of s_mb_small_req depend on the s_mb_prealloc_table ?
If yes, then how do we update the s_mb_small_req. We have a  hook to update
the prealloc table via /proc. But that doesn't update the s_mb_small_req.
*/

/* FIXME!! The code within ext4_mb_group_or_file does  below.
if (ac->ac_o_ex.fe_len >= sbi->s_mb_large_req)
	return;

if (ac->ac_o_ex.fe_len >= >sbi->s_mb_small_req)
	return;

That doesn't seem to make sense because the if the len is greater than
s_mb_sall_req it will be always greater than s_mb_large_req. What are we
expecting to do here ?
*/


First stage the allocator looks at the inode prealloc list
ext4_inode_info->i_prealloc_list contain list of prealloc
spaces for this particular inode. The inode prealloc space
is represented as
pa_lstart -> the logical start block for this prealloc space
pa_pstart -> the physical start block for this prealloc space
pa_len    -> lenght for this prealloc space
pa_free   ->  free space available in this prealloc space

The inode preallocation space is used looking at the _logical_
start block. If only the logical file block falls within the
range of prealloc space we will consume the particular prealloc
space. This make sure that that the we have contiguous physical
blocks representing the file blocks

The important thing to be noted in case of inode prealloc space
is that we don't modify the values associated to inode prealloc
space except pa_free.

If we are not able to find blocks in the inode prealloc space and if we have
the group allocation flag set then we look at the locality group prealloc
space. These are per CPU prealloc list repreasented as

ext4_sb_info.s_locality_groups[smp_processor_id()]

/* FIXME!! 
After getting the locality group related to the current CPU we could be
scheduled out and scheduled in on different CPU. So why are we putting the
locality group per cpu ?
*/

The locality group prealloc space is used looking at whether we have
enough free space (pa_free) withing the prealloc space.


If we can't allocate blocks via inode prealloc or/and locality group prealloc
then we look at the buddy cache. The buddy cache is represented by
ext4_sb_info.s_buddy_cache (struct inode) whose file offset gets mapped to the
buddy and bitmap information regarding different groups. The buddy information
is attached to buddy cache inode so that we can access them through the page
cache. The information regarding each group is loaded via ext4_mb_load_buddy.
The information involve block bitmap and buddy information. The information are
stored in the inode as

 {                        page                        }
 [ group 0 buddy][ group 0 bitmap] [group 1][ group 1]...


one block each for bitmap and buddy information.
So for each group we take up 2 blocks. A page can
contain blocks_per_page (PAGE_CACHE_SIZE / blocksize)  blocks.
So it can have information regarding groups_per_page which
is blocks_per_page/2

Buddy cachche inode is not stored on disk. The inode get
thrown away at the end when unmounting the disk.

We look for count number of blocks in the buddy cache. If
we were able to locate that many free blocks we return
with additional information regarding rest of the
contiguous physical block available

/* FIXME: 
We need to explain the normalization of the request length.
What are the conditions we are checking the request length
against. Why are group request always requested at 512 blocks ?


Buddy scanning follows different criteria. We need to explain what
a "criteria" is how they infulence the allocation 
*/

If we allocate more space than we requested for then the remaining
space get added to the locality group prealloc space or
inode prealloc space.


Both the prealloc space are getting populated
as above. So for the first request we will hit the buddy cache
which will result in this prealloc space getting filled. The prealloc
space is then later used for the subsequent request.
