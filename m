From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v2 02/10] vfs: add support for updating access frequency
Date: Wed, 26 Sep 2012 10:53:07 +0800
Message-ID: <CAEH94Lg5haGMh0rkiv27tchthhFGk0o-+FAGiJ5zvPTcO8QbwA@mail.gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
	<1348404995-14372-3-git-send-email-zwu.kernel@gmail.com>
	<20120925091739.GB29154@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	cmm@us.ibm.com, tytso@mit.edu, marco.stornelli@gmail.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120925091739.GB29154@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

thanks a lot for your review in my heart, Dave. It is very helpful to me.

On Tue, Sep 25, 2012 at 5:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Sep 23, 2012 at 08:56:27PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add some utils helpers to update access frequencies
>> for one file or its range.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c |  359 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_tracking.h |   15 +++
>>  2 files changed, 374 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> index 173054b..52ed926 100644
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -106,6 +106,365 @@ inode_err:
>>  }
>>
>>  /*
>> + * Drops the reference out on hot_inode_item by one and free the structure
>> + * if the reference count hits zero
>> + */
>> +void hot_rb_free_hot_inode_item(struct hot_inode_item *he)
>
> hot_inode_item_put()
>
>> +{
>> +     if (!he)
>> +             return;
>
> It's a bug to call a put function on a kref counted item with a null
> pointer. Let the kernel crash so it is noticed and fixed.
OK, will remove it.
>
>> +
>> +     if (atomic_dec_and_test(&he->refs.refcount)) {
>> +             WARN_ON(he->in_tree);
>> +             kmem_cache_free(hot_inode_item_cache, he);
>> +     }
>
> Isn't this abusing krefs? i.e. this should be:
Sorry, thanks for your explaination as below:
>
> hot_inode_item_free()
> {
>         WARN_ON(he->in_tree);
>         kmem_cache_free(hot_inode_item_cache, he);
> }
>
> hot_inode_item_put()
> {
>         kref_put(&he->refs, hot_inode_item_free)
> }
>
>> +/*
>> + * Drops the reference out on hot_range_item by one and free the structure
>> + * if the reference count hits zero
>> + */
>> +static void hot_rb_free_hot_range_item(struct hot_range_item *hr)
>
> same comments as above.
OK, thanks.
> ....
>> +static struct rb_node *hot_rb_insert_hot_inode_item(struct rb_root *root,
>> +                                             unsigned long inode_num,
>> +                                             struct rb_node *node)
>
> static struct rb_node *
> hot_inode_item_find(..... )
OK, thanks.
>
>> +{
>> +     struct rb_node **p = &root->rb_node;
>> +     struct rb_node *parent = NULL;
>> +     struct hot_inode_item *entry;
>> +
>> +     /* walk tree to find insertion point */
>> +     while (*p) {
>> +             parent = *p;
>> +             entry = rb_entry(parent, struct hot_inode_item, rb_node);
>> +
>> +             if (inode_num < entry->i_ino)
>> +                     p = &(*p)->rb_left;
>> +             else if (inode_num > entry->i_ino)
>> +                     p = &(*p)->rb_right;
>> +             else
>> +                     return parent;
>> +     }
>> +
>> +     entry = rb_entry(node, struct hot_inode_item, rb_node);
>> +     entry->in_tree = 1;
>> +     rb_link_node(node, parent, p);
>> +     rb_insert_color(node, root);
>
> So the hot inode item search key is the inode number? Why use an
Yes
> rb-tree then? Wouldn't a btree be a more memory efficient way to
> hold a sparse index that has fixed key and pointer sizes?
Yes, i know, but if we don't use btree, what will be better? Radix tree?

>
> Also, the API seems quite strange. you pass in the the rb_node and
> the inode number which instead of passing in the hot inode item that
> already holds this information. You then convert the rb_node back to
> a hot inode item to set the in_tree variable. So why not just pass
> in the struct hot_inode_item in the first place?
Good catch, thanks for your remider.
>
>> +static u64 hot_rb_range_end(struct hot_range_item *hr)
>
> hot_range_item_end()
OK
>
>> +{
>> +     if (hr->start + hr->len < hr->start)
>> +             return (u64)-1;
>> +
>> +     return hr->start + hr->len - 1;
>> +}
>> +
>> +static struct rb_node *hot_rb_insert_hot_range_item(struct rb_root *root,
>
> hot_range_item_find()
OK
>
>> +                                             u64 start,
>> +                                             struct rb_node *node)
>> +{
>> +     struct rb_node **p = &root->rb_node;
>> +     struct rb_node *parent = NULL;
>> +     struct hot_range_item *entry;
>> +
>> +     /* ensure start is on a range boundary */
>> +     start = start & RANGE_SIZE_MASK;
>> +     /* walk tree to find insertion point */
>> +     while (*p) {
>> +             parent = *p;
>> +             entry = rb_entry(parent, struct hot_range_item, rb_node);
>> +
>> +             if (start < entry->start)
>> +                     p = &(*p)->rb_left;
>> +             else if (start >= hot_rb_range_end(entry))
>
> Shouldn't an aligned end always be one byte short of the start
> offset of the next aligned region? i.e. start ==
> hot_rb_range_end(entry) is an indication of an off-by one bug
> somewhere?
This is really one good catch, thanks.
>
>> +                     p = &(*p)->rb_right;
>> +             else
>> +                     return parent;
>> +     }
>> +
>> +     entry = rb_entry(node, struct hot_range_item, rb_node);
>> +     entry->in_tree = 1;
>> +     rb_link_node(node, parent, p);
>> +     rb_insert_color(node, root);
>
> Same comments as the hot_inode_range.
OK.
>
> Also, the start offset in the hot_range_item is already aligned, so
> why do you need to align it again?
ah, thanks, will remove it.
>
>> +
>> +     return NULL;
>> +}
>> +
>> +/*
>> + * Add a hot_inode_item to a hot_inode_tree. If the tree already contains
>> + * an item with the index given, return -EEXIST
>> + */
>> +static int hot_rb_add_hot_inode_item(struct hot_inode_tree *tree,
>> +                             struct hot_inode_item *he)
>> +{
>> +     int ret = 0;
>> +     struct rb_node *rb;
>> +
>> +     rb = hot_rb_insert_hot_inode_item(
>> +                     &tree->map, he->i_ino, &he->rb_node);
>> +     if (rb) {
>> +             ret = -EEXIST;
>> +             goto out;
>> +     }
>> +
>> +     kref_get(&he->refs);
>> +
>> +out:
>> +     return ret;
>
> And this really just seems like a useless wrapper. just move the
> -EEXIST and kref_get(&he->refs); into hot_inode_item_find() and
> call that directly....
OK, thanks.
>
>> +}
>> +
>> +/*
>> + * Add a hot_range_item to a hot_range_tree. If the tree already contains
>> + * an item with the index given, return -EEXIST
>> + *
>> + * Also optionally aggresively merge ranges (currently disabled)
>> + */
>> +static int hot_rb_add_hot_range_item(struct hot_range_tree *tree,
>> +                     struct hot_range_item *hr)
>> +{
>> +     int ret = 0;
>> +     struct rb_node *rb;
>> +
>> +     rb = hot_rb_insert_hot_range_item(
>> +                             &tree->map, hr->start, &hr->rb_node);
>> +     if (rb) {
>> +             ret = -EEXIST;
>> +             goto out;
>> +     }
>> +
>> +     kref_get(&hr->refs);
>> +
>> +out:
>> +     return ret;
>> +}
>
> Same again.
OK.
>
>> +
>> +/*
>> + * Lookup a hot_inode_item in the hot_inode_tree with the given index
>> + * (inode_num)
>> + */
>> +struct hot_inode_item
>> +*hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
>> +                             unsigned long inode_num)
>> +{
>> +     struct rb_node **p = &(tree->map.rb_node);
>> +     struct rb_node *parent = NULL;
>> +     struct hot_inode_item *entry;
>> +
>> +     while (*p) {
>> +             parent = *p;
>> +             entry = rb_entry(parent, struct hot_inode_item, rb_node);
>> +
>> +             if (inode_num < entry->i_ino)
>> +                     p = &(*p)->rb_left;
>> +             else if (inode_num > entry->i_ino)
>> +                     p = &(*p)->rb_right;
>> +             else {
>> +                     kref_get(&entry->refs);
>> +                     return entry;
>> +             }
>> +     }
>> +
>> +     return NULL;
>> +}
>
> That's basically a duplicate of hot_inode_item_find(), jus
> without the rb_node parameter. You could combine the two into a
> single function - the lookup simply passes a NULL rb_node parameter.
> That would then justify passing the inode number and rb_node
> separately rather than the hot_inode_item into the insert
> function....
Got it. thanks.
>
>> +
>> +/*
>> + * Lookup a hot_range_item in a hot_range_tree with the given index
>> + * (start, offset)
>> + */
>> +static struct hot_range_item
>> +*hot_rb_lookup_hot_range_item(struct hot_range_tree *tree,
>> +                             u64 start)
>> +{
>> +     struct rb_node **p = &(tree->map.rb_node);
>> +     struct rb_node *parent = NULL;
>> +     struct hot_range_item *entry;
>> +
>> +     /* ensure start is on a range boundary */
>> +     start = start & RANGE_SIZE_MASK;
>> +     while (*p) {
>> +             parent = *p;
>> +             entry = rb_entry(parent, struct hot_range_item, rb_node);
>> +
>> +             if (start < entry->start)
>> +                     p = &(*p)->rb_left;
>> +             else if (start > hot_rb_range_end(entry))
>> +                     p = &(*p)->rb_right;
>> +             else {
>> +                     kref_get(&entry->refs);
>> +                     return entry;
>> +             }
>> +     }
>> +
>> +     return NULL;
>> +}
>
> Same again.
OK
>
>> +
>> +/*
>> + * This function does the actual work of updating the frequency numbers,
>> + * whatever they turn out to be. FREQ_POWER determines how many atime
>> + * deltas we keep track of (as a power of 2). So, setting it to anything above
>> + * 16ish is probably overkill. Also, the higher the power, the more bits get
>> + * right shifted out of the timestamp, reducing precision, so take note of that
>> + * as well.
>> + *
>> + * The caller should have already locked freq_data's parent's spinlock.
>> + *
>> + * FREQ_POWER, defined immediately below, determines how heavily to weight
>> + * the current frequency numbers against the newest access. For example, a value
>> + * of 4 means that the new access information will be weighted 1/16th (ie 2^-4)
>> + * as heavily as the existing frequency info. In essence, this is a kludged-
>> + * together version of a weighted average, since we can't afford to keep all of
>> + * the information that it would take to get a _real_ weighted average.
>> + */
>> +static void hot_rb_update_freq(struct hot_freq_data *freq_data, int rw)
>
> hot_inode_freq_update(struct hot_freq_data *freq_data, bool write)
OK
>
>> +{
>> +     struct timespec old_atime;
>> +     struct timespec current_time;
>> +     struct timespec delta_ts;
>> +     u64 new_avg;
>> +     u64 new_delta;
>> +
>> +     if (unlikely(rw)) {
>
> Don't use unlikely() - the branch predictor in a modern CPU is
> better than static hints almost all the time. so:
OK
>
>         if (write) {
>
>> +             old_atime = freq_data->last_write_time;
>> +             freq_data->nr_writes += 1;
>> +             new_avg = freq_data->avg_delta_writes;
>> +     } else {
>> +             old_atime = freq_data->last_read_time;
>> +             freq_data->nr_reads += 1;
>> +             new_avg = freq_data->avg_delta_reads;
>> +     }
>> +
>> +     current_time = current_kernel_time();
>> +     delta_ts = timespec_sub(current_time, old_atime);
>> +     new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
>> +
>> +     new_avg = (new_avg << FREQ_POWER) - new_avg + new_delta;
>> +     new_avg = new_avg >> FREQ_POWER;
>> +
>> +     if (unlikely(rw)) {
>> +             freq_data->last_write_time = current_time;
>> +             freq_data->avg_delta_writes = new_avg;
>> +     } else {
>> +             freq_data->last_read_time = current_time;
>> +             freq_data->avg_delta_reads = new_avg;
>> +     }
>> +}
>
> static u64  update_average(struct timespec old_atime,
>                            struct timespec current_time, u64 avg)
> {
>         struct timespec delta_ts;
>         u64 new_delta;
>
>         delta_ts = timespec_sub(current_time, old_atime);
>         new_delta = timespec_to_ns(&delta_ts) >> FREQ_POWER;
>
>         avg = (avg << FREQ_POWER) - avg + new_delta;
>         avg = avg >> FREQ_POWER;
>
>         return avg
> }
>
> static void hot_inode_freq_update(struct hot_freq_data *freq_data, bool write)
> {
>         struct timespec current_time = current_kernel_time();
>
>         if (write) {
>                 freq_data->avg_delta_writes = update_average(
>                                                 freq_data->last_write_time,
>                                                 current_time,
>                                                 freq_data->avg_delta_writes);
>                 freq_data->last_write_time = current_time;
>                 return;
>         }
>
>         freq_data->avg_delta_reads = update_average(
>                                         freq_data->last_read_time,
>                                         current_time,
>                                         freq_data->avg_delta_reads);
>         freq_data->last_read_time = current_time;
> }
OK, thanks a lot.
>
>> +
>> +/* Update inode frequency struct */
>> +static struct hot_inode_item *hot_rb_update_inode_freq(struct inode *inode,
>> +                                                     int rw)
>> +{
>> +     struct hot_info *root = &(inode->i_sb->s_hotinfo);
>> +     struct hot_inode_tree *hitree = &(root->hot_inode_tree);
>> +     struct hot_inode_item *he;
>> +
>> +     read_lock(&hitree->lock);
>> +     he = hot_rb_lookup_hot_inode_item(hitree, inode->i_ino);
>> +     read_unlock(&hitree->lock);
>> +
>> +     if (!he) {
>> +             he = kmem_cache_alloc(hot_inode_item_cache,
>> +                                     GFP_KERNEL | GFP_NOFS);
>> +             if (!he)
>> +                     goto out;
>> +
>> +             write_lock(&hitree->lock);
>> +             hot_rb_inode_item_init(he);
>> +             he->i_ino = inode->i_ino;
>> +             hot_rb_add_hot_inode_item(hitree, he);
>> +             write_unlock(&hitree->lock);
>> +     }
>
> The insert is racy - you've dropped the lock after the failed
> lookup, so you can race with another failed lookup to insert the
> newly allocated inode item. You can't avoid this race if you are
> using an rwlock, so you have to handle it.
>
> As it is, I suspect the use of a rwlock here is premature
> optimisation - if there are any amount of inserts being done then
> the rwlock will be more expensive than a spin lock. I've done the
> numbers before, which is why the XFS buffer cache rbtrees use a
> plain spin lock. They sustain >10^6 lookups per second under heavy
> load with a 99.999% lookup hit rate, and yet the spinlock is not a
> contention point. hence I suspect for simplicity sake the rwlock
> shoul dbe made a spin lock and the lookup done in a similar manner
> to xfs_buf_get_map/_xfs_buf_find()
Got it, thanks.
>
> (And yes, you'll see a lot of similarities between that code and the
> suggestions I've been making, like a single function that does both
> lookup and insert...)
>
>> +
>> +     spin_lock(&he->lock);
>> +     hot_rb_update_freq(&he->hot_freq_data, rw);
>> +     spin_unlock(&he->lock);
>
> Probably should move the he->lock into hot_inode_freq_update().
OK
>
>> +
>> +out:
>> +     return he;
>> +}
>> +
>> +/* Update range frequency struct */
>> +static bool hot_rb_update_range_freq(struct hot_inode_item *he,
>> +                             u64 off, u64 len, int rw,
>> +                             struct hot_info *root)
>> +{
>> +     struct hot_range_tree *hrtree = &(he->hot_range_tree);
>> +     struct hot_range_item *hr = NULL;
>> +     u64 start_off = off & RANGE_SIZE_MASK;
>> +     u64 end_off = (off + len - 1) & RANGE_SIZE_MASK;
>> +     u64 cur;
>> +     int ret = true;
>> +
>> +     if (len == 0)
>> +             return false;
>> +
>> +     /*
>> +      * Align ranges on RANGE_SIZE boundary to prevent proliferation
>> +      * of range structs
>> +      */
>> +     for (cur = start_off; cur <= end_off; cur += RANGE_SIZE) {
>> +             read_lock(&hrtree->lock);
>> +             hr = hot_rb_lookup_hot_range_item(hrtree, cur);
>> +             read_unlock(&hrtree->lock);
>> +
>> +             if (!hr) {
>> +                     hr = kmem_cache_alloc(hot_range_item_cache,
>> +                                             GFP_KERNEL | GFP_NOFS);
>> +                     if (!hr) {
>> +                             ret = false;
>> +                             goto out;
>> +                     }
>> +
>> +                     write_lock(&hrtree->lock);
>> +                     hot_rb_range_item_init(hr);
>> +                     hr->start = cur & RANGE_SIZE_MASK;
>> +                     hr->len = RANGE_SIZE;
>> +                     hr->hot_inode = he;
>> +                     hot_rb_add_hot_range_item(hrtree, hr);
>> +                     write_unlock(&hrtree->lock);
>> +             }
>> +
>> +             spin_lock(&hr->lock);
>> +             hot_rb_update_freq(&hr->hot_freq_data, rw);
>> +             spin_unlock(&hr->lock);
>> +             hot_rb_free_hot_range_item(hr);
>> +     }
>
> Same comments again about locking.
OK
>
> I note that the code will always insert range items of a length
> RANGE_SIZE. This means you have a fixed object granularity and hence
> you have no need for a range based search. That is, you could use a
> radix tree where each entry in the radix tree points directly to the
> range object similar to how the page cache uses a radix tree for
> indexing pages. That brings the possibility of lockless range item
> lookups....
Great suggestion, but can we temporarily put it in TODO list? because
it will bring one big code change.
>
>
>> +
>> +out:
>> +     return ret;
>> +}
>> +
>> +/* main function to update access frequency from read/writepage(s) hooks */
>> +void hot_rb_update_freqs(struct inode *inode, u64 start,
>> +                     u64 len, int rw)
>> +{
>> +     struct hot_inode_item *he;
>> +
>> +     he = hot_rb_update_inode_freq(inode, rw);
>> +
>> +     WARN_ON(!he);
>> +
>> +     if (he) {
>> +             hot_rb_update_range_freq(he, start, len,
>> +                     rw, &(inode->i_sb->s_hotinfo));
>> +
>> +             hot_rb_free_hot_inode_item(he);
>> +     }
>
> This is very assymetric. it would be much better to collapse all
> the abstraction down to something much simpler, say:
OK, thanks.
>
>
> int hot_inode_update_freqs()
> {
>         he = hot_inode_item_find(tree, inum, null)
>         if (!he) {
>                 new_he = allocate()
>                 if (!new_he)
>                         return -ENOMEM;
>
>                 <init new_he>
>                 he = hot_inode_item_find(tree, inum, new_he)
>                 if (he != new_he)
>                         free new_he
>         }
>         hot_inode_freq_update(&he->hot_freq_data, write)
>
>         for (cur = start_off; cur <= end_off; cur += RANGE_SIZE) {
>                 hr = hot_range_item_find(tree, cur, NULL)
>                 if (!hr) {
>                         new_hr = allocate()
>                         if (!new_hr)
>                                 return -ENOMEM;
>
>                         <init new_hr>
>                         hr = hot_inode_item_find(tree, cur, new_hr)
>                         if (hr != new_hr)
>                                 free new_hr
>                 }
>                 hot_inode_freq_update(&hr->hot_freq_data, write)
>                 hot_range_item_put(hr);
>         {
>         hot_inode_item_put(he);
> }
>
>
>
>
>
>
>> +}
>> +
>> +/*
>>   * Initialize kmem cache for hot_inode_item
>>   * and hot_range_item
>>   */
>> diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
>> index 269b67a..2ba29e4 100644
>> --- a/fs/hot_tracking.h
>> +++ b/fs/hot_tracking.h
>> @@ -21,6 +21,21 @@
>>  #define FREQ_DATA_TYPE_INODE (1 << 0)
>>  /* freq data struct is for a range */
>>  #define FREQ_DATA_TYPE_RANGE (1 << 1)
>> +/* size of sub-file ranges */
>> +#define RANGE_SIZE (1 << 20)
>> +#define RANGE_SIZE_MASK (~((u64)(RANGE_SIZE - 1)))
>
> You might want to state what units these ranges are in, and that
> there is one tracking object per range per inode....
yes.
>
>> +#define FREQ_POWER 4
>> +
>> +struct hot_info;
>> +struct inode;
>> +
>> +struct hot_inode_item
>
> You've already included include/linux/hot_tracking.h, so you
> shouldn't need these forward declarations...
OK.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu
