From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix extent cache fragmentation
Date: Wed, 24 Feb 2016 15:17:40 +0400
Message-ID: <874mcy1hnv.fsf@openvz.org>
References: <1455010041-23082-1-git-send-email-dmonakhov@openvz.org> <20160222143741.GA10531@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:35085 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbcBXLRo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Feb 2016 06:17:44 -0500
Received: by mail-lb0-f177.google.com with SMTP id bc4so8350138lbc.2
        for <linux-ext4@vger.kernel.org>; Wed, 24 Feb 2016 03:17:43 -0800 (PST)
In-Reply-To: <20160222143741.GA10531@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> Hello,
>
> On Tue 09-02-16 13:27:21, Dmitry Monakhov wrote:
>> Currently we populate extent-status inside ext4_map_blocks() by map's result
>> which is sub-optimal because usually map request are too small (few blocks),
>> even is extent itself is big (thousands of blocks).
>> In my case I have perfectly plain file:
>> File size of /mnt/static_exec_test is 889320 (218 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..     217:      33024..     33241:    218:             last,eof
>> 
>> Test case performs exec in a loop which result in random page faults
>> W/o patch es_trace looks like follows (extent status tree contains 39 peaces):
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 198
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [198/1) mapped 33222 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 0
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 2 [0/1) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 197
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [197/1) mapped 33221 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 196
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [196/1) mapped 33220 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 17
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [17/1) mapped 33041 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 159
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [159/1) mapped 33183 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 18
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [18/1) mapped 33042 status W
>> 
>> With the patch it looks much more sane (extent status tree contains 1 peace)
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 198
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 0 [0/0) 0
>> ext4_es_insert_extent: dev 1,0 ino 12 es [0/218) mapped 33024 status W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 198
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 0
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 197
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 196
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 17
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 159
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 18
>> ext4_es_lookup_extent_exit: dev 1,0 ino 12 found 1 [0/218) 33024 W
>> ext4_es_lookup_extent_enter: dev 1,0 ino 12 lblk 59
>
> So in principle this patch is fine but I hate how handling of extent status
> tree is proliferating to fs/ext4/extent.c to handle some cases especially
> through special function flags. So looking into the code, probably it would
> make sense to move all updates of the extent status tree handling down into
> ext4_ext_map_blocks() and ext4_ind_map_blocks(). Thoughts?
Agree. This was my initial diea but patch was too big for stable
releases. In fact this is not critical fix so we can simply make is
in good way and simply ignore @stable. Will send updated version shortly.

>
> 								Honza
>
>> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>> ---
>>  fs/ext4/ext4.h           | 1 +
>>  fs/ext4/extents.c        | 6 ++++++
>>  fs/ext4/extents_status.c | 2 +-
>>  fs/ext4/inode.c          | 5 +++--
>>  4 files changed, 11 insertions(+), 3 deletions(-)
>> 
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 0662b28..6dbdabc 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -567,6 +567,7 @@ enum {
>>  #define EXT4_GET_BLOCKS_CONVERT_UNWRITTEN	0x0100
>>  	/* Write zeros to newly created written extents */
>>  #define EXT4_GET_BLOCKS_ZERO			0x0200
>> +#define EXT4_GET_BLOCKS_CACHE			0x0400
>>  #define EXT4_GET_BLOCKS_CREATE_ZERO		(EXT4_GET_BLOCKS_CREATE |\
>>  					EXT4_GET_BLOCKS_ZERO)
>>  
>> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
>> index 0ffabaf..7a8c610 100644
>> --- a/fs/ext4/extents.c
>> +++ b/fs/ext4/extents.c
>> @@ -4328,7 +4328,13 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>>  		 * we split out initialized portions during a write.
>>  		 */
>>  		ee_len = ext4_ext_get_actual_len(ex);
>> +		if (flags & EXT4_GET_BLOCKS_CACHE) {
>> +			unsigned int status = EXTENT_STATUS_WRITTEN;
>>  
>> +			if (ext4_ext_is_unwritten(ex))
>> +				status = EXTENT_STATUS_UNWRITTEN;
>> +			ext4_es_cache_extent(inode, ee_block, ee_len, ee_start, status);
>> +		}
>>  		trace_ext4_ext_show_extent(inode, ee_block, ee_start, ee_len);
>>  
>>  		/* if found extent covers block, simply return it */
>> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
>> index ac748b3..79a29b9 100644
>> --- a/fs/ext4/extents_status.c
>> +++ b/fs/ext4/extents_status.c
>> @@ -811,7 +811,7 @@ int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
>>  		else if (lblk > ext4_es_end(es1))
>>  			node = node->rb_right;
>>  		else {
>> -			found = 1;
>> +			found = 2;
>>  			break;
>>  		}
>>  	}
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 83bc8bf..0096de2 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -524,8 +524,9 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>  	 */
>>  	down_read(&EXT4_I(inode)->i_data_sem);
>>  	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
>> -		retval = ext4_ext_map_blocks(handle, inode, map, flags &
>> -					     EXT4_GET_BLOCKS_KEEP_SIZE);
>> +		retval = ext4_ext_map_blocks(handle, inode, map,
>> +					     (flags & EXT4_GET_BLOCKS_KEEP_SIZE) |
>> +					     EXT4_GET_BLOCKS_CACHE);
>>  	} else {
>>  		retval = ext4_ind_map_blocks(handle, inode, map, flags &
>>  					     EXT4_GET_BLOCKS_KEEP_SIZE);
>> -- 
>> 1.8.3.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
