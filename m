From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] ext4: dynamical adjust the length of zero-out chunk
Date: Thu, 12 Jul 2012 10:51:12 -0600
Message-ID: <7B794B69-EF6C-4279-83D7-EA47E35CD54C@dilger.ca>
References: <1342075703-4537-1-git-send-email-wenqing.lz@taobao.com> <4FFEE402.7090601@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Zheng Liu <gnehzuil.liu@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Zach Brown <zab@zabbo.net>
To: Zheng Liu <wenqing.lz@taobao.com>,
	Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45276 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab2GLQvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2012 12:51:00 -0400
In-Reply-To: <4FFEE402.7090601@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-07-12, at 8:49 AM, Eric Sandeen wrote:
> On 7/12/12 1:48 AM, Zheng Liu wrote:
>> From: Zheng Liu <wenqing.lz@taobao.com>
>> 
>> Currently in ext4 the length of zero-out chunk is set to 7.  But it is
>> too short so that it will cause a lot of fragmentation of extent when
>> we use fallocate to preallocate some uninitialized extents and the
>> workload frequently does some uninitialized extent conversions.  Thus,
>> now we set it to 256 (1MB chunk), and put it into super block in order
>> to adjust it dynamically in sysfs.
> 
> Does this in fact help the workload for which you wanted the non-flagged
> fallocate interface?
> 
> I'm a little wary of adding another user tunable; how will the user have
> any idea what value to use here?

It would make sense to use the s_raid_stripe_width as the default value for
this parameter.  The other thing we need to pay attention to is that the
growth of the extent zeroing be done on a RAID or erase-block aligned manner.
Otherwise, this might cause extra IO that doesn't benefit the application.

It appears that the current code does not pay attention to alignment, and
that should be fixed before landing this patch with larger zero-out sizes.

> At any rate, something should also go into Documentation/filesystems/ext4.txt
> to explain the new tunable.
> 
> Thanks,
> -Eric
> 
>> CC: Zach Brown <zab@zabbo.net>
>> CC: Andreas Dilger <adilger@dilger.ca>
>> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
>> ---
>> v2 <- v1:
>> * use a on-stack copy to avoid seeing differenet values
>> * add missing spaces around '*'
>> 
>> fs/ext4/ext4.h    |    3 +++
>> fs/ext4/extents.c |   13 ++++++++-----
>> fs/ext4/super.c   |    3 +++
>> 3 files changed, 14 insertions(+), 5 deletions(-)
>> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index cfc4e01..0f44577 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1265,6 +1265,9 @@ struct ext4_sb_info {
>> 	/* locality groups */
>> 	struct ext4_locality_group __percpu *s_locality_groups;
>> 
>> +	/* the size of zero-out chunk */
>> +	unsigned int s_extent_zeroout_len;
>> +
>> 	/* for write statistics */
>> 	unsigned long s_sectors_written_start;
>> 	u64 s_kbytes_written;
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 91341ec..a114d65 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -3029,7 +3029,6 @@ out:
>> 	return err ? err : map->m_len;
>> }
>> 
>> -#define EXT4_EXT_ZERO_LEN 7
>> /*
>>  * This function is called by ext4_ext_map_blocks() if someone tries to write
>>  * to an uninitialized extent. It may result in splitting the uninitialized
>> @@ -3055,12 +3054,14 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>> 					   struct ext4_map_blocks *map,
>> 					   struct ext4_ext_path *path)
>> {
>> +	struct ext4_sb_info *sbi;
>> 	struct ext4_extent_header *eh;
>> 	struct ext4_map_blocks split_map;
>> 	struct ext4_extent zero_ex;
>> 	struct ext4_extent *ex;
>> 	ext4_lblk_t ee_block, eof_block;
>> 	unsigned int ee_len, depth;
>> +	unsigned int zeroout_len;
>> 	int allocated;
>> 	int err = 0;
>> 	int split_flag = 0;
>> @@ -3069,6 +3070,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>> 		"block %llu, max_blocks %u\n", inode->i_ino,
>> 		(unsigned long long)map->m_lblk, map->m_len);
>> 
>> +	sbi = EXT4_SB(inode->i_sb);
>> +	zeroout_len = sbi->s_extent_zeroout_len;
>> 	eof_block = (inode->i_size + inode->i_sb->s_blocksize - 1) >>
>> 		inode->i_sb->s_blocksize_bits;
>> 	if (eof_block < map->m_lblk + map->m_len)
>> @@ -3168,8 +3171,8 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>> 	 */
>> 	split_flag |= ee_block + ee_len <= eof_block ? EXT4_EXT_MAY_ZEROOUT : 0;
>> 
>> -	/* If extent has less than 2*EXT4_EXT_ZERO_LEN zerout directly */
>> -	if (ee_len <= 2*EXT4_EXT_ZERO_LEN &&
>> +	/* If extent has less than 2*s_extent_zeroout_len zerout directly */
>> +	if (ee_len <= (2 * zeroout_len) &&
>> 	    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>> 		err = ext4_ext_zeroout(inode, ex);
>> 		if (err)
>> @@ -3195,7 +3198,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>> 	split_map.m_len = map->m_len;
>> 
>> 	if (allocated > map->m_len) {
>> -		if (allocated <= EXT4_EXT_ZERO_LEN &&
>> +		if (allocated <= zeroout_len &&
>> 		    (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>> 			/* case 3 */
>> 			zero_ex.ee_block =
>> @@ -3209,7 +3212,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
>> 			split_map.m_lblk = map->m_lblk;
>> 			split_map.m_len = allocated;
>> 		} else if ((map->m_lblk - ee_block + map->m_len <
>> -			   EXT4_EXT_ZERO_LEN) &&
>> +			   zeroout_len) &&
>> 			   (EXT4_EXT_MAY_ZEROOUT & split_flag)) {
>> 			/* case 2 */
>> 			if (map->m_lblk != ee_block) {
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index eb7aa3e..ea7cb6b 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2535,6 +2535,7 @@ EXT4_RW_ATTR_SBI_UI(mb_order2_req, s_mb_order2_reqs);
>> EXT4_RW_ATTR_SBI_UI(mb_stream_req, s_mb_stream_request);
>> EXT4_RW_ATTR_SBI_UI(mb_group_prealloc, s_mb_group_prealloc);
>> EXT4_RW_ATTR_SBI_UI(max_writeback_mb_bump, s_max_writeback_mb_bump);
>> +EXT4_RW_ATTR_SBI_UI(extent_zeroout_len, s_extent_zeroout_len);
>> EXT4_ATTR(trigger_fs_error, 0200, NULL, trigger_test_error);
>> 
>> static struct attribute *ext4_attrs[] = {
>> @@ -2550,6 +2551,7 @@ static struct attribute *ext4_attrs[] = {
>> 	ATTR_LIST(mb_stream_req),
>> 	ATTR_LIST(mb_group_prealloc),
>> 	ATTR_LIST(max_writeback_mb_bump),
>> +	ATTR_LIST(extent_zeroout_len),
>> 	ATTR_LIST(trigger_fs_error),
>> 	NULL,
>> };
>> @@ -3626,6 +3628,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>> 
>> 	sbi->s_stripe = ext4_get_stripe_size(sbi);
>> 	sbi->s_max_writeback_mb_bump = 128;
>> +	sbi->s_extent_zeroout_len = 256;
>> 
>> 	/*
>> 	 * set up enough so that it can read an inode
>> 
> 
> 


Cheers, Andreas





