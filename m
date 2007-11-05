From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Mon, 5 Nov 2007 08:53:52 -0600
Message-ID: <20071105085352.36405a00@gara>
References: <20070814043245.32206.34785.stgit@gara>
	<20070814043303.32206.10239.stgit@gara>
	<20071103233609.GA30710@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37672 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbXKEOvN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 09:51:13 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5EpAZg002602
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 09:51:10 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5Ep89h440260
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 09:51:08 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5Ep7Or004506
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 09:51:07 -0500
In-Reply-To: <20071103233609.GA30710@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 3 Nov 2007 19:36:09 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Aug 13, 2007 at 11:33:03PM -0500, Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> > Relax group descriptor checking.
> 
> This patch should really be before patch #2 in the series (add the
> ability to handle the new feature before adding the ability to add in
> mke2fs).  (Actually, I would have split up #2 into one patch which
> added the libe2p handling for the feature, then added the change to
> e2fsck, and then added the mke2fs changes, but that's just me
> quibbling.)

Sound reasonable.  I'll take care of patch ordering better next time.

> > @@ -578,8 +580,16 @@ void check_super_block(e2fsck_t ctx)
> >  	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
> >  		pctx.group = i;
> >  
> > -		first_block = ext2fs_group_first_block(fs, i);
> > -		last_block = ext2fs_group_last_block(fs, i);
> > +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> > +					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> > +			meta_bg_size = (fs->blocksize / sizeof (struct ext2_group_desc));
> > +			start_group = (i / meta_bg_size) * meta_bg_size;
> > +			first_block = ext2fs_group_first_block(fs, start_group);
> > +			last_block = ext2fs_group_first_block(fs, start_group + meta_bg_size);
> 
> This patch requires that the metadata be in located in the metablock
> group descriptor, instead of anywhere in the filesystem, which is what
> we ultimately ended up checking into the kernel.  Being more flexible
> is good (even if that's not the layout we use by default).  I'll fix
> this up using git rebase --interactive and republish the patch in the
> next branch.

Yes, the patch is slightly off and I did send an email pointing to
exactly this, but you had already committed the patch by the time the
email was sent.  This patch was submitted to the mailing list before
the final kernel changes made it into the queue.

> 						- Ted

-JRS
