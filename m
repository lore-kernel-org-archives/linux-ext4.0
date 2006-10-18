From: Jean-Pierre Dion <jean-pierre.dion@bull.net>
Subject: Re: + ext4_allow_larger_descriptor_size.patch added to -mm tree
Date: Wed, 18 Oct 2006 17:12:46 +0200
Message-ID: <4536446E.9020507@bull.net>
References: <20061006080329.GA32421@openx1.frec.bull.fr> <45364639.3090707@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: akpm@osdl.org, shaggy@austin.ibm.com,
	Alexandre Ratchov <alexandre.ratchov@bull.net>,
	Valerie Clement <valerie.clement@bull.net>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35715 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1161154AbWJRPMh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Oct 2006 11:12:37 -0400
To: Jean-Noel Cordenner <jean-noel.cordenner@bull.net>
In-Reply-To: <45364639.3090707@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks Jean-No=EBl,

I am just cc'ing the list  ;-)


jean-pierre


Jean-Noel Cordenner wrote:

> hi,
>
> I've tested it using 64bits adressing, and it works.
>
> regards,
>
> Jean noel
>
>
>>
>> The patch titled
>>
>>      ext4: allow larger descriptor size
>>
>> has been added to the -mm tree.  Its filename is
>>
>>      ext4_allow_larger_descriptor_size.patch
>>
>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt=20
>> to find
>> out what to do about this
>>
>> ------------------------------------------------------
>> Subject: ext4: allow larger descriptor size
>> From: Alexandre Ratchov <alexandre.ratchov@bull.net>
>>
>> make block group descriptor larger.
>>
>> Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>
>> Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>
>> Signed-off-by: Andrew Morton <akpm@osdl.org>
>> ---
>>
>>  fs/ext4/balloc.c           |    6 ++++--
>>  fs/ext4/inode.c            |    8 +++++---
>>  fs/ext4/super.c            |   18 +++++++++++++++---
>>  include/linux/ext4_fs.h    |    9 ++++++---
>>  include/linux/ext4_fs_sb.h |    1 +
>>  5 files changed, 31 insertions(+), 11 deletions(-)
>>
>> diff -puN fs/ext4/balloc.c~ext4_allow_larger_descriptor_size=20
>> fs/ext4/balloc.c
>> --- a/fs/ext4/balloc.c~ext4_allow_larger_descriptor_size
>> +++ a/fs/ext4/balloc.c
>> @@ -74,10 +74,12 @@ struct ext4_group_desc * ext4_get_group_
>>          return NULL;
>>      }
>> =20
>> -    desc =3D (struct ext4_group_desc *)=20
>> sbi->s_group_desc[group_desc]->b_data;
>> +    desc =3D (struct ext4_group_desc *)(
>> +        (__u8 *)sbi->s_group_desc[group_desc]->b_data +
>> +        offset * EXT4_DESC_SIZE(sb));
>>      if (bh)
>>          *bh =3D sbi->s_group_desc[group_desc];
>> -    return desc + offset;
>> +    return desc;
>>  }
>> =20
>>  /**
>> diff -puN fs/ext4/inode.c~ext4_allow_larger_descriptor_size=20
>> fs/ext4/inode.c
>> --- a/fs/ext4/inode.c~ext4_allow_larger_descriptor_size
>> +++ a/fs/ext4/inode.c
>> @@ -2432,14 +2432,16 @@ static ext4_fsblk_t ext4_get_inode_block
>>          return 0;
>>      }
>> =20
>> -    gdp =3D (struct ext4_group_desc *)bh->b_data;
>> +    gdp =3D (struct ext4_group_desc *)((__u8 *)bh->b_data +
>> +        desc * EXT4_DESC_SIZE(sb));
>>      /*
>>       * Figure out the offset within the block group inode table
>>       */
>>      offset =3D ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
>>          EXT4_INODE_SIZE(sb);
>> -    block =3D ext4_inode_table(gdp + desc) +
>> -            (offset >> EXT4_BLOCK_SIZE_BITS(sb));
>> +    block =3D ext4_inode_table(gdp) + (offset >>=20
>> EXT4_BLOCK_SIZE_BITS(sb));
>> +
>> +
>> =20
>>      iloc->block_group =3D block_group;
>>      iloc->offset =3D offset & (EXT4_BLOCK_SIZE(sb) - 1);
>> diff -puN fs/ext4/super.c~ext4_allow_larger_descriptor_size=20
>> fs/ext4/super.c
>> --- a/fs/ext4/super.c~ext4_allow_larger_descriptor_size
>> +++ a/fs/ext4/super.c
>> @@ -1268,7 +1268,8 @@ static int ext4_check_descriptors (struc
>>              return 0;
>>          }
>>          first_block +=3D EXT4_BLOCKS_PER_GROUP(sb);
>> -        gdp++;
>> +        gdp =3D (struct ext4_group_desc *)
>> +            ((__u8 *)gdp + EXT4_DESC_SIZE(sb));
>>      }
>> =20
>>      ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb=
));
>> @@ -1619,7 +1620,18 @@ static int ext4_fill_super (struct super
>>                 sbi->s_frag_size, blocksize);
>>          goto failed_mount;
>>      }
>> -    sbi->s_frags_per_block =3D 1;
>> +    sbi->s_desc_size =3D le16_to_cpu(es->s_desc_size);
>> +    if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT))=
 {
>> +        if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE ||
>> +            sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
>> +            sbi->s_desc_size & (sbi->s_desc_size - 1)) {
>> +            printk(KERN_ERR
>> +                   "EXT4-fs: unsupported descriptor size %ld\n",
>> +                   sbi->s_desc_size);
>> +            goto failed_mount;
>> +        }
>> +    } else
>> +        sbi->s_desc_size =3D EXT4_MIN_DESC_SIZE;
>>      sbi->s_blocks_per_group =3D le32_to_cpu(es->s_blocks_per_group)=
;
>>      sbi->s_frags_per_group =3D le32_to_cpu(es->s_frags_per_group);
>>      sbi->s_inodes_per_group =3D le32_to_cpu(es->s_inodes_per_group)=
;
>> @@ -1630,7 +1642,7 @@ static int ext4_fill_super (struct super
>>          goto cantfind_ext4;
>>      sbi->s_itb_per_group =3D sbi->s_inodes_per_group /
>>                      sbi->s_inodes_per_block;
>> -    sbi->s_desc_per_block =3D blocksize / sizeof(struct ext4_group_=
desc);
>> +    sbi->s_desc_per_block =3D blocksize / EXT4_DESC_SIZE(sb);
>>      sbi->s_sbh =3D bh;
>>      sbi->s_mount_state =3D le16_to_cpu(es->s_state);
>>      sbi->s_addr_per_block_bits =3D log2(EXT4_ADDR_PER_BLOCK(sb));
>> diff -puN include/linux/ext4_fs.h~ext4_allow_larger_descriptor_size=20
>> include/linux/ext4_fs.h
>> --- a/include/linux/ext4_fs.h~ext4_allow_larger_descriptor_size
>> +++ a/include/linux/ext4_fs.h
>> @@ -142,6 +142,9 @@ struct ext4_group_desc
>>  /*
>>   * Macro-instructions used to manage group descriptors
>>   */
>> +#define EXT4_MIN_DESC_SIZE        32
>> +#define    EXT4_MAX_DESC_SIZE        EXT4_MIN_BLOCK_SIZE
>> +#define EXT4_DESC_SIZE(s)        (EXT4_SB(s)->s_desc_size)
>>  #ifdef __KERNEL__
>>  # define EXT4_BLOCKS_PER_GROUP(s)    (EXT4_SB(s)->s_blocks_per_grou=
p)
>>  # define EXT4_DESC_PER_BLOCK(s)        (EXT4_SB(s)->s_desc_per_bloc=
k)
>> @@ -149,7 +152,7 @@ struct ext4_group_desc
>>  # define EXT4_DESC_PER_BLOCK_BITS(s)   =20
>> (EXT4_SB(s)->s_desc_per_block_bits)
>>  #else
>>  # define EXT4_BLOCKS_PER_GROUP(s)    ((s)->s_blocks_per_group)
>> -# define EXT4_DESC_PER_BLOCK(s)        (EXT4_BLOCK_SIZE(s) / sizeof=
=20
>> (struct ext4_group_desc))
>> +# define EXT4_DESC_PER_BLOCK(s)        (EXT4_BLOCK_SIZE(s) /=20
>> EXT4_DESC_SIZE(s))
>>  # define EXT4_INODES_PER_GROUP(s)    ((s)->s_inodes_per_group)
>>  #endif
>> =20
>> @@ -474,7 +477,7 @@ struct ext4_super_block {
>>       * things it doesn't understand...
>>       */
>>      __le32    s_first_ino;        /* First non-reserved inode */
>> -    __le16   s_inode_size;        /* size of inode structure */
>> +    __le16  s_inode_size;        /* size of inode structure */
>>      __le16    s_block_group_nr;    /* block group # of this=20
>> superblock */
>>      __le32    s_feature_compat;    /* compatible feature set */
>>  /*60*/    __le32    s_feature_incompat;    /* incompatible feature=20
>> set */
>> @@ -500,7 +503,7 @@ struct ext4_super_block {
>>      __le32    s_hash_seed[4];        /* HTREE hash seed */
>>      __u8    s_def_hash_version;    /* Default hash version to use *=
/
>>      __u8    s_reserved_char_pad;
>> -    __u16    s_reserved_word_pad;
>> +    __le16  s_desc_size;        /* size of group descriptor */
>>  /*100*/    __le32    s_default_mount_opts;
>>      __le32    s_first_meta_bg;    /* First metablock block group */
>>      __le32    s_mkfs_time;        /* When the filesystem was create=
d */
>> diff -puN=20
>> include/linux/ext4_fs_sb.h~ext4_allow_larger_descriptor_size=20
>> include/linux/ext4_fs_sb.h
>> --- a/include/linux/ext4_fs_sb.h~ext4_allow_larger_descriptor_size
>> +++ a/include/linux/ext4_fs_sb.h
>> @@ -29,6 +29,7 @@
>>   */
>>  struct ext4_sb_info {
>>      unsigned long s_frag_size;    /* Size of a fragment in bytes */
>> +    unsigned long s_desc_size;    /* Size of a group descriptor in=20
>> bytes */
>>      unsigned long s_frags_per_block;/* Number of fragments per bloc=
k */
>>      unsigned long s_inodes_per_block;/* Number of inodes per block =
*/
>>      unsigned long s_frags_per_group;/* Number of fragments in a=20
>> group */
>> _
>>
>> Patches currently in -mm which might be from=20
>> alexandre.ratchov@bull.net are
>>
>> 64bit-metadata.patch
>> ext4_allow_larger_descriptor_size.patch
>> ext4_move_block_number_hi_bits.patch
>>
>> ----- End forwarded message -----
>> ----- Forwarded message from akpm@osdl.org -----
>>
>> From: akpm@osdl.org
>> Date: Thu, 05 Oct 2006 17:36:51 -0700
>> To: mm-commits@vger.kernel.org
>> Cc: alexandre.ratchov@bull.net, shaggy@austin.ibm.com
>> Subject: + ext4_move_block_number_hi_bits.patch added to -mm tree
>>
>>
>> The patch titled
>>
>>      ext4: move block number hi bits
>>
>> has been added to the -mm tree.  Its filename is
>>
>>      ext4_move_block_number_hi_bits.patch
>>
>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt=20
>> to find
>> out what to do about this
>>
>> ------------------------------------------------------
>> Subject: ext4: move block number hi bits
>> From: Alexandre Ratchov <alexandre.ratchov@bull.net>
>>
>> move '_hi' bits of block numbers in the larger part of the
>> block group descriptor structure
>>
>> Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>
>> Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>
>> Signed-off-by: Andrew Morton <akpm@osdl.org>
>> ---
>>
>>  fs/ext4/balloc.c        |   20 ++++++++--------
>>  fs/ext4/ialloc.c        |    4 +--
>>  fs/ext4/inode.c         |    7 ++---
>>  fs/ext4/resize.c        |    6 ++--
>>  fs/ext4/super.c         |   46 +++++++++++++++++++++++-------------=
--
>>  include/linux/ext4_fs.h |   27 ++++++++++++++--------
>>  6 files changed, 64 insertions(+), 46 deletions(-)
>>
>> diff -puN fs/ext4/balloc.c~ext4_move_block_number_hi_bits=20
>> fs/ext4/balloc.c
>> --- a/fs/ext4/balloc.c~ext4_move_block_number_hi_bits
>> +++ a/fs/ext4/balloc.c
>> @@ -101,13 +101,13 @@ read_block_bitmap(struct super_block *sb
>>      desc =3D ext4_get_group_desc (sb, block_group, NULL);
>>      if (!desc)
>>          goto error_out;
>> -    bh =3D sb_bread(sb, ext4_block_bitmap(desc));
>> +    bh =3D sb_bread(sb, ext4_block_bitmap(sb, desc));
>>      if (!bh)
>>          ext4_error (sb, "read_block_bitmap",
>>                  "Cannot read block bitmap - "
>>                  "block_group =3D %d, block_bitmap =3D %llu",
>>                  block_group,
>> -                ext4_block_bitmap(desc));
>> +                ext4_block_bitmap(sb, desc));
>>  error_out:
>>      return bh;
>>  }
>> @@ -463,10 +463,10 @@ do_more:
>>      if (!desc)
>>          goto error_return;
>> =20
>> -    if (in_range(ext4_block_bitmap(desc), block, count) ||
>> -        in_range(ext4_inode_bitmap(desc), block, count) ||
>> -        in_range(block, ext4_inode_table(desc),=20
>> sbi->s_itb_per_group) ||
>> -        in_range(block + count - 1, ext4_inode_table(desc),
>> +    if (in_range(ext4_block_bitmap(sb, desc), block, count) ||
>> +        in_range(ext4_inode_bitmap(sb, desc), block, count) ||
>> +        in_range(block, ext4_inode_table(sb, desc),=20
>> sbi->s_itb_per_group) ||
>> +        in_range(block + count - 1, ext4_inode_table(sb, desc),
>>               sbi->s_itb_per_group))
>>          ext4_error (sb, "ext4_free_blocks",
>>                  "Freeing blocks in system zones - "
>> @@ -1563,11 +1563,11 @@ allocated:
>> =20
>>      ret_block =3D grp_alloc_blk + ext4_group_first_block_no(sb,=20
>> group_no);
>> =20
>> -    if (in_range(ext4_block_bitmap(gdp), ret_block, num) ||
>> -        in_range(ext4_block_bitmap(gdp), ret_block, num) ||
>> -        in_range(ret_block, ext4_inode_table(gdp),
>> +    if (in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
>> +        in_range(ext4_block_bitmap(sb, gdp), ret_block, num) ||
>> +        in_range(ret_block, ext4_inode_table(sb, gdp),
>>               EXT4_SB(sb)->s_itb_per_group) ||
>> -        in_range(ret_block + num - 1, ext4_inode_table(gdp),
>> +        in_range(ret_block + num - 1, ext4_inode_table(sb, gdp),
>>               EXT4_SB(sb)->s_itb_per_group))
>>          ext4_error(sb, "ext4_new_block",
>>                  "Allocating block in system zone - "
>> diff -puN fs/ext4/ialloc.c~ext4_move_block_number_hi_bits=20
>> fs/ext4/ialloc.c
>> --- a/fs/ext4/ialloc.c~ext4_move_block_number_hi_bits
>> +++ a/fs/ext4/ialloc.c
>> @@ -60,12 +60,12 @@ read_inode_bitmap(struct super_block * s
>>      if (!desc)
>>          goto error_out;
>> =20
>> -    bh =3D sb_bread(sb, ext4_inode_bitmap(desc));
>> +    bh =3D sb_bread(sb, ext4_inode_bitmap(sb, desc));
>>      if (!bh)
>>          ext4_error(sb, "read_inode_bitmap",
>>                  "Cannot read inode bitmap - "
>>                  "block_group =3D %lu, inode_bitmap =3D %llu",
>> -                block_group, ext4_inode_bitmap(desc));
>> +                block_group, ext4_inode_bitmap(sb, desc));
>>  error_out:
>>      return bh;
>>  }
>> diff -puN fs/ext4/inode.c~ext4_move_block_number_hi_bits fs/ext4/ino=
de.c
>> --- a/fs/ext4/inode.c~ext4_move_block_number_hi_bits
>> +++ a/fs/ext4/inode.c
>> @@ -2439,9 +2439,8 @@ static ext4_fsblk_t ext4_get_inode_block
>>       */
>>      offset =3D ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
>>          EXT4_INODE_SIZE(sb);
>> -    block =3D ext4_inode_table(gdp) + (offset >>=20
>> EXT4_BLOCK_SIZE_BITS(sb));
>> -
>> -
>> +    block =3D ext4_inode_table(sb, gdp) +
>> +        (offset >> EXT4_BLOCK_SIZE_BITS(sb));
>> =20
>>      iloc->block_group =3D block_group;
>>      iloc->offset =3D offset & (EXT4_BLOCK_SIZE(sb) - 1);
>> @@ -2508,7 +2507,7 @@ static int __ext4_get_inode_loc(struct i
>>                  goto make_io;
>> =20
>>              bitmap_bh =3D sb_getblk(inode->i_sb,
>> -                ext4_inode_bitmap(desc));
>> +                ext4_inode_bitmap(inode->i_sb, desc));
>>              if (!bitmap_bh)
>>                  goto make_io;
>> =20
>> diff -puN fs/ext4/resize.c~ext4_move_block_number_hi_bits=20
>> fs/ext4/resize.c
>> --- a/fs/ext4/resize.c~ext4_move_block_number_hi_bits
>> +++ a/fs/ext4/resize.c
>> @@ -834,9 +834,9 @@ int ext4_group_add(struct super_block *s
>>      /* Update group descriptor block for new group */
>>      gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
>> =20
>> -    ext4_block_bitmap_set(gdp, input->block_bitmap); /* LV FIXME */
>> -    ext4_inode_bitmap_set(gdp, input->inode_bitmap); /* LV FIXME */
>> -    ext4_inode_table_set(gdp, input->inode_table); /* LV FIXME */
>> +    ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXM=
E */
>> +    ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXM=
E */
>> +    ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME =
*/
>>      gdp->bg_free_blocks_count =3D cpu_to_le16(input->free_blocks_co=
unt);
>>      gdp->bg_free_inodes_count =3D cpu_to_le16(EXT4_INODES_PER_GROUP=
(sb));
>> =20
>> diff -puN fs/ext4/super.c~ext4_move_block_number_hi_bits fs/ext4/sup=
er.c
>> --- a/fs/ext4/super.c~ext4_move_block_number_hi_bits
>> +++ a/fs/ext4/super.c
>> @@ -63,40 +63,52 @@ static void ext4_write_super (struct sup
>>  static void ext4_write_super_lockfs(struct super_block *sb);
>> =20
>> =20
>> -ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg)
>> +ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
>> +                   struct ext4_group_desc *bg)
>>  {
>>      return le32_to_cpu(bg->bg_block_bitmap) |
>> -        ((ext4_fsblk_t)le16_to_cpu(bg->bg_block_bitmap_hi) << 32);
>> +        (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT ?
>> +         (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : =
0);
>>  }
>> =20
>> -ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg)
>> +ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
>> +                   struct ext4_group_desc *bg)
>>  {
>>      return le32_to_cpu(bg->bg_inode_bitmap) |
>> -        ((ext4_fsblk_t)le16_to_cpu(bg->bg_inode_bitmap_hi) << 32);
>> +        (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT ?
>> +         (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : =
0);
>>  }
>> =20
>> -ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg)
>> +ext4_fsblk_t ext4_inode_table(struct super_block *sb,
>> +                  struct ext4_group_desc *bg)
>>  {
>>      return le32_to_cpu(bg->bg_inode_table) |
>> -        ((ext4_fsblk_t)le16_to_cpu(bg->bg_inode_table_hi) << 32);
>> +        (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT ?
>> +         (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0=
);
>>  }
>> =20
>> -void ext4_block_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t=
=20
>> blk)
>> +void ext4_block_bitmap_set(struct super_block *sb,
>> +               struct ext4_group_desc *bg, ext4_fsblk_t blk)
>>  {
>>      bg->bg_block_bitmap =3D cpu_to_le32((u32)blk);
>> -    bg->bg_block_bitmap_hi =3D cpu_to_le16(blk >> 32);
>> +    if (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT)
>> +        bg->bg_block_bitmap_hi =3D cpu_to_le32(blk >> 32);
>>  }
>> =20
>> -void ext4_inode_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t=
=20
>> blk)
>> +void ext4_inode_bitmap_set(struct super_block *sb,
>> +               struct ext4_group_desc *bg, ext4_fsblk_t blk)
>>  {
>>      bg->bg_inode_bitmap  =3D cpu_to_le32((u32)blk);
>> -    bg->bg_inode_bitmap_hi =3D cpu_to_le16(blk >> 32);
>> +    if (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT)
>> +        bg->bg_inode_bitmap_hi =3D cpu_to_le32(blk >> 32);
>>  }
>> =20
>> -void ext4_inode_table_set(struct ext4_group_desc *bg, ext4_fsblk_t =
blk)
>> +void ext4_inode_table_set(struct super_block *sb,
>> +              struct ext4_group_desc *bg, ext4_fsblk_t blk)
>>  {
>>      bg->bg_inode_table =3D cpu_to_le32((u32)blk);
>> -    bg->bg_inode_table_hi =3D cpu_to_le16(blk >> 32);
>> +    if (EXT4_DESC_SIZE(sb) >=3D EXT4_MIN_DESC_SIZE_64BIT)
>> +        bg->bg_inode_table_hi =3D cpu_to_le32(blk >> 32);
>>  }
>> =20
>>  /*
>> @@ -1239,7 +1251,7 @@ static int ext4_check_descriptors (struc
>>          if ((i % EXT4_DESC_PER_BLOCK(sb)) =3D=3D 0)
>>              gdp =3D (struct ext4_group_desc *)
>>                      sbi->s_group_desc[desc_block++]->b_data;
>> -        block_bitmap =3D ext4_block_bitmap(gdp);
>> +        block_bitmap =3D ext4_block_bitmap(sb, gdp);
>>          if (block_bitmap < first_block || block_bitmap > last_block=
)
>>          {
>>              ext4_error (sb, "ext4_check_descriptors",
>> @@ -1248,7 +1260,7 @@ static int ext4_check_descriptors (struc
>>                      i, block_bitmap);
>>              return 0;
>>          }
>> -        inode_bitmap =3D ext4_inode_bitmap(gdp);
>> +        inode_bitmap =3D ext4_inode_bitmap(sb, gdp);
>>          if (inode_bitmap < first_block || inode_bitmap > last_block=
)
>>          {
>>              ext4_error (sb, "ext4_check_descriptors",
>> @@ -1257,7 +1269,7 @@ static int ext4_check_descriptors (struc
>>                      i, inode_bitmap);
>>              return 0;
>>          }
>> -        inode_table =3D ext4_inode_table(gdp);
>> +        inode_table =3D ext4_inode_table(sb, gdp);
>>          if (inode_table < first_block ||
>>              inode_table + sbi->s_itb_per_group > last_block)
>>          {
>> @@ -1622,11 +1634,11 @@ static int ext4_fill_super (struct super
>>      }
>>      sbi->s_desc_size =3D le16_to_cpu(es->s_desc_size);
>>      if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_64BIT))=
 {
>> -        if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE ||
>> +        if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
>>              sbi->s_desc_size > EXT4_MAX_DESC_SIZE ||
>>              sbi->s_desc_size & (sbi->s_desc_size - 1)) {
>>              printk(KERN_ERR
>> -                   "EXT4-fs: unsupported descriptor size %ld\n",
>> +                   "EXT4-fs: unsupported descriptor size %lu\n",
>>                     sbi->s_desc_size);
>>              goto failed_mount;
>>          }
>> diff -puN include/linux/ext4_fs.h~ext4_move_block_number_hi_bits=20
>> include/linux/ext4_fs.h
>> --- a/include/linux/ext4_fs.h~ext4_move_block_number_hi_bits
>> +++ a/include/linux/ext4_fs.h
>> @@ -129,10 +129,10 @@ struct ext4_group_desc
>>      __le16    bg_free_inodes_count;    /* Free inodes count */
>>      __le16    bg_used_dirs_count;    /* Directories count */
>>      __u16    bg_flags;
>> -    __le16    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>> -    __le16    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>> -    __le16    bg_inode_table_hi;    /* Inodes table block MSB */
>> -    __u16    bg_reserved[3];
>> +    __u32    bg_reserved[3];
>> +    __le32    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>> +    __le32    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>> +    __le32    bg_inode_table_hi;    /* Inodes table block MSB */
>>  };
>> =20
>>  #ifdef __KERNEL__
>> @@ -143,6 +143,7 @@ struct ext4_group_desc
>>   * Macro-instructions used to manage group descriptors
>>   */
>>  #define EXT4_MIN_DESC_SIZE        32
>> +#define EXT4_MIN_DESC_SIZE_64BIT    64
>>  #define    EXT4_MAX_DESC_SIZE        EXT4_MIN_BLOCK_SIZE
>>  #define EXT4_DESC_SIZE(s)        (EXT4_SB(s)->s_desc_size)
>>  #ifdef __KERNEL__
>> @@ -904,12 +905,18 @@ extern void ext4_abort (struct super_blo
>>  extern void ext4_warning (struct super_block *, const char *, const=
=20
>> char *, ...)
>>      __attribute__ ((format (printf, 3, 4)));
>>  extern void ext4_update_dynamic_rev (struct super_block *sb);
>> -extern ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg);
>> -extern ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg);
>> -extern ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg);
>> -extern void ext4_block_bitmap_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> -extern void ext4_inode_bitmap_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> -extern void ext4_inode_table_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> +extern ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
>> +                      struct ext4_group_desc *bg);
>> +extern ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
>> +                      struct ext4_group_desc *bg);
>> +extern ext4_fsblk_t ext4_inode_table(struct super_block *sb,
>> +                     struct ext4_group_desc *bg);
>> +extern void ext4_block_bitmap_set(struct super_block *sb,
>> +                  struct ext4_group_desc *bg, ext4_fsblk_t blk);
>> +extern void ext4_inode_bitmap_set(struct super_block *sb,
>> +                  struct ext4_group_desc *bg, ext4_fsblk_t blk);
>> +extern void ext4_inode_table_set(struct super_block *sb,
>> +                 struct ext4_group_desc *bg, ext4_fsblk_t blk);
>> =20
>>  static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_bloc=
k=20
>> *es)
>>  {
>> _
>>
>> Patches currently in -mm which might be from=20
>> alexandre.ratchov@bull.net are
>>
>> 64bit-metadata.patch
>> ext4_allow_larger_descriptor_size.patch
>> ext4_move_block_number_hi_bits.patch
>>
>> ----- End forwarded message -----
>> ----- Forwarded message from akpm@osdl.org -----
>>
>> From: akpm@osdl.org
>> Date: Thu, 05 Oct 2006 17:36:41 -0700
>> To: mm-commits@vger.kernel.org
>> Cc: Laurent.Vivier@bull.net, alexandre.ratchov@bull.net,=20
>> shaggy@austin.ibm.com
>> Subject: + 64bit-metadata.patch added to -mm tree
>>
>>
>> The patch titled
>>
>>      ext4: 64bit metadata
>>
>> has been added to the -mm tree.  Its filename is
>>
>>      64bit-metadata.patch
>>
>> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt=20
>> to find
>> out what to do about this
>>
>> ------------------------------------------------------
>> Subject: ext4: 64bit metadata
>> From: Laurent Vivier <Laurent.Vivier@bull.net>
>>
>> In-kernel super block changes to support >32 bit free blocks numbers=
=2E
>>
>> Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
>> Signed-off-by: Dave Kleikamp <shaggy@austin.ibm.com>
>> Signed-off-by: Alexandre Ratchov <alexandre.ratchov@bull.net>
>> Signed-off-by: Andrew Morton <akpm@osdl.org>
>> ---
>>
>>  fs/ext4/balloc.c        |   50 +++++++++----------
>>  fs/ext4/ialloc.c        |    8 +--
>>  fs/ext4/inode.c         |    6 +-
>>  fs/ext4/resize.c        |   52 +++++++++++---------
>>  fs/ext4/super.c         |   96 ++++++++++++++++++++++++++----------=
--
>>  include/linux/ext4_fs.h |   86 ++++++++++++++++++++++++++++------
>>  6 files changed, 201 insertions(+), 97 deletions(-)
>>
>> diff -puN fs/ext4/balloc.c~64bit-metadata fs/ext4/balloc.c
>> --- a/fs/ext4/balloc.c~64bit-metadata
>> +++ a/fs/ext4/balloc.c
>> @@ -99,12 +99,13 @@ read_block_bitmap(struct super_block *sb
>>      desc =3D ext4_get_group_desc (sb, block_group, NULL);
>>      if (!desc)
>>          goto error_out;
>> -    bh =3D sb_bread(sb, le32_to_cpu(desc->bg_block_bitmap));
>> +    bh =3D sb_bread(sb, ext4_block_bitmap(desc));
>>      if (!bh)
>>          ext4_error (sb, "read_block_bitmap",
>>                  "Cannot read block bitmap - "
>> -                "block_group =3D %d, block_bitmap =3D %u",
>> -                block_group, le32_to_cpu(desc->bg_block_bitmap));
>> +                "block_group =3D %d, block_bitmap =3D "E3FSBLK,
>> +                block_group,
>> +                ext4_block_bitmap(desc));
>>  error_out:
>>      return bh;
>>  }
>> @@ -432,14 +433,14 @@ void ext4_free_blocks_sb(handle_t *handl
>>      es =3D sbi->s_es;
>>      if (block < le32_to_cpu(es->s_first_data_block) ||
>>          block + count < block ||
>> -        block + count > le32_to_cpu(es->s_blocks_count)) {
>> +        block + count > ext4_blocks_count(es)) {
>>          ext4_error (sb, "ext4_free_blocks",
>>                  "Freeing blocks not in datazone - "
>>                  "block =3D "E3FSBLK", count =3D %lu", block, count)=
;
>>          goto error_return;
>>      }
>> =20
>> -    ext4_debug ("freeing block(s) %lu-%lu\n", block, block + count =
-=20
>> 1);
>> +    ext4_debug ("freeing block(s) %llu-%llu\n", block, block + coun=
t=20
>> - 1);
>> =20
>>  do_more:
>>      overflow =3D 0;
>> @@ -460,12 +461,11 @@ do_more:
>>      if (!desc)
>>          goto error_return;
>> =20
>> -    if (in_range (le32_to_cpu(desc->bg_block_bitmap), block, count)=
 ||
>> -        in_range (le32_to_cpu(desc->bg_inode_bitmap), block, count)=
 ||
>> -        in_range (block, le32_to_cpu(desc->bg_inode_table),
>> -              sbi->s_itb_per_group) ||
>> -        in_range (block + count - 1, le32_to_cpu(desc->bg_inode_tab=
le),
>> -              sbi->s_itb_per_group))
>> +    if (in_range(ext4_block_bitmap(desc), block, count) ||
>> +        in_range(ext4_inode_bitmap(desc), block, count) ||
>> +        in_range(block, ext4_inode_table(desc),=20
>> sbi->s_itb_per_group) ||
>> +        in_range(block + count - 1, ext4_inode_table(desc),
>> +             sbi->s_itb_per_group))
>>          ext4_error (sb, "ext4_free_blocks",
>>                  "Freeing blocks in system zones - "
>>                  "Block =3D "E3FSBLK", count =3D %lu",
>> @@ -552,8 +552,8 @@ do_more:
>>                          bit + i, bitmap_bh->b_data)) {
>>              jbd_unlock_bh_state(bitmap_bh);
>>              ext4_error(sb, __FUNCTION__,
>> -                "bit already cleared for block "E3FSBLK,
>> -                 block + i);
>> +                   "bit already cleared for block "E3FSBLK,
>> +                   (ext4_fsblk_t)(block + i));
>>              jbd_lock_bh_state(bitmap_bh);
>>              BUFFER_TRACE(bitmap_bh, "bit already cleared");
>>          } else {
>> @@ -1351,7 +1351,7 @@ static int ext4_has_free_blocks(struct e
>>      ext4_fsblk_t free_blocks, root_blocks;
>> =20
>>      free_blocks =3D=20
>> percpu_counter_read_positive(&sbi->s_freeblocks_counter);
>> -    root_blocks =3D le32_to_cpu(sbi->s_es->s_r_blocks_count);
>> +    root_blocks =3D ext4_r_blocks_count(sbi->s_es);
>>      if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE)=
 &&
>>          sbi->s_resuid !=3D current->fsuid &&
>>          (sbi->s_resgid =3D=3D 0 || !in_group_p (sbi->s_resgid))) {
>> @@ -1462,7 +1462,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *h
>>       * First, test whether the goal block is free.
>>       */
>>      if (goal < le32_to_cpu(es->s_first_data_block) ||
>> -        goal >=3D le32_to_cpu(es->s_blocks_count))
>> +        goal >=3D ext4_blocks_count(es))
>>          goal =3D le32_to_cpu(es->s_first_data_block);
>>      ext4_get_group_no_and_offset(sb, goal, &group_no, &grp_target_b=
lk);
>>      goal_group =3D group_no;
>> @@ -1561,12 +1561,12 @@ allocated:
>> =20
>>      ret_block =3D grp_alloc_blk + ext4_group_first_block_no(sb,=20
>> group_no);
>> =20
>> -    if (in_range(le32_to_cpu(gdp->bg_block_bitmap), ret_block, num)=
 ||
>> -        in_range(le32_to_cpu(gdp->bg_inode_bitmap), ret_block, num)=
 ||
>> -        in_range(ret_block, le32_to_cpu(gdp->bg_inode_table),
>> -              EXT4_SB(sb)->s_itb_per_group) ||
>> -        in_range(ret_block + num - 1, le32_to_cpu(gdp->bg_inode_tab=
le),
>> -              EXT4_SB(sb)->s_itb_per_group))
>> +    if (in_range(ext4_block_bitmap(gdp), ret_block, num) ||
>> +        in_range(ext4_block_bitmap(gdp), ret_block, num) ||
>> +        in_range(ret_block, ext4_inode_table(gdp),
>> +             EXT4_SB(sb)->s_itb_per_group) ||
>> +        in_range(ret_block + num - 1, ext4_inode_table(gdp),
>> +             EXT4_SB(sb)->s_itb_per_group))
>>          ext4_error(sb, "ext4_new_block",
>>                  "Allocating block in system zone - "
>>                  "blocks from "E3FSBLK", length %lu",
>> @@ -1604,11 +1604,11 @@ allocated:
>>      jbd_unlock_bh_state(bitmap_bh);
>>  #endif
>> =20
>> -    if (ret_block + num - 1 >=3D le32_to_cpu(es->s_blocks_count)) {
>> +    if (ret_block + num - 1 >=3D ext4_blocks_count(es)) {
>>          ext4_error(sb, "ext4_new_block",
>> -                "block("E3FSBLK") >=3D blocks count(%d) - "
>> +                "block("E3FSBLK") >=3D blocks count("E3FSBLK") - "
>>                  "block_group =3D %lu, es =3D=3D %p ", ret_block,
>> -            le32_to_cpu(es->s_blocks_count), group_no, es);
>> +            ext4_blocks_count(es), group_no, es);
>>          goto out;
>>      }
>> =20
>> @@ -1707,7 +1707,7 @@ ext4_fsblk_t ext4_count_free_blocks(stru
>>      brelse(bitmap_bh);
>>      printk("ext4_count_free_blocks: stored =3D "E3FSBLK
>>          ", computed =3D "E3FSBLK", "E3FSBLK"\n",
>> -           le32_to_cpu(es->s_free_blocks_count),
>> +           EXT4_FREE_BLOCKS_COUNT(es),
>>          desc_count, bitmap_count);
>>      return bitmap_count;
>>  #else
>> diff -puN fs/ext4/ialloc.c~64bit-metadata fs/ext4/ialloc.c
>> --- a/fs/ext4/ialloc.c~64bit-metadata
>> +++ a/fs/ext4/ialloc.c
>> @@ -60,12 +60,12 @@ read_inode_bitmap(struct super_block * s
>>      if (!desc)
>>          goto error_out;
>> =20
>> -    bh =3D sb_bread(sb, le32_to_cpu(desc->bg_inode_bitmap));
>> +    bh =3D sb_bread(sb, ext4_inode_bitmap(desc));
>>      if (!bh)
>>          ext4_error(sb, "read_inode_bitmap",
>>                  "Cannot read inode bitmap - "
>> -                "block_group =3D %lu, inode_bitmap =3D %u",
>> -                block_group, le32_to_cpu(desc->bg_inode_bitmap));
>> +                "block_group =3D %lu, inode_bitmap =3D %llu",
>> +                block_group, ext4_inode_bitmap(desc));
>>  error_out:
>>      return bh;
>>  }
>> @@ -304,7 +304,7 @@ static int find_group_orlov(struct super
>>          goto fallback;
>>      }
>> =20
>> -    blocks_per_dir =3D le32_to_cpu(es->s_blocks_count) - freeb;
>> +    blocks_per_dir =3D ext4_blocks_count(es) - freeb;
>>      sector_div(blocks_per_dir, ndirs);
>> =20
>>      max_dirs =3D ndirs / ngroups + inodes_per_group / 16;
>> diff -puN fs/ext4/inode.c~64bit-metadata fs/ext4/inode.c
>> --- a/fs/ext4/inode.c~64bit-metadata
>> +++ a/fs/ext4/inode.c
>> @@ -2438,8 +2438,8 @@ static ext4_fsblk_t ext4_get_inode_block
>>       */
>>      offset =3D ((ino - 1) % EXT4_INODES_PER_GROUP(sb)) *
>>          EXT4_INODE_SIZE(sb);
>> -    block =3D le32_to_cpu(gdp[desc].bg_inode_table) +
>> -        (offset >> EXT4_BLOCK_SIZE_BITS(sb));
>> +    block =3D ext4_inode_table(gdp + desc) +
>> +            (offset >> EXT4_BLOCK_SIZE_BITS(sb));
>> =20
>>      iloc->block_group =3D block_group;
>>      iloc->offset =3D offset & (EXT4_BLOCK_SIZE(sb) - 1);
>> @@ -2506,7 +2506,7 @@ static int __ext4_get_inode_loc(struct i
>>                  goto make_io;
>> =20
>>              bitmap_bh =3D sb_getblk(inode->i_sb,
>> -                    le32_to_cpu(desc->bg_inode_bitmap));
>> +                ext4_inode_bitmap(desc));
>>              if (!bitmap_bh)
>>                  goto make_io;
>> =20
>> diff -puN fs/ext4/resize.c~64bit-metadata fs/ext4/resize.c
>> --- a/fs/ext4/resize.c~64bit-metadata
>> +++ a/fs/ext4/resize.c
>> @@ -27,7 +27,7 @@ static int verify_group_input(struct sup
>>  {
>>      struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>      struct ext4_super_block *es =3D sbi->s_es;
>> -    ext4_fsblk_t start =3D le32_to_cpu(es->s_blocks_count);
>> +    ext4_fsblk_t start =3D ext4_blocks_count(es);
>>      ext4_fsblk_t end =3D start + input->blocks_count;
>>      unsigned group =3D input->group;
>>      ext4_fsblk_t itend =3D input->inode_table + sbi->s_itb_per_grou=
p;
>> @@ -68,43 +68,43 @@ static int verify_group_input(struct sup
>>                   end - 1);
>>      else if (outside(input->block_bitmap, start, end))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Block bitmap not in group (block %u)",
>> +                 "Block bitmap not in group (block %llu)",
>>                   input->block_bitmap);
>>      else if (outside(input->inode_bitmap, start, end))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Inode bitmap not in group (block %u)",
>> +                 "Inode bitmap not in group (block %llu)",
>>                   input->inode_bitmap);
>>      else if (outside(input->inode_table, start, end) ||
>>               outside(itend - 1, start, end))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Inode table not in group (blocks %u-"E3FSBLK")",
>> +                 "Inode table not in group (blocks %llu-%llu)",
>>                   input->inode_table, itend - 1);
>>      else if (input->inode_bitmap =3D=3D input->block_bitmap)
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Block bitmap same as inode bitmap (%u)",
>> +                 "Block bitmap same as inode bitmap (%llu)",
>>                   input->block_bitmap);
>>      else if (inside(input->block_bitmap, input->inode_table, itend)=
)
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Block bitmap (%u) in inode table (%u-"E3FSBLK")",
>> +                 "Block bitmap (%llu) in inode table (%llu-%llu)",
>>                   input->block_bitmap, input->inode_table, itend-1);
>>      else if (inside(input->inode_bitmap, input->inode_table, itend)=
)
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Inode bitmap (%u) in inode table (%u-"E3FSBLK")",
>> +                 "Inode bitmap (%llu) in inode table (%llu-%llu)",
>>                   input->inode_bitmap, input->inode_table, itend-1);
>>      else if (inside(input->block_bitmap, start, metaend))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Block bitmap (%u) in GDT table"
>> +                 "Block bitmap (%llu) in GDT table"
>>                   " ("E3FSBLK"-"E3FSBLK")",
>>                   input->block_bitmap, start, metaend - 1);
>>      else if (inside(input->inode_bitmap, start, metaend))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Inode bitmap (%u) in GDT table"
>> +                 "Inode bitmap (%llu) in GDT table"
>>                   " ("E3FSBLK"-"E3FSBLK")",
>>                   input->inode_bitmap, start, metaend - 1);
>>      else if (inside(input->inode_table, start, metaend) ||
>>               inside(itend - 1, start, metaend))
>>          ext4_warning(sb, __FUNCTION__,
>> -                 "Inode table (%u-"E3FSBLK") overlaps"
>> +                 "Inode table ("E3FSBLK"-"E3FSBLK") overlaps"
>>                   "GDT table ("E3FSBLK"-"E3FSBLK")",
>>                   input->inode_table, itend - 1, start, metaend - 1)=
;
>>      else
>> @@ -286,6 +286,7 @@ exit_journal:
>>      return err;
>>  }
>> =20
>> +
>>  /*
>>   * Iterate through the groups which hold BACKUP superblock/GDT=20
>> copies in an
>>   * ext4 filesystem.  The counters should be initialized to 1, 5, an=
d=20
>> 7 before
>> @@ -340,12 +341,15 @@ static int verify_reserved_gdb(struct su
>>      int gdbackups =3D 0;
>> =20
>>      while ((grp =3D ext4_list_backups(sb, &three, &five, &seven)) <=
=20
>> end) {
>> -        if (le32_to_cpu(*p++) !=3D grp * EXT4_BLOCKS_PER_GROUP(sb) =
+=20
>> blk){
>> +        if (le32_to_cpu(*p++) !=3D
>> +            grp * EXT4_BLOCKS_PER_GROUP(sb) + blk){
>>              ext4_warning(sb, __FUNCTION__,
>>                       "reserved GDT "E3FSBLK
>>                       " missing grp %d ("E3FSBLK")",
>>                       blk, grp,
>> -                     grp * EXT4_BLOCKS_PER_GROUP(sb) + blk);
>> +                     grp *
>> +                     (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
>> +                     blk);
>>              return -EINVAL;
>>          }
>>          if (++gdbackups > EXT4_ADDR_PER_BLOCK(sb))
>> @@ -731,8 +735,8 @@ int ext4_group_add(struct super_block *s
>>          return -EPERM;
>>      }
>> =20
>> -    if (le32_to_cpu(es->s_blocks_count) + input->blocks_count <
>> -        le32_to_cpu(es->s_blocks_count)) {
>> +    if (ext4_blocks_count(es) + input->blocks_count <
>> +        ext4_blocks_count(es)) {
>>          ext4_warning(sb, __FUNCTION__, "blocks_count overflow\n");
>>          return -EINVAL;
>>      }
>> @@ -830,9 +834,9 @@ int ext4_group_add(struct super_block *s
>>      /* Update group descriptor block for new group */
>>      gdp =3D (struct ext4_group_desc *)primary->b_data + gdb_off;
>> =20
>> -    gdp->bg_block_bitmap =3D cpu_to_le32(input->block_bitmap);
>> -    gdp->bg_inode_bitmap =3D cpu_to_le32(input->inode_bitmap);
>> -    gdp->bg_inode_table =3D cpu_to_le32(input->inode_table);
>> +    ext4_block_bitmap_set(gdp, input->block_bitmap); /* LV FIXME */
>> +    ext4_inode_bitmap_set(gdp, input->inode_bitmap); /* LV FIXME */
>> +    ext4_inode_table_set(gdp, input->inode_table); /* LV FIXME */
>>      gdp->bg_free_blocks_count =3D cpu_to_le16(input->free_blocks_co=
unt);
>>      gdp->bg_free_inodes_count =3D cpu_to_le16(EXT4_INODES_PER_GROUP=
(sb));
>> =20
>> @@ -846,7 +850,7 @@ int ext4_group_add(struct super_block *s
>>       * blocks/inodes before the group is live won't actually let us
>>       * allocate the new space yet.
>>       */
>> -    es->s_blocks_count =3D cpu_to_le32(le32_to_cpu(es->s_blocks_cou=
nt) +
>> +    ext4_blocks_count_set(es, ext4_blocks_count(es) +
>>          input->blocks_count);
>>      es->s_inodes_count =3D cpu_to_le32(le32_to_cpu(es->s_inodes_cou=
nt) +
>>          EXT4_INODES_PER_GROUP(sb));
>> @@ -882,7 +886,7 @@ int ext4_group_add(struct super_block *s
>> =20
>>      /* Update the reserved block counts only once the new group is
>>       * active. */
>> -    es->s_r_blocks_count =3D=20
>> cpu_to_le32(le32_to_cpu(es->s_r_blocks_count) +
>> +    ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
>>          input->reserved_blocks);
>> =20
>>      /* Update the free space counts */
>> @@ -933,7 +937,7 @@ int ext4_group_extend(struct super_block
>>      /* We don't need to worry about locking wrt other resizers just
>>       * yet: we're going to revalidate es->s_blocks_count after
>>       * taking lock_super() below. */
>> -    o_blocks_count =3D le32_to_cpu(es->s_blocks_count);
>> +    o_blocks_count =3D ext4_blocks_count(es);
>>      o_groups_count =3D EXT4_SB(sb)->s_groups_count;
>> =20
>>      if (test_opt(sb, DEBUG))
>> @@ -1004,7 +1008,7 @@ int ext4_group_extend(struct super_block
>>      }
>> =20
>>      lock_super(sb);
>> -    if (o_blocks_count !=3D le32_to_cpu(es->s_blocks_count)) {
>> +    if (o_blocks_count !=3D ext4_blocks_count(es)) {
>>          ext4_warning(sb, __FUNCTION__,
>>                   "multiple resizers run on filesystem!");
>>          unlock_super(sb);
>> @@ -1020,7 +1024,7 @@ int ext4_group_extend(struct super_block
>>          ext4_journal_stop(handle);
>>          goto exit_put;
>>      }
>> -    es->s_blocks_count =3D cpu_to_le32(o_blocks_count + add);
>> +    ext4_blocks_count_set(es, o_blocks_count + add);
>>      ext4_journal_dirty_metadata(handle, EXT4_SB(sb)->s_sbh);
>>      sb->s_dirt =3D 1;
>>      unlock_super(sb);
>> @@ -1032,8 +1036,8 @@ int ext4_group_extend(struct super_block
>>      if ((err =3D ext4_journal_stop(handle)))
>>          goto exit_put;
>>      if (test_opt(sb, DEBUG))
>> -        printk(KERN_DEBUG "EXT4-fs: extended group to %u blocks\n",
>> -               le32_to_cpu(es->s_blocks_count));
>> +        printk(KERN_DEBUG "EXT4-fs: extended group to %llu blocks\n=
",
>> +               ext4_blocks_count(es));
>>      update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
>>                 sizeof(struct ext4_super_block));
>>  exit_put:
>> diff -puN fs/ext4/super.c~64bit-metadata fs/ext4/super.c
>> --- a/fs/ext4/super.c~64bit-metadata
>> +++ a/fs/ext4/super.c
>> @@ -62,6 +62,43 @@ static void ext4_unlockfs(struct super_b
>>  static void ext4_write_super (struct super_block * sb);
>>  static void ext4_write_super_lockfs(struct super_block *sb);
>> =20
>> +
>> +ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg)
>> +{
>> +    return le32_to_cpu(bg->bg_block_bitmap) |
>> +        ((ext4_fsblk_t)le16_to_cpu(bg->bg_block_bitmap_hi) << 32);
>> +}
>> +
>> +ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg)
>> +{
>> +    return le32_to_cpu(bg->bg_inode_bitmap) |
>> +        ((ext4_fsblk_t)le16_to_cpu(bg->bg_inode_bitmap_hi) << 32);
>> +}
>> +
>> +ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg)
>> +{
>> +    return le32_to_cpu(bg->bg_inode_table) |
>> +        ((ext4_fsblk_t)le16_to_cpu(bg->bg_inode_table_hi) << 32);
>> +}
>> +
>> +void ext4_block_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t=
=20
>> blk)
>> +{
>> +    bg->bg_block_bitmap =3D cpu_to_le32((u32)blk);
>> +    bg->bg_block_bitmap_hi =3D cpu_to_le16(blk >> 32);
>> +}
>> +
>> +void ext4_inode_bitmap_set(struct ext4_group_desc *bg, ext4_fsblk_t=
=20
>> blk)
>> +{
>> +    bg->bg_inode_bitmap  =3D cpu_to_le32((u32)blk);
>> +    bg->bg_inode_bitmap_hi =3D cpu_to_le16(blk >> 32);
>> +}
>> +
>> +void ext4_inode_table_set(struct ext4_group_desc *bg, ext4_fsblk_t =
blk)
>> +{
>> +    bg->bg_inode_table =3D cpu_to_le32((u32)blk);
>> +    bg->bg_inode_table_hi =3D cpu_to_le16(blk >> 32);
>> +}
>> +
>>  /*
>>   * Wrappers for jbd2_journal_start/end.
>>   *
>> @@ -1182,6 +1219,9 @@ static int ext4_check_descriptors (struc
>>      struct ext4_sb_info *sbi =3D EXT4_SB(sb);
>>      ext4_fsblk_t first_block =3D=20
>> le32_to_cpu(sbi->s_es->s_first_data_block);
>>      ext4_fsblk_t last_block;
>> +    ext4_fsblk_t block_bitmap;
>> +    ext4_fsblk_t inode_bitmap;
>> +    ext4_fsblk_t inode_table;
>>      struct ext4_group_desc * gdp =3D NULL;
>>      int desc_block =3D 0;
>>      int i;
>> @@ -1191,7 +1231,7 @@ static int ext4_check_descriptors (struc
>>      for (i =3D 0; i < sbi->s_groups_count; i++)
>>      {
>>          if (i =3D=3D sbi->s_groups_count - 1)
>> -            last_block =3D le32_to_cpu(sbi->s_es->s_blocks_count) -=
 1;
>> +            last_block =3D ext4_blocks_count(sbi->s_es) - 1;
>>          else
>>              last_block =3D first_block +
>>                  (EXT4_BLOCKS_PER_GROUP(sb) - 1);
>> @@ -1199,42 +1239,39 @@ static int ext4_check_descriptors (struc
>>          if ((i % EXT4_DESC_PER_BLOCK(sb)) =3D=3D 0)
>>              gdp =3D (struct ext4_group_desc *)
>>                      sbi->s_group_desc[desc_block++]->b_data;
>> -        if (le32_to_cpu(gdp->bg_block_bitmap) < first_block ||
>> -            le32_to_cpu(gdp->bg_block_bitmap) > last_block)
>> +        block_bitmap =3D ext4_block_bitmap(gdp);
>> +        if (block_bitmap < first_block || block_bitmap > last_block=
)
>>          {
>>              ext4_error (sb, "ext4_check_descriptors",
>>                      "Block bitmap for group %d"
>> -                    " not in group (block %lu)!",
>> -                    i, (unsigned long)
>> -                    le32_to_cpu(gdp->bg_block_bitmap));
>> +                    " not in group (block "E3FSBLK")!",
>> +                    i, block_bitmap);
>>              return 0;
>>          }
>> -        if (le32_to_cpu(gdp->bg_inode_bitmap) < first_block ||
>> -            le32_to_cpu(gdp->bg_inode_bitmap) > last_block)
>> +        inode_bitmap =3D ext4_inode_bitmap(gdp);
>> +        if (inode_bitmap < first_block || inode_bitmap > last_block=
)
>>          {
>>              ext4_error (sb, "ext4_check_descriptors",
>>                      "Inode bitmap for group %d"
>> -                    " not in group (block %lu)!",
>> -                    i, (unsigned long)
>> -                    le32_to_cpu(gdp->bg_inode_bitmap));
>> +                    " not in group (block "E3FSBLK")!",
>> +                    i, inode_bitmap);
>>              return 0;
>>          }
>> -        if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
>> -            le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group=
 >
>> -            last_block)
>> +        inode_table =3D ext4_inode_table(gdp);
>> +        if (inode_table < first_block ||
>> +            inode_table + sbi->s_itb_per_group > last_block)
>>          {
>>              ext4_error (sb, "ext4_check_descriptors",
>>                      "Inode table for group %d"
>> -                    " not in group (block %lu)!",
>> -                    i, (unsigned long)
>> -                    le32_to_cpu(gdp->bg_inode_table));
>> +                    " not in group (block "E3FSBLK")!",
>> +                    i, inode_table);
>>              return 0;
>>          }
>>          first_block +=3D EXT4_BLOCKS_PER_GROUP(sb);
>>          gdp++;
>>      }
>> =20
>> -   =20
>> sbi->s_es->s_free_blocks_count=3Dcpu_to_le32(ext4_count_free_blocks(=
sb));
>> +    ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb=
));
>>     =20
>> sbi->s_es->s_free_inodes_count=3Dcpu_to_le32(ext4_count_free_inodes(=
sb));
>>      return 1;
>>  }
>> @@ -1411,6 +1448,7 @@ static int ext4_fill_super (struct super
>>      int i;
>>      int needs_recovery;
>>      __le32 features;
>> +    __u64 blocks_count;
>> =20
>>      sbi =3D kzalloc(sizeof(*sbi), GFP_KERNEL);
>>      if (!sbi)
>> @@ -1620,7 +1658,7 @@ static int ext4_fill_super (struct super
>>          goto failed_mount;
>>      }
>> =20
>> -    if (le32_to_cpu(es->s_blocks_count) >
>> +    if (ext4_blocks_count(es) >
>>              (sector_t)(~0ULL) >> (sb->s_blocksize_bits - 9)) {
>>          printk(KERN_ERR "EXT4-fs: filesystem on %s:"
>>              " too large to mount safely\n", sb->s_id);
>> @@ -1632,9 +1670,11 @@ static int ext4_fill_super (struct super
>> =20
>>      if (EXT4_BLOCKS_PER_GROUP(sb) =3D=3D 0)
>>          goto cantfind_ext4;
>> -    sbi->s_groups_count =3D ((le32_to_cpu(es->s_blocks_count) -
>> -                   le32_to_cpu(es->s_first_data_block) - 1)
>> -                       / EXT4_BLOCKS_PER_GROUP(sb)) + 1;
>> +    blocks_count =3D (ext4_blocks_count(es) -
>> +            le32_to_cpu(es->s_first_data_block) +
>> +            EXT4_BLOCKS_PER_GROUP(sb) - 1);
>> +    do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
>> +    sbi->s_groups_count =3D blocks_count;
>>      db_count =3D (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1=
) /
>>             EXT4_DESC_PER_BLOCK(sb);
>>      sbi->s_group_desc =3D kmalloc(db_count * sizeof (struct=20
>> buffer_head *),
>> @@ -1949,7 +1989,7 @@ static journal_t *ext4_get_dev_journal(s
>>          goto out_bdev;
>>      }
>> =20
>> -    len =3D le32_to_cpu(es->s_blocks_count);
>> +    len =3D ext4_blocks_count(es);
>>      start =3D sb_block + 1;
>>      brelse(bh);    /* we're done with the superblock */
>> =20
>> @@ -2119,7 +2159,7 @@ static void ext4_commit_super (struct su
>>      if (!sbh)
>>          return;
>>      es->s_wtime =3D cpu_to_le32(get_seconds());
>> -    es->s_free_blocks_count =3D cpu_to_le32(ext4_count_free_blocks(=
sb));
>> +    ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
>>      es->s_free_inodes_count =3D cpu_to_le32(ext4_count_free_inodes(=
sb));
>>      BUFFER_TRACE(sbh, "marking dirty");
>>      mark_buffer_dirty(sbh);
>> @@ -2312,7 +2352,7 @@ static int ext4_remount (struct super_bl
>>      ext4_init_journal_params(sb, sbi->s_journal);
>> =20
>>      if ((*flags & MS_RDONLY) !=3D (sb->s_flags & MS_RDONLY) ||
>> -        n_blocks_count > le32_to_cpu(es->s_blocks_count)) {
>> +        n_blocks_count > ext4_blocks_count(es)) {
>>          if (sbi->s_mount_opt & EXT4_MOUNT_ABORT) {
>>              err =3D -EROFS;
>>              goto restore_opts;
>> @@ -2431,10 +2471,10 @@ static int ext4_statfs (struct dentry * =20
>>      buf->f_type =3D EXT4_SUPER_MAGIC;
>>      buf->f_bsize =3D sb->s_blocksize;
>> -    buf->f_blocks =3D le32_to_cpu(es->s_blocks_count) - overhead;
>> +    buf->f_blocks =3D ext4_blocks_count(es) - overhead;
>>      buf->f_bfree =3D percpu_counter_sum(&sbi->s_freeblocks_counter)=
;
>> -    buf->f_bavail =3D buf->f_bfree - le32_to_cpu(es->s_r_blocks_cou=
nt);
>> -    if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
>> +    buf->f_bavail =3D buf->f_bfree - ext4_r_blocks_count(es);
>> +    if (buf->f_bfree < ext4_r_blocks_count(es))
>>          buf->f_bavail =3D 0;
>>      buf->f_files =3D le32_to_cpu(es->s_inodes_count);
>>      buf->f_ffree =3D percpu_counter_sum(&sbi->s_freeinodes_counter)=
;
>> diff -puN include/linux/ext4_fs.h~64bit-metadata include/linux/ext4_=
fs.h
>> --- a/include/linux/ext4_fs.h~64bit-metadata
>> +++ a/include/linux/ext4_fs.h
>> @@ -128,10 +128,17 @@ struct ext4_group_desc
>>      __le16    bg_free_blocks_count;    /* Free blocks count */
>>      __le16    bg_free_inodes_count;    /* Free inodes count */
>>      __le16    bg_used_dirs_count;    /* Directories count */
>> -    __u16    bg_pad;
>> -    __le32    bg_reserved[3];
>> +    __u16    bg_flags;
>> +    __le16    bg_block_bitmap_hi;    /* Blocks bitmap block MSB */
>> +    __le16    bg_inode_bitmap_hi;    /* Inodes bitmap block MSB */
>> +    __le16    bg_inode_table_hi;    /* Inodes table block MSB */
>> +    __u16    bg_reserved[3];
>>  };
>> =20
>> +#ifdef __KERNEL__
>> +#include <linux/ext4_fs_i.h>
>> +#include <linux/ext4_fs_sb.h>
>> +#endif
>>  /*
>>   * Macro-instructions used to manage group descriptors
>>   */
>> @@ -194,9 +201,9 @@ struct ext4_group_desc
>>  /* Used to pass group descriptor data when online resize is done */
>>  struct ext4_new_group_input {
>>      __u32 group;            /* Group number for this data */
>> -    __u32 block_bitmap;     /* Absolute block number of block bitma=
p */
>> -    __u32 inode_bitmap;     /* Absolute block number of inode bitma=
p */
>> -    __u32 inode_table;      /* Absolute block number of inode table=
=20
>> start */
>> +    __u64 block_bitmap;     /* Absolute block number of block bitma=
p */
>> +    __u64 inode_bitmap;     /* Absolute block number of inode bitma=
p */
>> +    __u64 inode_table;      /* Absolute block number of inode table=
=20
>> start */
>>      __u32 blocks_count;     /* Total number of blocks in this group=
 */
>>      __u16 reserved_blocks;  /* Number of reserved blocks in this=20
>> group */
>>      __u16 unused;
>> @@ -205,9 +212,9 @@ struct ext4_new_group_input {
>>  /* The struct ext4_new_group_input in kernel space, with=20
>> free_blocks_count */
>>  struct ext4_new_group_data {
>>      __u32 group;
>> -    __u32 block_bitmap;
>> -    __u32 inode_bitmap;
>> -    __u32 inode_table;
>> +    __u64 block_bitmap;
>> +    __u64 inode_bitmap;
>> +    __u64 inode_table;
>>      __u32 blocks_count;
>>      __u16 reserved_blocks;
>>      __u16 unused;
>> @@ -494,14 +501,18 @@ struct ext4_super_block {
>>      __u8    s_def_hash_version;    /* Default hash version to use *=
/
>>      __u8    s_reserved_char_pad;
>>      __u16    s_reserved_word_pad;
>> -    __le32    s_default_mount_opts;
>> +/*100*/    __le32    s_default_mount_opts;
>>      __le32    s_first_meta_bg;    /* First metablock block group */
>> -    __u32    s_reserved[190];    /* Padding to the end of the block=
 */
>> +    __le32    s_mkfs_time;        /* When the filesystem was create=
d */
>> +    __le32    s_jnl_blocks[17];    /* Backup of the journal inode *=
/
>> +    /* 64bit support valid if EXT4_FEATURE_COMPAT_64BIT */
>> +/*150*/    __le32    s_blocks_count_hi;    /* Blocks count */
>> +    __le32    s_r_blocks_count_hi;    /* Reserved blocks count */
>> +    __le32    s_free_blocks_count_hi;    /* Free blocks count */
>> +    __u32    s_reserved[169];    /* Padding to the end of the block=
 */
>>  };
>> =20
>>  #ifdef __KERNEL__
>> -#include <linux/ext4_fs_i.h>
>> -#include <linux/ext4_fs_sb.h>
>>  static inline struct ext4_sb_info * EXT4_SB(struct super_block *sb)
>>  {
>>      return sb->s_fs_info;
>> @@ -588,12 +599,14 @@ static inline int ext4_valid_inum(struct
>>  #define EXT4_FEATURE_INCOMPAT_JOURNAL_DEV    0x0008 /* Journal=20
>> device */
>>  #define EXT4_FEATURE_INCOMPAT_META_BG        0x0010
>>  #define EXT4_FEATURE_INCOMPAT_EXTENTS        0x0040 /* extents=20
>> support */
>> +#define EXT4_FEATURE_INCOMPAT_64BIT        0x0080
>> =20
>>  #define EXT4_FEATURE_COMPAT_SUPP    EXT2_FEATURE_COMPAT_EXT_ATTR
>>  #define EXT4_FEATURE_INCOMPAT_SUPP   =20
>> (EXT4_FEATURE_INCOMPAT_FILETYPE| \
>>                       EXT4_FEATURE_INCOMPAT_RECOVER| \
>>                       EXT4_FEATURE_INCOMPAT_META_BG| \
>> -                     EXT4_FEATURE_INCOMPAT_EXTENTS)
>> +                     EXT4_FEATURE_INCOMPAT_EXTENTS| \
>> +                     EXT4_FEATURE_INCOMPAT_64BIT)
>>  #define EXT4_FEATURE_RO_COMPAT_SUPP   =20
>> (EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
>>                       EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
>>                       EXT4_FEATURE_RO_COMPAT_BTREE_DIR)
>> @@ -888,6 +901,53 @@ extern void ext4_abort (struct super_blo
>>  extern void ext4_warning (struct super_block *, const char *, const=
=20
>> char *, ...)
>>      __attribute__ ((format (printf, 3, 4)));
>>  extern void ext4_update_dynamic_rev (struct super_block *sb);
>> +extern ext4_fsblk_t ext4_block_bitmap(struct ext4_group_desc *bg);
>> +extern ext4_fsblk_t ext4_inode_bitmap(struct ext4_group_desc *bg);
>> +extern ext4_fsblk_t ext4_inode_table(struct ext4_group_desc *bg);
>> +extern void ext4_block_bitmap_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> +extern void ext4_inode_bitmap_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> +extern void ext4_inode_table_set(struct ext4_group_desc *bg,=20
>> ext4_fsblk_t blk);
>> +
>> +static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_bloc=
k=20
>> *es)
>> +{
>> +    return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32)=
 |
>> +        le32_to_cpu(es->s_blocks_count);
>> +}
>> +
>> +static inline ext4_fsblk_t ext4_r_blocks_count(struct=20
>> ext4_super_block *es)
>> +{
>> +    return ((ext4_fsblk_t)le32_to_cpu(es->s_r_blocks_count_hi) << 3=
2) |
>> +        le32_to_cpu(es->s_r_blocks_count);
>> +}
>> +
>> +static inline ext4_fsblk_t ext4_free_blocks_count(struct=20
>> ext4_super_block *es)
>> +{
>> +    return ((ext4_fsblk_t)le32_to_cpu(es->s_free_blocks_count_hi) <=
<=20
>> 32) |
>> +        le32_to_cpu(es->s_free_blocks_count);
>> +}
>> +
>> +static inline void ext4_blocks_count_set(struct ext4_super_block *e=
s,
>> +                     ext4_fsblk_t blk)
>> +{
>> +    es->s_blocks_count =3D cpu_to_le32((u32)blk);
>> +    es->s_blocks_count_hi =3D cpu_to_le32(blk >> 32);
>> +}
>> +
>> +static inline void ext4_free_blocks_count_set(struct=20
>> ext4_super_block *es,
>> +                          ext4_fsblk_t blk)
>> +{
>> +    es->s_free_blocks_count =3D cpu_to_le32((u32)blk);
>> +    es->s_free_blocks_count_hi =3D cpu_to_le32(blk >> 32);
>> +}
>> +
>> +static inline void ext4_r_blocks_count_set(struct ext4_super_block =
*es,
>> +                       ext4_fsblk_t blk)
>> +{
>> +    es->s_r_blocks_count =3D cpu_to_le32((u32)blk);
>> +    es->s_r_blocks_count_hi =3D cpu_to_le32(blk >> 32);
>> +}
>> +
>> +
>> =20
>>  #define ext4_std_error(sb, errno)                \
>>  do {                                \
>> _
>>
>> Patches currently in -mm which might be from Laurent.Vivier@bull.net=
 are
>>
>> 64bit-metadata.patch
>>
>> ----- End forwarded message -----
>>
>
