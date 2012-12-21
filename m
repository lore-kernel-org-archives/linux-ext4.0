From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Uninitialized extent races
Date: Fri, 21 Dec 2012 18:03:35 -0500
Message-ID: <20121221230335.GH31731@thunk.org>
References: <20121221012526.GD13474@quack.suse.cz>
 <20121221031151.GA5014@thunk.org>
 <20121221161929.GF17357@quack.suse.cz>
 <20121221180243.GB31731@thunk.org>
 <20121221224947.GA23652@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39830 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab2LUXDo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Dec 2012 18:03:44 -0500
Content-Disposition: inline
In-Reply-To: <20121221224947.GA23652@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 21, 2012 at 11:49:47PM +0100, Jan Kara wrote:
>   It's actually simpler than that. We wait for any pending DIO using
> inode_dio_wait() and i_mutex protects from new writes to be submitted. So
> that takes care of one possibility. truncate_inode_pages() waits for
> PageWriteback bit so that handles waiting for IO itself. 

Hmm, yes, I should have known/remembered that.  I've seen cases where
very rarely, it's possible for a unlink() or truncate() call to stall
for multiple minutes(!).  This can happen if you have writeback
happening in a container which has a very small (low priority)
constraint on its block I/O bandwidth.  If you try to delete an inode
which has writeback work pending, it's possible for the writeback to
take a looong time, which in turn causes the unlink to take a long
time.

It becomes worse the process doing the unlink is a high priority
process (say, the cluster management daemon who is cleaning up after
said low-priority job has completed), but the writeback is happening
in the context of a low priority cgroup.  You can end up with a nasty
priority inversion.

And there's not a lot we can do at the kernel level.  We could
dispatch the truncate to a workqueue and just make sure the file name
has disappeared from the file system name space before the unlink() to
userspace, but then the disk space gets released after the unlink()
call returns, which can cause other problems.

						- Ted
