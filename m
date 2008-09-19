From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH] Filesystem Journal Notifications
Date: Fri, 19 Sep 2008 14:34:03 -0600
Message-ID: <20080919203402.GI10950@webber.adilger.int>
References: <20080912220649.GB26999@apaithan-desktop.sanmateo.corp.akamai.com>
 <20080915023126.GF4090@webber.adilger.int>
 <20080915053937.GG4090@webber.adilger.int>
 <20080915193648.GC31055@apaithan-desktop.sanmateo.corp.akamai.com>
 <20080915233740.GF3241@webber.adilger.int>
 <20080916230552.GB13446@apaithan-desktop.sanmateo.corp.akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Jamie Lokier <jamie@shareable.org>,
	Dave Chinner <david@fromorbit.com>,
	Joel Becker <joel.becker@oracle.com>
To: Abhijit Paithankar <apaithan@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56019 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbYISUen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 19 Sep 2008 16:34:43 -0400
In-reply-to: <20080916230552.GB13446@apaithan-desktop.sanmateo.corp.akamai.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 16, 2008  16:05 -0700, Abhijit Paithankar wrote:
> > Is there a reason NOT to use the journal commit callback mechanism that
> > I posted?  This would only require registering a single callback for
> > each transaction for the inotify, but has the benefit of being completely
> > generic and can be used for other commit notifiers in the future.
> 
> In the current patch if two applications want to be notified on the journal
> commit event they could register for IN_JOURNAL_COMMIT on the same inode,
> which could be the root inode of the file system.
> 
> There is no limit on the number of applications that could register on the
> root inode for journal commit notifications. The only limitation is that
> they all have to register on the same inode for that partition.
>
> Any number of applications can register for the journal event as long as they
> register on the same inode.

That assumes agreement between the applications that are using this
interface.  It isn't at all desirable that applications have to know
the "mountpoint" of the filesystem in order to use inotify, and in
some cases (e.g. bind mount in a new namespace) there isn't even access
to the root inode.

> The journal commit callback mechanism could be viable way to notify
> journal commits. However it is not clear to me how an application would
> register the callback.

The application registers for the callback via the inotify interface,
which in turn needs to have an interface to the filesystem to use the
fs-specific transaction commit callback.

> It is not clear to me how using journal_callback_set API would change
> that if we use inotify to register callbacks.

The journal_callback_set() API doesn't need to change at all (though in
fact Joel Becker of OCFS2 is implementing a more generic API that can be
used for other kinds of commit callbacks.  He will hopefully post it to
this list soon.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

