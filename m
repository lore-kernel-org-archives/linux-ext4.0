From: Jan Kara <jack@suse.cz>
Subject: Re: ext3/4, btrfs, ocfs2: How to assure that
 cleancache_invalidate_fs is called on every superblock free
Date: Mon, 12 Mar 2012 14:38:25 +0100
Message-ID: <20120312133825.GF5998@quack.suse.cz>
References: <CACQs63L2wfXKaD5sH6OOV+Bm_+37F3QOdt1QMFbWnB9AE4iCpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	dan.magenheimer@oracle.com, fschmaus@gmail.com, linux-mm@kvack.org,
	ilendir@googlemail.com, sjenning@linux.vnet.ibm.com,
	konrad.wilk@oracle.com, i4passt@lists.informatik.uni-erlangen.de,
	ngupta@vflare.org
To: Andor Daam <andor.daam@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2CLNi2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Mar 2012 09:38:28 -0400
Content-Disposition: inline
In-Reply-To: <CACQs63L2wfXKaD5sH6OOV+Bm_+37F3QOdt1QMFbWnB9AE4iCpA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 09-03-12 14:40:22, Andor Daam wrote:
> Is it ever possible for a superblock for a mounted filesystem to be
> free'd without a previous call to unmount the filesystem?
  No, I don't think so (well, except for cases where we do not manage to
fully setup the superblock). But be aware that mount/umount need not be
really the entry points you are looking for since filesystem can be mounted
several times. Rather deactivate_locked_supers() is the place you are
looking for...

> I need to be certain that the function cleancache_invalidate_fs, which is
> at the moment called by deactivate_locked_super (fs/super.c) [1], is
> called before every free on a superblock of cleancache-enabled
> filesystems.  Is this already the case or are there situations in which
> this does not happen?
> 
> It would be interesting to know this, as we are planning to have
> cleancache save pointers to superblocks of every mounted
> cleancache-enabled filesystem [2] and it would be fatal if a
> superblock is free'd without cleancache being notified.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
