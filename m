From: Jan Kara <jack@suse.cz>
Subject: Re: DRAFT Design Spec for 1st Class Quota Support in Ext4
Date: Mon, 26 Apr 2010 20:47:47 +0200
Message-ID: <20100426184746.GC21179@atrey.karlin.mff.cuni.cz>
References: <E1O6I3M-0002Wl-CV@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38320 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280Ab0DZSrs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 14:47:48 -0400
Content-Disposition: inline
In-Reply-To: <E1O6I3M-0002Wl-CV@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

  The proposal looks fine. A couple of comments / questions:

> 6) Tune2fs will have a facility for adding and removing user and group
> quotas inodes while the file system is mounted.  The quota usage will
> not be correct after the quota inodes are newly added, however, so quota
> will not be enabled by default,  If the quota inodes are removed, quota
> will be disabled first.
  I suppose you will make quota file mtime not match last mounted time so
that e2fsck updating the usage will be triggered, right?

> 7) There will be a new interface so that bulk quota information can be
> fetched from the file system.  This needs to be negotiated with Jan
> Kara.  It can either be a new system call, or a magic file in /proc that
> can be opened and the repquota data extracted.
  Traditionally, quota interaction happens via quotactl() syscall. I'm not
against adding a syscall for this but then it would be a logical thing to
transition all the quotactl interface to standard syscalls... I'll try to
come up with some proposal during this week.
  Using /proc/ file looks like an ugly hack to me.

  And one more question: You don't speak in your document, when quotas
will be enabled. I expect accounting will be enabled during mount time, how
about quota enforcement? I think it might be useful if admin can disable
the quota limit enforcement and QUOTAON / QUOTAOFF sysctl is a natural
way to do this. Generic quota code supports this so it comes basically
for free.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
