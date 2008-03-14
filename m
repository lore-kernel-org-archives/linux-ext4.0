From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Fri, 14 Mar 2008 21:02:18 +0900
Message-ID: <200803141202.AA00330@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

> Overall I think the header changes probably should go with the patches
> that need those changes, that helps explain why we need this header
> changes and makes the patch compile itself. Right now this patch failed
> to compile alone.
I see.
I will reorganize my patches into meaningful groups.

>>  /*
>> @@ -299,6 +300,14 @@ struct ext4_new_group_data {
>>  #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
>>  #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
>>  #define EXT4_IOC_MIGRATE		_IO('f', 7)
>> +#define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
>> +#define EXT4_IOC_DEFRAG		_IOW('f', 10, struct ext4_ext_defrag_data)
>> +#define EXT4_IOC_GROUP_INFO	_IOW('f', 11, struct ext4_group_data_info)
>> +#define EXT4_IOC_FREE_BLOCKS_INFO	_IOW('f', 12, struct ext4_extents_info)
>> +#define EXT4_IOC_EXTENTS_INFO		_IOW('f', 13, struct ext4_extents_info)
>> +#define EXT4_IOC_RESERVE_BLOCK		_IOW('f', 14, struct ext4_extents_info)
>> +#define EXT4_IOC_MOVE_VICTIM		_IOW('f', 15, struct ext4_extents_info)
>> +#define EXT4_IOC_BLOCK_RELEASE		_IO('f', 8)
>
> These should go with the last patch in this series, where the ioctl
> commands get implemented
OK.

> Could you add more comments about the tunables below? What they are used
> for?
>
>> +/* Used for defrag */
>> +#define DEFRAG_MAX_ENT         32
>
> This means at most 32 free space extents per block group?
OK.  I will add more comments later.

This means the maximum count of extents(or free space extents) for exchanging 
between kernel-space and user-space at once.
For example, EXT4_IOC_EXTENTS_INFO is called multiple times(per DEFRAG_MAX_ENT)
to get its block distribution if there is a large number of
extents(or free space extents) in the target block group.

>> +#define DEFRAG_FORCE_TRY       1
>> +#define DEFRAG_FORCE_VICTIM    2
>> +#define DEFRAG_FORCE_GATHER    3
>> +
>
> And these tunables are used in the last patch in this series, so it make
> sense to move there too.
OK.

>> +struct ext4_extent_data {
>> +	ext4_lblk_t block;		/* start logical block number */
>> +	ext4_fsblk_t start;		/* start physical block number */
>> +	int len;			/* blocks count */
>> +};
>> +
>
> Not related to defrag, but I would like to consider this as in-core
> extent structure. Maybe we should use this structure in other extents.c,
> instead of sharing the same on-disk extent structure, which needs to
> worry about little endian?

I agree. 
How about renaming this structure from ext4_extent_data to
ext4_extent_info which used the extent in-core structure
and put it into ext4_fs_extents.h? 
Because in-core super_block is ext4_sb_info.

/*
 * This is the extent in-core structure.
 */
struct ext4_extent_info {
	ext4_lblk_t	ee_block;	/* first logical block extent covers */
	int		ee_len;		/* number of blocks covered by extent */
	ext4_fsblk_t	ee_start;	/* first physical block extent covers */
};      

Regards, Akira
