From: tytso@mit.edu
Subject: Re: ext5
Date: Thu, 11 Feb 2010 01:44:33 -0500
Message-ID: <20100211064433.GF739@thunk.org>
References: <20100210215028.GD739@thunk.org>
 <4B73931D.5000302@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54564 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0BKGoh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Feb 2010 01:44:37 -0500
Content-Disposition: inline
In-Reply-To: <4B73931D.5000302@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 10, 2010 at 11:18:21PM -0600, Ron Johnson wrote:
> >We currently don't have any plans for an "ext5".  There might be some
> >new features that might gradually trickle into ext4; for example
> >there's someone who I may be mentoring who is interested in working on
> >an idea I've had to add read-only compression to ext4.  (Actually, the
> >design I've sketched out makes 90% of the work be file system
> >independent, so it's something that could be retrofitted into other
> >filesystems: xfs, btrfs, etc.)
> 
> I guess that means every file on the fs?

No, I mean per-file compression, but a compressed file is immutable.
This is basically what Mac OS X has recently added, and while I
haven't looked at their implementation, Apple being one of those
closed source companies and all, I wouldn't be surprised if they did
things the same way.

> Windows-like per-file compression would be darned useful in certain
> circumstances.  Big mbox files, for example.

The problem with mbox files is that some mail readers try to smart
about how they modify them to avoid needing to rewrite the whole mbox
file; mutt will seak to the middle of the file, write to the end of
the file, and then trim off any excess space by using the truncate
system call.  This is *hard* to support if the mbox file is
compressed; you can do it using a stacker-style compression technique,
but it's not as efficient, and it has a lot of complexity in the
kernel.

The idea with read-only compressed files is that they are useful for
large executables or large static files, where compressing them means
that it takes less time to read them off of an HDD.

     	      	   	   	     	    - Ted
