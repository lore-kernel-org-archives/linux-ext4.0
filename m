From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] tune2fs: fix uninitialized variable in
 remove_journal_device
Date: Fri, 1 Aug 2014 21:32:06 -0400
Message-ID: <20140802013206.GC27252@thunk.org>
References: <53DA5DDC.1020703@redhat.com>
 <1406821994-19600-1-git-send-email-tytso@mit.edu>
 <6FF7A658-00C4-4185-A182-E9895E704A3E@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Azat Khuzhin <a3at.mail@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41227 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHBBcM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Aug 2014 21:32:12 -0400
Content-Disposition: inline
In-Reply-To: <6FF7A658-00C4-4185-A182-E9895E704A3E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2014 at 08:38:30AM +0200, Andreas Dilger wrote:
> >    /* Write back the journal superblock */
> > -    if ((retval = io_channel_write_blk64(jfs->io, start,
> > -        -SUPERBLOCK_SIZE, buf))) {
> > +    if ((retval = io_channel_write_blk64(jfs->io,
> > +                ext2fs_journal_sb_start(fs->blocksize),
> > +                -SUPERBLOCK_SIZE, buf))) {
> 
> Better to also remove assignment in conditional check. 

Good point, done.

						- Ted
