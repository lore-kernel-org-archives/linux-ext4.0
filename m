From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 13:10:41 -0600
Message-ID: <7755CB79-FD71-49BE-AF93-0A49CA25CEAC@dilger.ca>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com> <20110915165512.GA12086@tux1.beaverton.ibm.com> <20110915171934.GB12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>, linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:55580 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934458Ab1IOTKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 15:10:48 -0400
In-Reply-To: <20110915171934.GB12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-09-15, at 11:19 AM, Darrick J. Wong wrote:
> On Thu, Sep 15, 2011 at 09:55:12AM -0700, Darrick J. Wong wrote:
>> On Thu, Sep 15, 2011 at 11:12:22AM -0400, Theodore Ts'o wrote:
>>> 
>>> Hi Darrick, Amir,
>>> 
>>> Could you please take a look at the changes here and make sure they look
>>> sane to you?   I just want to make sure we're all on the same page as
>>> far as on-disk field assignments are concerned.
>>> 
>>> Also, one thought for Darrick.  I note that with the assignment of
>>> l_i_checksum, we've exhausted the very last field in the base 128-byte
>>> inode.  Given that the checksum is protecting a 128 byte or 256 byte
>>> inode, I wonder if we need to use a full 32 bit checksum.  Maybe we
>>> should just use 16 bits of a crc32c?
>>> 
>>> I did some web searching on the issue, and the recommendation I've come
>>> across is the following:
>>> 
>>> 	"Generally speaking, an n-bit CRC's error detection properties
>>> 	degrade after 2**(n-1)-1 data bits."
>>> 
>>> So a CRC-16 will be good up to just under 4k.  A 16-bit truncated crc32c
>>> will presumably not be as good as a crc16, but seems to me that it's
>>> probably fine for a 128-256 byte inode.  Especially since the main thing
>>> we're generally worried about is detecting a block getting written to
>>> the wrong location, overwriting an existing inode table block.  So if we
>>> were really paranoid we could verify the checksums for all of the inodes
>>> in a particular inode table block when we read in the inode table block
>>> in question.
>> 
>> On the other hand, you can set inode_size = block_size, which means that
>> with a 4k inode + 32-bit inode number + 16-byte UUID you actually could
>> run afoul of that degradation.  But that seems like an extreme argument
>> for an infrequent case.
>> 
>> Actually, I've started wondering if we could split the 4 bytes of the crc32c
>> among the first few inodes of the block, and compute the checksums at block
>> size granularity.  Though that would make inode updates particularly more
>> expensive... but if I'm going to shift the write-time checksum to a journal
>> callback then it's not going to matter (for the journal-using users, anyway).
>> 
>> Though with that scheme, you'd probably lose more inodes for any given
>> integrity error.  It also means that the checksum size in each inode becomes
>> variable (32 bits if inode=blocksize, 16 if inode=blocksize/2, and 8
>> otherwise), which is a somewhat confusing schema.
>> 
>> <shrug> Do you anticipate a need to add more fields to 128-byte inode
>> filesystems?  I think most of those would be former ext2/3 filesystems,
>> floppies, and "small" filesystems, correct?
>> 
>> Or does this second scheme sound more attractive?
> 
> I forgot to say, "as opposed to storing the lower 16 bits below 128 bytes and
> the upper 16 bits somewhere above it."

This is also a possible alternative, though it makes for more fragments that
need to be checksummed.  I think as a general rule it makes sense to store
the checksum as the last word in the structure, if possible, so that the
checksum can be computed in a single call.  This is already done for 128-byte
inodes and for 32-byte group descriptors, but should also be done for the
s_checksum field in the superblock (i.e. put it after s_reserved instead of
before).

For inodes 256-bytes or larger (which are commonly used for Lustre to store
large xattrs that are needed for every file access), and 64-byte group
descriptors it has to checksum 2 fragments, but at least not more than that
if we precompute for each inode the crc32c(uuid + inum) seed and for each
 group the crc32c(uuid + group) seed.  The superblock already contains the
UUID, but it may make sense to still precompute the crc32c(uuid) part and
store it in ext4_sb_info for computing the inode seed.

It really would be interesting to measure the crc32c() and crc16() performance
for 512MB in chunks of 4, 32, 128, 256, and 4096 bytes (which is the largest
that we will generally use until we get to data checksums).  That would give
us a good idea how fast the checksums _really_ are in our actual usage.

