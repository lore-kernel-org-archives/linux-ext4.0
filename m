From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal filesystems
Date: Tue, 22 Nov 2016 15:49:51 -0700
Message-ID: <4CB8CE8B-8AFE-4266-9983-4B2555702EF3@dilger.ca>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com> <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca> <20161118184704.GA73496@google.com> <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca> <20161121231924.GG30672@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A159610F-0D3C-4475-A5D3-CEAB92D33B64"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34195 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbcKVWt5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Nov 2016 17:49:57 -0500
Received: by mail-io0-f193.google.com with SMTP id r94so2997404ioe.1
        for <linux-ext4@vger.kernel.org>; Tue, 22 Nov 2016 14:49:57 -0800 (PST)
In-Reply-To: <20161121231924.GG30672@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A159610F-0D3C-4475-A5D3-CEAB92D33B64
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 21, 2016, at 4:19 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> On Fri, Nov 18, 2016 at 02:52:22PM -0700, Andreas Dilger wrote:
>>=20
>>> Yes, this would be a much nicer way to detect fast symlinks.
>>>=20
>>> The only thing I'd be concerned about is the possibility of =
pre-existing
>>> "slow" symlinks that actually have targets short enough to be "fast"
>>> symlinks, perhaps in filesystems created by old drivers or by =
external
>>> tools.  If such links happened to work before, then a change to =
check
>>> i_size would break them.
>>>=20
>>> This may not be an issue in practice.  I checked some old ext4 =
versions,
>>> ext2 from Linux 0.99.7, e2fsprogs, Android's ext4_utils, and =
FreeBSD's
>>> ext2 driver.  They all create "fast" symlinks if the length of the
>>> symlink target length excluding the terminating null (i_size) is < =
60.
>>=20
>> I did a similar analysis with similar results.
>>=20
>=20
> Ted, what would you say about Andreas' suggestion to use i_size to
> distinguish fast symlinks from slow symlinks?
>=20
> It looks like this was discussed some years ago but the discussion =
died
> out and no change was made: see =
https://www.spinics.net/lists/linux-ext4/msg05693.html
>=20
> Given the investigation I did it seems it would very likely be safe, =
but
> we can never be 100% sure it won't break some obscure tool or (version =
of
> a tool) to create symlinks on ext2/ext3/ext4 filesystems we don't know
> about.

Conversely, we've had fast symlinks break a few times due to additional
blocks being stored with the fast symlink (external xattr blocks for =
SELinux,
now encryption), possibly others in the future, and such breakages are
backwards incompatible (i.e. if there is some new way to add a block to
a symlink it will break all older kernels).

Cheers, Andreas






--Apple-Mail=_A159610F-0D3C-4475-A5D3-CEAB92D33B64
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBWDTLkHKl2rkXzB/gAQgJyw//dcwFphzkUkDfJjvxRdbZFl/7aePbnLqE
X/lMBzmnPs/6U0V4LBP9k3Q2clWKWY9Q/xCdAbS8eaGy+etjkfSeEoFCd0uNM7ZT
L+A8Zmf0/wXDKpQbBcAS0/OKk/sBYnpPwt7fzib5fU9b05qZ6Hf/UE58PznX8H9o
hjxF8LQkOR0aLjREtRFTluQpi+DbWGF+72Xwl9mbHnwuCHQ0dW3nPRaT3LYOdtMn
b9C5IBpHUZ45nIICkp6VTF1p3noNIoFtwprZYWaixyzvNTWjcf+DWsMyDaxqTJ2/
px9UWTm3pEOnNbukH1eVV/SQKwtHM9mtL2mEcT0ygn3GXGRmWS3FY7M8b8XMN1mj
zo3nMyh19rXxKCBNNFIwbXSrPAuc1R7O9a8d29l4qqXit+3tJmK1TyuphpZvSyk4
y9RJEQgoZRWet5q60l9Y1vJ1kqZ0B119THT1Vd5qG9EQnqFH74qwQDe+bEbe3cd2
za58TSOsRtJ0Zi9MNoeFBthxBKMQFqXZzL5QtJ/sjhAJMXQGxpTEHfiq7cIxP2ED
C8rA8xdy/x2x7oAOXDQqpE1pTIzXHxGs2owa63kXKRQOx6TeBAetdB/SDPLoeF9k
9d5F/WO0Khbsa4NNLDykHAmp3hwoxR89NYMuX7P17iCzY0sy2/Pc4EVD0KfSPoA+
iwiNXKwtM2I=
=rFtr
-----END PGP SIGNATURE-----

--Apple-Mail=_A159610F-0D3C-4475-A5D3-CEAB92D33B64--
