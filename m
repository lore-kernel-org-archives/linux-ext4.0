From: yu xing <mdxy2014@gmail.com>
Subject: =?UTF-8?Q?Re=3A_EXT4=EF=BC=9A_About_the_method_of_compute_journal_bloc?=
        =?UTF-8?Q?ks?=
Date: Wed, 18 Jan 2017 13:06:07 +0800
Message-ID: <CAHndWeUE6R=pCF0fh7wZL0ukuhDM0Liga32s7Jsp2Y_e798ohw@mail.gmail.com>
References: <CAHndWeV=wT74J2TBWsxcFF0Ks_u0UYQeD=040+m8CtP2L9d7XQ@mail.gmail.com>
 <20170117171024.lbunxryq5mjlvrvv@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:34417 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdARFGL (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Jan 2017 00:06:11 -0500
Received: by mail-yw0-f196.google.com with SMTP id v73so187450ywg.1
        for <linux-ext4@vger.kernel.org>; Tue, 17 Jan 2017 21:06:08 -0800 (PST)
In-Reply-To: <20170117171024.lbunxryq5mjlvrvv@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks the detail answer from Theodore, I add some comments again , as
following inline answer.

yu.xing

2017-01-18 1:10 GMT+08:00 Theodore Ts'o <tytso@mit.edu>:
> On Tue, Jan 17, 2017 at 11:50:13AM +0800, yu xing wrote:
>>
>>          Currently, I am seeing the the make_ext4fs code of
>> android=EF=BC=8Cthe source code is located at system/extras/ext4_utils
>
> The make_ext4fs code in AOSP is something I've been trying to make go
> away.  It exists because many years ago, the people who were working
> on Android were desperately trying to avoid all GPLv2 code outside of
> the kernel.  So make_ext4fs was a cleanroom rewrite from scratch of
> mke2fs, and so they may have gotten a few things wrong.  As a result
> file systems made with make_ext4fs are not completely identical to
> those made by ext4 (especially when used on the device after a factory
> reset) and this has caused some interesting and hard to debug problems
> in the past.
>
> E2fsprogs is now in AOSP, and I am hoping to make all of the use cases
> of make_ext4fs go away, since it will make everyone's lives much
> easier.  This has actually been a bit tricker since make_ext4fs has
> some additional functionality that never should have been part of
> make_ext4fs, but that is slowly being disentangled (see the very
> latest AOSP git trees).   So tiny steps....
>
     [yu.xing]:
      Do you mean, In future , the mke2fs will instead of the make_ext4fs ?
      if true, maybe some functions from make_ext4fs will add to mke2fs.
      such as pack the system.img from out/target/product/xxxxx/system,
      and add selinux file_contexts into system , as the following command =
list

    make_ext4fs [ -l <len> ] [ -j <journal size> ] [ -b <block_size> ]
    [ -g <blocks per group> ] [ -i <inodes> ] [ -I <inode size> ]
    [ -L <label> ] [ -f ] [ -a <android mountpoint> ] [ -u ]
    [ -S file_contexts ] [ -C fs_config ] [ -T timestamp ]
    [ -z | -s ] [ -w ] [ -c ] [ -J ] [ -v ] [ -B <block_list_file> ]
    <filename> [[<directory>] <target_out_directory>]

     the [<target_out_directory>] arguments is the packing directory
     and the -S arguments is used to include the selinux file_contexts

     but in the mke2fs command, I can not find these functions( the
newest version mk2fs whether or not support these functions,
     if my wrong, please correct me), so maybe add these functions
into mke2fs ?  the mke2fs command list as following:
     Usage: mke2fs [-c|-l filename] [-b block-size] [-C cluster-size]
        [-i bytes-per-inode] [-I inode-size] [-J journal-options]
        [-G flex-group-size] [-N number-of-inodes]
        [-m reserved-blocks-percentage] [-o creator-os]
        [-g blocks-per-group] [-L volume-label] [-M last-mounted-directory]
        [-O feature[,...]] [-r fs-revision] [-E extended-option[,...]]
        [-t fs-type] [-T usage-type ] [-U UUID] [-jnqvDFKSV] device
[blocks-count]

> For this reason, most of the people on this list aren't going to be
> able to answer questions about make_ext4fs, since it's Android
> specific code.  I can answer some of these questions, but only because
> I've been asked to debug some of these hard to understand bugs in
> make_ext4fs (and I really don't want to do that any more, hence the
> work to extirpate make_ext4fs from the AOSP source tree :-).
>
>> I have some question, as following, can somebody help me to explain
>> these questions? Thanks a lot!
>>
>> 1. The method of compute journal blocks, why  divide 64 :
>>
>>           static u32 compute_journal_blocks()
>> {
>>     u32 journal_blocks =3D DIV_ROUND_UP(info.len, info.block_size) / 64;
>>    // is here, why divide 64 ???
>>     if (journal_blocks < 1024)
>>         journal_blocks =3D 1024;
>>     if (journal_blocks > 32768)
>>         journal_blocks =3D 32768;
>>     return journal_blocks;
>> }
>
> This is to compute how many blocks should be allocated for the
> journal.  It's a hueristic, and I suspect the authors of make_ext4fs
> were trying to make the it work more or less like what mke2fs does.
> See ext2fs_default_journal_size() in lib/ext2fs/mkjournal.c in
> e2fsprogs for the original code.  It's a bit better documented, but in
> the end, it's just a hueristic.  The hueristic has changed over the
> years, by the way, for better performance on larger, faster devices.
> So what make_ext4fs does is different from e2fsprogs's current defaults.
>
>> 2. The method of compute jbg_desc_reserve_blocks , why multiply by 1024:
>> static u32 compute_bg_desc_reserve_blocks()
>> {
>>     u32 blocks =3D DIV_ROUND_UP(info.len, info.block_size);
>>     u32 block_groups =3D DIV_ROUND_UP(blocks, info.blocks_per_group);
>>     u32 bg_desc_blocks =3D DIV_ROUND_UP(block_groups * sizeof(struct
>> ext2_group_desc),
>>             info.block_size);
>>
>>     u32 bg_desc_reserve_blocks =3D
>>             DIV_ROUND_UP(block_groups * 1024 * sizeof(struct
>> ext2_group_desc),      // is here , why multiply by 1024 ???
>>                     info.block_size) - bg_desc_blocks;
>>
>>     if (bg_desc_reserve_blocks > info.block_size / sizeof(u32))
>>         bg_desc_reserve_blocks =3D info.block_size / sizeof(u32);
>>
>>     return bg_desc_reserve_blocks;
>> }
>
> These are reserved blocks used so the file system can be on-line
> resized.  It's actually a waste of space since android file systems
> are never resized, but again, cargo cult algorithms from clean room
> reimplementations.  :-)
   [yu.xing]:
   For android file system, resize maybe need:
   for the system.img, it is not required the resize , but for the
userdata.img resizing was needed.
   For example, we build a 512M userdata.img , but when we mount it
to data partition,
   we need to resize it for get the rest of space of the emmc device ,
if not, the data partition size is 512M.
>
>> 3. About compute_inodes function , why divide 4 ??
>> static u32 compute_inodes()
>> {
>>     return DIV_ROUND_UP(info.len, info.block_size) / 4;  // is here
>> why divide 4 ??
>> }
>
> Again, this is a hueristic to figure out roughly how many inodes
> should be reserved given a particular file system size.  The default
> assumes that the average size of files in the file system is 16k, and
> allocates enough inodes so that the file system won't run out of
> inodes given that average file size.
>
> This is adjustable using mke2fs's command line arguments.  See the man
> page for mke2fs for more details.  make_ext4fs was just using a hard
> coded default that can't be adjusted, apparently.
>
> Cheers,
>
>                                         - Ted
