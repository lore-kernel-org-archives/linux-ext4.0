From: Artem Blagodarenko <artem.blagodarenko@seagate.com>
Subject: Re: [PATCH 1/3] mke2fs: enable large directroy support
Date: Wed, 25 Jan 2017 12:01:45 +0300
Message-ID: <CAO3qy=HqRJGyiwWtYCsvF+TCi=1D4MCzSLu6pThSAQmLcxDRDg@mail.gmail.com>
References: <CAO3qy=F_CxQQ0bUtOm5CZbE0QQ78vyviMStOgg8nryUZZymung@mail.gmail.com>
 <20170124180816.GG14029@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:37579 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751182AbdAYJBs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 25 Jan 2017 04:01:48 -0500
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0P8wQfL035580
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 04:01:48 -0500
Received: from mail-qk0-f198.google.com (mail-qk0-f198.google.com [209.85.220.198])
        by mx0a-00003501.pphosted.com with ESMTP id 286rvcg196-21
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 04:01:47 -0500
Received: by mail-qk0-f198.google.com with SMTP id c69so68130736qkg.1
        for <linux-ext4@vger.kernel.org>; Wed, 25 Jan 2017 01:01:47 -0800 (PST)
In-Reply-To: <20170124180816.GG14029@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Darrick, thank you for inspection.

>Please break this up into separate patches for each of those two changes.
Sure. Coming soon.

>Will a test case be provided to demonstrate that e2fsck can handle
rebuilding a >1 level htree dir?

Just send "[PATCH 3/3] tests: 3 level hash tree test" with test that
rebuild directory to 3 level tree. But it depends from "debugfs:
increase inode reference count after link" I posted some days ago.
Sorry, didn't mentioned it in the email with patch.


Best regards,
Artem Blagodarenko.

