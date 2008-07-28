From: Theodore Tso <tytso@mit.edu>
Subject: Re: Multiple Data Stream
Date: Mon, 28 Jul 2008 16:15:07 -0400
Message-ID: <20080728201506.GM9378@mit.edu>
References: <2d08ef090807270334x4b275c21we69d0dd9fc9a460@mail.gmail.com> <20080727230455.GE7922@mit.edu> <18697577.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46335 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752817AbYG1UPS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2008 16:15:18 -0400
Content-Disposition: inline
In-Reply-To: <18697577.post@talk.nabble.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2008 at 12:30:23PM -0700, SandeepKsinha wrote:
> I am a newbie into these filesystems but I can see the positive sides of
> these Alternate Data Streams or multiple data streams too, needless to
> mention those.
>  
> If you look a bit more deeper into it, in my perspective and the kind of
> implementation I look forward to, here is what I have.

You've explained *how* to do it, but not *why* it would be a good
idea.  I'm aware that it's not that difficult to do.  But it becomes a
mess for system administrators.  Most backup tools won't know how to
deal with alternate data streams, so they won't be backed up
correctly.  rsync, ftp, zip, scp, etc., all don't deal with alternate
data streams, so the potential for data loss is limitless.  

> Access to the multiple data stream can be done through a file descriptor.
> Applications can open the multiple data stream to get a file descriptor and
> can do read(), write(), mmap().. using the file descriptor. These system
> calls would work as if it is been operated on a regular file. 
> The multiple data streams of a file will be stored in a hidden named data
> stream directory inode associated with the file. The hidden directory inode
> for the file can be accessed only through the multiple data stream API.

Yes, I'm aware that this is how Solaris 9 implemented alternate data
streams.  For a good time, assuming that /var/tmp/demo_file is a file
that contains alternate data forks owned by an unprivileged user, try
this command as that unprivileged user: "runat /var/tmp/demo_file chmod 0 ."

Now try to get access to the alternate data forks; there is no way to
recover without root access.   Lovely, eh?

						- Ted
