From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 09/13] vfs: add one wq to update map info periodically
Date: Wed, 17 Oct 2012 14:34:15 +0800
Message-ID: <CAEH94LjoanfL3piP89qM6MP6zdN0AybfeqJe0kR_5-DJ0mLH_w@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-10-git-send-email-zwu.kernel@gmail.com>
	<20121016002744.GC2864@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45638 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2JQGeR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Oct 2012 02:34:17 -0400
In-Reply-To: <20121016002744.GC2864@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 16, 2012 at 8:27 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:31PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add a per-superblock workqueue and a work_struct
>>  to run periodic work to update map info on each superblock.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c            |   94 ++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_tracking.h            |    3 +
>>  include/linux/hot_tracking.h |    2 +
>>  3 files changed, 99 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> index a8dc599..f333c47 100644
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -15,6 +15,8 @@
>>  #include <linux/module.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/hardirq.h>
>> +#include <linux/kthread.h>
>> +#include <linux/freezer.h>
>>  #include <linux/fs.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/types.h>
>> @@ -623,6 +625,88 @@ static void hot_map_array_exit(struct hot_info *root)
>>  }
>>
>>  /*
>> + * Update temperatures for each hot inode item and
>> + * hot range item for aging purposes
>> + */
>> +static void hot_temperature_update_work(struct work_struct *work)
>> +{
>> +     struct hot_update_work *hot_work =
>> +                     container_of(work, struct hot_update_work, work);
>> +     struct hot_info *root = hot_work->hot_info;
>> +     struct hot_inode_item *hi_nodes[8];
>> +     unsigned long delay = HZ * HEAT_UPDATE_DELAY;
>> +     u64 ino = 0;
>> +     int i, n;
>> +
>> +     do {
>> +             while (1) {
>> +                     spin_lock(&root->lock);
>> +                     n = radix_tree_gang_lookup(&root->hot_inode_tree,
>> +                                        (void **)hi_nodes, ino,
>> +                                        ARRAY_SIZE(hi_nodes));
>> +                     if (!n) {
>> +                             spin_unlock(&root->lock);
>> +                             break;
>> +                     }
>> +
>> +                     ino = hi_nodes[n - 1]->i_ino + 1;
>> +                     for (i = 0; i < n; i++) {
>> +                             kref_get(&hi_nodes[i]->hot_inode.refs);
>> +                             hot_map_array_update(
>> +                                     &hi_nodes[i]->hot_inode.hot_freq_data, root);
>> +                             hot_range_update(hi_nodes[i], root);
>> +                             hot_inode_item_put(hi_nodes[i]);
>> +                     }
>> +                     spin_unlock(&root->lock);
>
> This is a lot of work to do under a spin lock. Perhaps you should
> get a reference on all the nodes, then drop the root->lock and then
> update all the nodes in a separate loop.
OK, done
>
>> +             }
>> +
>> +             if (unlikely(freezing(current))) {
>> +                     __refrigerator(true);
>> +             } else {
>> +                     set_current_state(TASK_INTERRUPTIBLE);
>> +                     if (!kthread_should_stop()) {
>> +                             schedule_timeout(delay);
>> +                     }
>> +                     __set_current_state(TASK_RUNNING);
>> +             }
>> +     } while (!kthread_should_stop());
>
> I don't think you understand workqueues fully. A work queue worker
> function is not something that executes endlessly. It is a
> "one-shot" function that does the work once, not an endless loop
> that has to delay it's execution for periodic work.
ah, i have done this based on your following suggestions, thanks.
>
> If you need periodic work, then you should use a struct delayed_work
> and queue the next work iteration to be run a later time. See, for
> example, xfs_syncd_worker() and xfs_syncd_queue_sync() and how that
> reschedules itself for periodic work. It also means you don't have
> to handle kthread freezing, as the WQ infrastructure takes care of
> that for you.
ditto.
>
> This is why unmount is hanging for me - this work never completes,
> so flush_workqueue() will never return.
got it, thanks.
>
>> +}
>> +
>> +static int hot_wq_init(struct hot_info *root)
>> +{
>> +     struct hot_update_work *hot_work;
>> +     int ret = 0;
>> +
>> +     root->update_wq = alloc_workqueue(
>> +             "hot_temperature_update", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
>> +     if (!root->update_wq) {
>> +             printk(KERN_ERR "%s: failed to create "
>> +                     "temperature update workqueue\n",
>> +                     __func__);
>> +             return 1;
>> +     }
>> +
>> +     hot_work = kmalloc(sizeof(*hot_work), GFP_NOFS);
>> +     if (hot_work) {
>> +             hot_work->hot_info = root;
>> +             INIT_WORK(&hot_work->work, hot_temperature_update_work);
>> +             queue_work(root->update_wq, &hot_work->work);
>> +     } else {
>> +             printk(KERN_ERR "%s: failed to create update work\n",
>> +                             __func__);
>> +             ret = 1;
>> +     }
>
> I don't understand why you need a separate "hot_work" structure.
> just embed a struct delayed_work in the struct hot_info and use
> container_of() to get the struct hot_info from the work structure.
> As such, there's no need for a separate function just for this
> initialisation - just put it in line.
OK, done.
>
>> +
>> +     return ret;
>> +}
>> +
>> +static void hot_wq_exit(struct workqueue_struct *wq)
>> +{
>> +     flush_workqueue(wq);
>
> flush_workqueue_sync().
done, thanks
>
>> +     destroy_workqueue(wq);
>> +}
>
> And there's not need for separate function for this - put it in
> line.
ditto.
>
> FWIW, it also leaks the hot_work structure, but you're going to
> remove that anyway. ;)
>
>> diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
>> index d19e64a..7a79a6d 100644
>> --- a/fs/hot_tracking.h
>> +++ b/fs/hot_tracking.h
>> @@ -36,6 +36,9 @@
>>   */
>>  #define TIME_TO_KICK 400
>>
>> +/* set how often to update temperatures (seconds) */
>> +#define HEAT_UPDATE_DELAY 400
>
> FWIW, 400 seconds is an unusual time period. It's expected that
> periodic work might take place at intervals of 5 minutes, 10
> minutes, etc, not 6m40s. It's much easier to predict and understand
> behaviour if it's at a interval of whole units like minutes,
> especially when looking at timestamped event traces. Hence 300s (5
> minutes) makes a lot more sense as a period for updates...
got it. thanks.
>
>>  /*
>>   * The following comments explain what exactly comprises a unit of heat.
>>   *
>> diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
>> index 7114179..b37e0f8 100644
>> --- a/include/linux/hot_tracking.h
>> +++ b/include/linux/hot_tracking.h
>> @@ -84,6 +84,8 @@ struct hot_info {
>>
>>       /* map of range temperature */
>>       struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
>> +
>> +     struct workqueue_struct *update_wq;
>
> Add the struct delayed_work here, too.
ditto
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
