From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] Add support for new compat feature "one_backup_sb"
Date: Mon, 13 Jan 2014 09:06:45 -0500
Message-ID: <20140113140645.GC18029@thunk.org>
References: <1389497029-10488-1-git-send-email-tytso@mit.edu>
 <20140113132707.GA22358@orion.maiolino.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47992 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaAMOGs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 09:06:48 -0500
Content-Disposition: inline
In-Reply-To: <20140113132707.GA22358@orion.maiolino.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 13, 2014 at 11:27:08AM -0200, Carlos Maiolino wrote:
> I'm not really a big fan of removing more backup metadata blocks
> than we already have with the sparse_super feature, but, giving the
> SMR writing system, this might save the filesystem from a lot of
> fragmentation when updating the backup superblocks.

Not only that, but the backup superblocks become extra things for the
SMR subsystem to have to copy around.

> I'm just wondering if it might not be interesting in still have the
> backup superblock into the last block group, but I'm not really sure
> about the concerns it might have when resizing a filesystem. This
> might add more problems than the benefits :)

Yes, I thought about putting the backup superblock either at the very
last block group, or at the very end of the file system (which would
avoid further fragmentation).  Either way, it adds a lot more
complications, and realistically, have you ever actually seen a user
take advantage of a backup superblock other than the one at block
#32768?

Still, it is something we could do, if we really thought it would
help.  My original thought was that keeping things simple was better
than adding more complexity, especially if the vast majority of users
would never take advantage of such a feature, and given that everyone
is trained to know that a backup superblock is always available at
32768, so we really want to have one there regardless.  Given that, is
having a third backup superblock at the end of the disk really going
to provide that much additional safety?

							 -Ted

P.S.  If we want to have extra copies of the backup blocks, we could
also use e2image to make additional backup copies; we could even a
future version of mke2fs place a copy of the e2image file at the very
of the file system, if we really thought it would be helpful later on.
If we thought it was really required, we should do it now, of course.
I'm just not entirely sure it's worth the extra hair, either way.  I'm
curious to hear what other people think.
