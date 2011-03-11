From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] filefrag: count optimize non-verbose mode; count 0 extents
 properly when verbose
Date: Fri, 11 Mar 2011 09:01:38 -0600
Message-ID: <4D7A3952.8020903@redhat.com>
References: <4CEC4C86.1030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: p@draigbrady.com
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1CKPBm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Mar 2011 10:01:42 -0500
In-Reply-To: <4CEC4C86.1030806@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/23/10 5:21 PM, Eric Sandeen wrote:
> # rm -f a; touch a; filefrag -v a
>=20
> yields 1 extent when it should be 0.  Without -v, 0 is returned.
>=20
> Fix this up by special-casing no extents returned in verbose
> mode; skip printing the header for the columns too, since there
> are no columns to print.
>=20
> Also, in nonverbose mode we can set fm_extent_count to 0
> so that FIEMAP will just query the extent count without gathering
> details; as it is today I think a non-verbose query may under-report
> the extent count once "count" extents have been filled in.
>=20
> Addresses-redhat-bugzilla: 653234
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ted, ping on this one?  Looks like it got lost.  I noticed this when
P=E1draig Brady filed another red hat bug for the same issue,
saying that he had also sent you a patch...

-Eric

> ---
>=20
> diff --git a/misc/filefrag.c b/misc/filefrag.c
> index bd4486d..a48b9b0 100644
> --- a/misc/filefrag.c
> +++ b/misc/filefrag.c
> @@ -194,7 +194,14 @@ static int filefrag_fiemap(int fd, int blk_shift=
, int *num_extents)
>  	do {
>  		fiemap->fm_length =3D ~0ULL;
>  		fiemap->fm_flags =3D flags;
> -		fiemap->fm_extent_count =3D count;
> +		/*
> +		 * If fm_extent_count =3D=3D 0, FIEMAP returns count of
> +		 * extents found without filling in details.
> +		 */
> +		if (!verbose)
> +			fiemap->fm_extent_count =3D 0;
> +		else
> +			fiemap->fm_extent_count =3D count;
>  		rc =3D ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
>  		if (rc < 0) {
>  			if (errno =3D=3D EBADR && fiemap_incompat_printed =3D=3D 0) {
> @@ -206,6 +213,14 @@ static int filefrag_fiemap(int fd, int blk_shift=
, int *num_extents)
>  		}
> =20
>  		if (verbose && !fiemap_header_printed) {
> +			/*
> +			 * No extents on first call?
> +			 * Skip header and show 0 extents.
> +			 */
> +			if (fiemap->fm_mapped_extents =3D=3D 0) {
> +				*num_extents =3D 0;
> +				goto out;
> +			}
>  			printf(" ext %*s %*s %*s length flags\n", logical_width,
>  			       "logical", physical_width, "physical",
>  			       physical_width, "expected");
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
