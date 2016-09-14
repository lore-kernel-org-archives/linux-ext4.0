From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] fscrypto: make fname_encrypt() actually return length of ciphertext
Date: Wed, 14 Sep 2016 15:37:01 -0600
Message-ID: <F8E95FD1-D51F-44B5-95C1-253FE9156816@dilger.ca>
References: <1473886634-24627-1-git-send-email-ebiggers@google.com> <1473886634-24627-2-git-send-email-ebiggers@google.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/signed; boundary="Apple-Mail=_C7BEF365-7368-4264-8811-201E8C75358E"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        jaegeuk@kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1473886634-24627-2-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--Apple-Mail=_C7BEF365-7368-4264-8811-201E8C75358E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 14, 2016, at 2:57 PM, Eric Biggers <ebiggers@google.com> wrote:
>=20
> This makes the return value match the comment.  Previously it would
> actually return 0 if encryption was successful.  No callers currently
> care, but this change should reduce the chance of future bugs.

This may be introducing a subtle bug in fscrypt_fname_usr_to_disk(), =
since
that function returns the status from fname_encrypt() directly and now =
it
returns the name length instead of 0 on success:

int fscrypt_fname_usr_to_disk(struct inode *inode,
                        const struct qstr *iname,
                        struct fscrypt_str *oname)
{
        if (fscrypt_is_dot_dotdot(iname)) {
                oname->name[0] =3D '.';
                oname->name[iname->len - 1] =3D '.';
                oname->len =3D iname->len;
                return oname->len;
        }
        if (inode->i_crypt_info)
                return fname_encrypt(inode, iname, oname);
        /*
         * Without a proper key, a user is not allowed to modify the =
filenames
         * in a directory. Consequently, a user space name cannot be =
mapped to
         * a disk-space name
         */
        return -EACCES;
}

This percolates further up to some of the callers, but in the cases that =
I
saw the check is "if (err < 0)" and the positive value is either ignored
or overwritten before being returned further up the call chain.  =
However,
that could be easily missed in the future and somewhere up the call =
chain
doing "if (rc)" would suddenly start to fail.

Since both "struct fscrypt_str" and "struct qstr" already hold the =
length
I don't think there is any benefit to returning the length to the =
caller.
Since (IMHO) this creates a non-trivial chance of introducing bugs in =
the
future it makes more sense to just change the function comment to match =
the
actual behaviour.

Cheers, Andreas

> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> fs/crypto/fname.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 3108806..7f3239c 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -103,12 +103,13 @@ static int fname_encrypt(struct inode *inode,
> 	}
> 	kfree(alloc_buf);
> 	skcipher_request_free(req);
> -	if (res < 0)
> +	if (res < 0) {
> 		printk_ratelimited(KERN_ERR
> 				"%s: Error (error code %d)\n", __func__, =
res);
> -
> +		return res;
> +	}
> 	oname->len =3D ciphertext_len;
> -	return res;
> +	return ciphertext_len;
> }
>=20
> /*
> --
> 2.8.0.rc3.226.g39d4020
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_C7BEF365-7368-4264-8811-201E8C75358E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBV9nC/XKl2rkXzB/gAQgNPhAAjC6MCep1CLgCWRRE0ApgzzUhJKQX/BN+
U9Fipkul1p0iZIb5wYOOt+BUs8DCLoojBfND4x/iFFVe7TEYdA6kPu2CkGHC2YxN
7y8Al3mVGkLToJV4lYmSJWY6vnlM/StY7Nw+Kdh0XuPcSiY/94pgCMCSVNFljcnW
//2KcJve9wrS033rUs3vbgRFYicDB3CtG+nHvnsKuaVGfseZxljxtXPe2WtjBELB
0hXa4sicEV+8+T5KPR0n4Nv25DO2gHABjayUWHmigL2D0quPYHsXnkB9/6RjOl0/
E0Ai9uaNVihdlzeQjeuDtIyZOCIRYcMjDPtWvXyONtagIeEPWeq5bwfoqD+C2NEN
IS1XHSaQwJnD2KLV6LjuqIUxGxIC6v8tkSUgFmOOQ/GP3GN65ld0guuj9N4DysqY
67bGaupvppW/O23QVntrl2/JbVnGURaUBEr/2Y3QdF6erUfQ0h2CaOACJaedCiI5
7PfEEwLT6qhi1lRkpIArzrPndkRAuesMp9CSLN/ZiuypfoZpm5F18uLpghbqrx1A
uoVTR/0+UWOmFz6lcQlpGjNJAgUMRjrLMBW8QKihXyueJooGwvA3aTmtqgssIbYN
QQ6KUOJc2nR6l3CM1kkSmDRMka0AG1jlptA3Qbsuh2OR3PjVVr83acg1cOZV6yxx
WRl8ijB1B38=
=3EtW
-----END PGP SIGNATURE-----

--Apple-Mail=_C7BEF365-7368-4264-8811-201E8C75358E--
