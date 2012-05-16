From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsck: Let end_blk to be the maximum value of u32.
Date: Wed, 16 May 2012 10:31:01 -0500
Message-ID: <4FB3C835.2090509@redhat.com>
References: <1337158225-4627-1-git-send-email-tm@tao.ma> <4FB3B404.4080101@redhat.com> <4FB3C2BE.8080502@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab2EPPbF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 May 2012 11:31:05 -0400
In-Reply-To: <4FB3C2BE.8080502@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/12 10:07 AM, Tao Ma wrote:
> On 05/16/2012 10:04 PM, Eric Sandeen wrote:
>> On 5/16/12 3:50 AM, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> Now we can use fallocate to create a large file while keep the size
>>> to be small. It will cause the e2fsck complain about it. The test
>>> script is simple and I have pasted it here.
>>>
>>> DEVICE=/dev/sdb1
>>> mount -t ext4 $DEVICE /mnt/ext4
>>> for((i=0;i<10;i++))do fallocate -n -o $[$i*8192] -l 4096 /mnt/ext4/a;done
>>> umount $DEVICE
>>> e2fsck -fn $DEVICE
>>
>> Should this be put into an e2fsprogs regression test?
> sure, but could you please tell me where I can find the repo?

there are regression tests in the e2fsprogs git tree itself.
I think a prepared filesytem image may be the way to go for this one.

>>> The error message will be like this:
>>> e2fsck 1.42.3 (14-May-2012)
>>> Pass 1: Checking inodes, blocks, and sizes
>>> Inode 12 has zero length extent
>>> 	(invalid logical block 0, physical block 32775)
>>> Clear? no
>>>
>>> Inode 12, i_blocks is 88, should be 0.  Fix? no
>>>
>>> Pass 2: Checking directory structure
>>> Pass 3: Checking directory connectivity
>>> Pass 4: Checking reference counts
>>> Pass 5: Checking group summary information
>>> Block bitmap differences:  -(8231--8232) -(32770--32778)
>>> Fix? no
>>>
>>> Now actually the end_blk can be any value which is less than
>>> u32, so make end_blk be the maximum value of u32.
>>>
>>> Cc: Theodore Ts'o <tytso@mit.edu>
>>> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
>>> ---
>>>  lib/ext2fs/extent.c |    4 +---
>>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
>>> index eb096d6..e2815c2 100644
>>> --- a/lib/ext2fs/extent.c
>>> +++ b/lib/ext2fs/extent.c
>>> @@ -253,9 +253,7 @@ extern errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
>>>  		ext2fs_le16_to_cpu(eh->eh_entries);
>>>  	handle->path[0].max_entries = ext2fs_le16_to_cpu(eh->eh_max);
>>>  	handle->path[0].curr = 0;
>>> -	handle->path[0].end_blk =
>>> -		(EXT2_I_SIZE(handle->inode) + fs->blocksize - 1) >>
>>> -		 EXT2_BLOCK_SIZE_BITS(fs->super);
>>
>> Hm, so this picked the actual last block of the file, whereas
> No, it doesn't. With fallocate(FALLOC_FL_KEEP_SIZE), we have no idea of
> what is the last block until we iterate the last leaf ext4_extent.

Oh, sorry - this "tried to pick" is what I meant to say :)

>>> +	handle->path[0].end_blk = ((((unsigned long long) 1) << 32) - 1);
>>
>> this gives it an upper bound... why is that ok?  It's been a long time since
>> I looked at this code, but some explanation in the commit and in code
>> comments would be helpful.
>>
>> If end_blk can be any value less than u32, what is its purpose?
> As I have mentioned above, now there is no way for us to tell the end
> block of a file at the very beginning of ext2fs_extent_open2, so
> actually any value less than u32 could be OK if we have a sparse file
> while the last block is fallocated near the end of u32 logical block
> offset. Actually path[0]->end_blk is only used when we have no idea of
> the length of the last ext4_extent_idx. See ext2fs_extent_get.

Ok.  Thanks.

-Eric

> if (path->left > 0) {
> 	ix++;
>         newpath->end_blk = ext2fs_le32_to_cpu(ix->ei_block);
> } else
> 	newpath->end_blk = path->end_blk;
> 
> Having said that, I have to admit that I didn't think of the case of
> ext3 and I am not sure whether this change will affect it or not.
> 
> Thanks
> Tao
>>
>> -Eric
>>
>>>  	handle->path[0].visit_num = 1;
>>>  	handle->level = 0;
>>>  	handle->magic = EXT2_ET_MAGIC_EXTENT_HANDLE;
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

