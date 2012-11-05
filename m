From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 03/19] vfs: add I/O frequency update function
Date: Mon, 5 Nov 2012 19:47:33 +0800
Message-ID: <CAEH94Li9M7fda5AExMvU_JbAKYHJHnZjTK6kpUQDTO5jnfS9eQ@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-4-git-send-email-zwu.kernel@gmail.com>
	<1352113625.2705.10.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57353 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2KELrf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Nov 2012 06:47:35 -0500
In-Reply-To: <1352113625.2705.10.camel@menhir>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 5, 2012 at 7:07 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Mon, 2012-10-29 at 12:30 +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add some util helpers to update access frequencies
>> for one file or its range.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c            |  179 ++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_tracking.h            |    7 ++
>>  include/linux/hot_tracking.h |    2 +
>>  3 files changed, 188 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> index 68591f0..0a7d9a3 100644
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -172,6 +172,137 @@ static void hot_inode_tree_exit(struct hot_info *root)
>>       }
>>  }
>>
>> +struct hot_inode_item
>> +*hot_inode_item_find(struct hot_info *root, u64 ino)
>> +{
>> +     struct hot_inode_item *he;
>> +     int ret;
>> +
>> +again:
>> +     spin_lock(&root->lock);
>> +     he = radix_tree_lookup(&root->hot_inode_tree, ino);
>> +     if (he) {
>> +             kref_get(&he->hot_inode.refs);
>> +             spin_unlock(&root->lock);
>> +             return he;
>> +     }
>> +     spin_unlock(&root->lock);
>> +
>> +     he = kmem_cache_zalloc(hot_inode_item_cachep,
>> +                             GFP_KERNEL | GFP_NOFS);
> This doesn't look quite right... which of these two did you mean? I
> assume probably just GFP_NOFS
Yes, good catch, thanks.
>
>> +     if (!he)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     hot_inode_item_init(he, ino, &root->hot_inode_tree);
>> +
>> +     ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
>> +     if (ret) {
>> +             kmem_cache_free(hot_inode_item_cachep, he);
>> +             return ERR_PTR(ret);
>> +     }
>> +
>> +     spin_lock(&root->lock);
>> +     ret = radix_tree_insert(&root->hot_inode_tree, ino, he);
>> +     if (ret == -EEXIST) {
>> +             kmem_cache_free(hot_inode_item_cachep, he);
>> +             spin_unlock(&root->lock);
>> +             radix_tree_preload_end();
>> +             goto again;
>> +     }
>> +     spin_unlock(&root->lock);
>> +     radix_tree_preload_end();
>> +
>> +     kref_get(&he->hot_inode.refs);
>> +     return he;
>> +}
>> +EXPORT_SYMBOL_GPL(hot_inode_item_find);
>> +
>> +static struct hot_range_item
>> +*hot_range_item_find(struct hot_inode_item *he,
>> +                     u32 start)
>> +{
>> +     struct hot_range_item *hr;
>> +     int ret;
>> +
>> +again:
>> +     spin_lock(&he->lock);
>> +     hr = radix_tree_lookup(&he->hot_range_tree, start);
>> +     if (hr) {
>> +             kref_get(&hr->hot_range.refs);
>> +             spin_unlock(&he->lock);
>> +             return hr;
>> +     }
>> +     spin_unlock(&he->lock);
>> +
>> +     hr = kmem_cache_zalloc(hot_range_item_cachep,
>> +                             GFP_KERNEL | GFP_NOFS);
> Likewise, here too.
ditto
>
> Steve.
>
>
>



-- 
Regards,

Zhi Yong Wu
