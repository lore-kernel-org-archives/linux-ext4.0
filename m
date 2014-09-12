From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: possible different donor file naming in e4defrag
Date: Fri, 12 Sep 2014 13:41:17 -0600
Message-ID: <30D261EC-6B62-4A83-BA43-29DF560DF193@dilger.ca>
References: <BLU436-SMTP2540BD5998FEB4A3695A2E4FDE90@phx.gbl>,<20140815203909.GM2808@birch.djwong.org>,<BAY179-W62818B481ECC21D8121A2FFDE90@phx.gbl>,<4DF4149D-9995-475D-B25E-DAE799DE6100@dilger.ca>,<BAY179-W923915B59A3302CF7A1CB0FDCC0@phx.gbl>,<25905DD3-CD3E-42F2-A101-715E7C205CEB@dilger.ca>,<BAY179-W1E8676C4343760B6A8332FDCC0@phx.gbl> <BAY179-W439C9EFFCA6CA9A7C99DF8FDCC0@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_FD80564F-7BAB-42D1-83D4-40C117AD8EB8"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54115 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbaILTlQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Sep 2014 15:41:16 -0400
Received: by mail-pa0-f50.google.com with SMTP id bj1so1929945pad.9
        for <linux-ext4@vger.kernel.org>; Fri, 12 Sep 2014 12:41:16 -0700 (PDT)
In-Reply-To: <BAY179-W439C9EFFCA6CA9A7C99DF8FDCC0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_FD80564F-7BAB-42D1-83D4-40C117AD8EB8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=iso-8859-1

On Sep 11, 2014, at 5:03 PM, TR Reardon <thomas_reardon@hotmail.com> =
wrote:
> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
> index d0eac60..8001182 100644
> --- a/misc/e4defrag.c
> +++ b/misc/e4defrag.c
> @@ -1526,31 +1527,36 @@ static int file_defrag(const char *file, const =
struct stat64 *buf,
> =20
>  	/* Create donor inode */
>  	memset(tmp_inode_name, 0, PATH_MAX + 8);
> -	sprintf(tmp_inode_name, "%.*s.defrag",
> -				(int)strnlen(file, PATH_MAX), file);
> -	donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, =
S_IRUSR);
> +	/* Try O_TMPFILE first, to avoid changing directory mtime */
> +	sprintf(tmp_inode_name, "%.*s", (int)strnlen(file, PATH_MAX), =
file);
> +	donor_fd =3D open64(dirname(tmp_inode_name), O_TMPFILE | =
O_WRONLY | O_EXCL, S_IRUSR | S_IWUSR );

Lines need to be <=3D 80 columns.  Please run patch through =
checkpatch.pl.

Why is it opened O_WRONLY, but the permissions are S_IRUSR | S_IWUSR?
I agree it didn't make sense in the old code to have S_IRUSR either,
but I don't think this makes more sense.  If the file is write-only
(which is probably correct, unless e4defrag is doing some post-copy
checksum of the data) then S_IWUSR would be enough.

