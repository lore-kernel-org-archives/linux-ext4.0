From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Use EXT4_BOOT_LOADER_INO for boot loader GRUB?
Date: Sat, 26 Jan 2013 13:49:27 -0500
Message-ID: <20130126184927.GB20005@thunk.org>
References: <51023FEA.7000802@reinform.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Dr. Tilmann Bubeck" <t.bubeck@reinform.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45604 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3AZStb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 26 Jan 2013 13:49:31 -0500
Content-Disposition: inline
In-Reply-To: <51023FEA.7000802@reinform.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2013 at 09:18:50AM +0100, Dr. Tilmann Bubeck wrote:
> The basic problem is, that GRUB needs a safe place to store
> (currently 32k) for its boot loader "core.img". That place should be
> simple to find from the primary boot code ("stage1") and the place
> should be safe for user intervention.
> 
> QUESTION:
> 
> You have reserved a special inode #5 called "EXT4_BOOT_LOADER_INO".
> Is this inode currently used or supported by kernel or user land?
> What is the idea of this inode?

It was basically for something exactly like this.  :-)

> PROPOSAL:
> 
> I can think of using that inode to store the file "core.img" of
> GRUB. That file is used by GRUB to boot and the block list of that
> file is stored in GRUB when using "--force" to override the above
> error.
> 
> ext2/3/4 must make sure, that the block list of that file never
> changes. I propose an additional EXT4 ioctl to tell ext4, which file
> to store in EXT4_BOOT_LOADER_INO.

What I'm thinking about is a new ioctl that would swap the i_block and
i_blocks array of the BOOT_LOADER_INO and the file descriptor.  That
is, if there were any blocks attached to the boot_loader_ino, they
would become attached to the inode associated with the file
descriptor, and the blocks associated with that inode would be
attached to inode #5.

> Probably there must be more changes to e2fsck and friends.

Actually, no changes to e2fsck would be necessary.  The original plan
was that boot loader inode would be installed while the file system is
unmounted.  But it's already the case that blocks associated with
inode <5> are already accounted for by e2fsck.

      	      	      		       - Ted
