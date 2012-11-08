From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 10/19] vfs: introduce hot func register framework
Date: Thu, 8 Nov 2012 10:59:04 +0800
Message-ID: <CAEH94LgxsyVHSmT+pcT7n9zywKFDsxbCe0aY7d=eFoFWng+=3Q@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-11-git-send-email-zwu.kernel@gmail.com>
	<20121106233011.GC4255@blackbox.djwong.org>
	<CAEH94Lhg+uWQpauySdXGrLDjbO-6cSPfHJMgZkJmWr5EqV2CWQ@mail.gmail.com>
	<20121107185802.GA4038@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121107185802.GA4038@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 8, 2012 at 2:58 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Wed, Nov 07, 2012 at 04:34:35PM +0800, Zhi Yong Wu wrote:
>> On Wed, Nov 7, 2012 at 7:30 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
>> > On Mon, Oct 29, 2012 at 12:30:52PM +0800, zwu.kernel@gmail.com wrote:
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >>   Introduce one framwork to enable that specific FS
>> >> can register its own hot tracking functions.
>> >>
>> >> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> ---
>> >>  fs/hot_tracking.c            |   78 ++++++++++++++++++++++++++++++++++++++----
>> >>  include/linux/hot_tracking.h |   25 +++++++++++++
>> >>  2 files changed, 96 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> >> index 0ef9cad..c6c6138 100644
>> >> --- a/fs/hot_tracking.c
>> >> +++ b/fs/hot_tracking.c
>> >> @@ -24,6 +24,9 @@
>> >>  #include <linux/limits.h>
>> >>  #include "hot_tracking.h"
>> >>
>> >> +static DEFINE_SPINLOCK(hot_func_list_lock);
>> >> +static LIST_HEAD(hot_func_list);
>> >> +
>> >>  /* kmem_cache pointers for slab caches */
>> >>  static struct kmem_cache *hot_inode_item_cachep __read_mostly;
>> >>  static struct kmem_cache *hot_range_item_cachep __read_mostly;
>> >> @@ -305,20 +308,23 @@ static u64 hot_average_update(struct timespec old_atime,
>> >>       return new_avg;
>> >>  }
>> >>
>> >> -static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
>> >> +static void hot_freq_data_update(struct hot_info *root,
>> >> +             struct hot_freq_data *freq_data, bool write)
>> >>  {
>> >>       struct timespec cur_time = current_kernel_time();
>> >>
>> >>       if (write) {
>> >>               freq_data->nr_writes += 1;
>> >> -             freq_data->avg_delta_writes = hot_average_update(
>> >> +             freq_data->avg_delta_writes =
>> >> +                     root->hot_func_type->ops.hot_rw_freq_calc_fn(
>> >>                               freq_data->last_write_time,
>> >>                               cur_time,
>> >>                               freq_data->avg_delta_writes);
>> >>               freq_data->last_write_time = cur_time;
>> >>       } else {
>> >>               freq_data->nr_reads += 1;
>> >> -             freq_data->avg_delta_reads = hot_average_update(
>> >> +             freq_data->avg_delta_reads =
>> >> +                     root->hot_func_type->ops.hot_rw_freq_calc_fn(
>> >>                               freq_data->last_read_time,
>> >>                               cur_time,
>> >>                               freq_data->avg_delta_reads);
>> >> @@ -430,7 +436,7 @@ static void hot_map_array_update(struct hot_freq_data *freq_data,
>> >>       struct hot_comm_item *comm_item;
>> >>       struct hot_inode_item *he;
>> >>       struct hot_range_item *hr;
>> >> -     u32 temp = hot_temp_calc(freq_data);
>> >> +     u32 temp = root->hot_func_type->ops.hot_temp_calc_fn(freq_data);
>> >>       u8 a_temp = temp >> (32 - HEAT_MAP_BITS);
>> >>       u8 b_temp = freq_data->last_temp >> (32 - HEAT_MAP_BITS);
>> >>
>> >> @@ -511,7 +517,7 @@ static void hot_range_update(struct hot_inode_item *he,
>> >>                               &hr_nodes[i]->hot_range.hot_freq_data, root);
>> >>
>> >>                       spin_lock(&hr_nodes[i]->hot_range.lock);
>> >> -                     obsolete = hot_is_obsolete(
>> >> +                     obsolete = root->hot_func_type->ops.hot_is_obsolete_fn(
>> >>                                       &hr_nodes[i]->hot_range.hot_freq_data);
>> >>                       spin_unlock(&hr_nodes[i]->hot_range.lock);
>> >>
>> >> @@ -668,7 +674,7 @@ void hot_update_freqs(struct inode *inode, u64 start,
>> >>       }
>> >>
>> >>       spin_lock(&he->hot_inode.lock);
>> >> -     hot_freq_data_update(&he->hot_inode.hot_freq_data, rw);
>> >> +     hot_freq_data_update(root, &he->hot_inode.hot_freq_data, rw);
>> >>       spin_unlock(&he->hot_inode.lock);
>> >>
>> >>       /*
>> >> @@ -685,7 +691,7 @@ void hot_update_freqs(struct inode *inode, u64 start,
>> >>               }
>> >>
>> >>               spin_lock(&hr->hot_range.lock);
>> >> -             hot_freq_data_update(&hr->hot_range.hot_freq_data, rw);
>> >> +             hot_freq_data_update(root, &hr->hot_range.hot_freq_data, rw);
>> >>               spin_unlock(&hr->hot_range.lock);
>> >>
>> >>               hot_range_item_put(hr);
>> >> @@ -695,6 +701,61 @@ void hot_update_freqs(struct inode *inode, u64 start,
>> >>  }
>> >>  EXPORT_SYMBOL_GPL(hot_update_freqs);
>> >>
>> >> +static struct hot_func_type hot_func_def = {
>> >> +     .hot_func_name = "hot_type_def",
>> >> +     .ops = {
>> >> +             .hot_rw_freq_calc_fn = hot_average_update,
>> >> +             .hot_temp_calc_fn    = hot_temp_calc,
>> >> +             .hot_is_obsolete_fn  = hot_is_obsolete,
>> >> +     },
>> >> +};
>> >
>> > If these hot_ops are per-filesystem, why not just embed a struct hot_func_ops
>> > inside of struct file_system_type?  That eliminates this _get function,
>> this _get function is very small, only some loc, if hot_func_ops is
>> embedded in struct file_system_type, i am afraid to introduce some
>> regressions....
>
> What kind of regressions are you afraid of, specifically?  I don't think fstype
> is performance-critical enough to worry about wreaking havoc in the caches due
> to adding three function pointers.
done, thanks.
>
>> > collision avoidance, etc.  You can fill in NULL function pointers in
>> fill in NULL func pointer? why?
>> > hot_track_init (or just code around them).
>
> I guess you could just require that everyone fill out .hot_temp_calc_fn,
> even if they just point it to generic_hot_temp_calc.
>
> --D
>
>> >
>> > --D
>> >
>> >> +
>> >> +static struct hot_func_type *hot_func_get(const char *name)
>> >> +{
>> >> +     struct hot_func_type *f, *h = &hot_func_def;
>> >> +
>> >> +     spin_lock(&hot_func_list_lock);
>> >> +     list_for_each_entry(f, &hot_func_list, list) {
>> >> +             if (!strcmp(f->hot_func_name, name))
>> >> +                     h = f;
>> >> +     }
>> >> +     spin_unlock(&hot_func_list_lock);
>> >> +
>> >> +     return h;
>> >> +}
>> >> +
>> >> +int hot_func_register(struct hot_func_type *h)
>> >> +{
>> >> +     struct hot_func_type *f, *t = NULL;
>> >> +
>> >> +     /* register, don't allow duplicate names */
>> >> +     spin_lock(&hot_func_list_lock);
>> >> +     list_for_each_entry(f, &hot_func_list, list) {
>> >> +             if (!strcmp(f->hot_func_name, h->hot_func_name))
>> >> +                     t = f;
>> >> +     }
>> >> +
>> >> +     if (t) {
>> >> +             spin_unlock(&hot_func_list_lock);
>> >> +             return -EBUSY;
>> >> +     }
>> >> +
>> >> +     list_add_tail(&h->list, &hot_func_list);
>> >> +     spin_unlock(&hot_func_list_lock);
>> >> +
>> >> +     return 0;
>> >> +}
>> >> +EXPORT_SYMBOL_GPL(hot_func_register);
>> >> +
>> >> +void hot_func_unregister(struct hot_func_type *h)
>> >> +{
>> >> +     /* unregister */
>> >> +     spin_lock(&hot_func_list_lock);
>> >> +     list_del_init(&h->list);
>> >> +     spin_unlock(&hot_func_list_lock);
>> >> +}
>> >> +EXPORT_SYMBOL_GPL(hot_func_unregister);
>> >> +
>> >>  /*
>> >>   * Initialize the data structures for hot data tracking.
>> >>   */
>> >> @@ -714,6 +775,9 @@ int hot_track_init(struct super_block *sb)
>> >>       hot_inode_tree_init(root);
>> >>       hot_map_array_init(root);
>> >>
>> >> +     /* Get hot func type */
>> >> +     root->hot_func_type = hot_func_get(sb->s_type->name);
>> >> +
>> >>       root->update_wq = alloc_workqueue(
>> >>               "hot_update_wq", WQ_NON_REENTRANT, 0);
>> >>       if (!root->update_wq) {
>> >> diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
>> >> index 2ee0d02..3941052 100644
>> >> --- a/include/linux/hot_tracking.h
>> >> +++ b/include/linux/hot_tracking.h
>> >> @@ -23,6 +23,8 @@
>> >>  #define HEAT_MAP_BITS 8
>> >>  #define HEAT_MAP_SIZE (1 << HEAT_MAP_BITS)
>> >>
>> >> +#define HOT_NAME_MAX 16
>> >> +
>> >>  /*
>> >>   * A frequency data struct holds values that are used to
>> >>   * determine temperature of files and file ranges. These structs
>> >> @@ -73,6 +75,25 @@ struct hot_range_item {
>> >>       u32 len; /* length in bytes */
>> >>  };
>> >>
>> >> +typedef u64 (hot_rw_freq_calc_fn) (struct timespec old_atime,
>> >> +                     struct timespec cur_time, u64 old_avg);
>> >> +typedef u32 (hot_temp_calc_fn) (struct hot_freq_data *freq_data);
>> >> +typedef bool (hot_is_obsolete_fn) (struct hot_freq_data *freq_data);
>> >> +
>> >> +struct hot_func_ops {
>> >> +     hot_rw_freq_calc_fn *hot_rw_freq_calc_fn;
>> >> +     hot_temp_calc_fn *hot_temp_calc_fn;
>> >> +     hot_is_obsolete_fn *hot_is_obsolete_fn;
>> >> +};
>> >> +
>> >> +/* identifies an hot func type */
>> >> +struct hot_func_type {
>> >> +     char hot_func_name[HOT_NAME_MAX];
>> >> +     /* fields provided by specific FS */
>> >> +     struct hot_func_ops ops;
>> >> +     struct list_head list;
>> >> +};
>> >> +
>> >>  struct hot_info {
>> >>       struct radix_tree_root hot_inode_tree;
>> >>       spinlock_t lock; /*protect inode tree */
>> >> @@ -85,6 +106,7 @@ struct hot_info {
>> >>
>> >>       struct workqueue_struct *update_wq;
>> >>       struct delayed_work update_work;
>> >> +     struct hot_func_type *hot_func_type;
>> >>  };
>> >>
>> >>  extern void __init hot_cache_init(void);
>> >> @@ -93,4 +115,7 @@ extern void hot_track_exit(struct super_block *sb);
>> >>  extern void hot_update_freqs(struct inode *inode, u64 start,
>> >>                               u64 len, int rw);
>> >>
>> >> +extern int hot_func_register(struct hot_func_type *h);
>> >> +extern void hot_func_unregister(struct hot_func_type *h);
>> >> +
>> >>  #endif  /* _LINUX_HOTTRACK_H */
>> >> --
>> >> 1.7.6.5
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Regards,
>>
>> Zhi Yong Wu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
