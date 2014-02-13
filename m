From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v4 0/3] ext4: increase mbcache scalability
Date: Wed, 12 Feb 2014 19:01:17 -0700
Message-ID: <1C3FB797-A411-4528-B38D-5E0533353724@dilger.ca>
References: <1377186876-57291-1-git-send-email-tmac@hp.com> <1390588288-66930-1-git-send-email-tmac@hp.com> <87fvodcb65.fsf@tassilo.jf.intel.com> <DBA818DD-1C87-4B98-8475-8BB8F00F7DA4@dilger.ca> <52FA80DB.2000504@hp.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AED3833F-1086-41BA-BE7C-FCE997FDB864"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Andi Kleen <andi@firstfloor.org>, T Makphaibulchoke <tmac@hp.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"aswin@hp.com" <aswin@hp.com>
To: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52FA80DB.2000504@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_AED3833F-1086-41BA-BE7C-FCE997FDB864
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1


On Feb 11, 2014, at 12:58 PM, Thavatchai Makphaibulchoke =
<thavatchai.makpahibulchoke@hp.com> wrote:
> On 01/24/2014 11:09 PM, Andreas Dilger wrote:
>> I think the ext4 block groups are locked with the blockgroup_lock =
that has about the same number of locks as the number of cores, with a =
max of 128, IIRC.  See blockgroup_lock.h.=20
>>=20
>> While there is some chance of contention, it is also unlikely that =
all of the cores are locking this area at the same time. =20
>>=20
>> Cheers, Andreas
>>=20
>=20
> Andreas, looks like your assumption is correct.  On all 3 systems, 80, =
60 and 20 cores, I got almost identical aim7 results using either a =
smaller dedicated lock array or the block group lock.  I'm inclined to =
go with using the block group lock as it does not incur any extra space.
>=20
> One problem is that, with the current implementation mbcache has no =
knowledge of the super block, including its block group lock, of the =
filesystem.  In my implementation I have to change the first argument of =
mb_cache_create() from char * to struct super_block * to be able to =
access the super block's block group lock.

Note that you don't have to use the ext4_sb_info->s_blockgroup_lock.
You can allocate and use a separate struct blockgroup_lock for mbcache
instead of allocating a spinlock array (and essentially reimplementing
the bgl_lock_*() code).  While it isn't a huge amount of duplication,
that code is already tuned for different SMP core configurations and
there is no reason NOT to use struct blockgroup_lock.

> This works with my proposed change to allocate an mb_cache for each =
mounted ext4 filesystem.  This would also require the same change, =
allocating an mb_cache for each mounted filesystem, to both ext2 and =
ext3, which would increase the scope of the patch.  The other =
alternative, allocating a new smaller spinlock array, would not require =
any change to either ext2 and ext3.
>=20
> I'm working on resubmitting my patches using the block group locks and =
extending the changes to also include both ext2 and ext3.  With this =
approach, not only that no addition space for dedicated new spinlock =
array is required, the e_bdev member of struct mb_cache_entry could also =
be removed, reducing the space required for each mb_cache_entry.
>=20
> Please let me know if you have any concern or suggestion.

I'm not against re-using the s_blockgroup_lock in the superblock, since
the chance of contention on this lock between threads is very small, as
there are normally 4x the number of spinlocks as cores.

You might consider starting with a dedicated struct blockgroup_lock in
the mbcache code, then move to use the in-superblock struct in a later
patch.  That would allow you to push and land the mbcache and ext4 =
patches
independently of the ext2 and ext3 patches (if they are big).  If the
ext2 and ext3 patches are relatively small then this extra complexity
in the patches may not be needed.

Cheers, Andreas






--Apple-Mail=_AED3833F-1086-41BA-BE7C-FCE997FDB864
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUvwnbnKl2rkXzB/gAQIclQ/9GbLAfmadFvkX0BTRh3DT71fcuf+RTE9P
pNysFzwPWuZcufchZBIh2M3VxRl2ZeiADlGTVva1Qzg2pPB49+m8VRQOI2JQ7GOv
vtEbL8SneO1P+3mK2elxRKN4o8L5dqYsfcipOL+XoE4E+YOJgJ5FsEACg0i9oai1
nwYato5jddHbqD3t4+tUjNHHKbKVp8ZHihojLfYndHEJvxaPtQfSQqdKIFNPfjYk
3TLpol93+Wq/X4ClWNBt75YZmgq+j1zm8w84YKBuq3WJWfdz7t3AOronogeX8p/p
Nyl3F1ABRtyFPZT1Pui6Dp+uf5gryWrsgHqY5+1bpFAfXl7+zGjPuDtSSJi5/+vV
ewk/cuTWb71KvLnsDQzfPCgG+5Du9G6CjsBCpjcjjmagqeuTGUtiwxAXJ3N4scK6
+ByBJ3RWw0Jaklh3Vxtf8KSZB6Bjj4P3v3auG39eZu0xQlMm+xYpGditogECuwod
cCla0uDAq7QDfke+nxbVkHWg/cxnlYpout3J6lZVRrI++KbtEaI1CQJRGod5u4dh
W3RnH6bplET1nsLyMoszKOpqMZ3D74+7XZ/Z+PVuiVipIZoK/5WKPBPUrvHOMhEx
8smt1vncYnKkUfT7YIhVfEQ/8y+WZBpPmwEDuk+lSkQoWb+TJ2g0O+qIY/BqF+3C
REX1gWLRLsY=
=KMDK
-----END PGP SIGNATURE-----

--Apple-Mail=_AED3833F-1086-41BA-BE7C-FCE997FDB864--
