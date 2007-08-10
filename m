From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] dir_index: error out instead of BUG on corrupt hash dir limit
Date: Fri, 10 Aug 2007 12:51:00 -0600
Message-ID: <20070810185100.GV6689@schatzie.adilger.int>
References: <46BB8830.3060009@redhat.com> <46BB9826.6040904@redhat.com> <20070810082904.GL6689@schatzie.adilger.int> <46BC8D61.9080400@redhat.com> <20070810181901.GT6689@schatzie.adilger.int> <46BCB0F5.5060701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:45942 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760425AbXHJSu6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Aug 2007 14:50:58 -0400
Content-Disposition: inline
In-Reply-To: <46BCB0F5.5060701@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 10, 2007  13:39 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > It would be interesting to check if mounting a dir_index filesystem on
> > linux with ext2 has the same problem.  It _should_ have been that 
> > if rec_len % 4 == 0 (i.e. any valid dirent) we would fail the hash_version
> > check, but we left in the DX_HASH_LEGACY (0) and that check is blown.
> 
> Hmmm...
> 
> > The unused_flags & 1 is only hit for a dirent with DT_FIFO (no good).
> > The remaining check is indirect_levels > 1, which should be hit for
> > any dirent with name_len > 1 (i.e. most, but not all).
> > 
> > So, I think you could reproduce this in linux by making an indexed directory
> > in ext3/4, mounting it as ext2, and then creating a 1-character filename
> > in the directory, or any length filename and then deleting it.
> 
> With those quick tests I don't see any problems... you may be giving the
> windows driver too much credit here.  :)

Ah, true - I forgot about the "EXT2_I(dir)->i_flags &= ~EXT2_BTREE_FL;"
line that has existed since time immemorial in ext2.  Isn't foresight
a wonderful thing.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
