From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH 0/4] fs: introduce new writeback error tracking infrastructure and convert ext4 to use it
Date: Fri, 07 Apr 2017 08:15:24 +1000
Message-ID: <87y3vdyygz.fsf@notabene.neil.brown.name>
References: <1491215318.2724.3.camel@redhat.com> <20170403143257.GA30811@bombadil.infradead.org> <1491241657.2673.10.camel@redhat.com> <20170403191602.GF30811@bombadil.infradead.org> <1491250577.2673.20.camel@redhat.com> <87h924kh6t.fsf@notabene.neil.brown.name> <20170404115358.GH30811@bombadil.infradead.org> <1491308268.20445.4.camel@redhat.com> <20170404161247.GJ30811@bombadil.infradead.org> <1491323146.309.1.camel@redhat.com> <20170404170909.GK30811@bombadil.infradead.org> <1491421792.18658.20.camel@redhat.com> <87efx6tnbr.fsf@notabene.neil.brown.name> <1491506092.9621.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, akpm@linux-foundation.org,
        tytso@mit.edu, jack@suse.cz
To: Jeff Layton <jlayton@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491506092.9621.2.camel@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06 2017, Jeff Layton wrote:

>
> I tried to avoid updating things unnecesssarily. I could use some
> guidance on how to specify the constants in terms of MAX_ERRNO as well.

ilog2() defined in include/linux/log2.h

And you have MAX_ERROR in one comment, instead of MAX_ERRNO :-)

>=20=20
> -  flush: called by the close(2) system call to flush a file
> +  flush: called by the close(2) system call to flush a file. Writeback
> +	errors not previously reported via fsync should be reported
> +	here as you would for fsync.

"could", not "should".  I think it is agreed that this is a good
idea, is it?

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 7251f7bb45e8..f33857113ff4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -394,6 +394,7 @@ struct address_space {
>  	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
>  	struct list_head	private_list;	/* ditto */
>  	void			*private_data;	/* ditto */
> +	u32			wb_err;

I would rather this was a wb_err_t or similar, and that the functions
which implement it take a pointer to a wb_err_t.
Then the 'error' in 'struct nfs_open_context' could become a 'wb_err_t',
and nfs could use these functions to do error tracking the way it wants
to.

Thanks - looking good.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljmvfwACgkQOeye3VZi
gbkv0xAAnvb2w8+iq5UAqlHTl9nmQRZ6tClJlFCgG+cTVch2TPKzxd6RxwMECZor
IKeDfFNDUTcZtjPPc25SdwrB/8YgozY+++RMUReCgVy3L/Fs9ydYSpc0hKuRufcJ
9MCNJHNNFmTLlyvUhgGpaCrOeZ3GC9li2lSHa17blBe6+p8vAsI2c6BI9C6cWN61
jmVRKYv0GocrCHPHmepYB+gogqlcrW2xXtYuy78AgIIxDzoeWrUc547hITWuxVWL
oLLqQ41p/qXmZSqEgCkEcKTahIO7bok450XDRtW/+bgNaR8NzVou+7LPZBnSmRFR
km0FBl4VC4m/0MM0jk5zLOgs51MtQZBMp8Eo6b9iiyrrte0xewkBBZP+0q6usLTq
Kyzb4d0369mw7v2pjMylT5fOplrC+c13cvWScTgCBWAvR6/S4Iew8toxB12ElCC3
ii+izk69vKUREXP7AlDzZ9iVbjVZptXF2gJ5qIuZJ7sOa3ZI9HQ0WLKSa8PaZEnr
robn38F6oh0Ied7tG+JB0h7SPVQWBAXVCVn4LcRXP+O4vy9b9JWbmQLIzEM+9KkC
+TaQHBlk+/gQp4vl/cvElkCpR9QtSyA6OBOMEQlKCLx2TxWAL8Gx8YU5al6+QYPk
zbe39Gil600EStym6rTW3Jr36GaVZ/1b2KY5JZSyWhO36jAdRHc=
=nQwP
-----END PGP SIGNATURE-----
--=-=-=--
