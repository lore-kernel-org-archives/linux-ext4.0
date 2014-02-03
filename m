From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/3] libext2fs: allow clients to read-ahead metadata
Date: Mon, 3 Feb 2014 14:32:45 -0700
Message-ID: <0E88D038-7509-435F-BBAF-6A8416749785@dilger.ca>
References: <20140201103721.9011.5971.stgit@birch.djwong.org> <20140201103735.9011.14433.stgit@birch.djwong.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: multipart/signed; boundary="Apple-Mail=_CFED0F1C-5BDA-45BD-9FFD-462A4A91B78B"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:37793 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaBCVcs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Feb 2014 16:32:48 -0500
Received: by mail-pd0-f170.google.com with SMTP id p10so7387387pdj.29
        for <linux-ext4@vger.kernel.org>; Mon, 03 Feb 2014 13:32:48 -0800 (PST)
In-Reply-To: <20140201103735.9011.14433.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_CFED0F1C-5BDA-45BD-9FFD-462A4A91B78B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Feb 1, 2014, at 3:37 AM, Darrick J. Wong <darrick.wong@oracle.com> =
wrote:
> This patch adds to libext2fs the ability to pre-fetch metadata
> into the page cache in the hopes of speeding up libext2fs' clients.
> There are two new library functions -- the first allows a client to
> readahead a list of blocks, and the second is a helper function that
> uses that first mechanism to load group data (bitmaps, inode tables).
>=20
> e2fsck will employ both of these methods to speed itself up.
>=20
> diff --git a/lib/ext2fs/readahead.c b/lib/ext2fs/readahead.c
> new file mode 100644
> index 0000000..05f6135
> --- /dev/null
> +++ b/lib/ext2fs/readahead.c
> +errcode_t ext2fs_readahead(ext2_filsys fs, int flags, dgrp_t start,
> +			   dgrp_t ngroups)
> +{
> +
> +	for (i =3D start; i < end; i++) {
> =08+		if ((flags & EXT2FS_READ_ITABLE) &&
> +		    ext2fs_bg_free_inodes_count(fs, i) <
> +				fs->super->s_inodes_per_group) {
> +			super =3D ext2fs_inode_table_loc(fs, i);
> +			err =3D ext2fs_add_dir_block2(dblist, 0, super,
> +					fs->inode_blocks_per_group);

This prefetches all of the inode table blocks, when it could instead
just prefetch the in-use blocks using:

		if ((flags & EXT2FS_READ_ITABLE) &&
		    ext2fs_bg_itable_unused(fs, i) <
		    fs->inode_blocks_per_group))
			err =3D ext2fs_add_dir_block2(dblist, 0, super,
					fs->inode_blocks_per_group -=20
					ext2fs_bg_itable_unused(fs, i));

If there is corruption in the filesystem and the "unused" blocks need
to be read later it is probably more than offset by not reading those
actually unused blocks for the rest of the time.


Cheers, Andreas






--Apple-Mail=_CFED0F1C-5BDA-45BD-9FFD-462A4A91B78B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUvAK/XKl2rkXzB/gAQIqnBAAryl+4fH2t8uhH8NQv6zzcRCJLxIDGwpA
YUrmO8DgCp2jsNm1kSXiE1W+wqXR9KGkAoZrdy1ruS1cej5d2LNYl6XjpfGg+jWp
HQAfZ52BPIMEWG9qR8NJGFd46gdvctt/K3EAFJVpkNstqmKYSNycQKAHtlhsJcqH
Pr8kr0etcHix6/P8L32c7SLPElz8ftktqn9F7hsuRtqbQnrM2w2ZdyPO7HbVmSD4
Z/P8weyVScmq/IVtuso9FoCNFkp15ywxXpCvN1lvk/9JihMijLenXQ/FAG6WKp5X
wlu0jsgJ6IbAmBL2n2AJS0VTsYnBBH+2F7Vo+ulyPTz7301tByImXA9vjaz11zun
yBkxFvuSaDN94BNF3f2DhZ6eirE6xS1WOrsnitXwW4TgAh0aIXI7GYpN5XCCGBcc
z0mladmycVtSQNsg2GC0Q41xc5D7lyUStkPp3pKYj/jRSlHj16Kb2Y9G7Fuz0cdB
V0xxDJuylvYFoRNOld2h6q2Pv8iv2zgV2bCW94+7qdyuSd17aK76liwWYpoXDYs4
j0qarqXy3kle8z/JPdlBpXiKnhXjMzx8cnOmkmzQSA8eZVJkCkfbm+pPOJCYyeIy
E+t8HTIQQ1Bww+StYPugUsVRnekq9HXs1S2WJsX4BIz1zOrSvAE9DZWyfBA9pILb
eH2dlZYOp0o=
=EbGC
-----END PGP SIGNATURE-----

--Apple-Mail=_CFED0F1C-5BDA-45BD-9FFD-462A4A91B78B--
