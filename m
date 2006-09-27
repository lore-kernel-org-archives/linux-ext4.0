From: Jens Axboe <axboe@kernel.dk>
Subject: Re: ext3 merge status
Date: Wed, 27 Sep 2006 13:34:51 +0200
Message-ID: <20060927113451.GA4073@suse.de>
References: <20060926134156.9c2f5c57.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@fys.uio.no>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:21056 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S932236AbWI0Ley (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Sep 2006 07:34:54 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20060926134156.9c2f5c57.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Sep 26 2006, Andrew Morton wrote:
>=20
> I'll plan on merging the following patches into Linus's tree this wee=
k:
>=20
> jbd-add-lock-annotation-to-jbd_sync_bh.patch
> ext3-and-jbd-cleanup-remove-whitespace.patch
> jbd-use-build_bug_on-in-journal-init.patch
> fix-ext3-mounts-at-16t.patch
> fix-ext3-mounts-at-16t-fix.patch
> fix-ext2-mounts-at-16t.patch
> fix-ext2-mounts-at-16t-fix.patch
> ext3-inode-numbers-are-unsigned-long.patch
> ext3-inode-numbers-are-unsigned-long-fix.patch
> jbd-16t-fixes.patch
> ext3-turn-on-reservation-dump-on-block-allocation-errors.patch
> ext3-add-more-comments-in-block-allocation-reservation-code.patch
> ext3-wrong-error-behavior.patch
> ext3-more-whitespace-cleanups.patch
> ext3-fix-sparse-warnings.patch
> more-ext3-16t-overflow-fixes.patch
> more-ext3-16t-overflow-fixes-fix.patch
> fs-conversions-from-kmallocmemset-to-kzcalloc.patch
> fs-removing-useless-casts.patch
> really-ignore-kmem_cache_destroy-return-value.patch
>=20
> Once that's done, the remaining patches touch on ext3:
>=20
> git-block.patch
> inode-diet-eliminate-i_blksize-and-use-a-per-superblock-default.patch
> vectorize-aio_read-aio_write-fileop-methods.patch
> remove-readv-writev-methods-and-use-aio_read-aio_write.patch
> fs-cache-provide-a-filesystem-specific-syncable-page-bit.patch
> r-o-bind-mount-unlink-monitor-i_nlink.patch
> r-o-bind-mount-prepwork-inc_nlink-helper.patch
> r-o-bind-mount-monitor-zeroing-of-i_nlink.patch
>=20
> These are harder.
>=20
> Jens needs to get a wiggle on with merging the block tree (please).

I had hoped that Linus would pull the block tree first, as I=B4m away o=
n
vacation this week and cannot fix this up until sunday when I=B4m back.
I=B4ll get right on it then.

--=20
Jens Axboe

-
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
