From: tytso@mit.edu
Subject: Re: DRAFT Design Spec for 1st Class Quota Support in Ext4
Date: Mon, 26 Apr 2010 18:57:58 -0400
Message-ID: <20100426225758.GA13800@thunk.org>
References: <E1O6I3M-0002Wl-CV@closure.thunk.org>
 <20100426184746.GC21179@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:56109 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0D0B1j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 21:27:39 -0400
Content-Disposition: inline
In-Reply-To: <20100426184746.GC21179@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 26, 2010 at 08:47:47PM +0200, Jan Kara wrote:
>   Hi Ted,
> 
>   The proposal looks fine. A couple of comments / questions:
> 
> > 6) Tune2fs will have a facility for adding and removing user and group
> > quotas inodes while the file system is mounted.  The quota usage will
> > not be correct after the quota inodes are newly added, however, so quota
> > will not be enabled by default,  If the quota inodes are removed, quota
> > will be disabled first.
>   I suppose you will make quota file mtime not match last mounted time so
> that e2fsck updating the usage will be triggered, right?

Yes, that was my original plan (when adding quotas to a mounted
filesystem).  The one downside to this is that it requires rebooting
and running e2fsck in order enable quotas, which is kind of unfortunate.

One thing which I was thinking about doing was running quotacheck and
having it create aquota.user,group files the old-fashioned (admittedly
racy) way, and then having tune2fs zap those inodes into the
superblock and then enabling quotas.  The usage counters won't be
exactly write if the filesystem has any activity happening while
quotacheck si running, but that's a problem system administrators seem
to be willing to live with today.

We can then have e2fsck convert the aquota.{user,group} files to
hidden files by simply copying the inode to inodes 3 and 4, and then
removing the link in the root directory (without requiring a full fsck
run) on the next reboot.  We use a similar trick today to migrate from
a /.journal file to a hidden journal inode in e2fsck already, so most
of that code is in e2fsck already.

> > 7) There will be a new interface so that bulk quota information can be
> > fetched from the file system.  This needs to be negotiated with Jan
> > Kara.  It can either be a new system call, or a magic file in /proc that
> > can be opened and the repquota data extracted.
>   Traditionally, quota interaction happens via quotactl() syscall. I'm not
> against adding a syscall for this but then it would be a logical thing to
> transition all the quotactl interface to standard syscalls... I'll try to
> come up with some proposal during this week.

I'm OK with whatever you can get past the LKML bike shed painting
crew.  :-)

There's a set of folks who tend to whinge about how multiplexed system
calls are evil, and I'm not sure whether they will complain about
adding more multiplexing to the quotactl system call, with the
attendent need for 64->32 compat complexity.

>   Using /proc/ file looks like an ugly hack to me.

Well, unlike the other the other quotactl subcommands, this one is
going to require some kind of first/next iterator, since the number of
user/groups that needs to be returned is highly variable.  And in
fact, if we need a system call per user/group data that we need to
extract, it's going to be somewhat painful from a syscall overhead
point of view, isn't it?

Using a single /proc file means many fewer syscalls to read out the
repquota data, since userspace can use a nice big 4k buffer.  (I
suppose the repquota quotactl subcommand could fill in a big passed-in
array, but that's more complexity.)  And with a /proc file, userspace
would be able to read out the repquota information directly using a
shell script.

But I don't have strong preference if you really want to use a binary
format instead of a /proc file.

>   And one more question: You don't speak in your document, when quotas
> will be enabled. I expect accounting will be enabled during mount time, how
> about quota enforcement? I think it might be useful if admin can disable
> the quota limit enforcement and QUOTAON / QUOTAOFF sysctl is a natural
> way to do this. Generic quota code supports this so it comes basically
> for free.

I was assuming that it was better to simply enable quota enforcement
by default; how often do system administrators want to selecting
enable and disable quota?  It seemed to me that a huge amount of the
hair and complexity and nastiness of the /etc/init.d/quota scripts was
because quota checking had to be enabled from userspace, and there was
a need to grovel through /etc/mtab (or /proc/mounts) to figure out
which file systems needed to have quota enabled, not just for
quotacheck.

I consider the amount of mount options that we have to pass through to
/proc/mounts to be horrible, and one of my primary design goals was to
eliminate all of that.  So my plan was to enable quotas enforcement
and tracking when the file system is mounted.

Is there a usage scenario where a system administrator would want to
mount a file system and _not_ enforce quota?

    	     	     	    	 	   - Ted
