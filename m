From: Ted Ts'o <tytso@mit.edu>
Subject: Re: How do I clear the append-only flag on symlinks?
Date: Sat, 22 Oct 2011 01:16:44 -0400
Message-ID: <20111022051644.GD4196@thunk.org>
References: <CAObL_7FLTio3+X3iQ3sdHw156OvmjT92_AD0vKTSagNTkaF9fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andrew Lutomirski <andy@luto.us>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51259 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1JVHtP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Oct 2011 03:49:15 -0400
Content-Disposition: inline
In-Reply-To: <CAObL_7FLTio3+X3iQ3sdHw156OvmjT92_AD0vKTSagNTkaF9fQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 11:07:51AM -0700, Andrew Lutomirski wrote:
> By means that are best not admitted to, I managed to mark a large
> chunk of my filesystem append-only, including symlinks.  I cleared the
> flag from all the normal files and directories, but chattr and lsattr
> don't want to operate on symlinks.

Yes.  So how did you set a whole chunk of your file system
append-only?

> Any ideas on how to clear the append-only flags?  debug2fs is a little
> scary, and hacking e2fsprogs to allow operation on symlinks seems to
> affect symlink targets and not the symlinks themselves.

I'd probably hack it into e2fsck, and let it offer to clear the
append-only flag on things that aren't regular files, on the theory
that they should have never been allowed to be set to begin with.

     	  	      	    	 	 - Ted