>  	if (donor_fd < 0) {
> -		if (mode_flag & DETAIL) {
> -			PRINT_FILE_NAME(file);
> -			if (errno =3D=3D EEXIST)
> -				PRINT_ERR_MSG_WITH_ERRNO(
> -				"File is being defraged by other =
program");
> -			else
> -				=
PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
> +		sprintf(tmp_inode_name, "%.*s.defrag",
> +					(int)strnlen(file, PATH_MAX), =
file);
> +		donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | =
O_EXCL, S_IRUSR);

Wrap at 80 columns.

This has the same issue with O_WRONLY and S_IRUSR, though it at least
matches the old code.

> +		if (donor_fd < 0) {
> +			if (mode_flag & DETAIL) {
> +				PRINT_FILE_NAME(file);
> +				if (errno =3D=3D EEXIST)
> +					PRINT_ERR_MSG_WITH_ERRNO(
> +					"File is being defraged by other =
program");
> +				else
> +					=
PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
> +			}
> +			goto out;
>  		}
> -		goto out;
> -	}
> =20
> -	/* Unlink donor inode */
> -	ret =3D unlink(tmp_inode_name);
> -	if (ret < 0) {
> -		if (mode_flag & DETAIL) {
> -			PRINT_FILE_NAME(file);
> -			PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink");
> +		/* Unlink donor inode */
> +		ret =3D unlink(tmp_inode_name);
> +		if (ret < 0) {
> +			if (mode_flag & DETAIL) {
> +				PRINT_FILE_NAME(file);
> +				PRINT_ERR_MSG_WITH_ERRNO("Failed to =
unlink");
> +			}
> +			goto out;
>  		}

Shouldn't it reset the timestamp in this case?

Cheers, Andreas

> -		goto out;
>  	}
> -
> +=09
>  	/* Allocate space for donor inode */
>  	orig_group_tmp =3D orig_group_head;
>  	do {


> ----------------------------------------
>> From: thomas_reardon@hotmail.com
>> To: adilger@dilger.ca
>> CC: darrick.wong@oracle.com; linux-ext4@vger.kernel.org
>> Subject: RE: possible different donor file naming in e4defrag
>> Date: Thu, 11 Sep 2014 18:49:07 -0400
>>=20
>>> On Sep 11, 2014, at 1:48 PM, TR Reardon <thomas_reardon@hotmail.com> =
wrote:
>>>> Picking this back up. How would O_TMPFILE avoid races? It =
definitely avoids the unwanted mtime/atime update, but then the existing =
"<filename>.defrag" pseudo-lock file would no longer be available. How =
could you use O_TMPFILE and still avoid multiple defrag? If this isn't =
possible, then resetting the parent times on unlink(tmpfile), as you =
suggest, is the simplest way out of this.
>>>=20
>>> Looking at this the opposite way - what are the chances that there
>>> will be concurrent defrags on the same file? Basically no chance at
>>> all. So long as it doesn't explode (the kernel would need to protect
>>> against this anyway to avoid malicious apps), the worst case is that
>>> there will be some extra defragmentation done in a very rare case.
>>>=20
>>> Conversely, creating a temporary filename and then resetting the
>>> parent directory timestamp is extra work for every file =
defragmented,
>>> and is racy because e4defrag may "reset" the time to before the temp
>>> file was created, but clobber a legitimate timestamp update in the
>>> directory from some other concurrent update. That timestamp update
>>> is always going to be racy, even if e4defrag tries to be careful.
>>>=20
>>> Cheers, Andreas
>>=20
>>=20
>> Thanks, well described.
>>=20
>> So a simple attempt with O_TMPFILE first, then revert to original =
behavior, like below?
>>=20
>>=20
>> diff --git a/misc/e4defrag.c b/misc/e4defrag.c
>> index d0eac60..8001182 100644
>> --- a/misc/e4defrag.c
>> +++ b/misc/e4defrag.c
>> @@ -40,6 +40,7 @@
>> #include <sys/stat.h>
>> #include <sys/statfs.h>
>> #include <sys/vfs.h>
>> +#include <libgen.h>
>>=20
>> /* A relatively new ioctl interface ... */
>> #ifndef EXT4_IOC_MOVE_EXT
>> @@ -1526,31 +1527,36 @@ static int file_defrag(const char *file, =
const struct stat64 *buf,
>>=20
>> /* Create donor inode */
>> memset(tmp_inode_name, 0, PATH_MAX + 8);
>> - sprintf(tmp_inode_name, "%.*s.defrag",
>> - (int)strnlen(file, PATH_MAX), file);
>> - donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, =
S_IRUSR);
>> + /* Try O_TMPFILE first, to avoid changing directory mtime */
>> + sprintf(tmp_inode_name, "%.*s", (int)strnlen(file, PATH_MAX), =
file);
>> + donor_fd =3D open64(dirname(tmp_inode_name), O_TMPFILE | O_WRONLY | =
O_EXCL, S_IRUSR | S_IWUSR );
>> if (donor_fd < 0) {
>> - if (mode_flag & DETAIL) {
>> - PRINT_FILE_NAME(file);
>> - if (errno =3D=3D EEXIST)
>> - PRINT_ERR_MSG_WITH_ERRNO(
>> - "File is being defraged by other program");
>> - else
>> - PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
>> + sprintf(tmp_inode_name, "%.*s.defrag",
>> + (int)strnlen(file, PATH_MAX), file);
>> + donor_fd =3D open64(tmp_inode_name, O_WRONLY | O_CREAT | O_EXCL, =
S_IRUSR);
>> + if (donor_fd < 0) {
>> + if (mode_flag & DETAIL) {
>> + PRINT_FILE_NAME(file);
>> + if (errno =3D=3D EEXIST)
>> + PRINT_ERR_MSG_WITH_ERRNO(
>> + "File is being defraged by other program");
>> + else
>> + PRINT_ERR_MSG_WITH_ERRNO(NGMSG_FILE_OPEN);
>> + }
>> + goto out;
>> }
>> - goto out;
>> - }
>>=20
>> - /* Unlink donor inode */
>> - ret =3D unlink(tmp_inode_name);
>> - if (ret < 0) {
>> - if (mode_flag & DETAIL) {
>> - PRINT_FILE_NAME(file);
>> - PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink");
>> + /* Unlink donor inode */
>> + ret =3D unlink(tmp_inode_name);
>> + if (ret < 0) {
>> + if (mode_flag & DETAIL) {
>> + PRINT_FILE_NAME(file);
>> + PRINT_ERR_MSG_WITH_ERRNO("Failed to unlink");
>> + }
>> + goto out;
>> }
>> - goto out;
>> }
>> -
>> +
>> /* Allocate space for donor inode */
>> orig_group_tmp =3D orig_group_head;
>> do {
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> 		 	   		  <DEFRAG_O_TMPFILE>


Cheers, Andreas






--Apple-Mail=_FD80564F-7BAB-42D1-83D4-40C117AD8EB8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVBNMXXKl2rkXzB/gAQJfmw/9EkhtSkzHULcQhK+Fsd74xhdcr8hNDnUE
wbP5/frcqafP48dLjZEiNtigaTpVlbPa86SGsjmWnMz9AzBTIO0YN+6zr8sTc/v6
TKazQsJilJjxrZGTS3CZPxBe8poHx+awdb0iA2w4fMT/k6hnvGesGn2PprtdBkOP
/IrIJGqy1OycuIojEndcvXdSFnd7nDHhS6iOk5PcAbyPdFetVLZc1ukVPeG6RFSM
ZNyFm+3MU8wK6kxciSHDjGuFqQ5Ud3K8U9YvyFdzxicL4yfGNL3X/BWKaDS8pU7L
11/P08CNjBTid1qjX27WLj2CRf6GD3iM580yWDeIMC6Y9v75v7OtHfh0nX8QAEi7
UhA/RMRa0GxR0bO5jSxATsOjTK+Y9o9NttIR2Cwzzy/bfso3U3psE9hEenuxpooV
WwPSp/6mZmBC5JJXc7bjoZ1yh3xhig+WmN1W4LRB3jtyPiq8qUAJ/rU3XlJfC0X2
g6c3KRXkXSszhElhx0RUHlJj8vpLPEYHEwbLiSUJmsrt5h+8HZPcmMfv81RWXMbF
cSO4Eb+lzRbMzlFrg/ov1/xkQNTY8y305dB50empCuc8vA4gvPtUIJ5F27m3rEJ0
iIfO0A7lQqm0cOL3z3aBcE+lMdS6pJ8LpX4KCs7lXad4YUSWwCxpuOK6a3RXMWO+
fSnELhbXVM4=
=DzhU
-----END PGP SIGNATURE-----

--Apple-Mail=_FD80564F-7BAB-42D1-83D4-40C117AD8EB8--
