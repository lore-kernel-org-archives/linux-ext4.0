From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add checksum calculation when clearing UNINIT
	flag
Date: Fri, 7 Nov 2008 08:52:22 -0500
Message-ID: <20081107135222.GB9543@mit.edu>
References: <1226053376.3542.8.camel@frecb007923.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:38275 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751449AbYKGNwY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 08:52:24 -0500
Content-Disposition: inline
In-Reply-To: <1226053376.3542.8.camel@frecb007923.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 07, 2008 at 11:22:56AM +0100, Fr=E9d=E9ric Boh=E9 wrote:
> From: Frederic Bohe <frederic.bohe@bull.net>
>=20
> Block group's checksum need to be re-calculated during the
> initialization of an UNINIT'd group. This fix a race when several
> threads try to allocate a new inode in an UNINIT'd group.

This patch looks sane, and so I'll accept it, but there's a higher
order hiding here ---- why are we initializing the block bitmap in
ext4_new_inode()?  Sure, *most* of the time where we create a new
inode, we'll be needing to allocate a new block, but sometimes we
won't (i.e., when creating a symlink, device file, socket, or a
zero-length regular file).  More seriously, we don't account for the
potential need for an extra journal credit in all of the callers for
ext4_new_inode().  Obviously this doesn't get us in trouble because we
generally massively overestimate the number of journal credits we need
--- but from the point of view of code simplification, maybe code
block to ininitialize the block bitmap in ext4_new_inode() should be
dropped entirely.

We have to do the exact same check in the mballoc.c when we actually
allocate blocks --- and in that case we know we'll be modifying the
block bitmap, so there's no need to first initialize the block bitmap
in ext4_new_inode(), only to need to request to redirty that same
block bitmap in mballoc.c when we are really allocating data for the
inode.

Does that make sense for a future cleanup?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
