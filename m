From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [Ext4 Secure Delete 1/7v4] ext4: Secure Delete: Add new EXT4_SECRM_RANDOM_FL
 flag
Date: Fri, 07 Oct 2011 10:14:20 -0700
Message-ID: <4E8F336C.1060708@linux.vnet.ibm.com>
References: <1317971465-8517-1-git-send-email-achender@linux.vnet.ibm.com> <1317971465-8517-2-git-send-email-achender@linux.vnet.ibm.com> <20111007170255.GE12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:58083 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab1JGRO0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 13:14:26 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 7 Oct 2011 11:14:26 -0600
In-Reply-To: <20111007170255.GE12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/07/2011 10:02 AM, Darrick J. Wong wrote:
> On Fri, Oct 07, 2011 at 12:10:59AM -0700, Allison Henderson wrote:
>> This patch adds a new attribute flag EXT4_SECRM_RANDOM_FL.
>> During a secure delete, this flag will cause blocks to be
>> overwritten with random data instead of zeros.
>>
>> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
>> ---
>> :100644 100644 e717dfd... db54ce4... M	fs/ext4/ext4.h
>>   fs/ext4/ext4.h |    9 ++++++---
>>   1 files changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index e717dfd..db54ce4 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -350,17 +350,18 @@ struct flex_groups {
>>   #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
>>   #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
>>   #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
>> +#define EXT4_SECRM_RANDOM_FL		0x10000000 /* Use random data instead of zeros */
>>   #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>>
>> -#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
>> -#define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
>> +#define EXT4_FL_USER_VISIBLE		0x104BDFFF /* User visible flags */
>> +#define EXT4_FL_USER_MODIFIABLE		0x104B80FF /* User modifiable flags */
>
> Is there a reason why this #define is 0x104BDFFF instead of a bunch of flags
> or'd together in a manner similar to the one below it?
>
> --D

That's a really good suggestion, and I dont see any reason why it needs 
to be a hard number like that.  I will definitely add that in if we 
decide to keep the EXT4_SECRM_RANDOM_FL flag.  Thx!

>>
>>   /* Flags that should be inherited by new inodes from their parent. */
>>   #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>>   			   EXT4_SYNC_FL | EXT4_IMMUTABLE_FL | EXT4_APPEND_FL |\
>>   			   EXT4_NODUMP_FL | EXT4_NOATIME_FL |\
>>   			   EXT4_NOCOMPR_FL | EXT4_JOURNAL_DATA_FL |\
>> -			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL)
>> +			   EXT4_NOTAIL_FL | EXT4_DIRSYNC_FL | EXT4_SECRM_RANDOM_FL)
>>
>>   /* Flags that are appropriate for regular files (all but dir-specific ones). */
>>   #define EXT4_REG_FLMASK (~(EXT4_DIRSYNC_FL | EXT4_TOPDIR_FL))
>> @@ -407,6 +408,7 @@ enum {
>>   	EXT4_INODE_EXTENTS	= 19,	/* Inode uses extents */
>>   	EXT4_INODE_EA_INODE	= 21,	/* Inode used for large EA */
>>   	EXT4_INODE_EOFBLOCKS	= 22,	/* Blocks allocated beyond EOF */
>> +	EXT4_INODE_SECRM_RANDOM = 28,   /* Use random data instead of zeros */
>>   	EXT4_INODE_RESERVED	= 31,	/* reserved for ext4 lib */
>>   };
>>
>> @@ -453,6 +455,7 @@ static inline void ext4_check_flag_values(void)
>>   	CHECK_FLAG_VALUE(EXTENTS);
>>   	CHECK_FLAG_VALUE(EA_INODE);
>>   	CHECK_FLAG_VALUE(EOFBLOCKS);
>> +	CHECK_FLAG_VALUE(SECRM_RANDOM);
>>   	CHECK_FLAG_VALUE(RESERVED);
>>   }
>>
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

