From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide stable pages during write
Date: Fri, 28 Dec 2012 04:14:49 +0900
Message-ID: <877go3z4ra.fsf@devron.myhome.or.jp>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
	<20121213080811.23360.98131.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org> (Darrick
	J. Wong's message of "Thu, 13 Dec 2012 00:08:11 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 780d4c6..0144fbb 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -69,6 +69,7 @@ struct inodes_stat_t {
>  #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
>  #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
>  #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
> +#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
>  #define MS_NOATIME	1024	/* Do not update access times. */
>  #define MS_NODIRATIME	2048	/* Do not update directory access times */
>  #define MS_BIND		4096

I think this flag should be separated into "FS provide stable page" and
"FS needs bounce buffer for stable page".

My fs (I guess btrfs also) provides stable page by better way, and
doesn't need to wait writeback flags too. What needs is just to avoid
those stable page stuff.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
