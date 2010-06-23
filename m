From: Hsuan-Ting <acht93@cs.ccu.edu.tw>
Subject: Re: E2fsprogs master branch now has all 64-bit patch applied
Date: Wed, 23 Jun 2010 16:42:29 +0800
Message-ID: <AANLkTinjWSRx43xWHWv9WtaxotihDHvokI977zg5bT6l@mail.gmail.com>
References: <AANLkTilD3D2QOXi1b7oXT2uFBx_vuO803HOX4JJXfWG0@mail.gmail.com>
	<20100621170556.GB6843@thunk.org> <AANLkTimN1pMUlpoVbQe1ueL_LiorWqPNgpEfRBNrbEp0@mail.gmail.com>
	<2B02F50E-2878-48D4-835F-B6C57C4DC34E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Andreas Dilger <adilger@dilger.ca>, tytso@mit.edu,
	"development\"" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53068 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab0FWImv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jun 2010 04:42:51 -0400
Received: by vws9 with SMTP id 9so650831vws.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jun 2010 01:42:50 -0700 (PDT)
In-Reply-To: <2B02F50E-2878-48D4-835F-B6C57C4DC34E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/6/23 Andreas Dilger <adilger@dilger.ca>:
> On 2010-06-22, at 03:15, Hsuan-Ting wrote:
> 2010/6/22 <tytso@mit.edu>
>>> This means that we may want to enable the 64-bit feature flag if th=
ere
>>> is an expectation that the filesystem might be grown to a size larg=
e
>>> enough where this would be an issue.
>>
>> Sounds like I must enable 64-bit feature when mkfs.
>> Then it will work, right?
>>
>> But base on my test, it will occur core dump when resize:
>> (gdb) bt
>> #0 =A00x00000000004160bf in ext2fs_test_bit64 ()
>> #1 =A00x0000000000416318 in ba_test_bmap ()
>> #2 =A00x0000000000410629 in ext2fs_test_generic_bmap ()
>> #3 =A00x0000000000410656 in ext2fs_test_block_bitmap_range2 ()
>> #4 =A00x000000000040873d in ext2fs_get_free_blocks2 ()
>> #5 =A00x000000000040936d in ext2fs_allocate_group_table ()
>> #6 =A00x0000000000404456 in adjust_fs_info ()
>> #7 =A00x0000000000404a81 in resize_fs ()
>> #8 =A00x00000000004069c7 in main ()
>>
>> I do the following modification
>> (to enable "EXT4_FEATURE_INCOMPAT_64BIT" and "EXT2_FLAG_64BITS"):
>>
>> misc/mke2fs.c :
>> @@ -1530,6 +1945,8 @@ static void PRS(int argc, char *argv[])
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT2_BLOCK_SIZE(&fs_p=
aram));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0exit(1);
>> =A0 =A0 =A0 =A0}
>> + =A0 =A0 =A0 fs_param.s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT=
_64BIT;
>
>
> You don't need to modify mke2fs for this, just run "mke2fs -O 64bit .=
=2E." to tell it to create the filesystem with this feature flag set.

Hi Andreas ,

If the size is not big enough, "-O 64bit" will get the following error =
messages:
"/dev/sda3: Cannot create filesystem with requested number of inodes
while setting up superblock"

And base on my trace, I think "-O 64bit" won't always work.
It will check the blocks count  as the following code in mke2fs.c:
    if ((fs_blocks_count > MAX_32_NUM) &&
        !(fs_param.s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) &&
        get_bool_from_profile(fs_types, "auto_64-bit_support", 0)) {
        fs_param.s_feature_incompat |=3D EXT4_FEATURE_INCOMPAT_64BIT;
        fs_param.s_feature_compat &=3D ~EXT2_FEATURE_COMPAT_RESIZE_INOD=
E;
    }
So I do the above modification to force 64bit feature enabling.

I also find some strange things when mkfs:
If the size(ex. 91.3G) isn't big enough it will use "floppy" settings
in mke2fs.conf instead of "ext4".

I do the following steps, it seems work but still has core dump message=
s:
1. remove "resize_inode" and "flex_bg" features ,and let "floppy"
settings the same as "ext4" in mke2fs.conf
2. build linera raid with a small partition of 1 disks (91.3G)
3. mkfs.ext4 to this raid
5. grow this linear raid (91.3G + 9 x 2TB disks)
6. do resize2fs
6. get the following core dump:
[458783.472100] resize2fs[27376]: segfault at 7fa420f14000 ip
0000000000416055 sp 00007fff533a99e8 error 4 in
resize2fs[400000+1e000]
Segmentation fault (core dumped)
(gdb) bt
#0  0x000000000041606f in ext2fs_test_bit64 ()
Cannot access memory at address 0x7fff2be12328
8. but the fs size have grown (16.3T)

So I think if the 64bit feature is enabled when mkfs, it will reserve
more room in file system
And we can grow it up bigger than 16TB.
It seems there are some issues in "master" still, I'll try "pu" branch =
later.

Thanks.

                                       -HsuanTing
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
