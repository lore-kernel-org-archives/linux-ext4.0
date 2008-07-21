From: Andreas Dilger <adilger@sun.com>
Subject: Re: e2fsprogs and blocks outside i_size
Date: Sun, 20 Jul 2008 23:08:25 -0600
Message-ID: <20080721050825.GE3370@webber.adilger.int>
References: <20080718121130.GB23898@skywalker> <20080718123706.GE11221@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57768 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbYGUFI2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jul 2008 01:08:28 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6L58R4Q025980
	for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 22:08:27 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4C00M01BJM6S00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sun, 20 Jul 2008 22:08:27 -0700 (PDT)
In-reply-to: <20080718123706.GE11221@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 18, 2008  08:37 -0400, Theodore Ts'o wrote:
> On Fri, Jul 18, 2008 at 05:41:30PM +0530, Aneesh Kumar K.V wrote:
> > With fallocate FALLOC_FL_KEEP_SIZE option, when we write to prealloc
> > space and if we hit ENOSPC when trying to insert the extent,
> > we actually zero out the extent. That means we can have blocks
> > outside i_size for an inode.

To clarify, doesn't FALLOC_FL_KEEP_SIZE put the extent beyond i_size,
regardless of whether the ENOSPC problem is hit?

> > I guess e2fsck currently doesn't handle this. Or should we fix kernel
> > to update i_size to the right value if we do a zero out of the extent ?
> > 
> > With fallocate if the prealloc area is small we also aggressively zeroout.
> > This was needed so that a random write pattern on falloc area doesn't
> > results in too many extents.  That also can result in the above
> > error on fsck.
> 
> It would seem to me that e2fsck should be fixed to not complain about
> blocks outside of i_size, *if* the blocks in question are marked as
> being unitialized.

Yes, I think that is the right approach.

> It also seems to me that updating i_size when the
> extent is zero'ed out is also not the right thing to do.  Some
> applications depend on i_size.

Yes, this was my thought exactly.  Just because the fallocated extent
is zeroed out doesn't mean the file size can suddenly change.  This
would appear as file corruption or "data loss" to many applications.

> In the case where you hit ENOSPC when you need to grow the tree to
> insert an extent, that's a tough one.  One approach would be to simply

I think you misunderstand Aneesh's comments - the ext4 fallocate code
already handles all of these cases.  If ENOSPC is hit during the
extent split the error recovery will zero out the whole uninitialized
extent.  Slow, but effective.

> For your second case, where we aggressively zero out blocks, one of
> the reasons why we have to do that is because the kernel isn't
> coalescing extents aggressively.  My inclination here is to *not*
> aggressively zero out blocks outside outside of i_size, and to split
> the extent in that case

That is only partly true.  If an application is writing every other
block in a 64MB fallocated extent we don't want to create 64MB/4kB
separate extents.  There is no guarantee that the application will
fill in the rest of the unwritten extents and allow them to merge.

Also, there is likely a net performance improvement by writing every
block (half with data, the other half with zeroes) compared to doing
write + seek over the entire file.

> I suppose the other hack we could do is have e2fsck check the blocks
> that are outside of i_size, and if they are all zero and extents are
> involved, that it's a case of pre-allocated blocks that needed to be
> zero'ed for some reason, as opposed to a corrupted i_size.  That seems
> to be a really gross hack, though.

Yuck, with the added problem that there is no guarantee that these
data blocks ARE all zero.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

