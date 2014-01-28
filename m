From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: How many files to create in one directory?
Date: Tue, 28 Jan 2014 14:02:02 -0700
Message-ID: <4E499A0C-8A39-4AA2-9C9E-F85C77D9F4C4@dilger.ca>
References: <52E607B1.2060206@jprs.co.jp> <52E69F3F.2000104@redhat.com> <20140127193950.GA20411@thunk.org> <52E6B80D.7060807@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_7694FFE9-1379-4CDF-86A6-AC86F762BF5F"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>, Masato Minda <minmin@jprs.co.jp>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37093 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaA1VCH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Jan 2014 16:02:07 -0500
Received: by mail-pb0-f41.google.com with SMTP id up15so872370pbc.28
        for <linux-ext4@vger.kernel.org>; Tue, 28 Jan 2014 13:02:07 -0800 (PST)
In-Reply-To: <52E6B80D.7060807@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_7694FFE9-1379-4CDF-86A6-AC86F762BF5F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Jan 27, 2014, at 12:48 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/27/14, 1:39 PM, Theodore Ts'o wrote:
>>> It will depend on the length of the filenames.  But by my =
calculations,
>>> for average 28-char filenames, it's closer to 30 million.

Note that there is also a 2GB directory size limit imposed by not using
i_size_high for directories.  That works out to be about:

  (2^30 bytes / 4096 bytes/block) *
  ((4096 bytes/block / (28 + 4 + 4 bytes/entry)) * 0.75 full) ~=3D 22M =
entries

We have a patch that allows using i_size_high for directories, and
adding 3rd level htree support for small block filesystems or very
large directories.  However, we haven't written e2fsck support for
it and it isn't currently enabled.

If someone is interested in taking a look at this:
=
http://git.whamcloud.com/?p=3Dfs/lustre-release.git;a=3Dblob;f=3Dldiskfs/k=
ernel_patches/patches/sles11sp2/ext4-pdirop.patch;h=3D4d2acffadaa31a1bdd9f=
3a592cda71dfcdd585a4;hb=3DHEAD

The "htree lock" part of the patch is for allowing parallel
create/lookup/unlink access to the large directory, but last time
I asked Al Viro about this he didn't seem interested in exporting
that functionality to the VFS.

>> Note that there will be some very significant performance problems
>> well before a directory gets that big.  For example, just simply =
doing
>> a readdir + stat on all of the files in that directory (or a readdir =
+
>> unlink, etc.) will very likely result in extremely unacceptable
>> performance.
>=20
> Yep, that's the max possible, not the max useable.  ;)

In newer kernels it is also possible to put an upper limit on the size
of a directory via /sys/fs/ext4/{dev}/max_dir_size_kb tunable or mount
option.  This prevents users from creating directories that are so big
they can't be handled by normal tools.

> (Although, I'm not sure in practice what max useable looks like, TBH).

We regularly test with 10M files per directory.  Obviously, workloads
that do this do not use "ls -l" or equivalent, but just lookup-by-name
from within applications.  It is usable in our testing up to about 15M
entries before there can start being problems with level-2 leaf blocks
getting full (due to uneven usage of the leaf blocks).

Cheers, Andreas

>> So if you can find some other way of avoiding allowing the file =
system
>> that big (i.e., using a real database instead of trying to use a file
>> system as a database, etc.), I'd strongly suggest that you consider
>> those alternatives.
>>=20
>> Regards,
>>=20
>> 					- Ted
>>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_7694FFE9-1379-4CDF-86A6-AC86F762BF5F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUugaynKl2rkXzB/gAQIh1Q//TSvZmY4oMVcsQEF+ylRRDffmPM3fhaFu
ye/dbsMQGD8HoUNZM0+rsWwa5Y0NTNTgZC+gn8rmtdiiLo/miqj0hY/5+2HTZFM9
BvgqEyMCY0TJTUJe05Ytu+wjqe8qnk8QjwbOeWAMKpHISbAxAZ7qc5FCa8XKCxAi
LO6jxs5T64VpQjh2oW/engem7Iaz933p0S5t31g3emUFG5tgHZHdcedFejuX1C6e
FNqW0Vb4OTVbxQzb9wpe+eXmEZQQZDx76dQjYap6vAe/U46rmYgZyiqSJ1K/PZ+p
vUxtDYl2AoaK4ah9+yARla4mSEpDdWAstqYsXPvBuzDTFc9o71G5hZvyDCNi/oYG
fIxhBZ9KMNjbOm9/+LtOKXdoSiInCDsD5//YPQWoY4fWmfK1Uxzo/MK/vV3pBV14
Jn6rnx58nStQHXjmb2Q/cwiRpzjv1s87xyXeE4O5FiHJMLZz1S47tjyy3RMXdJGy
P6haDIeJhcJi3X58p0H7E1UpNh+C9Yiiyy7TrIYzbLp6HrLG9zFvFacI6V0rWLq0
HkYeDq4ZW0b+8DQRD1ADJyivjJuL+Cz/h/U3gQ3iPNlhGqTy07v6ZRQ+NH9oE1eg
AC636V/K7uEAas4fpM48Grp57rdDuLr3oSfu8ueVKLqfiC4gBDU6vM+FYMj+nLsZ
iWr2uABIvgM=
=gCBD
-----END PGP SIGNATURE-----

--Apple-Mail=_7694FFE9-1379-4CDF-86A6-AC86F762BF5F--
