From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 10/19] vfs: introduce hot func register framework
Date: Wed, 7 Nov 2012 15:18:57 +0800
Message-ID: <CAEH94LggeTEK-RxBMUUM1VefpwgTDWcB5CLZsGD3rBPu86L1Tw@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-11-git-send-email-zwu.kernel@gmail.com>
	<20121106231447.GV3102@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121106231447.GV3102@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 7, 2012 at 7:14 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:52PM +0800, zwu.kernel@gmail.com wrote:
>> +static struct hot_func_type *hot_func_get(const char *name)
>> +{
>> +     struct hot_func_type *f, *h = &hot_func_def;
>> +
>> +     spin_lock(&hot_func_list_lock);
>> +     list_for_each_entry(f, &hot_func_list, list) {
>> +             if (!strcmp(f->hot_func_name, name))
>> +                     h = f;
>
> You probably want to break here
Good catch, done, thanks.
>
>> +     }
>> +     spin_unlock(&hot_func_list_lock);
>> +
>> +     return h;
>> +}
>> +
>> +int hot_func_register(struct hot_func_type *h)
>> +{
>> +     struct hot_func_type *f, *t = NULL;
>> +
>> +     /* register, don't allow duplicate names */
>> +     spin_lock(&hot_func_list_lock);
>> +     list_for_each_entry(f, &hot_func_list, list) {
>> +             if (!strcmp(f->hot_func_name, h->hot_func_name))
>> +                     t = f;
>
> if duplicate names are not allowed, then a warning may make sense to
> let us know that something is wrong
done, thanks.
>
>> +     }
>> +
>> +     if (t) {
>> +             spin_unlock(&hot_func_list_lock);
>> +             return -EBUSY;
>> +     }
>> +
>> +     list_add_tail(&h->list, &hot_func_list);
>> +     spin_unlock(&hot_func_list_lock);
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(hot_func_register);
>> --- a/include/linux/hot_tracking.h
>> +++ b/include/linux/hot_tracking.h
>> @@ -73,6 +75,25 @@ struct hot_range_item {
>>       u32 len; /* length in bytes */
>>  };
>>
>> +typedef u64 (hot_rw_freq_calc_fn) (struct timespec old_atime,
>> +                     struct timespec cur_time, u64 old_avg);
>> +typedef u32 (hot_temp_calc_fn) (struct hot_freq_data *freq_data);
>> +typedef bool (hot_is_obsolete_fn) (struct hot_freq_data *freq_data);
>
> I'm thinking, whether these typedefs are useful, similar ops structures
> do not introduce them, also when you pick a struct member names exactly
> same as the typedefs:
>
>> +struct hot_func_ops {
>> +     hot_rw_freq_calc_fn *hot_rw_freq_calc_fn;
>> +     hot_temp_calc_fn *hot_temp_calc_fn;
>> +     hot_is_obsolete_fn *hot_is_obsolete_fn;
>> +};
>
> My suggestion is to make the types explicit in the structure.
sorry, i don't get your point, can you elaborate it about how to do this?
>
>> +/* identifies an hot func type */
>> +struct hot_func_type {
>> +     char hot_func_name[HOT_NAME_MAX];
>
> 'name' would be sufficient IMHO
done, thanks.
>
>> +     /* fields provided by specific FS */
>> +     struct hot_func_ops ops;
>> +     struct list_head list;
>> +};
>
> david



-- 
Regards,

Zhi Yong Wu
