From: Stewart Smith <stewart@flamingspork.com>
Subject: Re: [RFC] Optimizing readdir()
Date: Mon, 14 Jan 2013 17:09:26 +1100
Message-ID: <87wqvge1nt.fsf@flamingspork.com>
References: <20130113152204.GB26803@laptop.redhat.com> <20130114045152.GF29329@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org,
	=?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>, Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kaylee.flamingspork.com ([74.207.245.61]:44466 "EHLO
	kaylee.flamingspork.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3ANGQO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Jan 2013 01:16:14 -0500
In-Reply-To: <20130114045152.GF29329@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:
> I wonder if the better approach is to just simply have some
> easy-to-use library routines that do a readdir/sort in userspace.  The
> spd_readdir does basically this, and as we can see it's good enough
> for most purposes.  The problem is danger when using this in threaded
> programs, or if you have programs doing really strange things with
> telldir/seekdir, etc.
>
> But it wouldn't be that hard to write a generic library function which
> if it were used for find, ls, tar, and a few other key programs, would
> solve the problem for most use cases.

Many times I've used scandir(3) to do this.

(copying out of notmuch/notmuch-new.c):

static int
dirent_sort_inode (const struct dirent **a, const struct dirent **b)
{
    return ((*a)->d_ino < (*b)->d_ino) ? -1 : 1;
}

(as then doing stat() on each file is *much* faster in inode order)

glibc provides alphasort() (POSIX.1-2008) and versionsort() (GNU
extension), it'd probably be great if it also provided inodesort()

=2D-=20
Stewart Smith

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ86EXAAoJEP08notdpDyvvhsP/22+zbigK0+8/BPMU2j+YO7z
IBIgT7XppgIsJ7caxz9pnJfwuoV0a01O6Cu43CWwxsODWnTI+WIwUMlseIDoCQcQ
13vlxoAQc0uriiQ3uX5TEALoiCx0xMD6wzTOuG113N5ZTjI+1gOBSexJGgtPAwNm
9lMnts6OOp0wpNSPMr1dRnAv2fvzDNGoxI09gorfRbWLfmV9cUbovTH4GE2U8aoK
4E/C5HblPNfDuH/SOmoV848THVurlsE1ud1jQS6uvdAW3mrdjk6kmOFmH3uk+Cxk
yC/uamf7K5ramnzdaOGIbuROKa9uvP2d1ocnpJRdM+YrQ0ncIX44jvYWmNAXI5Ck
6tI29ZVLGD07bWzH4PQiy3WLowZMM6ISb5ahCWWvG/95AQkzlIAPxLnLGwLYUDJ3
az5JRaQS+FNn8HTAQyKyh4f2vebekZISBn1u6RNbcrbs12TWYVpbgCuOI2t++i5W
t2aTQRfCuaA2qeJgfRbTqYbiu+ZCrWKVkuMfZlf95CGoVub+jPkaCLQ5zduts3D8
PskxDmYN0ZC37WHmKwJ2g7syERDgFQvddUrYjTOFyR6U7YSm8WqV+lzSK4gYLwm6
8QB8ILN/1+UMQ/770rE3uNC21d+ppd5CnvSi3DtWrHX8/xFfzd2cmRTuLjEVJaSQ
st4xJpsqDcu7IMBZpyHi
=F/S3
-----END PGP SIGNATURE-----
--=-=-=--
