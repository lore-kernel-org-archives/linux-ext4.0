From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 00/25] e2fsprogs Summer 2014 patchbomb, part 5.2
Date: Thu, 11 Sep 2014 16:30:16 -0700
Message-ID: <20140911233016.GB10351@birch.djwong.org>
References: <20140908231135.25904.66591.stgit@birch.djwong.org>
 <20140911223347.GH17990@thunk.org>
 <20140911225022.GA10351@birch.djwong.org>
 <20140911225223.GJ17990@thunk.org>
 <20140911230758.GB11640@birch.djwong.org>
 <20140911231446.GK17990@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40923 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaIKXaW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Sep 2014 19:30:22 -0400
Content-Disposition: inline
In-Reply-To: <20140911231446.GK17990@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 11, 2014 at 07:14:46PM -0400, Theodore Ts'o wrote:
> On Thu, Sep 11, 2014 at 04:07:58PM -0700, Darrick J. Wong wrote:
> > On Thu, Sep 11, 2014 at 06:52:23PM -0400, Theodore Ts'o wrote:
> > > On Thu, Sep 11, 2014 at 03:50:22PM -0700, Darrick J. Wong wrote:
> > > > 
> > > > Looks like most everything landed ok except for:
> > > > 
> > > > Yikes, make check explodes:
> > > 
> > > Hmm, works for me.  Could you make sure you've done a "make clean" and
> > > also a "git clean"?  In particular, make sure you don't have a
> > > leftover file in debugfs/jfs_user.h....
> > 
> > There aren't any stray jfs_user.h files, but rearranging DEBUGFS_CFLAGS seems
> > to fix it.  On Ubuntu 14.04 it seems that the compile command for
> > lib/ext2fs/journal.o is:
> >
> > gcc -I. -I../../lib -I../../lib -Wall -g -O2 -fstack-protector --param=ssp-buffer-size=4 -DHAVE_CONFIG_H -I./../../e2fsck -DDEBUGFS -c ../../debugfs/journal.c -o journal.o
> 
> Ah, now I see why it works for me.  I was using a VPATH build
> directory, so it wasn't finding the one in lib/ext2fs/jfs_user.h.  But
> you're probably building in the source directory, so it was finding it
> via "-I.".
> 
> Your patch looks good, thanks.  I'll apply it and push out an update.

Cool, thanks!  Yes, I do build out of the source dir.

Part 6 will have: e2fsck readahead; alloc_block cleanup; dumpe2fs output
cleanup; reporting of foreign FSes being fed to tune2fs/debugfs/e2fsck; uninit
block handling for fileio; 32->64bit resize2fs; fallocate; fuse2fs.

I'll give it all a spin on the usual x64/ppc64/arm64/i386 testbeds.  Hopefully
it'll be out tomorrow.

--D

> 
>      	   	       		     	      	  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
