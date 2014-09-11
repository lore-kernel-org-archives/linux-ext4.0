From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 23/25] ext2fs: add readahead method to improve scanning
Date: Thu, 11 Sep 2014 17:10:31 -0400
Message-ID: <20140911211031.GA17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140908231408.25904.47150.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52055 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbaIKVKg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 17:10:36 -0400
Content-Disposition: inline
In-Reply-To: <20140908231408.25904.47150.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 08, 2014 at 04:14:08PM -0700, Darrick J. Wong wrote:
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
> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  lib/ext2fs/ext2_io.h    |    8 +++++++-
>  lib/ext2fs/io_manager.c |    9 +++++++++
>  lib/ext2fs/unix_io.c    |   27 ++++++++++++++++++++++++---
>  3 files changed, 40 insertions(+), 4 deletions(-)

Could you also plumb through the new method in test_io.c?  Because we
often use this to interposed between mke2fs or e2fsprogs and unix_io.c
for debugging purposes.

Thanks!

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
