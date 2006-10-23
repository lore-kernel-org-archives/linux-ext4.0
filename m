From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFC] Ext3 online defrag
Date: Mon, 23 Oct 2006 11:29:06 -0600
Message-ID: <20061023172906.GO3509@schatzie.adilger.int>
References: <20061023122710.GA12034@atrey.karlin.mff.cuni.cz> <20061023141641.GA29649@thunk.org> <20061023151447.GL3509@schatzie.adilger.int> <20061023160310.GB11353@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:20623 "EHLO
	mail.clusterfs.com") by vger.kernel.org with ESMTP id S932193AbWJWR3L
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Oct 2006 13:29:11 -0400
To: Jan Kara <jack@suse.cz>
Content-Disposition: inline
In-Reply-To: <20061023160310.GB11353@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Oct 23, 2006  18:03 +0200, Jan Kara wrote:
> Andreas Dilger wrote:
> > I would in fact go so far as to allow only a single extent to be specified
> > per call.  This is to avoid the passing of any pointers as part of the
> > interface (hello ioctl police :-), and also makes the kernel code simpler.
> > I don't think the syscall/ioctl overhead is significant compared to the
> > journal and IO overhead.
>
> ...it makes it kind of
> harder to tell where indirect blocks would go - and it would be
> impossible for the defragmenter to force some unusual placement of
> indirect blocks...

It would be possible to specify indirect block relocation in same manner
as regular block relocation I think.  Allocate a new block, copy contents,
flush block from cache, fix up reference (inode, dindirect), commit.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
