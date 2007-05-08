From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] Restore backup superblocks in preen mode
Date: Tue, 8 May 2007 14:14:59 -0400
Message-ID: <20070508181459.GA31101@thunk.org>
References: <20070508174324.40EBE7B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Daniel Drake <ddrake@brontes3d.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33128 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967003AbXEHSPG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 May 2007 14:15:06 -0400
Content-Disposition: inline
In-Reply-To: <20070508174324.40EBE7B409F@zog.reactivated.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, May 08, 2007 at 06:43:24PM +0100, Daniel Drake wrote:
> The restoration of backup superblocks seems to be reversed in the current
> e2fsprogs:
> 
> When running without preen mode, e2fsck searches and locates a backup
> superblock and fixes the primary superblock without any user intervention.
> 
> When running in preen mode, e2fsck prints a message describing how the user
> can specify the location of a backup superblock, and exits without doing any
> repair.

That's intentional.  If the priumary superblock is wiped out,
something really bad has happened, and usually the first part of the
filesystem is gone too --- possibly including the first part of the
inode table, which would mean the root inode is gone.  So we do want
the user running e2fsck by hand.

We could argue about whether or not e2fsck should explicitly ask for
permission before using a backup superblock, and possibly printing the
label and validating the size, etc., before using it --- but we
definitely don't want to just blithly use a backup superblock when in
preen mode.

						- Ted
