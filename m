From: Ravi Pinjala <ravi@p-static.net>
Subject: Re: e4defrag doesn't work on root filesystem
Date: Tue, 08 Sep 2009 08:42:13 -0500
Message-ID: <4AA65F35.9090707@p-static.net>
References: <4AA52B31.5090205@p-static.net> <4AA5D5C8.2010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from irongate.mail.utexas.edu ([146.6.25.6]:48004 "EHLO
	irongate.mail.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZIHNmT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Sep 2009 09:42:19 -0400
In-Reply-To: <4AA5D5C8.2010304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> Ravi Pinjala wrote:
>> Hi,
>>
>> I'm playing with e4defrag from e2frprogs git, and I've run into a bug.
>> When I try to defragment files on my root filesystem, it refuses to
>> acknowledge that the filesystem is ext4. I believe the problem is that
>> it checks the filesystem type by parsing /etc/mtab, but the root
>> filesystem shows up there like this:
>>
>> rootfs on / type rootfs (rw)
>> /dev/root on / type ext4 (rw,noatime,barrier=1,data=ordered)
>>
>> so it gets confused by the bogus first entry. It works just fine on
>> other ext4 filesystems I have.
>>
>> (If this is the wrong mailing list, I apologize; I couldn't find one for
>> e2fsprogs, so I thought this was the next best thing.)
>>
>> --Ravi
>> -- 
>>   
> This list is a fine place to report it, thanks.
> 
> In is_ext4() it does a statfs on the file, and checks that the magic is
> EXT4,
> but then that's the same as ext2 and ext3 unfortunately  ....
> 
> It later does getmntent for the actual fs type, but fails, as you said.
> 
> Does this fix it for you?

Yeah, that works great. Thanks!

--Ravi

> 
> =========
> 
> Skip "rootfs" entry when checking for ext4 filesystem.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index 82e3868..0d04df9 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -430,6 +430,8 @@ static int is_ext4(const char *file)
>     }
> 
>     while ((mnt = getmntent(fp)) != NULL) {
> +        if (mnt->mnt_fsname[0] != '/')
> +            continue;
>         len = strlen(mnt->mnt_dir);
>         ret = memcmp(file_path, mnt->mnt_dir, len);
>         if (ret != 0)
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

