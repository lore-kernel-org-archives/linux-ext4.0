From: tytso@mit.edu
Subject: Re: [Bug 15910] zero-length files and performance degradation
Date: Sun, 9 May 2010 22:56:12 -0400
Message-ID: <20100510025612.GM18762@thunk.org>
References: <bug-15910-13602@https.bugzilla.kernel.org/>
 <201005091819.o49IJCQG017276@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:34103 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087Ab0EJC4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 May 2010 22:56:16 -0400
Content-Disposition: inline
In-Reply-To: <201005091819.o49IJCQG017276@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> The problem is, dpkg needs to guarantee the system is always usable,
> and when a crash occurs, say when it's unpacking libc, it's not
> acceptable for dpkg not to fsync() before rename() as it might end
> up with an empty libc.so file, even if it might have marked the
> package as correctly unpacked (wrongly but unknowingly as there's no
> guarantees), which is not true until the changes have been fully
> committed to the file system.

Why not unpack all of the files as "foo.XXXXXX" (where XXXXXX is a
mkstemp filename template) do a sync call (which in Linux is
synchronous and won't return until all the files have been written),
and only then, rename the files?  That's going to be the most fastest
and most efficient way to guarantee safety under Linux; the downside
is that you need to have enough free space to store the old and the
new files in the package simultaneously.  But this also is a win,
because it means you don't actually start overwriting files in a
package until you know that the package installation is most likely
going to succeed.  (Well, it could fail in the postinstall script, but
at least you don't have to worry about disk full errors.)

   	     	   	   	       	    - Ted
