From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/21] fs: Mark functions as static in jbd2/journal.c
Date: Sun, 9 Feb 2014 18:59:38 -0800
Message-ID: <20140210025938.GD9176@birch.djwong.org>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
 <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b13f571ff87a2ee1942578a97b00823373e9bd79.1391949868.git.rashika.kheria@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Feb 09, 2014 at 06:41:21PM +0530, Rashika Kheria wrote:
> Mark functions as static in jbd2/journal.c because they are not used
> outside this file.
>=20
> This eliminates the following warning in jbd2/journal.c:
> fs/jbd2/journal.c:125:5: warning: no previous prototype for =E2=80=98=
jbd2_verify_csum_type=E2=80=99 [-Wmissing-prototypes]
> fs/jbd2/journal.c:146:5: warning: no previous prototype for =E2=80=98=
jbd2_superblock_csum_verify=E2=80=99 [-Wmissing-prototypes]
> fs/jbd2/journal.c:154:6: warning: no previous prototype for =E2=80=98=
jbd2_superblock_csum_set=E2=80=99 [-Wmissing-prototypes]
>=20
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Looks fine to me, so you can add
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/jbd2/journal.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 5fa344a..244b6f6 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -122,7 +122,7 @@ EXPORT_SYMBOL(__jbd2_debug);
>  #endif
> =20
>  /* Checksumming functions */
> -int jbd2_verify_csum_type(journal_t *j, journal_superblock_t *sb)
> +static int jbd2_verify_csum_type(journal_t *j, journal_superblock_t =
*sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -143,7 +143,7 @@ static __be32 jbd2_superblock_csum(journal_t *j, =
journal_superblock_t *sb)
>  	return cpu_to_be32(csum);
>  }
> =20
> -int jbd2_superblock_csum_verify(journal_t *j, journal_superblock_t *=
sb)
> +static int jbd2_superblock_csum_verify(journal_t *j, journal_superbl=
ock_t *sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return 1;
> @@ -151,7 +151,7 @@ int jbd2_superblock_csum_verify(journal_t *j, jou=
rnal_superblock_t *sb)
>  	return sb->s_checksum =3D=3D jbd2_superblock_csum(j, sb);
>  }
> =20
> -void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb=
)
> +static void jbd2_superblock_csum_set(journal_t *j, journal_superbloc=
k_t *sb)
>  {
>  	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
>  		return;
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
