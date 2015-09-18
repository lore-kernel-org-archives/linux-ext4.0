From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: clear uninit BG if allocating from new group
Date: Thu, 17 Sep 2015 20:54:11 -0400 (EDT)
Message-ID: <196754A4-210B-45E7-837A-7955780208E6@redhat.com>
References: <55FB41CA.8010003@redhat.com> <20150917235524.GE10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:60466 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbbIRAyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2015 20:54:13 -0400
In-Reply-To: <20150917235524.GE10390@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 17, 2015, at 6:55 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
>> On Thu, Sep 17, 2015 at 05:42:18PM -0500, Eric Sandeen wrote:
>> If resize2fs_get_alloc_block() allocates from a BLOCK_UNINIT
>> group, nothing clears the UNINIT flag, so it is skipped when we
>> go to write out modified bitmaps.  This leads to post-resize2fs
>> e2fsck errors; used blocks in UNINIT groups, not marked in the
>> block bitmap.
>> 
>> This shamelessly cuts & pastes clear_block_uninit() into
>> resize2fs.c, and my problem goes away.
> 
> Hmm... which test was it that exhibited this error?
> 
r_ext4_small_bg

Originally it was claimed that only a gcc change exposed it; I'm still trying to make sense of that.  But the pre-resize image exhibits it with any recent resizefs when resized up to 2g as the test does.

>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>> 
>> I've kind of lost the thread on resize2fs lately, so maybe this is
>> a hack job?  At least it highlights the issue, even if it's not
>> quite right.  Passes "make check" here and seems ok to me...
>> 
>> Thanks,
>> -Eric
>> 
>> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
>> index 07c6a0c..0f202bd 100644
>> --- a/resize/resize2fs.c
>> +++ b/resize/resize2fs.c
>> @@ -1614,12 +1614,27 @@ static blk64_t get_new_block(ext2_resize_t rfs)
>>    }
>> }
>> 
>> +static void clear_block_uninit(ext2_filsys fs, dgrp_t group)
>> +{
>> +    if (!ext2fs_has_group_desc_csum(fs) ||
>> +        !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
>> +        return;
>> +
>> +    /* uninit block bitmaps are now initialized in read_bitmaps() */
>> +
>> +    ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
>> +    ext2fs_group_desc_csum_set(fs, group);
>> +    ext2fs_mark_super_dirty(fs);
>> +    ext2fs_mark_bb_dirty(fs);
>> +}
>> +
>> static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
>>                       blk64_t goal EXT2FS_ATTR((unused)),
>>                       blk64_t *ret)
>> {
>>    ext2_resize_t rfs = (ext2_resize_t) fs->priv_data;
>>    blk64_t blk;
>> +    int group;
>> 
>>    blk = get_new_block(rfs);
>>    if (!blk)
>> @@ -1632,6 +1647,12 @@ static errcode_t resize2fs_get_alloc_block(ext2_filsys fs,
>> 
>>    ext2fs_mark_block_bitmap2(rfs->old_fs->block_map, blk);
>>    ext2fs_mark_block_bitmap2(rfs->new_fs->block_map, blk);
>> +
>> +    group = ext2fs_group_of_blk2(rfs->old_fs, blk);
>> +    clear_block_uninit(rfs->old_fs, group);
> 
> Why does the old fs need to have BLOCK_UNINIT cleared?
> 
Same reason we mark the block used in the old fs?  TBH I didn't understand why we do that either, but sinc we do....

Eric

> --D
> 
>> +    group = ext2fs_group_of_blk2(rfs->new_fs, blk);
>> +    clear_block_uninit(rfs->new_fs, group);
>> +
>>    *ret = (blk64_t) blk;
>>    return 0;
>> }
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
