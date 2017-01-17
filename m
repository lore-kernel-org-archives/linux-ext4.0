From: yu xing <mdxy2014@gmail.com>
Subject: =?UTF-8?Q?EXT4=EF=BC=9A_About_the_method_of_compute_journal_blocks?=
Date: Tue, 17 Jan 2017 11:50:13 +0800
Message-ID: <CAHndWeV=wT74J2TBWsxcFF0Ks_u0UYQeD=040+m8CtP2L9d7XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36413 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdAQDuO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jan 2017 22:50:14 -0500
Received: by mail-yw0-f193.google.com with SMTP id l75so10442740ywb.3
        for <linux-ext4@vger.kernel.org>; Mon, 16 Jan 2017 19:50:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello All=EF=BC=8C

         Currently, I am seeing the the make_ext4fs code of
android=EF=BC=8Cthe source code is located at system/extras/ext4_utils

I have some question, as following, can somebody help me to explain
these questions? Thanks a lot!

1. The method of compute journal blocks, why  divide 64 :

          static u32 compute_journal_blocks()
{
    u32 journal_blocks =3D DIV_ROUND_UP(info.len, info.block_size) / 64;
   // is here, why divide 64 ???
    if (journal_blocks < 1024)
        journal_blocks =3D 1024;
    if (journal_blocks > 32768)
        journal_blocks =3D 32768;
    return journal_blocks;
}

2. The method of compute jbg_desc_reserve_blocks , why multiply by 1024:
static u32 compute_bg_desc_reserve_blocks()
{
    u32 blocks =3D DIV_ROUND_UP(info.len, info.block_size);
    u32 block_groups =3D DIV_ROUND_UP(blocks, info.blocks_per_group);
    u32 bg_desc_blocks =3D DIV_ROUND_UP(block_groups * sizeof(struct
ext2_group_desc),
            info.block_size);

    u32 bg_desc_reserve_blocks =3D
            DIV_ROUND_UP(block_groups * 1024 * sizeof(struct
ext2_group_desc),      // is here , why multiply by 1024 ???
                    info.block_size) - bg_desc_blocks;

    if (bg_desc_reserve_blocks > info.block_size / sizeof(u32))
        bg_desc_reserve_blocks =3D info.block_size / sizeof(u32);

    return bg_desc_reserve_blocks;
}

3. About compute_inodes function , why divide 4 ??
static u32 compute_inodes()
{
    return DIV_ROUND_UP(info.len, info.block_size) / 4;  // is here
why divide 4 ??
}


yu.xing
