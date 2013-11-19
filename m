From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: add generic uevent infrastructure
Date: Tue, 19 Nov 2013 12:36:21 +1100
Message-ID: <20131119013621.GH11434@dastard>
References: <1384785520-607-1-git-send-email-dmonakhov@openvz.org>
 <20131118162045.GA3268@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59518 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab3KSBgq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Nov 2013 20:36:46 -0500
Content-Disposition: inline
In-Reply-To: <20131118162045.GA3268@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 18, 2013 at 08:20:45AM -0800, Christoph Hellwig wrote:
> On Mon, Nov 18, 2013 at 06:38:40PM +0400, Dmitry Monakhov wrote:
> > *Purpose:
> > It is reasonable to annaunce fs related events via uevent infrastructure.
> > This patch implement only ext4'th part, but IMHO this should be usefull for
> > any generic filesystem.
> 
> It does indeed look very generic.  How about you try to redo it to sit
> at the VFS level?

I certain agree with that. I'd also like to see ENOSPC notifications
as that would obliviate the need for distros like RHEL to ship
systemtap scripts to generate such notifications for admins....

> Also Jan Kara has done quota netlink notifications a while ago, which
> fit into the same sort of niche.

The question I'm asking is whether we really want a new interface
for these events? Shouldn't we really try to use an existing
filesystem event interface for generating these events (e.g.
fanotify) rather than adding yet another disjoint filesystem event
interface to the kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
