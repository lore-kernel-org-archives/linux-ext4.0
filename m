From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH V4 05/11] misc/create_inode.c: copy regular file
Date: Thu, 6 Mar 2014 14:47:15 -0500
Message-ID: <20140306194715.GA30214@thunk.org>
References: <1393661175-459-1-git-send-email-liezhi.yang@windriver.com>
 <1393661175-459-6-git-send-email-liezhi.yang@windriver.com>
 <20140306190622.GE9875@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Yang <liezhi.yang@windriver.com>, dvhart@linux.intel.com,
	linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38107 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaCFTrW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 14:47:22 -0500
Content-Disposition: inline
In-Reply-To: <20140306190622.GE9875@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 06, 2014 at 11:06:22AM -0800, Darrick J. Wong wrote:
> I noticed a few things while merging -next into my dev tree...

Darrick, good catch!

> > +	retval = ext2fs_new_inode(current_fs, cwd, 010755, 0, &newfile);
> > +	if (retval) {
> > +		com_err(__func__, retval, 0);
> > +		close(fd);
> > +		return errno;
> 
> Why return errno here, instead of retval?

Yep, we should do s/errno/retval/ at the places that you noted.

Robert, since these are in next already, could you submit a patch to
fixt this up?

Thanks!!

					- Ted

P.S.  Fortunately, this isn't crypto code ala gnutls.  :-)