On Tue, Jan 24, 2017 at 9:08 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Tue, Jan 24, 2017 at 07:34:13PM +0300, Artem Blagodarenko wrote:
>> The INCOMPAT_LARGEDIR feature allows larger directories to
>> be created, both with directory sizes over 2GB and and a
>> maximum htree depth of 3 instead of the current limit of 2.
>> These features are needed in order to exceed the currently
>> limit of approximately 10M entries in a single directory.
>>
>> debugfs, e2fsck, ext2fs, mke2fs and tune2fs support is
>> added.
>>
>> Signed-off-by: Alexey Lyashkov <alexey.lyashkov@seagate.com>
>> Signed-off-by: Artem Blagodarenko <artem.blagodarenko@seagate.com>
>> ---
>>  debugfs/debugfs.c            |   16 +++++++---------
>>  debugfs/set_fields.c         |    1 -
>>  e2fsck/message.c             |    4 ----
>>  e2fsck/pass1.c               |    5 ++---
>>  e2fsck/pass2.c               |   11 ++---------
>>  e2fsck/problem.c             |    5 -----
>>  e2fsck/problem.h             |    3 ---
>>  lib/ext2fs/ext2_fs.h         |    9 ++++-----
>>  lib/ext2fs/ext2fs.h          |   15 ++++++++++++++-
>>  lib/ext2fs/swapfs.c          |    2 +-
>>  misc/mke2fs.c                |    3 ++-
>>  misc/tune2fs.c               |    3 ++-
>>  tests/d_special_files/expect |   10 +++++-----
>>  tests/f_badcluster/expect    |   14 +++++++-------
>>  tests/f_recnect_bad/expect.1 |    3 ---
>>  15 files changed, 46 insertions(+), 58 deletions(-)
>>
>> diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
>> index b40d9e2..795bdc3 100644
>> --- a/debugfs/debugfs.c
>> +++ b/debugfs/debugfs.c
>> @@ -841,16 +841,15 @@ void internal_dump_inode(FILE *out, const char *pr=
efix,
>>          fprintf(out, "%d\n", inode->i_size);
>>      if (os =3D=3D EXT2_OS_HURD)
>>          fprintf(out,
>> -            "%sFile ACL: %d    Directory ACL: %d Translator: %d\n",
>> +            "%sFile ACL: %d Translator: %d\n",
>>              prefix,
>> -            inode->i_file_acl, LINUX_S_ISDIR(inode->i_mode) ?
>> inode->i_dir_acl : 0,
>> +            inode->i_file_acl,
>>              inode->osd1.hurd1.h_i_translator);
>>      else
>> -        fprintf(out, "%sFile ACL: %llu    Directory ACL: %d\n",
>> +        fprintf(out, "%sFile ACL: %llu\n",
>>              prefix,
>>              inode->i_file_acl | ((long long)
>> -                (inode->osd2.linux2.l_i_file_acl_high) << 32),
>> -            LINUX_S_ISDIR(inode->i_mode) ? inode->i_dir_acl : 0);
>> +                (inode->osd2.linux2.l_i_file_acl_high) << 32));
>>      if (os !=3D EXT2_OS_HURD)
>>          fprintf(out, "%sLinks: %d   Blockcount: %llu\n",
>>              prefix, inode->i_links_count,
>> @@ -1347,10 +1346,9 @@ void do_modify_inode(int argc, char *argv[])
>>      modify_u32(argv[0], "Reserved1", decimal_format, &inode.i_reserved1=
);
>>  #endif
>>      modify_u32(argv[0], "File acl", decimal_format, &inode.i_file_acl);
>> -    if (LINUX_S_ISDIR(inode.i_mode))
>> -        modify_u32(argv[0], "Directory acl", decimal_format, &inode.i_d=
ir_acl);
>> -    else
>> -        modify_u32(argv[0], "High 32bits of size", decimal_format,
>> &inode.i_size_high);
>> +
>> +    modify_u32(argv[0], "High 32bits of size", decimal_format,
>> +           &inode.i_size_high);
>
> Ugh, this patch removes dir_acl /and/ adds support for 3-level htrees!
>
> Please break this up into separate patches for each of those two changes.
>
> "e2fsprogs: supersede i_dir_acl with i_size_high for all cases"
> "e2fsprogs: add support for 3-level htree"
>
>>
>>      if (os =3D=3D EXT2_OS_HURD)
>>          modify_u32(argv[0], "Translator Block",
>> diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
>> index ff9b7b6..ca68862 100644
>> --- a/debugfs/set_fields.c
>> +++ b/debugfs/set_fields.c
>> @@ -212,7 +212,6 @@ static struct field_set_info inode_fields[] =3D {
>>      /* Special case: i_file_acl_high is 2 bytes */
>>      { "file_acl", &set_inode.i_file_acl,
>>          &set_inode.osd2.linux2.l_i_file_acl_high, 6, parse_uint },
>> -    { "dir_acl", &set_inode.i_dir_acl, NULL, 4, parse_uint, FLAG_ALIAS =
},
>>      { "faddr", &set_inode.i_faddr, NULL, 4, parse_uint },
>>      { "frag", &set_inode.osd2.hurd2.h_i_frag, NULL, 1, parse_uint,
>> FLAG_ALIAS },
>>      { "fsize", &set_inode.osd2.hurd2.h_i_fsize, NULL, 1, parse_uint },
>> diff --git a/e2fsck/message.c b/e2fsck/message.c
>> index 1c3fcd8..d21ba05 100644
>> --- a/e2fsck/message.c
>> +++ b/e2fsck/message.c
>> @@ -318,10 +318,6 @@ static _INLINE_ void expand_inode_expression(FILE
>> *f, ext2_filsys fs, char ch,
>>      case 'f':
>>          fprintf(f, "%llu", ext2fs_file_acl_block(fs, inode));
>>          break;
>> -    case 'd':
>> -        fprintf(f, "%u", (LINUX_S_ISDIR(inode->i_mode) ?
>> -                  inode->i_dir_acl : 0));
>> -        break;
>>      case 'u':
>>          fprintf(f, "%d", inode_uid(*inode));
>>          break;
>> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
>> index 8ef40f6..8444b37 100644
>> --- a/e2fsck/pass1.c
>> +++ b/e2fsck/pass1.c
>> @@ -1715,8 +1715,7 @@ void e2fsck_pass1(e2fsck_t ctx)
>>              frag =3D fsize =3D 0;
>>          }
>>
>> -        if (inode->i_faddr || frag || fsize ||
>> -            (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
>> +        if (inode->i_faddr || frag || fsize)
>>              mark_inode_bad(ctx, ino);
>>          if ((fs->super->s_creator_os !=3D EXT2_OS_HURD) &&
>>              !ext2fs_has_feature_64bit(fs->super) &&
>> @@ -2469,7 +2468,7 @@ static int handle_htree(e2fsck_t ctx, struct
>> problem_context *pctx,
>>          return 1;
>>
>>      pctx->num =3D root->indirect_levels;
>> -    if ((root->indirect_levels > 1) &&
>> +    if ((root->indirect_levels > ext2_dir_htree_level(fs)) &&
>>          fix_problem(ctx, PR_1_HTREE_DEPTH, pctx))
>>          return 1;
>>
>> diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
>> index 11c19e8..7ded7bb 100644
>> --- a/e2fsck/pass2.c
>> +++ b/e2fsck/pass2.c
>> @@ -1058,7 +1058,8 @@ inline_read_fail:
>>              dx_db->flags |=3D DX_FLAG_FIRST | DX_FLAG_LAST;
>>              if ((root->reserved_zero ||
>>                   root->info_length < 8 ||
>> -                 root->indirect_levels > 1) &&
>> +                 root->indirect_levels
>> +                > ext2_dir_htree_level(fs)) &&
>>                  fix_problem(ctx, PR_2_HTREE_BAD_ROOT, &cd->pctx)) {
>>                  clear_htree(ctx, ino);
>>                  dx_dir->numblocks =3D 0;
>> @@ -1811,14 +1812,6 @@ int e2fsck_process_bad_inode(e2fsck_t ctx,
>> ext2_ino_t dir,
>>          } else
>>              not_fixed++;
>>      }
>> -    if (inode.i_dir_acl &&
>> -        LINUX_S_ISDIR(inode.i_mode)) {
>> -        if (fix_problem(ctx, PR_2_DIR_ACL_ZERO, &pctx)) {
>> -            inode.i_dir_acl =3D 0;
>> -            inode_modified++;
>> -        } else
>> -            not_fixed++;
>> -    }
>>
>>      if (inode_modified)
>>          e2fsck_write_inode(ctx, ino, &inode, "process_bad_inode");
>> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
>> index 34a671e..ce2f79d 100644
>> --- a/e2fsck/problem.c
>> +++ b/e2fsck/problem.c
>> @@ -1360,11 +1360,6 @@ static struct e2fsck_problem problem_table[] =3D =
{
>>        N_("i_file_acl @F %If, @s zero.\n"),
>>        PROMPT_CLEAR, 0 },
>>
>> -    /* i_dir_acl should be zero */
>> -    { PR_2_DIR_ACL_ZERO,
>> -      N_("i_dir_acl @F %Id, @s zero.\n"),
>> -      PROMPT_CLEAR, 0 },
>> -
>>      /* i_frag should be zero */
>>      { PR_2_FRAG_ZERO,
>>        N_("i_frag @F %N, @s zero.\n"),
>> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
>> index 86cb614..f07f9b6 100644
>> --- a/e2fsck/problem.h
>> +++ b/e2fsck/problem.h
>> @@ -808,9 +808,6 @@ struct problem_context {
>>  /* i_file_acl should be zero */
>>  #define PR_2_FILE_ACL_ZERO    0x02000E
>>
>> -/* i_dir_acl should be zero */
>> -#define PR_2_DIR_ACL_ZERO    0x02000F
>> -
>>  /* i_frag should be zero */
>>  #define PR_2_FRAG_ZERO        0x020010
>>
>> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
>> index 27a7d3a..6d9a5d0 100644
>> --- a/lib/ext2fs/ext2_fs.h
>> +++ b/lib/ext2fs/ext2_fs.h
>> @@ -398,7 +398,7 @@ struct ext2_inode {
>>      __u32    i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
>>      __u32    i_generation;    /* File version (for NFS) */
>>      __u32    i_file_acl;    /* File ACL */
>> -    __u32    i_size_high;    /* Formerly i_dir_acl, directory ACL */
>> +    __u32    i_size_high;
>>      __u32    i_faddr;    /* Fragment address */
>>      union {
>>          struct {
>> @@ -446,7 +446,7 @@ struct ext2_inode_large {
>>      __u32    i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
>>      __u32    i_generation;    /* File version (for NFS) */
>>      __u32    i_file_acl;    /* File ACL */
>> -    __u32    i_size_high;    /* Formerly i_dir_acl, directory ACL */
>> +    __u32    i_size_high;
>>      __u32    i_faddr;    /* Fragment address */
>>      union {
>>          struct {
>> @@ -484,8 +484,6 @@ struct ext2_inode_large {
>>  #define EXT4_EPOCH_BITS 2
>>  #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
>>
>> -#define i_dir_acl    i_size_high
>> -
>>  #define i_checksum_lo    osd2.linux2.l_i_checksum_lo
>>
>>  #define inode_includes(size, field)            \
>> @@ -923,7 +921,8 @@ EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,        4, ENCRY=
PT)
>>
>>  #define EXT2_FEATURE_COMPAT_SUPP    0
>>  #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| =
\
>> -                       EXT4_FEATURE_INCOMPAT_MMP)
>> +                       EXT4_FEATURE_INCOMPAT_MMP|\
>> +                       EXT4_FEATURE_INCOMPAT_LARGEDIR)
>>  #define EXT2_FEATURE_RO_COMPAT_SUPP    (EXT2_FEATURE_RO_COMPAT_SPARSE_S=
UPER| \
>>                       EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
>>                       EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
>> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
>> index 786ded8..5e956d0 100644
>> --- a/lib/ext2fs/ext2fs.h
>> +++ b/lib/ext2fs/ext2fs.h
>> @@ -588,7 +588,8 @@ typedef struct ext2_icount *ext2_icount_t;
>>                       EXT4_FEATURE_INCOMPAT_64BIT|\
>>                       EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
>>                       EXT4_FEATURE_INCOMPAT_ENCRYPT|\
>> -                     EXT4_FEATURE_INCOMPAT_CSUM_SEED)
>> +                     EXT4_FEATURE_INCOMPAT_CSUM_SEED|\
>> +                     EXT4_FEATURE_INCOMPAT_LARGEDIR)
>>
>>  #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP
>> (EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
>>                       EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
>> @@ -1924,6 +1925,18 @@ _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_fils=
ys fs,
>>      return (blk_t) ext2fs_inode_data_blocks2(fs, inode);
>>  }
>>
>> +/* htree levels for ext4 */
>> +#define EXT4_HTREE_LEVEL_COMPAT 1
>> +#define EXT4_HTREE_LEVEL    3
>
> Three levels...
>
> 1k: 126^3 * 123 =3D ~246 million blocks
> 4k: 510^3 * 507 =3D ~67.3 billion dirent blocks.
> 64k: 8190^3 * 8187 =3D ~4.5 quadrillion dirent blocks
>
> I was about to wonder why not permit enough levels to fill out a full
> 2^63 byte directory, but then considered that three is probably enough.
>
> (Also I wasn't sure if ext4 still loads the whole dir into kernel memory.=
..)
>
>> +
>> +_INLINE_ unsigned int ext2_dir_htree_level(ext2_filsys fs)
>> +{
>> +        if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
>> +                          EXT4_FEATURE_INCOMPAT_LARGEDIR))
>
> if (ext2fs_has_feature_largedir(...))
>
>> +                    return EXT4_HTREE_LEVEL;
>> +            return EXT4_HTREE_LEVEL_COMPAT;
>> +}
>> +
>>  /*
>>   * This is an efficient, overflow safe way of calculating ceil((1.0 * a=
) / b)
>>   */
>> diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
>> index d63fc55..2d05ee7 100644
>> --- a/lib/ext2fs/swapfs.c
>> +++ b/lib/ext2fs/swapfs.c
>> @@ -247,7 +247,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct
>> ext2_inode_large *t,
>>          has_extents =3D 1;
>>      if (!hostorder && (t->i_flags & EXT4_INLINE_DATA_FL))
>>          has_inline_data =3D 1;
>> -    t->i_dir_acl =3D ext2fs_swab32(f->i_dir_acl);
>> +    t->i_size_high =3D ext2fs_swab32(f->i_size_high);
>>      /*
>>       * Extent data and inline data are swapped on access, not here
>>       */
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 9f18c83..b2bf461 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -1081,7 +1081,8 @@ static __u32 ok_features[3] =3D {
>>          EXT4_FEATURE_INCOMPAT_64BIT|
>>          EXT4_FEATURE_INCOMPAT_INLINE_DATA|
>>          EXT4_FEATURE_INCOMPAT_ENCRYPT |
>> -        EXT4_FEATURE_INCOMPAT_CSUM_SEED,
>> +        EXT4_FEATURE_INCOMPAT_CSUM_SEED |
>> +        EXT4_FEATURE_INCOMPAT_LARGEDIR,
>>      /* R/O compat */
>>      EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
>>          EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>> index 6239577..f78d105 100644
>> --- a/misc/tune2fs.c
>> +++ b/misc/tune2fs.c
>> @@ -156,7 +156,8 @@ static __u32 ok_features[3] =3D {
>>          EXT4_FEATURE_INCOMPAT_MMP |
>>          EXT4_FEATURE_INCOMPAT_64BIT |
>>          EXT4_FEATURE_INCOMPAT_ENCRYPT |
>> -        EXT4_FEATURE_INCOMPAT_CSUM_SEED,
>> +        EXT4_FEATURE_INCOMPAT_CSUM_SEED |
>> +        EXT4_FEATURE_INCOMPAT_LARGEDIR,
>>      /* R/O compat */
>>      EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
>>          EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
>> diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
>> index f729b0f..c825932 100644
>> --- a/tests/d_special_files/expect
>> +++ b/tests/d_special_files/expect
>> @@ -5,7 +5,7 @@ debugfs -R ''stat foo'' -w test.img
>>  Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
>>  Generation: 0    Version: 0x00000000
>>  User:     0   Group:     0   Size: 3
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 0
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
>> @@ -17,7 +17,7 @@ debugfs -R ''stat foo2'' -w test.img
>>  Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
>>  Generation: 0    Version: 0x00000000
>>  User:     0   Group:     0   Size: 80
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 2
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
>> @@ -42,7 +42,7 @@ debugfs -R ''stat pipe'' -w test.img
>>  Inode: 14   Type: FIFO    Mode:  0000   Flags: 0x0
>>  Generation: 0    Version: 0x00000000
>>  User:     0   Group:     0   Size: 0
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 0
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
>> @@ -55,7 +55,7 @@ debugfs -R ''stat sda'' -w test.img
>>  Inode: 15   Type: block special    Mode:  0000   Flags: 0x0
>>  Generation: 0    Version: 0x00000000
>>  User:     0   Group:     0   Size: 0
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 0
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
>> @@ -67,7 +67,7 @@ debugfs -R ''stat null'' -w test.img
>>  Inode: 16   Type: character special    Mode:  0000   Flags: 0x0
>>  Generation: 0    Version: 0x00000000
>>  User:     0   Group:     0   Size: 0
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 0
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
>> diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
>> index 65a1641..75a3820 100644
>> --- a/tests/f_badcluster/expect
>> +++ b/tests/f_badcluster/expect
>> @@ -116,7 +116,7 @@ debugfs: stat /a
>>  Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152157    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -128,7 +128,7 @@ debugfs: stat /b
>>  Inode: 13   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152158    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -140,7 +140,7 @@ debugfs: stat /c
>>  Inode: 14   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152159    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -152,7 +152,7 @@ debugfs: stat /d
>>  Inode: 15   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152160    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 0
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -163,7 +163,7 @@ debugfs: stat /e
>>  Inode: 16   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152161    Version: 0x00000001
>>  User:     0   Group:     0   Size: 6144
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -175,7 +175,7 @@ debugfs: stat /f
>>  Inode: 17   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152162    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> @@ -187,7 +187,7 @@ debugfs: stat /g
>>  Inode: 18   Type: regular    Mode:  0644   Flags: 0x80000
>>  Generation: 1117152163    Version: 0x00000001
>>  User:     0   Group:     0   Size: 3072
>> -File ACL: 0    Directory ACL: 0
>> +File ACL: 0
>>  Links: 1   Blockcount: 32
>>  Fragment:  Address: 0    Number: 0    Size: 0
>>  ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
>> diff --git a/tests/f_recnect_bad/expect.1 b/tests/f_recnect_bad/expect.1
>> index 8ba81e6..6433c8d 100644
>> --- a/tests/f_recnect_bad/expect.1
>> +++ b/tests/f_recnect_bad/expect.1
>> @@ -3,9 +3,6 @@ Pass 2: Checking directory structure
>>  i_faddr for inode 15 (/test/quux) is 23, should be zero.
>>  Clear? yes
>>
>> -i_dir_acl for inode 15 (/test/quux) is 12, should be zero.
>> -Clear? yes
>> -
>>  i_file_acl for inode 13 (/test/???) is 12, should be zero.
>>  Clear? yes
>
> Will a test case be provided to demonstrate that e2fsck can handle
> rebuilding a >1 level htree dir?
>
> --D
>>
>> --



--=20
Artem Blagodarenko Ph.D.=C2=B7 SW Developer on my.seagate.com
Seagate Technology, LLC
www.seagate.com
