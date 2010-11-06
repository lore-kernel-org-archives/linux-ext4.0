From: Tony Vroon <tony@linx.net>
Subject: Re: BUG in ext4 with 2.6.37-rc1
Date: Sat, 06 Nov 2010 01:06:50 +0000
Message-ID: <1289005610.2961.21.camel@localhost>
References: <20101102202013.GA3861@elliptictech.com>
	 <1288998589.2961.3.camel@localhost>
	 <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/dISZGFlckwavfyJqBRE"
Cc: Nick Bowler <nbowler@elliptictech.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:39969 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0KFBGl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Nov 2010 21:06:41 -0400
In-Reply-To: <0C557864-9D5C-45A3-8DDF-114E4DD22258@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-/dISZGFlckwavfyJqBRE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-11-05 at 20:33 -0400, Theodore Tso wrote:
> And if you have the stack trace easily to hand, it would be useful to mak=
e sure that part is the same as well.

Seemingly identical between 2.6.36-09452-g2d10d87 &
2.6.37-rc1-00040-g0660a9b, both had cvs as the active process.
This one is from 2.6.37-rc1-00040-g0660a9b:

Call Trace:
 [<ffffffff810e6716>] ? ext4_bio_write_page+0x176/0x30a
 [<ffffffff810e25db>] ? mpage_da_submit_io+0x2ad/0x31e
 [<ffffffff8106d034>] ? pagevec_lookup_tag+0x18/0x1f
 [<ffffffff810e5c56>] ? write_cache_pages_da+0xad/0x36d
 [<ffffffff810e5ac3>] ? mpage_da_map_and_submit+0x2c4/0x2da
 [<ffffffff810edbba>] ? ext4_journal_start_sb+0xd4/0x108
 [<ffffffff810269ac>] ? should_resched+0x5/0x26
 [<ffffffff810a2f26>] ? _cond_resched+0x9/0x1e
 [<ffffffff810e61ee>] ? ext4_da_writepages+0x2d8/0x422
 [<ffffffff810b3471>] ? __getblk+0x1c/0x2d4
 [<ffffffff81065cad>] ? __filemap_fdatawrite_range+0x48/0x4d
 [<ffffffff810ff15c>] ? jbd2_journal_begin_ordered_truncated+0x72/0x9b
 [<ffffffff810bb060>] ? fsnotify_clear_marks_by_inode+0x8a/0xc7
 [<ffffffff810e5359>] ? ext4_evict_inode+0x56/0x241
 [<ffffffff810a4c62>] ? evict+0x1a/0x89
 [<ffffffff810a51dd>] ? iput+0x20d/0x246
 [<ffffffff8109d85f>] ? do_unlinkat+0xf4/0x14c
 [<ffffffff810029ab>] ? system_call_fastpath+0x16/0x1b

> Many thanks,
> -- Ted

Regards,
--=20
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net

--=-/dISZGFlckwavfyJqBRE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkzUqioACgkQp5vW4rUFj5ps9QCeJRcBiMJYexxD6f6ythERnl+4
1IgAnj49QxepY6RDd2PqLGRG6V/unFkD
=R7hZ
-----END PGP SIGNATURE-----

--=-/dISZGFlckwavfyJqBRE--

