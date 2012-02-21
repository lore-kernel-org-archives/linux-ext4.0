From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V4 01/22] ext4: Move extra inode read to a new function.
Date: Tue, 21 Feb 2012 16:13:17 +0800
Message-ID: <4F43521D.2070401@tao.ma>
References: <4F41EF95.2000909@tao.ma> <1329721316-4955-1-git-send-email-tm@tao.ma> <77C00684-DB5E-4BDC-A500-9128D8BD0BC3@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <77C00684-DB5E-4BDC-A500-9128D8BD0BC3@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 02/21/2012 02:51 PM, Andreas Dilger wrote:
> On 2012-02-20, at 12:01 AM, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> Currently, in ext4_iget we do a simple check to see whether
>> there does exist some information starting from the end
>> of i_extra_size. With inline data added, this procedure
>> is more complicated. So move it to a new function named
>> ext4_iget_extra_inode.
>>
>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>> ---
>> fs/ext4/inode.c |   19 ++++++++++++-------
>> 1 files changed, 12 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index feaa82f..0b2d6c1 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3610,6 +3610,16 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
>> 	}
>> }
>>
>> +static inline void ext4_iget_extra_inode(struct inode *inode,
>> +					 struct ext4_inode *raw_inode,
>> +					 struct ext4_inode_info *ei)
>> +{
>> +	__le32 *magic = (void *)raw_inode +
>> +			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
>> +	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
>> +		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
>> +}
> 
> The patch looks fine, and is a nice little cleanup, but...
> 
>> struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>> {
>> 	struct ext4_iloc iloc;
>> @@ -3720,13 +3730,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
>> 			/* The extra space is currently unused. Use it. */
>> 			ei->i_extra_isize = sizeof(struct ext4_inode) -
>> 					    EXT4_GOOD_OLD_INODE_SIZE;
>> -		} else {
>> -			__le32 *magic = (void *)raw_inode +
>> -					EXT4_GOOD_OLD_INODE_SIZE +
>> -					ei->i_extra_isize;
>> -			if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
>> -				ext4_set_inode_state(inode, EXT4_STATE_XATTR);
>> -		}
>> +		} else
>> +			ext4_iget_extra_inode(inode, raw_inode, ei);
> 
> This does not follow Documentation/CodingStyle - there should be braces around
> the "else" clause if it is needed for the "if" clause.  The below code could be
> fixed at the same time.
OK, I will fix it. Thanks for the review.

Thanks
Tao
> 
>> 	} else
>> 		ei->i_extra_isize = 0;
>>
>> -- 
>> 1.7.0.4
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

