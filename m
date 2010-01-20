From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] Add flag to files with blocks intentionally past EOF
Date: Tue, 19 Jan 2010 21:58:47 -0600
Message-ID: <4B567F77.5030103@redhat.com>
References: <4B5627EF.3080804@redhat.com> <1263948377.3954.2.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754122Ab0ATD7G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jan 2010 22:59:06 -0500
In-Reply-To: <1263948377.3954.2.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming wrote:
> On Tue, 2010-01-19 at 15:45 -0600, Eric Sandeen wrote:
>> From: Jiaying Zhang <jiayingz@google.com>
>>
>> fallocate() may potentially instantiate blocks past EOF, depending
>> on the flags used when it is called.
>>
>> e2fsck currently has a test for blocks past i_size, and it
>> sometimes trips up - noticeably on xfstests 013 which runs fsstress.
>>
>> This patch from Jiayang does fix it up for me - it (along with
>> e2fsprogs updates and other patches recently from Aneesh) has
>> survived many fsstress runs in a row.
>>
>> The setattr interface may also be used to clear the flag and remove
>> any blocks past EOF.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> (just resending this since it probably got lost in the previous
>> thread - Jiaying didn't have a SOB line, but maybe that should
>> be added.  I have included the proper From: line for authorship)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 874d169..4c7cd9b 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -284,10 +284,11 @@ struct flex_groups {
>>  #define EXT4_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
>>  #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
>>  #define EXT4_EXTENTS_FL			0x00080000 /* Inode uses extents */
>> +#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF (bit reserved in fs.h) */
>>  #define EXT4_RESERVED_FL		0x80000000 /* reserved for ext4 lib */
>>
>> -#define EXT4_FL_USER_VISIBLE		0x000BDFFF /* User visible flags */
>> -#define EXT4_FL_USER_MODIFIABLE		0x000B80FF /* User modifiable flags */
>> +#define EXT4_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
>> +#define EXT4_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
>>
>>  /* Flags that should be inherited by new inodes from their parent. */
>>  #define EXT4_FL_INHERITED (EXT4_SECRM_FL | EXT4_UNRM_FL | EXT4_COMPR_FL |\
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 765a482..e7d5ba2 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3185,7 +3185,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>>  {
>>  	struct ext4_ext_path *path = NULL;
>>  	struct ext4_extent_header *eh;
>> -	struct ext4_extent newex, *ex;
>> +	struct ext4_extent newex, *ex, *last_ex;
>>  	ext4_fsblk_t newblock;
>>  	int err = 0, depth, ret, cache_type;
>>  	unsigned int allocated = 0;
>> @@ -3366,6 +3366,14 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
>>  					EXT4_STATE_DIO_UNWRITTEN;;
>>  		}
>>  	}
>> +
>> +	if (unlikely(inode->i_flags & EXT4_EOFBLOCKS_FL)) {
>> +		BUG_ON(!eh->eh_entries);
> 
> Perhaps BUG_ON() is too strong? Maybe add some warning messages first.

perhaps ... not sure how we would get here w/ no entries.

...

>> @@ -5315,6 +5321,11 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
>>  				goto err_out;
>>  			}
>>  		}
>> +		if ((inode->i_flags & EXT4_EOFBLOCKS_FL)) {
>> +			rc = vmtruncate(inode, attr->ia_size);
>> +			if (rc)
>> +				goto err_out;
>> +		}
>>  	}
>>
> 
> I am a little lost why doing vmtruncate here...

Hm first off I assume vmtruncate will clear blocks past that size,
but tonight I'm not seeing how it gets there.

Anyway, it looks like any setting of the size, truncate up or down
(or to current size) will clear any blocks past EOF.

>>  	rc = inode_setattr(inode, attr);
>> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
>> index b63d193..71f578e 100644
>> --- a/fs/ext4/ioctl.c
>> +++ b/fs/ext4/ioctl.c
>> @@ -92,6 +92,16 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>>  			flags &= ~EXT4_EXTENTS_FL;
>>  		}
>>
>> +		if (flags & EXT4_EOFBLOCKS_FL) {
>> +			/* we don't support adding EOFBLOCKS flag */
>> +			if (!(oldflags & EXT4_EOFBLOCKS_FL)) {
>> +				err = -EOPNOTSUPP;
>> +				goto flags_out;
>> +			}
>> +		} else if (oldflags & EXT4_EOFBLOCKS_FL)
>> +			/* free the space reserved with fallocate KEEPSIZE */
>> +			vmtruncate(inode, inode->i_size);
>> +
>>  		handle = ext4_journal_start(inode, 1);
>>  		if (IS_ERR(handle)) {
>>  			err = PTR_ERR(handle);
> 
> And here...

Well here we are clearing the EOFBLOCKS flag so we'd want to clear any
blocks past EOF.... but now, does vmtruncate do that?

Ok, count me as confused too, but mostly jsut so far as how does
vmtruncate clear the blocks beyond eof.  I guess I glossed over this when reading it.

-Eric
