From: coly <colyli@gmail.com>
Subject: Re: confused on different inode size
Date: Mon, 09 Apr 2007 10:33:13 +0800
Message-ID: <1176085993.4101.6.camel@colyT43.site>
References: <1176014343.20429.6.camel@colyT43.site>
	 <20070408175218.GB29180@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:58119 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXDIC3e (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Apr 2007 22:29:34 -0400
Received: by py-out-1112.google.com with SMTP id a29so924479pyi
        for <linux-ext4@vger.kernel.org>; Sun, 08 Apr 2007 19:29:33 -0700 (PDT)
In-Reply-To: <20070408175218.GB29180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore:

Thanks for your replying.=20

Can I understand this way:
* Though sizeof(struct ext4_inode) is 152, the real inode size on disk
still depends on mount options.
* If use old inode size, the on disk inode will be 128 bytes.
* If use new inode size(e.g. extent option in mount), the on disk inode
will be 256, or more bytes.
* If on disk inode size is 128 bytes, only first 128 bytes of struct
ext4_inode take effects.

Best regards.

Coly

=E5=9C=A8 2007-04-08=E6=97=A5=E7=9A=84 13:52 -0400=EF=BC=8CTheodore Tso=
=E5=86=99=E9=81=93=EF=BC=9A
> On Sun, Apr 08, 2007 at 02:39:03PM +0800, coly wrote:
> > Hi, list:
> >=20
> > I find size of struct ext4_inode is 152 bytes, but from the dumpe2f=
s, it
> > tells me the inode size is 128 bytes.
> >=20
> > I am confused that, the ext4_inode is the on-disk inode format, so =
how
> > can dumpe2fs tells the inode size is 128 bytes.
> >=20
> > Further more, when I use sb_bread() to read inode from inode table =
(with
> > 152 bytes inode size), I can not read proper data from the bh->b_da=
ta.
> > Once I use 128 bytes inode size, I can read what I want from the
> > bh->b_data.
>=20
> The inode size for ext4 filesystems can be multiple sizes; the
> traditional ext2/ext3 inode size is 128 bytes.  If so, then you won't
> have any of the features that require inode fields starting at
> i_extra_isize.  If you use an inode size of 256 bytes, then you will
> be able to use nanosecond granularity timestamps, and the extra space
> (256-152 bytes) can be used for fast access to extended attributes.
> If there is an expectation that the filesystem will need a larger
> amount of space for extended attributes, the filesystem can be
> formatted with 512, 1024, or even larger sizes (so long as it is a
> power of two >=3D 128 bytes).
>=20
> 					- Ted
