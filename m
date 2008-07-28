From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: 64k Page size + ext3 errors
Date: Mon, 28 Jul 2008 16:29:23 -0700 (PDT)
Message-ID: <590218.14781.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org
To: sandeen@sandeen.net
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Eric,
=A0=A0=A0 This is PowerPC architecture from AMCC(I work for AMCC). I am=
 using 2.6.25 Kernel. According your suggestion I tested with out RAID =
I did not see any EXT-3 errors. I use "sum" command to check the data i=
ntegrity of the files.=20
I ported ADMA driver to do HW accelerated XOR calculations . Also pleas=
e note that RAID-5 works with 4K Page size.
Thanks,
Marri


----- Original Message ----
=46rom: "sandeen@sandeen.net" <sandeen@sandeen.net>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org; linux-ext4@vger.kernel.org
Sent: Sunday, July 27, 2008 6:52:05 PM
Subject: Re: 64k Page size + ext3 errors

> I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-fs
> errors when I use 64K page size. When I use 4K page size I don't see =
any
> issue. As many of you know, we=A0will get better performance when we =
store
> bigger files like videos.

Do you think it is specific to the filesystem on raid-5?=A0 Have you te=
sted
w/o md?=A0 I'd be a little surprised if the problem is at the raid laye=
r (so
cc'ing the ext3/4 list), but maybe you tested that already.

Which arch is it, and which kernel?=A0 How big is the filesystem?=A0 Wi=
th full
geometry information it might be easier for someone to reproduce & debu=
g.

Thanks,
-Eric

> When I copy 128MB size files using 64k page size no issues seen. When=
 I
> tried to copy 1.8 GB file with 64KB page size support I am seeing the
> following errors. Any clue what could be wrong.
> =A0
> Errors 1:
> EXT3-fs error (device md0): ext3_new_block: Allocating block in syste=
m
> zone - blocks from 65533, length 1
> EXT3-fs error (device md0): ext3_new_block: Allocating block in syste=
m
> zone - blocks from 65534, length 1
> =A0
> =A0
> Errors2:
> EXT3-fs error (device md0): ext3_readdir: bad entry in directory #2:
> rec_len % 4 !=3D 0 - offset=3D0, inode=3D3040
>
> =A0
> Thanks in Advance,
> Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
