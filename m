From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 09/19] vfs: add one work queue
Date: Mon, 5 Nov 2012 19:55:40 +0800
Message-ID: <CAEH94LjXrK6OfSU=aQa+waMMY+0kCjL3MU2faKeRxm9UggaKQA@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-10-git-send-email-zwu.kernel@gmail.com>
	<1352114465.2705.13.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, tytso@mit.edu, cmm@us.ibm.com,
	wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: Steven Whitehouse <swhiteho@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352114465.2705.13.camel@menhir>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 5, 2012 at 7:21 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Mon, 2012-10-29 at 12:30 +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   Add a per-superblock workqueue and a delayed_work
>> to run periodic work to update map info on each superblock.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/hot_tracking.c            |   85 ++++++++++++++++++++++++++++++++++++++++++
>>  fs/hot_tracking.h            |    3 +
>>  include/linux/hot_tracking.h |    3 +
>>  3 files changed, 91 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
>> index fff0038..0ef9cad 100644
>> --- a/fs/hot_tracking.c
>> +++ b/fs/hot_tracking.c
>> @@ -15,9 +15,12 @@
>>  #include <linux/module.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/hardirq.h>
>> +#include <linux/kthread.h>
>> +#include <linux/freezer.h>
>>  #include <linux/fs.h>
>>  #include <linux/blkdev.h>
>>  #include <linux/types.h>
>> +#include <linux/list_sort.h>
>>  #include <linux/limits.h>
>>  #include "hot_tracking.h"
>>
>> @@ -557,6 +560,67 @@ static void hot_map_array_exit(struct hot_info *root)
>>       }
>>  }
>>
>> +/* Temperature compare function*/
>> +static int hot_temp_cmp(void *priv, struct list_head *a,
>> +                             struct list_head *b)
>> +{
>> +     struct hot_comm_item *ap =
>> +                     container_of(a, struct hot_comm_item, n_list);
>> +     struct hot_comm_item *bp =
>> +                     container_of(b, struct hot_comm_item, n_list);
>> +
>> +     int diff = ap->hot_freq_data.last_temp
>> +                             - bp->hot_freq_data.last_temp;
>> +     if (diff > 0)
>> +             return -1;
>> +     if (diff < 0)
>> +             return 1;
>> +     return 0;
>> +}
>> +
>> +/*
>> + * Every sync period we update temperatures for
>> + * each hot inode item and hot range item for aging
>> + * purposes.
>> + */
>> +static void hot_update_worker(struct work_struct *work)
>> +{
>> +     struct hot_info *root = container_of(to_delayed_work(work),
>> +                                     struct hot_info, update_work);
>> +     struct hot_inode_item *hi_nodes[8];
>> +     u64 ino = 0;
>> +     int i, n;
>> +
>> +     while (1) {
>> +             n = radix_tree_gang_lookup(&root->hot_inode_tree,
>> +                                (void **)hi_nodes, ino,
>> +                                ARRAY_SIZE(hi_nodes));
>> +             if (!n)
>> +                     break;
>> +
>> +             ino = hi_nodes[n - 1]->i_ino + 1;
>> +             for (i = 0; i < n; i++) {
>> +                     kref_get(&hi_nodes[i]->hot_inode.refs);
>> +                     hot_map_array_update(
>> +                             &hi_nodes[i]->hot_inode.hot_freq_data, root);
>> +                     hot_range_update(hi_nodes[i], root);
>> +                     hot_inode_item_put(hi_nodes[i]);
>> +             }
>> +     }
>> +
>> +     /* Sort temperature map info */
>> +     for (i = 0; i < HEAT_MAP_SIZE; i++) {
>> +             list_sort(NULL, &root->heat_inode_map[i].node_list,
>> +                     hot_temp_cmp);
>> +             list_sort(NULL, &root->heat_range_map[i].node_list,
>> +                     hot_temp_cmp);
>> +     }
>> +
>
> If this list can potentially have one (or more) entries per inode, then
Only one hot_inode_item per inode, while maybe multiple
hot_range_items per inode.
> filesystems with a lot of inodes (millions) may potentially exceed the
> max size of list which list_sort() can handle. If that happens it still
> works, but you'll get a warning message and it won't be as efficient.
I haven't do so large scale test. If we want to find that issue, we
need to do large scale performance test, before that, i want to make
sure the code change is correct at first.
To be honest, for that issue you pointed to, i also have such
concern.But list_sort() performance looks good from the test result of
the following URL:
https://lkml.org/lkml/2010/1/20/485

>
> It is something that we've run into with list_sort() and GFS2, but it
> only happens very rarely,
Beside list_sort(), do you have any other way to share? For this
concern, how does GFS2 resolve it?

>
> Steve.
>
>
>



-- 
Regards,

Zhi Yong Wu
