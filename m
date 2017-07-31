From: Sean Anderson <seanga2@gmail.com>
Subject: Re: [ext2] Mislabeled quadratic probing?
Date: Sun, 30 Jul 2017 21:40:29 -0400
Message-ID: <ec430a38-9458-343e-5c0f-a4a74474ddb0@gmail.com>
References: <07c8955b-0ead-9dd9-978e-767d5dec6712@gmail.com>
 <20170730023718.GH15980@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="k4gjOAVbcER2td2LgrpT5wPHAjnMcM439"
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack@suse.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:38436 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbdGaBkc (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jul 2017 21:40:32 -0400
In-Reply-To: <20170730023718.GH15980@bombadil.infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--k4gjOAVbcER2td2LgrpT5wPHAjnMcM439
Content-Type: multipart/mixed; boundary="lvSdhnPoxTlvNJT4tslndWxikLGRQOque";
 protected-headers="v1"
From: Sean Anderson <seanga2@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, jack@suse.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
Message-ID: <ec430a38-9458-343e-5c0f-a4a74474ddb0@gmail.com>
Subject: Re: [ext2] Mislabeled quadratic probing?
References: <07c8955b-0ead-9dd9-978e-767d5dec6712@gmail.com>
 <20170730023718.GH15980@bombadil.infradead.org>
In-Reply-To: <20170730023718.GH15980@bombadil.infradead.org>

--lvSdhnPoxTlvNJT4tslndWxikLGRQOque
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

> The biggest danger I see here is that we're only going to test 32
> groups before falling back to linear probing (we'll shift the single
> '1' bit out of 'i' in 32 steps).  That might be a performance problem,
> but it should hit quite rarely.

Actually, because the loop condition is `i < ngroups`, we test even less
than that . For example, on a 1T disk with 4K blocks there are 8192
block groups, and the maximum iterations are 13. It seems then that
simply creating a directory and creating at least 15 files and writing
at least 128M between each would cause a fall back to a linear search.
This doesn't seem all that uncommon of use case: any directory over 2GB
or so with many files would be susceptible.


--lvSdhnPoxTlvNJT4tslndWxikLGRQOque--

--k4gjOAVbcER2td2LgrpT5wPHAjnMcM439
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEkGEdW86NSNID6GAoPuiP7LShEG4FAll+io1fFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDkw
NjExRDVCQ0U4RDQ4RDIwM0U4NjAyODNFRTg4RkVDQjRBMTEwNkUACgkQPuiP7LSh
EG6+WAf/bbXrT8UftFEkcZQjIrG91TR6o51wVT0koesIlADrJ6fkAcUFIKSxZ7Dq
xt07p2uj49JVcKdn1qG0zeq4plyV5wevByxLbFXJjL6Ov2JsTCAbVRhG6ZcINe+i
6xvkmqaKeyZSRGqFdk92vOI2C6ipjcJi8MxUd4xPgrgIF1IqJEqj9wlAf5MVAo23
E2qT8v5Y3hwZifCgITKtmXNlNG3d/zarxUd5t69Z7Nyu/gxfzomcPPMehPSg+ONJ
9mC8i1eheZHdtvJcdElDdJrv87i7/E27KhMRxr26VCDoihtwsXz27g6cRedOQYLG
ipdXC8zJtWdmq3SgwGkGJCRMYOUcbA==
=EpZf
-----END PGP SIGNATURE-----

--k4gjOAVbcER2td2LgrpT5wPHAjnMcM439--
