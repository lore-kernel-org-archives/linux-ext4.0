From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v2 05/10] vfs: introduce one hash table
Date: Wed, 26 Sep 2012 12:08:51 +0800
Message-ID: <CAEH94LiWJQDmm=Sqn3yQ81KPrA_7qfGLZh+JHqOo_5T8unUywQ@mail.gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
	<1348404995-14372-6-git-send-email-zwu.kernel@gmail.com>
	<20120925095401.GA2456@ram-ThinkPad-T61>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	david@fromorbit.com, stroetmann@ontolinux.com, diegocg@gmail.com,
	chris@csamuel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120925095401.GA2456@ram-ThinkPad-T61>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 25, 2012 at 5:54 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Sun, Sep 23, 2012 at 08:56:30PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Adds a hash table structure which contains
>> a lot of hash list and is used to efficiently
>> look up the data temperature of a file or its
>> ranges.
>>   In each hash list of hash table, the hash node
>> will keep track of temperature info.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c            |   77 ++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/hot_tracking.h |   35 +++++++++++++++++++
>>  2 files changed, 110 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> index fa89f70..5f96442 100644
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/module.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/hardirq.h>
>> +#include <linux/hash.h>
>>  #include <linux/fs.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/types.h>
>> @@ -24,6 +25,9 @@
>
> ...snip...
>
>> +/* Hash list heads for hot hash table */
>> +struct hot_hash_head {
>> +     struct hlist_head hashhead;
>> +     rwlock_t rwlock;
>> +     u32 temperature;
>> +};
>> +
>> +/* Nodes stored in each hash list of hash table */
>> +struct hot_hash_node {
>> +     struct hlist_node hashnode;
>> +     struct list_head node;
>> +     struct hot_freq_data *hot_freq_data;
>> +     struct hot_hash_head *hlist;
>> +     spinlock_t lock; /* protects hlist */
>> +
>> +     /*
>> +      * number of references to this node
>> +      * equals 1 (hashlist entry)
>> +      */
>> +     struct kref refs;
>> +};
>
> Dont see why you need yet another datastructure to hash the inode_item
> and the range_item into a hash list.  You can just add another
If there's such one structure, we can rapidly know which hash bucket
one inode_item is currently linking to via its hlist field.
This is useful if one inode_item corresponding to one file need to
move from one bucket to another bucket when this file get cold or
hotter.
Does it make sense to you?

> hlist_node in the inode_item and range_item. This field can be then used
> to link into the corresponding hash list.
>
> You can use the container_of() get to the inode_item or the range_item
> using the hlist_node field.
>
> You can thus eliminate a lot of code.
As what i said above, i don't think it can eliminate a lo of code.
>
>> +
>>  /* An item representing an inode and its access frequency */
>>  struct hot_inode_item {
>>       /* node for hot_inode_tree rb_tree */
>> @@ -68,6 +93,8 @@ struct hot_inode_item {
>>       spinlock_t lock;
>>       /* prevents kfree */
>>       struct kref refs;
>> +     /* hashlist node for this inode */
>> +     struct hot_hash_node *heat_node;
>
> this can be just
>         struct hlist_node head_node; /* lookup hot_inode hash list */
>
> Use this field to link it into the corresponding hashlist.
>
>>  };
>>
> this can be just
>>  /*
>> @@ -91,6 +118,8 @@ struct hot_range_item {
>>       spinlock_t lock;
>>       /* prevents kfree */
>>       struct kref refs;
>> +     /* hashlist node for this range */
>> +     struct hot_hash_node *heat_node;
>
> this can be just
>         struct hlist_node head_node; /* lookup hot_range hash list */
>
>
>>  };
>>
>>  struct hot_info {
>> @@ -98,6 +127,12 @@ struct hot_info {
>>
>>       /* red-black tree that keeps track of fs-wide hot data */
>>       struct hot_inode_tree hot_inode_tree;
>> +
>> +     /* hash map of inode temperature */
>> +     struct hot_hash_head heat_inode_hl[HEAT_HASH_SIZE];
>> +
>> +     /* hash map of range temperature */
>> +     struct hot_hash_head heat_range_hl[HEAT_HASH_SIZE];
>>  };
>>
>>  #endif  /* _LINUX_HOTTRACK_H */
>



-- 
Regards,

Zhi Yong Wu
