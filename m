From: Theodore Tso <tytso@mit.edu>
Subject: Re: The e2fsprogs nlinks-dir patch
Date: Thu, 13 Mar 2008 16:17:48 -0400
Message-ID: <20080313201747.GB28728@mit.edu>
References: <E1JZr6d-0004yL-1m@closure.thunk.org> <20080313190127.GG3217@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:58933 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754108AbYCMUSF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 16:18:05 -0400
Content-Disposition: inline
In-Reply-To: <20080313190127.GG3217@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 13, 2008 at 12:01:27PM -0700, Andreas Dilger wrote:
> > So if it is the actual and on-disk count is different, but the inode in
> > question is an inode and the on-disk count is 1, but the actual count is
>                  ^^^^^ directory?

Yes, directory.  Sorry for the typo....

> > The number 65538 will get masked down to 2.  Hilarity then ensues.
> 
> Can you expand?  I tested the kernel and a link count of 2 will still
> result in the "ext3_is_empty()" function being called prior to doing
> the unlink and it will be refused.  If a subdirectory is removed at
> that point nlink will go down to 1 again and all is well?

Hmm, you're right.  It's still results in an incorrect value, but it
shouldn't totally blow us out of the water if we attempt an rmdir.
The one problem I can think of is that find and some other directory
iterators had some optimizations which depended on st_nlink being
correct.  They've been patched so that the optimizatoins are turned
off if st_nlink is 1 for directories.  But if st_nlink is both
incorrect and > 1, it could cause them to terminate their search too
soon.

						- Ted
