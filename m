From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide
 stable pages during write
Date: Thu, 27 Dec 2012 13:40:29 -0800
Message-ID: <20121227210543.GA20103@blackbox.djwong.org>
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
 <20121213080811.23360.98131.stgit@blackbox.djwong.org>
 <877go3z4ra.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
	martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
	bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44680 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2L0Vmd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 Dec 2012 16:42:33 -0500
Content-Disposition: inline
In-Reply-To: <877go3z4ra.fsf@devron.myhome.or.jp>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 28, 2012 at 04:14:49AM +0900, OGAWA Hirofumi wrote:
> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
> 
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index 780d4c6..0144fbb 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -69,6 +69,7 @@ struct inodes_stat_t {
> >  #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
> >  #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
> >  #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
> > +#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
> >  #define MS_NOATIME	1024	/* Do not update access times. */
> >  #define MS_NODIRATIME	2048	/* Do not update directory access times */
> >  #define MS_BIND		4096
> 
> I think this flag should be separated into "FS provide stable page" and
> "FS needs bounce buffer for stable page".
> 
> My fs (I guess btrfs also) provides stable page by better way, and
> doesn't need to wait writeback flags too. What needs is just to avoid
> those stable page stuff.

How does your fs (are we talking about vfat?) provide stable pages?

btrfs creates its own bdi and doesn't set the "stable pages required" flag, so
it already skips all the stable page stuff.

--D
> 
> Thanks.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
