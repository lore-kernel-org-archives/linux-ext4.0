From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH 32/32] ext4: add nombcache mount option
Date: Wed, 21 Jun 2017 16:46:48 -0700
Message-ID: <CAAeU0aNUvSBkicQgnc9V4dWicZKWutum9aUsFy7oTLasRinhfQ@mail.gmail.com>
References: <20170620091435.13560-1-tahsin@google.com> <B63F04AF-ED74-4A05-BA5A-160A97C61106@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:35886 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFUXqu (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 19:46:50 -0400
Received: by mail-yw0-f180.google.com with SMTP id l75so205899ywc.3
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 16:46:49 -0700 (PDT)
In-Reply-To: <B63F04AF-ED74-4A05-BA5A-160A97C61106@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>> +     if ((sbi->s_mount_opt ^ old_opts.s_mount_opt) & EXT4_MOUNT_NO_MBCACHE) {
>> +             ext4_msg(sb, KERN_ERR, "can't enable nombcache during remount");
>> +             err = -EINVAL;
>> +             goto restore_opts;
>> +     }
>
> It appears that this restriction also applies to enabling mbcache during
> remount as well, so the message should be updated?  In particular, if
> NO_MBCACHE is currently set but isn't passed during the remount then this
> will always cause the remount to fail.  That makes it harder for users to
> just run something like "mount -o remount,ro".

Remount option handling is a bit strange. If an option is not
specified, it is not automatically cleared in sbi->s_mount_opt. So,
once nombcache option is set in the original mount, it is not possible
to clear it. I don't know whether this option handling behavior in
ext4 is deliberate but because of that, the mount -o remount,ro does
not result in a mount failure. The check above is effectively only to
protect against going from not having nombcache option to having
nombcache option, because the opposite is not possible.

Following shows how "debug" option remains set even though it wasn't
specified during remount:

# mount -o debug /dev/sdb /mnt/sdb
# mount | grep sdb
/dev/sdb on /mnt/sdb type ext4 (rw,debug)
# cat /proc/mounts | grep sdb
/dev/sdb /mnt/sdb ext4 rw,relatime,debug,data=ordered 0 0
# mount -o remount,ro /dev/sdb /mnt/sdb
# mount | grep sdb
/dev/sdb on /mnt/sdb type ext4 (ro)
# cat /proc/mounts | grep sdb
/dev/sdb /mnt/sdb ext4 ro,relatime,debug,data=ordered 0 0
