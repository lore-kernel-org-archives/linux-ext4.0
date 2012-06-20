From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Minimal configuration for e2fsprogs
Date: Wed, 20 Jun 2012 08:14:21 -0600
Message-ID: <2314E505-27E8-4FA7-8034-4CE3F6CAA138@dilger.ca>
References: <20120615042421.GA7021@thor.bakeyournoodle.com> <20120616000825.GE7363@thunk.org> <20120618055836.GA30557@thor.bakeyournoodle.com> <20120618171257.GA16017@thunk.org> <20120619054751.GA2660@thor.bakeyournoodle.com> <86585638-21F5-4FEE-9313-28AC122FCCEE@dilger.ca> <20120619135610.GA10637@thunk.org> <20120620052604.GB11330@thor.bakeyournoodle.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-154--1030274518"
Content-Transfer-Encoding: 7bit
Cc: Ted Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Tony Breeds <tony@bakeyournoodle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:33318 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2FTOOX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2012 10:14:23 -0400
In-Reply-To: <20120620052604.GB11330@thor.bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-154--1030274518
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii

On 2012-06-19, at 11:26 PM, Tony Breeds wrote:
> From 5f6a6528c93ad9b3eb878afbeab10c01802647b0 Mon Sep 17 00:00:00 2001
> From: Tony Breeds <tony@bakeyournoodle.com>
> Date: Wed, 20 Jun 2012 15:04:43 +1000
> Subject: [PATCH] WiP: Add --disable-mmp
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> ---
> configure.in         |   17 +++++++++++++++++
> debugfs/debugfs.c    |    5 +++++
> debugfs/set_fields.c |    5 +++++
> lib/config.h.in      |    3 +++
> lib/ext2fs/ext2fs.h  |   23 ++++++++++++-----------
> lib/ext2fs/mmp.c     |   24 ++++++++++++++++++++++++
> 6 files changed, 66 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
> index bb3772d..a783698 100644
> --- a/lib/ext2fs/mmp.c
> +++ b/lib/ext2fs/mmp.c
> @@ -33,6 +33,9 @@
> 
> errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
> {
> +#ifndef CONFIG_MMP
> +	return EXT2_ET_OP_NOT_SUPPORTED;
> +#endif
> 	struct mmp_struct *mmp_cmp;
> 	errcode_t retval = 0;

I suspect that this will cause warnings from code analysis tools about
dead code, and bloat the code if the compiler isn't optimizing heavily.
Better to put the whole function body inside "#ifdef CONFIG_MMP" and
the "return EXT2_ET_OP_NOT_SUPPORTED" in the #else clause.

Cheers, Andreas






--Apple-Mail-154--1030274518
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iD8DBQFP4dq+pIg59Q01vtYRAgFPAJ4pyOr84/NINoPzvqXca0CVSYgoZQCg1fDc
zF9AFZp0pOXNEBUdoNa89G0=
=ezWL
-----END PGP SIGNATURE-----

--Apple-Mail-154--1030274518--
