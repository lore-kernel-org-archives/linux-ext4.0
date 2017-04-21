From: Alexey Lyashkov <alexey.lyashkov@gmail.com>
Subject: Re: some large dir testing results
Date: Fri, 21 Apr 2017 17:11:43 +0300
Message-ID: <52BDEB7E-D971-4BF3-8BE0-0351138E2742@gmail.com>
References: <52B4B404-9FE0-4586-A02A-3451AA5BE089@gmail.com>
 <1725105.ueF9SMfe6v@t1700bs>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Artem Blagodarenko <artem.blagodarenko@gmail.com>
To: Bernd Schubert <bschubert@ddn.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:35691 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1040435AbdDUONB (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Apr 2017 10:13:01 -0400
Received: by mail-io0-f174.google.com with SMTP id r16so115602952ioi.2
        for <linux-ext4@vger.kernel.org>; Fri, 21 Apr 2017 07:13:00 -0700 (PDT)
In-Reply-To: <1725105.ueF9SMfe6v@t1700bs>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> 21 =D0=B0=D0=BF=D1=80. 2017 =D0=B3., =D0=B2 17:08, Bernd Schubert =
<bschubert@ddn.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>>=20
>> Initial analyze say about several problems
>> 0) CPU load isn=E2=80=99t high, and perf top say ldiskfs functions =
isn=E2=80=99t hot (2%-3%
>> cpu), most spent for dir entry checking function.
>>=20
>> 1) lookup have a large time to read a directory block to verify file =
not
>> exist. I think it because a block fragmentation. [root@pink03 ~]# cat
>> /proc/100993/stack
>> [<ffffffff81211b1e>] sleep_on_buffer+0xe/0x20
>> [<ffffffff812130da>] __wait_on_buffer+0x2a/0x30
>> [<ffffffffa0899e6c>] ldiskfs_bread+0x7c/0xc0 [ldiskfs]
>> [<ffffffffa088ee4a>] __ldiskfs_read_dirblock+0x4a/0x400 [ldiskfs]
>> [<ffffffffa08915af>] ldiskfs_dx_find_entry+0xef/0x200 [ldiskfs]
>> [<ffffffffa0891b8b>] ldiskfs_find_entry+0x4cb/0x570 [ldiskfs]
>> [<ffffffffa08921d5>] ldiskfs_lookup+0x75/0x230 [ldiskfs]
>> [<ffffffff811e8e7d>] lookup_real+0x1d/0x50
>> [<ffffffff811e97f2>] __lookup_hash+0x42/0x60
>> [<ffffffff811ee848>] filename_create+0x98/0x180
>> [<ffffffff811ef6e1>] user_path_create+0x41/0x60
>> [<ffffffff811f084a>] SyS_mknodat+0xda/0x220
>> [<ffffffff811f09ad>] SyS_mknod+0x1d/0x20
>> [<ffffffff81645549>] system_call_fastpath+0x16/0x1b
>> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
> I wrote patches for ext4 a long time ago to get a better caching for =
that
>=20
> https://patchwork.ozlabs.org/patch/101200/
>=20
>=20
> For FhGFS/BeeGFS we then decided to use a totally different directory =
layout,=20
> which totally eliminated the underlying issue for the main requirement =
or=20
> large dirs at all. (Personally I would recommend to do the something =
similar=20
> for Lustre - using hash dirs to store objects has a much too random =
access=20
> pattern once the file system gets used with many files...).
>=20
> Also, a caching issue has been fixed by Mel Gorman in 3.11 (I didn't =
check if=20
> these patches are backported to any vendor kernel).
>=20
>=20
Bernd,

Thanks to point we to patches, I will test with it on my next test loop.
As about a different layout - it=E2=80=99s exist as separate option.


Alex
