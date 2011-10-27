From: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH V1 00/17] ext4: Add inline data support.
Date: Thu, 27 Oct 2011 03:10:22 -0400
Message-ID: <7941.1319699422@turing-police.cc.vt.edu>
References: <4EA7B788.3040503@tao.ma>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1319699422_3371P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger@dilger.ca>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: Your message of "Wed, 26 Oct 2011 15:32:24 +0800."
             <4EA7B788.3040503@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--==_Exmh_1319699422_3371P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Oct 2011 15:32:24 +0800, Tao Ma said:

> Currently I use all the space between i_extra_isize and inode_size if
> inode_size = 256. For inode_size > 256, half of that space is used so as
> to leave some space for other xattrs.

I didn't check the code too closely - does this code DTRT if the user tries to
then attach a moby-sized xattr (or set of xattrs - if it's got a security.selinux
tag on it, and a security.capabilities xattr, and a user xattr or two, things are
going to be getting full).

> This is only a V1 and there are still something to do(e.g. I am thinking
> of using unused extent space), but I'd like to send it out earlier so
> that it can be reviewed ASAP.

If this works out, would it make sense to investigate doing this for all
tails in a V2?  So if your file was 4099 bytes long, you could save allocating
a second block.  Assuming random distribution of tail sizes, this wil save
an average of (space avail for tail)/(blocksize) per file.

--==_Exmh_1319699422_3371P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOqQPecC3lWbTT17ARAuHkAKCj3CNruCkDhLu8No83GgQQwl4iogCgghAR
DGtFIx2AfT8RBBJ3T+agO7A=
=DGK7
-----END PGP SIGNATURE-----

--==_Exmh_1319699422_3371P--
