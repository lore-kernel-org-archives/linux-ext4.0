From: Daniel Drake <dsd@laptop.org>
Subject: Re: Determining if an ext4 fs uses the whole partition
Date: Mon, 30 Apr 2012 12:18:48 -0600
Message-ID: <CAMLZHHQUQKK10XQ2WZdgoMO9PPTmP2tNYL5xN2aQirD+TLSzbA@mail.gmail.com>
References: <CAMLZHHSi=1U=-V+qMOOunPnuSWDcTm81aSjXdnc51kvYk=n_vA@mail.gmail.com>
	<4F9ECC0E.8020201@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2D3SSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2012 14:18:49 -0400
Received: by pbbrp8 with SMTP id rp8so3536875pbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 30 Apr 2012 11:18:49 -0700 (PDT)
In-Reply-To: <4F9ECC0E.8020201@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 30, 2012 at 11:29 AM, Eric Sandeen <sandeen@redhat.com> wro=
te:
> For starters, use fdisk -u to get 512-byte sector units,
> otherwise it's just inscrutable CHS magic.
>
> i.e.:
>
> # fdisk -lu /dev/sda2
>
> Disk /dev/sda2: 526 MB, 526417920 bytes
> 255 heads, 63 sectors/track, 64 cylinders, total 1028160 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
>
> so 1028160 512-byte sectors.
>
> # dumpe2fs -h /dev/sda2 | grep "Block count\|Block size"
> dumpe2fs 1.42.2 (27-Mar-2012)
> Block count: =A0 =A0 =A0 =A0 =A0 =A0 =A0514080
> Block size: =A0 =A0 =A0 =A0 =A0 =A0 =A0 1024
>
> so 514080 1k blocks, or 1028160 512-byte sectors, so bingo, it's full=
=2E

Hmm yes, following the same process I can get the same results. I must
have misread/miscalculated something when I looked earlier.
User error :)

> Or, FWIW, it's harmless to invoke resize2fs if the fs already fills t=
he
> partition; it should just exit with a no-op.

Thanks for pointing this out - its probably my best option, coming to
think of it.

>> One easy solution, if possible, would be to find out the number of t=
he
>> last sector used by the filesystem. I could then very easily compare
>> this to the "end" information found in sysfs for the partition. Then=
 I
>> can make the decision on whether to grow or not.
>
> dumpe2fs should certainly be able to tell you. =A0Mounting the fs, an=
d
> doing statfs would, as well (f_blocks). =A0There should also be libex=
t2fs
> functions you could use if you want to do it in C...

Trying the statfs approach (the fs in question is already mounted):

# dumpe2fs -h /dev/mmcblk0p2 | grep "Block count\|Block size"
dumpe2fs 1.42 (29-Nov-2011)
Block count:              949248
Block size:               4096

# stat -f /
  File: "/"
    ID: f09a7645207bdd68 Namelen: 255     Type: ext2/ext3
Block size: 4096       Fundamental block size: 4096
Blocks: Total: 934935     Free: 198205     Available: 188947
Inodes: Total: 227824     Free: 133103

The numbers don't agree.

(Not a big deal, since I can use the other 2 approaches you mentioned,
just wanted to point it out)

Thanks
Daniel
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
