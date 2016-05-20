From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: correct error value of function verifying dx checksum
Date: Thu, 19 May 2016 21:40:04 -0600
Message-ID: <B1B2837F-8C07-4CD2-967C-AEA8A51C05C8@dilger.ca>
References: <1463702096-11386-1-git-send-email-daeho.jeong@samsung.com> <20160520015100.GA4586@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_4B638A9F-13B3-49D7-8895-F5EE0D74E8F3"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Daeho Jeong <daeho.jeong@samsung.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f193.google.com ([209.85.213.193]:35404 "EHLO
	mail-ig0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbcETDkM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 May 2016 23:40:12 -0400
Received: by mail-ig0-f193.google.com with SMTP id jn6so9430469igb.2
        for <linux-ext4@vger.kernel.org>; Thu, 19 May 2016 20:40:11 -0700 (PDT)
In-Reply-To: <20160520015100.GA4586@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_4B638A9F-13B3-49D7-8895-F5EE0D74E8F3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On May 19, 2016, at 7:51 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Fri, May 20, 2016 at 08:54:56AM +0900, Daeho Jeong wrote:
>> ext4_dx_csum_verify() returns the success return value in two =
checksum
>> verification failure cases. We need to set the return values to zero
>> as failure like ext4_dirent_csum_verify() returning zero when failing
>> to find a checksum dirent at the tail.

It would be useful to add a comment block to this function that =
describes
the return values.  Clearly, if the author didn't get the return values
correct, it seems likely that someone else may be confused in the =
future.
The function itself isn't named clearly enough to know whether the =
return
of "1" or "0" should be considered an error.  If it were named something
like "ext4_dx_csum_valid()" then clearly "1" would mean it is valid and
"0" would mean it is invalid.

> ISTR deciding back in 2011 that "can't find the checksums" wasn't a =
hard enough
> error to warrant shutting down the FS.  Though, being unable to find =
the limit
> and count fields of a dx node /is/ bad enough, I think.
>=20
> 2016 me is more paranoid about soft errors, so:
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

My recollection is that there are some cases where adding a checksum to =
an existing directory that didn't have enough space for the tail would =
leave
the directory with no checksum?  What does e2fsck do in this case when
adding checksums to an existing directory?  Skip the tail or split the =
block?

Cheers, Andreas

>> Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
>> ---
>> fs/ext4/namei.c |    4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
>> index 48e4b89..ec811bb 100644
>> --- a/fs/ext4/namei.c
>> +++ b/fs/ext4/namei.c
>> @@ -446,14 +446,14 @@ static int ext4_dx_csum_verify(struct inode =
*inode,
>> 	c =3D get_dx_countlimit(inode, dirent, &count_offset);
>> 	if (!c) {
>> 		EXT4_ERROR_INODE(inode, "dir seems corrupt?  Run e2fsck =
-D.");
>> -		return 1;
>> +		return 0;
>> 	}
>> 	limit =3D le16_to_cpu(c->limit);
>> 	count =3D le16_to_cpu(c->count);
>> 	if (count_offset + (limit * sizeof(struct dx_entry)) >
>> 	    EXT4_BLOCK_SIZE(inode->i_sb) - sizeof(struct dx_tail)) {
>> 		warn_no_space_for_csum(inode);
>> -		return 1;
>> +		return 0;
>> 	}
>> 	t =3D (struct dx_tail *)(((struct dx_entry *)c) + limit);
>>=20
>> --
>> 1.7.9.5
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_4B638A9F-13B3-49D7-8895-F5EE0D74E8F3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVz6HFnKl2rkXzB/gAQitjQ//ZKZ9W53VeVFA1nwPyE+ZJ02c9n5I1eB7
+Q9ukvHEzpEVnVoA6Wp+BAu46pguHIN2YGGJkdZ6szYfzc+zdMxQySRzx80NPFVE
F6tp8S8yaQ5LgZ3E1vumYNBgah5L04j+yV+QwBsJr+H1w8OaTiBwDy7kDBZwzvqn
lq+MvZUlHZjcETTuLAkJha3QtTFFD0ZCpJTUgn+JqDUVY6Y7PfVErsoSAhb+7os5
hcC/XU7BTzTD2yZzU9/T6ojQ3RwMF+Dw7UnhsJIbRRaHNonJ3onor4nkpr+2eK4t
QbRxE9UKCM4DLOROwRL2nxcQOnsZP9TUUiJH6B1IbSB0rQ2r5LBJ1CmAtO6sMwdW
PKdU5TTu5etwZ2xzmuLKCy6PH6uB90b5SZD5xqg2KTAPUBrG4RmVIwbtwv3V8EA9
ps5eOUYPO1P5ThiA6bQhluoaqbl957fYNt6xH0sV5ZfMZTeVmfANSoxU1/N2GocH
b2NcNzDbBmhecQW3b2/NQQsLWl3/uXi+qK2D6ViL6thQYKcf+mRnqywZedquUSCQ
eLgxyeddMRm1DXjwJxAdT4//sbNaQkaW2tuM7pSuSp2pr6+y4R+97AHzqz7Lw8bD
JObH2BadJjlwpJCu7m4g8nnlxlDw05HS8cS5rvifVsE7tLjTdq1XAAZLblSsfWKX
QrNjS/z7ARA=
=SN/T
-----END PGP SIGNATURE-----

--Apple-Mail=_4B638A9F-13B3-49D7-8895-F5EE0D74E8F3--
