From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Thu, 1 Nov 2012 23:42:16 +0100
Message-ID: <20121101224216.GA31937@quack.suse.cz>
References: <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
 <20121030154844.1898f068@notabene.brown>
 <yq1a9v4884i.fsf@sermon.lab.mkp.net>
 <20121030201424.GD19559@blackbox.djwong.org>
 <20121031091441.5fc6b412@notabene.brown>
 <20121031085604.GC19591@blackbox.djwong.org>
 <20121031115614.GC18424@quack.suse.cz>
 <20121031193652.GF19591@blackbox.djwong.org>
 <20121101085942.GA6584@quack.suse.cz>
 <5092B060.9070604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762442Ab2KAWmS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2012 18:42:18 -0400
Content-Disposition: inline
In-Reply-To: <5092B060.9070604@panasas.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 01-11-12 10:24:48, Boaz Harrosh wrote:
> On 11/01/2012 01:59 AM, Jan Kara wrote:
> <>
> > (all block device inodes share one superblock).
> > 
> 
> Really? that is not so good is it, for other obvious reasons. 
> Why is it not one superblock per BDI? That would be more obvious
> to me.
> 
> > Thoughts?
> 
> It's a really bad design. I think it is worth fixing. For the above
> problem, as well as a much better fit with our current thread-per-bdi,
> and the rest of the Kernel model. No?
  So the fact that there is one superblock of virtual filesystem containing
all block device inodes is inconvenient at times (that's why we have to
have inode_to_bdi() function in fs/fs-writeback.c) but OTOH you cannot
really attach these virtual block device inodes (note that these are
different from an inode for an object say /dev/sda in the filesystem)
anywhere else and having one sb per block device would really be an
overkill.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
