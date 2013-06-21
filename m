From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Fri, 21 Jun 2013 17:05:56 -0400
Message-ID: <20130621210556.GB10582@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ryan Lortie <desrt@desrt.ca>
To: "Joseph D. Wagner" <joe@josephdwagner.info>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60158 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423539Ab3FUVGG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Jun 2013 17:06:06 -0400
Content-Disposition: inline
In-Reply-To: <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 21, 2013 at 09:25:13AM -0700, Joseph D. Wagner wrote:
> 
> Please forgive me for the stupid question.  Would Ryan's concerns be
> addressed by configuring ext4 to run in data=journal mode?

It would, but for most workloads, data=journal is much, much slower.

Another option is to use the nodelalloc mount option.  The nodelalloc
option plus the default data=ordered mode will cause an implicit data
integrity writeback of all files that were written at every commit.
This is basically what ext3 did, but it makes fsync()'s painfully slow
since *all* files are getting flushed out, which is what trained so
many application programmers to think fsync() calls needed to be
avoided at all costs.  In addition, it decreases performance both for
writes, and since without delalloc, block allocation tends not to be
as good, for future read operations as well.

We are keeping nodelalloc mode for now, basically so that when the
ext4 code is used to mount filesystems explicitly marked as ext3 in
/etc/fstab (via CONFIG_EXT4_USE_AS_EXT23) we are bug-for-bug
compatible with ext3 at least with respect to delayed allocation and
implied writeback on file system commits.

> I realize that as a programmer he cannot guarantee that his application
> will run on a file system in a particular configuration.  I'm just
> curious as to how this all fits together.

Agreed, and in addition, this is not something we would want to
recommend to users, since they come with significant downsides.

	     	    	       	    	 - Ted
