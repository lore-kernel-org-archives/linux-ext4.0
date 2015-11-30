From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fuse2fs: set inode's uid/gid when creating inode
Date: Mon, 30 Nov 2015 18:28:57 -0500
Message-ID: <20151130232857.GI4316@thunk.org>
References: <20151123205620.GA10580@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Lennart =?iso-8859-1?Q?L=F6vstrand?= <lennart@lovstrand.com>,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58713 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbbK3X3F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Nov 2015 18:29:05 -0500
Content-Disposition: inline
In-Reply-To: <20151123205620.GA10580@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 23, 2015 at 12:56:20PM -0800, Darrick J. Wong wrote:
> When creating a file in op_create, set the file's uid and gid to the
> user's uid and gid.  Do the same in op_mknod.
>=20
> Reported-by: Lennart L=F6vstrand <lennart@lovstrand.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
