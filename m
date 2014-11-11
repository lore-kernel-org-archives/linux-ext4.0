From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 3/4] e2fsprogs/tune2fs: rewrite metadata checksums when
 resizing inode size
Date: Tue, 11 Nov 2014 17:08:42 +0800
Message-ID: <5461D21A.8050206@cn.fujitsu.com>
References: <1415689169-19393-1-git-send-email-wangxg.fnst@cn.fujitsu.com> <1415689169-19393-3-git-send-email-wangxg.fnst@cn.fujitsu.com> <20141111083329.GE10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-ext4@vger.kernel.org>, <tytso@mit.edu>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21792 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751725AbaKKJK6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Nov 2014 04:10:58 -0500
In-Reply-To: <20141111083329.GE10043@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On 11/11/2014 04:33 PM, Darrick J. Wong wrote:
> On Tue, Nov 11, 2014 at 02:59:28PM +0800, Xiaoguang Wang wrote:
>> When we use tune2fs -I new_ino_size to change inode size, if everything is OK,
>> the corresponding ext4_group_desc.bg_free_blocks_count will be decreased, so
>> obviously, we need to re-compute the group descriptor checksums, fix this. If
>> not doing this, mount operation will fail.
>>
>> Meanwhile, the patch will trigger an existing memory write overflow, which will
>> casue segfault, please see the next patch.
>>
>> Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
>> ---
>>  misc/tune2fs.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>> index 065b483..91dc7c1 100644
>> --- a/misc/tune2fs.c
>> +++ b/misc/tune2fs.c
>> @@ -2908,8 +2908,7 @@ retry_open:
>>  				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>>  			rewrite_checksums = 1;
>>  	}
>> -	if (rewrite_checksums)
>> -		rewrite_metadata_checksums(fs);
>> +
>>  	if (I_flag) {
>>  		if (mount_flags & EXT2_MF_MOUNTED) {
>>  			fputs(_("The inode size may only be "
>> @@ -2935,6 +2934,7 @@ retry_open:
>>  		if (resize_inode(fs, new_inode_size) == 0) {
>>  			printf(_("Setting inode size %lu\n"),
>>  							new_inode_size);
>> +			rewrite_checksums = 1;
> 
> rewrite_metadata_checksums() was designed to rewrite checksums on every
> metadata object in the filesystem (extents, ACLs, directory blocks), which I
> think does more work than necessary for your use case (if I'm reading this
> correctly) of simply rewriting the block group descriptor checksums.  Would it
> suffice to call ext2fs_group_desc_csum_set() when setting bg_free_blocks_count?
> I think this could be done in ext2fs_calculate_summary_stats().

For a new created file system, I think ext2fs_group_desc_csum_set() would be sufficient, because
the needed blocks(used for new inode table, they must be continuous) will be free. But for a file
system, if it already has many directories and files, these blocks may be in use, then we need to
replace these blocks with other blocks, so the ACLs and extent tree may also be modified, see
inode_scan_and_fix(), so I think here we need a rewrite_metadata_checksums(), in other words, it's
the safest :) I'm still new to ext4(learning the code now), so I may also miss something, thanks!

Regards,
Xiaoguang Wang

 

> 
> --D
> 
>>  		} else {
>>  			printf("%s", _("Failed to change inode size\n"));
>>  			rc = 1;
>> @@ -2942,6 +2942,9 @@ retry_open:
>>  		}
>>  	}
>>  
>> +	if (rewrite_checksums)
>> +		rewrite_metadata_checksums(fs);
>> +
>>  	if (l_flag)
>>  		list_super(sb);
>>  	if (stride_set) {
>> -- 
>> 1.8.2.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

