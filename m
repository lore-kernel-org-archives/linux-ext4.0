From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] return status from chattr
Date: Mon, 22 Oct 2007 08:55:04 -0400
Message-ID: <20071022125504.GB29220@thunk.org>
References: <46F2B47A.1070902@redhat.com> <4718FD8B.5050803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:38484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXJVMzT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 08:55:19 -0400
Content-Disposition: inline
In-Reply-To: <4718FD8B.5050803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Oct 19, 2007 at 01:55:07PM -0500, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > This is for RH bug #180596, Chattr command doesn't provide expected 
> > exit code in case of failure.
> > 
> > (trying to clear out an e2fsprogs bug backlog, can you tell?)  :)
> 
> Any comments on this one?  Can we commit it if it looks ok?

It turns out you didn't quite completely fix the problem, since the
iterate_on_directory() command wasn't reflecting errors up.

Also, while I was at it I cleaned up the code so that it more it
attempts to set the flags on special files, instead of just ignoring
them.  On Linux this will result in an error message, but at least
this way the user knows that those files didn't get set, and you can
suppress them using the -f flag, just like chmod/chown.

						- Ted
