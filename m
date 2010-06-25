From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Fri, 25 Jun 2010 18:33:28 +0800
Message-ID: <AANLkTimJVDB4hqCeD2dPBAD8krJScgiBP8-3sBmRaFB1@mail.gmail.com>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
	<20100621170556.GB6843@thunk.org> <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: tytso@mit.edu,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64478 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0FYKdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jun 2010 06:33:49 -0400
Received: by vws9 with SMTP id 9so3719137vws.19
        for <linux-ext4@vger.kernel.org>; Fri, 25 Jun 2010 03:33:48 -0700 (PDT)
In-Reply-To: <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

  I try to :
1. force to enable 64bits feature even the size <16TB
2. fix the "block_bmap" overflow issue when resizing.

It seems OK when resize to >16TB .
(the content of the test file is correct).
But after it grown up, it will get error when do fsck.

My modification is as the following:

lib/ext2fs/openfs.c
@@ -109,6 +109,8 @@ errcode_t ext2fs_open2(const char *name, const
char *io_options,
        memset(fs, 0, sizeof(struct struct_ext2_filsys));
        fs->magic =3D EXT2_ET_MAGIC_EXT2FS_FILSYS;
        fs->flags =3D flags;
+       fs->flags |=3D EXT2_FLAG_64BITS;
        /* don't overwrite sb backups unless flag is explicitly cleared=
 */
        fs->flags |=3D EXT2_FLAG_MASTER_SB_ONLY;
        fs->umask =3D 022;

misc/mke2fs.c
@@ -1530,6 +1531,8 @@ static void PRS(int argc, char *argv[])
                        EXT2_BLOCK_SIZE(&fs_param));
                exit(1);
        }
+       fs_param.s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_64BIT;

        ext2fs_blocks_count_set(&fs_param, fs_blocks_count);


resize/resize2fs.c
index 064c4c4..e28f5f2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -294,7 +294,8 @@ errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsy=
s old_fs,
        blk64_t         overhead =3D 0;
        blk64_t         rem;
        blk64_t         blk, group_block;
-       ext2_ino_t      real_end;
+       __u64           real_end;
        blk64_t         adj, old_numblocks, numblocks, adjblocks;
        unsigned long   i, j, old_desc_blocks, max_group;
        unsigned int    meta_bg, meta_bg_size;
@@ -381,9 +382,9 @@ retry:
                                            fs->inode_map);
        if (retval) goto errout;

-       real_end =3D ((EXT2_BLOCKS_PER_GROUP(fs->super)
-                    * fs->group_desc_count)) - 1 +
-                            fs->super->s_first_data_block;
+       real_end =3D ((__u64)(EXT2_BLOCKS_PER_GROUP(fs->super)
+                    * (__u64)fs->group_desc_count)) - 1ULL +
+                            (__u64)fs->super->s_first_data_block;
        retval =3D ext2fs_resize_block_bitmap2(ext2fs_blocks_count(fs->=
super)-1,
                                            real_end, fs->block_map);

@@ -585,6 +586,8 @@ static errcode_t adjust_superblock(ext2_resize_t
rfs, blk64_t new_size)
        if (retval)
                return retval;

+       fs->super->s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_64BIT;
        retval =3D adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks,=
 new_size);
        if (retval)
                goto errout;

My test case:
1. build a linear raid (1 x 2TB disk)
2. mkfs.ext4, mount it and"echo 123 > test" to
touch a test file.
3.  grown the linear raid to >16TB (9 x 2TB + 1 x 1.5TB)
4. do resize ( resize -fpF /dev/md2 )
After resizing, the content of the test file is correct.

But "fsck -nyv" will get the following error:

e2fsck 1.41.12 (17-May-2010)
###open|=3D EXT2_FLAG_64BITS
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  +(244154882--244187135) +(244187650--2441881=
63)
=46ix? no
/dev/md2: ********** WARNING: Filesystem still has errors **********
      12 inodes used (0.00%)
       0 non-contiguous files (0.0%)
       0 non-contiguous directories (0.0%)
         # of inodes with ind/dind/tind blocks: 0/0/0
         Extent depth histogram: 2
74638645 blocks used (1.57%)
       0 bad blocks
       0 large files
       1 regular file
       2 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
       3 files


I think maybe I should modify "ext2_ino_t" type from
"__u32" to "__u64".
Maybe this modification will fix many overflow issue.

Do you have any idea of this fsck error or any opinions of this approac=
h?

Thanks

                                                                -HsuanT=
ing



