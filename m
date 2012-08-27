From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: don't clear orphan list on ro mount with errors
Date: Mon, 27 Aug 2012 18:35:07 -0500
Message-ID: <503C042B.7060104@redhat.com>
References: <503BC685.7090707@redhat.com> <503BCA24.7050100@redhat.com> <9B528F50-65A2-48C5-A76F-F8B6DFB66636@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab2H0XfJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Aug 2012 19:35:09 -0400
In-Reply-To: <9B528F50-65A2-48C5-A76F-F8B6DFB66636@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/27/12 6:31 PM, Andreas Dilger wrote:
> On 2012-08-27, at 1:27 PM, Eric Sandeen wrote:
>> When we have a filesystem with an orphan inode list *and* in error
>> state, things behave differently if:
>>
>> 1) e2fsck -p is done prior to mount: e2fsck fixes things and exits
>>   happily (barring other significant problems)
>>
>> vs.
>>
>> 2) mount is done first, then e2fsck -p: due to the orphan inode
>>   list removal, more errors are found and e2fsck exits with
>>   UNEXPECTED INCONSISTENCY.
>>
>> The 2nd case above, on the root filesystem, has the tendency to halt
>> the boot process, which is unfortunate.
> 
> I think the reasoning is that if the filesystem is corrupted, then
> processing the orphan list may introduce further corruption.  If one
> has to run a full e2fsck run anyway, then there is no benefit to be
> had from processing the orphan list in advance, and a potential
> downside (e.g. corrupt inode in the list pointing to some valid inode
> and causing it to be deleted).
> 
> That said, it depends on how robust the orphan handling code is -
> if it won't get confused and delete an in-use inode (i.e. dtime == 0)
> then it probably is OK.  I wouldn't trust the inode bitmaps to determine
> if the inode is in use or not, only whether it is referenced by some
> directory.

What's interesting, though, is that e2fsck trusts the orphan inode list
even in the ERROR_FS case.  Seems inconsistent with the kernel, I guess,
although e2fsck will only be processing it, not adding to it... *shrug*

> That said, no value in trying to clear the orphan list on a read-only fs,
> so I think you patch is OK.
> 
> Acked-by: Andreas Dilger <adilger@dilger.ca>

Thanks,
-Eric
 

>> The situation can be improved by not clearing the orphan
>> inode list when the fs is mounted readonly.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 2d51cd9..2e1ea01 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2165,10 +2165,12 @@ static void ext4_orphan_cleanup(struct super_block *sb,
>> 	}
>>
>> 	if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
>> -		if (es->s_last_orphan)
>> +		/* don't clear list on RO mount w/ errors */
>> +		if (es->s_last_orphan && !(s_flags & MS_RDONLY)) {
>> 			jbd_debug(1, "Errors on filesystem, "
>> 				  "clearing orphan list.\n");
>> -		es->s_last_orphan = 0;
>> +			es->s_last_orphan = 0;
>> +		}
>> 		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
>> 		return;
>> 	}
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

