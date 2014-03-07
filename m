From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 18:38:28 -0800
Message-ID: <20140307023828.GG9875@birch.djwong.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
 <20140306190622.GE9875@birch.djwong.org>
 <20140306194715.GA30214@thunk.org>
 <20140306201439.GF9875@birch.djwong.org>
 <20140306225714.GB30214@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, dvhart@linux.intel.com,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46663 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaCGCif (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 21:38:35 -0500
Content-Disposition: inline
In-Reply-To: <20140306225714.GB30214@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 05:57:14PM -0500, Theodore Ts'o wrote:
> On Thu, Mar 06, 2014 at 12:14:39PM -0800, Darrick J. Wong wrote:
> > 
> > I'm already queuing up a bunch of (more) fixes... there's more weird things I
> > didn't notice.  Such as, why is current_fs now defined in current_inode.h?
> > That really ought to have stayed in debugfs.c, and current_inode.h should have
> > 'extern ext2_filsys current_fs;', no?
> 
> Yes, that would be better --- although in the long term we should
> probably try to get rid of the global variable and pass in an "fs"
> parameter into functions in misc/create_inode.c.

Agreed (and fixed).

> Since these aren't in a shared library, I wasn't worried that much
> about the details of the abstraction interface, but I'm sure there are
> some ways that we can improve things.
> 
> BTW, one of my plans for 1.43 is to rename libquota.a to libe2int.a,
> and to move things like profile.c, and other files shared between misc
> and e2fsck, etc., into an "internal support" library.  I suspect
> create_inoode.c would be a candidate for moving into this internal
> support library.

Higher level functionality?  I'd been musing that such a thing might be
beneficial to userland tools.

> 
> Cheers,
> 
> > ...I'll also respin the patchset I sent out a few days ago.
> 
> Sorry for having you respin the patchset yet again --- although
> hopefully it should be easier this time around.  I'm trying to be fair
> in catching up with th e2fsprogs backlog, and Robert and Zheng's
> patches have been outstanding for a long time.  Don't worry, yours are
> next on the list.  :-)

It's fine, (st)git merging isn't usually that painful.  I was more worried
about the impact of spamming linux-ext4 with giant patchsets, but respinning is
better than nothing happening at all. :)

That said, combing through all the "new arrivals" when I run the static
checkers ... was intense this time.

Though, it is a little time consuming to run checkpatch, then sparse/cppcheck,
then make check, then the metadata checksum test, and then xfstests.  But,
skipping tests isn't acceptable either, given the things I've fubar'd in the
past from /not/ doing that. :)

--D

> 
> Cheers,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
