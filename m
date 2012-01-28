From: WIMPy <WIMPy@yeti.dk>
Subject: Re: [dm-devel] can't recover ext4 on lvm from =?utf-8?b?ZXh0NF9tYl9nZW5lcmF0ZV9idWRkeTo3Mzk6?= group 1687, 32254 clusters in bitmap, 32258 in gd
Date: Sat, 28 Jan 2012 15:31:59 +0000 (UTC)
Message-ID: <loom.20120128T162211-867@post.gmane.org>
References: <217150909.20120105113759@eikelenboom.it> <197607646.20120105142107@eikelenboom.it> <6FC155DD-80C1-4088-B745-6B74D9D5AA48@mit.edu> <4910694144.20120105171428@eikelenboom.it> <20120105181535.GB26382@thunk.org> <Pine.LNX.4.64.1201061133140.6954@hs20-bc2-1.build.redhat.com> <loom.20120128T050950-718@post.gmane.org> <loom.20120128T090712-530@post.gmane.org> <EBC820CD-E86F-48BB-ADA3-38B5C8A75187@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58466 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965Ab2A1Rcw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 28 Jan 2012 12:32:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1RrBqw-0000KC-Dn
	for linux-ext4@vger.kernel.org; Sat, 28 Jan 2012 18:14:14 +0100
Received: from e183095026.adsl.alicedsl.de ([85.183.95.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 18:14:14 +0100
Received: from WIMPy by e183095026.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Sat, 28 Jan 2012 18:14:14 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger <adilger <at> dilger.ca> writes:

> 
> Could you please try to bisect the problem, if it is reproducible?

If you or someone else has an idea, how to do so, I will try to collect more 
information.

There is actually an important bit I forgot to mention in the last message: 
After I got the error and umount the FS I get lots of journal commit I/O 
errors. But no indication as to what or why it fails.

> I was looking for a change which I thought might be responsible (removal of 
block bitmap initialization
> when inodes are first allocated from an uninitialized inode table) but I 
couldn't see it in the git log, so
> maybe that change has not landed yet.
> 
> I don't have any other ideas of which recent patches might be responsible at 
this point. 

As there was a mention at the beginning that this may have happened after an 
upgrade from 3.1.5 to 3.2, I will build a 3.1.5 and see if that really makes a 
difference.

> On 2012-01-28, at 1:14, WIMPy <WIMPy <at> yeti.dk> wrote:
> 
> > Update:
> > 
> >>>>> this is a problem which apparently occurred when the user went from
> >>>> v3.1.5 to v3.2, so this looks likes 3.2 regression.)
> >> 
> >> I am on 3.2.0 as well.
> > 
> > I didn't spot anything obvious in the logs.
> > 
> >> It happened for me on a freshly created FS.
> >> "mke2fs -j -O sparse_super -O dir_index -O extents -O filetype -O uninit_
bg"
> >> mounted with no additional options for the first time I got an
> >> "EXT4-fs error (device md127): ext4_mb_generate_buddy:739: group 28671, 
32765 
> >> clusters in bitmap, 32766 in gd"
> >> after writing about 3TB of data.
> >> I do not have RO snapshots as the OP, but my md sits on to of luks 
> > containers. 
> >> So we do have the device mapper in common.
> > 
> > After I did an fsck and tried to continue, I didn't get that far.
> > After another 200GB or so it happened again.
> > And now it's reproducible:
> > I can run fsck and then try to continue (using rsync). But as soon as 
writing 
> > starts, the process hangs for a long time. At least one minute, probably 
longer.
> > Then the ext4_mb_generate_buddy comes again.
> > 
> > I upgraded e2fstools from 1.41.14 to 1.42 and the kernel to 3.2.2.
> > No difference.
> > That FS is unusable.
> > 
> >> Just for the records: Unlike the contents, the hardware is not new and did 
> > not 
> >> have any known issues.
> >> 
> >>  Greetings,
> >>    WIMPy


