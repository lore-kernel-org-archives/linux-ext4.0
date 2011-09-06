From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: EXT4-fs (dm-1): Couldn't remount RDWR because of unprocessed
 orphan inode list
Date: Tue, 6 Sep 2011 11:14:50 -0700 (PDT)
Message-ID: <alpine.DEB.2.01.1109061105450.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1109021346290.9183@trent.utfs.org> <4E66478E.90102@redhat.com> <alpine.DEB.2.01.1109060923340.9183@trent.utfs.org> <4E664DFD.80308@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from trent.utfs.org ([194.246.123.103]:48245 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1IFSOy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Sep 2011 14:14:54 -0400
In-Reply-To: <4E664DFD.80308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 6 Sep 2011 at 11:44, Eric Sandeen wrote:
> > remount the filesystem rw and then ro again every day. I guess this equals
> > the scenario of "fs goes down (remount!) while someone is holding open a 
> > file"?
> 
> well, no - "goes down" means "crashed or lost power"

Hm, the machine and its storage is online all the time and the messages 
occur inbetween downtimes.

> well, as the commit said, it'd be nice to handle it in remount, yes... :(

If my daily remounts are causing this, it's unforuntate. But it's nice to 
know that now. It'd be more worrying that someting else is slowly 
corrupting the fs.

> well, seems like you need to get to the root cause of the unprocessed
> orphan inodes.
> 
> I don't yet have my post-vacation thinking cap back on... does cycling
> rw/ro/rw/ro with open & unlinked files cause an orphan inode situation?

This is almost all I do on this fs. The whole process is:

1) fs is ro most of the time, while a remote application accesses it via 
   a readonly nfs mount.
2) once a day the fs gets remounted rw (the remote application does not 
   know this and is still accessing the fs via the same ro-nfs mount
3) backups are being pushed to the fs (via rsync, using hardlinks a lot)
4) fs is remounted ro again
5) at some point the remote application notices that the nfs mount went
   stale and has to remount its readonly nfs-mount

Thanks,
Christian.
-- 
BOFH excuse #93:

Feature not yet implemented
