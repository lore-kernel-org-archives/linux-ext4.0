From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - ignore bind mounts in fsck
Date: Wed, 19 Sep 2007 16:42:49 -0400
Message-ID: <20070919204249.GH25497@thunk.org>
References: <46F1847E.6080400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59044 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXISUmu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Sep 2007 16:42:50 -0400
Content-Disposition: inline
In-Reply-To: <46F1847E.6080400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 19, 2007 at 03:20:14PM -0500, Eric Sandeen wrote:
> An entry like this in /etc/fstab:
> 
> /foo	/bar	ext3	bind,defaults	1 3
> 
> will stop boot, as fsck.ext3 tries to check it and fails:
> 
> e2fsck 1.40.2 (12-Jul-2007)
> fsck.ext3: Is a directory while trying to open /foo
> 
> The superblock could not be read or does not describe a correct ext2
> filesystem. ...
> 
> Granted, asking for fsck of a bind mount in the fstab is a bit odd, 
> but it doesn't seem like it should stop the boot process if you make
> this mistake.

That's fair, but note that the dump number and fsck pass number really
should be zero in the fstab entry.  i.e., it really should be "0 0",
or just plain ommitted.

							- Ted
