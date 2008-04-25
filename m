From: Andreas Dilger <adilger@sun.com>
Subject: Re: [E2FSPROGS, RFC] mke2fs: New bitmap and inode table allocation	for
 FLEX_BG
Date: Fri, 25 Apr 2008 14:10:26 -0600
Message-ID: <20080425201026.GB3444@webber.adilger.int>
References: <1208868379-17580-1-git-send-email-tytso@mit.edu>
 <1208868379-17580-2-git-send-email-tytso@mit.edu>
 <1208868379-17580-3-git-send-email-tytso@mit.edu>
 <20080423203955.GH2775@webber.adilger.int> <20080423160518.5c7fad2e@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Valerie Clement <valerie.clement@bull.net>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41784 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763107AbYDYUOk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 16:14:40 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3PKEdDv023541
	for <linux-ext4@vger.kernel.org>; Fri, 25 Apr 2008 13:14:39 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZW00J01DAZ5P00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Fri, 25 Apr 2008 13:14:39 -0700 (PDT)
In-reply-to: <20080423160518.5c7fad2e@gara>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2008  16:05 -0500, Jose R. Santos wrote:
> On Wed, 23 Apr 2008 14:39:55 -0600
> Andreas Dilger <adilger@sun.com> wrote:
> > It makes total sense to me that the BG_BLOCK_UNINIT flag would not be set
> > on a group that does not have the default bitmap layouts, so I agree with
> > this change.  I might suggest that we add a new flag BG_BLOCK_EMPTY or
> > similar (which is really part of the FLEXBG feature so it doesn't affect
> > the existing uninit_groups code) that indicates that the block bitmap
> > contains NO allocated blocks, so that the kernel can know immediately
> > when reconstructing the bitmap that there are no bitmaps or itable in
> > that group (i.e. the bitmap is all zero).
> 
> I originally had a similar idea but was vetoed because there was no
> kernel user on the flag.  The flag that I used was set if the block
> group had meta-data as opposed to just being empty since there are still
> block groups out there that can have no meta-data but still have bgd or
> backup super blocks.  Would BG_BLOCK_EMPTY mean no bitmaps/inode tables
> or does it imply completely empty block group?

It could mean either...  What is important is if that is useful it should
be done before FLEXBG goes into the field.

The kernel can already determine somewhat efficiently whether a group
has sb or gdt backups, though it can't hurt to flag this also.  What
seems to be quite difficult is to know in the presence of FLEXBG whether
a group has an itable or bitmap in it.

I'd HOPE (and I believe this is what Ted's recent patch did) is that any
group which is being used to store flexbg data will have an initialized
block bitmap in it, because it is "non-standard".

What is more tricky is if a group has BLOCK_UNINIT and/or INODE_UNINIT
set what should happen when that group's block bitmap is initialized.
Should it assume there is a block + inode bitmap and an itable, or is
it enough to check its own group descriptor to determine if the bitmap
and itable are not in the group itself.

Maybe I'm being paranoid, and we don't need the flag(s), but better to
think the issues through now and decide we don't need them, than to
decide later that we do.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

