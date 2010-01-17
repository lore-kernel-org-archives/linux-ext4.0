From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v4 1/3] ext4: mechanical change on dio get_block code
 in prepare for it to be used by buffer write
Date: Sun, 17 Jan 2010 10:19:30 -0600
Message-ID: <4B533892.5040900@redhat.com>
References: <1263583812-21355-1-git-send-email-tytso@mit.edu>	<1263583812-21355-2-git-send-email-tytso@mit.edu> <87y6jw23yn.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jiaying Zhang <jiayingz@google.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0AQQTm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jan 2010 11:19:42 -0500
In-Reply-To: <87y6jw23yn.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K. V wrote:
> On Fri, 15 Jan 2010 14:30:10 -0500, "Theodore Ts'o" <tytso@mit.edu> wrote:
>> Renaming the dio block allocation flags, variables, and functions
>> introduced in Mingming's "Direct IO for holes and fallocate"
>> patches so that they can be used by ext4 buffer write as well.
>> Also changed the related function comments accordingly to cover
>> both direct write and buffer wirte cases.
>>
>> Signed-off-by: Jiaying Zhang <jiayingz@google.com>
>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>> ---
>>  fs/ext4/ext4.h    |   18 ++++++------
>>  fs/ext4/extents.c |   24 +++++++-------
>>  fs/ext4/fsync.c   |    2 +-
>>  fs/ext4/inode.c   |   84 ++++++++++++++++++++++++-----------------------------
>>  fs/ext4/super.c   |    2 +-
>>  5 files changed, 61 insertions(+), 69 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 2ca1b41..b1dcbb7 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -133,7 +133,7 @@ struct mpage_da_data {
>>  	int pages_written;
>>  	int retval;
>>  };
>> -#define	DIO_AIO_UNWRITTEN	0x1
>> +#define	EXT4_IO_UNWRITTEN	0x1
>>  typedef struct ext4_io_end {
>>  	struct list_head	list;		/* per-file finished AIO list */
>>  	struct inode		*inode;		/* file being written to */
>> @@ -364,13 +364,13 @@ struct ext4_new_group_data {
>>  	/* caller is from the direct IO path, request to creation of an
>>  	unitialized extents if not allocated, split the uninitialized
>>  	extent if blocks has been preallocated already*/
>> -#define EXT4_GET_BLOCKS_DIO			0x0008
>> +#define EXT4_GET_BLOCKS_PRE_IO			0x0008
>>  #define EXT4_GET_BLOCKS_CONVERT			0x0010
>> -#define EXT4_GET_BLOCKS_DIO_CREATE_EXT		(EXT4_GET_BLOCKS_DIO|\
>> +#define EXT4_GET_BLOCKS_IO_CREATE_EXT		(EXT4_GET_BLOCKS_PRE_IO|\
>>  					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
>> -	/* Convert extent to initialized after direct IO complete */
>> -#define EXT4_GET_BLOCKS_DIO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
>> -					 EXT4_GET_BLOCKS_DIO_CREATE_EXT)
>> +	/* Convert extent to initialized after IO complete */
>> +#define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
>> +					 EXT4_GET_BLOCKS_IO_CREATE_EXT)
>>
> 
> All these flags are really confusing. I guess we can make it much more
> cleaner. For ex: Why is EXT4_GET_BLOCKS_IO_CONVERT_EXT enabling
> EXT4_GET_BLOCKS_CREATE_UNINIT_EXT. The renaming to PRE_IO made it
> better. But i guess these names should be self documenting.


> How about
> 
> EXT4_GET_BLOCKS_CREATE. Indicate we should do block
> allocation. But that flag alone doesn't say whether we are suppose
> to create init or uninit extent.
> 
> EXT4_GET_BLOCKS_UNINIT_EXT -> Request the creation of uninit extent
> 
> EXT4_GET_BLOCKS_CREATE_UNINIT_EXT -> EXT4_GET_BLOCKS_CREATE|EXT4_GET_BLOCKS_UNINIT_EXT;
> 
> EXT4_GET_BLOCKS_DELALLOC_RESERVE -> Request for delayed allocaion
> reservation
> 
> EXT4_GET_BLOCKS_PRE_IO  -> 0x0008 -> Indicate that we should do all
> necessary extent split and make the requested range in to single extent.
> 
> EXT4_GET_BLOCKS_CONVERT_IO -> Convert the specified range which should be a
> single extent into init and then try to merge the extent to left/right
> 
> EXT4_GET_BLOCKS_IO_CREATE_EXT -> EXT4_GET_BLOCKS_PRE_IO | EXT4_GET_BLOCKS_CREATE_UNINIT_EXT
> 
> EXT4_GET_BLOCKS_IO_CONVERT_EXT -> EXT4_GET_BLOCKS_CREATE | EXT4_GET_BLOCKS_CONVERT_IO;

 
In addition to Aneesh's suggestions, I'm not sure of the value of
creating more

#define FLAG_A = FLAG_B|FLAG_C

flag macros; unless you have this all in your head you just have to
go look up the flag definition anyway, since we usually test individual
flags not the aggregates.  I'm wondering if it might be better to just
explicitly send in the OR'd flags rather than creating a new one, to
see the code flow better.

Maybe it saves space, but at the cost of easy understanding IMHO.
At least that's been my experience.

-Eric

> So from the above list it is only the last flag that is different from
> what is already there. But i guess we need more documentation around
> these flags.
> 
> -aneesh

