From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] tune2fs: confirm slow/dangerous operations
Date: Fri, 4 Dec 2015 16:54:01 -0700
Message-ID: <C3F58672-86A5-438F-BE3D-DCAFE0B80C33@dilger.ca>
References: <20151203204024.GI10580@birch.djwong.org> <ADF3DE2C-3BAF-4678-8B9B-7220F3333FE1@dilger.ca> <20151204230745.GJ10580@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_A62620EB-8C81-41AB-A450-F263F95EFB06"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35144 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbbLDXyK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 18:54:10 -0500
Received: by ioc74 with SMTP id 74so132275932ioc.2
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2015 15:54:09 -0800 (PST)
In-Reply-To: <20151204230745.GJ10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_A62620EB-8C81-41AB-A450-F263F95EFB06
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 4, 2015, at 4:07 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>=20
> On Fri, Dec 04, 2015 at 03:12:53PM -0700, Andreas Dilger wrote:
>> On Dec 3, 2015, at 1:40 PM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
>>>=20
>>> Give admins a short amount of time to confirm that they want to
>>> proceed with a dangerous operation.  Refuse to perform the op
>>> unless the filesystem is freshly checked.
>>>=20
>>> Cc: Andreas Dilger <adilger@dilger.ca>
>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> ---
>>> misc/tune2fs.c           |   41 ++++++++++----
>>> tests/t_dangerous/expect |   97 +++++++++++++++++++++++++++++++++
>>> tests/t_dangerous/name   |    1
>>> tests/t_dangerous/script |  134 =
++++++++++++++++++++++++++++++++++++++++++++++
>>> 4 files changed, 260 insertions(+), 13 deletions(-)
>>> create mode 100644 tests/t_dangerous/expect
>>> create mode 100644 tests/t_dangerous/name
>>> create mode 100644 tests/t_dangerous/script
>>>=20
>>> diff --git a/misc/tune2fs.c b/misc/tune2fs.c
>>> index af7d73c..aaa1597 100644
>>> --- a/misc/tune2fs.c
>>> +++ b/misc/tune2fs.c
>>> @@ -405,14 +405,25 @@ static int update_mntopts(ext2_filsys fs, char =
*mntopts)
>>> 	return 0;
>>> }
>>>=20
>>> -static int check_fsck_needed(ext2_filsys fs)
>>> +static void check_fsck_needed(ext2_filsys fs, const char *prompt)
>>> {
>>> -	if (fs->super->s_state & EXT2_VALID_FS)
>>> -		return 0;
>>> -	printf("\n%s\n", _(please_fsck));
>>> -	if (mount_flags & EXT2_MF_READONLY)
>>> -		printf("%s", _("(and reboot afterwards!)\n"));
>>> -	return 1;
>>> +	/* Refuse to modify anything but a freshly checked valid =
filesystem. */
>>> +	if (!(fs->super->s_state & EXT2_VALID_FS) ||
>>> +	    (fs->super->s_state & EXT2_ERROR_FS) ||
>>> +	    (fs->super->s_lastcheck < fs->super->s_mtime)) {
>>> +		printf("\n%s\n", _(please_fsck));
>>> +		if (mount_flags & EXT2_MF_READONLY)
>>> +			printf("%s", _("(and reboot afterwards!)\n"));
>>> +		exit(1);
>>> +	}
>>=20
>> Should this explicitly check for NEEDS_RECOVERY, or force journal =
replay
>> directly?  It would be a sad thing if the filesystem was modified and =
then
>> journal replay clobbered it.
>=20
> I was under the impression that the patch "tune2fs: warn if the =
filesystem
> journal is dirty" was sufficient to discourage journal-clobbering?
>=20
> AFAICT, that patch runs for any invocation of tune2fs, whereas
> check_fsck_needed only applies to "dangerous" operations, i.e. the =
ones that
> want to rewrite big chunks of FS.

That check is fine as a warning for "simple" changes (e.g. setting a =
flag in
the superblock), since if it gets clobbered when there _may_ be a =
superblock
in the journal it isn't any worse than if it was never set at all.

For "dangerous" options like these, if the filesystem is modified and =
then
the journal is replayed (e.g resize inodes, replay journal with old =
inode
table blocks on top of the modified inodes) the results would be =
disastrous.

So for dangerous options it makes sense to either refuse to change the =
filesystem
if the journal is dirty, or replay the journal before changing the =
filesystem
if the proceed question is accepted.

It wouldn't be terrible to have a proceed question if the journal is =
dirty
to see if they want to replay the journal before any field is modified, =
and
just revert the warning patch.

Cheers, Andreas






--Apple-Mail=_A62620EB-8C81-41AB-A450-F263F95EFB06
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmInmnKl2rkXzB/gAQhd8w/+P+2nsrsMtediyBxjomAU3ufsYapmPI7m
8rk0UoIR/+L0EadhBT+xCkp0ickIUeEgMMbs8QOuVvz62/TwABa9L2QO9+g1u5eo
WL727kct/tD6koMH3sVjXXbCN1Iu5KRWzvW+rpLstZE0AE/s4f9DJ7r7uAAyxlFt
qtA9SGGabyXejaMEQ458dCQ7CnWAk7Rl14ER7j3PGgEwqWSBKStuWcaMd93Z7Tdw
5FjU8lb7wRZ1P9Xpe3hbtbbf24iumgmI9eSvVVjcvHcmMQqzAqaGIJtosVT3oMuw
K2sqojiw6qcM/Dt93Oug6DxzKfGKo4soze3d7y6wBrM9z5dAjhJjT0wFrg5g5SJb
JUBOV8QDZ3rb4KO0ehcHzelIzvJNw1zmDP6oFfI8bp+vZIFkd35/0oHjjwU7DRDj
cQHfXLb73S3IQZJXnEVsis1ATxeiJWIWo7Vai9FIJjI7H+Nem4X2xz9bP+U0jw3o
cdgO9wTlcimd4eI7NynX/y/PpLOZLLPoyDYuMINbOqMjKRt8XscQ6uqi/2dVVlFQ
xNyTmqlkcb3Q/ps6oFSEUptiJdn3K2g780Q3pocB0r+7JA62//id/uj83toRvlln
S7kt0hrq+w9KpzZs/nL8TU3vt8lo2GA/yEBYxTFCURG9xOY+964fQK5X1IvwLEcO
5EDo1x3RWiU=
=4AMD
-----END PGP SIGNATURE-----

--Apple-Mail=_A62620EB-8C81-41AB-A450-F263F95EFB06--
