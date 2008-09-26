From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Fri, 26 Sep 2008 08:35:25 -0400
Message-ID: <35472.1222432525@turing-police.cc.vt.edu>
References: <20080908205337t-sato@mail.jp.nec.com>
	<20080908171119.GB22521@infradead.org>
	<48DBFD42.6030307@redhat.com>
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1342194515=="
Cc: axboe@kernel.dk, mtk.manpages@googlemail.com, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
	dm-devel@redhat.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
	Oleg Nesterov <oleg@tv-sign.ru>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Fri, 26 Sep 2008 17:52:35 +0900."
	<D0B0D91F884647D6808626CDFF81E532@nsl.ad.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

--===============1342194515==
Content-Type: multipart/signed; boundary="==_Exmh_1222432525_7097P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1222432525_7097P
Content-Type: text/plain; charset=us-ascii

On Fri, 26 Sep 2008 17:52:35 +0900, Takashi Sato said:

(Sorry, am reading the threads out of temporal sequence....)

> I think that your concern is that the freezer cannot recognize the occurrence
> of a timeout and it continues the backup process and the backup data is
> corrupted finally.
> If the freezer can recognize it by the unfreeze ioctl's errono, will your concern
>  be solved?
> If so, I will implement it.

That would also address my concerns about merging patches 8 and 10 of the
other patch series (because patch 10 wouldn't be needed then)...


--==_Exmh_1222432525_7097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI3NcNcC3lWbTT17ARAlfSAJ9koC6IkAWpTwgQQzzxs0CHDfWf6ACgzm8C
gDUF+0x2+mjqNZBumGOhqOA=
=x5uP
-----END PGP SIGNATURE-----

--==_Exmh_1222432525_7097P--


--===============1342194515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1342194515==--
