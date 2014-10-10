From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: fix race between write and fcntl(F_SETFL)
Date: Fri, 10 Oct 2014 11:48:30 +0400
Message-ID: <878uko4b75.fsf@openvz.org>
References: <1412853287-10496-1-git-send-email-dmonakhov@openvz.org> <948E780F-14EB-4E38-9BAC-A5410F339441@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, sasha.levin@oracle.com
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60046 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbaJJHsp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2014 03:48:45 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so3503798wib.3
        for <linux-ext4@vger.kernel.org>; Fri, 10 Oct 2014 00:48:44 -0700 (PDT)
In-Reply-To: <948E780F-14EB-4E38-9BAC-A5410F339441@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Andreas Dilger <adilger@dilger.ca> writes:

> On Oct 9, 2014, at 5:14 AM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
>> O_DIRECT flags can be toggeled via fcntl(F_SETFL).
>> But this value checked twice inside ext4_file_write_iter() and __generic=
_file_write()
>> which result in BUG_ON (see typical stack trace below)
>> In order to fix this we have to use our own copy of __generic_file_write
>> and pass o_direct status explicitly.
>
> This seems like a generic problem that would be better served by fixing
> the core code instead of making a private copy of such a large function
> for ext4.  I expect other filesystems might have similar issues if the
> O_DIRECT state is changed in the middle of IO?
>
> One option is to flush pending IO on the file if the O_DIRECT flag is
> changed in setfl(). This is a bit heavyweight but I can't imagine any
> sane app that is changing the O_DIRECT state on a file repeatedly.
Agree. In fact there are a lot of other issues there fcntl(F_SETFL)
works incorrectly. For example it does not works on stack-fs
(ecrypt,unionfs) if you try to add O_APPEND flags it will be directly
assigned to virtual file (not lower one). For that reason OpenVZ introduced
f_op->set_flags in order to support our stackfs (vefs)
This is reasonable solution in general so I'll prepare patches for mainstre=
am
But this require reasonable time for negotiations with vfs people.
At the same time currently all versions are affected since 69c499d1/2012-11=
-29
So we need quick and simple fix for stable releases.
From=20first glance the best fix is to simply deny toggle O_DIRECT on files.
and f_op->check_flags(new_flags) looks like reasonable candidate, *but*
this interface is 100% useless because it has no access to file_pointer
so we do not know current ->f_flags :)
>
> Cheers, Andreas

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUN49OAAoJEFzOBSYIXfve8WwQAIen1PxHRziYvPca/DnOKgYG
SFXPJ7z9AMYQUCZHUvhPJMEb0nZBU2q+9snzTZQ917n87EUS+PFxo3gWETCu2Poa
zChSbBSvdww+A71hgmQhxa2YOebEv/HQc0zzlHsHX08J/gUzgxhz4k/1GuBHR3b0
efZIrrFCRChRImDqnrTj/F27Tau27utvqShkJE361RcE/22nWKxAYbQNUxMhssm3
nNewFnmlkEFfNiaeM/sSZkBMHAPWsHn8Li60T60hoF7dNM0NASSAmA8J9zVoI6SN
x3HZcGIBUpU0piF+OhTKTYIMNisg6JHe4B5brUG6OGlwByLD6EaEqTXsnVSVsTGk
Iaj4NRXESOp7VILXgTMBRepyIy4Rq9f98ilb2lkotvVssb1UaxmrsPumKW4wWpj/
a4T+V6rvHmawWHHk+s+VEGLz7GIjGS2puRCXqlvuEwKuV4qbeLhrNZ7h20O9Xd/r
Esg0Pz0rwDCKLePdY88XllMMgR/WVuAQfDdt1PmI8gFk3C6Mt0Rlq+V94QroL9Dw
3u73Fu9nAGrDQjLUeO/Ow1UL2rLxwsow+OOmzS6F81Gk+GbFqRb14iKTeOVOEfAO
/Khd6gDf9L0LQONDit+Y6YCaC2OlnPZUGn+mj6xYbGxFNyIaEu0v3hIL8jUnYhIr
FwMGbwTnURBREiNES2bt
=Q7Yg
-----END PGP SIGNATURE-----
--=-=-=--
