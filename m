From: Andreas Dilger <adilger@sun.com>
Subject: Re: FIEMAP patches
Date: Tue, 26 Aug 2008 00:57:03 -0600
Message-ID: <20080826065703.GD3392@webber.adilger.int>
References: <20080825202250.GY3392@webber.adilger.int>
 <20080826062241.GL4563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <esandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Mark Fasheh <mfasheh@suse.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63601 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYHZG5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Aug 2008 02:57:10 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m7Q6v5Gg008389
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 23:57:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K67003014JL9A00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Mon, 25 Aug 2008 23:57:05 -0700 (PDT)
In-reply-to: <20080826062241.GL4563@wotan.suse.de>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 25, 2008  23:22 -0700, Mark Fasheh wrote:
> On Mon, Aug 25, 2008 at 02:22:50PM -0600, Andreas Dilger wrote:
> > I read through the entire previous FIEMAP thread (phew!) and it boils
> > down mostly to:
> > 
> > s/FIEMAP_FLAG_NO_DIRECT/FIEMAP_FLAG_NO_BYPASS/
> 
> Yeah, there's a few like that. I'll have to go back through the thread.

There are many proposed changes, but to be honest I don't agree with
many of them.  It was just an exercise in "I think my naming of these
flags will be better than yours" without much substance in the end.
I got a few private emails from different parties (e.g. Dave Chinner)
that just want to get this finished, and the most vocal complainer(s)
are not necessarily the ones that need listening to.

> > > * FIEMAP_EXTENT_UNWRITTEN
> > > Unwritten extent - the extent is allocated but it's data has not been
> > > initialized.  This indicates the extent's data will be all zero.
> > This should say "will be all zero if read through the filesystem
> > but the contents are undefined if read directly from the device."
> > 
> > There was also an update to the ext4 patch from Kalpak for handling
> > EA-in-inode at the same time as an external inode.
> > 
> > Eric, Mark,
> > could one of you please just submit the patches to Andrew for inclusion.
> > I think there was plenty of debate already, with very little significant
> > benefit except suggesting different names for some of the flags.
> 
> Agreed. I'll go ahead and spin another set of patches this week.

Thanks.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

