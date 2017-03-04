From: NeilBrown <neil-+NVA1uvv1dVBDLzU/O5InQ@public.gmane.org>
Subject: Re: [RFC PATCH v1 30/30] fs: convert i_version counter over to an atomic64_t
Date: Sat, 04 Mar 2017 11:00:06 +1100
Message-ID: <87zih1lxmh.fsf@notabene.neil.brown.name>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com> <1482339827-7882-31-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482339827-7882-31-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 21 2016, Jeff Layton wrote:

>=20=20
> +/*
> + * We borrow the top bit in the i_version to use as a flag to tell us wh=
ether
> + * it has been queried since we last bumped it. If it has, then we must =
bump
> + * it and set the flag. Note that this means that we have to handle wrap=
ping
> + * manually.
> + */
> +#define INODE_I_VERSION_QUERIED		(1ULL<<63)
> +

I would prefer that the least significant bit were used, rather than the
most significant.

Partly, this is because the "queried" state is less significant than
that "number has changed" state.
But most, this would mean we wouldn't need inode_cmp_iversion() at all.
We could just use "<" or ">=3D" or whatever.
The number returned by inode_get_iversion() would always be even (or
maybe odd) and wrapping (after the end of time) would "just work".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli6A4YACgkQOeye3VZi
gblBNA//dX+mAOOvNDvTqyQtKxXDIZlrQmK7oI+wSvSBbgpyOR6vwxMkmQboJXJ9
q8pIudntLXjyEykbXb+HA30AxSpL/X/7PQxG/ZllYJ1ImY2QMcvSNKnkfsNcUN0o
yv9334AIoShL8lEq35JLuoBQ3w2tVbDlNhFRTbW+lWW9hqzzNiWbSdgMuVg8qEAz
feGjCW0FqmfyhCEX4UIARUDM7qpqt71fmI1EYmriEU0hU/rFViMVAyLU7cWjF9WS
FxgYAR+QJFCHuA3OFB4Bg32jzj7qS35mI3bGG/v1X+RDjp8jQ0WwWI+8A45p0+vX
Zdw6ABbkW56vl5kM5x4j7UNG96AthXjOf1qJ5UK1dw7S3GQJb0MfLh+94v4ECWU1
SSZTvPC5OYfMcLThhew1CUx//f/p8CeG4Dfq3iBW6FHYWclWZoM0t3KRiC1dQJaT
njf0xd7CUIsXaLtlKbLXKC2vqY9wcMX62E7W74DGeffyfQ+maQaygRUW9yBiMPPe
Rh2akXxE5vpdPxm9rsP/PUJIStmTsM7MQl2oFb0zWxY5hY8PREpAXk8nD0QrrK/M
S6qNtgFevm4sPemwfe04EmumUJjX5/u1gypeHz02omdBO6Fk5XE2be6EeBC8aHtL
oxLnpA/JZxCrvoS+nvHAHvrPQHJ/EZYm1I+qDighBQN1NIxGVJI=
=HK7d
-----END PGP SIGNATURE-----
--=-=-=--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
