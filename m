From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 4/4] ext4: fix suboptimal seek_{data,hole} extents traversial
Date: Fri, 12 Dec 2014 11:52:29 +0300
Message-ID: <878uidgshe.fsf@openvz.org>
References: <1417518054-21733-1-git-send-email-dmonakhov@openvz.org> <1417518054-21733-4-git-send-email-dmonakhov@openvz.org> <20141211200540.GE31008@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56566 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaLLIxD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Dec 2014 03:53:03 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so8523651wgg.5
        for <linux-ext4@vger.kernel.org>; Fri, 12 Dec 2014 00:53:01 -0800 (PST)
In-Reply-To: <20141211200540.GE31008@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> Hi Dmitry,
>
> I only noticed this after I sent the pull request to Linus, but it
> looks like this patch is triggering regression using the ext3 config:
>
> ./kvm-xfstests -c ext3 generic/285:
>
> The failure reported by seek_santy_test is:
>
> 10. Test a huge file for offset overflow
> 10.01 SEEK_HOLE expected 65536 or 0, got 0.                       FAIL
> 10.02 SEEK_HOLE expected 65536 or 0, got 1.                       FAIL
> 10.03 SEEK_DATA expected 0 or 0, got -1.                          FAIL
> 10.04 SEEK_DATA expected 1 or 1, got -1.                          FAIL
> 10.05 SEEK_HOLE expected 0 or 0, got -65536.                      FAIL
> 10.06 SEEK_DATA expected -65536 or -65536, got -1.                FAIL
> 10.07 SEEK_DATA expected -65535 or -65535, got -1.                FAIL
> 10.08 SEEK_DATA expected -65536 or -65536, got -1.                FAIL
>
> What's strange is that if I run the commands by hand, I get a very
> different failure:
>
> root@kvm-xfstests:~# ./xfstests/src/seek_sanity_test /vdd/seek_sanity_tes=
tfile
> File system magic#: 0xef53
> Allocation size: 4096
> Kernel does not support llseek(2) extensions SEEK_HOLE and/or SEEK_DATA. =
Aborting.
>
> Using strace, the problem is that the SEEK_DATA fallocate is failing:
>
> pwrite64(3, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"..., 8192, 0) =3D 8192
> ftruncate64(3, 16384)                   =3D 0
> _llseek(3, 0, 0xbff7fe70, SEEK_DATA)    =3D -1 ENXIO (No such device or a=
ddress)
Oh. Indeed That is my mistake.

ret =3D ext4_fiemap(inode, &fie, offset, maxsize - offset);
/* No extents found, EOF */
if (!fie.fi_extents_mapped) {
     ret =3D -ENXIO;
     break;
  }=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
Delalloc case handled incorrectly. Will fix that ASAP.

>
> This fails with commit 14516bb: "ext4: fix suboptimal seek_{data,hole}
> extents traversial" and succeeds with its immediate predesssor commit.
>
> I've tried looking at this, but hte fact that I'm seeing different
> results when I run it by hand (sometimes I can trigger the failure
> with runtests.sh, usually I can't), means that it appears to be timing
> dependent.
>
> Could you take a look?
>
> Many thanks!!
>
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUiqzOAAoJELhyPTmIL6kB5RUIAL5d8j8tLn1+WDeSr30/FjYu
Ya0J3CxGFd9CyHliSbH9J9mwx/OGyF5eIyNKLgNXHGTIivTF2WTUG5nR6iT+yp7h
Dyovd95U+whRf+8LjgTaRphot3j8x/bht8x6mRz3IeDTskNm/hKvir2MgvkZCTUb
eR071WfGC4uY4VrusS73ZobZMNz/zRe8Fe45Rq9sgLkEuId//5pbJcyZd4RjPMxE
uLHfNJcOhS2ox+Caqr0qqNtFhQYIgO0Pt9oe/RQcaJpW1wauvVDPGeEf2zNdaymC
LzPKeZBOU8f3Q8SDip4b38IcMXyI/qpwXJRzm86HcNzBlUjfeq7rDXyx+DHS8Qs=
=kdyd
-----END PGP SIGNATURE-----
--=-=-=--
