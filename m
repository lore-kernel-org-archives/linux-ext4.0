From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 09/32] ext4: extended attribute value size limit is
 enforced by vfs
Date: Thu, 22 Jun 2017 13:40:25 -0600
Message-ID: <B0650C7F-0982-4D10-ADC9-925B376D92BE@dilger.ca>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-9-tahsin@google.com>
 <20170622180243.GC4728@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_766C4A12-92AA-4705-B8BB-4C80A41E1C42";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170622180243.GC4728@birch.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_766C4A12-92AA-4705-B8BB-4C80A41E1C42
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 22, 2017, at 12:02 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Wed, Jun 21, 2017 at 02:21:19PM -0700, Tahsin Erdogan wrote:
>> EXT4_XATTR_MAX_LARGE_EA_SIZE definition in ext4 is currently unused.
>> Besides, vfs enforces its own 64k limit which makes the 1MB limit in
>> ext4 redundant. Remove it.
>=20
> Just FYI I believe the 64k VFS limit exists because XFS is the only fs
> to allow large xattr values, and its maximum is 64k (on-disk field =
size
> limitation).
>=20
> I don't know if anyone actually wants larger values?  Now could be a
> time to have such a conversation, if anyone is so interested.

The EXT4_XATTR_MAX_LARGE_EA_SIZE limit of 1MB was also totally =
arbitrary,
but a reasonable upper limit for the atomic get/set interface used by
xattrs.  The underlying disk format could actually store xattrs of any =
size.

I'd think if we want to get huge xattrs that they should be handled by
having separate streams (e.g. open file descriptor, ioctl/syscall to =
select
a different stream number on that file) so that the data doesn't have to =
be
completely rewritten any time it is modified, but streams are frowned =
upon
by many Linux developers for security reasons so will probably be a =
no-go.

Cheers, Andreas

> --D
>=20
>>=20
>> Signed-off-by: Tahsin Erdogan <tahsin@google.com>
>> ---
>> fs/ext4/ext4.h | 6 ------
>> 1 file changed, 6 deletions(-)
>>=20
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 5d5fc0d0e2bc..2cdd6070e348 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -2220,12 +2220,6 @@ struct mmpd_data {
>>  */
>> #define EXT4_MMP_MAX_CHECK_INTERVAL	300UL
>>=20
>> -/*
>> - * Maximum size of xattr attributes for FEATURE_INCOMPAT_EA_INODE =
1Mb
>> - * This limit is arbitrary, but is reasonable for the xattr API.
>> - */
>> -#define EXT4_XATTR_MAX_LARGE_EA_SIZE    (1024 * 1024)
>> -
>> /*
>>  * Function prototypes
>>  */
>> --
>> 2.13.1.611.g7e3b11ae1-goog
>>=20


Cheers, Andreas






--Apple-Mail=_766C4A12-92AA-4705-B8BB-4C80A41E1C42
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFZTB0rpIg59Q01vtYRAo3KAJ9N2HAdAUjudUx5v+aSs6qSWVjQvQCdGs97
2Gffzt0lTKA4pQWq0LdVZh0=
=tpys
-----END PGP SIGNATURE-----

--Apple-Mail=_766C4A12-92AA-4705-B8BB-4C80A41E1C42--
