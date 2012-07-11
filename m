From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCHv6 3/5] ext4: remove unnecessary superblock dirtying
Date: Wed, 11 Jul 2012 13:24:19 +0300
Message-ID: <1342002259.18274.8.camel@sauron.fi.intel.com>
References: <1342000698-13556-1-git-send-email-dedekind1@gmail.com>
	 <1342000698-13556-4-git-send-email-dedekind1@gmail.com>
	 <20120711100726.GE1316@quack.suse.cz> <20120711101150.GH1316@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xi7At3cGn/3OTrdzKzol"
Cc: Theodore Tso <tytso@mit.edu>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120711101150.GH1316@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-xi7At3cGn/3OTrdzKzol
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 12:11 +0200, Jan Kara wrote:
> > > So case 2.b is a bit controversial, but I think it is acceptable. Aft=
er all, by
> > > enabling checksumming we already sign up for paying the price of calc=
ulating
> > > it. The way to improve checksumming performance globally would be to =
calculate
> > > it just before sending buffers to the I/O queue. We'd need some kind =
of
> > > call-back which could be registered by file-systems.
>   Actually, the most common case of adding orphan inode used
> ext4_handle_dirty_super_now() so for that case there is no difference. An=
d
> other cases are so rare it really does not matter... So there shouldn't b=
e
> any measurable difference.

Thank you, I'll take a closer look and possibly change the commit
message.

--=20
Best Regards,
Artem Bityutskiy

--=-xi7At3cGn/3OTrdzKzol
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/VRTAAoJECmIfjd9wqK05qAP/1NDgfwLYkmPLr+YxzDrreef
/4Om+BNCMv7rM7WedN9Lr718P2C0nf4BwcWy06jOFkK6htLwKrsiGvPO892BYLG0
22Gq/YRjuRPSJJt6z9yo92AuAia8aGc0mo6yeYR+/zlYGCNWiwZJ0g2IHNAhmHSn
MoJSpMilDp1hg4mgxCOgXqZM9cHPVMDrb0qErb3m4AONo2E0xTR621/M2yVTGKoW
bwLZG1xUymeSpK4KXWgMKvmYmM3q77pOqWDe5aqYn40H/1c00ME2/w3h1fbsK3ku
EfyBgxQDsyl8xzbvs5Rv+/921iME136bpUdJB3F8vRWZVDyb27rLdXMPCnrHCXRw
3s3qycVM4ZkRXygkfh5kc04cIkMFEULMuFS0+bqlgq6fKNxzMK4dkbkbhYDnKWEJ
wv8DLjy4UepZGknb//PdOQXw094ApA++Ai5w350EVkU7KgCcqI2VNpxCUpRpsABP
Ji3D0EdASDH6lJcQxmHPQN8ArXm6Q9UXT0w9Q5caB6hGTxEYPqaEWtFjIrSJdcuw
trwcn/RM4Vkm+hHMjqyysEXXwMliUu1PPlBxiLmdCiX6Py5973AN5k2Lgt7CcsBG
0ehmiwFXQyXniU4dsAXXH0nmxlz0fnrRg5Mx/58H/RMNe+6WCZjFFIEGnfJCP8nS
DhxkOWXAxt4qeABf/C7a
=xvRN
-----END PGP SIGNATURE-----

--=-xi7At3cGn/3OTrdzKzol--

