From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: some large dir testing results
Date: Fri, 21 Apr 2017 18:11:12 +0300
Message-ID: <B65B18DF-BC4C-459A-AB87-DB10727E7290@gmail.com>
References: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
 <F883702D-CECE-4FE8-ACA7-706EAB3D69FB@dilger.ca>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33778 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424559AbdDUTLl (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Apr 2017 15:11:41 -0400
Received: by mail-io0-f194.google.com with SMTP id k87so33392583ioi.0
        for <linux-ext4@vger.kernel.org>; Fri, 21 Apr 2017 12:11:40 -0700 (PDT)
In-Reply-To: <F883702D-CECE-4FE8-ACA7-706EAB3D69FB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> 21 =D0=B0=D0=BF=D1=80. 2017 =D0=B3., =D0=B2 0:10, Andreas Dilger =
<adilger@dilger.ca> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
>> 2) Some JBD problems when create thread have a wait a shadow BH from =
a committed transaction.
>> [root@pink03 ~]# cat /proc/100993/stack
>> [<ffffffffa06a072e>] sleep_on_shadow_bh+0xe/0x20 [jbd2]
>> [<ffffffffa06a1bad>] do_get_write_access+0x2dd/0x4e0 [jbd2]
>> [<ffffffffa06a1dd7>] jbd2_journal_get_write_access+0x27/0x40 [jbd2]
>> [<ffffffffa08c7cab>] __ldiskfs_journal_get_write_access+0x3b/0x80 =
[ldiskfs]
>> [<ffffffffa08ce817>] __ldiskfs_new_inode+0x447/0x1300 [ldiskfs]
>> [<ffffffffa08948c8>] ldiskfs_create+0xd8/0x190 [ldiskfs]
>> [<ffffffff811eb42d>] vfs_create+0xcd/0x130
>> [<ffffffff811f0960>] SyS_mknodat+0x1f0/0x220
>> [<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
>> [<ffffffff81645549>] system_call_fastpath+0x16/0x1b
>=20
> You might consider to use "createmany -l" to link entries (at least =
65k
> at a time) to the same inode (this would need changes to createmany to
> create more than 65k files), so that you are exercising the directory
> code and not loading so many inodes into memory?
>=20

I have run a hardlink test now (it don=E2=80=99t finished all loops but =
some initial results is exist).
Initial creation rate for HDD case is ~130k hardlink per second,
after ~ 83580000 entries it dropped to the 30k-40k hard links per =
second.

Alex.=
