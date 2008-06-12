From: Shen Feng <shen@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] ext4: Make ext4_ext_find_extent fills ext_path	completely
Date: Thu, 12 Jun 2008 08:28:23 +0800
Message-ID: <48506DA7.1070306@cn.fujitsu.com>
References: <484F68BE.8040203@cn.fujitsu.com> <20080611114344.GF9008@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53421 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYFLAby (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 20:31:54 -0400
In-Reply-To: <20080611114344.GF9008@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Aneesh Kumar K.V Wrote:
> On Wed, Jun 11, 2008 at 01:55:10PM +0800, Shen Feng wrote:
>> When pos=0 or depth, the fields of ext4_ext_path is not
>> completely filled.
>> This patch also removes some unnecessary code.
>>
>> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
>> ---
>>  fs/ext4/extents.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index d4f76d7..ff609df 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -524,6 +524,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>  		alloc = 1;
>>  	}
>>  	path[0].p_hdr = eh;
>> +	path[0].p_bh = NULL;
> 
> 
> We did a kzalloc before. So do we need this ?

If the path is not allocated by kzalloc, we need this.

> 
> 
> 
>>  	i = depth;
>>  	/* walk through the tree */
>> @@ -552,12 +553,11 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
>>  	}
>>
>>  	path[ppos].p_depth = i;
>> -	path[ppos].p_hdr = eh;
> 
> 
> This is needed. Because we look at extent_header  in ext_binsearch.

This has been done in the last while loop.

> 
> 
> 
>> -	path[ppos].p_ext = NULL;
>>  	path[ppos].p_idx = NULL;
>>
>>  	/* find extent */
>>  	ext4_ext_binsearch(inode, path + ppos, block);
>> +	path[ppos].p_block = ext4_ext_pblock(path[ppos].p_ext);
>>
>>  	ext4_ext_show_path(inode, path);
>>
> 
> -aneesh
> 
> 


