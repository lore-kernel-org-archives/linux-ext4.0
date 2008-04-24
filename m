From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Thu, 24 Apr 2008 08:46:44 -0400
Message-ID: <20080424124644.GC25173@unused.rdu.redhat.com>
References: <20080423193914.GA25173@unused.rdu.redhat.com> <20080423232725.GK3095@webber.adilger.int> <20080424025803.GM3095@webber.adilger.int> <20080424123600.GB25173@unused.rdu.redhat.com> <4810827C.2020706@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759602AbYDXM50 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Apr 2008 08:57:26 -0400
Content-Disposition: inline
In-Reply-To: <4810827C.2020706@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 24, 2008 at 07:52:12AM -0500, Eric Sandeen wrote:
> Josef Bacik wrote:
> > On Wed, Apr 23, 2008 at 08:58:03PM -0600, Andreas Dilger wrote:
> >> On Apr 23, 2008  15:39 -0400, Josef Bacik wrote:
> >>> Here is my reworked fiemap patch for ext3.  The generic fiemap handler
> >>> takes the get_block_t from the filesystem and does the fiemap that way,
> >>> so then adding ext2 support should be a snap, as well as any other fs
> >>> that wants to use this.
> >> Ah, one other point is that this should also be used by ext4 to map inodes
> >> that are not in extents format, replacing the -EOPNOTSUPP return in that
> >> case.
> >>
> > 
> > Sounds good, but I'm wondering if we should add a flag to the FIEMAP stuff to
> > specify wether the inode you are mapping does truly have extents or if its just
> > more of a block map.  Do you think something like that would be usefull?  Thank
> > you,
> > 
> > Josef 
> 
> I don't see that in itself as useful; you care about file layout, but
> why would you care about the filesystem's mechanism for tracking that
> layout?
>

idk, just thought it may be usefull in the case of ext4 where you potentially
have both formats.  Mostly thinking out loud while we can still change things.
Thanks,

Josef 
