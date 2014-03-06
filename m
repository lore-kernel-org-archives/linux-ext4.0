From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 12:14:39 -0800
Message-ID: <20140306201439.GF9875@birch.djwong.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
 <20140306190622.GE9875@birch.djwong.org>
 <20140306194715.GA30214@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, dvhart@linux.intel.com,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50735 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCFUOq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Mar 2014 15:14:46 -0500
Content-Disposition: inline
In-Reply-To: <20140306194715.GA30214@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 02:47:15PM -0500, Theodore Ts'o wrote:
> On Thu, Mar 06, 2014 at 11:06:22AM -0800, Darrick J. Wong wrote:
> > I noticed a few things while merging -next into my dev tree...
> 
> Darrick, good catch!
> 
> > > +	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
> > > +	if (retval) {
> > > +		com_err(__func__, retval, 0);
> > > +		close(fd);
> > > +		return errno;
> > 
> > Why return errno here, instead of retval?
> 
> Yep, we should do s/errno/retval/ at the places that you noted.
> 
> Robert, since these are in next already, could you submit a patch to
> fixt this up?

I'm already queuing up a bunch of (more) fixes... there's more weird things I
didn't notice.  Such as, why is current_fs now defined in current_inode.h?
That really ought to have stayed in debugfs.c, and current_inode.h should have
'extern ext2_filsys current_fs;', no?

Also there's a no-return-value 'return;' if the inline data write fails later
down in that function, and I think it's time to pull in cppcheck on a make
C=1 build.

...I'll also respin the patchset I sent out a few days ago.

--D
> 
> Thanks!!
> 
> 					- Ted
> 
> P.S.  Fortunately, this isn't crypto code ala gnutls.  :-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
