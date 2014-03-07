From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 18:56:30 -0800
Message-ID: <20140307025630.GH9875@birch.djwong.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
 <20140306190622.GE9875@birch.djwong.org>
 <20140306194715.GA30214@thunk.org>
 <20140306201439.GF9875@birch.djwong.org>
 <20140306225714.GB30214@thunk.org>
 <53191FBC.4040106@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, dvhart@linux.intel.com,
	linux-ext4@vger.kernel.org
To: Robert Yang <liezhi.yang@windriver.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaCGC4i (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 21:56:38 -0500
Content-Disposition: inline
In-Reply-To: <53191FBC.4040106@windriver.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Mar 07, 2014 at 09:24:12AM +0800, Robert Yang wrote:
> 
> 
> On 03/07/2014 06:57 AM, Theodore Ts'o wrote:
> >On Thu, Mar 06, 2014 at 12:14:39PM -0800, Darrick J. Wong wrote:
> >>
> >>I'm already queuing up a bunch of (more) fixes... there's more weird things I
> >>didn't notice.  Such as, why is current_fs now defined in current_inode.h?
> >>That really ought to have stayed in debugfs.c, and current_inode.h should have
> >>'extern ext2_filsys current_fs;', no?
> >
> >Yes, that would be better --- although in the long term we should
> >probably try to get rid of the global variable and pass in an "fs"
> >parameter into functions in misc/create_inode.c.
> >
> >Since these aren't in a shared library, I wasn't worried that much
> >about the details of the abstraction interface, but I'm sure there are
> >some ways that we can improve things.
> >
> >BTW, one of my plans for 1.43 is to rename libquota.a to libe2int.a,
> >and to move things like profile.c, and other files shared between misc
> >and e2fsck, etc., into an "internal support" library.  I suspect
> >create_inoode.c would be a candidate for moving into this internal
> >support library.
> >
> 
> Hi Ted and Darrick,
> 
> Thank you very much for the great help, I think that I don't have to
> submit a fix patch again since Darrick has helped me to fix the
> problem, please feel free to let me know if there is anything I
> can do.

I'll have 6 patches for you to review soon.  I also fixed a number of style and
whitespace errors. :)

I had another thought about populate_fs -- it should be in charge of setting up
and tearing down the hdlinks_s hardlink map, not the caller, and it shouldn't
really be a global variable.  I noticed that populate_fs recursively calls
itself, so I moved the functionality to a static function and wrote a wrapper
that takes care of hdlinks and calls the static function.

By the way, one of the things I /didn't/ fix was the root inode parameter that
you pass to ext2fs_namei.  I couldn't tell if supporting debugfs' chroot
command is part of your requirements set (though it doesn't seem likely to me),
but I also think that a better interface would be to have callers of the
create_inode functions pass in the destination dir inode instead of a pathname,
similar to the do_mknod_internal interface.  debugfs is the only tool that
knows about the notion of a 'chroot'; the rest would seem to do all namei
operations starting at EXT2_ROOT_INO.

Also I recommend running sparse/cppcheck on any source files that a patch of
yours touches.

--D
> 
> // Robert
> 
> >Cheers,
> >
> >>...I'll also respin the patchset I sent out a few days ago.
> >
> >Sorry for having you respin the patchset yet again --- although
> >hopefully it should be easier this time around.  I'm trying to be fair
> >in catching up with th e2fsprogs backlog, and Robert and Zheng's
> >patches have been outstanding for a long time.  Don't worry, yours are
> >next on the list.  :-)
> >
> >Cheers,
> >
> >						- Ted
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
