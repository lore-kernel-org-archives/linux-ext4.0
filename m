From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Thu, 1 Nov 2012 09:59:42 +0100
Message-ID: <20121101085942.GA6584@quack.suse.cz>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121027013524.GA19591@blackbox.djwong.org>
 <yq1ehkg8us1.fsf@sermon.lab.mkp.net>
 <20121030154844.1898f068@notabene.brown>
 <yq1a9v4884i.fsf@sermon.lab.mkp.net>
 <20121030201424.GD19559@blackbox.djwong.org>
 <20121031091441.5fc6b412@notabene.brown>
 <20121031085604.GC19591@blackbox.djwong.org>
 <20121031115614.GC18424@quack.suse.cz>
 <20121031193652.GF19591@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab2KAI7p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Nov 2012 04:59:45 -0400
Content-Disposition: inline
In-Reply-To: <20121031193652.GF19591@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 31-10-12 12:36:52, Darrick J. Wong wrote:
> On Wed, Oct 31, 2012 at 12:56:14PM +0100, Jan Kara wrote:
> >   I'd like to keep things simple. It's not hard to make all filesystems
> > support stable pages so let's just do that to remove one variable from the
> > picture. Then we are in the situation where storage can request stable
> > pages by setting bdi bit and filesystem will obey. Also filesystem itself can
> > request stable pages by setting the bit and generic functions in mm will
> > take that into account. No need for two flags...
> > 
> > You are right that we need a mechanism to push the flags from the devices
> > through various storage layers up into the bdi filesystem sees to make
> > things reliable.
> 
> md/dm will call blk_integrity_register, so pushing the "stable page writes
> required" flag through the various layers is already taken care of.  If devices
> and filesystems can both indicate that they want stable page writes,  I'll have
> to keep track of however many users there are.
  Oh, right. When the device is partitioned and more filesystems are used,
it would be reasonable to clear the flag when there are no stable-page
users. Actually, thinking more about this case, two flags would make things
more transparent. One flag will be in bdi and one in superblock. When
device needs stable pages, it sets bdi flag. If filesystem needs stable pages,
it sets the sb flag. This way we don't have to track any users.

I was thinking about transferring the flag from bdi to sb on mount so that
we can check only sb flag but that actually won't work because of writes
directly to the block device (all block device inodes share one
superblock).

Thoughts?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
