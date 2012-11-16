From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 02/19] vfs: initialize and free data structures
Date: Fri, 16 Nov 2012 14:16:13 +0800
Message-ID: <CAEH94Lj+Ju9KzJTo=g2Mb6sr6CLnpikur7_tWboWRDGRZgbxpQ@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-3-git-send-email-zwu.kernel@gmail.com>
	<20121106222442.GS3102@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48739 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2KPGQP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Nov 2012 01:16:15 -0500
In-Reply-To: <20121106222442.GS3102@twin.jikos.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 7, 2012 at 6:24 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:44PM +0800, zwu.kernel@gmail.com wrote:
>> +/* Frees the entire hot_range_tree. */
>> +static void hot_inode_item_free(struct kref *kref)
>> +{
>> +     struct hot_comm_item *comm_item = container_of(kref,
>> +                     struct hot_comm_item, refs);
>> +     struct hot_inode_item *he = container_of(comm_item,
>> +                     struct hot_inode_item, hot_inode);
>> +
>> +     hot_range_tree_free(he);
>> +     radix_tree_delete(he->hot_inode_tree, he->i_ino);
>
> void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
>
> and he::i_ino is u64, this will not work when
> sizeof(unsigned long) != sizeof(u64) (iirc this is a known limitation of
> radix tree implementation). This will work on 64bit only, not sure if
> this is intentional.
Fixed, thanks.
>
>> +     kmem_cache_free(hot_inode_item_cachep, he);
>> +}
>> +
>> +/* Frees the entire hot_inode_tree. */
>> +static void hot_inode_tree_exit(struct hot_info *root)
>> +{
>> +     struct hot_inode_item *hi_nodes[8];
>> +     u64 ino = 0;
>> +     int i, n;
>
> nitpick, put the declarations on separate lines
>
>> +
>> +     while (1) {
>> +             spin_lock(&root->lock);
>> +             n = radix_tree_gang_lookup(&root->hot_inode_tree,
>> +                                        (void **)hi_nodes, ino,
>> +                                        ARRAY_SIZE(hi_nodes));
>> +             if (!n) {
>> +                     spin_unlock(&root->lock);
>> +                     break;
>> +             }
>> +
>> +             ino = hi_nodes[n - 1]->i_ino + 1;
>> +             for (i = 0; i < n; i++)
>> +                     hot_inode_item_put(hi_nodes[i]);
>> +             spin_unlock(&root->lock);
>> +     }
>> +}
>> +
>>  /*
>>   * Initialize kmem cache for hot_inode_item and hot_range_item.
>>   */
>> @@ -106,3 +197,36 @@ err:
>>       kmem_cache_destroy(hot_inode_item_cachep);
>>  }
>>  EXPORT_SYMBOL_GPL(hot_cache_init);
>> +
>> +/*
>> + * Initialize the data structures for hot data tracking.
>> + */
>> +int hot_track_init(struct super_block *sb)
>> +{
>> +     struct hot_info *root;
>> +     int ret = -ENOMEM;
>> +
>> +     root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
>> +     if (!root) {
>> +             printk(KERN_ERR "%s: Failed to malloc memory for "
>> +                             "hot_info\n", __func__);
>> +             return ret;
>
> minor: you can drop the variable ret and just reurn ENOMEM here
>
>> +     }
>> +
>> +     sb->s_hot_root = root;
>> +     hot_inode_tree_init(root);
>> +
>> +     printk(KERN_INFO "VFS: Turning on hot data tracking\n");
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(hot_track_init);
>
> david



-- 
Regards,

Zhi Yong Wu
