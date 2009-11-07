From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: journal all modifications in ext4_xattr_set_handle
Date: Fri, 06 Nov 2009 19:00:48 -0600
Message-ID: <4AF4C6C0.5080305@redhat.com>
References: <4AF4A334.1000304@redhat.com> <A7C68A34-99A5-4476-8545-10FA95E32EAD@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377AbZKGBAs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Nov 2009 20:00:48 -0500
In-Reply-To: <A7C68A34-99A5-4476-8545-10FA95E32EAD@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> On 2009-11-06, at 15:29, Eric Sandeen wrote:
>> ext4_xattr_set_handle() was modifying s_inode_size outside
>> of journaling constraints; this is one of the accesses that
>> was causing the crc errors in journal replay as seen in
>> kernel.org bugzilla #14354.
> 
> Is this description accurate?  It doesn't seem to be modifying 
> s_inode_size, per-se, but rather zeroing the whole inode if it is a new 
> inode that was never read from disk.

Doh, skimmed too fast, you're right. I'll resend a V2 w/ the proper 
description, sorry about that.  :)

-eric

> Other than the above description the patch looks correct.
> 
> Reviewed-by: Andreas Dilger <adilger@sun.com>
> 
>> @@ -988,6 +988,10 @@ ext4_xattr_set_handle(handle_t *handle, struct 
>> inode *inode, int name_index,
>>     if (error)
>>         goto cleanup;
>> +    error = ext4_journal_get_write_access(handle, is.iloc.bh);
>> +    if (error)
>> +        goto cleanup;
>> +
>>     if (EXT4_I(inode)->i_state & EXT4_STATE_NEW) {
>>         struct ext4_inode *raw_inode = ext4_raw_inode(&is.iloc);
>>         memset(raw_inode, 0, EXT4_SB(inode->i_sb)->s_inode_size);
>> @@ -1013,9 +1017,6 @@ ext4_xattr_set_handle(handle_t *handle, struct 
>> inode *inode, int name_index,
>>         if (flags & XATTR_CREATE)
>>             goto cleanup;
>>     }
>> -    error = ext4_journal_get_write_access(handle, is.iloc.bh);
>> -    if (error)
>> -        goto cleanup;
>>     if (!value) {
>>         if (!is.s.not_found)
>>             error = ext4_xattr_ibody_set(handle, inode, &i, &is);
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> -- 
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

