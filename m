From: Sylvain Rochet <gradator-XWGZPxRNpGHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
Date: Thu, 20 Aug 2009 19:19:53 +0200
Message-ID: <20090820171952.GA15133@gradator.net>
References: <20090725151751.GA6419@gradator.net> <20090727154253.GB8332@duck.suse.cz> <20090728112715.GA8442@gradator.net> <20090728135226.GA21682@duck.suse.cz> <20090728164142.GA13662@gradator.net> <20090803222901.GB23162@duck.suse.cz> <20090804111505.GA6433@gradator.net> <20090804225619.GB11097@duck.suse.cz> <20090806131555.GA23359@gradator.net> <20090812223453.GC10729@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Sylvain Rochet <gradator-XWGZPxRNpGHk1uMJSBkQmQ@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090812223453.GC10729-pwKtmJkCtMINMLpHRKhSow@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!,

On Thu, Aug 13, 2009 at 12:34:53AM +0200, Jan Kara wrote:
>   Hello,
>=20
> On Thu 06-08-09 15:15:56, Sylvain Rochet wrote:
> > > I have one idea what could cause your filesystem corruption, although=
=20
> > > it's a wild guess... Please try attached oneliner.
> >=20
> > Running since yesterday.
>=20
> Any news after a week of running? How often did the corruption happen
> previously?

Sorry for the late answer, I was lurking at HAR ;-)

So, everything is fine, but the problem happened only one time on this=20
server, so we cannot conclude anything after a few weeks. However,=20
I now have physical access back, so we will switch back to the former=20
server where the problem happened quite frequently, then we will see!

By the way, syslogd is happy, eating about 350 MiB of kernel logs a day ;)

Sylvain

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKjYW4DFub3qtEsS8RArIwAJ0bvebcBG9Yh4bqUGU/+jXb/zZojACeIfPM
y+UiPvD92jzujLIGcU+qsw8=
=FrVB
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
