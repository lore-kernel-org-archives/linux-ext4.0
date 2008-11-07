From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add checksum calculation when clearing UNINIT
	flag
Date: Fri, 7 Nov 2008 09:38:06 -0500
Message-ID: <20081107143806.GD9543@mit.edu>
References: <1226053376.3542.8.camel@frecb007923.frec.bull.fr> <20081107135222.GB9543@mit.edu> <20081107142718.GL25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37011 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752058AbYKGOiM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 09:38:12 -0500
Content-Disposition: inline
In-Reply-To: <20081107142718.GL25194@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 07:57:18PM +0530, Aneesh Kumar K.V wrote:
> On Fri, Nov 07, 2008 at 08:52:22AM -0500, Theodore Tso wrote:
> > On Fri, Nov 07, 2008 at 11:22:56AM +0100, Fr=E9d=E9ric Boh=E9 wrote=
:
> > > From: Frederic Bohe <frederic.bohe@bull.net>
> > >=20
> > > Block group's checksum need to be re-calculated during the
> > > initialization of an UNINIT'd group. This fix a race when several
> > > threads try to allocate a new inode in an UNINIT'd group.
> >=20
> > This patch looks sane, and so I'll accept it, but there's a higher
> > order hiding here ---- why are we initializing the block bitmap in
> > ext4_new_inode()?  Sure, *most* of the time where we create a new
> > inode, we'll be needing to allocate a new block, but sometimes we
> > won't (i.e., when creating a symlink, device file, socket, or a
> > zero-length regular file). =20
>=20
> Because when we clear the uninitt_bg flag the kernel expect the block=
=20
> bitmap to be correctly indicate blocks containing block
> bitmap and inode bitmap as used. If mke2fs didn't do that we would
> need to do the same when we remove the uninit_bg flag.

We have separate flags inidicating whether the block allocation bitmap
and inode allocation bitmaps are initialized or not,
EXT4_BG_BLOCK_UNINIT, and EXT4_BG_INODE_UNINIT, respectively.  So what
I am proposing is to not initialize the block bitmap in
ext4_new_inode(), and not to clear the EXT4_BG_BLOCK_UNINIT flag, eithe=
r.

		  		      	     	       - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
