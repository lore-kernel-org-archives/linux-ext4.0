From: Ted Ts'o <tytso@mit.edu>
Subject: Re: bsd groups
Date: Wed, 17 Nov 2010 20:41:54 -0500
Message-ID: <20101118014154.GN3290@thunk.org>
References: <B289F406-D03C-499D-9F3B-EAF5B6E5DEF2@cs.dartmouth.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: wayne cripps <wbc@cs.dartmouth.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48979 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab0KRBl6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 20:41:58 -0500
Content-Disposition: inline
In-Reply-To: <B289F406-D03C-499D-9F3B-EAF5B6E5DEF2@cs.dartmouth.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 26, 2010 at 02:05:00PM -0400, wayne cripps wrote:
> 
>   Our department - Computer Science, at Dartmouth College, depends
> on bsd groups for our projects.  Having bsd groups means one less
> thing for the undergrads and their TAs to have to keep track of.
> Since we have used them forever, people are used to that behavior as
> default.

So if people really insist on using it, then we'll keep it.

But one thing which I don't understand; why can't you just set the
setgid bit on the shared spaces?  This causes newly created files to
have the same group id as the directory, and newly created
subdirectories to have the set gid bit.  Set the group id at the top
directory of the project's directory hierarchy, and set the setgid
bit, and all newly created files will inherit the group id of the
directory --- and all newly created subdirectory will inherit the
group id as well as the setgid bit.

This is the System V scheme, which is much more flexible than the BSD
scheme, since you can set control whether you have the BSD behaviour
or the original System V unix behaviour, which is to always use the
primary group ID of the creator.

If you set the setgid bit on all directories (chmod -R g+s /mnt), then
you'll effectively have the same behavior as the grpid mount option.

What we may do is add a pointer to a web page with this explanation so
that people can understand there is a better alternative.  Does this
work for you?

						- Ted
