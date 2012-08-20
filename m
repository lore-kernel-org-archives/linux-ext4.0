From: Hugh Dickins <hughd@google.com>
Subject: Re: Add invalidatepage_range address space operation
Date: Sun, 19 Aug 2012 21:43:55 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1208192120420.2390@eggly.anvils>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com> <20120819005727.GA15763@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mmc@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2HTEoi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Aug 2012 00:44:38 -0400
Received: by pbbrr13 with SMTP id rr13so6394764pbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 19 Aug 2012 21:44:37 -0700 (PDT)
In-Reply-To: <20120819005727.GA15763@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

(I wonder if linux-mmc@vger.kernel.org was supposed to be
linux-mm@kvack.org?  Our apologies to linux-mmc if so.)

On Sat, 18 Aug 2012, Theodore Ts'o wrote:
> On Fri, Jul 27, 2012 at 10:00:59AM +0200, Lukas Czerner wrote:
> > This set of patches are aimed to allow truncate_inode_pages_range() handle
> > ranges which are not aligned at the end of the page. Currently it will
> > hit BUG_ON() when the end of the range is not aligned. Punch hole feature
> > however can benefit from this ability saving file systems some work not
> > forcing them to implement their own invalidate code to handle unaligned
> > ranges.
> > 
> > In order for this to work we need however new address space operation
> > invalidatepage_range which should be able to handle page invalidation with
> > offset and length specified.
> > 
> > patch 01:	Implements the new invalidatepage_range address space
> > 		operation in the mm layer
> > patch 02 - 05:	Wire the new invalidatepage_range aop to the ext4, xfs and
> > 		ocfs2 file system (which are currently the only file
> > 		systems supporting punch hole) and implement this
> > 		functionality for jbd2 as well.

(tmpfs also supports punch hole, but has its own truncation routine,
and does not need to get involved in these changes.)

> > patch 06:	Change truncate_inode_pages_range() to handle unaligned
> > 		ranges.
> > patch 07 - 15:	Ext4 specific changes which take benefit from the
> > 		previous truncate_inode_pages_range() change. Not all
> > 		are realated specifically to this change, but all are
> > 		related to the punch hole feature.
> 
> What's the current status of this patch series?
> 
> I haven't seen much if any comment from the mm folks and the xfs/ocfs2
> folks.  I've incorporated the patches into the unstable portion of the
> ext4 tree so I can do some testing (some minor changes to the ext4
> patches were needed to rebase the patch series to the 3.6-rc1-based
> ext4 dev tree, but nothing major).  However, I don't want to include
> this into the ext4 tree for merging into linux-next unless we get
> general agreement from the maintainers of the other trees that are
> affected by this patch series.

Thanks for the reminder.  I'm happy with the general direction, if not
some of the details; though I see it as more of a vfs than an mm thing.

I'll comment briefly now on patch 06 (which is fine) and patch 01 (which
is not) and patch 07 (which is outside my scope, but worth a remark on).

I won't attempt to judge whether the ext4 and ocfs2 and xfs parts
are correct; but from the look of it, 02 03 04 05 are wrong like 01
(or you can say it's 06 which is wrong, though it looks good to me).

Hugh
