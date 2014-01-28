From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Tue, 28 Jan 2014 14:09:15 -0700
Message-ID: <848E47EB-5FDF-4DB9-9800-4B1F4B1FA71C@dilger.ca>
References: <20140128122623.26029.qmail@science.horizon.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AFBFE058-8A9E-4A16-9EDE-15F5645AF9B2"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: T Makphaibulchoke <tmac@hp.com>, Andi Kleen <andi@firstfloor.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140128122623.26029.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_AFBFE058-8A9E-4A16-9EDE-15F5645AF9B2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jan 28, 2014, at 5:26 AM, George Spelvin <linux@horizon.com> wrote:
>> The third part of the patch further increases the scalablity of an =
ext4
>> filesystem by having each ext4 fielsystem allocate and use its own =
private
>> mbcache structure, instead of sharing a single mcache structures =
across all
>> ext4 filesystems, and increases the size of its mbcache hash tables.
>=20
> Are you sure this helps?  The idea behind having one large mbcache is
> that one large hash table will always be at least as well balanced as
> multiple separate tables, if the total size is the same.
>=20
> If you have two size 2^n hash tables, the chance of collision is equal =
to
> one size  2^(n+1) table if they're equally busy, and if they're =
unequally
> busy. the latter is better.  The busier file system will take less =
time
> per search, and since it's searched more often than the less-busy one,
> net win.
>=20
> How does it compare with just increasing the hash table size but =
leaving
> them combined?

Except that having one mbcache per block device would avoid the need
to store the e_bdev pointer in thousands/millions of entries.  Since
the blocks are never shared between different block devices, there
is no caching benefit even if the same block is on two block devices.

Cheers, Andreas






--Apple-Mail=_AFBFE058-8A9E-4A16-9EDE-15F5645AF9B2
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUugce3Kl2rkXzB/gAQK5eBAAg8vPhCVJKZN55Mj55y9CiA9M9OyVsiG+
LwXLw7HxsDoMfDW0K0SKMzPn93LKtDQpVFi23Ot4//t4PYJXkuDo0JS6v9u9ftN1
cuuuzpvPiWx1lxBA/S1tOfrmhfdYzAbkSzhnGZJYem+VVdkSF9e4j5ETfWwKZUcV
EtpAcCH7N8maMuEoffwn69MKngwJjSREayYsFwgxOCNvYGJalPSFj1K5Kl9OEkry
JJoxlGCrfVG988lbX+0qqHiCizAZUSi6QclwANNJKtaHD0FlwWNzBS3jbh6fDTue
f8wYyjGrYlSO3XaqSqL9xvk3icTdLxvwsC1mp37svBXOuDbnvwkLIO3GSoCtN143
v70qe7PPFdszAiOsAtXVjY95jNYbAA05CO+UzjVTloBvaQnTWwDzsCjaHaldBxFI
9eBjqbxcWbL7uaYst2nw3NYsCc5pDF26ir3zu70Igdf6+5GO8BhoseDz5V8zMnY2
tvdOFUTn0g7A01mjDIeYwbAelAjFugpujyxhgkIVULSlYd84aoczwEM6pk9F/A6E
W//6fybj0Xg8cI3I6Rsuppfno4Bgqh807bRj/d02yRVHzY9Vc88vSjSEiZdZo8j8
hg5eK7zdCyQiaYlRr+EcGwAMtNz6GEGy8vX2CJQ3xOpARtH9MITcPXFyzVL91fye
gU2o67Vk0Lk=
=agJf
-----END PGP SIGNATURE-----

--Apple-Mail=_AFBFE058-8A9E-4A16-9EDE-15F5645AF9B2--
