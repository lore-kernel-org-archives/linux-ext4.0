From: Kilian Cavalotti <kilian.cavalotti.work@gmail.com>
Subject: Re: Recover from a "deleted inode referenced" situation
Date: Thu, 12 Oct 2017 15:02:03 -0700
Message-ID: <CAJz=VjEOnU=wsdjmHitxQsTXvW7AMgYRiKFJPGq_imPUbu5+GQ@mail.gmail.com>
References: <CAJz=VjEUqxMNo6zShYaV5ffioxaj6+a5Av0imtfdtCDf7wqY=A@mail.gmail.com>
 <32D25551-5517-4B17-B89B-2A1D60249ABA@dilger.ca> <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:52950 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753191AbdJLWCZ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Oct 2017 18:02:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id k4so16932973wmc.1
        for <linux-ext4@vger.kernel.org>; Thu, 12 Oct 2017 15:02:24 -0700 (PDT)
In-Reply-To: <CAJz=VjG+7Q0j7erfNC8ocwnkkgtrDXK-Ma_pRLSu7yiGZXH88w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 11, 2017 at 7:36 AM, Kilian Cavalotti
<kilian.cavalotti.work@gmail.com> wrote:
> On Tue, Oct 10, 2017 at 1:36 PM, Andreas Dilger <adilger@dilger.ca> wrote=
:
>> If the problem is only one of the partition being misaligned compared
>> to the logical volume, you can run the "findsuper" utility which is
>> part of e2fsprogs *sources* (it isn't built and packaged by default).
>> It will scan your block device and print out the ext2/3/4 superblocks
>> that it finds, along with the *byte* offset of each one found.  You
>> can use this to determine where the start of the filesystem should be.
>
> I will give this a try, thanks. Although I don't really had any issue
> to mount the filesystem r/o, which seems to indicate that there is no
> misalignment issue, right?

So... I tried findsuper, and it started listing things (including, for
some, non-printable characters in the "label" field, but I guess it's
just false-positives).

It's still running right now, but it already listed superblocks which
are obviously not related to the actual filesystem, but to raw disk
images (created via dd) that I had on that filesystem. For instance:

-- 8< ---------------------------------------------------------
# /usr/local/sbin/findsuper /dev/mapper/overlay
starting at 0, with 512 byte increments
byte_offset  byte_start     byte_end  fs_blocks blksz  grp
mkfs/mount_time           sb_uuid label
      1024           0  17983724322816   95590400  4096    0  Thu Nov
26 23:22:42 2015 12c2c019 1.42.6-5644
149595921408 18323935265112545280  13818231386087778304  2356078660
1024 28990  Sun Sep  7 13:34:55 2098 dc41997c 8=EF=BF=BDb=EF=BF=BD=EF=BF=BD=
=EF=BF=BDa`/=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD03=EF=BF=BD=EF=BF=BDx^=EF=
=BF=BD=EF=BF=BD|


=EF=BF=BD=EF=BF=BDFq=EF=BF=BD=EF=BF=BD<<=EF=BF=BD=EF=BF=BD_=EF=BF=BDs=DF=A0=
=E8=92=BF=EF=BF=BD=EF=BF=BD=EF=BF=BDCx=EF=BF=BDX=EF=BF=BD=EF=BF=BDZ=EF=BF=
=BD=EF=BF=BD8=EF=BF=BD=EF=BF=BD=EF=BF=BDMxR=EF=BF=BD=EF=BF=BD(R=EF=BF=BD=EF=
=BF=BD=EF=BF=BD/
                              =EF=BF=BD@=EF=BF=BD-+=EF=BF=BD>=EF=BF=BDF=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DB=82=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD@=EF=BF=BD
=EF=BF=BD=EF=BF=BD=EF=BF=BD$=EF=BF=BD=D7=B8}=EF=BF=BD=EF=BF=BD|=EF=BF=BD=EF=
=BF=BD=EF=BF=BD)=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD
=EF=BF=BD=EF=BF=BDK=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDy=EF=BF=BD=EF=BF=BDl=
=EF=BF=BD=EF=BF=BD0=EF=BF=BD=DE=80c.3`B=EF=BF=BD~g=DD=84`A=EF=BF=BD~=EF=BF=
=BD=EF=BF=BD{=EF=BF=BD12=EF=BF=BD=EF=BF=BD!^p=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDk=EF=BF=BDDn
0=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDoD=EF=BF=BD=EF=BF=BD=
=DE=B3=EF=BF=BD=EF=BF=BD=EF=BF=BDI=EF=BF=BD=EF=BF=BD;&=DA=A2=EF=BF=BDB=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD/=EF=BF=BDY=EF=BF=BD =EF=BF=BD_Ba=
=EF=BF=BDo=EF=BF=BD=EF=BF=BD=EF=BF=BD?$}=EF=BF=BDb'=EF=BF=BDB=EF=BF=BD=EF=
=BF=BD=EF=BF=BD%A=EF=BF=BD!=EF=BF=BD#=EF=BF=BD$@u=EF=BF=BD8~
293534171136 293534170112  18277258492928   95590400  4096    0  Thu
Nov 26 23:22:42 2015 12c2c019 1.42.6-5644
716505512960 716505511936  716628391936     120000  1024    0  Thu Aug
20 23:31:41 2009 d33ff464
716539067392 716530677760  716653557760     120000  1024    1  Thu Aug
20 23:31:41 2009 d33ff464
[...]
2556972232704 2556972231680  2560139979776     773376  4096    0  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
2557257444352 2557123226624  2560290974720     773376  4096    1  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
2557962087424 2557559434240  2560727182336     773376  4096    3  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
2558532512768 2557861424128  2561029172224     773376  4096    5  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
2559086160896 2558146636800  2561314384896     773376  4096    7  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
2559656586240 2558448626688  2561616374784     773376  4096    9  Tue
Jan 29 20:40:53 2013 da57c5f6 casper-rw
-- 8< ---------------------------------------------------------

That makes me think I should be able to recover those dd images with
the correct offsets, right? So for instance, looking at the
"casper-rw" label, I tried this:

-- 8< ---------------------------------------------------------
# dd if=3D/dev/ro_device of=3D/tmp/test.dd bs=3D4096 skip=3D2556972231680
count=3D773376 iflag=3Dskip_bytes
-- 8< ---------------------------------------------------------

The resulting /tmp/test.dd file looks like a correct filesystem:
-- 8< ---------------------------------------------------------
# file /tmp/dd_test
/tmp/dd_test: Linux rev 1.0 ext2 filesystem data (mounted or unclean),
UUID=3Dda57c5f6-1018-8a45-83b9-e12a39be7ce2, volume name "casper-rw"
(large files)
-- 8< ---------------------------------------------------------

But I can't seem to be able to mount it:
-- 8< ---------------------------------------------------------
[507159.565593] EXT2-fs (loop3): warning: mounting unchecked fs,
running e2fsck is recommended
[507165.114603] EXT2-fs (loop3): error: ext2_check_page: bad entry in
directory #2: : unaligned directory entry - offset=3D0,
inode=3D2263518911, rec_len=3D23425, name_len=3D177
[507165.129657] EXT2-fs (loop3): error: ext2_readdir: bad page in #2
-- 8< ---------------------------------------------------------

Did I misinterpret the output of findsuper?

Thanks!
--=20
Kilian
