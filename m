From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v4+ hot_track 12/19] vfs: add one ioctl interface
Date: Wed, 7 Nov 2012 15:36:56 +0800
Message-ID: <CAEH94Lj7vuQz6nqG3_u5DjcoeWc_LjejfxxWc3W0UoRs_worNg@mail.gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
	<1351485061-12297-13-git-send-email-zwu.kernel@gmail.com>
	<20121106233058.GW3102@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43594 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2KGHg6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Nov 2012 02:36:58 -0500
In-Reply-To: <20121106233058.GW3102@twin.jikos.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 7, 2012 at 7:30 AM, David Sterba <dave@jikos.cz> wrote:
> On Mon, Oct 29, 2012 at 12:30:54PM +0800, zwu.kernel@gmail.com wrote:
>> +static int ioctl_heat_info(struct file *file, void __user *argp)
>> +{
>> +     struct inode *inode = file->f_dentry->d_inode;
>> +     struct hot_heat_info *heat_info;
>> +     struct hot_inode_item *he;
>> +     int ret = 0;
>> +
>> +     heat_info = kmalloc(sizeof(struct hot_heat_info),
>> +                             GFP_KERNEL | GFP_NOFS);
>
> heat_info is small enough to fit onto the stack, so you can avoid the
> kmalloc, I don't think there are deep callstacks to be expected.
ok, done.
> Nevertheless, if you want to use kmalloc here, then please check the
> return value and use GFP_KERNEL.
thanks for your pointing out.
>
>> +
>> +     if (copy_from_user((void *) heat_info,
>> +                     argp,
>> +                     sizeof(struct hot_heat_info)) != 0) {
>> +             ret = -EFAULT;
>> +             goto err;
>> +     }
>> +
>> +     he = hot_inode_item_find(inode->i_sb->s_hot_root, inode->i_ino);
>> +     if (!he) {
>> +             /* we don't have any info on this file yet */
>> +             ret = -ENODATA;
>> +             goto err;
>> +     }
>> +
>> +     spin_lock(&he->hot_inode.lock);
>> +     heat_info->avg_delta_reads =
>> +             (__u64) he->hot_inode.hot_freq_data.avg_delta_reads;
>> +     heat_info->avg_delta_writes =
>> +             (__u64) he->hot_inode.hot_freq_data.avg_delta_writes;
>> +     heat_info->last_read_time =
>> +     (__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_read_time);
>> +     heat_info->last_write_time =
>> +     (__u64) timespec_to_ns(&he->hot_inode.hot_freq_data.last_write_time);
>> +     heat_info->num_reads =
>> +             (__u32) he->hot_inode.hot_freq_data.nr_reads;
>> +     heat_info->num_writes =
>> +             (__u32) he->hot_inode.hot_freq_data.nr_writes;
>> +
>> +     if (heat_info->live > 0) {
>> +             /*
>> +              * got a request for live temperature,
>> +              * call hot_hash_calc_temperature to recalculate
>> +              */
>> +             heat_info->temp =
>> +             inode->i_sb->s_hot_root->hot_func_type->ops.hot_temp_calc_fn(
>> +                                     &he->hot_inode.hot_freq_data);
>> +     } else {
>> +             /* not live temperature, get it from the hashlist */
>> +             heat_info->temp = he->hot_inode.hot_freq_data.last_temp;
>> +     }
>> +     spin_unlock(&he->hot_inode.lock);
>> +
>> +     hot_inode_item_put(he);
>> +
>> +     if (copy_to_user(argp, (void *) heat_info,
>> +                     sizeof(struct hot_heat_info))) {
>> +             ret = -EFAULT;
>> +             goto err;
>> +     }
>> +
>> +err:
>> +     kfree(heat_info);
>> +     return ret;
>> +}
>
> david



-- 
Regards,

Zhi Yong Wu
