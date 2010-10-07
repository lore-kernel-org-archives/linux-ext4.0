From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Skip "rootfs" entry when checking for ext4 filesystem.
Date: Thu, 07 Oct 2010 12:04:45 -0500
Message-ID: <4CADFDAD.3020202@redhat.com>
References: <4AA682BE.2030200@redhat.com> <4ACE480E.9070508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ravi@p-static.net
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812Ab0JGREr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Oct 2010 13:04:47 -0400
In-Reply-To: <4ACE480E.9070508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/08/2009 03:14 PM, Eric Sandeen wrote:
> Ping on this one?

Ping++

-Eric

> Ravi reported a failure w/o it:
> 
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
> 
> Thanks,
> -Eric
> 
> Eric Sandeen wrote:
>> Skip "rootfs" entry when checking for ext4 filesystem.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index 82e3868..0d04df9 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -430,6 +430,8 @@ static int is_ext4(const char *file)
>>  	}
>>  
>>  	while ((mnt = getmntent(fp)) != NULL) {
>> +		if (mnt->mnt_fsname[0] != '/')
>> +			continue;
>>  		len = strlen(mnt->mnt_dir);
>>  		ret = memcmp(file_path, mnt->mnt_dir, len);
>>  		if (ret != 0)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

