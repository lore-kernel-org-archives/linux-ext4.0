From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Tue, 17 Jun 2008 17:42:57 +0800
Message-ID: <48578721.4020205@cn.fujitsu.com>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>	 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>	 <20080605032220.GC10488@mit.edu>  <20080605084329.GB8942@skywalker> <1212677741.3645.44.camel@localhost.localdomain> <4855E0F2.9070207@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Theodore Tso <tytso@mit.edu>, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62141 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYFQJq0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2008 05:46:26 -0400
In-Reply-To: <4855E0F2.9070207@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Shen Feng Wrote:
> 
> Mingming Cao Wrote:
>> On Thu, 2008-06-05 at 14:13 +0530, Aneesh Kumar K.V wrote:
>>> On Wed, Jun 04, 2008 at 11:22:20PM -0400, Theodore Tso wrote:
>>>> when I moved this patch to the beginning of the unstable patch queue,
>>>> it didn't apply.  When I tried to look at it, my head started
>>>> spinning.  The patch applied to the wrong function, apparently,
>>>> because there is so much code duplication "patch" got confused.  I
>>>> can't blame it, though, because *I* got confused.  
>>>>
> 
> ...snip...
> 
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index 09922ae..a810a21 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -4048,7 +4048,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
>>>  	sbi = EXT4_SB(sb);
>>>
>>>  	if (!test_opt(sb, MBALLOC)) {
>>> -		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
>>> +		block = ext4_orlov_new_blocks(handle, ar->inode, ar->goal,
>>>  					    &(ar->len), errp);
>>>  		return block;
>>>  	}
>> when we get to ext4_mb_new_blocks, don't we already tested MBALLOC is
>> turned on?
>>
> 
> ext4_ext_get_blocks calls ext4_mb_new_blocks. So we have to check this.
> So maybe ext4_ext_get_blocks should call ext4_new_blocks and 
> we can remove this check.
> 

How about this patch?
I tested it with bonnie++ and ltp fs test using mballoc and nonomballoc
options.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |   25 +++++++++----------------
 fs/ext4/mballoc.c |    6 ------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 47929c4..3f6be32 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2528,7 +2528,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t goal, newblock;
 	int err = 0, depth, ret;
 	unsigned long allocated = 0;
-	struct ext4_allocation_request ar;
+	ext4_lblk_t lleft, lright;
+	ext4_fsblk_t pleft, pright;
 
 	__clear_bit(BH_New, &bh_result->b_state);
 	ext_debug("blocks %u/%lu requested for inode %u\n",
@@ -2653,12 +2654,12 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		ext4_init_block_alloc_info(inode);
 
 	/* find neighbour allocated blocks */
-	ar.lleft = iblock;
-	err = ext4_ext_search_left(inode, path, &ar.lleft, &ar.pleft);
+	lleft = iblock;
+	err = ext4_ext_search_left(inode, path, &lleft, &pleft);
 	if (err)
 		goto out2;
-	ar.lright = iblock;
-	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright);
+	lright = iblock;
+	err = ext4_ext_search_right(inode, path, &lright, &pright);
 	if (err)
 		goto out2;
 
@@ -2685,16 +2686,8 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 		allocated = max_blocks;
 
 	/* allocate new block */
-	ar.inode = inode;
-	ar.goal = ext4_ext_find_goal(inode, path, iblock);
-	ar.logical = iblock;
-	ar.len = allocated;
-	if (S_ISREG(inode->i_mode))
-		ar.flags = EXT4_MB_HINT_DATA;
-	else
-		/* disable in-core preallocation for non-regular files */
-		ar.flags = 0;
-	newblock = ext4_mb_new_blocks(handle, &ar, &err);
+	goal = ext4_ext_find_goal(inode, path, iblock);
+	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
 	ext_debug("allocate new block: goal %llu, found %llu/%lu\n",
@@ -2702,7 +2695,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* try to insert new extent into found leaf and return */
 	ext4_ext_store_pblock(&newex, newblock);
-	newex.ee_len = cpu_to_le16(ar.len);
+	newex.ee_len = cpu_to_le16(allocated);
 	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c9900aa..bc82d39 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4010,12 +4010,6 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
 
-	if (!test_opt(sb, MBALLOC)) {
-		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
-					    &(ar->len), errp);
-		return block;
-	}
