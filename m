From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] fallocate vs O_(D)SYNC
Date: Wed, 16 Nov 2011 08:42:34 -0500
Message-ID: <20111116134234.GA24258@infradead.org>
References: <20111116084256.GA22963@infradead.org>
 <1321436588.2713.5.camel@menhir>
 <20111116105413.GA2916@quack.suse.cz>
 <20111116124550.GA11650@infradead.org>
 <20111116133915.GD8195@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Steven Whitehouse <swhiteho@redhat.com>,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	mfasheh@suse.com, jlbec@evilplan.org, cluster-devel@redhat.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42560
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757225Ab1KPNmh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Nov 2011 08:42:37 -0500
Content-Disposition: inline
In-Reply-To: <20111116133915.GD8195@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 16, 2011 at 02:39:15PM +0100, Jan Kara wrote:
> > This would work fine with XFS and be equivalent to what it does for
> > O_DSYNC now.  But I'd rather see every filesystem do the right thing
> > and make sure the update actually is on disk when doing O_(D)SYNC
> > operations.
>   OK, I don't really have a strong opinion here. Are you afraid that just
> calling fsync() need not be enough to push all updates fallocate did to
> disk?

No, the point is that you should not have to call fsync when doing
O_SYNC I/O.  That's the whole point of it.

