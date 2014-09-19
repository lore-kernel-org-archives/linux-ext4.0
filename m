From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 07/34] ext2fs: add readahead method to improve scanning
Date: Fri, 19 Sep 2014 12:15:42 -0400
Message-ID: <20140919161542.GM26995@thunk.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
 <20140913221158.13646.41794.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37761 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaISQPr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Sep 2014 12:15:47 -0400
Content-Disposition: inline
In-Reply-To: <20140913221158.13646.41794.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 13, 2014 at 03:11:58PM -0700, Darrick J. Wong wrote:
> Fr=F8m: Andreas Dilger <adilger@whamcloud.com>
>=20
> Add a readahead method for prefetching ranges of disk blocks.  This i=
s
> useful for inode table scanning, and other large contiguous ranges of
> blocks, and may also prove useful for random block prefetch, since it
> will allow reordering of the IO without waiting synchronously for the
> reads to complete.
>=20
> It is currently using the posix_fadvise(POSIX_FADV_WILLNEED)
> interface, as this proved most efficient during our testing.
>=20
> [darrick.wong@oracle.com]
> Make the arguments to the readahead function take the same ULL values
> as the other IO functions, and return an appropriate error code when
> fadvise isn't available.
>=20
> v2: Plumb in test_io.c for cache readahead.
>=20
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
