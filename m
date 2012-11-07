From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 14/19] vfs: add debugfs support
Date: Wed, 7 Nov 2012 15:49:27 +0800
Message-ID: <CAEH94Lh7q2k_-HC1Lvt9K8_HywP_fNOec6kAox0xYKwa_a+69A@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-15-git-send-email-zwu.kernel@gmail.com>
	<20121106234556.GX3102@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121106234556.GX3102@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 7, 2012 at 7:45 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:56PM +0800, zwu.kernel@gmail.com wrote:
>> +static int hot_range_seq_show(struct seq_file *seq, void *v)
>> +{
>> +     struct hot_range_item *hr = v;
>> +     struct hot_inode_item *he = hr->hot_inode;
>> +     struct hot_freq_data *freq_data = &hr->hot_range.hot_freq_data;
>> +
>> +     /* Always lock hot_inode_item first */
>> +     spin_lock(&he->hot_inode.lock);
>> +     spin_lock(&hr->hot_range.lock);
>> +     seq_printf(seq, "inode #%llu, range start " \
>
> the # seems unnecessary to me
OK, removed.
>
>> +                     "%llu (range len %u) reads %u, writes %u, "
>> +                     "avg read time %llu, avg write time %llu, temp %u\n",
>
> compiler will complain if it sees a %llu format and not the expected
> type of 'unsigned long long'
When built, i haven't seen any warning report about this...
>
>> +                     he->i_ino,
>
>                         (unsigned long long)he->i_ino,
>
>> +                     (u64)hr->start * RANGE_SIZE,
>> +                     hr->len,
>> +                     freq_data->nr_reads,
>> +                     freq_data->nr_writes,
>> +                     freq_data->avg_delta_reads / NSEC_PER_MSEC,
>> +                     freq_data->avg_delta_writes / NSEC_PER_MSEC,
>> +                     freq_data->last_temp >> (32 - HEAT_MAP_BITS));
>> +     spin_unlock(&hr->hot_range.lock);
>> +     spin_unlock(&he->hot_inode.lock);
>> +
>> +     return 0;
>> +}
>> +
>> +static int hot_inode_seq_show(struct seq_file *seq, void *v)
>> +{
>> +     struct hot_inode_item *he = v;
>> +     struct hot_freq_data *freq_data = &he->hot_inode.hot_freq_data;
>> +
>> +     spin_lock(&he->hot_inode.lock);
>> +     seq_printf(seq, "inode #%llu, reads %u, writes %u, " \
>> +             "avg read time %llu, avg write time %llu, temp %u\n",
>
> (same here)
ditto.
>
>> +             he->i_ino,
>> +             freq_data->nr_reads,
>> +             freq_data->nr_writes,
>> +             freq_data->avg_delta_reads / NSEC_PER_MSEC,
>> +             freq_data->avg_delta_writes / NSEC_PER_MSEC,
>> +             freq_data->last_temp >> (32 - HEAT_MAP_BITS));
>> +     spin_unlock(&he->hot_inode.lock);
>> +
>> +     return 0;
>> +}
>>
>> +static void *hot_spot_range_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>> +{
>> +     struct hot_info *root = seq->private;
>> +     struct hot_range_item *hr_next, *hr = v;
>> +     struct hot_comm_item *comm_item;
>> +     struct list_head *n_list;
>> +     int i =
>> +      hr->hot_range.hot_freq_data.last_temp >> (32 - HEAT_MAP_BITS);
>
> now I have noticed that I've seen the ... (32 - HEAT_MAP_BITS)
> expression so many times that it tend to think it deserves a helper
> function
This helper function has existed, hot_raw_shift(), i will replace this with it.
>
>> +
>> +     n_list = seq_list_next(&hr->hot_range.n_list,
>> +             &root->heat_range_map[i].node_list, pos);
>> +     hot_range_item_put(hr);
>> +next:
>> +     if (n_list) {
>> +             comm_item = container_of(n_list,
>> +                     struct hot_comm_item, n_list);
>> +             hr_next = container_of(comm_item,
>> +                     struct hot_range_item, hot_range);
>> +             kref_get(&hr_next->hot_range.refs);
>> +             return hr_next;
>> +     } else if (--i >= 0) {
>> +             n_list = seq_list_next(&root->heat_range_map[i].node_list,
>> +                             &root->heat_range_map[i].node_list, pos);
>> +             goto next;
>> +     }
>> +
>> +     return NULL;
>> +}
>> +
>> +static void hot_debugfs_exit(struct super_block *sb)
>> +{
>> +     struct dentry *vol_dentry;
>> +
>> +     vol_dentry = debugfs_get_dentry(sb->s_id,
>> +                             sb->s_hot_root->debugfs_root, strlen(sb->s_id));
>> +     /* remove all debugfs entries recursively from the volume root */
>> +     if (vol_dentry)
>> +             debugfs_remove_recursive(vol_dentry);
>> +     else
>> +             BUG_ON(1);
>
>                 BUG()
done, thanks.
>
>> +
>> +     if (list_empty(&sb->s_hot_root->debugfs_root->d_subdirs))
>> +             debugfs_remove(sb->s_hot_root->debugfs_root);
>> +}
>> +
>> +/*
>
> david



-- 
Regards,

Zhi Yong Wu
