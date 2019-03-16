Return-Path: <SRS0=ONaI=RT=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CADFC43381
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 02:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2EE218A1
	for <linux-ext4@archiver.kernel.org>; Sat, 16 Mar 2019 02:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="rS7Mdc5X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfCPC5M (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 15 Mar 2019 22:57:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43662 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfCPC5L (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 15 Mar 2019 22:57:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id c8so922215pfd.10
        for <linux-ext4@vger.kernel.org>; Fri, 15 Mar 2019 19:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bZPDWlrKqKLNmgKL6fKVJREU4TtTjP+NCQYPG/8Tsm4=;
        b=rS7Mdc5XknlINrbMT2raXmwHtcaIgU4e6hc0eUF9VmJxUrogpdFo8H15Yzhre7xaD9
         3xC5HzXiFM4r3E1K5uNEsRPlE6Fhb9sl24iFTMmVdJ+I1R1Koxlxuk5cQk5Bebos8VKs
         N9Kx0dqLq9luE/t7j1lhCRDQLbItYVv+dEX/y2N98q3JzT/bsBRmUEFTLqkDMKWrOOwf
         2232eJ16bCScKvnqrh8r3wUv91W5PkRaLfq1SI8U0Wxyu7KgeirKFTkIourrXRuT/08n
         pQ/z7GWbYKyM9geSn98mLS9fsfQEhBBti5iaB29sROspAg+kwF161hZR7M27hSRl52CN
         KxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=bZPDWlrKqKLNmgKL6fKVJREU4TtTjP+NCQYPG/8Tsm4=;
        b=PYFzzqoXBtArfj738oUGd+r1pjNx3bOzI8L9ZYV6yjYlZ/ZeZ9U85ndKbwAv3pmySy
         bJ1mGGlyvrv1b0lO0zsfrGUT4SGICu2r+EkDDJNJFaW71NHhoNQdsy9n5GvyEGVObzbC
         q7Zn/ftyaBAdCvrLKJn3jK24e+e5rTrAaymiDHVcAs1NUAQkTLq2Xvm5KVnXNZOJr9Ah
         cROnTjpDkKAKFrqAVO9FejnFAQEqub6CPE351UYrorumXQ8YOkbQ2RUsCB5Wp040vBUz
         6wJtBThLXdE6slU3wueBZh3aCCnb60aqw+Zn4klMQPBeoie9qAFS4FAiXNkGxYsVF06j
         N29A==
X-Gm-Message-State: APjAAAVNk1SNyOdNnVRVBmN/G1+UgheNT2SkGGHtenmxGA+xZlOmVqha
        F3TUVtYQ/N3s3Ap1qysxh4We9chgtnE=
X-Google-Smtp-Source: APXvYqxWIZ9hdcXnxL0JWUowMUHrzq9qRg2boD6uyaHaB0RggzOZ6sZsPS5kUANXS5o3O+I7jSVl/Q==
X-Received: by 2002:a17:902:d715:: with SMTP id w21mr7468636ply.14.1552705030579;
        Fri, 15 Mar 2019 19:57:10 -0700 (PDT)
Received: from [192.168.10.175] (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id h126sm10006287pfc.135.2019.03.15.19.57.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 19:57:09 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: e2fsck fails on non journalled partition
From:   Andreas Dilger <adilger@dilger.ca>
X-Mailer: iPhone Mail (16D57)
In-Reply-To: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
Date:   Fri, 15 Mar 2019 20:57:08 -0600
Cc:     linux-ext4@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
References: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
To:     listac@nebelschwaden.de
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

It looks like you have some superblock corruption, since the journal UUID is=
 non-zero, and the journal inode is also non-zero. You can probably use debu=
gfs "ssv" command to clear these fields so that e2fsck doesn't think there i=
s a journal somewhere.=20

Cheers, Andreas

> On Mar 15, 2019, at 13:28, Ede Wolf <listac@nebelschwaden.de> wrote:
>=20
> I have to check an ext4 partition, that has been created without a journal=
. But, as it seems, e2fsck is refusing to check this drive, failing with a "=
no external journal has been found" error, code 12. That of course is correc=
t, no journal does imply no external journal.
>=20
> I am wondering, ^has_journal is well documented in both the mkfs.ext4 manp=
age as well as tune2fs. So by omitting the journal nothing obscure, hacky or=
 obviously unsupported has been done.
>=20
> Why is e2fsck refusing to check the partition? Or what else may I have be d=
oing wrong?
>=20
>=20
> ~ # e2fsck -fv /dev/sde1
> e2fsck 1.44.5 (15-Dec-2018)
> Can't find external journal
>=20
> USERDATA: ********** WARNING: Filesystem still has errors **********
>=20
> ~ # echo $?
> 12
> ~ #
>=20
> Filesystem has been created similar to this:
>=20
> mkfs -m 0 -O "^has_journal,dir_index,^metadata_csum,64bit,^ext_attr,^huge_=
file,large_dir,^metadata_csum_seed,^quota,extent" -b 4096 -i 32768 -L USERDA=
TA
>=20
>=20
>=20
> ~ # tune2fs -l /dev/sde1
> tune2fs 1.44.5 (15-Dec-2018)
> Filesystem volume name:   USERDATA
> Last mounted on:          /mnt/userdata
> Filesystem UUID:          241d6272-a004-44ef-9998-7fbc3ef98672
> Filesystem magic number:  0xEF53
> Filesystem revision #:    1 (dynamic)
> Filesystem features:      ext_attr resize_inode dir_index filetype extent 6=
4bit large_dir sparse_super large_file
> Filesystem flags:         signed_directory_hash
> Default mount options:    user_xattr acl
> Filesystem state:         not clean with errors
> Errors behavior:          Continue
> Filesystem OS type:       Linux
> Inode count:              4669440
> Block count:              9338880
> Reserved block count:     0
> Overhead blocks:          1536
> Free blocks:              5602781
> Free inodes:              4247845
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Group descriptor size:    64
> Reserved GDT blocks:      1024
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         16384
> Inode blocks per group:   1024
> Filesystem created:       Wed Jan 30 18:42:35 2019
> Last mount time:          Fri Mar 15 20:16:26 2019
> Last write time:          Fri Mar 15 20:16:26 2019
> Mount count:              90
> Maximum mount count:      -1
> Last checked:             Thu Jan 31 18:49:12 2019
> Check interval:           0 (<none>)
> Lifetime writes:          204 GB
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:              256
> Required extra isize:     32
> Desired extra isize:      32
> Journal UUID:             00000000-1b00-0000-0000-000000000000
> Journal inode:            131072
> Default directory hash:   half_md4
> Directory Hash Seed:      2416ec00-bef9-437a-a3b1-f626303d72a2
> FS Error count:           41
> First error time:         Sun Mar  3 13:15:39 2019
> First error function:     ext4_readdir
> First error line #:       182
> First error inode #:      3673403
> First error block #:      0
> Last error time:          Mon Mar 11 18:22:09 2019
> Last error function:      ext4_empty_dir
> Last error line #:        2712
> Last error inode #:       639817
> Last error block #:       1
>=20
