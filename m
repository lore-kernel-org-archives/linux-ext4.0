From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Wed, 24 Jul 2013 19:36:28 -0400
Message-ID: <20130724233628.GD3641@logfs.org>
References: <1374699833.7083.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dhaval Giani <dgiani@mozilla.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59897 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3GYBIX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Jul 2013 21:08:23 -0400
Content-Disposition: inline
In-Reply-To: <1374699833.7083.2.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 July 2013 17:03:53 -0400, Dhaval Giani wrote:
>=20
> I am posting this series early in its development phase to solicit so=
me
> feedback.

At this state, a good description of the format would be nice.

> We are implementing transparent decompression with a focus on ext4. O=
ne
> of the main usecases is that of Firefox on Android. Currently libxul.=
so
> is compressed and it is loaded into memory by a custom linker on
> demand. With the use of transparent decompression, we can make do
> without the custom linker. More details (i.e. code) about the linker =
can
> be found at https://github.com/glandium/faulty.lib

It is not quite clear what you want to achieve here.  One approach is
to create an empty file, chattr it to enable compression, then write
uncompressed data to it.  Nothing in userspace will ever know the file
is compressed, unless you explicitly call lsattr.

If you want to follow some other approach where userspace has one
interface to write the compressed data to a file and some other
interface to read the file uncompressed, you are likely in a world of
pain.

Assuming you use the chattr approach, that pretty much comes down to
adding compression support to ext4.  There have been old patches for
ext2 around that never got merged.  Reading up on the problems
encountered by those patches might be instructive.

J=C3=B6rn

--
I've never met a human being who would want to read 17,000 pages of
documentation, and if there was, I'd kill him to get him out of the
gene pool.
-- Joseph Costello
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
