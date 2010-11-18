From: Ted Ts'o <tytso@mit.edu>
Subject: Re: removal of grpid option from ext4
Date: Wed, 17 Nov 2010 20:20:52 -0500
Message-ID: <20101118012052.GM3290@thunk.org>
References: <4CE45B0A.3010401@cs.washington.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: John Petersen <jrp@cs.washington.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53170 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0KRBUy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Nov 2010 20:20:54 -0500
Content-Disposition: inline
In-Reply-To: <4CE45B0A.3010401@cs.washington.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 17, 2010 at 02:45:30PM -0800, John Petersen wrote:
> The removal of this option puzzles me.  It's extremely useful in an
> academic environment like ours, where different groups of
> researchers work in shared project spaces.  I'd like to migrate our
> data partitions to ext4.  If this option is going to disappear, I
> will have to seriously consider keeping current and new project
> spaces as ext3.

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

Best regards,

						- Ted
