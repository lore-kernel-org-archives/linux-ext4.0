From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 26 Apr 2010 18:55:28 +0200
Message-ID: <20100426165527.GB21179@atrey.karlin.mff.cuni.cz>
References: <1271674527-2977-2-git-send-email-lczerner@redhat.com> <1271674527-2977-3-git-send-email-lczerner@redhat.com> <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com> <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com> <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com> <4BCF4C53.3010608@redhat.com> <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com> <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com> <alpine.LFD.2.00.1004230944070.2814@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51803 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834Ab0DZQz3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Apr 2010 12:55:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004230944070.2814@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Wed, 21 Apr 2010, Greg Freemyer wrote:
> And also, currently I am rewriting the patch do use rbtree instead of the
> bitmap, because there were some concerns of memory consumption. It is a
> question whether or not the rbtree will be more memory friendly.
> Generally I think that in most "normal" cases it will, but there are some
> extreme scenarios, where the rbtree will be much worse. Any comment on
> this ?
  I see two possible improvements here:
a) At a cost of some code complexity, you can bound the worst case by combining
RB-trees with bitmaps. The basic idea is that when space to TRIM gets too
fragmented (memory to keep to-TRIM blocks in RB-tree for a given group exceeds
the memory needed to keep it in a bitmap), you convert RB-tree for a
problematic group to a bitmap and attach it to an appropriate RB-node. If you
track with a bitmap also a number of to-TRIM extents in the bitmap, you can
also decide whether it's benefitial to switch back to an RB-tree.

b) Another idea might be: When to-TRIM space is fragmented (again, let's say
in some block group), there's not much point in sending tiny trim commands
anyway (at least that's what I've understood from this discussion). So you
might as well stop maintaining information which blocks we need to trim
for that group. When the situation gets better, you can always walk block
bitmap and issue trim commands. You might even trigger this rescan from
kernel - if you'd maintain number of free block extents for each block group
(which is rather easy), you could trigger the bitmap rescan and trim as soon
as ratio number of free blocks / number of extents gets above a reasonable
threshold.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
