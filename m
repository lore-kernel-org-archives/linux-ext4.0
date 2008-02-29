From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 29 Feb 2008 10:05:27 -0800
Message-ID: <20080229180527.GD2997@webber.adilger.int>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204240440.3609.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39039 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbYB2SFn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Feb 2008 13:05:43 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1TI5gX4006715
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 10:05:42 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX000G01HGACQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 29 Feb 2008 10:05:42 -0800 (PST)
In-reply-to: <1204240440.3609.26.camel@localhost.localdomain>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 28, 2008  15:14 -0800, Mingming Cao wrote:
> On Thu, 2008-02-28 at 23:35 +0530, Aneesh Kumar K.V wrote:
> A write to prealloc area cause the split of unititalized extent into
> a initialized and uninitialized extent. If we don't have space to
> add new extent information instead of returning error convert the
> existing uninitialized extent to initialized one. We need to zero out
> the blocks corresponding to the extent to prevent wrong data reaching
> userspace.

> > +/* FIXME!! we need to try to merge to left or right after zerout  */
> > +static int ext4_ext_zeroout(handle_t *handle, struct inode *inode,
> > +				ext4_lblk_t iblock, struct ext4_extent *ex)
> > +{
> > +}
> > +
> 
> The complexity added to the code to handle the corner case seems not
> worth the effort. 
> 
> One simple solution is submit bio directly to zero out the blocks on
> disk, and wait for that to finish before clear the uninitialized bit. On
> a 4K block size case, the max size of an uninitialized extents is 128MB,
> and since the blocks are all contigous on disk, a single IO could done
> the job, the latency should not be a too big issue. After all when a
> filesystem is full, it's already performs slowly.

Further to Mingming's comments:
- you can map the ZERO_PAGE to every entry in the bio, which will avoid
  the very significant problem of needing 128MB of pages to zero out the
  extent
- make sure you limit the extent size to BIO_MAX_PAGES
- submitting large bios to the block layer is MUCH more efficient than
  adding pages to the page cache because the block device can do a very
  good job of writing this out
- make sure you wait for bio completion before you allow the block IO
  to begin.  In Lustre we did this by passing a waitq and our own
  completion function to the bio and have the caller go to sleep until
  the bio completion function is called.  Note that the completion
  function may be called multiple times if there are block errors.
- zeroing out pages in the page cache is very dangerous because they
  may already have dirty data in them.
- please make a helper function like "ext4_zero_blocks()" because at
  some point in the future I'd like to add the ability to have the kernel
  zero out inode table blocks for filesystems formatted with
  "-O uninit_groups,lazy_bg"

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

