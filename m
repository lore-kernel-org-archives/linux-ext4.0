From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: add ratelimiting to ext4 messages
Date: Sun, 20 Oct 2013 07:18:00 -0400
Message-ID: <20131020111800.GA31086@thunk.org>
References: <1382059728-29483-1-git-send-email-tytso@mit.edu>
 <526140E8.7000002@redhat.com>
 <20131018185955.GA7557@thunk.org>
 <52631017.6010001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48172 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3JTLSH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Oct 2013 07:18:07 -0400
Content-Disposition: inline
In-Reply-To: <52631017.6010001@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 19, 2013 at 06:04:55PM -0500, Eric Sandeen wrote:
> 
> Maybe the ratelimit should depend on that then?  I'm just concerned about
> the possibility of filtering messages that, rather than being a nuisance,
> are vital to figuring out what went wrong.
> 
> (granted, it's probably the first error or two that matters)

The default rate limit threshold that we've set is ten messages per 5
seconds.  I have a really hard time believing that the 11th message is
going to containing any critical information that won't be in the
first ten.  :-)

> Or maybe it's only relevant with errors=continue, and errors=remount-ro
> will be self-limiting in any case.

Even with remount-ro, there are certainly cases where things will not
be self limiting, simply because user processes continually try
referencing the same corrupted directory or file.

> > When xfs "shuts down" the file system, it doesn't allow any read or
> > write accesses, right?  So it's basically an even stronger version of
> > errors=remount-ro.  We should perhaps discuss whether it would be
> > better to squelch errors if we've remounted the file system read-only,
> > or whether we should implement a complete shutdown errors option.
> 
> Yeah, there is no errors=continue type option, that is probably too
> dangerous in general for the majority of users.

What I was asking was whether it might make sense for us to implement
a errors=shutdown-fs option which causes all read operations (in
addition to write operations) to immediately return EIO.  That would
certainly reduce the error flood risk, but if you did this on the root
file system, you might as well set errors=panic.  This is what XFS's
default behavior on fserrors, correct?

						- Ted
