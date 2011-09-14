From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 11/37] libext2fs: Create the inode bitmap checksum
Date: Wed, 14 Sep 2011 13:59:06 -0600
Message-ID: <1240A2E8-5AA6-4F97-BB36-944A2F51B2E5@dilger.ca>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003622.1176.1504.stgit@elm3c44.beaverton.ibm.com> <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20448 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1INT7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 15:59:07 -0400
In-Reply-To: <20110914170259.GG3429@dhcp-172-31-195-159.cam.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-14, at 11:02 AM, Ted Ts'o wrote:
> On Wed, Aug 31, 2011 at 05:36:22PM -0700, Darrick J. Wong wrote:
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 1f08673..367bfdf 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -169,7 +169,8 @@ struct ext4_group_desc
>> 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
>> 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
>> 	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
>> -	__u32	bg_reserved2[3];
>> +	__u32	bg_inode_bitmap_csum;	/* crc32c(uuid+group+ibitmap) */
>> +	__u32	bg_reserved2[2];
>> };
> 
> One of the reasons why I like to coalesce the patches to the data
> structures into their own separate commit, is it's hard when I'm
> reviewing individual patches in a mail reader what's going on from a
> big picture spective.  (Heck, even just *finding* the patches that
> modify the on-disk format is hard....)
> 
> But as near as I can tell, your patch series only uses one of the
> 32-bit fields in bg_reserved.  Is there a good reason why
> bg_inode_bitmap_csum can't also used one of the two fields in
> bg_reserved?  That way we get two 32-bit checksums for both struct
> ext2_group_desc and struct ext4_group_desc.  Is there a third 32-bit
> per-block group checksum I'm forgetting about?

There is the field that you told Amir he could use for the exception
bitmap for snapshots, which is using one of the two reserved fields in
ext2_group_desc, and also one of the 3 reserved fields in ext4_group_desc
for 64-bit block numbers.  That leaves one __u32 in ext2_group_desc, and
two __u32 in ext4_group_desc for checksums.

My proposal was as follows.  It adds the split checksums for block and
inode bitmaps, and renames bg_checksum to bg_group_desc_csum to avoid
confusion with these new checksums.  Truncate after bg_group_desc_csum
for smaller ext2_group_desc version.

struct ext4_group_desc
{
        __le32  bg_block_bitmap_lo;     /* Blocks bitmap block */
        __le32  bg_inode_bitmap_lo;     /* Inodes bitmap block */
        __le32  bg_inode_table_lo;      /* Inodes table block */
        __le16  bg_free_blocks_count_lo;/* Free blocks count */
        __le16  bg_free_inodes_count_lo;/* Free inodes count */
        __le16  bg_used_dirs_count_lo;  /* Directories count */
        __le16  bg_flags;               /* EXT4_BG_flags (INODE_UNINIT, etc) */
        __le32  bg_exclude_bitmap_lo;   /* Snapshot exclude bitmap block LSB */
        __le16  bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
        __le16  bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
        __le16  bg_itable_unused_lo;    /* Unused inodes count */
        __le16  bg_group_desc_csum;     /* crc16(sb_uuid+group+desc) */
        __le32  bg_block_bitmap_hi;     /* Blocks bitmap block MSB */
        __le32  bg_inode_bitmap_hi;     /* Inodes bitmap block MSB */
        __le32  bg_inode_table_hi;      /* Inodes table block MSB */
        __le16  bg_free_blocks_count_hi;/* Free blocks count MSB */
        __le16  bg_free_inodes_count_hi;/* Free inodes count MSB */
        __le16  bg_used_dirs_count_hi;  /* Directories count MSB */
        __le16  bg_itable_unused_hi;    /* Unused inodes count MSB */
	__le32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
        __le16  bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
        __le16  bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
        __le32  bg_reserved2;
};

Whether crc32c & 0xffff is as strong as crc16 is open for debate, but it
isn't completely worthless (it provides some protection, and crc32c is
much faster at least for larger block sizes), and is only for filesystems
upgraded in-place from ext3 so it isn't critical in the long run.  I'd
rather have less complex and faster code than having to conditionally
compute crc16 vs crc32c depending on the ext4_group_desc size.

There is also the question if we want to extend bg_group_desc_csum and/or
the bg_flags values to be 32-bit fields?  If we do, then that uses up all
of the space in the 64-byte group descriptor and we would need to bump it
to 128 bytes to add any new fields.  We can deal with that when we run
out of flags.  I don't think there is a need to have a 32-bit checksum
for such a small structure, and potentially it makes sense to use the low
bits of crc32c instead of crc16 just to stick with a single algorithm for
the filesystem.

Cheers, Andreas