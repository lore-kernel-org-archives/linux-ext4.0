From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 01/13] btrfs: add one new mount option '-o hot_track'
Date: Thu, 11 Oct 2012 21:41:01 +0800
Message-ID: <CAEH94LiFvUfNA1vjJ37y3U0r0cw+k_w6hoboOXPO75=CQwoXSg@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-2-git-send-email-zwu.kernel@gmail.com>
	<20121010162842.GZ4405@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, zwu.kernel@gmail.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20121010162842.GZ4405@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Oct 11, 2012 at 12:28 AM, David Sterba <dave@jikos.cz> wrote:
> Hi,
>
> On Wed, Oct 10, 2012 at 06:07:23PM +0800, zwu.kernel@gmail.com wrote:
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1726,6 +1726,7 @@ struct btrfs_ioctl_defrag_range_args {
>>  #define BTRFS_MOUNT_CHECK_INTEGRITY  (1 << 20)
>>  #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>>  #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR     (1 << 22)
>> +#define BTRFS_MOUNT_HOT_TRACK                (1 << 23)
>
> Please don't forget to add new options to btrfs_show_options(),
> otherwise we can't tell what filesystems have hot tracking enabled.
Great catch, thanks.
>
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -303,7 +304,7 @@ enum {
>>       Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
>>       Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
>>       Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cache,
>> -     Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
>> +     Opt_no_space_cache, Opt_recovery, Opt_skip_balance, Opt_hot_track,
>
> Please add the new option to the end.
OK.
>
>>       Opt_check_integrity, Opt_check_integrity_including_extent_data,
>>       Opt_check_integrity_print_mask, Opt_fatal_errors,
>>       Opt_err,
>> @@ -342,6 +343,7 @@ static match_table_t tokens = {
>>       {Opt_no_space_cache, "nospace_cache"},
>>       {Opt_recovery, "recovery"},
>>       {Opt_skip_balance, "skip_balance"},
>> +     {Opt_hot_track, "hot_track"},
>
> (also this one)
ditto.
>
>>       {Opt_check_integrity, "check_int"},
>>       {Opt_check_integrity_including_extent_data, "check_int_data"},
>>       {Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
>> @@ -553,6 +555,9 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>>               case Opt_skip_balance:
>>                       btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
>>                       break;
>> +             case Opt_hot_track:
>
> It's a common patter in the surrounding code that a message is printed
> when enabling options, but the vfs prints its own, so I'm not sure if
> it's needed here as well. Just thinking, leave it as it is now.
OK
>
>> +                     btrfs_set_opt(info->mount_opt, HOT_TRACK);
>> +                     break;
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>>               case Opt_check_integrity_including_extent_data:
>>                       printk(KERN_INFO "btrfs: enabling check integrity"
>
> david



-- 
Regards,

Zhi Yong Wu
