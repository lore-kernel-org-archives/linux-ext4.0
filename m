From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Tue, 22 Jun 2010 17:15:59 +0800
Message-ID: <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
	<20100621170556.GB6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: tytso@mit.edu,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62384 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab0FVJQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 05:16:21 -0400
Received: by vws9 with SMTP id 9so738239vws.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 02:16:20 -0700 (PDT)
In-Reply-To: <20100621170556.GB6843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/6/22 <tytso@mit.edu>
>
> On Mon, Jun 21, 2010 at 09:44:31PM +0800, Hsuan-Ting wrote:
> > Hi Ted,
> >
> > =A0 =A0Resize seems not work when the size is bigger than 16TB (off=
line resize).
> >
> > My test machine:
> > x64 platform 2.6.32 kernel + this newest patch
> >
> > 1. <16TB ext4 enlarge to >16TB (offline)
> > =A0 =A0 a. I use "8 x 2TB WD disks" and "mdadm" build linear raid
> > =A0 =A0 b. then use mkfs.ext4 to make ext4 file system
> > =A0 =A0 c. grow the linear raid to "10 X 2TB"
> > =A0 =A0 d. finally it grow to "2.X TB" smaller than before
>
> This doesn't surprise me. =A0We should add some checks to simply not
> allow the file system growing greater than 16TB if the 64-bit feature
> is not set for now. =A0Making this work is going to be tricky, becaus=
e
> enabling the 64-bit feature doubles the size of the block group
> descriptors, which means we have to make room for them. =A0This could
> involve moving files out of the way, as well as moving the inode
> table.
>
> This means that we may want to enable the 64-bit feature flag if ther=
e
> is an expectation that the filesystem might be grown to a size large
> enough where this would be an issue.

Sounds like I must enable 64-bit feature when mkfs.
Then it will work, right?

But base on my test, it will occur core dump when resize:
(gdb) bt
#0  0x00000000004160bf in ext2fs_test_bit64 ()
#1  0x0000000000416318 in ba_test_bmap ()
#2  0x0000000000410629 in ext2fs_test_generic_bmap ()
#3  0x0000000000410656 in ext2fs_test_block_bitmap_range2 ()
#4  0x000000000040873d in ext2fs_get_free_blocks2 ()
#5  0x000000000040936d in ext2fs_allocate_group_table ()
#6  0x0000000000404456 in adjust_fs_info ()
#7  0x0000000000404a81 in resize_fs ()
#8  0x00000000004069c7 in main ()

I do the following modification
(to enable "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"):

misc/mke2fs.c :
@@ -1530,6 +1945,8 @@ static void PRS(int argc, char *argv[])
                        EXT2_BLOCK_SIZE(&fs_param));
                exit(1);
        }
+       fs_param.s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_64BIT;

        ext2fs_blocks_count_set(&fs_param, fs_blocks_count);


resize/resize2fs.c :
@@ -585,6 +598,9 @@ static errcode_t adjust_superblock(ext2_resize_t
rfs, blk64_t new_size)
        if (retval)
                return retval;

+       fs->super->s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_64BIT;
        retval =3D adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks,=
 new_size);


lib/ext2fs/openfs.c :
@@ -109,6 +109,8 @@ errcode_t ext2fs_open2(const char *name, const
char *io_options,
        memset(fs, 0, sizeof(struct struct_ext2_filsys));
        fs->magic =3D EXT2_ET_MAGIC_EXT2FS_FILSYS;
        fs->flags =3D flags;
+       fs->flags |=3D EXT2_FLAG_64BITS;


Did I mistake something?

>
> > 2. >16TB offline resize, the steps is similiar as before.
> > =A0 =A0a. I use "9 x 2TB WD disks" build linear raid
> > =A0 =A0b. mkfs.ext4 and not mount
> > =A0 =A0c. grow the linear raid to "10 X 2TB"
> > =A0 =A0d. do resize
> > =A0 =A0e. finally it grow to "2.X TB" smaller than before
> >
> > I try to on "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"
> > when mkfs and resize.
> > And modify ext2fs_div_ceil code to ext2fs_div64_ceil.
> > It seems work something, the fs size isn't grow but also not deduce=
,
> > remain the same.
>
> I'm not sure I understand that last sentence; it's not parsing as an
> understandable English sentence, sorry. =A0Are you saying that both
> attempts to grow and shrink the filesystem is failing? =A0If so, how?
> Are you getting an error message? =A0Is it appearing to succeed but t=
he
> file system size isn't changing?

  Sorry for my poor English. The last sentence means "succeed but the
file system size isn't changing".
I also remove "flex_bg" feature in this case.

Thanks.

                                                              -HsuanTin=
g

>
> Thanks for the bug report,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
