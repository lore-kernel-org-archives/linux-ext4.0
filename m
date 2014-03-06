From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 17:57:14 -0500
Message-ID: <20140306225714.GB30214@thunk.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
 <20140306190622.GE9875@birch.djwong.org>
 <20140306194715.GA30214@thunk.org>
 <20140306201439.GF9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, dvhart@linux.intel.com,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38157 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaCFW5Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 17:57:25 -0500
Content-Disposition: inline
In-Reply-To: <20140306201439.GF9875@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 12:14:39PM -0800, Darrick J. Wong wrote:
> 
> I'm already queuing up a bunch of (more) fixes... there's more weird things I
> didn't notice.  Such as, why is current_fs now defined in current_inode.h?
> That really ought to have stayed in debugfs.c, and current_inode.h should have
> 'extern ext2_filsys current_fs;', no?

Yes, that would be better --- although in the long term we should
probably try to get rid of the global variable and pass in an "fs"
parameter into functions in misc/create_inode.c.

Since these aren't in a shared library, I wasn't worried that much
about the details of the abstraction interface, but I'm sure there are
some ways that we can improve things.

BTW, one of my plans for 1.43 is to rename libquota.a to libe2int.a,
and to move things like profile.c, and other files shared between misc
and e2fsck, etc., into an "internal support" library.  I suspect
create_inoode.c would be a candidate for moving into this internal
support library.

Cheers,

> ...I'll also respin the patchset I sent out a few days ago.

Sorry for having you respin the patchset yet again --- although
hopefully it should be easier this time around.  I'm trying to be fair
in catching up with th e2fsprogs backlog, and Robert and Zheng's
patches have been outstanding for a long time.  Don't worry, yours are
next on the list.  :-)

Cheers,

						- Ted
