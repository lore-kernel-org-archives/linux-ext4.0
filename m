From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Ext4 external journal UUID mismatch?
Date: Mon, 16 Jul 2012 11:40:46 -0400
Message-ID: <20120716154046.GB27656@thunk.org>
References: <20120715234058.GA2562@tuon.disenchant.local>
 <20120716025610.GB2562@tuon.disenchant.local>
 <11FEA6E4-EF75-4CD9-B2B6-78E42410027B@gmail.com>
 <20120716100010.GC2562@tuon.disenchant.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <aedilger@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Kevin Shanahan <kmshanah@disenchant.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39315 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab2GPPkt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 11:40:49 -0400
Content-Disposition: inline
In-Reply-To: <20120716100010.GC2562@tuon.disenchant.local>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 16, 2012 at 07:30:10PM +0930, Kevin Shanahan wrote:
> > The lookup of the journal by UUID (instead of relying on the "device
> > hint" in the superblock) _should_ be handled by mount, but I don't
> > recall if we ever got a mount.ext4 to handle this or not. It would
> > also be possible for the "fast e2fsck" check to verify the journal
> > UUID before mounting the filesystem, but again I'm not sure if this
> > is done yet, and I can't check right now.
> 
> Ok, thanks. For now I can ask LVM to make the major/minor number
> persistent.
> 
> Assuming it's not already done, do you think adding the UUID lookup
> would be a reasonable project for a newbie or is it likely to be a bit
> complicated?

We have a mount option.  You can specify it via a mount option, i.e.,

   -o journal_dev=0xFC02

It would be nice if the mount program (in util-linux) did a uuid
lookup using the blkid library if there was a mount option string of
the form "journal_dev=lookup".

I would certainly support getting a feature like that into mount
command, but it would be up to the maintainer of the util-linux
package to approve the specific patch.  Since it would require linking
in the ext2fs library, or putting in enough knowledge of the ext3/4
superblock to fetch the external journal uuid, I could imagine the
util-linux maintainer insisting that this be done in a helper program
(i.e., /sbin/mount.ext3 and /sbin/mount.ext4).  So it could
potentially get a little complicated, just to warn you ahead of time.

Regards,

					- Ted
