From: Ted Ts'o <tytso@mit.edu>
Subject: Re: e2image doesn't get backup superblocks?
Date: Mon, 20 Feb 2012 14:05:35 -0500
Message-ID: <20120220190535.GA6541@thunk.org>
References: <4F42683F.3070409@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60528 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2BTTFi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Feb 2012 14:05:38 -0500
Content-Disposition: inline
In-Reply-To: <4F42683F.3070409@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2012 at 10:35:27AM -0500, Phillip Susi wrote:
> 
> I've noticed that e2image doesn't get the backup superblocks and group
> descriptors.  Is this intentional or an oversight?  

It's deliberate.  I suppose it might be useful if you are using
e2image -r to make a copy of a corrupted file system, where the
primary superblocks are corrupted.  It's probably reasonable to save a
copy of the first backup superblock just so that e2fsck run on the raw
image mimicks what you'd see if you were running on the same file
system.   I'd accept a patch to do this.

> Is there a way to resync the backups from the master copy?  e2fsck
> doesn't seem to do it.

Why do you want to do this?  In general the tools will automatically
sync the backups from the master if it is necessary (i.e., in the case
of a file system resize, or if there is a change in the file system
features).  Otherwise, we deliberately try to avoid modifying the
backups, since any updates to the backups is an opportunity to copy
corrupted values to the backups, or otherwise risk write failures that
could smash the backups.

But if you really do want to copy the master superblock and block
descriptor blocks ot backups, you can do it via the following:

debugfs -w /dev/sdb1
debugfs: dirty
debugfs: close -a
debugfs: quit

Regards,

						- Ted
