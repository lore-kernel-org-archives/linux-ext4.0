From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH V6 18/30] fs: add read_iter and write_iter to several
 file systems
Date: Fri, 01 Feb 2013 09:51:09 +0200
Message-ID: <1359705069.32509.67.camel@sauron.fi.intel.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
 <1359476623-10544-19-git-send-email-dave.kleikamp@oracle.com>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0390823542547849066=="
Cc: jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>,
 Bob Copeland <me@bobcopeland.com>, linux-mtd@lists.infradead.org,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 linux-nilfs@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 Christoph Hellwig <hch@infradead.org>, v9fs-developer@lists.sourceforge.net,
 linux-ext4@vger.kernel.org, Prasad Joshi <prasadjoshi.linux@gmail.com>,
 "Maxim V.
 Patlasov" <mpatlasov@parallels.com>, Evgeniy Dushistov <dushistov@mail.ru>,
 user-mode-linux-devel@lists.sourceforge.net, Jeff Dike <jdike@addtoit.com>,
 reiserfs-devel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Joern Engel <joern@logfs.org>,
 "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
 linux-kernel@vger.kernel.org, logfs@logfs.org,
 Benny Halevy <bhalevy@tonian.com>, linux-fsdevel@vger.kernel.org,
 Andreas
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1359476623-10544-19-git-send-email-dave.kleikamp@oracle.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org


--===============0390823542547849066==
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-5GSqoZs9d0FHihhNTP/P"


--=-5GSqoZs9d0FHihhNTP/P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-29 at 10:23 -0600, Dave Kleikamp wrote:
> -       .aio_read =3D generic_file_aio_read,
> -       .aio_write =3D generic_file_aio_write,
> +       .read_iter =3D generic_file_read_iter,
> +       .write_iter =3D generic_file_write_iter,=20

The new names a lot less self-documenting than the old ones - I read
them as "read iteration", because "iter" is often used for "iteration",
and this gives me no clue that they are related to AIO...

I apologize if this was already discussed, but why did you choose
"iter"?

--=20
Best Regards,
Artem Bityutskiy

--=-5GSqoZs9d0FHihhNTP/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRC3PtAAoJECmIfjd9wqK0wRMQALvjuIWMlqGKDjYZ+Oc05zpM
umuYU9hx82FV8OzKkb0EBd2OZyhC5Eujwa2YO+oZUNrhabUexK1D7sTE8PY/mFKs
jPXtfieaMxyxZr38lM+bFVpbVg/3AHuXd4kUAodYWBR+6UwZt8WQ5MLn1RS1nUYl
Pki/4MO63nfikAL1va/Ruu3jgw4jZ3Bhr5K9Oa5rpE4YTHAtfwMFMP0DTNyt7r+s
PlgQtdVPvFTCiGcvdMtXAsKbAb0/3d7cQJdUPtoughEvfpdgkSDRTjaT4iGzx9iC
cBAYTK/jqSPg2jX0YmHv9NNjNZaPv6yXOq5DW/PpDDzVJyvKRLMfsGxcYgjqej0Q
0Ph5HjXyhHf+7emKFd9svAzfYapyVoX0AIna5FedSpab4lHTtB4ecydJMG9KgWi5
zebZ/ZVMmkg+mIs4VNBGIwKpgPebhUUJa1yaK/T2KbGj32y1QnRXdzLjYnMmx83L
QW+1su+bI4xQQVqsu4WkkfavCsk57nPsiOjSVzHl21RHlz2MkXCtumoHbbQCcrbO
w3EMCDfXFpjEUX4LpcRiyGHChs5gOZfQuPzP8OwmNUbhHNHX5wginXRnUN4+WFdy
SlryvuodGFXxHOlGJRb3WDZjE5ucOVc3FsKmdcbyrzcJ/QXtObvk89chzWD5fyrz
MijqIe/1hjIksBnGPx7F
=ay3H
-----END PGP SIGNATURE-----

--=-5GSqoZs9d0FHihhNTP/P--



--===============0390823542547849066==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/

--===============0390823542547849066==--
