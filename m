From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [dm-devel] do not disable ext4 discards on first discard failure?
 [was: Re: dm snapshot: ignore discards issued to the snapshot-origin
 target]
Date: Wed, 4 May 2011 19:02:06 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105041858010.27793@dhcp-27-109.brq.redhat.com>
References: <20110413224025.GA18589@redhat.com> <20110413234854.GA19793@redhat.com> <20110426173213.GA19604@redhat.com> <20110428001912.GA14659@redhat.com> <20110428075355.GA2190@infradead.org> <20110428205935.GA24979@redhat.com>
 <alpine.LFD.2.00.1104291117510.5496@dhcp-27-109.brq.redhat.com> <20110429122454.GL32370@agk-dp.fab.redhat.com> <20110429122906.GA7381@infradead.org> <4DBACB23.80607@redhat.com> <20110504163317.GA17529@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Lukas Czerner <lczerner@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
	DarkNovaNick@gmail.com, linux-lvm@redhat.com,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1EDRCW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 May 2011 13:02:22 -0400
In-Reply-To: <20110504163317.GA17529@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 4 May 2011, Ted Ts'o wrote:

> On Fri, Apr 29, 2011 at 09:28:51AM -0500, Eric Sandeen wrote:
> > On 4/29/11 7:29 AM, Christoph Hellwig wrote:
> > > FYI, that disable discard on failure seems to be an ext4 special and no
> > > one else picked up that stupid idea.  If ext4 wants to misbehave for
> > > that just let them..
> > 
> > It was my "stupid idea," and I'm ok with reverting it ;)
> 
> I think I forgot to send the patch out, but it's been reverted in the
> ext4 master branch, commit id: d9f34504e695.  It's more than a revert,
> actually, since I also dropped error checking for FITRIM.  Otherwise
> an attempt to use FITRIM would stop after hitting the first dm region
> that didn't support discards.
> 
> 						- Ted
> 

However I would very much like to change blkdev_issue_discard() not NOT
return EOPNOTSUPP if QUEUE_FLAG_DISCARD is set, this way we can rely on
EOPNOTSUPP saying really that it is NOT supported. Regardless on ext4
change.

I will send a patch for it, if you guy agree. Also consider BLKDISCARD
which is now broken and this change will fix that!

Thanks!
-Lukas
