From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Date: Tue, 27 Mar 2012 16:29:58 +0300
Message-ID: <1332854998.31549.40.camel@sauron.fi.intel.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
	 <20120322095342.GC14485@quack.suse.cz>
	 <1332410747.18717.12.camel@sauron.fi.intel.com>
	 <20120322103309.GA14484@quack.suse.cz>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-vxhLdacxcq0nWDR2x6N8"
Cc: Ted Tso <tytso@mit.edu>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:9306 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2C0N06 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Mar 2012 09:26:58 -0400
In-Reply-To: <20120322103309.GA14484@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-vxhLdacxcq0nWDR2x6N8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-03-22 at 11:33 +0100, Jan Kara wrote:
>   Then we have ext4_mark_super_dirty() call from 4 places - I forgot abou=
t
> these originally... I kind of miss their purpose. Originally they were us=
ed
> so that we write total number of free blocks and inodes in the superblock
> but when we do not maintain them in the journal mode I don't see a reason
> to periodically sync them in no-journal mode. Ted, what is the purpose of
> these calls?

I do not understand what's the fundamental difference between journal
and non-journal mode. Why when we do have the journal we do not mark the
super-block as dirty in many places (e.g., in 'ext4_file_open()' - if we
do have the journal, when do we make sure we save the mount point path
change?).

May be it has something to do with behaving like the ext2 driver when
mounting ext2-formatted media with the the ext4 driver?

Jan, since Ted did not answer, may be you can figure out the reasons
from this commit message, which actually introduced the
'ext4_mark_super_dirty()' function?


commit a0375156ca1041574b5d47cc7e32f10b891151b0
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jun 11 23:14:04 2010 -0400

    ext4: Clean up s_dirt handling
   =20
    We don't need to set s_dirt in most of the ext4 code when journaling
    is enabled.  In ext3/4 some of the summary statistics for # of free
    inodes, blocks, and directories are calculated from the per-block
    group statistics when the file system is mounted or unmounted.  As a
    result the superblock doesn't have to be updated, either via the
    journal or by setting s_dirt.  There are a few exceptions, most
    notably when resizing the file system, where the superblock needs to
    be modified --- and in that case it should be done as a journalled
    operation if possible, and s_dirt set only in no-journal mode.
   =20
    This patch will optimize out some unneeded disk writes when using ext4
    with a journal.
   =20
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

--=20
Best Regards,
Artem Bityutskiy

--=-vxhLdacxcq0nWDR2x6N8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPccDWAAoJECmIfjd9wqK0RwQP/jhyI57Vq3+itEGw8gX/SyFw
LjVaXBNpai7Iz1l7sHfuOBuRv58lTgjlxtFgJZm7799wcAvlV2LfGlbWwVIasGeM
gsEcGezF78SxaHC4tKH2XxVZGhmdq4psrcDo62ylK8R2jS7FAT516u/YaBrUtYlv
0cNLXR52HsebzPI1CXDXvgTtY+igyqM1KhGXFpNY2tuzh+xsGz1OgR+mhuF2fFRc
3wnHmp1G6ox879Y5ah4MGOyScgPjlJVwqKCFRhHaPCIVUN/fBsofKq+8MOvu6V+m
XLBO5cRJM30clLwNriOjAK32yB1pvK3SEM+kATP6hzML8S0Xc4S3aiz5eT9I+9is
z6az/qpxRukUe8Up+FvxWNn3MHu46M7QmusMhvsWNvnpAReZVRmxJb7Binh0YS3V
4OCgoHrf2eD4aOTcWxqY3LsI4cUnmUAGgtBRNLWSX/0vuwl8vD3YfyF/H+siiNJG
18X16R1eNL5qMHfUT06GQWNH4tLGV352c/qLsX5P4Bq5A3d9OsBN04PPa3ImIsA8
O7sen03k2pf9kr9Q5cMCQS70qapTv4HHEfu/02sje0od9OMvcsRZzl7vofuWMbFb
NdCIQbiAk3Z1mWjBF/Yx9tBOBp2NNqTvF7bc6bjQDzj1bPgopDzwWg+mkyGDJUr1
cVIEmeFO5fAJOFsTSP72
=wmNE
-----END PGP SIGNATURE-----

--=-vxhLdacxcq0nWDR2x6N8--

