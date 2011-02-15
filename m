From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [BUG] ext4: cannot unfreeze a filesystem due to a deadlock
Date: Tue, 15 Feb 2011 13:04:35 -0500
Message-ID: <20110215180435.GH4255@thunk.org>
References: <20110207205325.FB6A.61FB500B@jp.fujitsu.com>
 <20110215160630.GH17313@quack.suse.cz>
 <20110215170352.GE4255@thunk.org>
 <20110215172954.GK17313@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57854 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab1BOSEm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Feb 2011 13:04:42 -0500
Content-Disposition: inline
In-Reply-To: <20110215172954.GK17313@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 15, 2011 at 06:29:54PM +0100, Jan Kara wrote:
>   Sadly this does not quite work because even down_read(&sb->s_umount)
> in thaw_super() can block if there is another process that tries to acquire
> s_umount for writing - a situation like:
>   TASK 1 (e.g. flusher)		TASK 2	(e.g. remount)		TASK 3 (unfreeze)
> down_read(&sb->s_umount)
>   block on s_frozen
> 				down_write(&sb->s_umount)
> 				  -blocked
> 								down_read(&sb->s_umount)
> 								  -blocked
> behind the write access...

OK, sorry for being dense, but why does this cause a deadlock?  What
are you imaging TASK 3 doing that would impede the flusher from
eventually resuming?  Or how would TASK 3 prevent userspace from
completing whatever it needs to do (say, a device mapper ioctl)?

freeze_fs has always been inherently dangerous if the userspace does
not know what it's doing.  If it freezes the root file system, and
then while the file system is frozen, userspace attempts to modify
/etc/mtab, it's going to lose.  I've in the past argued for some kind
of safety timeout that prevents the system from wedging, but the
argument I've gotten back is (a) it's too complex, and (b) userspace
programmers aren't that stupid, and (c) it could cause the filesystem
to unfreeze when userspace wasn't expecting it.  Oh, and (d) if the
system wedges up due to userspace being stupid, it's acceptable.

Obviously, if the kernel does something to itself that causes a
deadlock, we need to fix it, but userspace doing something stupid has
been explicitly ruled out of scope, at least in previous
discussions...

> And in particular ext4 has another deadlock of this kind because it does
> IO from ext4_remount() e.g. when doing online resize (I know it's a bit
> artifical but still ;).

OK, I'm being dense again.  How does remount and online resize relate
with each other?  and it's not I/O in general which is a problem, it's
writeback activity which causes a problem because it takes a read lock
on s_umount, right?

						- Ted
