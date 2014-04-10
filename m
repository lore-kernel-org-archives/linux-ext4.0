From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: How to resize to an bigger then 16TB ext4 filesysteem on Debian
Date: Thu, 10 Apr 2014 10:09:37 -0400
Message-ID: <20140410140937.GE15925@thunk.org>
References: <53468055.4070700@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jelle de Jong <jelledejong@powercraft.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52537 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020AbaDJOJp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Apr 2014 10:09:45 -0400
Content-Disposition: inline
In-Reply-To: <53468055.4070700@powercraft.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 01:28:21PM +0200, Jelle de Jong wrote:
> 
> Hello everyone,
> 
> https://packages.debian.org/wheezy/e2fsprogs
> 
> # resize2fs /dev/lvm0-vol/storage
> resize2fs 1.42.5 (29-Jul-2012)
> resize2fs: New size too large to be expressed in 32 bits
> 
> (will the command work with e2fsprogs 1.42.9-3?)
> 
> # tune2fs -l /dev/lvm0-vol/storage
> http://paste.debian.net/92889/
> 
> Suggestions has to be stable enough for production systems.

I'm going to assume the file system was created without having the
64-bit file system feature set.  (Running dumpe2fs -h
/dev/lvm0-vol/storage can verify this).

If that's true, and you require a production-stable way of doing this,
there's really only one thing I can suggest:

1)  Backup your file system completely
2)  Get the development version of e2fsprogs, and apply a set of
    in-development patches that haven't yet been merged
3)  Use this in-development resize2fs to convert to a 64-bit file system,
    realizing that it will have completely rewrite your inode tables.
    Cross your fingers.
4)  If it works, you're done.  If not, you can restore from backups.  :-)

So basically steps 2 and 3 are ways of optimizing needing to do a full
restore of your file system.....

Cheers,

					- Ted
