Return-Path: <SRS0=ONaI=RT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAE4C43381
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 09:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9726C218FC
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 09:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfCPJK3 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sat, 16 Mar 2019 05:10:29 -0400
Received: from mail.worldserver.net ([217.13.200.37]:57667 "EHLO
        mail.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfCPJK3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Mar 2019 05:10:29 -0400
Received: from mail.nebelschwaden.de (port-92-193-18-13.dynamic.qsc.de [92.193.18.13])
        (Authenticated sender: postmaster@nebelschwaden.de)
        by mail.worldserver.net (Postfix) with ESMTPSA id 64A77300579
        for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2019 10:10:27 +0100 (CET)
Received: from [172.16.37.5] (kaperfahrt.nebelschwaden.de [172.16.37.5])
        by mail.nebelschwaden.de (Postfix) with ESMTP id AEB1E500C5B
        for <linux-ext4@vger.kernel.org>; Sat, 16 Mar 2019 10:10:26 +0100 (CET)
Reply-To: listac@nebelschwaden.de
Subject: Re: e2fsck fails on non journalled partition
To:     linux-ext4@vger.kernel.org
References: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
 <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
From:   Ede Wolf <listac@nebelschwaden.de>
Message-ID: <c2be64f5-d0fc-f66b-36ab-ab601301cbed@nebelschwaden.de>
Date:   Sat, 16 Mar 2019 10:10:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Thanks very, very much. That "ssv" did the trick!

Learned something new and the next beer of course is on you.

Ede

Am 16.03.19 um 03:57 schrieb Andreas Dilger:
> It looks like you have some superblock corruption, since the journal UUID is non-zero, and the journal inode is also non-zero. You can probably use debugfs "ssv" command to clear these fields so that e2fsck doesn't think there is a journal somewhere.
> 
> Cheers, Andreas
> 
>> On Mar 15, 2019, at 13:28, Ede Wolf <listac@nebelschwaden.de> wrote:
>>
>> I have to check an ext4 partition, that has been created without a journal. But, as it seems, e2fsck is refusing to check this drive, failing with a "no external journal has been found" error, code 12. That of course is correct, no journal does imply no external journal.
>>
>> I am wondering, ^has_journal is well documented in both the mkfs.ext4 manpage as well as tune2fs. So by omitting the journal nothing obscure, hacky or obviously unsupported has been done.
>>
>> Why is e2fsck refusing to check the partition? Or what else may I have be doing wrong?
>>
>>
>> ~ # e2fsck -fv /dev/sde1
>> e2fsck 1.44.5 (15-Dec-2018)
>> Can't find external journal
>>
>> USERDATA: ********** WARNING: Filesystem still has errors **********
>>
>> ~ # echo $?
>> 12
>> ~ #
>>
>> Filesystem has been created similar to this:
>>
>> mkfs -m 0 -O "^has_journal,dir_index,^metadata_csum,64bit,^ext_attr,^huge_file,large_dir,^metadata_csum_seed,^quota,extent" -b 4096 -i 32768 -L USERDATA
>>
>>
>>
>> ~ # tune2fs -l /dev/sde1
>> tune2fs 1.44.5 (15-Dec-2018)
>> Filesystem volume name:   USERDATA
>> Last mounted on:          /mnt/userdata
>> Filesystem UUID:          241d6272-a004-44ef-9998-7fbc3ef98672
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      ext_attr resize_inode dir_index filetype extent 64bit large_dir sparse_super large_file
>> Filesystem flags:         signed_directory_hash
>> Default mount options:    user_xattr acl
>> Filesystem state:         not clean with errors
>> Errors behavior:          Continue
>> Filesystem OS type:       Linux
>> Inode count:              4669440
>> Block count:              9338880
>> Reserved block count:     0
>> Overhead blocks:          1536
>> Free blocks:              5602781
>> Free inodes:              4247845
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Group descriptor size:    64
>> Reserved GDT blocks:      1024
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         16384
>> Inode blocks per group:   1024
>> Filesystem created:       Wed Jan 30 18:42:35 2019
>> Last mount time:          Fri Mar 15 20:16:26 2019
>> Last write time:          Fri Mar 15 20:16:26 2019
>> Mount count:              90
>> Maximum mount count:      -1
>> Last checked:             Thu Jan 31 18:49:12 2019
>> Check interval:           0 (<none>)
>> Lifetime writes:          204 GB
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:              256
>> Required extra isize:     32
>> Desired extra isize:      32
>> Journal UUID:             00000000-1b00-0000-0000-000000000000
>> Journal inode:            131072
>> Default directory hash:   half_md4
>> Directory Hash Seed:      2416ec00-bef9-437a-a3b1-f626303d72a2
>> FS Error count:           41
>> First error time:         Sun Mar  3 13:15:39 2019
>> First error function:     ext4_readdir
>> First error line #:       182
>> First error inode #:      3673403
>> First error block #:      0
>> Last error time:          Mon Mar 11 18:22:09 2019
>> Last error function:      ext4_empty_dir
>> Last error line #:        2712
>> Last error inode #:       639817
>> Last error block #:       1
>>

