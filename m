From: Theodore Tso <tytso@mit.edu>
Subject: Re: hard lockup, followed by ext4_lookup: deleted inode
	referenced: 524788
Date: Mon, 28 Sep 2009 16:25:07 -0400
Message-ID: <20090928202507.GB22733@mit.edu>
References: <20090928191644.GR12922@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:51828 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZI1UZF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Sep 2009 16:25:05 -0400
Content-Disposition: inline
In-Reply-To: <20090928191644.GR12922@hexapodia.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Sep 28, 2009 at 12:16:44PM -0700, Andy Isaacson wrote:
> After a hard lockup and reboot, my test box (running recent Linus git
> 851b147) came up with:
> 
> [    5.016854] EXT4-fs (sda1): mounted filesystem with ordered data mode
> [    8.809125] EXT4-fs (sda1): internal journal on sda1:8
> [   10.165239] EXT4-fs error (device sda1): ext4_lookup: deleted inode referenced: 524788
> [   10.165286] Aborting journal on device sda1:8.
> [   10.168111] EXT4-fs error (device sda1): ext4_journal_start_sb: Detected aborted journal
> [   10.168169] EXT4-fs (sda1): Remounting filesystem read-only
> [   10.171614] EXT4-fs (sda1): Remounting filesystem read-only

It would be useful to see what pathname is associated with inode 524788.

You can use debugfs to find this out.  For example to find a pathname
which points to inode 14666, you can do this:

# debugfs /dev/sda1
debugfs 1.41.9 (22-Aug-2009)
debugfs:  ncheck 14666
Inode	  Pathname
14666	  /grub/menu.lst

Also try using the debugfs stat command, send me the output, please:

debugfs: stat <14666>

> 2. after a lockup the journal recovery should not fail.

I'm not sure it was a matter of the journal recovery failing.  All we
know for certain is that filesystem was corrupted after the lockup and
remounting the filesystem.  What caused the file system corruption is
open to question at the moment; it could have been caused by the
lockup; or it could have been a file that was deleted right about the
time of the lockup; or it could have been some completely random
filesystem corruption that.

It would be useful to know whether the inode was in question was
supposed to have been deleted.  If it was, it would be useful to know
if the dtime reported by debugfs's stat was around the time of the
original lockup.  

						- Ted
