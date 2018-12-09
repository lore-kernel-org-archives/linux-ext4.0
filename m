Return-Path: <SRS0=zSAL=OS=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40246 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbeLIAqW (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2018 19:46:22 -0500
Received: by mail-pf1-f196.google.com with SMTP id i12so3651809pfo.7
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2018 16:46:21 -0800 (PST)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <46D361F6-4152-47DF-BD35-BD9D48B6957A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C31C5CE3-65F2-47C5-BBE4-2EACDA6EC895";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4 00/23] Ext4 Encoding and Case-insensitive support
Date: Sat, 8 Dec 2018 17:46:19 -0700
In-Reply-To: <CAHk-=wj62vGn5TeGDaPn41mev97VnA7px+R1Xor8+Ai_WmhQ9Q@mail.gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        kernel@collabora.com, linux-ext4@vger.kernel.org,
        krisman@collabora.com
To: Linus Torvalds <torvalds@linux-foundation.org>
References: <20181206230903.30011-1-krisman@collabora.com>
 <20181208194128.GE20708@thunk.org>
 <CAHk-=wg2JvjXfdZ8K5Tv3vm6+bKRedotF5cr5AwVZVBypVfdAQ@mail.gmail.com>
 <CAHk-=wg9J+9H4kvzF0SmBP_CoSrBTxPc6xMRJKb3fDnOUs0DNw@mail.gmail.com>
 <CAHk-=wj62vGn5TeGDaPn41mev97VnA7px+R1Xor8+Ai_WmhQ9Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_C31C5CE3-65F2-47C5-BBE4-2EACDA6EC895
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 8, 2018, at 3:59 PM, Linus Torvalds =
<torvalds@linux-foundation.org> wrote:
>=20
> On Sat, Dec 8, 2018 at 1:58 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>=20
>> I'm hoping you are at least doing it per-directory. That makes at
>> least the "oh, the whole filesystem needs to do this wrong" issue a
>> bit less bad.
>=20
> So for example, if you do it per-directory, the rules could be =
something like:
>=20
> - new directories (ie "mkdir()") inherit the icase/folding semantics
> of the parent directory
>=20
> - empty directories can have their case/folding rules changed with
> some well-defined interface
>=20
> and even from just those simple rules, now some icase behavior could
> be useful to testing.
>=20
> Not just filesystem testing (although that would be a thing - thing
> fsstress), but for doing app development in a test directory.
>=20
> Apps like git (and GNU fileutils) could use it for having test suites
> for FAT etc filesystems.
>=20
> And cross-platform apps could use it as a "I want to check that I do
> the right thing" if you do development on Linux, but might have a
> portable app for other platforms.
>=20
> If the whole filesystem is that way, nobody is going to do it. Sure,
> they could do it on a FAT filesystem using a USB disk, but nobody
> really does that. But if you can troivially just run your tests in a
> test subdirectory, it's another thing entirely.
>=20
> So this is the kind of thing I mean when I think icase behavior for a
> major Linux filesystem should have a real _design_. It's really quite
> fundamentally different from the "oh, I need FAT to be icase" hack
> that we have now.
>=20
> (We might also be able to make the dcache better at handling
> well-defined icase/folding rules, as opposed to the current "just give
> up, let the filesystem hash it" behavior).

In theory, we could store the encoding on a per-entry basis if we
wanted, using the dir_data feature (this would consume 2-3 bytes per
entry, depending on how rich an encoding type we wanted).  The tricky
part is how does the kernel know what the filename encoding is?  How
do we communicate the encoding type back to userspace?

Cheers, Andreas






--Apple-Mail=_C31C5CE3-65F2-47C5-BBE4-2EACDA6EC895
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlwMZdsACgkQcqXauRfM
H+CfZQ//WhYfEvbsAbbfFA1s7pHvmF+sy5qe0Q1hv2x+cz29n4hR6IjHXN5NctbL
rWHK7bYIAIcgUD8tp913c6qh+6eT+n8nP6Qo4Ywio5vyXKZRkOkh1v47qK24hGLC
O59A8kww5MVdFkzzd+q6eSiqK+U/x1GXXtiKy8mFNvCcFQ3DTHgkD3MJbCltikJU
x1L3KG/MDHG2Hs3z/cidr60h0KzF2LFDl7IkgcniILyQNRH+no4qyyHvrBJ8L+Ac
Ks3XY1jQ9Jekn+7Mj97S3VYjz4o/GqJFVZgsg9aiGS9ktP5uPoD4WBDp4bflDHEj
t+JeG9g4O7PFbHeB6AiSHSxESo9orQNIE/ivGIc9Cd/JNzcQr5llLHXXAd3MMZCE
sXsfkx0oy8Zn0hiagZcKNLaGfHOHAd08Qn4BtQH0XGuMUFKPKWGAhtwNG7QfmqJ+
sLu4/GysS6JCtfLbSDfbzDjFn30WfnRDMsRTaltV00hu1L4213haKbAhGadUDpzd
bP573FABwhDiqeBzCtv5mWo3z3fVp7wB2Jig5/TDsO5yQ1HEv7xn++XzjrDar/wN
P10kbUXkIKwTJtYOtjBQrYX2Br2q3Iz1fui2gRSA2d8imxab9X0LcTu6Ic+3CaYh
kiVhFbaGxo/8lxr/iKdFpsTPE30ucifZqbDtuLv/ed4iL5yw45I=
=fMUv
-----END PGP SIGNATURE-----

--Apple-Mail=_C31C5CE3-65F2-47C5-BBE4-2EACDA6EC895--
