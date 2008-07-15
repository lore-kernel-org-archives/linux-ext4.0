From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 16:20:03 -0500
Message-ID: <20080715162003.061c745a@ichigo>
References: <87bq10w8gv.fsf@frosties.localdomain>
	<20080715132734.68c64000@ichigo>
	<20080715195116.GL6239@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57258 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYGOVUV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 17:20:21 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FLKJoF018359
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:20:19 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FLKCg3231288
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:20:12 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FLKBVh007775
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 17:20:12 -0400
In-Reply-To: <20080715195116.GL6239@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 15 Jul 2008 14:12:19 -0600
Andreas Dilger <adilger@sun.com> wrote:

> On Jul 15, 2008  13:27 -0500, Jose R. Santos wrote:
> > On Mon, 14 Jul 2008 21:50:56 +0200
> > Goswin von Brederlow <goswin-v-b@web.de> wrote:
> > > we are using lustre on a cluster of servers and raid boxes. Currently
> > > lustre is based on the ext3 code and has a limit of 8TiB for each
> > > filesystem. For us that results on having to split a servers storage
> > > into up to 4 chunks and run one fs on each which I would rather avoid.
> > > The solution for this would be to rebase the lustre patches to use
> > > ext4 instead, which should also reduce the patch set considerably.
> > > Lustre already patches a lot of ext4 features into the ext3 base.
> > > 
> > > 
> > > But before I start rebasing lustre I though I would first test out
> > > plain ext4 so I know any bugs I find will be from my rebasing and not
> > > already existing in ext4 itself. And there I run into a big problem:
> > > Current e2fsprogs (1.41) seem to be totaly unable to handle the ext4 64BIT
> > > feature, i.e. filesystems larger than 16TiB. The mkfs.ext4 always
> > > stops saying the disk exceeds the 32bit block count. And looking at
> > > the code I see a lot of blk_t (instead of blk64_t) and unsigned long
> > > (instead of unsigned long long [or even better blk64_t]) usage.
> > > 
> > > I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
> > > mkfs. Does anyone know if there is an updated patch set for 1.41
> > > anywhere? And when will that be added to e2fsprogs upstream?
> > 
> > I've recently submitted a set of patches that covers most of the API
> > changes needed to support >16TB file systems (missing Ted bitmap
> > support of course).  Once the bitmap support is included, it _SHOULD_
> > be relatively painless to add mke2fs support with this series of patches.
> 
> Jose,
> while waiting for the "efficient bitmap" support, how hard would it be
> to implement "inefficient bitmaps" that just malloc some GB of memory
> if needed?  This would at least allow people with huge devices to test
> mke2fs/ext4/e2fsck in the meantime.

As Ted mentioned already, the "efficient bitmap" support can come
latter but the 64bit API call need to well design to able to support
different models.  I will see how difficult it would be to create a ABI
BREAKING patch for testing purposes but coming up with a ABI
compatible one seems like to much work if its going to be replace
sometime in the near future.

It should be possible to test it with flexbg as well (I think) since
all I need to make sure is that all bitmaps reside within the 32bit
block boundary.  Dont have large disk to test on so Im playing with
device mapper to see how I can fake one.  Our lab network is making
thing difficult though.

Im sure that I will uncover a couple of bug this way.  Like the fact
that I forgot to set the 64bit compatibility flag or large group
descriptors. :)

> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
> 

-JRS
