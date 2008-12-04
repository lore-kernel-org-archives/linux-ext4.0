From: Valdis.Kletnieks@vt.edu
Subject: Re: [patch 101/104] ext3: dont try to resize if there are no reserved gdt blocks left
Date: Thu, 04 Dec 2008 17:07:55 -0500
Message-ID: <80912.1228428475@turing-police.cc.vt.edu>
References: <20081203193901.715896543@mini.kroah.org>
            <20081203195653.GX8950@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1228428475_3727P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Josef Bacik <jbacik@redhat.com>,
	linux-ext4@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: Greg KH <gregkh@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38843 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758363AbYLDWK0 (ORCPT
	<RFC822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2008 17:10:26 -0500
In-Reply-To: Your message of "Wed, 03 Dec 2008 11:56:53 PST."
             <20081203195653.GX8950@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--==_Exmh_1228428475_3727P
Content-Type: text/plain; charset=us-ascii

On Wed, 03 Dec 2008 11:56:53 PST, Greg KH said:

>  	if (reserved_gdb || gdb_off == 0) {
>  		if (!EXT3_HAS_COMPAT_FEATURE(sb,
> -					     EXT3_FEATURE_COMPAT_RESIZE_INODE))
{
> +					     EXT3_FEATURE_COMPAT_RESIZE_INODE)
> +		    || !le16_to_cpu(es->s_reserved_gdt_blocks)) {
>  			ext3_warning(sb, __func__,
>  				     "No reserved GDT blocks, can't resize");
>  			return -EPERM;

What's the codepath if the compat_feature part trips, but the le16_to_cpu
doesn't?  Looks to me like it will then skip over the 'return -EPERM'?

--==_Exmh_1228428475_3727P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJOFS7cC3lWbTT17ARAsHNAKC/zstxmr8vsP3AAE86P9tTrnkY8wCcC8w8
G4ZMM1J9NwNGBaFSiDov2t4=
=4uNx
-----END PGP SIGNATURE-----

--==_Exmh_1228428475_3727P--
