From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs and blocks outside i_size
Date: Mon, 21 Jul 2008 17:32:38 -0600
Message-ID: <20080721233238.GF15203@webber.adilger.int>
References: <20080718121130.GB23898@skywalker> <20080718123706.GE11221@mit.edu>
 <20080721050825.GE3370@webber.adilger.int> <20080721055918.GA8788@skywalker>
 <20080721123400.GA28839@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55156 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYGUXcm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 19:32:42 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6LNWeBi007675
	for <linux-ext4@vger.kernel.org>; Mon, 21 Jul 2008 16:32:41 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4D00601QJS1W00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 21 Jul 2008 16:32:40 -0700 (PDT)
In-reply-to: <20080721123400.GA28839@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 21, 2008  08:34 -0400, Theodore Ts'o wrote:
> Wel, as I said originally, we have four choices, only two of which are
> tenable:
> 
> 1) Don't change i_size and leave e2fsck confused about whether i_size
> is confused or not; the next time e2fsck runs it can either fix it and
> change i_size, confusing applications that depend on i_size, or not
> fix it and in the case of a corrupted i_size, leave valid data
> inaccessible or do the hack to which Andreas reacted, "Yuck", and
> which Annesh quoted and I assume agree.  (i.e., checking the data
> blocks to see if they are non-zero, and electing to to risk confusing
> the application in the case where they are non-zero).  This is the
> current case.
> 
> 2) Change i_size and always confuse applications that depend on i_size
> carrying some semantic meaning.
> 
> 3) Don't aggressively zero-out (as it presents us with these two
> untenable options) and try to explit the extent instead.  If the block
> application fails, return ENOSPC.
> 
> 4) #3, except if the block allocation fails, try to steal a block that
> had been previously preallocated for some other logical block in that
> inode.

5) Add a flag to the inode which means "blocks beyond i_size" if fallocate()
   is called with "KEEP_SIZE" and allocation is actually beyond i_size
   and not just filling a hole) so that e2fsck won't "fix" the size,
   but allows the extent to be uninitialized.  The flag is cleared
   (by kernel and/or e2fsck) if the size is extended to the last block.

To avoid consuming our precious inode flags, we might consider to re-use
the EXT3_DIRSYNC_FL or EXT3_TOPDIR_FL for this purpose, since the are
definitely only having meaning for directories.  I guess the question
is whether we would need this for directories, but I don't think so as
we could always just add empty directory blocks (at the expense of
having to scan them later).

> The one other thing I would note is that at least for non-root users,
> the reserved blocks will help save us most of the time, except for
> when users explicitly set the reserved blocks down to zero.

Would the index block be allocated from the reserved space tough?
This is also a good idea, but I'm not sure if that is what happens.
I guess the "allocate index block" code path needs to check for
"(uid == s_reserved_uid || is_metadata)"?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

