From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] ext4: Make ext4_ext_find_extent fills ext_path	completely
Date: Fri, 13 Jun 2008 14:47:39 +0800
Message-ID: <4852180B.6060204@cn.fujitsu.com>
References: <484F68BE.8040203@cn.fujitsu.com> <1213309672.3698.22.camel@localhost.localdomain> <48520833.1080802@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57549 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbYFMGvI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jun 2008 02:51:08 -0400
In-Reply-To: <48520833.1080802@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Shen Feng Wrote:
> 
> Mingming Cao Wrote:
>> On Wed, 2008-06-11 at 13:55 +0800, Shen Feng wrote:
>>> When pos=0 or depth, the fields of ext4_ext_path is not
>>> completely filled.
>>> This patch also removes some unnecessary code.
>>>
>> I added this patch to the patch queue, unless somebody disagree.
>>
>> Mingming
>>> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
>>> ---
>>>  fs/ext4/extents.c |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>>> index d4f76d7..ff609df 100644
>>> --- a/fs/ext4/extents.c
>>> +++ b/fs/ext4/extents.c
>>> @@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>  		alloc = 1;
>>>  	}
>>>  	path[0].p_hdr = eh;
>>> +	path[0].p_bh = NULL;
>>>
>>>  	i = depth;
>>>  	/* walk through the tree */
>>> @@ -552,12 +553,11 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>>  	}
>>>
>>>  	path[ppos].p_depth = i;
>>> -	path[ppos].p_hdr = eh;
>>> -	path[ppos].p_ext = NULL;
>>>  	path[ppos].p_idx = NULL;
>>>
>>>  	/* find extent */
>>>  	ext4_ext_binsearch(inode, path + ppos, block);
>>> +	path[ppos].p_block = ext4_ext_pblock(path[ppos].p_ext);
> 
> Today I tested the patch with bonnie++ and found that sometimes
> path[ppos].p_ext may be NULL. This may cause kernel oops.
> 
> This is because ext4_ext_binsearch return directly when the leaf is empty.
> 
I updated the patch as following.
This patch is tested by bonnie++ and ltp fs test.
This patch is also rebased from the 2.6.26-RC5 and has no dependency to 
ext4: add ext4_ prefix for ext_block and idx_pblock patch.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/ext4/extents.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 47929c4..1d636cb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 		alloc = 1;
 	}
 	path[0].p_hdr = eh;
+	path[0].p_bh = NULL;
 
 	i = depth;
 	/* walk through the tree */
@@ -552,12 +553,14 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	}
 
 	path[ppos].p_depth = i;
-	path[ppos].p_hdr = eh;
 	path[ppos].p_ext = NULL;
 	path[ppos].p_idx = NULL;
 
 	/* find extent */
 	ext4_ext_binsearch(inode, path + ppos, block);
+	/* if not an empty leaf */
+	if (path[ppos].p_ext)
+		path[ppos].p_block = ext_pblock(path[ppos].p_ext);
 
 	ext4_ext_show_path(inode, path);
 
-- 1.5.5.1 
