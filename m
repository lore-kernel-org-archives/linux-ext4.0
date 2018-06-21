From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/6] ext4: use timespec64 for all inode times
Date: Thu, 21 Jun 2018 11:29:13 -0600
Message-ID: <9ED1876B-995B-490D-9173-467880FDEA7F@dilger.ca>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-4-arnd@arndb.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_C6057F87-5433-49E0-BFE3-D2F243952E2F";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        y2038@lists.linaro.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620153322.54221-4-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_C6057F87-5433-49E0-BFE3-D2F243952E2F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 20, 2018, at 9:33 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>=20
> This is the last missing piece for the inode times on 32-bit systems:
> now that VFS interfaces use timespec64, we just need to stop =
truncating
> the tv_sec values for y2038 compatibililty.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Andreas Dilger <adilger@dilger.ca>

> ---
> fs/ext4/ext4.h   | 18 +++++++-----------
> fs/ext4/ialloc.c |  2 +-
> 2 files changed, 8 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 0b127853c584..6b4f4369a08c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -789,17 +789,16 @@ struct move_extent {
>  * affected filesystem before 2242.
>  */
>=20
> -static inline __le32 ext4_encode_extra_time(struct timespec *time)
> +static inline __le32 ext4_encode_extra_time(struct timespec64 *time)
> {
> 	u32 extra =3D sizeof(time->tv_sec) > 4 ?
> 		((time->tv_sec - (s32)time->tv_sec) >> 32) & =
EXT4_EPOCH_MASK : 0;
> 	return cpu_to_le32(extra | (time->tv_nsec << EXT4_EPOCH_BITS));
> }
>=20
> -static inline void ext4_decode_extra_time(struct timespec *time, =
__le32 extra)
> +static inline void ext4_decode_extra_time(struct timespec64 *time, =
__le32 extra)
> {
> -	if (unlikely(sizeof(time->tv_sec) > 4 &&
> -			(extra & cpu_to_le32(EXT4_EPOCH_MASK)))) {
> +	if (unlikely(extra & cpu_to_le32(EXT4_EPOCH_MASK))) {
>=20
> #if 1
> 		/* Handle legacy encoding of pre-1970 dates with epoch
> @@ -821,9 +820,8 @@ static inline void ext4_decode_extra_time(struct =
timespec *time, __le32 extra)
> do {										=
\
> 	(raw_inode)->xtime =3D cpu_to_le32((inode)->xtime.tv_sec);		=
\
> 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## =
_extra))     {\
> -		struct timespec ts =3D =
timespec64_to_timespec((inode)->xtime);	\
> 		(raw_inode)->xtime ## _extra =3D				=
	\
> -				ext4_encode_extra_time(&ts);			=
\
> +				ext4_encode_extra_time(&(inode)->xtime);	=
\
> 		}								=
\
> } while (0)
>=20
> @@ -840,10 +838,8 @@ do {							=
		       \
> do {										=
\
> 	(inode)->xtime.tv_sec =3D =
(signed)le32_to_cpu((raw_inode)->xtime);	\
> 	if (EXT4_FITS_IN_INODE(raw_inode, EXT4_I(inode), xtime ## =
_extra)) {	\
> -		struct timespec ts =3D =
timespec64_to_timespec((inode)->xtime);	\
> -		ext4_decode_extra_time(&ts,					=
\
> +		ext4_decode_extra_time(&(inode)->xtime,				=
\
> 				       raw_inode->xtime ## _extra);		=
\
> -		(inode)->xtime =3D timespec_to_timespec64(ts);			=
\
> 		}								=
\
> 	else									=
\
> 		(inode)->xtime.tv_nsec =3D 0;					=
\
> @@ -993,9 +989,9 @@ struct ext4_inode_info {
>=20
> 	/*
> 	 * File creation time. Its function is same as that of
> -	 * struct timespec i_{a,c,m}time in the generic inode.
> +	 * struct timespec64 i_{a,c,m}time in the generic inode.
> 	 */
> -	struct timespec i_crtime;
> +	struct timespec64 i_crtime;
>=20
> 	/* mballoc */
> 	struct list_head i_prealloc_list;
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index f525f909b559..8c00c871f5dc 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -1073,7 +1073,7 @@ struct inode *__ext4_new_inode(handle_t *handle, =
struct inode *dir,
> 	/* This is the optimal IO size (for stat), not the fs block size =
*/
> 	inode->i_blocks =3D 0;
> 	inode->i_mtime =3D inode->i_atime =3D inode->i_ctime =3D =
current_time(inode);
> -	ei->i_crtime =3D timespec64_to_timespec(inode->i_mtime);
> +	ei->i_crtime =3D inode->i_mtime;
>=20
> 	memset(ei->i_data, 0, sizeof(ei->i_data));
> 	ei->i_dir_start_lookup =3D 0;
> --
> 2.9.0
>=20


Cheers, Andreas






--Apple-Mail=_C6057F87-5433-49E0-BFE3-D2F243952E2F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlsr4GoACgkQcqXauRfM
H+BdIg/+K/BV2pNCUWpP2L7KBRhDU371lHoZogBut1IhnL/h129JtZPZ+B2+bSga
4W6ujs75roeLfC6HrkYdmTR3R4hNAft3uJF2UVX93jLgOc7QF+5gMRyAVYDA0Lh/
sbR0ZYih0j3U0Y+gWarjIwjpRIqfL7M9m0WdlsqSHzV4C0rkAL1Jky7k2MOZE5/C
tQkRuFXlldFHjDePnK7cTIZKdR7ffV0zd/pt0ydsroUPhy7JPrVZaS4v2u6L+kH/
QY33xuCVXxLsFJhBAYKc4RgkFdM8m008w5N9xQ/39Im9Aj1P1D6uLB9EwTlUGSqv
FsOb8m5nF57a+ouRcPAkShkO2Rv732GOEo4HFHpdLiwFCxB04FYoJtB/axCn5JBt
HGzIgHw6NUqkasa/TT+Examp8EaAv35HawrG8qM3TYFjK9lVNArVWe4iFSGqNHWg
h5WkxczfRRA8SCsiZn662/1FDgCDEvTWsfzCmFSNNBP4G8z7eHGRQeDeNT6haVRK
bAJVE4GFNu4bgWbNKkAE+4/U+bPB2SebRikJmpwcRqNt/xju2TNxOreITjRqJXTX
RLKtKj/QbsA8hhGH4FybNqimt3PuC8ynXfP/U5ui0dkc4b++F3d4z1MzpXS5PEMS
U+/2RLfNI1EEcn+BhGTmNy4QCGaKNFl6y+7WWQwQEScb5h+LWxY=
=Q/Vk
-----END PGP SIGNATURE-----

--Apple-Mail=_C6057F87-5433-49E0-BFE3-D2F243952E2F--
