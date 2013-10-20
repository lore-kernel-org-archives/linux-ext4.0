From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: add ratelimiting to ext4 messages
Date: Mon, 21 Oct 2013 10:15:40 +1100
Message-ID: <20131020231540.GA16161@dastard>
References: <1382059728-29483-1-git-send-email-tytso@mit.edu>
 <526140E8.7000002@redhat.com>
 <20131018185955.GA7557@thunk.org>
 <52631017.6010001@redhat.com>
 <20131020111800.GA31086@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:17955 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3JTXPs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Oct 2013 19:15:48 -0400
Content-Disposition: inline
In-Reply-To: <20131020111800.GA31086@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 20, 2013 at 07:18:00AM -0400, Theodore Ts'o wrote:
> On Sat, Oct 19, 2013 at 06:04:55PM -0500, Eric Sandeen wrote:
> > > When xfs "shuts down" the file system, it doesn't allow any read or
> > > write accesses, right?  So it's basically an even stronger version of
> > > errors=remount-ro.  We should perhaps discuss whether it would be
> > > better to squelch errors if we've remounted the file system read-only,
> > > or whether we should implement a complete shutdown errors option.
> > 
> > Yeah, there is no errors=continue type option, that is probably too
> > dangerous in general for the majority of users.
> 
> What I was asking was whether it might make sense for us to implement
> a errors=shutdown-fs option which causes all read operations (in
> addition to write operations) to immediately return EIO.  That would
> certainly reduce the error flood risk, but if you did this on the root
> file system, you might as well set errors=panic.  This is what XFS's
> default behavior on fserrors, correct?

No. XFS's behaviour is dependent on the context the error occurs in.
If it's a fatal or corruption inducing error, then it shuts down and
returns errors to any attempt to read, write or modify anything in
the filesystem. If the error is not fatal, then XFS behaves like
errors=continue.

IOWs, if you read a directory and trip over a corruption, the XFS
filesystem will not shut down - it will just throw the
EFSCORRUPTED/EIO error back to userspace and log it. However, if you
are trying to modify that directory, and the IO error occurs after
modifications have already been made to the directory but are not
yet committed, then that's a fatal error and a shutdown will occur.

i.e. IO errors in metadata are only fatal if we can't back out
cleanly, otherwise they are simply logged and reported to userspace
like any other IO error during a data read...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