2010/6/22 Hsuan-Ting <acht93@cs.ccu.edu.tw>:
> 2010/6/22 <tytso@mit.edu>
>>
>> On Mon, Jun 21, 2010 at 09:44:31PM +0800, Hsuan-Ting wrote:
>> > Hi Ted,
>> >
>> > =A0 =A0Resize seems not work when the size is bigger than 16TB (of=
fline resize).
>> >
>> > My test machine:
>> > x64 platform 2.6.32 kernel + this newest patch
>> >
>> > 1. <16TB ext4 enlarge to >16TB (offline)
>> > =A0 =A0 a. I use "8 x 2TB WD disks" and "mdadm" build linear raid
>> > =A0 =A0 b. then use mkfs.ext4 to make ext4 file system
>> > =A0 =A0 c. grow the linear raid to "10 X 2TB"
>> > =A0 =A0 d. finally it grow to "2.X TB" smaller than before
>>
>> This doesn't surprise me. =A0We should add some checks to simply not
>> allow the file system growing greater than 16TB if the 64-bit featur=
e
>> is not set for now. =A0Making this work is going to be tricky, becau=
se
>> enabling the 64-bit feature doubles the size of the block group
>> descriptors, which means we have to make room for them. =A0This coul=
d
>> involve moving files out of the way, as well as moving the inode
>> table.
>>
>> This means that we may want to enable the 64-bit feature flag if the=
re
>> is an expectation that the filesystem might be grown to a size large
>> enough where this would be an issue.
>
> Sounds like I must enable 64-bit feature when mkfs.
> Then it will work, right?
>
> But base on my test, it will occur core dump when resize:
> (gdb) bt
> #0 =A00x00000000004160bf in ext2fs_test_bit64 ()
> #1 =A00x0000000000416318 in ba_test_bmap ()
> #2 =A00x0000000000410629 in ext2fs_test_generic_bmap ()
> #3 =A00x0000000000410656 in ext2fs_test_block_bitmap_range2 ()
> #4 =A00x000000000040873d in ext2fs_get_free_blocks2 ()
> #5 =A00x000000000040936d in ext2fs_allocate_group_table ()
> #6 =A00x0000000000404456 in adjust_fs_info ()
> #7 =A00x0000000000404a81 in resize_fs ()
> #8 =A00x00000000004069c7 in main ()
>
> I do the following modification
> (to enable "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"):
>
> misc/mke2fs.c :
> @@ -1530,6 +1945,8 @@ static void PRS(int argc, char *argv[])
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_BLOCK_SIZE(&fs_pa=
ram));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 fs_param.s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_=
64BIT;
>
> =A0 =A0 =A0 =A0ext2fs_blocks_count_set(&fs_param, fs_blocks_count);
>
>
> resize/resize2fs.c :
> @@ -585,6 +598,9 @@ static errcode_t adjust_superblock(ext2_resize_t
> rfs, blk64_t new_size)
> =A0 =A0 =A0 =A0if (retval)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return retval;
>
> + =A0 =A0 =A0 fs->super->s_feature_incompat |=3D EXT4_FEATURE_INCOMPA=
T_64BIT;
> =A0 =A0 =A0 =A0retval =3D adjust_fs_info(fs, rfs->old_fs, rfs->reserv=
e_blocks, new_size);
>
>
> lib/ext2fs/openfs.c :
> @@ -109,6 +109,8 @@ errcode_t ext2fs_open2(const char *name, const
> char *io_options,
> =A0 =A0 =A0 =A0memset(fs, 0, sizeof(struct struct_ext2_filsys));
> =A0 =A0 =A0 =A0fs->magic =3D EXT2_ET_MAGIC_EXT2FS_FILSYS;
> =A0 =A0 =A0 =A0fs->flags =3D flags;
> + =A0 =A0 =A0 fs->flags |=3D EXT2_FLAG_64BITS;
>
>
> Did I mistake something?
>
>>
>> > 2. >16TB offline resize, the steps is similiar as before.
>> > =A0 =A0a. I use "9 x 2TB WD disks" build linear raid
>> > =A0 =A0b. mkfs.ext4 and not mount
>> > =A0 =A0c. grow the linear raid to "10 X 2TB"
>> > =A0 =A0d. do resize
>> > =A0 =A0e. finally it grow to "2.X TB" smaller than before
>> >
>> > I try to on "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"
>> > when mkfs and resize.
>> > And modify ext2fs_div_ceil code to ext2fs_div64_ceil.
>> > It seems work something, the fs size isn't grow but also not deduc=
e,
>> > remain the same.
>>
>> I'm not sure I understand that last sentence; it's not parsing as an
>> understandable English sentence, sorry. =A0Are you saying that both
>> attempts to grow and shrink the filesystem is failing? =A0If so, how=
?
>> Are you getting an error message? =A0Is it appearing to succeed but =
the
>> file system size isn't changing?
>
> =A0Sorry for my poor English. The last sentence means "succeed but th=
e
> file system size isn't changing".
> I also remove "flex_bg" feature in this case.
>
> Thanks.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-HsuanTing
>
>>
>> Thanks for the bug report,
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0- Ted
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
