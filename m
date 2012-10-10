From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 01/13] btrfs: add one new mount option '-o hot_track'
Date: Wed, 10 Oct 2012 20:21:48 +0800
Message-ID: <CAEH94LgG+F2B=uw4tT1nYrZuq1ot3Sy19JjvSekZbUu4V=oOdA@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-2-git-send-email-zwu.kernel@gmail.com>
	<5075632c.03cc440a.1b33.7805SMTPIN_ADDED@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	david@fromorbit.com, dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35039 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab2JJMVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2012 08:21:51 -0400
In-Reply-To: <5075632c.03cc440a.1b33.7805SMTPIN_ADDED@mx.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 10, 2012 at 7:59 PM, Luk=C3=A1=C5=A1 Czerner <lczerner@redh=
at.com> wrote:
> On Wed, 10 Oct 2012, zwu.kernel@gmail.com wrote:
>
>> Date: Wed, 10 Oct 2012 18:07:23 +0800
>> From: zwu.kernel@gmail.com
>> To: linux-fsdevel@vger.kernel.org
>> Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
>>     linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
>>     viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
>>     tytso@mit.edu, cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm=
=2Ecom>
>> Subject: [RFC v3 01/13] btrfs: add one new mount option '-o hot_trac=
k'
>>
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Introduce one new mount option '-o hot_track',
>> and add its parsing support.
>>   Its usage looks like:
>>    mount -o hot_track
>>    mount -o nouser,hot_track
>>    mount -o nouser,hot_track,loop
>>    mount -o hot_track,nouser
>
> This patch should probably be at the end of the series.
Can you let me know your reason? I think that it is not necessary to
be at the end of the series.

>
> -Lukas
>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/btrfs/ctree.h |    1 +
>>  fs/btrfs/super.c |    7 ++++++-
>>  2 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 9821b67..094bec6 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -1726,6 +1726,7 @@ struct btrfs_ioctl_defrag_range_args {
>>  #define BTRFS_MOUNT_CHECK_INTEGRITY  (1 << 20)
>>  #define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>>  #define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR     (1 << 22)
>> +#define BTRFS_MOUNT_HOT_TRACK                (1 << 23)
>>
>>  #define btrfs_clear_opt(o, opt)              ((o) &=3D ~BTRFS_MOUNT=
_##opt)
>>  #define btrfs_set_opt(o, opt)                ((o) |=3D BTRFS_MOUNT_=
##opt)
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 83d6f9f..00be9e3 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/cleancache.h>
>>  #include <linux/ratelimit.h>
>> +#include <linux/hot_tracking.h>
>>  #include "compat.h"
>>  #include "delayed-inode.h"
>>  #include "ctree.h"
>> @@ -303,7 +304,7 @@ enum {
>>       Opt_notreelog, Opt_ratio, Opt_flushoncommit, Opt_discard,
>>       Opt_space_cache, Opt_clear_cache, Opt_user_subvol_rm_allowed,
>>       Opt_enospc_debug, Opt_subvolrootid, Opt_defrag, Opt_inode_cach=
e,
>> -     Opt_no_space_cache, Opt_recovery, Opt_skip_balance,
>> +     Opt_no_space_cache, Opt_recovery, Opt_skip_balance, Opt_hot_tr=
ack,
>>       Opt_check_integrity, Opt_check_integrity_including_extent_data=
,
>>       Opt_check_integrity_print_mask, Opt_fatal_errors,
>>       Opt_err,
>> @@ -342,6 +343,7 @@ static match_table_t tokens =3D {
>>       {Opt_no_space_cache, "nospace_cache"},
>>       {Opt_recovery, "recovery"},
>>       {Opt_skip_balance, "skip_balance"},
>> +     {Opt_hot_track, "hot_track"},
>>       {Opt_check_integrity, "check_int"},
>>       {Opt_check_integrity_including_extent_data, "check_int_data"},
>>       {Opt_check_integrity_print_mask, "check_int_print_mask=3D%d"},
>> @@ -553,6 +555,9 @@ int btrfs_parse_options(struct btrfs_root *root,=
 char *options)
>>               case Opt_skip_balance:
>>                       btrfs_set_opt(info->mount_opt, SKIP_BALANCE);
>>                       break;
>> +             case Opt_hot_track:
>> +                     btrfs_set_opt(info->mount_opt, HOT_TRACK);
>> +                     break;
>>  #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
>>               case Opt_check_integrity_including_extent_data:
>>                       printk(KERN_INFO "btrfs: enabling check integr=
ity"
>>



--=20
Regards,

Zhi Yong Wu
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
