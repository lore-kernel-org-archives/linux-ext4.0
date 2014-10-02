From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: ensure LARGE_FILE feature when mounting delalloc
Date: Wed, 01 Oct 2014 21:15:20 -0500
Message-ID: <542CB538.9010403@redhat.com>
References: <542C7331.4070200@redhat.com> <AA97FC30-5235-4E7E-AC17-14BC6C813F17@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJBCPV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Oct 2014 22:15:21 -0400
In-Reply-To: <AA97FC30-5235-4E7E-AC17-14BC6C813F17@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/1/14 8:26 PM, Andreas Dilger wrote:
> On Oct 1, 2014, at 3:33 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> Delalloc write journal reservations only reserve 1 credit,
>> to update the inode if necessary.  However, it may happen
>> once in a filesystem's lifetime that a file will cross
>> the 2G threshold, and require the LARGE_FILE feature to
>> be set in the superblock as well, if it was not set already.
>>
>> This overruns the transaction reservation, and can be
>> demonstrated simply on any ext4 filesystem without the LARGE_FILE
>> feature already set:
>>
>> dd if=/dev/zero of=testfile bs=1 seek=2147483646 count=1 \
>> 	conv=notrunc of=testfile
>> sync
>> dd if=/dev/zero of=testfile bs=1 seek=2147483647 count=1 \
>> 	conv=notrunc of=testfile
>>
>> leads to:
>>
>> EXT4-fs: ext4_do_update_inode:4296: aborting transaction: error 28 in __ext4_handle_dirty_super
>> EXT4-fs error (device loop0) in ext4_do_update_inode:4301: error 28
>> EXT4-fs error (device loop0) in ext4_reserve_inode_write:4757: Readonly filesystem
>> EXT4-fs error (device loop0) in ext4_dirty_inode:4876: error 28
>> EXT4-fs error (device loop0) in ext4_da_write_end:2685: error 28
>>
>> It simplifies things if we ensure that when we are running
>> with delalloc, we have LARGE_FILE set already; that way we
>> don't have to potentially set it later during a file write.
>>
>> For any fs of sufficient size, LARGE_FILE is usually set
>> simply due to the size of the resize inode.  And for ext4,
>> HUGE_FILE is set by default.
>>
>> LARGE_FILE is a decades-old compatibility flag, so at this
>> point there is little risk of backwards compatibility problems
>> by enabling it when the filesystem is mounted as ext4.
>>
>> So just set LARGE_FILE if we are mounted delalloc, if it's
>> not set already, and be done with it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> --- 
>>
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 0b28b36..8e56d7e 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -3576,6 +3576,20 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>> 			clear_opt(sb, DELALLOC);
>> 	}
>>
>> +	/*
>> +	 * Adding the LARGE_FILES feature to the superblock adds
>> +	 * unnecessary complication to journal credit calculations
>> +	 * when delalloc is enabled.  This is a decades-old feature,
>> +	 * so just enable it now to simplify things.
>> +	 */
>> +	if (test_opt(sb, DELALLOC) && !(sb->s_flags & MS_RDONLY) &&
>> +	    EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL) &&
>> +	    !EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_LARGE_FILE)) {
>> +		ext4_update_dynamic_rev(sb);
>> +		EXT4_SET_RO_COMPAT_FEATURE(sb,
>> +					   EXT4_FEATURE_RO_COMPAT_LARGE_FILE);
> 
> This sets the superblock flag, but doesn't actually mark the superblock
> dirty.  Later in ext4_fill_super() it is possible that this buffer_head
> is discarded without writing it out:
> 
>         if (sb->s_blocksize != blocksize) {
>                 :
>                 :
>                 brelse(bh);

sorry, I missed this; skipped to the end too fast.

> While this isn't completely fatal (the next mount would enable this
> flag again), it could cause some errors to appear in e2fsck if large
> files are created without the large_file feature in the superblock.
> It would probably be safer to mark the superblock dirty in this case
> so that it is written out.  No need to sync it I think
> 
>                 ext4_commit_super(sb, 0);
> 
> Also, it looks like it is possible to enable delalloc via remount, so
> this feature check/set should also be added there?

oh, bleah.  I guess so.

Thanks for the review, will send V2.

-Eric

> Cheers, Andreas
> 