>>> commit ceade753f14f2697d329f71b5277b49fd46fcb55
>>> Author: Theodore Ts'o <tytso@mit.edu>
>>> Date:   Thu Sep 15 10:38:55 2011 -0400
>>> 
>>>    libext2fs: add metadata checksum and snapshot feature flags
>>> 
>>>    Reserve EXT4_FEATURE_RO_COMPAT_METADATA_CSUM and
>>>    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP.  Also reserve fields in the
>>>    superblock and the inode for the checksums.  In the block group
>>>    descriptor, reserve the exclude bitmap field for the snapshot feature,
>>>    and checksums for the inode and block allocation bitmaps.
>>> 
>>>    With this commit, the metadata checksum and exclude bitmap features
>>>    should have reserved all of the fields they need in ext4's on-disk
>>>    format.
>>> 
>>>    This commit also fixes an a missing byte swap for s_overhead_blocks.
>>> 
>>>    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>>    Cc: Darrick J. Wong <djwong@us.ibm.com>
>>>    Cc: Amir Goldstein <amir73il@gmail.com>
>>> 
>>> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
>>> index ac6bc25..cba9c12 100644
>>> --- a/debugfs/set_fields.c
>>> +++ b/debugfs/set_fields.c
>>> @@ -144,6 +144,7 @@ static struct field_set_info super_fields[] = {
>>> 	{ "usr_quota_inum", &set_sb.s_usr_quota_inum, 4, parse_uint },
>>> 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, 4, parse_uint },
>>> 	{ "overhead_blocks", &set_sb.s_overhead_blocks, 4, parse_uint },
>>> +	{ "checksum", &set_sb.s_checksum, 2, parse_uint },
>>> 	{ 0, 0, 0, 0 }
>>> };
>>> 
>>> @@ -179,6 +180,7 @@ static struct field_set_info inode_fields[] = {
>>> 	{ "fsize", &set_inode.osd2.hurd2.h_i_fsize, 1, parse_uint },
>>> 	{ "uid_high", &set_inode.osd2.linux2.l_i_uid_high, 2, parse_uint },
>>> 	{ "gid_high", &set_inode.osd2.linux2.l_i_gid_high, 2, parse_uint },
>>> +	{ "checksum", &set_inode.osd2.linux2.l_i_checksum, 4, parse_uint },
>>> 	{ "author", &set_inode.osd2.hurd2.h_i_author, 4, parse_uint },
>>> 	{ "bmap", NULL, 4, parse_bmap, FLAG_ARRAY },
>>> 	{ 0, 0, 0, 0 }
>>> @@ -192,7 +194,6 @@ static struct field_set_info ext2_bg_fields[] = {
>>> 	{ "free_inodes_count", &set_gd.bg_free_inodes_count, 2, parse_uint },
>>> 	{ "used_dirs_count", &set_gd.bg_used_dirs_count, 2, parse_uint },
>>> 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
>>> -	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
>>> 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
>>> 	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
>>> 	{ 0, 0, 0, 0 }
>>> diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
>>> index 16fba53..965fc16 100644
>>> --- a/lib/e2p/feature.c
>>> +++ b/lib/e2p/feature.c
>>> @@ -40,6 +40,8 @@ static struct feature feature_list[] = {
>>> 			"resize_inode" },
>>> 	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_LAZY_BG,
>>> 			"lazy_bg" },
>>> +	{	E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP,
>>> +			"snapshot" },
>>> 
>>> 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
>>> 			"sparse_super" },
>>> @@ -59,6 +61,8 @@ static struct feature feature_list[] = {
>>> 			"quota" },
>>> 	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_BIGALLOC,
>>> 			"bigalloc"},
>>> +	{	E2P_FEATURE_RO_INCOMPAT, EXT4_FEATURE_RO_COMPAT_METADATA_CSUM,
>>> +			"metadata_csum"},
>>> 
>>> 	{	E2P_FEATURE_INCOMPAT, EXT2_FEATURE_INCOMPAT_COMPRESSION,
>>> 			"compression" },
>>> diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
>>> index 0f36f40..aaacdaa 100644
>>> --- a/lib/e2p/ls.c
>>> +++ b/lib/e2p/ls.c
>>> @@ -413,6 +413,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
>>> 	if (sb->s_grp_quota_inum)
>>> 		fprintf(f, "Group quota inode:        %u\n",
>>> 			sb->s_grp_quota_inum);
>>> +
>>> +	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
>>> +		fprintf(f, "Checksum:                 0x%08x\n",
>>> +			sb->s_checksum);
>>> }
>>> 
>>> void list_super (struct ext2_super_block * s)
>>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>>> index 4fec5db..1b02054 100644
>>> --- a/lib/ext2fs/ext2_fs.h
>>> +++ b/lib/ext2fs/ext2_fs.h
>>> @@ -142,7 +142,9 @@ struct ext2_group_desc
>>> 	__u16	bg_free_inodes_count;	/* Free inodes count */
>>> 	__u16	bg_used_dirs_count;	/* Directories count */
>>> 	__u16	bg_flags;
>>> -	__u32	bg_reserved[2];
>>> +	__u32	bg_exclude_bitmap_lo;	/* Exclude bitmap for snapshots */
>>> +	__u16	bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>>> +	__u16	bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>>> 	__u16	bg_itable_unused;	/* Unused inodes count */
>>> 	__u16	bg_checksum;		/* crc16(s_uuid+grouo_num+group_desc)*/
>>> };
>>> @@ -159,7 +161,9 @@ struct ext4_group_desc
>>> 	__u16	bg_free_inodes_count;	/* Free inodes count */
>>> 	__u16	bg_used_dirs_count;	/* Directories count */
>>> 	__u16	bg_flags;		/* EXT4_BG_flags (INODE_UNINIT, etc) */
>>> -	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
>>> +	__u32	bg_exclude_bitmap_lo;	/* Exclude bitmap for snapshots */
>>> +	__u16	bg_block_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>>> +	__u16	bg_inode_bitmap_csum_lo;/* crc32c(s_uuid+grp_num+bitmap) LSB */
>>> 	__u16	bg_itable_unused;	/* Unused inodes count */
>>> 	__u16	bg_checksum;		/* crc16(sb_uuid+group+desc) */
>>> 	__u32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
>>> @@ -169,7 +173,10 @@ struct ext4_group_desc
>>> 	__u16	bg_free_inodes_count_hi;/* Free inodes count MSB */
>>> 	__u16	bg_used_dirs_count_hi;	/* Directories count MSB */
>>> 	__u16	bg_itable_unused_hi;	/* Unused inodes count MSB */
>>> -	__u32	bg_reserved2[3];
>>> +	__u32	bg_exclude_bitmap_hi;	/* Exclude bitmap block MSB */
>>> +	__u16	bg_block_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
>>> +	__u16	bg_inode_bitmap_csum_hi;/* crc32c(s_uuid+grp_num+bitmap) MSB */
>>> +	__u32	bg_reserved;
>>> };
>>> 
>>> #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
>>> @@ -363,7 +370,7 @@ struct ext2_inode {
>>> 			__u16	l_i_file_acl_high;
>>> 			__u16	l_i_uid_high;	/* these 2 fields    */
>>> 			__u16	l_i_gid_high;	/* were reserved2[0] */
>>> -			__u32	l_i_reserved2;
>>> +			__u32	l_i_checksum;	/* crc32c(uuid+inum+inode) */
>>> 		} linux2;
>>> 		struct {
>>> 			__u8	h_i_frag;	/* Fragment number */
>>> @@ -410,7 +417,7 @@ struct ext2_inode_large {
>>> 			__u16	l_i_file_acl_high;
>>> 			__u16	l_i_uid_high;	/* these 2 fields    */
>>> 			__u16	l_i_gid_high;	/* were reserved2[0] */
>>> -			__u32	l_i_reserved2;
>>> +			__u32	l_i_checksum;	/* crc32c(uuid+inum+inode) */
>>> 		} linux2;
>>> 		struct {
>>> 			__u8	h_i_frag;	/* Fragment number */
>>> @@ -441,7 +448,7 @@ struct ext2_inode_large {
>>> #define i_gid_low	i_gid
>>> #define i_uid_high	osd2.linux2.l_i_uid_high
>>> #define i_gid_high	osd2.linux2.l_i_gid_high
>>> -#define i_reserved2	osd2.linux2.l_i_reserved2
>>> +#define i_checksum	osd2.linux2.l_i_checksum
>>> #else
>>> #if defined(__GNU__)
>>> 
>>> @@ -623,7 +630,8 @@ struct ext2_super_block {
>>> 	__u32	s_usr_quota_inum;	/* inode number of user quota file */
>>> 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
>>> 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
>>> -	__u32   s_reserved[109];        /* Padding to the end of the block */
>>> +	__u32	s_checksum;		/* crc32c(superblock) */
>>> +	__u32   s_reserved[108];        /* Padding to the end of the block */
>>> };
>>> 
>>> #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
>>> @@ -671,7 +679,9 @@ struct ext2_super_block {
>>> #define EXT2_FEATURE_COMPAT_RESIZE_INODE	0x0010
>>> #define EXT2_FEATURE_COMPAT_DIR_INDEX		0x0020
>>> #define EXT2_FEATURE_COMPAT_LAZY_BG		0x0040
>>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080
>>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE	0x0080 not used, legacy */
>>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
>>> +
>>> 
>>> #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
>>> #define EXT2_FEATURE_RO_COMPAT_LARGE_FILE	0x0002
>>> @@ -683,6 +693,7 @@ struct ext2_super_block {
>>> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
>>> #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
>>> #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
>>> +#define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
>>> 
>>> #define EXT2_FEATURE_INCOMPAT_COMPRESSION	0x0001
>>> #define EXT2_FEATURE_INCOMPAT_FILETYPE		0x0002
>>> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
>>> index 87b1a2e..d1c4a56 100644
>>> --- a/lib/ext2fs/swapfs.c
>>> +++ b/lib/ext2fs/swapfs.c
>>> @@ -78,6 +78,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
>>> 	sb->s_snapshot_list = ext2fs_swab32(sb->s_snapshot_list);
>>> 	sb->s_usr_quota_inum = ext2fs_swab32(sb->s_usr_quota_inum);
>>> 	sb->s_grp_quota_inum = ext2fs_swab32(sb->s_grp_quota_inum);
>>> +	sb->s_overhead_blocks = ext2fs_swab32(sb->s_overhead_blocks);
>>> +	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
>>> 
>>> 	for (i=0; i < 4; i++)
>>> 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
>>> @@ -106,6 +108,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
>>> 	gdp->bg_free_inodes_count = ext2fs_swab16(gdp->bg_free_inodes_count);
>>> 	gdp->bg_used_dirs_count = ext2fs_swab16(gdp->bg_used_dirs_count);
>>> 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
>>> +	gdp->bg_exclude_bitmap_lo = ext2fs_swab32(gdp->bg_exclude_bitmap_lo);
>>> +	gdp->bg_block_bitmap_csum_lo =
>>> +		ext2fs_swab16(gdp->bg_block_bitmap_csum_lo);
>>> +	gdp->bg_inode_bitmap_csum_lo =
>>> +		ext2fs_swab16(gdp->bg_inode_bitmap_csum_lo);
>>> 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
>>> 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
>>> 	/* If we're 32-bit, we're done */
>>> @@ -125,6 +132,11 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
>>> 	gdp4->bg_used_dirs_count_hi =
>>> 		ext2fs_swab16(gdp4->bg_used_dirs_count_hi);
>>> 	gdp4->bg_itable_unused_hi = ext2fs_swab16(gdp4->bg_itable_unused_hi);
>>> +	gdp->bg_exclude_bitmap_hi = ext2fs_swab16(gdp->bg_exclude_bitmap_hi);
>>> +	gdp->bg_block_bitmap_csum_hi =
>>> +		ext2fs_swab16(gdp->bg_block_bitmap_csum_hi);
>>> +	gdp->bg_inode_bitmap_csum_hi =
>>> +		ext2fs_swab16(gdp->bg_inode_bitmap_csum_hi);
>>> }
>>> 
>>> void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
>>> @@ -244,8 +256,8 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
>>> 		  ext2fs_swab16 (f->osd2.linux2.l_i_uid_high);
>>> 		t->osd2.linux2.l_i_gid_high =
>>> 		  ext2fs_swab16 (f->osd2.linux2.l_i_gid_high);
>>> -		t->osd2.linux2.l_i_reserved2 =
>>> -			ext2fs_swab32(f->osd2.linux2.l_i_reserved2);
>>> +		t->osd2.linux2.l_i_checksum =
>>> +			ext2fs_swab32(f->osd2.linux2.checksum);
>>> 		break;
>>> 	case EXT2_OS_HURD:
>>> 		t->osd1.hurd1.h_i_translator =
>>> diff --git a/lib/ext2fs/tst_inode_size.c b/lib/ext2fs/tst_inode_size.c
>>> index 962f1cd..683b79c 100644
>>> --- a/lib/ext2fs/tst_inode_size.c
>>> +++ b/lib/ext2fs/tst_inode_size.c
>>> @@ -61,7 +61,7 @@ void check_structure_fields()
>>> 	check_field(osd2.linux2.l_i_file_acl_high);
>>> 	check_field(osd2.linux2.l_i_uid_high);
>>> 	check_field(osd2.linux2.l_i_gid_high);
>>> -	check_field(osd2.linux2.l_i_reserved2);
>>> +	check_field(osd2.linux2.l_i_checksum);
>>> 	printf("Ending offset is %d\n\n", cur_offset);
>>> #endif
>>> }
>>> diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
>>> index 1e5a524..75659ae 100644
>>> --- a/lib/ext2fs/tst_super_size.c
>>> +++ b/lib/ext2fs/tst_super_size.c
>>> @@ -126,6 +126,7 @@ void check_superblock_fields()
>>> 	check_field(s_usr_quota_inum);
>>> 	check_field(s_grp_quota_inum);
>>> 	check_field(s_overhead_blocks);
>>> +	check_field(s_checksum);
>>> 	check_field(s_reserved);
>>> 	printf("Ending offset is %d\n\n", cur_offset);
>>> #endif
>>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





