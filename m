From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Which kernel do I need to use ext4 64-bit.
Date: Tue, 18 Jul 2017 13:17:34 -0600
Message-ID: <469EA06D-C08B-463E-9511-4C340BED86C8@dilger.ca>
References: <789629f3-d70f-5588-65ec-a45d5c3259a9@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_FCE9BEEB-4571-402A-909F-F48A8FCB679D";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35067 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbdGRTRi (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Jul 2017 15:17:38 -0400
Received: by mail-io0-f176.google.com with SMTP id k71so18802035iod.2
        for <linux-ext4@vger.kernel.org>; Tue, 18 Jul 2017 12:17:38 -0700 (PDT)
In-Reply-To: <789629f3-d70f-5588-65ec-a45d5c3259a9@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FCE9BEEB-4571-402A-909F-F48A8FCB679D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 16, 2017, at 10:26 AM, Ram Ramesh <rramesh2400@gmail.com> wrote:
> I asked this question on linux-ext3 and apparently I cannot post it =
there as moderator has to approve it, and he is neither approving or =
disapproving my message. May be the list is dormant now and everything =
happens here. Any way here is my question.

The linux-ext3 list is obsolete, linux-ext4 is the right list for such =
questions.

>> Is there a kernel version restriction for 64bit ext4 FS creation/use? =
Google does not seem to find any info on this. I have mythbuntu  14.04 =
distro that has
>>=20
>>> zym [rramesh] 473 > uname -a
>>> Linux zym 3.13.0-119-generic #166-Ubuntu SMP Wed May 3 12:18:55 UTC =
2017 x86_64 x86_64 x86_64 GNU/Linux
>>=20
>> Can I create a 64bit ext4 under this kernel and mount/use?

The 64bit feature flag was only set for large filesystems (> 16TB) in =
the past,
but I believe that this is the default for all filesystems since =
e2fsprogs-1.43.

>> BTW, my resize2fs cannot grow the file system beyond 16TB. I assume =
this is due to current FS being 32bit. I need to make it 64bit. What is =
the best way to go about doing this *on my distro*?
>>=20
>>> zym [rramesh] 474 > resize2fs
>>> resize2fs 1.42.9 (4-Feb-2014)
>>> Usage: resize2fs [-d debug_flags] [-f] [-F] [-M] [-P] [-p] device =
[new_size]

This is fairly old.  1.42.13 is probably the better version for you to =
use.
I believe that 1.43 also has support for enabling the 64bit feature on =
an
existing filesystem.

Cheers, Andreas






--Apple-Mail=_FCE9BEEB-4571-402A-909F-F48A8FCB679D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZbl7OpIg59Q01vtYRAjSFAKCz2P9/6SdNEC5VG43w/+jvxG/2aACg2oKc
eXn5iUZjQ0WCHQ46wOgOCp8=
=fnWD
-----END PGP SIGNATURE-----

--Apple-Mail=_FCE9BEEB-4571-402A-909F-F48A8FCB679D--
