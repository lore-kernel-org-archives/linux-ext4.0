From: Theodore Tso <tytso@mit.edu>
Subject: Re: spatch for 64-bit e2fsprogs (was Re: Fix device too big bug in
	mainline?)
Date: Tue, 4 Aug 2009 16:32:12 -0400
Message-ID: <20090804203212.GK28678@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu> <20090802022209.GC8680@mit.edu> <20090803202740.GE10853@shell> <20090804144846.GE28678@mit.edu> <20090804181850.GF9324@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Julia Lawall <julia@diku.dk>, linux-ext4@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Jesper Andersen <jespera@diku.dk>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55107 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbZHDUca (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 4 Aug 2009 16:32:30 -0400
Content-Disposition: inline
In-Reply-To: <20090804181850.GF9324@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 04, 2009 at 02:18:51PM -0400, Valerie Aurora wrote:
> On Tue, Aug 04, 2009 at 10:48:46AM -0400, Theodore Tso wrote:
> > 
> > If you want to start preparing for the semantic patches by preparing
> > and testing the receipes, and then helping to flag those patches that
> > contain some changes that contain some changes that can't be applied
> > via spatch, that would be helpful.
> > 
> > Does that sound like a plan?
> 
> That sounds great.  We won't be able to automate everything, but after
> this exercise, I bet spatch will be able to automate most of it.
> 
> Jesper, the patches you'll be interested in can be found in the
> shared-64bit branch of:
> 
> git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git

This is actually *very* out of date.  It's based off of e2fsprogs
1.41.4, and doesn't have the latest bug fixes or my efforts to clean
up the patches.

Please use either the pu branch of e2fsprogs:

   git://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git
   http://www.kernel.org/pub/scm/fs/ext2/e2fsprogs.git

or, the e2fsprogs 64-bit patch queue, which can be found here:

   http://github.com/tytso/e2fsprogs-64bit/tree/master
   git://github.com/tytso/e2fsprogs-64bit.git

Val, I had offered you write access into this patch queue back when I
first rebased the e2fsprogs patches to 1.41.4, and you declined,
saying you preferred not to work that way.  The offer is still open; I
find that patch queue to be a **far** better way of working,
especially if the goal is to refactor and clean up the patches.
Simply using a git branch doesn't work at all; I provide the pu branch
as a convenience, but it is constantly getting rewound as I clean up,
refactor, reorder, and gradually merge patches into mainline.

Currently I have merged around third of the changes into the e2fsprogs
master branch, and the patches have been significantly improved.  The
new bitmap code has been cleaned up significantly, and is almost ready
for mainline.

						- Ted
