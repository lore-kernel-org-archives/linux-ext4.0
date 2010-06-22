From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Tue, 22 Jun 2010 10:17:49 -0600
Message-ID: <2B02F50E-2878-48D4-835F-B6C57C4DC34E@dilger.ca>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com> <20100621170556.GB6843@thunk.org> <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: tytso@mit.edu,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:62346 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0FVQRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 12:17:52 -0400
In-Reply-To: <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-06-22, at 03:15, Hsuan-Ting wrote:
2010/6/22 <tytso@mit.edu>
>> This means that we may want to enable the 64-bit feature flag if there
>> is an expectation that the filesystem might be grown to a size large
>> enough where this would be an issue.
> 
> Sounds like I must enable 64-bit feature when mkfs.
> Then it will work, right?
> 
> But base on my test, it will occur core dump when resize:
> (gdb) bt
> #0  0x00000000004160bf in ext2fs_test_bit64 ()
> #1  0x0000000000416318 in ba_test_bmap ()
> #2  0x0000000000410629 in ext2fs_test_generic_bmap ()
> #3  0x0000000000410656 in ext2fs_test_block_bitmap_range2 ()
> #4  0x000000000040873d in ext2fs_get_free_blocks2 ()
> #5  0x000000000040936d in ext2fs_allocate_group_table ()
> #6  0x0000000000404456 in adjust_fs_info ()
> #7  0x0000000000404a81 in resize_fs ()
> #8  0x00000000004069c7 in main ()
> 
> I do the following modification
> (to enable "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"):
> 
> misc/mke2fs.c :
> @@ -1530,6 +1945,8 @@ static void PRS(int argc, char *argv[])
>                        EXT2_BLOCK_SIZE(&fs_param));
>                exit(1);
>        }
> +       fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;


You don't need to modify mke2fs for this, just run "mke2fs -O 64bit ..." to tell it to create the filesystem with this feature flag set.

> resize/resize2fs.c :
> @@ -585,6 +598,9 @@ static errcode_t adjust_superblock(ext2_resize_t
> rfs, blk64_t new_size)
> +       fs->super->s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
>        retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size);

You can't simply set this flag on an existing filesystem and expect anything except corruption to result.

> lib/ext2fs/openfs.c :
> @@ -109,6 +109,8 @@ errcode_t ext2fs_open2(const char *name, const
> char *io_options,
>        memset(fs, 0, sizeof(struct struct_ext2_filsys));
>        fs->magic = EXT2_ET_MAGIC_EXT2FS_FILSYS;
>        fs->flags = flags;
> +       fs->flags |= EXT2_FLAG_64BITS;
> 
> Did I mistake something?

Yes, that you can't just set this flag on an existing filesystem and expect it to work.  The only possibility to do this is to have resize2fs move the inode tables in groups where there are group descriptor tables (as if it were growing the filesystem) and then write 64-byte group descriptors.

Cheers, Andreas





