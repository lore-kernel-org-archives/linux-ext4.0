From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 19:14:46 -0400
Message-ID: <20140911231446.GK17990@thunk.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911223347.GH17990@thunk.org>
 <20140911225022.GA10351@birch.djwong.org>
 <20140911225223.GJ17990@thunk.org>
 <20140911230758.GB11640@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52340 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbaIKXOt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Sep 2014 19:14:49 -0400
Content-Disposition: inline
In-Reply-To: <20140911230758.GB11640@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 04:07:58PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 11, 2014 at 06:52:23PM -0400, Theodore Ts'o wrote:
> > On Thu, Sep 11, 2014 at 03:50:22PM -0700, Darrick J. Wong wrote:
> > > 
> > > Looks like most everything landed ok except for:
> > > 
> > > Yikes, make check explodes:
> > 
> > Hmm, works for me.  Could you make sure you've done a "make clean" and
> > also a "git clean"?  In particular, make sure you don't have a
> > leftover file in debugfs/jfs_user.h....
> 
> There aren't any stray jfs_user.h files, but rearranging DEBUGFS_CFLAGS seems
> to fix it.  On Ubuntu 14.04 it seems that the compile command for
> lib/ext2fs/journal.o is:
>
> gcc -I. -I../../lib -I../../lib -Wall -g -O2 -fstack-protector --param=ssp-buffer-size=4 -DHAVE_CONFIG_H -I./../../e2fsck -DDEBUGFS -c ../../debugfs/journal.c -o journal.o

Ah, now I see why it works for me.  I was using a VPATH build
directory, so it wasn't finding the one in lib/ext2fs/jfs_user.h.  But
you're probably building in the source directory, so it was finding it
via "-I.".

Your patch looks good, thanks.  I'll apply it and push out an update.

     	   	       		     	      	  - Ted
