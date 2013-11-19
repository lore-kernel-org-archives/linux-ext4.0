From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] ext4: add generic uevent infrastructure
Date: Tue, 19 Nov 2013 13:35:36 +0400
Message-ID: <87ob5gohsn.fsf@openvz.org>
References: <1384785520-607-1-git-send-email-dmonakhov@openvz.org> <20131118162045.GA3268@infradead.org> <20131119013621.GH11434@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57397 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KSJfl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Nov 2013 04:35:41 -0500
In-Reply-To: <20131119013621.GH11434@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 19 Nov 2013 12:36:21 +1100, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 18, 2013 at 08:20:45AM -0800, Christoph Hellwig wrote:
> > On Mon, Nov 18, 2013 at 06:38:40PM +0400, Dmitry Monakhov wrote:
> > > *Purpose:
> > > It is reasonable to annaunce fs related events via uevent infrastructure.
> > > This patch implement only ext4'th part, but IMHO this should be usefull for
> > > any generic filesystem.
> > 
> > It does indeed look very generic.  How about you try to redo it to sit
> > at the VFS level?
> 
> I certain agree with that. I'd also like to see ENOSPC notifications
> as that would obliviate the need for distros like RHEL to ship
> systemtap scripts to generate such notifications for admins....
Good point. This may be classified as NON_FATAL_ERROR. Will add this to
next version. But this event type may require some-sort of rate limiting.
> 
> > Also Jan Kara has done quota netlink notifications a while ago, which
> > fit into the same sort of niche.
> 
> The question I'm asking is whether we really want a new interface
> for these events? Shouldn't we really try to use an existing
> filesystem event interface for generating these events (e.g.
> fanotify) rather than adding yet another disjoint filesystem event
> interface to the kernel?
ASAIU fanotify is file-oriented event interface API aimed for antivirus
and index applications. fanotify_event_set = {ACCESS_XXX,OPEN,MODIFY, CLOSE_XXX}
But I want to emmit fs-oriented events (where SB is the object)
fs_event_set = {MOUNT,UMOUNT,FREEZE,UNFREEZE,ERROR,ENOSPC}.
IMHO fs_event_set is closer to {dm,device}_events_set than
fanotify_event_set, that is why I use idea of uevent for devices.
And new fs-events look as intuitive extension of existing dev-event API.
Are you agree?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
